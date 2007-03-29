From: akpm@linux-foundation.org
Subject: - uml-use-correct-register-file-size-everywhere.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:42:11 -0700
Message-ID: <200703290742.l2T7gB0c030285@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46234 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965254AbXC2Hn3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:43:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     uml: use correct register file size everywhere
has been removed from the -mm tree.  Its filename was
     uml-use-correct-register-file-size-everywhere.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: use correct register file size everywhere
From: Jeff Dike <jdike@addtoit.com>

This patch uses MAX_REG_NR consistently to refer to the register file size.
 FRAME_SIZE isn't sufficient because on x86_64, it is smaller than the
ptrace register file size.  MAX_REG_NR was introduced as a consistent way
to get the number of registers, but wasn't used everywhere it should be.

When this causes a problem, it makes PTRACE_SETREGS fail on x86_64 because
of a corrupted segment register value in the known-good register file.  The
patch also adds a register dump at that point in case there are any future
problems here.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/sysdep-x86_64/ptrace.h  |    4 ----
 arch/um/os-Linux/skas/mem.c             |   10 +++++++---
 arch/um/os-Linux/skas/process.c         |    6 +++---
 arch/um/os-Linux/sys-i386/registers.c   |    5 +++--
 arch/um/os-Linux/sys-x86_64/registers.c |    4 ++--
 5 files changed, 15 insertions(+), 14 deletions(-)

