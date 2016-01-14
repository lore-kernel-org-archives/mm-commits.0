From: akpm@linux-foundation.org
Subject: [folded-merged]
 arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch removed from -mm tree
Date: Thu, 14 Jan 2016 14:34:22 -0800
Message-ID: <5698226e.9XcpG4EjG/MXG34D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbcANWeY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:34:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, kirill.shutemov@linux.intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: thp: fix unterminated ifdef in header file
has been removed from the -mm tree.  Its filename was
     arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch

This patch was dropped because it was folded into arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: ARM: thp: fix unterminated ifdef in header file

A recent change accidentally removed one line more than it should
have, causing the build to fail with ARM LPAE:

In file included from /git/arm-soc/arch/arm/include/asm/pgtable.h:31:0,
                 from /git/arm-soc/include/linux/mm.h:55,
                 from /git/arm-soc/arch/arm/kernel/asm-offsets.c:15:
/git/arm-soc/arch/arm/include/asm/pgtable-3level.h:20:0: error: unterminated #ifndef
 #ifndef _ASM_PGTABLE_3LEVEL_H

This puts the line back where it was.

Fixes: f054144a1b23 ("arm, thp: remove infrastructure for handling splitting PMDs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-3level.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/include/asm/pgtable-3level.h~arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix arch/arm/include/asm/pgtable-3level.h
--- a/arch/arm/include/asm/pgtable-3level.h~arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -231,6 +231,7 @@ static inline pte_t pte_mkspecial(pte_t
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define pmd_trans_huge(pmd)	(pmd_val(pmd) && !pmd_table(pmd))
+#endif
 
 #define PMD_BIT_FUNC(fn,op) \
 static inline pmd_t pmd_##fn(pmd_t pmd) { pmd_val(pmd) op; return pmd; }
_

Patches currently in -mm which might be from arnd@arndb.de are

logfs-fix-logfs-build-errors-and-dependencies.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch

