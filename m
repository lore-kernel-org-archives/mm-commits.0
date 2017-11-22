From: akpm@linux-foundation.org
Subject: + mm-swap-clean-up-swap-readahead.patch added to -mm tree
Date: Tue, 21 Nov 2017 16:00:24 -0800
Message-ID: <5a14be18.LO5aZHzBgoIMvIUX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41306 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbdKVAAZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 19:00:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hughd@google.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: swap: clean up swap readahead
has been added to the -mm tree.  Its filename is
     mm-swap-clean-up-swap-readahead.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-clean-up-swap-readahead.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-clean-up-swap-readahead.patch

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
Subject: mm: swap: clean up swap readahead

When I see recent change of swap readahead, I am very unhappy about
current code structure which diverges two swap readahead algorithm in
do_swap_page.  This patch is to clean it up.

Main motivation is that fault handler doesn't need to be aware of
readahead algorithms but just should call swapin_readahead.

As first step, this patch cleans up a little bit but not perfect (I just
separate for review easier) so next patch will make the goal complete.

Link: http://lkml.kernel.org/r/1509520520-32367-2-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   17 +------
 mm/memory.c          |   17 +------
 mm/swap_state.c      |   89 ++++++++++++++++++++++-------------------
 3 files changed, 55 insertions(+), 68 deletions(-)

diff -puN include/linux/swap.h~mm-swap-clean-up-swap-readahead include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-clean-up-swap-readahead
+++ a/include/linux/swap.h
@@ -425,12 +425,8 @@ extern struct page *__read_swap_cache_as
 			bool *new_page_allocated);
 extern struct page *swapin_readahead(swp_entry_t, gfp_t,
 			struct vm_area_struct *vma, unsigned long addr);
-
-extern struct page *swap_readahead_detect(struct vm_fault *vmf,
-					  struct vma_swap_readahead *swap_ra);
 extern struct page *do_swap_page_readahead(swp_entry_t fentry, gfp_t gfp_mask,
-					   struct vm_fault *vmf,
-					   struct vma_swap_readahead *swap_ra);
+					   struct vm_fault *vmf);
 
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
@@ -549,15 +545,8 @@ static inline bool swap_use_vma_readahea
 	return false;
 }
 
-static inline struct page *swap_readahead_detect(
-	struct vm_fault *vmf, struct vma_swap_readahead *swap_ra)
-{
-	return NULL;
-}
-
-static inline struct page *do_swap_page_readahead(
-	swp_entry_t fentry, gfp_t gfp_mask,
-	struct vm_fault *vmf, struct vma_swap_readahead *swap_ra)
+static inline struct page *do_swap_page_readahead(swp_entry_t fentry,
+				gfp_t gfp_mask, struct vm_fault *vmf)
 {
 	return NULL;
 }
diff -puN mm/memory.c~mm-swap-clean-up-swap-readahead mm/memory.c
--- a/mm/memory.c~mm-swap-clean-up-swap-readahead
+++ a/mm/memory.c
@@ -2849,21 +2849,14 @@ int do_swap_page(struct vm_fault *vmf)
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page = NULL, *swapcache = NULL;
 	struct mem_cgroup *memcg;
-	struct vma_swap_readahead swap_ra;
 	swp_entry_t entry;
 	pte_t pte;
 	int locked;
 	int exclusive = 0;
 	int ret = 0;
-	bool vma_readahead = swap_use_vma_readahead();
 
-	if (vma_readahead)
-		page = swap_readahead_detect(vmf, &swap_ra);
-	if (!pte_unmap_same(vma->vm_mm, vmf->pmd, vmf->pte, vmf->orig_pte)) {
-		if (page)
-			put_page(page);
+	if (!pte_unmap_same(vma->vm_mm, vmf->pmd, vmf->pte, vmf->orig_pte))
 		goto out;
-	}
 
 	entry = pte_to_swp_entry(vmf->orig_pte);
 	if (unlikely(non_swap_entry(entry))) {
@@ -2889,9 +2882,7 @@ int do_swap_page(struct vm_fault *vmf)
 
 
 	delayacct_set_flag(DELAYACCT_PF_SWAPIN);
-	if (!page)
-		page = lookup_swap_cache(entry, vma_readahead ? vma : NULL,
-					 vmf->address);
+	page = lookup_swap_cache(entry, vma, vmf->address);
 	if (!page) {
 		struct swap_info_struct *si = swp_swap_info(entry);
 
@@ -2907,9 +2898,9 @@ int do_swap_page(struct vm_fault *vmf)
 				swap_readpage(page, true);
 			}
 		} else {
-			if (vma_readahead)
+			if (swap_use_vma_readahead())
 				page = do_swap_page_readahead(entry,
-					GFP_HIGHUSER_MOVABLE, vmf, &swap_ra);
+					GFP_HIGHUSER_MOVABLE, vmf);
 			else
 				page = swapin_readahead(entry,
 				       GFP_HIGHUSER_MOVABLE, vma, vmf->address);
diff -puN mm/swap_state.c~mm-swap-clean-up-swap-readahead mm/swap_state.c
--- a/mm/swap_state.c~mm-swap-clean-up-swap-readahead
+++ a/mm/swap_state.c
@@ -332,32 +332,38 @@ struct page *lookup_swap_cache(swp_entry
 			       unsigned long addr)
 {
 	struct page *page;
-	unsigned long ra_info;
-	int win, hits, readahead;
 
 	page = find_get_page(swap_address_space(entry), swp_offset(entry));
 
 	INC_CACHE_INFO(find_total);
 	if (page) {
+		bool vma_ra = swap_use_vma_readahead();
+		bool readahead = TestClearPageReadahead(page);
+
 		INC_CACHE_INFO(find_success);
 		if (unlikely(PageTransCompound(page)))
 			return page;
-		readahead = TestClearPageReadahead(page);
-		if (vma) {
-			ra_info = GET_SWAP_RA_VAL(vma);
-			win = SWAP_RA_WIN(ra_info);
-			hits = SWAP_RA_HITS(ra_info);
+
+		if (vma && vma_ra) {
+			unsigned long ra_val;
+			int win, hits;
+
+			ra_val = GET_SWAP_RA_VAL(vma);
+			win = SWAP_RA_WIN(ra_val);
+			hits = SWAP_RA_HITS(ra_val);
 			if (readahead)
 				hits = min_t(int, hits + 1, SWAP_RA_HITS_MAX);
 			atomic_long_set(&vma->swap_readahead_info,
 					SWAP_RA_VAL(addr, win, hits));
 		}
+
 		if (readahead) {
 			count_vm_event(SWAP_RA_HIT);
-			if (!vma)
+			if (!vma || !vma_ra)
 				atomic_inc(&swapin_readahead_hits);
 		}
 	}
+
 	return page;
 }
 
@@ -649,16 +655,15 @@ static inline void swap_ra_clamp_pfn(str
 		    PFN_DOWN((faddr & PMD_MASK) + PMD_SIZE));
 }
 
-struct page *swap_readahead_detect(struct vm_fault *vmf,
-				   struct vma_swap_readahead *swap_ra)
+static void swap_ra_info(struct vm_fault *vmf,
+			struct vma_swap_readahead *ra_info)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	unsigned long swap_ra_info;
-	struct page *page;
+	unsigned long ra_val;
 	swp_entry_t entry;
 	unsigned long faddr, pfn, fpfn;
 	unsigned long start, end;
-	pte_t *pte;
+	pte_t *pte, *orig_pte;
 	unsigned int max_win, hits, prev_win, win, left;
 #ifndef CONFIG_64BIT
 	pte_t *tpte;
