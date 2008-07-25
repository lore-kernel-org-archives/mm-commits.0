From: akpm@linux-foundation.org
Subject: - mm-speculative-page-references-fix-add_to_page_cache.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:55:43 -0700
Message-ID: <200807252355.m6PNtivc006100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755526AbYGYXzw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:55:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     speculative page references: fix add_to_page_cache
has been removed from the -mm tree.  Its filename was
     mm-speculative-page-references-fix-add_to_page_cache.patch

This patch was dropped because it was folded into mm-speculative-page-references.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: speculative page references: fix add_to_page_cache
From: Hugh Dickins <hugh@veritas.com>

The speculative page references patch actually depends on another patch of
Nick's which he hasn't supplied this time around: an atomic-avoiding
__set_page_locked patch: see http://lkml.org/lkml/2007/11/10/5

This showed up when shmem_unuse_inode's add_to_page_cache failed: the page
was passed in locked and should remain locked, but speculative's
add_to_page_cache had unlocked it already, so the subsequent unlock_page
BUGged.  add_to_page_cache indeed should set and clear the page lock, but
shmem/tmpfs needs an add_to_page_cache_locked entry point to avoid that.

This fix patch below extracts and updates what's needed from Nick's
original, including his comments, but leaving out the atomic-avoidance.

(Do speculative page references actually need the page locked before it's
entered into the page cache?  I'm not sure myself, suspect that if
everywhere else handled PageUptodate and PageError correctly then it might
not be necessary; but we're pretty sure there are gaps in that error
handling, so I agree with Nick that we should lock before.  He may well be
able to supply a stronger reason why it's necessary.)

I apologize for not finding this sooner, my testing coverage weaker than
I'd thought: only hit this in checking the swap priority patch.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   18 +++++++++++++++++-
 mm/filemap.c            |   19 +++++++++----------
 mm/shmem.c              |    6 +++---
 mm/swap_state.c         |    2 +-
 4 files changed, 30 insertions(+), 15 deletions(-)

diff -puN include/linux/pagemap.h~mm-speculative-page-references-fix-add_to_page_cache include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-speculative-page-references-fix-add_to_page_cache
+++ a/include/linux/pagemap.h
@@ -227,7 +227,7 @@ static inline struct page *read_mapping_
 	return read_cache_page(mapping, index, filler, data);
 }
 
-int add_to_page_cache(struct page *page, struct address_space *mapping,
+int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
@@ -235,6 +235,22 @@ extern void remove_from_page_cache(struc
 extern void __remove_from_page_cache(struct page *page);
 
 /*
+ * Like add_to_page_cache_locked, but used to add newly allocated pages:
+ * the page is new, so we can just run SetPageLocked() against it.
+ */
+static inline int add_to_page_cache(struct page *page,
+		struct address_space *mapping, pgoff_t offset, gfp_t gfp_mask)
+{
+	int error;
+
+	SetPageLocked(page);
+	error = add_to_page_cache_locked(page, mapping, offset, gfp_mask);
+	if (unlikely(error))
+		ClearPageLocked(page);
+	return error;
+}
+
+/*
  * Return byte-offset into filesystem object for page.
  */
 static inline loff_t page_offset(struct page *page)
diff -puN mm/filemap.c~mm-speculative-page-references-fix-add_to_page_cache mm/filemap.c
--- a/mm/filemap.c~mm-speculative-page-references-fix-add_to_page_cache
+++ a/mm/filemap.c
@@ -442,22 +442,23 @@ int filemap_write_and_wait_range(struct 
 }
 
 /**
- * add_to_page_cache - add newly allocated pagecache pages
+ * add_to_page_cache_locked - add newly allocated pagecache pages
  * @page:	page to add
  * @mapping:	the page's address_space
  * @offset:	page index
  * @gfp_mask:	page allocation mode
  *
- * This function is used to add newly allocated pagecache pages;
- * the page is new, so we can just run SetPageLocked() against it.
- * The other page state flags were set by rmqueue().
- *
+ * This function is used to add a page to the pagecache. It must be locked.
  * This function does not add the page to the LRU.  The caller must do that.
  */
-int add_to_page_cache(struct page *page, struct address_space *mapping,
+int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 		pgoff_t offset, gfp_t gfp_mask)
 {
-	int error = mem_cgroup_cache_charge(page, current->mm,
+	int error;
+
+	VM_BUG_ON(!PageLocked(page));
+
+	error = mem_cgroup_cache_charge(page, current->mm,
 					gfp_mask & ~__GFP_HIGHMEM);
 	if (error)
 		goto out;
@@ -465,7 +466,6 @@ int add_to_page_cache(struct page *page,
 	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
 	if (error == 0) {
 		page_cache_get(page);
-		SetPageLocked(page);
 		page->mapping = mapping;
 		page->index = offset;
 
@@ -476,7 +476,6 @@ int add_to_page_cache(struct page *page,
 			__inc_zone_page_state(page, NR_FILE_PAGES);
 		} else {
 			page->mapping = NULL;
-			ClearPageLocked(page);
 			mem_cgroup_uncharge_cache_page(page);
 			page_cache_release(page);
 		}
@@ -488,7 +487,7 @@ int add_to_page_cache(struct page *page,
 out:
 	return error;
 }
-EXPORT_SYMBOL(add_to_page_cache);
+EXPORT_SYMBOL(add_to_page_cache_locked);
 
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 				pgoff_t offset, gfp_t gfp_mask)
diff -puN mm/shmem.c~mm-speculative-page-references-fix-add_to_page_cache mm/shmem.c
--- a/mm/shmem.c~mm-speculative-page-references-fix-add_to_page_cache
+++ a/mm/shmem.c
@@ -936,7 +936,7 @@ found:
 	spin_lock(&info->lock);
 	ptr = shmem_swp_entry(info, idx, NULL);
 	if (ptr && ptr->val == entry.val) {
-		error = add_to_page_cache(page, inode->i_mapping,
+		error = add_to_page_cache_locked(page, inode->i_mapping,
 						idx, GFP_NOWAIT);
 		/* does mem_cgroup_uncharge_cache_page on error */
 	} else	/* we must compensate for our precharge above */
@@ -1301,8 +1301,8 @@ repeat:
 			SetPageUptodate(filepage);
 			set_page_dirty(filepage);
 			swap_free(swap);
-		} else if (!(error = add_to_page_cache(
-				swappage, mapping, idx, GFP_NOWAIT))) {
+		} else if (!(error = add_to_page_cache_locked(swappage, mapping,
+					idx, GFP_NOWAIT))) {
 			info->flags |= SHMEM_PAGEIN;
 			shmem_swp_set(info, entry, 0);
 			shmem_swp_unmap(entry);
diff -puN mm/swap_state.c~mm-speculative-page-references-fix-add_to_page_cache mm/swap_state.c
--- a/mm/swap_state.c~mm-speculative-page-references-fix-add_to_page_cache
+++ a/mm/swap_state.c
@@ -64,7 +64,7 @@ void show_swap_cache_info(void)
 }
 
 /*
- * add_to_swap_cache resembles add_to_page_cache on swapper_space,
+ * add_to_swap_cache resembles add_to_page_cache_locked on swapper_space,
  * but sets SwapCache flag and private instead of mapping and index.
  */
 int add_to_swap_cache(struct page *page, swp_entry_t entry, gfp_t gfp_mask)
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
x86-implement-pte_special-fix.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix-add_to_page_cache.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable-fix-4.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
mmapc-deinline-a-few-functions.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
prio_tree-debugging-patch.patch

