From: akpm@linux-foundation.org
Subject: + mm-define-page_mapping_flags.patch added to -mm tree
Date: Thu, 12 Nov 2009 12:55:13 -0800
Message-ID: <200911122055.nACKtDkS018728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754366AbZKLUzu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 15:55:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, Lee.Schermerhorn@hp.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, ieidus@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com


The patch titled
     mm: define PAGE_MAPPING_FLAGS
has been added to the -mm tree.  Its filename is
     mm-define-page_mapping_flags.patch

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
Subject: mm: define PAGE_MAPPING_FLAGS
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

At present we define PageAnon(page) by the low PAGE_MAPPING_ANON bit set
in page->mapping, with the higher bits a pointer to the anon_vma; and have
defined PageKsm(page) as that with NULL anon_vma.

But KSM swapping will need to store a pointer there: so in preparation for
that, now define PAGE_MAPPING_FLAGS as the low two bits, including
PAGE_MAPPING_KSM (always set along with PAGE_MAPPING_ANON, until some
other use for the bit emerges).

Declare page_rmapping(page) to return the pointer part of page->mapping,
and page_anon_vma(page) to return the anon_vma pointer when that's what it
is.  Use these in a few appropriate places: notably, unuse_vma() has been
testing page->mapping, but is better to be testing page_anon_vma() (cases
may be added in which flag bits are set without any pointer).

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h  |    5 +++--
 include/linux/mm.h   |   17 ++++++++++++++++-
 include/linux/rmap.h |    8 ++++++++
 mm/migrate.c         |   11 ++++-------
 mm/rmap.c            |    7 +++----
 mm/swapfile.c        |    2 +-
 6 files changed, 35 insertions(+), 15 deletions(-)

diff -puN include/linux/ksm.h~mm-define-page_mapping_flags include/linux/ksm.h
--- a/include/linux/ksm.h~mm-define-page_mapping_flags
+++ a/include/linux/ksm.h
@@ -38,7 +38,8 @@ static inline void ksm_exit(struct mm_st
  */
 static inline int PageKsm(struct page *page)
 {
-	return ((unsigned long)page->mapping == PAGE_MAPPING_ANON);
+	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) ==
+				(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM);
 }
 
 /*
@@ -47,7 +48,7 @@ static inline int PageKsm(struct page *p
 static inline void page_add_ksm_rmap(struct page *page)
 {
 	if (atomic_inc_and_test(&page->_mapcount)) {
-		page->mapping = (void *) PAGE_MAPPING_ANON;
+		page->mapping = (void *) (PAGE_MAPPING_ANON | PAGE_MAPPING_KSM);
 		__inc_zone_page_state(page, NR_ANON_PAGES);
 	}
 }
diff -puN include/linux/mm.h~mm-define-page_mapping_flags include/linux/mm.h
--- a/include/linux/mm.h~mm-define-page_mapping_flags
+++ a/include/linux/mm.h
@@ -620,13 +620,22 @@ void page_address_init(void);
 /*
  * On an anonymous page mapped into a user virtual memory area,
  * page->mapping points to its anon_vma, not to a struct address_space;
- * with the PAGE_MAPPING_ANON bit set to distinguish it.
+ * with the PAGE_MAPPING_ANON bit set to distinguish it.  See rmap.h.
+ *
+ * On an anonymous page in a VM_MERGEABLE area, if CONFIG_KSM is enabled,
+ * the PAGE_MAPPING_KSM bit may be set along with the PAGE_MAPPING_ANON bit;
+ * and then page->mapping points, not to an anon_vma, but to a private
+ * structure which KSM associates with that merged page.  See ksm.h.
+ *
+ * PAGE_MAPPING_KSM without PAGE_MAPPING_ANON is currently never used.
  *
  * Please note that, confusingly, "page_mapping" refers to the inode
  * address_space which maps the page from disk; whereas "page_mapped"
  * refers to user virtual address space into which the page is mapped.
  */
 #define PAGE_MAPPING_ANON	1
+#define PAGE_MAPPING_KSM	2
+#define PAGE_MAPPING_FLAGS	(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM)
 
 extern struct address_space swapper_space;
 static inline struct address_space *page_mapping(struct page *page)
@@ -644,6 +653,12 @@ static inline struct address_space *page
 	return mapping;
 }
 
+/* Neutral page->mapping pointer to address_space or anon_vma or other */
+static inline void *page_rmapping(struct page *page)
+{
+	return (void *)((unsigned long)page->mapping & ~PAGE_MAPPING_FLAGS);
+}
+
 static inline int PageAnon(struct page *page)
 {
 	return ((unsigned long)page->mapping & PAGE_MAPPING_ANON) != 0;
diff -puN include/linux/rmap.h~mm-define-page_mapping_flags include/linux/rmap.h
--- a/include/linux/rmap.h~mm-define-page_mapping_flags
+++ a/include/linux/rmap.h
@@ -39,6 +39,14 @@ struct anon_vma {
 
 #ifdef CONFIG_MMU
 
+static inline struct anon_vma *page_anon_vma(struct page *page)
+{
+	if (((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) !=
+					    PAGE_MAPPING_ANON)
+		return NULL;
+	return page_rmapping(page);
+}
+
 static inline void anon_vma_lock(struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
diff -puN mm/migrate.c~mm-define-page_mapping_flags mm/migrate.c
--- a/mm/migrate.c~mm-define-page_mapping_flags
+++ a/mm/migrate.c
@@ -172,17 +172,14 @@ static void remove_anon_migration_ptes(s
 {
 	struct anon_vma *anon_vma;
 	struct vm_area_struct *vma;
-	unsigned long mapping;
-
-	mapping = (unsigned long)new->mapping;
-
-	if (!mapping || (mapping & PAGE_MAPPING_ANON) == 0)
-		return;
 
 	/*
 	 * We hold the mmap_sem lock. So no need to call page_lock_anon_vma.
 	 */
-	anon_vma = (struct anon_vma *) (mapping - PAGE_MAPPING_ANON);
+	anon_vma = page_anon_vma(new);
+	if (!anon_vma)
+		return;
+
 	spin_lock(&anon_vma->lock);
 
 	list_for_each_entry(vma, &anon_vma->head, anon_vma_node)
diff -puN mm/rmap.c~mm-define-page_mapping_flags mm/rmap.c
--- a/mm/rmap.c~mm-define-page_mapping_flags
+++ a/mm/rmap.c
@@ -203,7 +203,7 @@ struct anon_vma *page_lock_anon_vma(stru
 
 	rcu_read_lock();
 	anon_mapping = (unsigned long) page->mapping;
-	if (!(anon_mapping & PAGE_MAPPING_ANON))
+	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
 		goto out;
 	if (!page_mapped(page))
 		goto out;
@@ -248,8 +248,7 @@ vma_address(struct page *page, struct vm
 unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
 {
 	if (PageAnon(page)) {
-		if ((void *)vma->anon_vma !=
-		    (void *)page->mapping - PAGE_MAPPING_ANON)
+		if (vma->anon_vma != page_anon_vma(page))
 			return -EFAULT;
 	} else if (page->mapping && !(vma->vm_flags & VM_NONLINEAR)) {
 		if (!vma->vm_file ||
@@ -513,7 +512,7 @@ int page_referenced(struct page *page,
 		referenced++;
 
 	*vm_flags = 0;
-	if (page_mapped(page) && page->mapping) {
+	if (page_mapped(page) && page_rmapping(page)) {
 		if (PageAnon(page))
 			referenced += page_referenced_anon(page, mem_cont,
 								vm_flags);
diff -puN mm/swapfile.c~mm-define-page_mapping_flags mm/swapfile.c
--- a/mm/swapfile.c~mm-define-page_mapping_flags
+++ a/mm/swapfile.c
@@ -937,7 +937,7 @@ static int unuse_vma(struct vm_area_stru
 	unsigned long addr, end, next;
 	int ret;
 
-	if (page->mapping) {
+	if (page_anon_vma(page)) {
 		addr = page_address_in_vma(page, vma);
 		if (addr == -EFAULT)
 			return 0;
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch
swap_info-private-to-swapfilec.patch
swap_info-change-to-array-of-pointers.patch
swap_info-include-first_swap_extent.patch
swap_info-include-first_swap_extent-fix.patch
swap_info-include-first_swap_extent-fix-fix.patch
swap_info-miscellaneous-minor-cleanups.patch
swap_info-swap_has_cache-cleanups.patch
swap_info-swap_map-of-chars-not-shorts.patch
swap_info-swap-count-continuations.patch
swap_info-note-swap_map_shmem.patch
swap_info-reorder-its-fields.patch
rmap-fix-the-comment-for-try_to_unmap_anon.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

