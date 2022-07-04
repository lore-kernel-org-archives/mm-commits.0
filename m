Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12CDCC43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbiGDBKR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbiGDBJ6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5CC630D
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03707B80C73
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA97C341C7;
        Mon,  4 Jul 2022 01:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896994;
        bh=gE7/RHgQ738pWcbkFJHRsmVqas46Jq19yHd21QndQrg=;
        h=Date:To:From:Subject:From;
        b=Rl1XgCEfLCkX2RwVpK18fgbo5pFK/f/mk/LVTpT+Q5l2mPSavgFR92SVjUNfIy92y
         4C2YCTp6KcrECQ0wS2i00k2soGlJNEu6DGolSFxL5oy1Q99cHoT/BdZAOb7zg5h8Ny
         C1/TLEIUPdIUGV34ChrAijKUvI6Yee9GSzRo3m/c=
Date:   Sun, 03 Jul 2022 18:09:54 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        songmuchun@bytedance.com, hughd@google.com, david@redhat.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-swap_cache_info-statistics.patch removed from -mm tree
Message-Id: <20220704010954.9FA97C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: remove swap_cache_info statistics
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-swap_cache_info-statistics.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap: remove swap_cache_info statistics
Date: Wed, 8 Jun 2022 22:40:31 +0800

swap_cache_info are not statistics that could be easily used to tune
system performance because they are not easily accessile.  Also they can't
provide really useful info when OOM occurs.  Remove these statistics can
also help mitigate unneeded global swap_cache_info cacheline contention.

Link: https://lkml.kernel.org/r/20220608144031.829-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   17 -----------------
 1 file changed, 17 deletions(-)

--- a/mm/swap_state.c~mm-swap-remove-swap_cache_info-statistics
+++ a/mm/swap_state.c
@@ -59,24 +59,11 @@ static bool enable_vma_readahead __read_
 #define GET_SWAP_RA_VAL(vma)					\
 	(atomic_long_read(&(vma)->swap_readahead_info) ? : 4)
 
-#define INC_CACHE_INFO(x)	data_race(swap_cache_info.x++)
-#define ADD_CACHE_INFO(x, nr)	data_race(swap_cache_info.x += (nr))
-
-static struct {
-	unsigned long add_total;
-	unsigned long del_total;
-	unsigned long find_success;
-	unsigned long find_total;
-} swap_cache_info;
-
 static atomic_t swapin_readahead_hits = ATOMIC_INIT(4);
 
 void show_swap_cache_info(void)
 {
 	printk("%lu pages in swap cache\n", total_swapcache_pages());
-	printk("Swap cache stats: add %lu, delete %lu, find %lu/%lu\n",
-		swap_cache_info.add_total, swap_cache_info.del_total,
-		swap_cache_info.find_success, swap_cache_info.find_total);
 	printk("Free swap  = %ldkB\n",
 		get_nr_swap_pages() << (PAGE_SHIFT - 10));
 	printk("Total swap = %lukB\n", total_swap_pages << (PAGE_SHIFT - 10));
@@ -133,7 +120,6 @@ int add_to_swap_cache(struct page *page,
 		address_space->nrpages += nr;
 		__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, nr);
 		__mod_lruvec_page_state(page, NR_SWAPCACHE, nr);
-		ADD_CACHE_INFO(add_total, nr);
 unlock:
 		xas_unlock_irq(&xas);
 	} while (xas_nomem(&xas, gfp));
@@ -172,7 +158,6 @@ void __delete_from_swap_cache(struct pag
 	address_space->nrpages -= nr;
 	__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, -nr);
 	__mod_lruvec_page_state(page, NR_SWAPCACHE, -nr);
-	ADD_CACHE_INFO(del_total, nr);
 }
 
 /**
@@ -348,12 +333,10 @@ struct page *lookup_swap_cache(swp_entry
 	page = find_get_page(swap_address_space(entry), swp_offset(entry));
 	put_swap_device(si);
 
-	INC_CACHE_INFO(find_total);
 	if (page) {
 		bool vma_ra = swap_use_vma_readahead();
 		bool readahead;
 
-		INC_CACHE_INFO(find_success);
 		/*
 		 * At the moment, we don't support PG_readahead for anon THP
 		 * so let's bail out rather than confusing the readahead stat.
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry.patch
mm-khugepaged-remove-unneeded-shmem_huge_enabled-check.patch
mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch
mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch
mm-khugepaged-minor-cleanup-for-collapse_file.patch
mm-khugepaged-use-helper-macro-__attr_rw.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch

