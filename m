From: akpm@linux-foundation.org
Subject: + uml-ptrace-floating-point-fixes.patch added to -mm tree
Date: Thu, 23 Aug 2007 17:09:59 -0700
Message-ID: <200708240009.l7O09xNg001528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55703 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933861AbXHXAKg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 20:10:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: ptrace floating point fixes
has been added to the -mm tree.  Its filename is
     uml-ptrace-floating-point-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: ptrace floating point fixes
From: Jeff Dike <jdike@addtoit.com>

Handle floating point state better in ptrace.  The code now correctly
distinguishes between PTRACE_[GS]ETFPREGS and PTRACE_[GS]ETFPXREGS.  The FPX
requests get handed off to arch-specific code because that's not generic.

get_fpregs, set_fpregs, set_fpregs, and set_fpxregs needed real
implementations.

Something here exposed a missing include in asm/page.h, which needed
linux/types.h in order to get gfp_t, so that's fixed here.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/ptrace.c         |   18 ++-----
 arch/um/sys-i386/ptrace.c       |   73 +++++++++++++++++++-----------
 arch/um/sys-x86_64/ptrace.c     |   53 ++++++++++++++++-----
 include/asm-um/page.h           |    1 
 include/asm-um/ptrace-generic.h |   11 ++--
 include/asm-um/ptrace-i386.h    |    6 ++
 6 files changed, 107 insertions(+), 55 deletions(-)

diff -puN arch/um/kernel/ptrace.c~uml-ptrace-floating-point-fixes arch/um/kernel/ptrace.c
--- a/arch/um/kernel/ptrace.c~uml-ptrace-floating-point-fixes
+++ a/arch/um/kernel/ptrace.c
@@ -143,22 +143,14 @@ long arch_ptrace(struct task_struct *chi
 #endif
 #ifdef PTRACE_GETFPREGS
 	case PTRACE_GETFPREGS: /* Get the child FPU state. */
-		ret = get_fpregs(data, child);
+		ret = get_fpregs((struct user_i387_struct __user *) data,
+				 child);
 		break;
 #endif
 #ifdef PTRACE_SETFPREGS
 	case PTRACE_SETFPREGS: /* Set the child FPU state. */
-	        ret = set_fpregs(data, child);
-		break;
-#endif
-#ifdef PTRACE_GETFPXREGS
-	case PTRACE_GETFPXREGS: /* Get the child FPU state. */
-		ret = get_fpxregs(data, child);
-		break;
-#endif
-#ifdef PTRACE_SETFPXREGS
-	case PTRACE_SETFPXREGS: /* Set the child FPU state. */
-		ret = set_fpxregs(data, child);
+	        ret = set_fpregs((struct user_i387_struct __user *) data,
+				 child);
 		break;
 #endif
 	case PTRACE_GET_THREAD_AREA:
@@ -227,6 +219,8 @@ long arch_ptrace(struct task_struct *chi
 #endif
 	default:
 		ret = ptrace_request(child, request, addr, data);
+		if (ret == -EIO)
+			ret = subarch_ptrace(child, request, addr, data);
 		break;
 	}
 
diff -puN arch/um/sys-i386/ptrace.c~uml-ptrace-floating-point-fixes arch/um/sys-i386/ptrace.c
--- a/arch/um/sys-i386/ptrace.c~uml-ptrace-floating-point-fixes
+++ a/arch/um/sys-i386/ptrace.c
@@ -6,6 +6,7 @@
 #include "linux/mm.h"
 #include "linux/sched.h"
 #include "asm/uaccess.h"
+#include "skas.h"
 
 extern int arch_switch_tls(struct task_struct *from, struct task_struct *to);
 
@@ -144,48 +145,64 @@ int peek_user(struct task_struct *child,
 	return put_user(tmp, (unsigned long __user *) data);
 }
 
-static inline int convert_fxsr_to_user(struct _fpstate __user *buf,
-				       struct pt_regs *regs)
+int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
-	return 0;
-}
+	int err, n, cpu = ((struct thread_info *) child->stack)->cpu;
+	long fpregs[HOST_FP_SIZE];
 
-static inline int convert_fxsr_from_user(struct pt_regs *regs,
-					 struct _fpstate __user *buf)
-{
-	return 0;
+	BUG_ON(sizeof(*buf) != sizeof(fpregs));
+	err = save_fp_registers(userspace_pid[cpu], fpregs);
+	if (err)
+		return err;
+
+	n = copy_to_user((void *) buf, fpregs, sizeof(fpregs));
+	if(n > 0)
+		return -EFAULT;
+
+	return n;
 }
 
