From: akpm@linux-foundation.org
Subject: - uml-x86_64-ptrace-fixes.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:49 -0800
Message-ID: <200702112249.l1BMnnwD015793@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59927 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702AbXBKWtw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: x86_64 ptrace fixes
has been removed from the -mm tree.  Its filename was
     uml-x86_64-ptrace-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: x86_64 ptrace fixes
From: Jeff Dike <jdike@addtoit.com>

This patch fixes some missing ptrace bits on x86_64.  PTRACE_ARCH_PRCTL is
hooked up and implemented.  This required generalizing arch_prctl_skas
slightly to take a task_struct to modify.  Previously, it always operated on
current.

Reading and writing the debug registers is also enabled by un-ifdefing the
code that implements that.  It turns out that x86_64 is identical to i386, so
the same code can be used.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/ptrace.c        |    7 +++++++
 arch/um/sys-x86_64/ptrace.c    |    5 -----
 arch/um/sys-x86_64/syscalls.c  |   14 ++++++++------
 include/asm-um/ptrace-x86_64.h |    3 +++
 4 files changed, 18 insertions(+), 11 deletions(-)

diff -puN arch/um/kernel/ptrace.c~uml-x86_64-ptrace-fixes arch/um/kernel/ptrace.c
--- a/arch/um/kernel/ptrace.c~uml-x86_64-ptrace-fixes
+++ a/arch/um/kernel/ptrace.c
@@ -18,6 +18,7 @@
 #include "kern_util.h"
 #include "skas_ptrace.h"
 #include "sysdep/ptrace.h"
+#include "os.h"
 
 static inline void set_singlestepping(struct task_struct *child, int on)
 {
@@ -241,6 +242,12 @@ long arch_ptrace(struct task_struct *chi
 		break;
 	}
 #endif
+#ifdef PTRACE_ARCH_PRCTL
+        case PTRACE_ARCH_PRCTL:
+                /* XXX Calls ptrace on the host - needs some SMP thinking */
+                ret = arch_prctl_skas(child, data, (void *) addr);
+                break;
+#endif
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
diff -puN arch/um/sys-x86_64/ptrace.c~uml-x86_64-ptrace-fixes arch/um/sys-x86_64/ptrace.c
--- a/arch/um/sys-x86_64/ptrace.c~uml-x86_64-ptrace-fixes
+++ a/arch/um/sys-x86_64/ptrace.c
@@ -71,8 +71,6 @@ int poke_user(struct task_struct *child,
 
         if (addr < MAX_REG_OFFSET)
                 return putreg(child, addr, data);
-
-#if 0 /* Need x86_64 debugregs handling */
         else if((addr >= offsetof(struct user, u_debugreg[0])) &&
                 (addr <= offsetof(struct user, u_debugreg[7]))){
                 addr -= offsetof(struct user, u_debugreg[0]);
@@ -81,7 +79,6 @@ int poke_user(struct task_struct *child,
                 child->thread.arch.debugregs[addr] = data;
                 return 0;
         }
-#endif
         return -EIO;
 }
 
@@ -119,14 +116,12 @@ int peek_user(struct task_struct *child,
         if(addr < MAX_REG_OFFSET){
                 tmp = getreg(child, addr);
         }
-#if 0 /* Need x86_64 debugregs handling */
         else if((addr >= offsetof(struct user, u_debugreg[0])) &&
                 (addr <= offsetof(struct user, u_debugreg[7]))){
                 addr -= offsetof(struct user, u_debugreg[0]);
                 addr = addr >> 2;
                 tmp = child->thread.arch.debugregs[addr];
         }
-#endif
         return put_user(tmp, (unsigned long *) data);
 }
 
diff -puN arch/um/sys-x86_64/syscalls.c~uml-x86_64-ptrace-fixes arch/um/sys-x86_64/syscalls.c
--- a/arch/um/sys-x86_64/syscalls.c~uml-x86_64-ptrace-fixes
+++ a/arch/um/sys-x86_64/syscalls.c
@@ -59,18 +59,20 @@ static long arch_prctl_tt(int code, unsi
 
 #ifdef CONFIG_MODE_SKAS
 
-static long arch_prctl_skas(int code, unsigned long __user *addr)
+long arch_prctl_skas(struct task_struct *task, int code,
+                     unsigned long __user *addr)
 {
         unsigned long *ptr = addr, tmp;
 	long ret;
-        int pid = current->mm->context.skas.id.u.pid;
+	int pid = task->mm->context.skas.id.u.pid;
 
 	/*
 	 * With ARCH_SET_FS (and ARCH_SET_GS is treated similarly to
 	 * be safe), we need to call arch_prctl on the host because
 	 * setting %fs may result in something else happening (like a
-	 * GDT being set instead).  So, we let the host fiddle the
-	 * registers and restore them afterwards.
+	 * GDT or thread.fs being set instead).  So, we let the host
+	 * fiddle the registers and thread struct and restore the
+	 * registers afterwards.
 	 *
 	 * So, the saved registers are stored to the process (this
 	 * needed because a stub may have been the last thing to run),
@@ -118,7 +120,7 @@ static long arch_prctl_skas(int code, un
 
 long sys_arch_prctl(int code, unsigned long addr)
 {
-	return CHOOSE_MODE_PROC(arch_prctl_tt, arch_prctl_skas, code,
+	return CHOOSE_MODE_PROC(arch_prctl_tt, arch_prctl_skas, current, code,
                                 (unsigned long __user *) addr);
 }
 
@@ -141,6 +143,6 @@ void arch_switch_to_skas(struct task_str
         if(to->thread.arch.fs == 0)
                 return;
 
-        arch_prctl_skas(ARCH_SET_FS, (void __user *) to->thread.arch.fs);
+        arch_prctl_skas(to, ARCH_SET_FS, (void __user *) to->thread.arch.fs);
 }
 
diff -puN include/asm-um/ptrace-x86_64.h~uml-x86_64-ptrace-fixes include/asm-um/ptrace-x86_64.h
--- a/include/asm-um/ptrace-x86_64.h~uml-x86_64-ptrace-fixes
+++ a/include/asm-um/ptrace-x86_64.h
@@ -84,4 +84,7 @@ static inline void arch_switch_to_tt(str
 extern void arch_switch_to_skas(struct task_struct *from,
 				struct task_struct *to);
 
+extern long arch_prctl_skas(struct task_struct *task, int code,
+			    unsigned long __user *addr);
+
 #endif
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
