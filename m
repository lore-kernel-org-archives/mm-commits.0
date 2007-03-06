From: akpm@linux-foundation.org
Subject: + uml-fix-formatting-violations-in-signal-delivery-code.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:54:19 -0800
Message-ID: <200703060454.l264sJQV012314@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50935 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbXCFEyW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:54:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: fix formatting violations in signal delivery code
has been added to the -mm tree.  Its filename is
     uml-fix-formatting-violations-in-signal-delivery-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix formatting violations in signal delivery code
From: Jeff Dike <jdike@addtoit.com>

Fix a few formatting bugs in the signal code.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/signal.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/um/kernel/signal.c~uml-fix-formatting-violations-in-signal-delivery-code arch/um/kernel/signal.c
--- a/arch/um/kernel/signal.c~uml-fix-formatting-violations-in-signal-delivery-code
+++ a/arch/um/kernel/signal.c
@@ -158,12 +158,12 @@ static int kern_do_signal(struct pt_regs
 		clear_thread_flag(TIF_RESTORE_SIGMASK);
 		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
 	}
-	return(handled_sig);
+	return handled_sig;
 }
 
 int do_signal(void)
 {
-	return(kern_do_signal(&current->thread.regs));
+	return kern_do_signal(&current->thread.regs);
 }
 
 /*
@@ -186,5 +186,5 @@ long sys_sigsuspend(int history0, int hi
 
 long sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss)
 {
-	return(do_sigaltstack(uss, uoss, PT_REGS_SP(&current->thread.regs)));
+	return do_sigaltstack(uss, uoss, PT_REGS_SP(&current->thread.regs));
 }
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
linux-audith-needs-linux-typesh.patch
uml-fix-formatting-violations-in-signal-delivery-code.patch
uml-add-a-debugging-message.patch
uml-comment-the-initialization-of-a-global.patch
div64_64-common-code.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph.patch
uml-hostfs-fix-double-free.patch
uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch
uml-fix-a-memory-leak-in-the-multicast-driver.patch
uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch
uml-mark-both-consoles-as-con_anytime.patch
uml-fix-confusion-irq-early-reenabling.patch
uml-activate_fd-return-enomem-only-when-appropriate.patch
uml-fix-errno-usage.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-fix-prototypes.patch
