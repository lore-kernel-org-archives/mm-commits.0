From: akpm@linux-foundation.org
Subject: [merged]
 arch-powerpc-mm-pgtablec-another-missed-conversion.patch removed from -mm
 tree
Date: Thu, 11 Jun 2020 15:22:42 -0700
Message-ID: <20200611222242.VqpJlPNz-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgFKWWn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Jun 2020 18:22:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@roeck-us.net, lkp@intel.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, rppt@kernel.org


The patch titled
     Subject: arch/powerpc/mm/pgtable.c: another missed conversion
has been removed from the -mm tree.  Its filename was
     arch-powerpc-mm-pgtablec-another-missed-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/powerpc/mm/pgtable.c: another missed conversion

Fixes: e05c7b1f2bc4b7 ("mm: pgtable: add shortcuts for accessing kernel PMD and PTE")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/pgtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/pgtable.c~arch-powerpc-mm-pgtablec-another-missed-conversion
+++ a/arch/powerpc/mm/pgtable.c
@@ -264,7 +264,7 @@ int huge_ptep_set_access_flags(struct vm
 #if defined(CONFIG_PPC_8xx)
 void set_huge_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
 {
-	pmd_t *pmd = pmd_ptr(mm, addr);
+	pmd_t *pmd = pmd_off(mm, addr);
 	pte_basic_t val;
 	pte_basic_t *entry = &ptep->pte;
 	int num = is_hugepd(*((hugepd_t *)pmd)) ? 1 : SZ_512K / SZ_4K;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
kernel-forkc-export-kernel_thread-to-modules.patch
