From: akpm@linux-foundation.org
Subject: + tmpfs-convert-mem_cgroup-shmem-to-radix-swap.patch added to -mm tree
Date: Fri, 17 Jun 2011 16:40:03 -0700
Message-ID: <201106172340.p5HNe3TS008320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759588Ab1FQXkI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 19:40:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, riel@redhat.com


The patch titled
     tmpfs: convert mem_cgroup shmem to radix-swap
has been added to the -mm tree.  Its filename is
     tmpfs-convert-mem_cgroup-shmem-to-radix-swap.patch

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
Subject: tmpfs: convert mem_cgroup shmem to radix-swap
From: Hugh Dickins <hughd@google.com>

Remove mem_cgroup_shmem_charge_fallback(): it was only required when we
had to move swappage to filecache with GFP_NOWAIT.

Remove the GFP_NOWAIT special case from mem_cgroup_cache_charge(), by
moving its call out from shmem_add_to_page_cache() to two of thats three
callers.  But leave it doing mem_cgroup_uncharge_cache_page() on error:
although asymmetrical, it's easier for all 3 callers to handle.

These two changes would also be appropriate if anyone were to start using
shmem_read_mapping_page_gfp() with GFP_NOWAIT.

Remove mem_cgroup_get_shmem_target(): mc_handle_file_pte() can test
radix_tree_exceptional_entry() to get what it needs for itself.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    8 ---
 include/linux/shmem_fs.h   |    2 
 mm/memcontrol.c            |   66 +++------------------------
 mm/shmem.c                 |   83 ++++-------------------------------
 4 files changed, 20 insertions(+), 139 deletions(-)

diff -puN include/linux/memcontrol.h~tmpfs-convert-mem_cgroup-shmem-to-radix-swap include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~tmpfs-convert-mem_cgroup-shmem-to-radix-swap
+++ a/include/linux/memcontrol.h
@@ -76,8 +76,6 @@ extern void mem_cgroup_uncharge_end(void
 
 extern void mem_cgroup_uncharge_page(struct page *page);
 extern void mem_cgroup_uncharge_cache_page(struct page *page);
-extern int mem_cgroup_shmem_charge_fallback(struct page *page,
-			struct mm_struct *mm, gfp_t gfp_mask);
 
 extern void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask);
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
@@ -207,12 +205,6 @@ static inline void mem_cgroup_uncharge_c
 {
 }
 
-static inline int mem_cgroup_shmem_charge_fallback(struct page *page,
-			struct mm_struct *mm, gfp_t gfp_mask)
-{
-	return 0;
-}
-
 static inline void mem_cgroup_add_lru_list(struct page *page, int lru)
 {
 }
diff -puN include/linux/shmem_fs.h~tmpfs-convert-mem_cgroup-shmem-to-radix-swap include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~tmpfs-convert-mem_cgroup-shmem-to-radix-swap
+++ a/include/linux/shmem_fs.h
@@ -57,8 +57,6 @@ extern struct page *shmem_read_mapping_p
 					pgoff_t index, gfp_t gfp_mask);
 extern void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end);
 extern int shmem_unuse(swp_entry_t entry, struct page *page);
-extern void mem_cgroup_get_shmem_target(struct inode *inode, pgoff_t pgoff,
-					struct page **pagep, swp_entry_t *ent);
 
 static inline struct page *shmem_read_mapping_page(
 				struct address_space *mapping, pgoff_t index)
diff -puN mm/memcontrol.c~tmpfs-convert-mem_cgroup-shmem-to-radix-swap mm/memcontrol.c
--- a/mm/memcontrol.c~tmpfs-convert-mem_cgroup-shmem-to-radix-swap
+++ a/mm/memcontrol.c
@@ -35,7 +35,6 @@
 #include <linux/limits.h>
 #include <linux/mutex.h>
 #include <linux/rbtree.h>
