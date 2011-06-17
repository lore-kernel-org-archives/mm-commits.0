From: akpm@linux-foundation.org
Subject: + mm-let-swap-use-exceptional-entries.patch added to -mm tree
Date: Fri, 17 Jun 2011 16:39:44 -0700
Message-ID: <201106172339.p5HNdiU2008242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759576Ab1FQXju (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 19:39:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, riel@redhat.com


The patch titled
     mm: let swap use exceptional entries
has been added to the -mm tree.  Its filename is
     mm-let-swap-use-exceptional-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: let swap use exceptional entries
From: Hugh Dickins <hughd@google.com>

If swap entries are to be stored along with struct page pointers in a
radix tree, they need to be distinguished as exceptional entries.

Most of the handling of swap entries in radix tree will be contained in
shmem.c, but a few functions in filemap.c's common code need to check for
their appearance: find_get_page(), find_lock_page(), find_get_pages() and
find_get_pages_contig().

So as not to slow their fast paths, tuck those checks inside the existing
checks for unlikely radix_tree_deref_slot(); except for find_lock_page(),
where it is an added test.  And make it a BUG in find_get_pages_tag(),
which is not applied to tmpfs files.

A part of the reason for eliminating shmem_readpage() earlier, was to
minimize the places where common code would need to allow for swap
entries.

The swp_entry_t known to swapfile.c must be massaged into a slightly
different form when stored in the radix tree, just as it gets massaged
into a pte_t when stored in page tables.

In an i386 kernel this limits its information (type and page offset) to 30
bits: given 32 "types" of swapfile and 4kB pagesize, that's a maximum
swapfile size of 128GB.  Which is less than the 512GB we previously
allowed with X86_PAE (where the swap entry can occupy the entire upper 32
bits of a pte_t), but not a new limitation on 32-bit without PAE; and
there's not a new limitation on 64-bit (where swap filesize is already
limited to 16TB by a 32-bit page offset).  Thirty areas of 128GB is
probably still enough swap for a 64GB 32-bit machine.

Provide swp_to_radix_entry() and radix_to_swp_entry() conversions, and
enforce filesize limit in read_swap_header(), just as for ptes.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |   23 +++++++++++++++++
 mm/filemap.c            |   49 ++++++++++++++++++++++++--------------
 mm/swapfile.c           |   20 +++++++++------
 3 files changed, 66 insertions(+), 26 deletions(-)

diff -puN include/linux/swapops.h~mm-let-swap-use-exceptional-entries include/linux/swapops.h
--- a/include/linux/swapops.h~mm-let-swap-use-exceptional-entries
+++ a/include/linux/swapops.h
@@ -1,3 +1,8 @@
+#ifndef _LINUX_SWAPOPS_H
+#define _LINUX_SWAPOPS_H
+
+#include <linux/radix-tree.h>
+
 /*
  * swapcache pages are stored in the swapper_space radix tree.  We want to
  * get good packing density in that tree, so the index should be dense in
@@ -76,6 +81,22 @@ static inline pte_t swp_entry_to_pte(swp
 	return __swp_entry_to_pte(arch_entry);
 }
 
+static inline swp_entry_t radix_to_swp_entry(void *arg)
+{
+	swp_entry_t entry;
+
+	entry.val = (unsigned long)arg >> RADIX_TREE_EXCEPTIONAL_SHIFT;
+	return entry;
+}
+
+static inline void *swp_to_radix_entry(swp_entry_t entry)
+{
+	unsigned long value;
+
+	value = entry.val << RADIX_TREE_EXCEPTIONAL_SHIFT;
+	return (void *)(value | RADIX_TREE_EXCEPTIONAL_ENTRY);
+}
+
 #ifdef CONFIG_MIGRATION
 static inline swp_entry_t make_migration_entry(struct page *page, int write)
 {
@@ -169,3 +190,5 @@ static inline int non_swap_entry(swp_ent
 	return 0;
 }
 #endif
+
+#endif /* _LINUX_SWAPOPS_H */
diff -puN mm/filemap.c~mm-let-swap-use-exceptional-entries mm/filemap.c
--- a/mm/filemap.c~mm-let-swap-use-exceptional-entries
+++ a/mm/filemap.c
@@ -717,9 +717,12 @@ repeat:
 		page = radix_tree_deref_slot(pagep);
 		if (unlikely(!page))
 			goto out;
-		if (radix_tree_deref_retry(page))
+		if (radix_tree_exception(page)) {
+			if (radix_tree_exceptional_entry(page))
+				goto out;
+			/* radix_tree_deref_retry(page) */
 			goto repeat;
-
+		}
 		if (!page_cache_get_speculative(page))
 			goto repeat;
 
@@ -756,7 +759,7 @@ struct page *find_lock_page(struct addre
 
 repeat:
 	page = find_get_page(mapping, offset);
-	if (page) {
+	if (page && !radix_tree_exception(page)) {
 		lock_page(page);
 		/* Has the page been truncated? */
 		if (unlikely(page->mapping != mapping)) {
@@ -852,11 +855,14 @@ repeat:
 		if (unlikely(!page))
 			continue;
 
-		/*
-		 * This can only trigger when the entry at index 0 moves out
-		 * of or back to the root: none yet gotten, safe to restart.
-		 */
-		if (radix_tree_deref_retry(page)) {
+		if (radix_tree_exception(page)) {
+			if (radix_tree_exceptional_entry(page))
+				continue;
+			/*
+			 * radix_tree_deref_retry(page):
+			 * can only trigger when entry at index 0 moves out of
+			 * or back to root: none yet gotten, safe to restart.
+			 */
 			WARN_ON(start | i);
 			goto restart;
 		}
@@ -915,12 +921,16 @@ repeat:
 		if (unlikely(!page))
 			continue;
 
-		/*
-		 * This can only trigger when the entry at index 0 moves out
-		 * of or back to the root: none yet gotten, safe to restart.
-		 */
-		if (radix_tree_deref_retry(page))
+		if (radix_tree_exception(page)) {
+			if (radix_tree_exceptional_entry(page))
+				break;
+			/*
+			 * radix_tree_deref_retry(page):
+			 * can only trigger when entry at index 0 moves out of
+			 * or back to root: none yet gotten, safe to restart.
+			 */
 			goto restart;
+		}
 
 		if (!page_cache_get_speculative(page))
 			goto repeat;
@@ -980,12 +990,15 @@ repeat:
 		if (unlikely(!page))
 			continue;
 
-		/*
-		 * This can only trigger when the entry at index 0 moves out
-		 * of or back to the root: none yet gotten, safe to restart.
-		 */
-		if (radix_tree_deref_retry(page))
+		if (radix_tree_exception(page)) {
+			BUG_ON(radix_tree_exceptional_entry(page));
+			/*
+			 * radix_tree_deref_retry(page):
+			 * can only trigger when entry at index 0 moves out of
+			 * or back to root: none yet gotten, safe to restart.
+			 */
 			goto restart;
+		}
 
 		if (!page_cache_get_speculative(page))
 			goto repeat;
diff -puN mm/swapfile.c~mm-let-swap-use-exceptional-entries mm/swapfile.c
--- a/mm/swapfile.c~mm-let-swap-use-exceptional-entries
+++ a/mm/swapfile.c
@@ -1960,20 +1960,24 @@ static unsigned long read_swap_header(st
 
 	/*
 	 * Find out how many pages are allowed for a single swap
-	 * device. There are two limiting factors: 1) the number of
-	 * bits for the swap offset in the swp_entry_t type and
-	 * 2) the number of bits in the a swap pte as defined by
-	 * the different architectures. In order to find the
-	 * largest possible bit mask a swap entry with swap type 0
+	 * device. There are three limiting factors: 1) the number
+	 * of bits for the swap offset in the swp_entry_t type, and
+	 * 2) the number of bits in the swap pte as defined by the
+	 * the different architectures, and 3) the number of free bits
+	 * in an exceptional radix_tree entry. In order to find the
+	 * largest possible bit mask, a swap entry with swap type 0
 	 * and swap offset ~0UL is created, encoded to a swap pte,
-	 * decoded to a swp_entry_t again and finally the swap
+	 * decoded to a swp_entry_t again, and finally the swap
 	 * offset is extracted. This will mask all the bits from
 	 * the initial ~0UL mask that can't be encoded in either
 	 * the swp_entry_t or the architecture definition of a
-	 * swap pte.
+	 * swap pte.  Then the same is done for a radix_tree entry.
 	 */
 	maxpages = swp_offset(pte_to_swp_entry(
-			swp_entry_to_pte(swp_entry(0, ~0UL)))) + 1;
+			swp_entry_to_pte(swp_entry(0, ~0UL))));
+	maxpages = swp_offset(radix_to_swp_entry(
+			swp_to_radix_entry(swp_entry(0, maxpages)))) + 1;
+
 	if (maxpages > swap_header->info.last_page) {
 		maxpages = swap_header->info.last_page + 1;
 		/* p->max is an unsigned int: don't overflow it */
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-move-vmtruncate_range-to-truncatec.patch
mm-move-shmem-prototypes-to-shmem_fsh.patch
tmpfs-take-control-of-its-truncate_range.patch
tmpfs-add-shmem_read_mapping_page_gfp.patch
drm-ttm-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_truncate_range.patch
drm-i915-more-struct_mutex-locking.patch
drm-i915-more-struct_mutex-locking-fix.patch
mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
linux-next.patch
tmpfs-clone-shmem_file_splice_read.patch
tmpfs-refine-shmem_file_splice_read.patch
tmpfs-pass-gfp-to-shmem_getpage_gfp.patch
tmpfs-remove_shmem_readpage.patch
tmpfs-simplify-prealloc_page.patch
tmpfs-simplify-filepage-swappage.patch
tmpfs-simplify-unuse-and-writepage.patch
radix_tree-exceptional-entries-and-indices.patch
mm-let-swap-use-exceptional-entries.patch
tmpfs-demolish-old-swap-vector-support.patch
tmpfs-miscellaneous-trivial-cleanups.patch
tmpfs-copy-truncate_inode_pages_range.patch
tmpfs-convert-shmem_truncate_range-to-radix-swap.patch
tmpfs-convert-shmem_unuse_inode-to-radix-swap.patch
tmpfs-convert-shmem_getpage_gfp-to-radix-swap.patch
tmpfs-convert-mem_cgroup-shmem-to-radix-swap.patch
tmpfs-convert-shmem_writepage-and-enable-swap.patch
tmpfs-use-kmemdup-for-short-symlinks.patch
mm-a-few-small-updates-for-radix-swap.patch
prio_tree-debugging-patch.patch

