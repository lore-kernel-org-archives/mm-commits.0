From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 arch-powerpc-mm-pgtablec-another-missed-conversion.patch added to -mm tree
Date: Wed, 10 Jun 2020 14:33:53 -0700
Message-ID: <20200610213353.ddCYb_UHB%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726134AbgFJVdy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 17:33:54 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@roeck-us.net, lkp@intel.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, rppt@kernel.org


The patch titled
     Subject: arch/powerpc/mm/pgtable.c: another missed conversion
has been added to the -mm tree.  Its filename is
     arch-powerpc-mm-pgtablec-another-missed-conversion.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-powerpc-mm-pgtablec-another-missed-conversion.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-powerpc-mm-pgtablec-another-missed-conversion.patch

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

arch-powerpc-mm-pgtablec-another-missed-conversion.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
