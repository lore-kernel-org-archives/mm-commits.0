From: akpm@linux-foundation.org
Subject: [merged]
 treewide-replace-config_enabled-with-is_enabled-2nd-round.patch removed
 from -mm tree
Date: Mon, 29 Aug 2016 12:51:24 -0700
Message-ID: <57c4923c.xu9AqATbFaLYuPUl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34907 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755742AbcH2TvZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 15:51:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, heiko.carstens@de.ibm.com, hpa@zytor.com, keescook@chromium.org, mingo@elte.hu, oberpar@linux.vnet.ibm.com, ralf@linux-mips.org, schwidefsky@de.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide: replace config_enabled() with IS_ENABLED() (2nd round)
has been removed from the -mm tree.  Its filename was
     treewide-replace-config_enabled-with-is_enabled-2nd-round.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: treewide: replace config_enabled() with IS_ENABLED() (2nd round)

Commit 97f2645f358b ("tree-wide: replace config_enabled() with
IS_ENABLED()") mostly killed config_enabled(), but some new users have
appeared for v4.8-rc1.  They are all used for a boolean option, so can be
replaced with IS_ENABLED() safely.

Link: http://lkml.kernel.org/r/1471970749-24867-1-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/page.h |    4 ++--
 arch/s390/kernel/setup.c     |    6 ++----
 arch/x86/mm/kaslr.c          |    2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff -puN arch/mips/include/asm/page.h~treewide-replace-config_enabled-with-is_enabled-2nd-round arch/mips/include/asm/page.h
--- a/arch/mips/include/asm/page.h~treewide-replace-config_enabled-with-is_enabled-2nd-round
+++ a/arch/mips/include/asm/page.h
@@ -164,7 +164,7 @@ typedef struct { unsigned long pgprot; }
  */
 static inline unsigned long ___pa(unsigned long x)
 {
-	if (config_enabled(CONFIG_64BIT)) {
+	if (IS_ENABLED(CONFIG_64BIT)) {
 		/*
 		 * For MIPS64 the virtual address may either be in one of
 		 * the compatibility segements ckseg0 or ckseg1, or it may
@@ -173,7 +173,7 @@ static inline unsigned long ___pa(unsign
 		return x < CKSEG0 ? XPHYSADDR(x) : CPHYSADDR(x);
 	}
 
-	if (!config_enabled(CONFIG_EVA)) {
+	if (!IS_ENABLED(CONFIG_EVA)) {
 		/*
 		 * We're using the standard MIPS32 legacy memory map, ie.
 		 * the address x is going to be in kseg0 or kseg1. We can
diff -puN arch/s390/kernel/setup.c~treewide-replace-config_enabled-with-is_enabled-2nd-round arch/s390/kernel/setup.c
--- a/arch/s390/kernel/setup.c~treewide-replace-config_enabled-with-is_enabled-2nd-round
+++ a/arch/s390/kernel/setup.c
@@ -204,11 +204,9 @@ static void __init conmode_default(void)
 #endif
 		}
 	} else if (MACHINE_IS_KVM) {
-		if (sclp.has_vt220 &&
-		    config_enabled(CONFIG_SCLP_VT220_CONSOLE))
+		if (sclp.has_vt220 && IS_ENABLED(CONFIG_SCLP_VT220_CONSOLE))
 			SET_CONSOLE_VT220;
-		else if (sclp.has_linemode &&
-			 config_enabled(CONFIG_SCLP_CONSOLE))
+		else if (sclp.has_linemode && IS_ENABLED(CONFIG_SCLP_CONSOLE))
 			SET_CONSOLE_SCLP;
 		else
 			SET_CONSOLE_HVC;
diff -puN arch/x86/mm/kaslr.c~treewide-replace-config_enabled-with-is_enabled-2nd-round arch/x86/mm/kaslr.c
--- a/arch/x86/mm/kaslr.c~treewide-replace-config_enabled-with-is_enabled-2nd-round
+++ a/arch/x86/mm/kaslr.c
@@ -77,7 +77,7 @@ static inline unsigned long get_padding(
  */
 static inline bool kaslr_memory_enabled(void)
 {
-	return kaslr_enabled() && !config_enabled(CONFIG_KASAN);
+	return kaslr_enabled() && !IS_ENABLED(CONFIG_KASAN);
 }
 
 /* Initialize base and padding for each memory region randomized with KASLR */
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are


