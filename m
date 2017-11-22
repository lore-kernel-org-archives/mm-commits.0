From: akpm@linux-foundation.org
Subject: + mm-swap-unify-cluster-based-and-vma-based-swap-readahead.patch
 added to -mm tree
Date: Tue, 21 Nov 2017 16:00:27 -0800
Message-ID: <5a14be1b.+N+HJi8gBy2zDX07%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41316 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbdKVAA3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 19:00:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hughd@google.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: swap: unify cluster-based and vma-based swap readahead
has been added to the -mm tree.  Its filename is
     mm-swap-unify-cluster-based-and-vma-based-swap-readahead.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-unify-cluster-based-and-vma-based-swap-readahead.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-unify-cluster-based-and-vma-based-swap-readahead.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: swap: unify cluster-based and vma-based swap readahead

This patch makes do_swap_page() not need to be aware of two different swap
readahead algorithms.  Just unify cluster-based and vma-based readahead
function call.

Link: http://lkml.kernel.org/r/1509520520-32367-3-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   27 ++++++-----------------
 mm/memory.c          |   11 +++------
 mm/shmem.c           |    5 +++-
 mm/swap_state.c      |   48 +++++++++++++++++++++++++++++++----------
 4 files changed, 53 insertions(+), 38 deletions(-)

diff -puN include/linux/swap.h~mm-swap-unify-cluster-based-and-vma-based-swap-readahead include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-unify-cluster-based-and-vma-based-swap-readahead
+++ a/include/linux/swap.h
@@ -401,7 +401,6 @@ int generic_swapfile_activate(struct swa
 #define SWAP_ADDRESS_SPACE_SHIFT	14
 #define SWAP_ADDRESS_SPACE_PAGES	(1 << SWAP_ADDRESS_SPACE_SHIFT)
 extern struct address_space *swapper_spaces[];
-extern bool swap_vma_readahead;
 #define swap_address_space(entry)			    \
 	(&swapper_spaces[swp_type(entry)][swp_offset(entry) \
 		>> SWAP_ADDRESS_SPACE_SHIFT])
@@ -423,10 +422,10 @@ extern struct page *read_swap_cache_asyn
 extern struct page *__read_swap_cache_async(swp_entry_t, gfp_t,
 			struct vm_area_struct *vma, unsigned long addr,
 			bool *new_page_allocated);
-extern struct page *swapin_readahead(swp_entry_t, gfp_t,
-			struct vm_area_struct *vma, unsigned long addr);
-extern struct page *do_swap_page_readahead(swp_entry_t fentry, gfp_t gfp_mask,
-					   struct vm_fault *vmf);
+extern struct page *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
+				struct vm_fault *vmf);
+extern struct page *swapin_readahead(swp_entry_t entry, gfp_t flag,
+				struct vm_fault *vmf);
 
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
@@ -434,11 +433,6 @@ extern long total_swap_pages;
 extern atomic_t nr_rotate_swap;
 extern bool has_usable_swap(void);
 
-static inline bool swap_use_vma_readahead(void)
-{
-	return READ_ONCE(swap_vma_readahead) && !atomic_read(&nr_rotate_swap);
-}
-
 /* Swap 50% full? Release swapcache more aggressively.. */
 static inline bool vm_swap_full(void)
 {
@@ -534,19 +528,14 @@ static inline void put_swap_page(struct
 {
 }
 
-static inline struct page *swapin_readahead(swp_entry_t swp, gfp_t gfp_mask,
-			struct vm_area_struct *vma, unsigned long addr)
+static inline struct page *swap_cluster_readahead(swp_entry_t entry,
+				gfp_t gfp_mask, struct vm_fault *vmf)
 {
 	return NULL;
 }
 
-static inline bool swap_use_vma_readahead(void)
-{
-	return false;
-}
-
-static inline struct page *do_swap_page_readahead(swp_entry_t fentry,
-				gfp_t gfp_mask, struct vm_fault *vmf)
+static inline struct page *swapin_readahead(swp_entry_t swp, gfp_t gfp_mask,
+			struct vm_fault *vmf)
 {
 	return NULL;
 }
diff -puN mm/memory.c~mm-swap-unify-cluster-based-and-vma-based-swap-readahead mm/memory.c
--- a/mm/memory.c~mm-swap-unify-cluster-based-and-vma-based-swap-readahead
+++ a/mm/memory.c
@@ -2889,7 +2889,8 @@ int do_swap_page(struct vm_fault *vmf)
 		if (si->flags & SWP_SYNCHRONOUS_IO &&
 				__swap_count(si, entry) == 1) {
 			/* skip swapcache */
-			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vmf->address);
+			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma,
+							vmf->address);
 			if (page) {
 				__SetPageLocked(page);
 				__SetPageSwapBacked(page);
@@ -2898,12 +2899,8 @@ int do_swap_page(struct vm_fault *vmf)
 				swap_readpage(page, true);
 			}
 		} else {
-			if (swap_use_vma_readahead())
-				page = do_swap_page_readahead(entry,
-					GFP_HIGHUSER_MOVABLE, vmf);
-			else
-				page = swapin_readahead(entry,
-				       GFP_HIGHUSER_MOVABLE, vma, vmf->address);
+			page = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE,
+						vmf);
 			swapcache = page;
 		}
 
diff -puN mm/shmem.c~mm-swap-unify-cluster-based-and-vma-based-swap-readahead mm/shmem.c
--- a/mm/shmem.c~mm-swap-unify-cluster-based-and-vma-based-swap-readahead
+++ a/mm/shmem.c
@@ -1413,9 +1413,12 @@ static struct page *shmem_swapin(swp_ent
 {
 	struct vm_area_struct pvma;
 	struct page *page;
+	struct vm_fault vmf;
 
 	shmem_pseudo_vma_init(&pvma, info, index);
-	page = swapin_readahead(swap, gfp, &pvma, 0);
+	vmf.vma = &pvma;
+	vmf.address = 0;
+	page = swap_cluster_readahead(swap, gfp, &vmf);
 	shmem_pseudo_vma_destroy(&pvma);
 
 	return page;
diff -puN mm/swap_state.c~mm-swap-unify-cluster-based-and-vma-based-swap-readahead mm/swap_state.c
--- a/mm/swap_state.c~mm-swap-unify-cluster-based-and-vma-based-swap-readahead
+++ a/mm/swap_state.c
@@ -38,7 +38,7 @@ static const struct address_space_operat
 
 struct address_space *swapper_spaces[MAX_SWAPFILES] __read_mostly;
 static unsigned int nr_swapper_spaces[MAX_SWAPFILES] __read_mostly;
-bool swap_vma_readahead __read_mostly = true;
+bool enable_vma_readahead __read_mostly = true;
 
 #define SWAP_RA_WIN_SHIFT	(PAGE_SHIFT / 2)
 #define SWAP_RA_HITS_MASK	((1UL << SWAP_RA_WIN_SHIFT) - 1)
@@ -322,6 +322,11 @@ void free_pages_and_swap_cache(struct pa
 	release_pages(pagep, nr);
 }
 
+static inline bool swap_use_vma_readahead(void)
+{
+	return READ_ONCE(enable_vma_readahead) && !atomic_read(&nr_rotate_swap);
+}
+
 /*
  * Lookup a swap entry in the swap cache. A found page will be returned
  * unlocked and with its refcount incremented - we rely on the kernel
@@ -539,11 +544,10 @@ static unsigned long swapin_nr_pages(uns
 }
 
 /**
- * swapin_readahead - swap in pages in hope we need them soon
+ * swap_cluster_readahead - swap in pages in hope we need them soon
  * @entry: swap entry of this memory
  * @gfp_mask: memory allocation flags
- * @vma: user vma this address belongs to
- * @addr: target address for mempolicy
+ * @vmf: fault information
  *
  * Returns the struct page for entry and addr, after queueing swapin.
  *
@@ -555,10 +559,10 @@ static unsigned long swapin_nr_pages(uns
  * This has been extended to use the NUMA policies from the mm triggering
  * the readahead.
  *
- * Caller must hold down_read on the vma->vm_mm if vma is not NULL.
+ * Caller must hold down_read on the vma->vm_mm if vmf->vma is not NULL.
  */
-struct page *swapin_readahead(swp_entry_t entry, gfp_t gfp_mask,
-			struct vm_area_struct *vma, unsigned long addr)
+struct page *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
+				struct vm_fault *vmf)
 {
 	struct page *page;
 	unsigned long entry_offset = swp_offset(entry);
@@ -568,6 +572,8 @@ struct page *swapin_readahead(swp_entry_
 	struct swap_info_struct *si = swp_swap_info(entry);
 	struct blk_plug plug;
 	bool do_poll = true, page_allocated;
+	struct vm_area_struct *vma = vmf->vma;
+	unsigned long addr = vmf->address;
 
 	mask = swapin_nr_pages(offset) - 1;
 	if (!mask)
@@ -723,7 +729,7 @@ static void swap_ra_info(struct vm_fault
 	pte_unmap(orig_pte);
 }
 
-struct page *do_swap_page_readahead(swp_entry_t fentry, gfp_t gfp_mask,
+struct page *swap_vma_readahead(swp_entry_t fentry, gfp_t gfp_mask,
 				    struct vm_fault *vmf)
 {
 	struct blk_plug plug;
@@ -771,20 +777,40 @@ skip:
 				     ra_info.win == 1);
 }
 
+/**
+ * swapin_readahead - swap in pages in hope we need them soon
+ * @entry: swap entry of this memory
+ * @gfp_mask: memory allocation flags
+ * @vmf: fault information
+ *
+ * Returns the struct page for entry and addr, after queueing swapin.
+ *
+ * It's a main entry function for swap readahead. By the configuration,
+ * it will read ahead blocks by cluster-based(ie, physical disk based)
+ * or vma-based(ie, virtual address based on faulty address) readahead.
+ */
+struct page *swapin_readahead(swp_entry_t entry, gfp_t gfp_mask,
+				struct vm_fault *vmf)
+{
+	return swap_use_vma_readahead() ?
+			swap_vma_readahead(entry, gfp_mask, vmf) :
+			swap_cluster_readahead(entry, gfp_mask, vmf);
+}
+
 #ifdef CONFIG_SYSFS
 static ssize_t vma_ra_enabled_show(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%s\n", swap_vma_readahead ? "true" : "false");
+	return sprintf(buf, "%s\n", enable_vma_readahead ? "true" : "false");
 }
 static ssize_t vma_ra_enabled_store(struct kobject *kobj,
 				      struct kobj_attribute *attr,
 				      const char *buf, size_t count)
 {
 	if (!strncmp(buf, "true", 4) || !strncmp(buf, "1", 1))
-		swap_vma_readahead = true;
+		enable_vma_readahead = true;
 	else if (!strncmp(buf, "false", 5) || !strncmp(buf, "0", 1))
-		swap_vma_readahead = false;
+		enable_vma_readahead = false;
 	else
 		return -EINVAL;
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-swap-clean-up-swap-readahead.patch
mm-swap-unify-cluster-based-and-vma-based-swap-readahead.patch

