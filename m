From: akpm@linux-foundation.org
Subject: [merged] arch-sparc-mm-srmmuc-fix-build.patch removed
 from -mm tree
Date: Wed, 10 Jun 2020 13:56:00 -0700
Message-ID: <20200610205600.AOJ8PEBBJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726134AbgFJU4B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 16:56:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, lkp@intel.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: arch/sparc/mm/srmmu.c: fix build
has been removed from the -mm tree.  Its filename was
     arch-sparc-mm-srmmuc-fix-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/sparc/mm/srmmu.c: fix build

"mm: consolidate pte_index() and pte_offset_*() definitions" was supposed
to remove arch/sparc/mm/srmmu.c:pte_offset_kernel().

Fixes: 974b9b2c68f3d35 ("mm: consolidate pte_index() and pte_offset_*() definitions")
Reported-by: kernel test robot <lkp@intel.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/srmmu.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/arch/sparc/mm/srmmu.c~arch-sparc-mm-srmmuc-fix-build
+++ a/arch/sparc/mm/srmmu.c
@@ -140,16 +140,6 @@ void pmd_set(pmd_t *pmdp, pte_t *ptep)
 	set_pte((pte_t *)&pmd_val(*pmdp), __pte(SRMMU_ET_PTD | ptp));
 }
 
-/* Find an entry in the third-level page table.. */
-pte_t *pte_offset_kernel(pmd_t *dir, unsigned long address)
-{
-	void *pte;
-
-	pte = __nocache_va((pmd_val(*dir) & SRMMU_PTD_PMASK) << 4);
-	return (pte_t *) pte +
-	    ((address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1));
-}
