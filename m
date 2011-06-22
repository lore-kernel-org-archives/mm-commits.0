From: akpm@linux-foundation.org
Subject: + mm-a-few-small-updates-for-radix-swap-fix.patch added to -mm tree
Date: Wed, 22 Jun 2011 12:06:58 -0700
Message-ID: <201106221906.p5MJ6xOR020607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758730Ab1FVTHa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Jun 2011 15:07:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, riel@redhat.com


The patch titled
     mm: a few small updates for radix-swap fix
has been added to the -mm tree.  Its filename is
     mm-a-few-small-updates-for-radix-swap-fix.patch

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
Subject: mm: a few small updates for radix-swap fix
From: Hugh Dickins <hughd@google.com>

Fix NULL dereference I introduced in mincore_page().

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/mincore.c~mm-a-few-small-updates-for-radix-swap-fix mm/mincore.c
--- a/mm/mincore.c~mm-a-few-small-updates-for-radix-swap-fix
+++ a/mm/mincore.c
@@ -71,13 +71,13 @@ static unsigned char mincore_page(struct
 	 * tmpfs's .fault). So swapped out tmpfs mappings are tested here.
 	 */
 	page = find_get_page(mapping, pgoff);
-	if (page) {
 #ifdef CONFIG_SWAP
-		if (radix_tree_exceptional_entry(page)) {
-			swp_entry_t swap = radix_to_swp_entry(page);
-			page = find_get_page(&swapper_space, swap.val);
-		}
+	if (radix_tree_exceptional_entry(page)) {
+		swp_entry_t swap = radix_to_swp_entry(page);
+		page = find_get_page(&swapper_space, swap.val);
+	}
 #endif
+	if (page) {
 		present = PageUptodate(page);
 		page_cache_release(page);
 	}
_

Patches currently in -mm which might be from hughd@google.com are

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
mm-a-few-small-updates-for-radix-swap-fix.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
prio_tree-debugging-patch.patch

