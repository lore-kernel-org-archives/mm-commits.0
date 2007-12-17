From: akpm@linux-foundation.org
Subject: - powerpc-kill-non-existent-symbols-from-ksyms-and-commproch.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:38:57 -0800
Message-ID: <200712172338.lBHNcvAp008079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44354 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755681AbXLQXjE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:39:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jochen@scram.de, mm-commits@vger.kernel.org


The patch titled
     powerpc: kill non-existent symbols from ksyms and commproc.h
has been removed from the -mm tree.  Its filename was
     powerpc-kill-non-existent-symbols-from-ksyms-and-commproch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc: kill non-existent symbols from ksyms and commproc.h
From: Jochen Friedrich <jochen@scram.de>

Remove exports of __res and cpm_install_handler/cpm_free_handler.  Remove
cpm_install_handler/cpm_free_handler from the commproc.h as well.  Both
were used for ARCH=ppc and aren't defined for ARCH=powerpc.

CC      arch/powerpc/kernel/ppc_ksyms.o
arch/powerpc/kernel/ppc_ksyms.c:180: error: '__res' undeclared here (not in a function)
arch/powerpc/kernel/ppc_ksyms.c:180: warning: type defaults to 'int' in declaration of '__res'
make[1]: *** [arch/powerpc/kernel/ppc_ksyms.o] Error 1
make: *** [arch/powerpc/kernel] Error 2

LD      .tmp_vmlinux1
arch/powerpc/kernel/built-in.o:(__ksymtab+0x198): undefined reference to `cpm_free_handler'
arch/powerpc/kernel/built-in.o:(__ksymtab+0x1a0): undefined reference to `cpm_install_handler'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Jochen Friedrich <jochen@scram.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/ppc_ksyms.c |   12 ------------
 include/asm-powerpc/commproc.h  |    3 ---
 2 files changed, 15 deletions(-)

diff -puN arch/powerpc/kernel/ppc_ksyms.c~powerpc-kill-non-existent-symbols-from-ksyms-and-commproch arch/powerpc/kernel/ppc_ksyms.c
--- a/arch/powerpc/kernel/ppc_ksyms.c~powerpc-kill-non-existent-symbols-from-ksyms-and-commproch
+++ a/arch/powerpc/kernel/ppc_ksyms.c
@@ -45,10 +45,6 @@
 #include <asm/signal.h>
 #include <asm/dcr.h>
 
-#ifdef  CONFIG_8xx
-#include <asm/commproc.h>
-#endif
-
 #ifdef CONFIG_PPC64
 EXPORT_SYMBOL(local_irq_restore);
 #endif
@@ -172,14 +168,6 @@ EXPORT_SYMBOL(console_drivers);
 EXPORT_SYMBOL(cacheable_memcpy);
 #endif
 
-#ifdef  CONFIG_8xx
-EXPORT_SYMBOL(cpm_install_handler);
-EXPORT_SYMBOL(cpm_free_handler);
-#endif /* CONFIG_8xx */
-#if defined(CONFIG_8xx)
-EXPORT_SYMBOL(__res);
-#endif
-
 #ifdef CONFIG_PPC32
 EXPORT_SYMBOL(next_mmu_context);
 EXPORT_SYMBOL(set_context);
diff -puN include/asm-powerpc/commproc.h~powerpc-kill-non-existent-symbols-from-ksyms-and-commproch include/asm-powerpc/commproc.h
--- a/include/asm-powerpc/commproc.h~powerpc-kill-non-existent-symbols-from-ksyms-and-commproch
+++ a/include/asm-powerpc/commproc.h
@@ -698,9 +698,6 @@ typedef struct risc_timer_pram {
 #define CICR_IEN		((uint)0x00000080)	/* Int. enable */
 #define CICR_SPS		((uint)0x00000001)	/* SCC Spread */
 
-extern void cpm_install_handler(int vec, void (*handler)(void *), void *dev_id);
-extern void cpm_free_handler(int vec);
-
 #define IMAP_ADDR		(get_immrbase())
 
 #define CPM_PIN_INPUT     0
_

Patches currently in -mm which might be from jochen@scram.de are

origin.patch
powerpc-add-support-for-porta-and-portb-odr-registers.patch
dio-fix-kernel-doc-notation.patch
