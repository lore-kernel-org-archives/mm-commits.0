From: akpm@osdl.org
Subject: - x86_64-i386-kernel-mode-faults-pollute-current-thead.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:02:06 -0800
Message-ID: <200701102302.l0AN26mb010712@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33068 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965161AbXAJXCQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:02:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64/i386: kernel-mode faults pollute current->thead
has been removed from the -mm tree.  Its filename was
     x86_64-i386-kernel-mode-faults-pollute-current-thead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64/i386: kernel-mode faults pollute current->thead
From: Jeff Dike <jdike@addtoit.com>

Kernel-mode traps on x86_64 can pollute the trap information for a previous
userspace trap for which the signal has not yet been delivered to the
process.

do_trap and do_general_protection set task->thread.error_code and .trapno
for kernel traps.  If a kernel-mode trap arrives between the arrival of a
userspace trap and the delivery of the associated SISGEGV to the process,
the process will get the kernel trap information in its sigcontext.

This causes UML process segfaults, as the trapno that the UML kernel sees
is 13, rather than the 14 for normal page faults.  So, the UML kernel
passes the SIGSEGV along to its process.

I don't claim to fully understand the problem.  On the one hand, a check in
do_general_protection for a pending SIGSEGV turned up nothing.  On the
other hand, this patch fixed the UML process segfault problem.

The patch below moves the setting of error_code and trapno so that that
only happens in the case of userspace faults.  As a side-effect, this
should speed up kernel-mode fault handling a tiny bit.

I looked at i386, and there is a similar situation.  In this case, there is
duplicate code setting task->thread.error_code and trapno.  I deleted one,
leaving the copy that runs in the case of a userspace fault.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/traps.c   |    8 +++-----
 arch/x86_64/kernel/traps.c |   12 ++++++------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff -puN arch/i386/kernel/traps.c~x86_64-i386-kernel-mode-faults-pollute-current-thead arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~x86_64-i386-kernel-mode-faults-pollute-current-thead
+++ a/arch/i386/kernel/traps.c
@@ -475,8 +475,6 @@ static void __kprobes do_trap(int trapnr
 			      siginfo_t *info)
 {
 	struct task_struct *tsk = current;
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = trapnr;
 
 	if (regs->eflags & VM_MASK) {
 		if (vm86)
@@ -488,6 +486,9 @@ static void __kprobes do_trap(int trapnr
 		goto kernel_trap;
 
 	trap_signal: {
+		tsk->thread.error_code = error_code;
+		tsk->thread.trap_no = trapnr;
+
 		if (info)
 			force_sig_info(signr, info, tsk);
 		else
@@ -602,9 +603,6 @@ fastcall void __kprobes do_general_prote
 	}
 	put_cpu();
 
-	current->thread.error_code = error_code;
-	current->thread.trap_no = 13;
-
 	if (regs->eflags & VM_MASK)
 		goto gp_in_vm86;
 
diff -puN arch/x86_64/kernel/traps.c~x86_64-i386-kernel-mode-faults-pollute-current-thead arch/x86_64/kernel/traps.c
--- a/arch/x86_64/kernel/traps.c~x86_64-i386-kernel-mode-faults-pollute-current-thead
+++ a/arch/x86_64/kernel/traps.c
@@ -582,10 +582,10 @@ static void __kprobes do_trap(int trapnr
 {
 	struct task_struct *tsk = current;
 
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = trapnr;
-
 	if (user_mode(regs)) {
+		tsk->thread.error_code = error_code;
+		tsk->thread.trap_no = trapnr;
+
 		if (exception_trace && unhandled_signal(tsk, signr))
 			printk(KERN_INFO
 			       "%s[%d] trap %s rip:%lx rsp:%lx error:%lx\n",
@@ -683,10 +683,10 @@ asmlinkage void __kprobes do_general_pro
 
 	conditional_sti(regs);
 
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 13;
-
 	if (user_mode(regs)) {
+		tsk->thread.error_code = error_code;
+		tsk->thread.trap_no = 13;
+
 		if (exception_trace && unhandled_signal(tsk, SIGSEGV))
 			printk(KERN_INFO
 		       "%s[%d] general protection rip:%lx rsp:%lx error:%lx\n",
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-initialize-a-list-head.patch
uml-make-time-data-per-cpu.patch
uml-delete-unused-file.patch
uml-remove-unused-variable-and-function.patch
uml-make-signal-handlers-static.patch
uml-const-a-variable.patch
uml-remove-code-controlled-by-non-existent-config-option.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
proc-remove-useless-and-buggy-nlink-settings.patch
