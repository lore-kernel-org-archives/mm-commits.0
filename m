From: akpm@linux-foundation.org
Subject: [folded-merged]
 =?US-ASCII?Q?mm-special-create-generic-fallbacks-for-pte=5Fspecial-and-pt?=
 =?US-ASCII?Q?e=5Fmkspecial-v3.patch?= removed from -mm tree
Date: Fri, 10 Apr 2020 14:13:00 -0700
Message-ID: <20200410211300.ar3bDttgK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgDJVNB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:13:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, mm-commits@vger.kernel.org, tsbogend@alpha.franken.de


The patch titled
     Subject: mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial-v3
has been removed from the -mm tree.  Its filename was
     mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial-v3.patch

This patch was dropped because it was folded into mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial.patch

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

mm-vma-define-a-default-value-for-vm_data_default_flags.patch
mm-vma-introduce-vm_access_flags.patch
mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial.patch