-#include <linux/shmem_fs.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
@@ -2718,30 +2717,6 @@ int mem_cgroup_cache_charge(struct page 
 		return 0;
 	if (PageCompound(page))
 		return 0;
-	/*
-	 * Corner case handling. This is called from add_to_page_cache()
-	 * in usual. But some FS (shmem) precharges this page before calling it
-	 * and call add_to_page_cache() with GFP_NOWAIT.
-	 *
-	 * For GFP_NOWAIT case, the page may be pre-charged before calling
-	 * add_to_page_cache(). (See shmem.c) check it here and avoid to call
-	 * charge twice. (It works but has to pay a bit larger cost.)
-	 * And when the page is SwapCache, it should take swap information
-	 * into account. This is under lock_page() now.
-	 */
-	if (!(gfp_mask & __GFP_WAIT)) {
-		struct page_cgroup *pc;
-
-		pc = lookup_page_cgroup(page);
-		if (!pc)
-			return 0;
-		lock_page_cgroup(pc);
-		if (PageCgroupUsed(pc)) {
-			unlock_page_cgroup(pc);
-			return 0;
-		}
-		unlock_page_cgroup(pc);
-	}
 
 	if (unlikely(!mm))
 		mm = &init_mm;
@@ -3331,31 +3306,6 @@ void mem_cgroup_end_migration(struct mem
 	cgroup_release_and_wakeup_rmdir(&mem->css);
 }
 
-/*
- * A call to try to shrink memory usage on charge failure at shmem's swapin.
- * Calling hierarchical_reclaim is not enough because we should update
- * last_oom_jiffies to prevent pagefault_out_of_memory from invoking global OOM.
- * Moreover considering hierarchy, we should reclaim from the mem_over_limit,
- * not from the memcg which this page would be charged to.
- * try_charge_swapin does all of these works properly.
- */
-int mem_cgroup_shmem_charge_fallback(struct page *page,
-			    struct mm_struct *mm,
-			    gfp_t gfp_mask)
-{
-	struct mem_cgroup *mem;
-	int ret;
-
-	if (mem_cgroup_disabled())
-		return 0;
-
-	ret = mem_cgroup_try_charge_swapin(mm, page, gfp_mask, &mem);
-	if (!ret)
-		mem_cgroup_cancel_charge_swapin(mem); /* it does !mem check */
-
-	return ret;
-}
-
 #ifdef CONFIG_DEBUG_VM
 static struct page_cgroup *lookup_page_cgroup_used(struct page *page)
 {
@@ -5115,15 +5065,17 @@ static struct page *mc_handle_file_pte(s
 		pgoff = pte_to_pgoff(ptent);
 
 	/* page is moved even if it's not RSS of this task(page-faulted). */
-	if (!mapping_cap_swap_backed(mapping)) { /* normal file */
-		page = find_get_page(mapping, pgoff);
-	} else { /* shmem/tmpfs file. we should take account of swap too. */
-		swp_entry_t ent;
-		mem_cgroup_get_shmem_target(inode, pgoff, &page, &ent);
+	page = find_get_page(mapping, pgoff);
+
+#ifdef CONFIG_SWAP
+	/* shmem/tmpfs may report page out on swap: account for that too. */
+	if (radix_tree_exceptional_entry(page)) {
+		swp_entry_t swap = radix_to_swp_entry(page);
 		if (do_swap_account)
-			entry->val = ent.val;
+			*entry = swap;
+		page = find_get_page(&swapper_space, swap.val);
 	}
-
+#endif
 	return page;
 }
 
diff -puN mm/shmem.c~tmpfs-convert-mem_cgroup-shmem-to-radix-swap mm/shmem.c
--- a/mm/shmem.c~tmpfs-convert-mem_cgroup-shmem-to-radix-swap
+++ a/mm/shmem.c
@@ -262,15 +262,11 @@ static int shmem_add_to_page_cache(struc
 				   struct address_space *mapping,
 				   pgoff_t index, gfp_t gfp, void *expected)
 {
-	int error;
+	int error = 0;
 
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(!PageSwapBacked(page));
 
-	error = mem_cgroup_cache_charge(page, current->mm,
-						gfp & GFP_RECLAIM_MASK);
-	if (error)
-		goto out;
 	if (!expected)
 		error = radix_tree_preload(gfp & GFP_RECLAIM_MASK);
 	if (!error) {
@@ -300,7 +296,6 @@ static int shmem_add_to_page_cache(struc
 	}
 	if (error)
 		mem_cgroup_uncharge_cache_page(page);
-out:
 	return error;
 }
 
@@ -660,7 +655,6 @@ int shmem_unuse(swp_entry_t swap, struct
 	 * Charge page using GFP_KERNEL while we can wait, before taking
 	 * the shmem_swaplist_mutex which might hold up shmem_writepage().
 	 * Charged back to the user (not to caller) when swap account is used.
-	 * shmem_add_to_page_cache() will be called with GFP_NOWAIT.
 	 */
 	error = mem_cgroup_cache_charge(page, current->mm, GFP_KERNEL);
 	if (error)
@@ -954,8 +948,11 @@ repeat:
 			goto failed;
 		}
 
-		error = shmem_add_to_page_cache(page, mapping, index,
-					gfp, swp_to_radix_entry(swap));
+		error = mem_cgroup_cache_charge(page, current->mm,
+						gfp & GFP_RECLAIM_MASK);
+		if (!error)
+			error = shmem_add_to_page_cache(page, mapping, index,
+						gfp, swp_to_radix_entry(swap));
 		if (error)
 			goto failed;
 
@@ -990,8 +987,11 @@ repeat:
 
 		SetPageSwapBacked(page);
 		__set_page_locked(page);
-		error = shmem_add_to_page_cache(page, mapping, index,
-								gfp, NULL);
+		error = mem_cgroup_cache_charge(page, current->mm,
+						gfp & GFP_RECLAIM_MASK);
+		if (!error)
+			error = shmem_add_to_page_cache(page, mapping, index,
+						gfp, NULL);
 		if (error)
 			goto decused;
 		lru_cache_add_anon(page);
@@ -2448,42 +2448,6 @@ out4:
 	return error;
 }
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
-/**
- * mem_cgroup_get_shmem_target - find page or swap assigned to the shmem file
- * @inode: the inode to be searched
- * @index: the page offset to be searched
- * @pagep: the pointer for the found page to be stored
- * @swapp: the pointer for the found swap entry to be stored
- *
- * If a page is found, refcount of it is incremented. Callers should handle
- * these refcount.
- */
-void mem_cgroup_get_shmem_target(struct inode *inode, pgoff_t index,
-				 struct page **pagep, swp_entry_t *swapp)
-{
-	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct page *page = NULL;
-	swp_entry_t swap = {0};
-
-	if ((index << PAGE_CACHE_SHIFT) >= i_size_read(inode))
-		goto out;
-
-	spin_lock(&info->lock);
-#ifdef CONFIG_SWAP
-	swap = shmem_get_swap(info, index);
-	if (swap.val)
-		page = find_get_page(&swapper_space, swap.val);
-	else
-#endif
-		page = find_get_page(inode->i_mapping, index);
-	spin_unlock(&info->lock);
-out:
-	*pagep = page;
-	*swapp = swap;
-}
-#endif
-
 #else /* !CONFIG_SHMEM */
 
 /*
@@ -2529,31 +2493,6 @@ void shmem_truncate_range(struct inode *
 }
 EXPORT_SYMBOL_GPL(shmem_truncate_range);
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
-/**
- * mem_cgroup_get_shmem_target - find page or swap assigned to the shmem file
- * @inode: the inode to be searched
- * @index: the page offset to be searched
- * @pagep: the pointer for the found page to be stored
- * @swapp: the pointer for the found swap entry to be stored
- *
- * If a page is found, refcount of it is incremented. Callers should handle
- * these refcount.
- */
-void mem_cgroup_get_shmem_target(struct inode *inode, pgoff_t index,
-				 struct page **pagep, swp_entry_t *swapp)
-{
-	struct page *page = NULL;
-
-	if ((index << PAGE_CACHE_SHIFT) >= i_size_read(inode))
-		goto out;
-	page = find_get_page(inode->i_mapping, index);
-out:
-	*pagep = page;
-	*swapp = (swp_entry_t){0};
-}
-#endif
-
 #define shmem_vm_ops				generic_file_vm_ops
 #define shmem_file_operations			ramfs_file_operations
 #define shmem_get_inode(sb, dir, mode, dev, flags)	ramfs_get_inode(sb, dir, mode, dev)
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

