From: akpm@linux-foundation.org
Subject: - lguest-the-guest-code-dont-use-paravirt_probe-its-dying.patch removed from -mm tree
Date: Wed, 09 May 2007 02:42:10 -0700
Message-ID: <200705090942.l499gA8U020178@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754504AbXEIJm6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:42:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: don't use paravirt_probe, it's dying
has been removed from the -mm tree.  Its filename was
     lguest-the-guest-code-dont-use-paravirt_probe-its-dying.patch

This patch was dropped because it was folded into lguest-the-guest-code.patch

------------------------------------------------------
Subject: lguest: don't use paravirt_probe, it's dying
From: Rusty Russell <rusty@rustcorp.com.au>

paravirt_probe() and its infrastructure proved as popular as it was
pretty.  In anticipation of its imminent demise, this switches lguest to
use a magic string to identify a different entry point.

This is not the long-term solution: that will take a new bootloader rev
and will hopefully be done in the next few months.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c     |    2 --
 drivers/lguest/lguest_asm.S |   23 +++++++++--------------
 2 files changed, 9 insertions(+), 16 deletions(-)

diff -puN drivers/lguest/lguest.c~lguest-the-guest-code-dont-use-paravirt_probe-its-dying drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-the-guest-code-dont-use-paravirt_probe-its-dying
+++ a/drivers/lguest/lguest.c
@@ -43,7 +43,6 @@ extern const char lgstart_sti[], lgend_s
 extern const char lgstart_popf[], lgend_popf[];
 extern const char lgstart_pushf[], lgend_pushf[];
 extern const char lgstart_iret[], lgend_iret[];
-extern asmlinkage void lguest_maybe_init(void);
 extern void lguest_iret(void);
 
 struct lguest_data lguest_data = {
@@ -500,4 +499,3 @@ __init void lguest_init(void)
 	pm_power_off = lguest_power_off;
 	start_kernel();
 }
-paravirt_probe(lguest_maybe_init);
diff -puN drivers/lguest/lguest_asm.S~lguest-the-guest-code-dont-use-paravirt_probe-its-dying drivers/lguest/lguest_asm.S
--- a/drivers/lguest/lguest_asm.S~lguest-the-guest-code-dont-use-paravirt_probe-its-dying
+++ a/drivers/lguest/lguest_asm.S
@@ -1,29 +1,24 @@
 #include <linux/linkage.h>
 #include <linux/lguest.h>
 #include <asm/asm-offsets.h>
+#include <asm/thread_info.h>
 
 /* FIXME: Once asm/processor-flags.h goes in, include that */
 #define X86_EFLAGS_IF 0x00000200
 
 /*
- * This is where we begin: head.S notes that paging is already enabled (which
- * doesn't happen in native boot) and calls the registered paravirt_probe
- * functions one at a time.  Ours is a simple assembler test for magic
- * registers.  If they're correct we jump to lguest_init.
+ * This is where we begin: we have a magic signature which the launcher looks
+ * for.  The plan is that the Linux boot protocol will be extended with a
+ * "platform type" field which will guide us here from the normal entry point,
+ * but for the moment this suffices.
  *
  * We put it in .init.text will be discarded after boot.
  */
 .section .init.text, "ax", @progbits
-ENTRY(lguest_maybe_init)
-	cmpl $LGUEST_MAGIC_EBP, %ebp
-	jne out
-	cmpl $LGUEST_MAGIC_EDI, %edi
-	jne out
-	cmpl $LGUEST_MAGIC_ESI, %esi
-	jne out
-	je lguest_init
-out:
-	ret
+.ascii "GenuineLguest"
+	/* Set up initial stack. */
+ 	movl $(init_thread_union+THREAD_SIZE),%esp
+	jmp lguest_init
 
 /* The templates for inline patching. */
 #define LGUEST_PATCH(name, insns...)			\
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
futex-new-private-futexes.patch
compiler-introduce-__used-and-__maybe_unused.patch
xfs-clean-up-shrinker-games.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-guest-code-dont-use-paravirt_probe-its-dying.patch
lguest-the-host-code.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o.patch
lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch
lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem.patch
lguest-the-host-code-remove-put_user-etc-warnings-add-bloat.patch
lguest-the-host-code-fix-obscure-but-nasty-cow-bug.patch
lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch.patch
lguest-the-net-driver-two-net-bugfixes.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
lguest-documentation-and-example-updates.patch
lguest-the-documentation-example-launcher-dont-use-paravirt_probe-its-dying-doc.patch
lguest-use-standard-bootloader-format-fix-badly-sized-doc.patch
lguest-two-net-bugfixes-doc.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
