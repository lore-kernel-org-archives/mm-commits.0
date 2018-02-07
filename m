From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-migrate-remove-reason-argument-from-new_page_t-fix.patch removed from
 -mm tree
Date: Wed, 07 Feb 2018 14:50:10 -0800
Message-ID: <5a7b82a2.YA4Yh1XP5zrlGOF+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40488 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbeBGWuL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 17:50:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, ar@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, zi.yan@cs.rutgers.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-remove-reason-argument-from-new_page_t-fix
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-reason-argument-from-new_page_t-fix.patch

This patch was dropped because it was folded into mm-migrate-remove-reason-argument-from-new_page_t.patch

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: mm-migrate-remove-reason-argument-from-new_page_t-fix

Ups, this one is missing so it should be folded in.

Link: http://lkml.kernel.org/r/20180103091134.GB11319@dhcp22.suse.cz
Cc: Andrea Reale <ar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <zi.yan@cs.rutgers.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mmu_context_iommu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/powerpc/mm/mmu_context_iommu.c~mm-migrate-remove-reason-argument-from-new_page_t-fix arch/powerpc/mm/mmu_context_iommu.c
--- a/arch/powerpc/mm/mmu_context_iommu.c~mm-migrate-remove-reason-argument-from-new_page_t-fix
+++ a/arch/powerpc/mm/mmu_context_iommu.c
@@ -75,8 +75,7 @@ EXPORT_SYMBOL_GPL(mm_iommu_preregistered
 /*
  * Taken from alloc_migrate_target with changes to remove CMA allocations
  */
-struct page *new_iommu_non_cma_page(struct page *page, unsigned long private,
-					int **resultp)
+struct page *new_iommu_non_cma_page(struct page *page, unsigned long private)
 {
 	gfp_t gfp_mask = GFP_USER;
 	struct page *new_page;
_

Patches currently in -mm which might be from mhocko@kernel.org are

mm-migrate-remove-reason-argument-from-new_page_t.patch

