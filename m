From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix-3.patch added to
 -mm tree
Date: Sun, 07 Jun 2020 16:53:47 -0700
Message-ID: <20200607235347.pemee48AR%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgFGXxs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 7 Jun 2020 19:53:48 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkp@intel.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com, sfr@canb.auug.org.au


The patch titled
     Subject: mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix-3
has been added to the -mm tree.  Its filename is
     mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix-3

Fix powerpc build

Link: http://lkml.kernel.org/r/20200607153443.GB738695@linux.ibm.com
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/nohash/32/pgtable.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/nohash/32/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix-3
+++ a/arch/powerpc/include/asm/nohash/32/pgtable.h
@@ -205,6 +205,9 @@ static inline void pmd_clear(pmd_t *pmdp
 	*pmdp = __pmd(0);
 }
 
+/* to find an entry in a page-table-directory */
+#define pgd_index(address)	 ((address) >> PGDIR_SHIFT)
+#define pgd_offset(mm, address)	 ((mm)->pgd + pgd_index(address))
 
 /*
  * PTE updates. This function is called whenever an existing
@@ -234,7 +237,7 @@ static inline pte_basic_t pte_update(str
 	pte_basic_t old = pte_val(*p);
 	pte_basic_t new = (old & ~(pte_basic_t)clr) | set;
 	int num, i;
-	pmd_t *pmd = pmd_offset(pud_offset(pgd_offset(mm, addr), addr), addr);
+	pmd_t *pmd = pmd_offset(pud_offset(p4d_offset(pgd_offset(mm, addr), addr), addr), addr);
 
 	if (!huge)
 		num = PAGE_SIZE / SZ_4K;
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

kernel-better-document-the-use_mm-unuse_mm-api-contract-v2-fix.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-fix-2.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix-3.patch
maccess-unexport-probe_kernel_write-and-probe_user_write-fix.patch
