Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D77C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 103502224E
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709263;
	bh=msXJ2+90yXXAO+tlk1GUbqpQNbfJqQDP/L8xjHEClK4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=mk6EVK2c8XIwuOmvx9TLGmtAPW6k+u3GaOfSp7vvRUQtliGwrzpXHrLTABJqZpuNc
	 qk5ZJKJmVyqzB7fME3w6sEYRbbA0nCywPXzM/H0AcZYvjzP6ta6vrCW8W6M7u6Nq+B
	 wGkwhLg5bYKzp5/j1qrpSh2P6WotbPfYLM9mFipA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgJNVBC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbgJNVBC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:02 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DF022224E;
        Wed, 14 Oct 2020 21:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709243;
        bh=msXJ2+90yXXAO+tlk1GUbqpQNbfJqQDP/L8xjHEClK4=;
        h=Date:From:To:Subject:From;
        b=uT8yTMw0F+OLjCkcbm7tjZoXGf95Vf6x7YN0phOdUjsYd/ehYy7RcweJHYxL9ylGv
         Vu7JYMnEeDCQ/ppehhY/M+Ft5TdaZqA+fRWXTstlAEa6YHgRb0rZdrD3vXcNbKM3Ix
         3dGF4w+84LJPDX4tT8PC2GNeyWE8bg6bod8rFCh0=
Date:   Wed, 14 Oct 2020 14:00:42 -0700
From:   akpm@linux-foundation.org
To:     abdhalee@linux.vnet.ibm.com, anders.roxell@linaro.org,
        arnd@arndb.de, christophe.leroy@csgroup.eu, jcmvbkbc@gmail.com,
        joro@8bytes.org, luto@kernel.org, mm-commits@vger.kernel.org,
        naresh.kamboju@linaro.org, peterz@infradead.org,
        rppt@linux.ibm.com, sathnaga@linux.vnet.ibm.com, shorne@gmail.com,
        willy@infradead.org
Subject:  [merged] mm-account-pmd-tables-like-pte-tables.patch
 removed from -mm tree
Message-ID: <20201014210042.ax02pGS1-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: account PMD tables like PTE tables
has been removed from the -mm tree.  Its filename was
     mm-account-pmd-tables-like-pte-tables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm: account PMD tables like PTE tables

We account the PTE level of the page tables to the process in order to
make smarter OOM decisions and help diagnose why memory is fragmented. 
For these same reasons, we should account pages allocated for PMDs.  With
larger process address spaces and ASLR, the number of PMDs in use is
higher than it used to be so the inaccuracy is starting to matter.

[rppt@linux.ibm.com: arm: __pmd_free_tlb(): call page table destructor]
  Link: https://lkml.kernel.org/r/20200825111303.GB69694@linux.ibm.com
Link: http://lkml.kernel.org/r/20200627184642.GF25039@casper.infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/tlb.h |    1 +
 include/linux/mm.h         |   24 ++++++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

--- a/arch/arm/include/asm/tlb.h~mm-account-pmd-tables-like-pte-tables
+++ a/arch/arm/include/asm/tlb.h
@@ -59,6 +59,7 @@ __pmd_free_tlb(struct mmu_gather *tlb, p
 #ifdef CONFIG_ARM_LPAE
 	struct page *page = virt_to_page(pmdp);
 
+	pgtable_pmd_page_dtor(page);
 	tlb_remove_table(tlb, page);
 #endif
 }
--- a/include/linux/mm.h~mm-account-pmd-tables-like-pte-tables
+++ a/include/linux/mm.h
@@ -2254,7 +2254,7 @@ static inline spinlock_t *pmd_lockptr(st
 	return ptlock_ptr(pmd_to_page(pmd));
 }
 
-static inline bool pgtable_pmd_page_ctor(struct page *page)
+static inline bool pmd_ptlock_init(struct page *page)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	page->pmd_huge_pte = NULL;
@@ -2262,7 +2262,7 @@ static inline bool pgtable_pmd_page_ctor
 	return ptlock_init(page);
 }
 
-static inline void pgtable_pmd_page_dtor(struct page *page)
+static inline void pmd_ptlock_free(struct page *page)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	VM_BUG_ON_PAGE(page->pmd_huge_pte, page);
@@ -2279,8 +2279,8 @@ static inline spinlock_t *pmd_lockptr(st
 	return &mm->page_table_lock;
 }
 
-static inline bool pgtable_pmd_page_ctor(struct page *page) { return true; }
-static inline void pgtable_pmd_page_dtor(struct page *page) {}
+static inline bool pmd_ptlock_init(struct page *page) { return true; }
+static inline void pmd_ptlock_free(struct page *page) {}
 
 #define pmd_huge_pte(mm, pmd) ((mm)->pmd_huge_pte)
 
@@ -2293,6 +2293,22 @@ static inline spinlock_t *pmd_lock(struc
 	return ptl;
 }
 
+static inline bool pgtable_pmd_page_ctor(struct page *page)
+{
+	if (!pmd_ptlock_init(page))
+		return false;
+	__SetPageTable(page);
+	inc_zone_page_state(page, NR_PAGETABLE);
+	return true;
+}
+
+static inline void pgtable_pmd_page_dtor(struct page *page)
+{
+	pmd_ptlock_free(page);
+	__ClearPageTable(page);
+	dec_zone_page_state(page, NR_PAGETABLE);
+}
+
 /*
  * No scalability reason to split PUD locks yet, but follow the same pattern
  * as the PMD locks to make it easier if we decide to.  The VM should not be
_

Patches currently in -mm which might be from willy@infradead.org are

xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
xarray-add-xas_split-fix-2.patch
xarray-add-xas_split-fix-3patch.patch
mm-filemap-fix-storing-to-a-thp-shadow-entry.patch
mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size-fix.patch
mm-page_owner-change-split_page_owner-to-take-a-count.patch
mm-huge_memory-fix-page_trans_huge_mapcount-assumption-of-thp-size.patch
mm-huge_memory-fix-can_split_huge_page-assumption-of-thp-size.patch
mm-rmap-fix-assumptions-of-thp-size.patch
mm-truncate-fix-truncation-for-pages-of-arbitrary-size.patch
mm-page-writeback-support-tail-pages-in-wait_for_stable_page.patch
mm-vmscan-allow-arbitrary-sized-pages-to-be-paged-out.patch
fs-add-a-filesystem-flag-for-thps.patch
fs-do-not-update-nr_thps-for-mappings-which-support-thps.patch
mm-readahead-add-define_readahead.patch
mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch
mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch
mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch
mm-rename-page_order-to-buddy_order.patch
ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache.patch
harden-autofs-ioctl-table.patch
mm-update-the-documentation-for-vfree.patch

