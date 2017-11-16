From: akpm@linux-foundation.org
Subject: [merged]
 mm-swap-skip-swapcache-for-swapin-of-synchronous-device.patch removed from
 -mm tree
Date: Thu, 16 Nov 2017 12:00:14 -0800
Message-ID: <20171116200014.9iGQK70Dd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46162 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934703AbdKPUAQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:00:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axboe@kernel.dk, dan.j.williams@intel.com, hch@lst.de, hughd@google.com, idryomov@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, sergey.senozhatsky@gmail.com, ying.huang@intel.com


The patch titled
     Subject: mm, swap: skip swapcache for swapin of synchronous device
has been removed from the -mm tree.  Its filename was
     mm-swap-skip-swapcache-for-swapin-of-synchronous-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm, swap: skip swapcache for swapin of synchronous device

With fast swap storage, the platforms want to use swap more aggressively
and swap-in is crucial to application latency.

The rw_page() based synchronous devices like zram, pmem and btt are such
fast storage.  When I profile swapin performance with zram lz4 decompress
test, S/W overhead is more than 70%.  Maybe, it would be bigger in nvdimm.

This patch aims to reduce swap-in latency by skipping swapcache if the
swap device is synchronous device like rw_page based device.  It enhances
45% my swapin test(5G sequential swapin, no readahead, from 2.41sec to
1.64sec).

Link: http://lkml.kernel.org/r/1505886205-9671-5-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   11 ++++++++
 mm/memory.c          |   52 ++++++++++++++++++++++++++++-------------
 mm/page_io.c         |    6 ++--
 mm/swapfile.c        |   11 +++++---
 4 files changed, 57 insertions(+), 23 deletions(-)

diff -puN include/linux/swap.h~mm-swap-skip-swapcache-for-swapin-of-synchronous-device include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-skip-swapcache-for-swapin-of-synchronous-device
+++ a/include/linux/swap.h
@@ -466,6 +466,7 @@ extern int page_swapcount(struct page *)
 extern int __swp_swapcount(swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *page_swap_info(struct page *);
+extern struct swap_info_struct *swp_swap_info(swp_entry_t entry);
 extern bool reuse_swap_page(struct page *, int *);
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
@@ -474,6 +475,16 @@ extern void exit_swap_address_space(unsi
 
 #else /* CONFIG_SWAP */
 
+static inline int swap_readpage(struct page *page, bool do_poll)
+{
+	return 0;
+}
+
+static inline struct swap_info_struct *swp_swap_info(swp_entry_t entry)
+{
+	return NULL;
+}
+
 #define swap_address_space(entry)		(NULL)
 #define get_nr_swap_pages()			0L
 #define total_swap_pages			0L
diff -puN mm/memory.c~mm-swap-skip-swapcache-for-swapin-of-synchronous-device mm/memory.c
--- a/mm/memory.c~mm-swap-skip-swapcache-for-swapin-of-synchronous-device
+++ a/mm/memory.c
@@ -2842,7 +2842,7 @@ EXPORT_SYMBOL(unmap_mapping_range);
 int do_swap_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct page *page = NULL, *swapcache;
+	struct page *page = NULL, *swapcache = NULL;
 	struct mem_cgroup *memcg;
 	struct vma_swap_readahead swap_ra;
 	swp_entry_t entry;
@@ -2881,17 +2881,35 @@ int do_swap_page(struct vm_fault *vmf)
 		}
 		goto out;
 	}
+
+
 	delayacct_set_flag(DELAYACCT_PF_SWAPIN);
 	if (!page)
 		page = lookup_swap_cache(entry, vma_readahead ? vma : NULL,
 					 vmf->address);
 	if (!page) {
-		if (vma_readahead)
-			page = do_swap_page_readahead(entry,
-				GFP_HIGHUSER_MOVABLE, vmf, &swap_ra);
-		else
-			page = swapin_readahead(entry,
-				GFP_HIGHUSER_MOVABLE, vma, vmf->address);
+		struct swap_info_struct *si = swp_swap_info(entry);
+
+		if (!(si->flags & SWP_SYNCHRONOUS_IO)) {
+			if (vma_readahead)
+				page = do_swap_page_readahead(entry,
+					GFP_HIGHUSER_MOVABLE, vmf, &swap_ra);
+			else
+				page = swapin_readahead(entry,
+					GFP_HIGHUSER_MOVABLE, vma, vmf->address);
+			swapcache = page;
+		} else {
+			/* skip swapcache */
+			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vmf->address);
+			if (page) {
+				__SetPageLocked(page);
+				__SetPageSwapBacked(page);
+				set_page_private(page, entry.val);
+				lru_cache_add_anon(page);
+				swap_readpage(page, true);
+			}
+		}
+
 		if (!page) {
 			/*
 			 * Back out if somebody else faulted in this pte
@@ -2920,7 +2938,6 @@ int do_swap_page(struct vm_fault *vmf)
 		goto out_release;
 	}
 
-	swapcache = page;
 	locked = lock_page_or_retry(page, vma->vm_mm, vmf->flags);
 
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
@@ -2935,7 +2952,8 @@ int do_swap_page(struct vm_fault *vmf)
 	 * test below, are not enough to exclude that.  Even if it is still
 	 * swapcache, we need to check that the page's swap has not changed.
 	 */
-	if (unlikely(!PageSwapCache(page) || page_private(page) != entry.val))
+	if (unlikely((!PageSwapCache(page) ||
+			page_private(page) != entry.val)) && swapcache)
 		goto out_page;
 
 	page = ksm_might_need_to_copy(page, vma, vmf->address);
@@ -2988,14 +3006,16 @@ int do_swap_page(struct vm_fault *vmf)
 		pte = pte_mksoft_dirty(pte);
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
 	vmf->orig_pte = pte;
-	if (page == swapcache) {
-		do_page_add_anon_rmap(page, vma, vmf->address, exclusive);
-		mem_cgroup_commit_charge(page, memcg, true, false);
-		activate_page(page);
-	} else { /* ksm created a completely new copy */
+
+	/* ksm created a completely new copy */
+	if (unlikely(page != swapcache && swapcache)) {
 		page_add_new_anon_rmap(page, vma, vmf->address, false);
 		mem_cgroup_commit_charge(page, memcg, false, false);
 		lru_cache_add_active_or_unevictable(page, vma);
+	} else {
+		do_page_add_anon_rmap(page, vma, vmf->address, exclusive);
+		mem_cgroup_commit_charge(page, memcg, true, false);
+		activate_page(page);
 	}
 
 	swap_free(entry);
@@ -3003,7 +3023,7 @@ int do_swap_page(struct vm_fault *vmf)
 	    (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
 		try_to_free_swap(page);
 	unlock_page(page);
-	if (page != swapcache) {
+	if (page != swapcache && swapcache) {
 		/*
 		 * Hold the lock to avoid the swap entry to be reused
 		 * until we take the PT lock for the pte_same() check
@@ -3036,7 +3056,7 @@ out_page:
 	unlock_page(page);
 out_release:
 	put_page(page);
-	if (page != swapcache) {
+	if (page != swapcache && swapcache) {
 		unlock_page(swapcache);
 		put_page(swapcache);
 	}
diff -puN mm/page_io.c~mm-swap-skip-swapcache-for-swapin-of-synchronous-device mm/page_io.c
--- a/mm/page_io.c~mm-swap-skip-swapcache-for-swapin-of-synchronous-device
+++ a/mm/page_io.c
@@ -347,7 +347,7 @@ out:
 	return ret;
 }
 
-int swap_readpage(struct page *page, bool do_poll)
+int swap_readpage(struct page *page, bool synchronous)
 {
 	struct bio *bio;
 	int ret = 0;
@@ -355,7 +355,7 @@ int swap_readpage(struct page *page, boo
 	blk_qc_t qc;
 	struct gendisk *disk;
 
-	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
+	VM_BUG_ON_PAGE(!PageSwapCache(page) && !synchronous, page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageUptodate(page), page);
 	if (frontswap_load(page) == 0) {
@@ -403,7 +403,7 @@ int swap_readpage(struct page *page, boo
 	count_vm_event(PSWPIN);
 	bio_get(bio);
 	qc = submit_bio(bio);
-	while (do_poll) {
+	while (synchronous) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (!READ_ONCE(bio->bi_private))
 			break;
diff -puN mm/swapfile.c~mm-swap-skip-swapcache-for-swapin-of-synchronous-device mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-skip-swapcache-for-swapin-of-synchronous-device
+++ a/mm/swapfile.c
@@ -3455,10 +3455,15 @@ int swapcache_prepare(swp_entry_t entry)
 	return __swap_duplicate(entry, SWAP_HAS_CACHE);
 }
 
+struct swap_info_struct *swp_swap_info(swp_entry_t entry)
+{
+	return swap_info[swp_type(entry)];
+}
+
 struct swap_info_struct *page_swap_info(struct page *page)
 {
-	swp_entry_t swap = { .val = page_private(page) };
-	return swap_info[swp_type(swap)];
+	swp_entry_t entry = { .val = page_private(page) };
+	return swp_swap_info(entry);
 }
 
 /*
@@ -3466,7 +3471,6 @@ struct swap_info_struct *page_swap_info(
  */
 struct address_space *__page_file_mapping(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
 	return page_swap_info(page)->swap_file->f_mapping;
 }
 EXPORT_SYMBOL_GPL(__page_file_mapping);
@@ -3474,7 +3478,6 @@ EXPORT_SYMBOL_GPL(__page_file_mapping);
 pgoff_t __page_file_index(struct page *page)
 {
 	swp_entry_t swap = { .val = page_private(page) };
-	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
 	return swp_offset(swap);
 }
 EXPORT_SYMBOL_GPL(__page_file_index);
_

Patches currently in -mm which might be from minchan@kernel.org are


