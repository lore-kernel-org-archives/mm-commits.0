From: akpm@linux-foundation.org
Subject: - swapin-needs-gfp_mask-for-loop-on-tmpfs.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:30:02 -0800
Message-ID: <200802052229.m15MThFv012004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56359 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762691AbYBEWoE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, a.p.zijlstra@chello.nl, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     swapin needs gfp_mask for loop on tmpfs
has been removed from the -mm tree.  Its filename was
     swapin-needs-gfp_mask-for-loop-on-tmpfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swapin needs gfp_mask for loop on tmpfs
From: Hugh Dickins <hugh@veritas.com>

Building in a filesystem on a loop device on a tmpfs file can hang when
swapping, the loop thread caught in that infamous throttle_vm_writeout.

In theory this is a long standing problem, which I've either never seen in
practice, or long ago suppressed the recollection, after discounting my load
and my tmpfs size as unrealistically high.  But now, with the new aops, it has
become easy to hang on one machine.

Loop used to grab_cache_page before the old prepare_write to tmpfs, which
seems to have been enough to free up some memory for any swapin needed; but
the new write_begin lets tmpfs find or allocate the page (much nicer, since
grab_cache_page missed tmpfs pages in swapcache).

When allocating a fresh page, tmpfs respects loop's mapping_gfp_mask, which
has __GFP_IO|__GFP_FS stripped off, and throttle_vm_writeout is designed to
break out when __GFP_IO or GFP_FS is unset; but when tmfps swaps in,
read_swap_cache_async allocates with GFP_HIGHUSER_MOVABLE regardless of the
mapping_gfp_mask - hence the hang.

So, pass gfp_mask down the line from shmem_getpage to shmem_swapin to
swapin_readahead to read_swap_cache_async to add_to_swap_cache.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 +++---
 mm/memory.c          |    3 ++-
 mm/shmem.c           |   28 ++++++++++++++--------------
 mm/swap_state.c      |   18 +++++++++---------
 mm/swapfile.c        |    3 ++-
 5 files changed, 30 insertions(+), 28 deletions(-)

