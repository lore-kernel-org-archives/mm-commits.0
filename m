From: akpm@linux-foundation.org
Subject: - uml-arch_prctl-should-set-thread-fs.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:56:25 -0800
Message-ID: <200703152156.l2FLuPn3027559@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42266 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbXCOV42 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:56:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: arch_prctl should set thread fs
has been removed from the -mm tree.  Its filename was
     uml-arch_prctl-should-set-thread-fs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: arch_prctl should set thread fs
From: Jeff Dike <jdike@addtoit.com>

In my previous x86_64 thread fix, I forgot to initialize thread.arch.fs in
arch_prctl.  A process calling arch_prctl to set %fs would lose it on the
next context switch.

It also turns out that you can switch to a process which is in the process
of exiting and which has lost its mm.  In this case, it's worse than
useless to try to call arch_prctl on the host process.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-x86_64/syscalls.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/um/sys-x86_64/syscalls.c~uml-arch_prctl-should-set-thread-fs arch/um/sys-x86_64/syscalls.c
--- a/arch/um/sys-x86_64/syscalls.c~uml-arch_prctl-should-set-thread-fs
+++ a/arch/um/sys-x86_64/syscalls.c
@@ -103,6 +103,9 @@ long arch_prctl_skas(struct task_struct 
 
         switch(code){
 	case ARCH_SET_FS:
+		current->thread.arch.fs = (unsigned long) ptr;
+		save_registers(pid, &current->thread.regs.regs);
+		break;
 	case ARCH_SET_GS:
                 save_registers(pid, &current->thread.regs.regs);
 		break;
@@ -140,9 +143,8 @@ long sys_clone(unsigned long clone_flags
 
 void arch_switch_to_skas(struct task_struct *from, struct task_struct *to)
 {
-        if(to->thread.arch.fs == 0)
+        if((to->thread.arch.fs == 0) || (to->mm == NULL))
                 return;
 
         arch_prctl_skas(to, ARCH_SET_FS, (void __user *) to->thread.arch.fs);
 }
-
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
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
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-fix-prototypes.patch
