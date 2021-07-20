Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F00C07E9B
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 22:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21CDE611CE
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 22:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhGTV4c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 17:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229604AbhGTV4c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 17:56:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4345D61178;
        Tue, 20 Jul 2021 22:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626820630;
        bh=BjezZeGZwzUGEJIhZSIo8da90YW8EcnAmpVXD9gKpHw=;
        h=Date:From:To:Subject:From;
        b=wIGdV1+K1Vk3RyRBmJJJbc3d67nS40jMybNLJtS7eDP0L4e4qMVKtscf08LPZqtN+
         34qsdNZLGPCMqOycJ+NKb8U3aFZoV+Ca4h7n+XuAF9y2r2lDIa8yLgQ/mW48AVjI2p
         x01Rcy9z6ejMaBmGzk76F+WMm/+1hgQphtBhtJLc=
Date:   Tue, 20 Jul 2021 15:37:08 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, shy828301@gmail.com,
        pbonzini@redhat.com, mhocko@suse.com, mgorman@suse.de,
        kirill.shutemov@linux.intel.com, hughd@google.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, dan.carpenter@oracle.com,
        borntraeger@de.ibm.com, aarcange@redhat.com, ying.huang@intel.com
Subject:  +
 mmdo_huge_pmd_numa_page-remove-unnecessary-tlb-flushing-code.patch added to
 -mm tree
Message-ID: <20210720223708.V45O2%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,do_huge_pmd_numa_page: remove unnecessary TLB flushing code
has been added to the -mm tree.  Its filename is
     mmdo_huge_pmd_numa_page-remove-unnecessary-tlb-flushing-code.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmdo_huge_pmd_numa_page-remove-unnecessary-tlb-flushing-code.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmdo_huge_pmd_numa_page-remove-unnecessary-tlb-flushing-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from ying.huang@intel.com are

mmdo_huge_pmd_numa_page-remove-unnecessary-tlb-flushing-code.patch
mm-migrate-add-sysfs-interface-to-enable-reclaim-migration.patch