-int get_fpregs(unsigned long buf, struct task_struct *child)
+int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
-	int err;
+	int n, cpu = ((struct thread_info *) child->stack)->cpu;
+	long fpregs[HOST_FP_SIZE];
 
-	err = convert_fxsr_to_user((struct _fpstate __user *) buf,
-				   &child->thread.regs);
-	if (err)
+	BUG_ON(sizeof(*buf) != sizeof(fpregs));
+	n = copy_from_user(fpregs, (void *) buf, sizeof(fpregs));
+	if (n > 0)
 		return -EFAULT;
-	return 0;
+
+	return restore_fp_registers(userspace_pid[cpu], fpregs);
 }
 
-int set_fpregs(unsigned long buf, struct task_struct *child)
+int get_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 {
-	int err;
+	int err, n, cpu = ((struct thread_info *) child->stack)->cpu;
+	long fpregs[HOST_XFP_SIZE];
 
-	err = convert_fxsr_from_user(&child->thread.regs,
-				     (struct _fpstate __user *) buf);
+	BUG_ON(sizeof(*buf) != sizeof(fpregs));
+	err = save_fpx_registers(userspace_pid[cpu], fpregs);
 	if (err)
+		return err;
+
+	n = copy_to_user((void *) buf, fpregs, sizeof(fpregs));
+	if(n > 0)
 		return -EFAULT;
-	return 0;
-}
 
-int get_fpxregs(unsigned long buf, struct task_struct *tsk)
-{
-	return 0;
+	return n;
 }
 
-int set_fpxregs(unsigned long buf, struct task_struct *tsk)
+int set_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 {
-	return 0;
+	int n, cpu = ((struct thread_info *) child->stack)->cpu;
+	long fpregs[HOST_XFP_SIZE];
+
+	BUG_ON(sizeof(*buf) != sizeof(fpregs));
+	n = copy_from_user(fpregs, (void *) buf, sizeof(fpregs));
+	if (n > 0)
+		return -EFAULT;
+
+	return restore_fpx_registers(userspace_pid[cpu], fpregs);
 }
 
 #ifdef notdef
@@ -209,3 +226,9 @@ int dump_fpu(struct pt_regs *regs, elf_f
 {
 	return 1;
 }
+
+long subarch_ptrace(struct task_struct *child, long request, long addr,
+		    long data)
+{
+	return -EIO;
+}
diff -puN arch/um/sys-x86_64/ptrace.c~uml-ptrace-floating-point-fixes arch/um/sys-x86_64/ptrace.c
--- a/arch/um/sys-x86_64/ptrace.c~uml-ptrace-floating-point-fixes
+++ a/arch/um/sys-x86_64/ptrace.c
@@ -156,28 +156,53 @@ int is_syscall(unsigned long addr)
 	return(instr == 0x050f);
 }
 
-int get_fpregs(unsigned long buf, struct task_struct *child)
+int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
-	panic("get_fpregs");
-	return(0);
-}
+	int err, n, cpu = ((struct thread_info *) child->stack)->cpu;
+	long fpregs[HOST_FP_SIZE];
 
-int set_fpregs(unsigned long buf, struct task_struct *child)
-{
-	panic("set_fpregs");
-	return(0);
+	BUG_ON(sizeof(*buf) != sizeof(fpregs));
+	err = save_fp_registers(userspace_pid[cpu], fpregs);
+	if (err)
+		return err;
+
+	n = copy_to_user((void *) buf, fpregs, sizeof(fpregs));
+	if(n > 0)
+		return -EFAULT;
+
+	return n;
 }
 
-int get_fpxregs(unsigned long buf, struct task_struct *tsk)
+int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
-	panic("get_fpxregs");
-	return(0);
+	int n, cpu = ((struct thread_info *) child->stack)->cpu;
+	long fpregs[HOST_FP_SIZE];
+
+	BUG_ON(sizeof(*buf) != sizeof(fpregs));
+	n = copy_from_user(fpregs, (void *) buf, sizeof(fpregs));
+	if (n > 0)
+		return -EFAULT;
+
+	return restore_fp_registers(userspace_pid[cpu], fpregs);
 }
 
