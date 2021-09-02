Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B185C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6736960FA0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347919AbhIBV5k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:57:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347809AbhIBV5k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:57:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD368603E9;
        Thu,  2 Sep 2021 21:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619801;
        bh=PslTs4ahvcZGXx8UdTpJh/OsPSM8uqLo/YVA61IE9fQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PNucE00mcclIt82N9f2PnKZBw9OGMvSnZ/TOb+fAvWdgW+sFv/Eb54ah82RVfnWKI
         A2LtUwHgbUTI/c98q6V0NYkwiHJmG23pYuBNFITLxAdJpJcN/cKMAIoM4ns0bB/GxU
         2psgEeH8/maLUD+NhwpaoR0aHT6OAprbocITlNs0=
Date:   Thu, 02 Sep 2021 14:56:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        borntraeger@de.ibm.com, dan.carpenter@oracle.com,
        gerald.schaefer@linux.ibm.com, gor@linux.ibm.com,
        hca@linux.ibm.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org,
        pbonzini@redhat.com, shy828301@gmail.com,
        torvalds@linux-foundation.org, ying.huang@intel.com, ziy@nvidia.com
Subject:  [patch 125/212] mm,do_huge_pmd_numa_page: remove
 unnecessary TLB flushing code
Message-ID: <20210902215640.JIDonco3t%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>
Subject: mm,do_huge_pmd_numa_page: remove unnecessary TLB flushing code

Before commit c5b5a3dd2c1f ("mm: thp: refactor NUMA fault handling"), the
TLB flushing is done in do_huge_pmd_numa_page() itself via
flush_tlb_range().

But after commit c5b5a3dd2c1f ("mm: thp: refactor NUMA fault handling"),
the TLB flushing is done in migrate_pages() as in the following code path
anyway.

do_huge_pmd_numa_page
  migrate_misplaced_page
    migrate_pages

So now, the TLB flushing code in do_huge_pmd_numa_page() becomes
unnecessary.  So the code is deleted in this patch to simplify the code. 
This is only code cleanup, there's no visible performance difference.

The mmu_notifier_invalidate_range() in do_huge_pmd_numa_page() is
deleted too.  Because migrate_pages() takes care of that too when CPU
TLB is flushed.

Link: https://lkml.kernel.org/r/20210720065529.716031-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   26 --------------------------
 1 file changed, 26 deletions(-)

--- a/mm/huge_memory.c~mmdo_huge_pmd_numa_page-remove-unnecessary-tlb-flushing-code
+++ a/mm/huge_memory.c
@@ -1440,32 +1440,6 @@ vm_fault_t do_huge_pmd_numa_page(struct
 		goto out;
 	}
 
-	/*
-	 * Since we took the NUMA fault, we must have observed the !accessible
-	 * bit. Make sure all other CPUs agree with that, to avoid them
-	 * modifying the page we're about to migrate.
-	 *
-	 * Must be done under PTL such that we'll observe the relevant
-	 * inc_tlb_flush_pending().
-	 *
-	 * We are not sure a pending tlb flush here is for a huge page
-	 * mapping or not. Hence use the tlb range variant
-	 */
-	if (mm_tlb_flush_pending(vma->vm_mm)) {
-		flush_tlb_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
-		/*
-		 * change_huge_pmd() released the pmd lock before
-		 * invalidating the secondary MMUs sharing the primary
-		 * MMU pagetables (with ->invalidate_range()). The
-		 * mmu_notifier_invalidate_range_end() (which
-		 * internally calls ->invalidate_range()) in
-		 * change_pmd_range() will run after us, so we can't
-		 * rely on it here and we need an explicit invalidate.
-		 */
-		mmu_notifier_invalidate_range(vma->vm_mm, haddr,
-					      haddr + HPAGE_PMD_SIZE);
-	}
-
 	pmd = pmd_modify(oldpmd, vma->vm_page_prot);
 	page = vm_normal_page_pmd(vma, haddr, pmd);
 	if (!page)
_
