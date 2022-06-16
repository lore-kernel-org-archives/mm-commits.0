Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF9D1CCA47C
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jun 2022 20:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiFPUt3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 16:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378960AbiFPUs6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 16:48:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016C45F25B
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 13:48:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97858B825FB
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 20:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50EE0C3411C;
        Thu, 16 Jun 2022 20:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655412533;
        bh=byu9tslT+8VuIFJrV1VQFpZJAaWZBwbpXaEy19CbSok=;
        h=Date:To:From:Subject:From;
        b=udN7k9zLCT/XzRAoEE69mAPsnYA0fBlpNy9Gz8KoBP+cm2RLe3GWEDqW0a9jEG1NQ
         FWpM9LIoRLHIPd0Ke3CgjVdzLB0fTlZpYwJJvI2LgG2sUdZRA5jlERwgW84WSRUS4y
         yXs6i9RN4nZq7JGoKTdBXiTq1YqaAb2RW1KWAzRg=
Date:   Thu, 16 Jun 2022 13:48:52 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, surenb@google.com,
        shy828301@gmail.com, peterx@redhat.com, neilb@suse.de,
        mike.kravetz@oracle.com, dhowells@redhat.com, david@redhat.com,
        apopple@nvidia.com, aarcange@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch removed from -mm tree
Message-Id: <20220616204853.50EE0C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: try to free transhuge swapcache when possible
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/khugepaged: try to free transhuge swapcache when possible
Date: Sat, 11 Jun 2022 16:47:31 +0800

Transhuge swapcaches won't be freed in __collapse_huge_page_copy().  It's
because release_pte_page() is not called for these pages and thus
free_page_and_swap_cache can't grab the page lock.  These pages won't be
freed from swap cache even if we are the only user until next time
reclaim.  It shouldn't hurt indeed, but we could try to free these pages
to save more memory for system.

Link: https://lkml.kernel.org/r/20220611084731.55155-8-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: "Zach O'Keefe" <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 +++++
 mm/khugepaged.c      |    1 +
 mm/swap.h            |    5 -----
 3 files changed, 6 insertions(+), 5 deletions(-)

--- a/include/linux/swap.h~mm-khugepaged-try-to-free-transhuge-swapcache-when-possible
+++ a/include/linux/swap.h
@@ -455,6 +455,7 @@ static inline unsigned long total_swapca
 	return global_node_page_state(NR_SWAPCACHE);
 }
 
+extern void free_swap_cache(struct page *page);
 extern void free_page_and_swap_cache(struct page *);
 extern void free_pages_and_swap_cache(struct page **, int);
 /* linux/mm/swapfile.c */
@@ -539,6 +540,10 @@ static inline void put_swap_device(struc
 /* used to sanity check ptes in zap_pte_range when CONFIG_SWAP=0 */
 #define free_swap_and_cache(e) is_pfn_swap_entry(e)
 
+static inline void free_swap_cache(struct page *page)
+{
+}
+
 static inline int add_swap_count_continuation(swp_entry_t swp, gfp_t gfp_mask)
 {
 	return 0;
--- a/mm/khugepaged.c~mm-khugepaged-try-to-free-transhuge-swapcache-when-possible
+++ a/mm/khugepaged.c
@@ -756,6 +756,7 @@ static void __collapse_huge_page_copy(pt
 	list_for_each_entry_safe(src_page, tmp, compound_pagelist, lru) {
 		list_del(&src_page->lru);
 		release_pte_page(src_page);
+		free_swap_cache(src_page);
 	}
 }
 
--- a/mm/swap.h~mm-khugepaged-try-to-free-transhuge-swapcache-when-possible
+++ a/mm/swap.h
@@ -41,7 +41,6 @@ void __delete_from_swap_cache(struct pag
 void delete_from_swap_cache(struct page *page);
 void clear_shadow_from_swap_cache(int type, unsigned long begin,
 				  unsigned long end);
-void free_swap_cache(struct page *page);
 struct page *lookup_swap_cache(swp_entry_t entry,
 			       struct vm_area_struct *vma,
 			       unsigned long addr);
@@ -81,10 +80,6 @@ static inline struct address_space *swap
 	return NULL;
 }
 
-static inline void free_swap_cache(struct page *page)
-{
-}
-
 static inline void show_swap_cache_info(void)
 {
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

maintainers-add-myself-as-a-memory-failure-reviewer.patch
mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch
mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-memremap-fix-wrong-function-name-above-memremap_pages.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-vmscan-dont-try-to-reclaim-freed-folios.patch
lib-test_hmm-avoid-accessing-uninitialized-pages.patch
mm-memremap-fix-memunmap_pages-race-with-get_dev_pagemap.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch

