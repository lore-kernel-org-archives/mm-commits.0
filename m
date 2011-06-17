From: akpm@linux-foundation.org
Subject: + tmpfs-pass-gfp-to-shmem_getpage_gfp.patch added to -mm tree
Date: Fri, 17 Jun 2011 16:39:32 -0700
Message-ID: <201106172339.p5HNdWCj008220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757478Ab1FQXjf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 19:39:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com


The patch titled
     tmpfs: pass gfp to shmem_getpage_gfp
has been added to the -mm tree.  Its filename is
     tmpfs-pass-gfp-to-shmem_getpage_gfp.patch

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
Subject: tmpfs: pass gfp to shmem_getpage_gfp
From: Hugh Dickins <hughd@google.com>

Make shmem_getpage() a wrapper, passing mapping_gfp_mask() down to
shmem_getpage_gfp(), which in turn passes gfp down to shmem_swp_alloc().

Change shmem_read_mapping_page_gfp() to use shmem_getpage_gfp() in the
CONFIG_SHMEM case; but leave tiny !SHMEM using read_cache_page_gfp().

Add a BUG_ON() in case anyone happens to call this on a non-shmem mapping;
though we might later want to let that case route to read_cache_page_gfp().

It annoys me to have these two almost-redundant args, gfp and fault_type:
I can't find a better way; but initialize fault_type only in shmem_fault().

Note that before, read_cache_page_gfp() was allocating i915_gem's pages
with __GFP_NORETRY as intended; but the corresponding swap vector pages
got allocated without it, leaving a small possibility of OOM.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   67 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 23 deletions(-)

diff -puN mm/shmem.c~tmpfs-pass-gfp-to-shmem_getpage_gfp mm/shmem.c
--- a/mm/shmem.c~tmpfs-pass-gfp-to-shmem_getpage_gfp
+++ a/mm/shmem.c
@@ -127,8 +127,15 @@ static unsigned long shmem_default_max_i
 }
 #endif
 
