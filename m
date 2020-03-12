From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?mm-special-create-generic-fallbacks-for-pte=5Fspecial-and-pt?=
 =?US-ASCII?Q?e=5Fmkspecial-v3.patch?= added to -mm tree
Date: Wed, 11 Mar 2020 18:17:09 -0700
Message-ID: <20200312011709.5Am6ng6wK%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387404AbgCLBRK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 11 Mar 2020 21:17:10 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, mm-commits@vger.kernel.org, tsbogend@alpha.franken.de


The patch titled
     Subject: mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial-v3
has been added to the -mm tree.  Its filename is
     mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial-v3

use defined(CONFIG_ARCH_HAS_PTE_SPECIAL) in mips per Thomas

Link: http://lkml.kernel.org/r/1583851924-21603-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/pgtable.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/mips/include/asm/pgtable.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial-v3
+++ a/arch/mips/include/asm/pgtable.h
@@ -273,7 +273,7 @@ extern pgd_t swapper_pg_dir[];
  * Platform specific pte_special() and pte_mkspecial() definitions
  * are required only when ARCH_HAS_PTE_SPECIAL is enabled.
  */
-#if !defined(CONFIG_32BIT) && !defined(CONFIG_CPU_HAS_RIXI)
+#if defined(CONFIG_ARCH_HAS_PTE_SPECIAL)
 #if defined(CONFIG_PHYS_ADDR_T_64BIT) && defined(CONFIG_CPU_MIPS32)
 static inline int pte_special(pte_t pte)
 {
@@ -297,7 +297,7 @@ static inline pte_t pte_mkspecial(pte_t
 	return pte;
 }
 #endif
-#endif
+#endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
 
 /*
  * The following only work if pte_present() is true.
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-vma-add-missing-vma-flag-readable-name-for-vm_sync.patch
mm-vma-make-vma_is_accessible-available-for-general-use.patch
mm-vma-replace-all-remaining-open-encodings-with-is_vm_hugetlb_page.patch
mm-vma-replace-all-remaining-open-encodings-with-vma_is_anonymous.patch
mm-vma-append-unlikely-while-testing-vma-access-permissions.patch
mm-vma-move-vm_no_khugepaged-into-generic-header.patch
mm-vma-make-vma_is_foreign-available-for-general-use.patch
mm-vma-make-is_vma_temporary_stack-available-for-general-use.patch
mm-vma-define-a-default-value-for-vm_data_default_flags.patch
mm-vma-introduce-vm_access_flags.patch
mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial.patch
mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial-v3.patch
mm-debug-add-tests-validating-architecture-page-table-helpers.patch