@@ -667,30 +672,32 @@ struct page *swap_readahead_detect(struc
 	max_win = 1 << min_t(unsigned int, READ_ONCE(page_cluster),
 			     SWAP_RA_ORDER_CEILING);
 	if (max_win == 1) {
-		swap_ra->win = 1;
-		return NULL;
+		ra_info->win = 1;
+		return;
 	}
 
 	faddr = vmf->address;
-	entry = pte_to_swp_entry(vmf->orig_pte);
-	if ((unlikely(non_swap_entry(entry))))
-		return NULL;
-	page = lookup_swap_cache(entry, vma, faddr);
-	if (page)
-		return page;
+	orig_pte = pte = pte_offset_map(vmf->pmd, faddr);
+	entry = pte_to_swp_entry(*pte);
+	if ((unlikely(non_swap_entry(entry)))) {
+		pte_unmap(orig_pte);
+		return;
+	}
 
 	fpfn = PFN_DOWN(faddr);
-	swap_ra_info = GET_SWAP_RA_VAL(vma);
-	pfn = PFN_DOWN(SWAP_RA_ADDR(swap_ra_info));
-	prev_win = SWAP_RA_WIN(swap_ra_info);
-	hits = SWAP_RA_HITS(swap_ra_info);
-	swap_ra->win = win = __swapin_nr_pages(pfn, fpfn, hits,
+	ra_val = GET_SWAP_RA_VAL(vma);
+	pfn = PFN_DOWN(SWAP_RA_ADDR(ra_val));
+	prev_win = SWAP_RA_WIN(ra_val);
+	hits = SWAP_RA_HITS(ra_val);
+	ra_info->win = win = __swapin_nr_pages(pfn, fpfn, hits,
 					       max_win, prev_win);
 	atomic_long_set(&vma->swap_readahead_info,
 			SWAP_RA_VAL(faddr, win, 0));
 
-	if (win == 1)
-		return NULL;
+	if (win == 1) {
+		pte_unmap(orig_pte);
+		return;
+	}
 
 	/* Copy the PTEs because the page table may be unmapped */
 	if (fpfn == pfn + 1)
@@ -703,23 +710,21 @@ struct page *swap_readahead_detect(struc
 		swap_ra_clamp_pfn(vma, faddr, fpfn - left, fpfn + win - left,
 				  &start, &end);
 	}
-	swap_ra->nr_pte = end - start;
-	swap_ra->offset = fpfn - start;
-	pte = vmf->pte - swap_ra->offset;
+	ra_info->nr_pte = end - start;
+	ra_info->offset = fpfn - start;
+	pte -= ra_info->offset;
 #ifdef CONFIG_64BIT
-	swap_ra->ptes = pte;
+	ra_info->ptes = pte;
 #else
-	tpte = swap_ra->ptes;
+	tpte = ra_info->ptes;
 	for (pfn = start; pfn != end; pfn++)
 		*tpte++ = *pte++;
 #endif
-
-	return NULL;
+	pte_unmap(orig_pte);
 }
 
 struct page *do_swap_page_readahead(swp_entry_t fentry, gfp_t gfp_mask,
-				    struct vm_fault *vmf,
-				    struct vma_swap_readahead *swap_ra)
+				    struct vm_fault *vmf)
 {
 	struct blk_plug plug;
 	struct vm_area_struct *vma = vmf->vma;
@@ -728,12 +733,14 @@ struct page *do_swap_page_readahead(swp_
 	swp_entry_t entry;
 	unsigned int i;
 	bool page_allocated;
+	struct vma_swap_readahead ra_info = {0,};
 
-	if (swap_ra->win == 1)
+	swap_ra_info(vmf, &ra_info);
+	if (ra_info.win == 1)
 		goto skip;
 
 	blk_start_plug(&plug);
-	for (i = 0, pte = swap_ra->ptes; i < swap_ra->nr_pte;
+	for (i = 0, pte = ra_info.ptes; i < ra_info.nr_pte;
 	     i++, pte++) {
 		pentry = *pte;
 		if (pte_none(pentry))
@@ -749,7 +756,7 @@ struct page *do_swap_page_readahead(swp_
 			continue;
 		if (page_allocated) {
 			swap_readpage(page, false);
-			if (i != swap_ra->offset &&
+			if (i != ra_info.offset &&
 			    likely(!PageTransCompound(page))) {
 				SetPageReadahead(page);
 				count_vm_event(SWAP_RA);
@@ -761,7 +768,7 @@ struct page *do_swap_page_readahead(swp_
 	lru_add_drain();
 skip:
 	return read_swap_cache_async(fentry, gfp_mask, vma, vmf->address,
-				     swap_ra->win == 1);
+				     ra_info.win == 1);
 }
 
 #ifdef CONFIG_SYSFS
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-swap-clean-up-swap-readahead.patch
mm-swap-unify-cluster-based-and-vma-based-swap-readahead.patch

