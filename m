From: akpm@linux-foundation.org
Subject: + uml-register-handling-formatting-fixes.patch added to -mm tree
Date: Wed, 07 Feb 2007 15:20:55 -0800
Message-ID: <200702072320.l17NKtEg030941@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44864 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161321AbXBGXU5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 18:20:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: register handling formatting fixes
has been added to the -mm tree.  Its filename is
     uml-register-handling-formatting-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: register handling formatting fixes
From: Jeff Dike <jdike@addtoit.com>

Formatting fixes in the register handling code.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/sys-i386/registers.c   |   14 +++++++-------
 arch/um/os-Linux/sys-x86_64/registers.c |    6 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN arch/um/os-Linux/sys-i386/registers.c~uml-register-handling-formatting-fixes arch/um/os-Linux/sys-i386/registers.c
--- a/arch/um/os-Linux/sys-i386/registers.c~uml-register-handling-formatting-fixes
+++ a/arch/um/os-Linux/sys-i386/registers.c
@@ -34,27 +34,27 @@ void init_thread_registers(union uml_pt_
 int save_fp_registers(int pid, unsigned long *fp_regs)
 {
 	if(ptrace(PTRACE_GETFPREGS, pid, 0, fp_regs) < 0)
-		return(-errno);
-	return(0);
+		return -errno;
+	return 0;
 }
 
 int restore_fp_registers(int pid, unsigned long *fp_regs)
 {
 	if(ptrace(PTRACE_SETFPREGS, pid, 0, fp_regs) < 0)
-		return(-errno);
-	return(0);
+		return -errno;
+	return 0;
 }
 
 static int move_registers(int pid, int int_op, union uml_pt_regs *regs,
 			  int fp_op, unsigned long *fp_regs)
 {
 	if(ptrace(int_op, pid, 0, regs->skas.regs) < 0)
-		return(-errno);
+		return -errno;
 
 	if(ptrace(fp_op, pid, 0, fp_regs) < 0)
-		return(-errno);
+		return -errno;
 
-	return(0);
+	return 0;
 }
 
 void save_registers(int pid, union uml_pt_regs *regs)
diff -puN arch/um/os-Linux/sys-x86_64/registers.c~uml-register-handling-formatting-fixes arch/um/os-Linux/sys-x86_64/registers.c
--- a/arch/um/os-Linux/sys-x86_64/registers.c~uml-register-handling-formatting-fixes
+++ a/arch/um/os-Linux/sys-x86_64/registers.c
@@ -27,12 +27,12 @@ static int move_registers(int pid, int i
 			  union uml_pt_regs *regs)
 {
 	if(ptrace(int_op, pid, 0, regs->skas.regs) < 0)
-		return(-errno);
+		return -errno;
 
 	if(ptrace(fp_op, pid, 0, regs->skas.fp) < 0)
-		return(-errno);
+		return -errno;
 
-	return(0);
+	return 0;
 }
 
 void save_registers(int pid, union uml_pt_regs *regs)
_

Patches currently in -mm which might be from jdike@addtoit.com are

x86_64-32-bit-ptrace-mangles-sixth-system-call-argument.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs-fix.patch
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
uml-add-per-device-queues-and-locks-to-ubd-driver.patch
uml-locking-fixes-in-the-ubd-driver.patch
uml-locking-comments-in-memory-and-tempfile-code.patch
uml-locking-comments-in-startup-code.patch
uml-style-fixes-in-startup-code.patch
uml-libc-dependent-code-should-call-libc-directly.patch
uml-fix-style-violations.patch
uml-fix-apparent-config_64_bit-typo.patch
uml-irq-handler-tidying.patch
uml-sigio-locking-comment.patch
uml-sigio-formatting-fixes.patch
uml-umid-tidying.patch
uml-elf-locking-commentary.patch
uml-register-handling-formatting-fixes.patch
uml-aio-locking-and-tidying.patch
uml-fix-prototypes.patch
proc-remove-useless-and-buggy-nlink-settings.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