diff -puN include/linux/swap.h~swapin-needs-gfp_mask-for-loop-on-tmpfs include/linux/swap.h
--- a/include/linux/swap.h~swapin-needs-gfp_mask-for-loop-on-tmpfs
+++ a/include/linux/swap.h
@@ -228,9 +228,9 @@ extern int move_from_swap_cache(struct p
 extern void free_page_and_swap_cache(struct page *);
 extern void free_pages_and_swap_cache(struct page **, int);
 extern struct page *lookup_swap_cache(swp_entry_t);
-extern struct page *read_swap_cache_async(swp_entry_t,
+extern struct page *read_swap_cache_async(swp_entry_t, gfp_t,
 			struct vm_area_struct *vma, unsigned long addr);
-extern struct page *swapin_readahead(swp_entry_t,
+extern struct page *swapin_readahead(swp_entry_t, gfp_t,
 			struct vm_area_struct *vma, unsigned long addr);
 
 /* linux/mm/swapfile.c */
@@ -306,7 +306,7 @@ static inline void swap_free(swp_entry_t
 {
 }
 
-static inline struct page *swapin_readahead(swp_entry_t swp,
+static inline struct page *swapin_readahead(swp_entry_t swp, gfp_t gfp_mask,
 			struct vm_area_struct *vma, unsigned long addr)
 {
 	return NULL;
diff -puN mm/memory.c~swapin-needs-gfp_mask-for-loop-on-tmpfs mm/memory.c
--- a/mm/memory.c~swapin-needs-gfp_mask-for-loop-on-tmpfs
+++ a/mm/memory.c
@@ -2007,7 +2007,8 @@ static int do_swap_page(struct mm_struct
 	page = lookup_swap_cache(entry);
 	if (!page) {
 		grab_swap_token(); /* Contend for token _before_ read-in */
-		page = swapin_readahead(entry, vma, address);
+		page = swapin_readahead(entry,
+					GFP_HIGHUSER_MOVABLE, vma, address);
 		if (!page) {
 			/*
 			 * Back out if somebody else faulted in this pte
diff -puN mm/shmem.c~swapin-needs-gfp_mask-for-loop-on-tmpfs mm/shmem.c
--- a/mm/shmem.c~swapin-needs-gfp_mask-for-loop-on-tmpfs
+++ a/mm/shmem.c
@@ -1025,8 +1025,8 @@ out:
 	return err;
 }
 
-static struct page *shmem_swapin(struct shmem_inode_info *info,
-				       swp_entry_t entry, unsigned long idx)
+static struct page *shmem_swapin(swp_entry_t entry, gfp_t gfp,
+			struct shmem_inode_info *info, unsigned long idx)
 {
 	struct vm_area_struct pvma;
 	struct page *page;
@@ -1036,13 +1036,13 @@ static struct page *shmem_swapin(struct 
 	pvma.vm_pgoff = idx;
 	pvma.vm_ops = NULL;
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, idx);
-	page = swapin_readahead(entry, &pvma, 0);
+	page = swapin_readahead(entry, gfp, &pvma, 0);
 	mpol_free(pvma.vm_policy);
 	return page;
 }
 
-static struct page *shmem_alloc_page(gfp_t gfp, struct shmem_inode_info *info,
-					unsigned long idx)
+static struct page *shmem_alloc_page(gfp_t gfp,
+			struct shmem_inode_info *info, unsigned long idx)
 {
 	struct vm_area_struct pvma;
 	struct page *page;
@@ -1063,14 +1063,14 @@ static inline int shmem_parse_mpol(char 
 	return 1;
 }
 
-static inline struct page *
-shmem_swapin(struct shmem_inode_info *info,swp_entry_t entry,unsigned long idx)
+static inline struct page *shmem_swapin(swp_entry_t entry, gfp_t gfp,
+			struct shmem_inode_info *info, unsigned long idx)
 {
-	return swapin_readahead(entry, NULL, 0);
+	return swapin_readahead(entry, gfp, NULL, 0);
 }
 
-static inline struct page *
-shmem_alloc_page(gfp_t gfp,struct shmem_inode_info *info, unsigned long idx)
+static inline struct page *shmem_alloc_page(gfp_t gfp,
+			struct shmem_inode_info *info, unsigned long idx)
 {
 	return alloc_page(gfp);
 }
@@ -1093,6 +1093,7 @@ static int shmem_getpage(struct inode *i
 	struct page *swappage;
 	swp_entry_t *entry;
 	swp_entry_t swap;
+	gfp_t gfp;
 	int error;
 
 	if (idx >= SHMEM_MAX_INDEX)
@@ -1117,6 +1118,7 @@ repeat:
 	error = 0;
 	if (sgp == SGP_QUICK)
 		goto failed;
+	gfp = mapping_gfp_mask(mapping);
 
 	spin_lock(&info->lock);
 	shmem_recalc_inode(inode);
@@ -1139,7 +1141,7 @@ repeat:
 				*type |= VM_FAULT_MAJOR;
 			}
 			spin_unlock(&info->lock);
-			swappage = shmem_swapin(info, swap, idx);
+			swappage = shmem_swapin(swap, gfp, info, idx);
 			if (!swappage) {
 				spin_lock(&info->lock);
 				entry = shmem_swp_alloc(info, idx, sgp);
@@ -1251,9 +1253,7 @@ repeat:
 
 		if (!filepage) {
 			spin_unlock(&info->lock);
-			filepage = shmem_alloc_page(mapping_gfp_mask(mapping),
-						    info,
-						    idx);
+			filepage = shmem_alloc_page(gfp, info, idx);
 			if (!filepage) {
 				shmem_unacct_blocks(info->flags, 1);
 				shmem_free_blocks(inode, 1);
diff -puN mm/swap_state.c~swapin-needs-gfp_mask-for-loop-on-tmpfs mm/swap_state.c
--- a/mm/swap_state.c~swapin-needs-gfp_mask-for-loop-on-tmpfs
+++ a/mm/swap_state.c
@@ -96,7 +96,8 @@ static int __add_to_swap_cache(struct pa
 	return error;
 }
 
-static int add_to_swap_cache(struct page *page, swp_entry_t entry)
+static int add_to_swap_cache(struct page *page, swp_entry_t entry,
+				gfp_t gfp_mask)
 {
 	int error;
 
@@ -106,7 +107,7 @@ static int add_to_swap_cache(struct page
 		return -ENOENT;
 	}
 	SetPageLocked(page);
-	error = __add_to_swap_cache(page, entry, GFP_KERNEL);
+	error = __add_to_swap_cache(page, entry, gfp_mask & GFP_KERNEL);
 	/*
 	 * Anon pages are already on the LRU, we don't run lru_cache_add here.
 	 */
@@ -318,7 +319,7 @@ struct page * lookup_swap_cache(swp_entr
  * A failure return means that either the page allocation failed or that
  * the swap entry is no longer in use.
  */
-struct page *read_swap_cache_async(swp_entry_t entry,
+struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 			struct vm_area_struct *vma, unsigned long addr)
 {
 	struct page *found_page, *new_page = NULL;
@@ -338,8 +339,7 @@ struct page *read_swap_cache_async(swp_e
 		 * Get a new page to read into from swap.
 		 */
 		if (!new_page) {
-			new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE,
-								vma, addr);
+			new_page = alloc_page_vma(gfp_mask, vma, addr);
 			if (!new_page)
 				break;		/* Out of memory */
 		}
@@ -354,7 +354,7 @@ struct page *read_swap_cache_async(swp_e
 		 * the just freed swap entry for an existing page.
 		 * May fail (-ENOMEM) if radix-tree node allocation failed.
 		 */
-		err = add_to_swap_cache(new_page, entry);
+		err = add_to_swap_cache(new_page, entry, gfp_mask);
 		if (!err) {
 			/*
 			 * Initiate read into locked page and return.
@@ -388,7 +388,7 @@ struct page *read_swap_cache_async(swp_e
  *
  * Caller must hold down_read on the vma->vm_mm if vma is not NULL.
  */
-struct page *swapin_readahead(swp_entry_t entry,
+struct page *swapin_readahead(swp_entry_t entry, gfp_t gfp_mask,
 			struct vm_area_struct *vma, unsigned long addr)
 {
 	int nr_pages;
@@ -407,11 +407,11 @@ struct page *swapin_readahead(swp_entry_
 	for (end_offset = offset + nr_pages; offset < end_offset; offset++) {
 		/* Ok, do the async read-ahead now */
 		page = read_swap_cache_async(swp_entry(swp_type(entry), offset),
-						vma, addr);
+						gfp_mask, vma, addr);
 		if (!page)
 			break;
 		page_cache_release(page);
 	}
 	lru_add_drain();	/* Push any new pages onto the LRU now */
-	return read_swap_cache_async(entry, vma, addr);
+	return read_swap_cache_async(entry, gfp_mask, vma, addr);
 }
diff -puN mm/swapfile.c~swapin-needs-gfp_mask-for-loop-on-tmpfs mm/swapfile.c
--- a/mm/swapfile.c~swapin-needs-gfp_mask-for-loop-on-tmpfs
+++ a/mm/swapfile.c
@@ -730,7 +730,8 @@ static int try_to_unuse(unsigned int typ
 		 */
 		swap_map = &si->swap_map[i];
 		entry = swp_entry(type, i);
-		page = read_swap_cache_async(entry, NULL, 0);
+		page = read_swap_cache_async(entry,
+					GFP_HIGHUSER_MOVABLE, NULL, 0);
 		if (!page) {
 			/*
 			 * Either swap_duplicate() failed because entry
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-unionfs.patch
git-x86.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-tmpfs-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
prio_tree-debugging-patch.patch
