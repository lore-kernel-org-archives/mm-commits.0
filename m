From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix-3.patch removed
 from -mm tree
Date: Mon, 08 Jun 2020 20:14:12 -0700
Message-ID: <20200609031412.XUFS96fSF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgFIDOO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 23:14:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkp@intel.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com, sfr@canb.auug.org.au


The patch titled
     Subject: mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix-3
has been removed from the -mm tree.  Its filename was
     mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix-3.patch

This patch was dropped because it was folded into mm-consolidate-pte_index-and-pte_offset_-definitions.patch

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

 arch/powerpc/include/asm/nohash/32/pgtable.h |    3 +++
 1 file changed, 3 insertions(+)

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
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-consolidate-pte_index-and-pte_offset_-definitions.patch
maccess-unexport-probe_kernel_write-and-probe_user_write-fix.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2-fix.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-fix-2.patch
