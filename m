From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-sparc-mm-srmmuc-fix-build.patch added to -mm tree
Date: Tue, 09 Jun 2020 15:26:54 -0700
Message-ID: <20200609222654.72kEGYBDv%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728191AbgFIW0z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 18:26:55 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, lkp@intel.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: arch/sparc/mm/srmmu.c: fix build
has been added to the -mm tree.  Its filename is
     arch-sparc-mm-srmmuc-fix-build.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-sparc-mm-srmmuc-fix-build.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-sparc-mm-srmmuc-fix-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/sparc/mm/srmmu.c: fix build

"mm: consolidate pte_index() and pte_offset_*() definitions" was supposed
to remove arch/sparc/mm/srmmu.c:pte_offset_kernel().

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
