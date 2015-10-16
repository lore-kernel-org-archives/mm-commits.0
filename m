From: akpm@linux-foundation.org
Subject: +
 arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch added
 to -mm tree
Date: Fri, 16 Oct 2015 13:18:11 -0700
Message-ID: <56215b83.KBDq2Hflw8xITpT1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbbJPUSM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Oct 2015 16:18:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, kirill.shutemov@linux.intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: thp: fix unterminated ifdef in header file
has been added to the -mm tree.  Its filename is
     arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch

