From: akpm@linux-foundation.org
Subject: - uml-fix-formatting-violations-in-signal-delivery-code.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:21:44 -0800
Message-ID: <200703070421.l274LiR0018923@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47055 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161322AbXCGEVr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:21:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix formatting violations in signal delivery code
has been removed from the -mm tree.  Its filename was
     uml-fix-formatting-violations-in-signal-delivery-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
uml-hostfs-fix-double-free.patch
uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch
uml-fix-a-memory-leak-in-the-multicast-driver.patch
uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch
uml-mark-both-consoles-as-con_anytime.patch
uml-fix-confusion-irq-early-reenabling.patch
uml-activate_fd-return-enomem-only-when-appropriate.patch
uml-fix-errno-usage.patch
div64_64-common-code.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
uml-fix-prototypes.patch