diff -puN arch/um/include/sysdep-x86_64/ptrace.h~uml-use-correct-register-file-size-everywhere arch/um/include/sysdep-x86_64/ptrace.h
--- a/arch/um/include/sysdep-x86_64/ptrace.h~uml-use-correct-register-file-size-everywhere
+++ a/arch/um/include/sysdep-x86_64/ptrace.h
@@ -104,10 +104,6 @@ union uml_pt_regs {
 #endif
 #ifdef UML_CONFIG_MODE_SKAS
 	struct skas_regs {
-		/* x86_64 ptrace uses sizeof(user_regs_struct) as its register
-		 * file size, while i386 uses FRAME_SIZE.  Therefore, we need
-		 * to use UM_FRAME_SIZE here instead of HOST_FRAME_SIZE.
-		 */
 		unsigned long regs[MAX_REG_NR];
 		unsigned long fp[HOST_FP_SIZE];
                 struct faultinfo faultinfo;
diff -puN arch/um/os-Linux/skas/mem.c~uml-use-correct-register-file-size-everywhere arch/um/os-Linux/skas/mem.c
--- a/arch/um/os-Linux/skas/mem.c~uml-use-correct-register-file-size-everywhere
+++ a/arch/um/os-Linux/skas/mem.c
@@ -48,7 +48,7 @@ int multi_op_count = 0;
 static inline long do_syscall_stub(struct mm_id * mm_idp, void **addr)
 {
 	unsigned long regs[MAX_REG_NR];
-	int n;
+	int n, i;
 	long ret, offset;
 	unsigned long * data;
 	unsigned long * syscall;
@@ -66,9 +66,13 @@ static inline long do_syscall_stub(struc
 		 (unsigned long) &__syscall_stub_start);
 
 	n = ptrace_setregs(pid, regs);
-	if(n < 0)
+	if(n < 0){
+		printk("Registers - \n");
+		for(i = 0; i < MAX_REG_NR; i++)
+			printk("\t%d\t0x%lx\n", i, regs[i]);
 		panic("do_syscall_stub : PTRACE_SETREGS failed, errno = %d\n",
-		      n);
+		      -n);
+	}
 
 	wait_stub_done(pid, 0, "do_syscall_stub");
 
diff -puN arch/um/os-Linux/skas/process.c~uml-use-correct-register-file-size-everywhere arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-use-correct-register-file-size-everywhere
+++ a/arch/um/os-Linux/skas/process.c
@@ -67,7 +67,7 @@ void wait_stub_done(int pid, int sig, ch
 
 	if((n < 0) || !WIFSTOPPED(status) ||
 	   (WSTOPSIG(status) != SIGUSR1 && WSTOPSIG(status) != SIGTRAP)){
-		unsigned long regs[HOST_FRAME_SIZE];
+		unsigned long regs[MAX_REG_NR];
 
 		if(ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
 			printk("Failed to get registers from stub, "
@@ -76,7 +76,7 @@ void wait_stub_done(int pid, int sig, ch
 			int i;
 
 			printk("Stub registers -\n");
-			for(i = 0; i < HOST_FRAME_SIZE; i++)
+			for(i = 0; i < ARRAY_SIZE(regs); i++)
 				printk("\t%d - %lx\n", i, regs[i]);
 		}
 		panic("%s : failed to wait for SIGUSR1/SIGTRAP, "
@@ -328,7 +328,7 @@ void userspace(union uml_pt_regs *regs)
 int copy_context_skas0(unsigned long new_stack, int pid)
 {
 	int err;
-	unsigned long regs[HOST_FRAME_SIZE];
+	unsigned long regs[MAX_REG_NR];
 	unsigned long fp_regs[HOST_FP_SIZE];
 	unsigned long current_stack = current_stub_stack();
 	struct stub_data *data = (struct stub_data *) current_stack;
diff -puN arch/um/os-Linux/sys-i386/registers.c~uml-use-correct-register-file-size-everywhere arch/um/os-Linux/sys-i386/registers.c
--- a/arch/um/os-Linux/sys-i386/registers.c~uml-use-correct-register-file-size-everywhere
+++ a/arch/um/os-Linux/sys-i386/registers.c
@@ -15,7 +15,7 @@
 
 /* These are set once at boot time and not changed thereafter */
 
-static unsigned long exec_regs[HOST_FRAME_SIZE];
+static unsigned long exec_regs[MAX_REG_NR];
 static unsigned long exec_fp_regs[HOST_FP_SIZE];
 static unsigned long exec_fpx_regs[HOST_XFP_SIZE];
 static int have_fpx_regs = 1;
@@ -101,6 +101,7 @@ void init_registers(int pid)
 {
 	int err;
 
+	memset(exec_regs, 0, sizeof(exec_regs));
 	err = ptrace(PTRACE_GETREGS, pid, 0, exec_regs);
 	if(err)
 		panic("check_ptrace : PTRACE_GETREGS failed, errno = %d",
@@ -124,7 +125,7 @@ void init_registers(int pid)
 
 void get_safe_registers(unsigned long *regs, unsigned long *fp_regs)
 {
-	memcpy(regs, exec_regs, HOST_FRAME_SIZE * sizeof(unsigned long));
+	memcpy(regs, exec_regs, sizeof(exec_regs));
 	if(fp_regs != NULL)
 		memcpy(fp_regs, exec_fp_regs,
 		       HOST_FP_SIZE * sizeof(unsigned long));
diff -puN arch/um/os-Linux/sys-x86_64/registers.c~uml-use-correct-register-file-size-everywhere arch/um/os-Linux/sys-x86_64/registers.c
--- a/arch/um/os-Linux/sys-x86_64/registers.c~uml-use-correct-register-file-size-everywhere
+++ a/arch/um/os-Linux/sys-x86_64/registers.c
@@ -14,7 +14,7 @@
 
 /* These are set once at boot time and not changed thereafter */
 
-static unsigned long exec_regs[HOST_FRAME_SIZE];
+static unsigned long exec_regs[MAX_REG_NR];
 static unsigned long exec_fp_regs[HOST_FP_SIZE];
 
 void init_thread_registers(union uml_pt_regs *to)
@@ -72,7 +72,7 @@ void init_registers(int pid)
 
 void get_safe_registers(unsigned long *regs, unsigned long *fp_regs)
 {
-	memcpy(regs, exec_regs, HOST_FRAME_SIZE * sizeof(unsigned long));
+	memcpy(regs, exec_regs, sizeof(exec_regs));
 	if(fp_regs != NULL)
 		memcpy(fp_regs, exec_fp_regs,
 		       HOST_FP_SIZE * sizeof(unsigned long));
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-i-o-hang-when-multiple-devices-are-in-use.patch
uml-fix-device-unplug-crash.patch
uml-irq-locking-fixes.patch
uml-fix-compilation-problems.patch
uml-fix-unreasonably-long-udelay.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
fix-utrace-utrace-tracehook-um.patch