-int set_fpxregs(unsigned long buf, struct task_struct *tsk)
+long subarch_ptrace(struct task_struct *child, long request, long addr,
+		    long data)
 {
-	panic("set_fxpregs");
-	return(0);
+	int ret = -EIO;
+
+	switch (request) {
+	case PTRACE_GETFPXREGS: /* Get the child FPU state. */
+		ret = get_fpregs((struct user_i387_struct __user *) data,
+				 child);
+		break;
+	case PTRACE_SETFPXREGS: /* Set the child FPU state. */
+		ret = set_fpregs((struct user_i387_struct __user *) data,
+				 child);
+		break;
+	}
+
+	return ret;
 }
 
 /*
diff -puN include/asm-um/page.h~uml-ptrace-floating-point-fixes include/asm-um/page.h
--- a/include/asm-um/page.h~uml-ptrace-floating-point-fixes
+++ a/include/asm-um/page.h
@@ -9,6 +9,7 @@
 
 struct page;
 
+#include <linux/types.h>
 #include <asm/vm-flags.h>
 
 /* PAGE_SHIFT determines the page size */
diff -puN include/asm-um/ptrace-generic.h~uml-ptrace-floating-point-fixes include/asm-um/ptrace-generic.h
--- a/include/asm-um/ptrace-generic.h~uml-ptrace-floating-point-fixes
+++ a/include/asm-um/ptrace-generic.h
@@ -9,6 +9,7 @@
 #ifndef __ASSEMBLY__
 
 #include "asm/arch/ptrace-abi.h"
+#include <asm/user.h>
 #include "sysdep/ptrace.h"
 
 struct pt_regs {
@@ -35,12 +36,14 @@ struct pt_regs {
 
 struct task_struct;
 
+extern long subarch_ptrace(struct task_struct *child, long request, long addr,
+			   long data);
 extern unsigned long getreg(struct task_struct *child, int regno);
 extern int putreg(struct task_struct *child, int regno, unsigned long value);
-extern int get_fpregs(unsigned long buf, struct task_struct *child);
-extern int set_fpregs(unsigned long buf, struct task_struct *child);
-extern int get_fpxregs(unsigned long buf, struct task_struct *child);
-extern int set_fpxregs(unsigned long buf, struct task_struct *tsk);
+extern int get_fpregs(struct user_i387_struct __user *buf,
+		      struct task_struct *child);
+extern int set_fpregs(struct user_i387_struct __user *buf,
+		      struct task_struct *child);
 
 extern void show_regs(struct pt_regs *regs);
 
diff -puN include/asm-um/ptrace-i386.h~uml-ptrace-floating-point-fixes include/asm-um/ptrace-i386.h
--- a/include/asm-um/ptrace-i386.h~uml-ptrace-floating-point-fixes
+++ a/include/asm-um/ptrace-i386.h
@@ -10,6 +10,7 @@
 
 #include "linux/compiler.h"
 #include "asm/ptrace-generic.h"
+#include <asm/user.h>
 #include "sysdep/ptrace.h"
 
 #define PT_REGS_EAX(r) UPT_EAX(&(r)->regs)
@@ -45,6 +46,11 @@
  */
 struct user_desc;
 
+extern int get_fpxregs(struct user_fxsr_struct __user *buf,
+		       struct task_struct *child);
+extern int set_fpxregs(struct user_fxsr_struct __user *buf,
+		       struct task_struct *tsk);
+
 extern int ptrace_get_thread_area(struct task_struct *child, int idx,
                                   struct user_desc __user *user_desc);
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

introduce-config_check_signature-was-re-uninline.patch
uml-fix-previous-request-size-limit-fix.patch
uml-fix-linker-script-alignment-bugs.patch
uml-fix-x86_64-core-dump-crash.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
uml-fix-inlines.patch
uml-use-64-bits-for-block-size-on-x86_64.patch
uml-userspace-files-should-call-libc-directly.patch
uml-clean-up-tlb-flush-path.patch
uml-remove-unneeded-if-from-hostfs.patch
uml-fix-hostfs-style.patch
uml-dont-use-glibc-asm-userh.patch
uml-floating-point-signal-delivery-fixes.patch
uml-ptrace-floating-point-fixes.patch
uml-coredumping-floating-point-fixes.patch
uml-sysrq-and-mconsole-fixes.patch
uml-style-fixes-in-fp-code.patch
uml-eliminate-floating-point-state-from-register-file.patch