-static int shmem_getpage(struct inode *inode, unsigned long idx,
-			 struct page **pagep, enum sgp_type sgp, int *type);
+static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
+	struct page **pagep, enum sgp_type sgp, gfp_t gfp, int *fault_type);
+
+static inline int shmem_getpage(struct inode *inode, pgoff_t index,
+	struct page **pagep, enum sgp_type sgp, int *fault_type)
+{
+	return shmem_getpage_gfp(inode, index, pagep, sgp,
+			mapping_gfp_mask(inode->i_mapping), fault_type);
+}
 
 static inline struct page *shmem_dir_alloc(gfp_t gfp_mask)
 {
@@ -404,10 +411,12 @@ static void shmem_swp_set(struct shmem_i
  * @info:	info structure for the inode
  * @index:	index of the page to find
  * @sgp:	check and recheck i_size? skip allocation?
+ * @gfp:	gfp mask to use for any page allocation
  *
  * If the entry does not exist, allocate it.
  */
-static swp_entry_t *shmem_swp_alloc(struct shmem_inode_info *info, unsigned long index, enum sgp_type sgp)
+static swp_entry_t *shmem_swp_alloc(struct shmem_inode_info *info,
+			unsigned long index, enum sgp_type sgp, gfp_t gfp)
 {
 	struct inode *inode = &info->vfs_inode;
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
@@ -435,7 +444,7 @@ static swp_entry_t *shmem_swp_alloc(stru
 		}
 
 		spin_unlock(&info->lock);
-		page = shmem_dir_alloc(mapping_gfp_mask(inode->i_mapping));
+		page = shmem_dir_alloc(gfp);
 		spin_lock(&info->lock);
 
 		if (!page) {
@@ -1225,14 +1234,14 @@ static inline struct mempolicy *shmem_ge
 #endif
 
 /*
- * shmem_getpage - either get the page from swap or allocate a new one
+ * shmem_getpage_gfp - find page in cache, or get from swap, or allocate
  *
  * If we allocate a new one we do not mark it dirty. That's up to the
  * vm. If we swap it in we mark it dirty since we also free the swap
  * entry since a page cannot live in both the swap and page cache
  */
-static int shmem_getpage(struct inode *inode, unsigned long idx,
-			struct page **pagep, enum sgp_type sgp, int *type)
+static int shmem_getpage_gfp(struct inode *inode, pgoff_t idx,
+	struct page **pagep, enum sgp_type sgp, gfp_t gfp, int *fault_type)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -1242,15 +1251,11 @@ static int shmem_getpage(struct inode *i
 	struct page *prealloc_page = NULL;
 	swp_entry_t *entry;
 	swp_entry_t swap;
-	gfp_t gfp;
 	int error;
 
 	if (idx >= SHMEM_MAX_INDEX)
 		return -EFBIG;
 
-	if (type)
-		*type = 0;
-
 	/*
 	 * Normally, filepage is NULL on entry, and either found
 	 * uptodate immediately, or allocated and zeroed, or read
@@ -1264,13 +1269,12 @@ repeat:
 		filepage = find_lock_page(mapping, idx);
 	if (filepage && PageUptodate(filepage))
 		goto done;
-	gfp = mapping_gfp_mask(mapping);
 	if (!filepage) {
 		/*
 		 * Try to preload while we can wait, to not make a habit of
 		 * draining atomic reserves; but don't latch on to this cpu.
 		 */
-		error = radix_tree_preload(gfp & ~__GFP_HIGHMEM);
+		error = radix_tree_preload(gfp & GFP_RECLAIM_MASK);
 		if (error)
 			goto failed;
 		radix_tree_preload_end();
@@ -1290,7 +1294,7 @@ repeat:
 
 	spin_lock(&info->lock);
 	shmem_recalc_inode(inode);
-	entry = shmem_swp_alloc(info, idx, sgp);
+	entry = shmem_swp_alloc(info, idx, sgp, gfp);
 	if (IS_ERR(entry)) {
 		spin_unlock(&info->lock);
 		error = PTR_ERR(entry);
@@ -1305,12 +1309,12 @@ repeat:
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
 			/* here we actually do the io */
-			if (type)
-				*type |= VM_FAULT_MAJOR;
+			if (fault_type)
+				*fault_type |= VM_FAULT_MAJOR;
 			swappage = shmem_swapin(swap, gfp, info, idx);
 			if (!swappage) {
 				spin_lock(&info->lock);
-				entry = shmem_swp_alloc(info, idx, sgp);
+				entry = shmem_swp_alloc(info, idx, sgp, gfp);
 				if (IS_ERR(entry))
 					error = PTR_ERR(entry);
 				else {
@@ -1461,7 +1465,7 @@ repeat:
 				SetPageSwapBacked(filepage);
 			}
 
-			entry = shmem_swp_alloc(info, idx, sgp);
+			entry = shmem_swp_alloc(info, idx, sgp, gfp);
 			if (IS_ERR(entry))
 				error = PTR_ERR(entry);
 			else {
@@ -1539,7 +1543,7 @@ static int shmem_fault(struct vm_area_st
 {
 	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 	int error;
-	int ret;
+	int ret = VM_FAULT_LOCKED;
 
 	if (((loff_t)vmf->pgoff << PAGE_CACHE_SHIFT) >= i_size_read(inode))
 		return VM_FAULT_SIGBUS;
@@ -1547,11 +1551,12 @@ static int shmem_fault(struct vm_area_st
 	error = shmem_getpage(inode, vmf->pgoff, &vmf->page, SGP_CACHE, &ret);
 	if (error)
 		return ((error == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS);
+
 	if (ret & VM_FAULT_MAJOR) {
 		count_vm_event(PGMAJFAULT);
 		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
 	}
-	return ret | VM_FAULT_LOCKED;
+	return ret;
 }
 
 #ifdef CONFIG_NUMA
@@ -3162,13 +3167,29 @@ int shmem_zero_setup(struct vm_area_stru
  * suit tmpfs, since it may have pages in swapcache, and needs to find those
  * for itself; although drivers/gpu/drm i915 and ttm rely upon this support.
  *
- * Provide a stub for those callers to start using now, then later
- * flesh it out to call shmem_getpage() with additional gfp mask, when
- * shmem_file_splice_read() is added and shmem_readpage() is removed.
+ * i915_gem_object_get_pages_gtt() mixes __GFP_NORETRY | __GFP_NOWARN in
+ * with the mapping_gfp_mask(), to avoid OOMing the machine unnecessarily.
  */
 struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 					 pgoff_t index, gfp_t gfp)
 {
+#ifdef CONFIG_SHMEM
+	struct inode *inode = mapping->host;
+	struct page *page = NULL;
+	int error;
+
+	BUG_ON(mapping->a_ops != &shmem_aops);
+	error = shmem_getpage_gfp(inode, index, &page, SGP_CACHE, gfp, NULL);
+	if (error)
+		page = ERR_PTR(error);
+	else
+		unlock_page(page);
+	return page;
+#else
+	/*
+	 * The tiny !SHMEM case uses ramfs without swap
+	 */
 	return read_cache_page_gfp(mapping, index, gfp);
+#endif
 }
 EXPORT_SYMBOL_GPL(shmem_read_mapping_page_gfp);
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

