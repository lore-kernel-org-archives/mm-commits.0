From: akpm@linux-foundation.org
Subject: - swapin_readahead-move-and-rearrange-args.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:29:59 -0800
Message-ID: <200802052229.m15MTeRA011997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35467 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761181AbYBEWnr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     swapin_readahead: move and rearrange args
has been removed from the -mm tree.  Its filename was
     swapin_readahead-move-and-rearrange-args.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swapin_readahead: move and rearrange args
From: Hugh Dickins <hugh@veritas.com>

swapin_readahead has never sat well in mm/memory.c: move it to mm/swap_state.c
beside its kindred read_swap_cache_async.  Why were its args in a different
order?  rearrange them.  And since it was always followed by a
read_swap_cache_async of the target page, fold that in and return struct
page*.  Then CONFIG_SWAP=n no longer needs valid_swaphandles and
read_swap_cache_async stubs.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   19 ++++++----------
 mm/memory.c          |   45 ---------------------------------------
 mm/shmem.c           |    6 +----
 mm/swap_state.c      |   47 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 57 insertions(+), 60 deletions(-)

diff -puN include/linux/swap.h~swapin_readahead-move-and-rearrange-args include/linux/swap.h
--- a/include/linux/swap.h~swapin_readahead-move-and-rearrange-args
+++ a/include/linux/swap.h
@@ -158,9 +158,6 @@ struct swap_list_t {
 /* Swap 50% full? Release swapcache more aggressively.. */
 #define vm_swap_full() (nr_swap_pages*2 < total_swap_pages)
 
-/* linux/mm/memory.c */
-extern void swapin_readahead(swp_entry_t, unsigned long, struct vm_area_struct *);
-
 /* linux/mm/page_alloc.c */
 extern unsigned long totalram_pages;
 extern unsigned long totalreserve_pages;
@@ -230,9 +227,12 @@ extern int move_from_swap_cache(struct p
 		struct address_space *);
 extern void free_page_and_swap_cache(struct page *);
 extern void free_pages_and_swap_cache(struct page **, int);
-extern struct page * lookup_swap_cache(swp_entry_t);
-extern struct page * read_swap_cache_async(swp_entry_t, struct vm_area_struct *vma,
-					   unsigned long addr);
+extern struct page *lookup_swap_cache(swp_entry_t);
+extern struct page *read_swap_cache_async(swp_entry_t,
+			struct vm_area_struct *vma, unsigned long addr);
+extern struct page *swapin_readahead(swp_entry_t,
+			struct vm_area_struct *vma, unsigned long addr);
+
 /* linux/mm/swapfile.c */
 extern long total_swap_pages;
 extern unsigned int nr_swapfiles;
@@ -306,7 +306,7 @@ static inline void swap_free(swp_entry_t
 {
 }
 
-static inline struct page *read_swap_cache_async(swp_entry_t swp,
+static inline struct page *swapin_readahead(swp_entry_t swp,
 			struct vm_area_struct *vma, unsigned long addr)
 {
 	return NULL;
@@ -317,11 +317,6 @@ static inline struct page *lookup_swap_c
 	return NULL;
 }
 
-static inline int valid_swaphandles(swp_entry_t entry, unsigned long *offset)
-{
-	return 0;
-}
-
 #define can_share_swap_page(p)			(page_mapcount(p) == 1)
 
 static inline int move_to_swap_cache(struct page *page, swp_entry_t entry)
diff -puN mm/memory.c~swapin_readahead-move-and-rearrange-args mm/memory.c
--- a/mm/memory.c~swapin_readahead-move-and-rearrange-args
+++ a/mm/memory.c
@@ -1980,48 +1980,6 @@ int vmtruncate_range(struct inode *inode
 	return 0;
 }
 
-/**
- * swapin_readahead - swap in pages in hope we need them soon
- * @entry: swap entry of this memory
- * @addr: address to start
- * @vma: user vma this addresses belong to
- *
- * Primitive swap readahead code. We simply read an aligned block of
- * (1 << page_cluster) entries in the swap area. This method is chosen
- * because it doesn't cost us any seek time.  We also make sure to queue
- * the 'original' request together with the readahead ones...
- *
- * This has been extended to use the NUMA policies from the mm triggering
- * the readahead.
- *
- * Caller must hold down_read on the vma->vm_mm if vma is not NULL.
- */
-void swapin_readahead(swp_entry_t entry, unsigned long addr,struct vm_area_struct *vma)
-{
-	int nr_pages;
-	struct page *page;
-	unsigned long offset;
-	unsigned long end_offset;
-
-	/*
-	 * Get starting offset for readaround, and number of pages to read.
-	 * Adjust starting address by readbehind (for NUMA interleave case)?
-	 * No, it's very unlikely that swap layout would follow vma layout,
-	 * more likely that neighbouring swap pages came from the same node:
-	 * so use the same "addr" to choose the same node for each swap read.
-	 */
-	nr_pages = valid_swaphandles(entry, &offset);
-	for (end_offset = offset + nr_pages; offset < end_offset; offset++) {
-		/* Ok, do the async read-ahead now */
-		page = read_swap_cache_async(swp_entry(swp_type(entry), offset),
-						vma, addr);
-		if (!page)
-			break;
-		page_cache_release(page);
-	}
-	lru_add_drain();	/* Push any new pages onto the LRU now */
-}
-
 /*
  * We enter with non-exclusive mmap_sem (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
@@ -2049,8 +2007,7 @@ static int do_swap_page(struct mm_struct
 	page = lookup_swap_cache(entry);
 	if (!page) {
 		grab_swap_token(); /* Contend for token _before_ read-in */
- 		swapin_readahead(entry, address, vma);
- 		page = read_swap_cache_async(entry, vma, address);
+		page = swapin_readahead(entry, vma, address);
 		if (!page) {
 			/*
 			 * Back out if somebody else faulted in this pte
diff -puN mm/shmem.c~swapin_readahead-move-and-rearrange-args mm/shmem.c
--- a/mm/shmem.c~swapin_readahead-move-and-rearrange-args
+++ a/mm/shmem.c
@@ -1036,8 +1036,7 @@ static struct page *shmem_swapin(struct 
 	pvma.vm_pgoff = idx;
 	pvma.vm_ops = NULL;
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, idx);
-	swapin_readahead(entry, 0, &pvma);
-	page = read_swap_cache_async(entry, &pvma, 0);
+	page = swapin_readahead(entry, &pvma, 0);
 	mpol_free(pvma.vm_policy);
 	return page;
 }
@@ -1067,8 +1066,7 @@ static inline int shmem_parse_mpol(char 
 static inline struct page *
 shmem_swapin(struct shmem_inode_info *info,swp_entry_t entry,unsigned long idx)
 {
-	swapin_readahead(entry, 0, NULL);
-	return read_swap_cache_async(entry, NULL, 0);
+	return swapin_readahead(entry, NULL, 0);
 }
 
 static inline struct page *
diff -puN mm/swap_state.c~swapin_readahead-move-and-rearrange-args mm/swap_state.c
--- a/mm/swap_state.c~swapin_readahead-move-and-rearrange-args
+++ a/mm/swap_state.c
@@ -10,6 +10,7 @@
 #include <linux/mm.h>
 #include <linux/kernel_stat.h>
 #include <linux/swap.h>
+#include <linux/swapops.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
@@ -368,3 +369,49 @@ struct page *read_swap_cache_async(swp_e
 		page_cache_release(new_page);
 	return found_page;
 }
+
+/**
+ * swapin_readahead - swap in pages in hope we need them soon
+ * @entry: swap entry of this memory
+ * @vma: user vma this address belongs to
+ * @addr: target address for mempolicy
+ *
+ * Returns the struct page for entry and addr, after queueing swapin.
+ *
+ * Primitive swap readahead code. We simply read an aligned block of
+ * (1 << page_cluster) entries in the swap area. This method is chosen
+ * because it doesn't cost us any seek time.  We also make sure to queue
+ * the 'original' request together with the readahead ones...
+ *
+ * This has been extended to use the NUMA policies from the mm triggering
+ * the readahead.
+ *
+ * Caller must hold down_read on the vma->vm_mm if vma is not NULL.
+ */
+struct page *swapin_readahead(swp_entry_t entry,
+			struct vm_area_struct *vma, unsigned long addr)
+{
+	int nr_pages;
+	struct page *page;
+	unsigned long offset;
+	unsigned long end_offset;
+
+	/*
+	 * Get starting offset for readaround, and number of pages to read.
+	 * Adjust starting address by readbehind (for NUMA interleave case)?
+	 * No, it's very unlikely that swap layout would follow vma layout,
+	 * more likely that neighbouring swap pages came from the same node:
+	 * so use the same "addr" to choose the same node for each swap read.
+	 */
+	nr_pages = valid_swaphandles(entry, &offset);
+	for (end_offset = offset + nr_pages; offset < end_offset; offset++) {
+		/* Ok, do the async read-ahead now */
+		page = read_swap_cache_async(swp_entry(swp_type(entry), offset),
+						vma, addr);
+		if (!page)
+			break;
+		page_cache_release(page);
+	}
+	lru_add_drain();	/* Push any new pages onto the LRU now */
+	return read_swap_cache_async(entry, vma, addr);
+}
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
