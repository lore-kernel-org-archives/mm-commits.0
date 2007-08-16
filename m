From: akpm@linux-foundation.org
Subject: + uml-throw-out-choose_mode.patch added to -mm tree
Date: Thu, 16 Aug 2007 14:14:18 -0700
Message-ID: <200708162114.l7GLEJPi007083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45965 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757838AbXHPVOg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 17:14:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: throw out CHOOSE_MODE
has been added to the -mm tree.  Its filename is
     uml-throw-out-choose_mode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: throw out CHOOSE_MODE
From: Jeff Dike <jdike@addtoit.com>

The next stage after removing code which depends on CONFIG_MODE_TT is removing
the CHOOSE_MODE abstraction, which provided both compile-time and run-time
branching to either tt-mode or skas-mode code.

This patch removes choose-mode.h and all inclusions of it, and replaces all
CHOOSE_MODE invocations with the skas branch.  This leaves a number of trivial
functions which will be dealt with in a later patch.

There are some changes in the uaccess and tls support which go somewhat beyond
this and eliminate some of the now-redundant functions.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_user.c            |    3 
 arch/um/drivers/harddog_user.c         |    3 
 arch/um/drivers/mconsole_kern.c        |    1 
 arch/um/include/choose-mode.h          |   20 -----
 arch/um/include/skas/uaccess-skas.h    |   21 -----
 arch/um/include/sysdep-i386/ptrace.h   |   67 ++++++-------------
 arch/um/include/sysdep-x86_64/ptrace.h |   81 +++++++++--------------
 arch/um/include/um_mmu.h               |    1 
 arch/um/include/um_uaccess.h           |   39 +----------
 arch/um/kernel/exec.c                  |    5 -
 arch/um/kernel/ksyms.c                 |   10 +-
 arch/um/kernel/physmem.c               |    2 
 arch/um/kernel/process.c               |   19 +----
 arch/um/kernel/reboot.c                |    7 -
 arch/um/kernel/skas/uaccess.c          |   12 +--
 arch/um/kernel/syscall.c               |    1 
 arch/um/kernel/time.c                  |    4 -
 arch/um/kernel/tlb.c                   |   17 +---
 arch/um/kernel/um_arch.c               |   13 +--
 arch/um/os-Linux/aio.c                 |    5 -
 arch/um/os-Linux/main.c                |   10 --
 arch/um/os-Linux/signal.c              |    6 -
 arch/um/os-Linux/start_up.c            |    1 
 arch/um/os-Linux/trap.c                |    1 
 arch/um/sys-i386/ldt.c                 |    4 -
 arch/um/sys-i386/ptrace.c              |   17 +---
 arch/um/sys-i386/signal.c              |   12 ---
 arch/um/sys-i386/tls.c                 |    7 -
 arch/um/sys-x86_64/signal.c            |    9 --
 arch/um/sys-x86_64/syscalls.c          |    4 -
 include/asm-um/a.out.h                 |    7 -
 include/asm-um/mmu_context.h           |   12 +--
 include/asm-um/processor-generic.h     |    1 
 include/asm-um/ptrace-i386.h           |   12 ---
 include/asm-um/tlbflush.h              |    6 -
 include/asm-um/uaccess.h               |    2 
 36 files changed, 131 insertions(+), 311 deletions(-)

diff -puN arch/um/drivers/chan_user.c~uml-throw-out-choose_mode arch/um/drivers/chan_user.c
--- a/arch/um/drivers/chan_user.c~uml-throw-out-choose_mode
+++ a/arch/um/drivers/chan_user.c
@@ -264,8 +264,7 @@ void register_winch(int fd, struct tty_s
 		return;
 
 	pid = tcgetpgrp(fd);
-	if (!CHOOSE_MODE_PROC(is_tracer_winch, is_skas_winch, pid, fd, tty) &&
-	    (pid == -1)) {
+	if (!is_skas_winch(pid, fd, tty) && (pid == -1)) {
 		thread = winch_tramp(fd, tty, &thread_fd, &stack);
 		if (thread < 0)
 			return;
diff -puN arch/um/drivers/harddog_user.c~uml-throw-out-choose_mode arch/um/drivers/harddog_user.c
--- a/arch/um/drivers/harddog_user.c~uml-throw-out-choose_mode
+++ a/arch/um/drivers/harddog_user.c
@@ -9,7 +9,6 @@
 #include "user.h"
 #include "mconsole.h"
 #include "os.h"
-#include "choose-mode.h"
 #include "mode.h"
 
 struct dog_data {
@@ -64,7 +63,7 @@ int start_watchdog(int *in_fd_ret, int *
 	}
 	else {
 		/* XXX The os_getpid() is not SMP correct */
-		sprintf(pid_buf, "%d", CHOOSE_MODE(tracing_pid, os_getpid()));
+		sprintf(pid_buf, "%d", os_getpid());
 		args = pid_args;
 	}
 
diff -puN arch/um/drivers/mconsole_kern.c~uml-throw-out-choose_mode arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-throw-out-choose_mode
+++ a/arch/um/drivers/mconsole_kern.c
@@ -33,7 +33,6 @@
 #include "init.h"
 #include "os.h"
 #include "irq_kern.h"
-#include "choose-mode.h"
 
 static int do_unlink_socket(struct notifier_block *notifier,
 			    unsigned long what, void *data)
diff -puN arch/um/include/choose-mode.h~uml-throw-out-choose_mode /dev/null
--- a/arch/um/include/choose-mode.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __CHOOSE_MODE_H__
-#define __CHOOSE_MODE_H__
-
-#include "uml-config.h"
-
-#define CHOOSE_MODE(tt, skas) (skas)
-
-#define CHOOSE_MODE_PROC(tt, skas, args...) \
-	CHOOSE_MODE(tt(args), skas(args))
-
-#ifndef __CHOOSE_MODE
-#define __CHOOSE_MODE(tt, skas) CHOOSE_MODE(tt, skas)
-#endif
-
-#endif
diff -puN arch/um/include/skas/uaccess-skas.h~uml-throw-out-choose_mode /dev/null
--- a/arch/um/include/skas/uaccess-skas.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __SKAS_UACCESS_H
-#define __SKAS_UACCESS_H
-
-#include "asm/errno.h"
-
-/* No SKAS-specific checking. */
-#define access_ok_skas(type, addr, size) 0
-
-extern int copy_from_user_skas(void *to, const void __user *from, int n);
-extern int copy_to_user_skas(void __user *to, const void *from, int n);
-extern int strncpy_from_user_skas(char *dst, const char __user *src, int count);
-extern int __clear_user_skas(void __user *mem, int len);
-extern int clear_user_skas(void __user *mem, int len);
-extern int strnlen_user_skas(const void __user *str, int len);
-
-#endif
diff -puN arch/um/include/sysdep-i386/ptrace.h~uml-throw-out-choose_mode arch/um/include/sysdep-i386/ptrace.h
--- a/arch/um/include/sysdep-i386/ptrace.h~uml-throw-out-choose_mode
+++ a/arch/um/include/sysdep-i386/ptrace.h
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -9,7 +9,6 @@
 #include "uml-config.h"
 #include "user_constants.h"
 #include "sysdep/faultinfo.h"
-#include "choose-mode.h"
 
 #define MAX_REG_NR (UM_FRAME_SIZE / sizeof(unsigned long))
 #define MAX_REG_OFFSET (UM_FRAME_SIZE)
@@ -67,40 +66,23 @@ union uml_pt_regs {
 #define EMPTY_UML_PT_REGS { }
 
 #define UPT_SC(r) ((r)->tt.sc)
-#define UPT_IP(r) \
-	__CHOOSE_MODE(SC_IP(UPT_SC(r)), REGS_IP((r)->skas.regs))
-#define UPT_SP(r) \
-	__CHOOSE_MODE(SC_SP(UPT_SC(r)), REGS_SP((r)->skas.regs))
-#define UPT_EFLAGS(r) \
-	__CHOOSE_MODE(SC_EFLAGS(UPT_SC(r)), REGS_EFLAGS((r)->skas.regs))
-#define UPT_EAX(r) \
-	__CHOOSE_MODE(SC_EAX(UPT_SC(r)), REGS_EAX((r)->skas.regs))
-#define UPT_EBX(r) \
-	__CHOOSE_MODE(SC_EBX(UPT_SC(r)), REGS_EBX((r)->skas.regs))
-#define UPT_ECX(r) \
-	__CHOOSE_MODE(SC_ECX(UPT_SC(r)), REGS_ECX((r)->skas.regs))
-#define UPT_EDX(r) \
-	__CHOOSE_MODE(SC_EDX(UPT_SC(r)), REGS_EDX((r)->skas.regs))
-#define UPT_ESI(r) \
-	__CHOOSE_MODE(SC_ESI(UPT_SC(r)), REGS_ESI((r)->skas.regs))
-#define UPT_EDI(r) \
-	__CHOOSE_MODE(SC_EDI(UPT_SC(r)), REGS_EDI((r)->skas.regs))
-#define UPT_EBP(r) \
-	__CHOOSE_MODE(SC_EBP(UPT_SC(r)), REGS_EBP((r)->skas.regs))
-#define UPT_ORIG_EAX(r) \
-	__CHOOSE_MODE((r)->tt.syscall, (r)->skas.syscall)
-#define UPT_CS(r) \
-	__CHOOSE_MODE(SC_CS(UPT_SC(r)), REGS_CS((r)->skas.regs))
-#define UPT_SS(r) \
-	__CHOOSE_MODE(SC_SS(UPT_SC(r)), REGS_SS((r)->skas.regs))
-#define UPT_DS(r) \
-	__CHOOSE_MODE(SC_DS(UPT_SC(r)), REGS_DS((r)->skas.regs))
-#define UPT_ES(r) \
-	__CHOOSE_MODE(SC_ES(UPT_SC(r)), REGS_ES((r)->skas.regs))
-#define UPT_FS(r) \
-	__CHOOSE_MODE(SC_FS(UPT_SC(r)), REGS_FS((r)->skas.regs))
-#define UPT_GS(r) \
-	__CHOOSE_MODE(SC_GS(UPT_SC(r)), REGS_GS((r)->skas.regs))
+#define UPT_IP(r) REGS_IP((r)->skas.regs)
+#define UPT_SP(r) REGS_SP((r)->skas.regs)
+#define UPT_EFLAGS(r) REGS_EFLAGS((r)->skas.regs)
+#define UPT_EAX(r) REGS_EAX((r)->skas.regs)
+#define UPT_EBX(r) REGS_EBX((r)->skas.regs)
+#define UPT_ECX(r) REGS_ECX((r)->skas.regs)
+#define UPT_EDX(r) REGS_EDX((r)->skas.regs)
+#define UPT_ESI(r) REGS_ESI((r)->skas.regs)
+#define UPT_EDI(r) REGS_EDI((r)->skas.regs)
+#define UPT_EBP(r) REGS_EBP((r)->skas.regs)
+#define UPT_ORIG_EAX(r) ((r)->skas.syscall)
+#define UPT_CS(r) REGS_CS((r)->skas.regs)
+#define UPT_SS(r) REGS_SS((r)->skas.regs)
+#define UPT_DS(r) REGS_DS((r)->skas.regs)
+#define UPT_ES(r) REGS_ES((r)->skas.regs)
+#define UPT_FS(r) REGS_FS((r)->skas.regs)
+#define UPT_GS(r) REGS_GS((r)->skas.regs)
 
 #define UPT_SYSCALL_ARG1(r) UPT_EBX(r)
 #define UPT_SYSCALL_ARG2(r) UPT_ECX(r)
@@ -111,8 +93,7 @@ union uml_pt_regs {
 
 extern int user_context(unsigned long sp);
 
-#define UPT_IS_USER(r) \
-	CHOOSE_MODE(user_context(UPT_SP(r)), (r)->skas.is_user)
+#define UPT_IS_USER(r) ((r)->skas.is_user)
 
 struct syscall_args {
 	unsigned long args[6];
@@ -181,18 +162,14 @@ struct syscall_args {
 	} while (0)
 
 #define UPT_SET_SYSCALL_RETURN(r, res) \
-	CHOOSE_MODE(SC_SET_SYSCALL_RETURN(UPT_SC(r), (res)), \
-                    REGS_SET_SYSCALL_RETURN((r)->skas.regs, (res)))
+	REGS_SET_SYSCALL_RETURN((r)->skas.regs, (res))
 
-#define UPT_RESTART_SYSCALL(r) \
-	CHOOSE_MODE(SC_RESTART_SYSCALL(UPT_SC(r)), \
-		    REGS_RESTART_SYSCALL((r)->skas.regs))
+#define UPT_RESTART_SYSCALL(r) REGS_RESTART_SYSCALL((r)->skas.regs)
 
 #define UPT_ORIG_SYSCALL(r) UPT_EAX(r)
 #define UPT_SYSCALL_NR(r) UPT_ORIG_EAX(r)
 #define UPT_SYSCALL_RET(r) UPT_EAX(r)
 
-#define UPT_FAULTINFO(r) \
-        CHOOSE_MODE((&(r)->tt.faultinfo), (&(r)->skas.faultinfo))
+#define UPT_FAULTINFO(r) (&(r)->skas.faultinfo)
 
 #endif
diff -puN arch/um/include/sysdep-x86_64/ptrace.h~uml-throw-out-choose_mode arch/um/include/sysdep-x86_64/ptrace.h
--- a/arch/um/include/sysdep-x86_64/ptrace.h~uml-throw-out-choose_mode
+++ a/arch/um/include/sysdep-x86_64/ptrace.h
@@ -84,8 +84,6 @@
 
 #define REGS_ERR(r) ((r)->fault_type)
 
-#include "choose-mode.h"
-
 /* XXX */
 union uml_pt_regs {
 	struct skas_regs {
@@ -99,48 +97,45 @@ union uml_pt_regs {
 
 #define EMPTY_UML_PT_REGS { }
 
-#define UPT_RBX(r) __CHOOSE_MODE(SC_RBX(UPT_SC(r)), REGS_RBX((r)->skas.regs))
-#define UPT_RCX(r) __CHOOSE_MODE(SC_RCX(UPT_SC(r)), REGS_RCX((r)->skas.regs))
-#define UPT_RDX(r) __CHOOSE_MODE(SC_RDX(UPT_SC(r)), REGS_RDX((r)->skas.regs))
-#define UPT_RSI(r) __CHOOSE_MODE(SC_RSI(UPT_SC(r)), REGS_RSI((r)->skas.regs))
-#define UPT_RDI(r) __CHOOSE_MODE(SC_RDI(UPT_SC(r)), REGS_RDI((r)->skas.regs))
-#define UPT_RBP(r) __CHOOSE_MODE(SC_RBP(UPT_SC(r)), REGS_RBP((r)->skas.regs))
-#define UPT_RAX(r) __CHOOSE_MODE(SC_RAX(UPT_SC(r)), REGS_RAX((r)->skas.regs))
-#define UPT_R8(r) __CHOOSE_MODE(SC_R8(UPT_SC(r)), REGS_R8((r)->skas.regs))
-#define UPT_R9(r) __CHOOSE_MODE(SC_R9(UPT_SC(r)), REGS_R9((r)->skas.regs))
-#define UPT_R10(r) __CHOOSE_MODE(SC_R10(UPT_SC(r)), REGS_R10((r)->skas.regs))
-#define UPT_R11(r) __CHOOSE_MODE(SC_R11(UPT_SC(r)), REGS_R11((r)->skas.regs))
-#define UPT_R12(r) __CHOOSE_MODE(SC_R12(UPT_SC(r)), REGS_R12((r)->skas.regs))
-#define UPT_R13(r) __CHOOSE_MODE(SC_R13(UPT_SC(r)), REGS_R13((r)->skas.regs))
-#define UPT_R14(r) __CHOOSE_MODE(SC_R14(UPT_SC(r)), REGS_R14((r)->skas.regs))
-#define UPT_R15(r) __CHOOSE_MODE(SC_R15(UPT_SC(r)), REGS_R15((r)->skas.regs))
-#define UPT_CS(r) __CHOOSE_MODE(SC_CS(UPT_SC(r)), REGS_CS((r)->skas.regs))
+#define UPT_RBX(r) REGS_RBX((r)->skas.regs)
+#define UPT_RCX(r) REGS_RCX((r)->skas.regs)
+#define UPT_RDX(r) REGS_RDX((r)->skas.regs)
+#define UPT_RSI(r) REGS_RSI((r)->skas.regs)
+#define UPT_RDI(r) REGS_RDI((r)->skas.regs)
+#define UPT_RBP(r) REGS_RBP((r)->skas.regs)
+#define UPT_RAX(r) REGS_RAX((r)->skas.regs)
+#define UPT_R8(r) REGS_R8((r)->skas.regs)
+#define UPT_R9(r) REGS_R9((r)->skas.regs)
+#define UPT_R10(r) REGS_R10((r)->skas.regs)
+#define UPT_R11(r) REGS_R11((r)->skas.regs)
+#define UPT_R12(r) REGS_R12((r)->skas.regs)
+#define UPT_R13(r) REGS_R13((r)->skas.regs)
+#define UPT_R14(r) REGS_R14((r)->skas.regs)
+#define UPT_R15(r) REGS_R15((r)->skas.regs)
+#define UPT_CS(r) REGS_CS((r)->skas.regs)
 #define UPT_FS_BASE(r) \
-	__CHOOSE_MODE(SC_FS_BASE(UPT_SC(r)), REGS_FS_BASE((r)->skas.regs))
-#define UPT_FS(r) __CHOOSE_MODE(SC_FS(UPT_SC(r)), REGS_FS((r)->skas.regs))
+	REGS_FS_BASE((r)->skas.regs)
+#define UPT_FS(r) REGS_FS((r)->skas.regs)
 #define UPT_GS_BASE(r) \
-	__CHOOSE_MODE(SC_GS_BASE(UPT_SC(r)), REGS_GS_BASE((r)->skas.regs))
-#define UPT_GS(r) __CHOOSE_MODE(SC_GS(UPT_SC(r)), REGS_GS((r)->skas.regs))
-#define UPT_DS(r) __CHOOSE_MODE(SC_DS(UPT_SC(r)), REGS_DS((r)->skas.regs))
-#define UPT_ES(r) __CHOOSE_MODE(SC_ES(UPT_SC(r)), REGS_ES((r)->skas.regs))
-#define UPT_CS(r) __CHOOSE_MODE(SC_CS(UPT_SC(r)), REGS_CS((r)->skas.regs))
-#define UPT_SS(r) __CHOOSE_MODE(SC_SS(UPT_SC(r)), REGS_SS((r)->skas.regs))
-#define UPT_ORIG_RAX(r) \
-	__CHOOSE_MODE((r)->tt.orig_rax, REGS_ORIG_RAX((r)->skas.regs))
+	REGS_GS_BASE((r)->skas.regs)
+#define UPT_GS(r) REGS_GS((r)->skas.regs)
+#define UPT_DS(r) REGS_DS((r)->skas.regs)
+#define UPT_ES(r) REGS_ES((r)->skas.regs)
+#define UPT_CS(r) REGS_CS((r)->skas.regs)
+#define UPT_SS(r) REGS_SS((r)->skas.regs)
+#define UPT_ORIG_RAX(r) REGS_ORIG_RAX((r)->skas.regs)
 
-#define UPT_IP(r) __CHOOSE_MODE(SC_IP(UPT_SC(r)), REGS_IP((r)->skas.regs))
-#define UPT_SP(r) __CHOOSE_MODE(SC_SP(UPT_SC(r)), REGS_SP((r)->skas.regs))
+#define UPT_IP(r) REGS_IP((r)->skas.regs)
+#define UPT_SP(r) REGS_SP((r)->skas.regs)
 
-#define UPT_EFLAGS(r) \
-	__CHOOSE_MODE(SC_EFLAGS(UPT_SC(r)), REGS_EFLAGS((r)->skas.regs))
+#define UPT_EFLAGS(r) REGS_EFLAGS((r)->skas.regs)
 #define UPT_SC(r) ((r)->tt.sc)
-#define UPT_SYSCALL_NR(r) __CHOOSE_MODE((r)->tt.syscall, (r)->skas.syscall)
+#define UPT_SYSCALL_NR(r) ((r)->skas.syscall)
 #define UPT_SYSCALL_RET(r) UPT_RAX(r)
 
 extern int user_context(unsigned long sp);
 
-#define UPT_IS_USER(r) \
-	CHOOSE_MODE(user_context(UPT_SP(r)), (r)->skas.is_user)
+#define UPT_IS_USER(r) ((r)->skas.is_user)
 
 #define UPT_SYSCALL_ARG1(r) UPT_RDI(r)
 #define UPT_SYSCALL_ARG2(r) UPT_RSI(r)
@@ -237,18 +232,12 @@ struct syscall_args {
         })
 
 #define UPT_SET_SYSCALL_RETURN(r, res) \
-	CHOOSE_MODE(SC_SET_SYSCALL_RETURN(UPT_SC(r), (res)), \
-                    REGS_SET_SYSCALL_RETURN((r)->skas.regs, (res)))
+	REGS_SET_SYSCALL_RETURN((r)->skas.regs, (res))
+
+#define UPT_RESTART_SYSCALL(r) REGS_RESTART_SYSCALL((r)->skas.regs)
 
-#define UPT_RESTART_SYSCALL(r) \
-	CHOOSE_MODE(SC_RESTART_SYSCALL(UPT_SC(r)), \
-		    REGS_RESTART_SYSCALL((r)->skas.regs))
-
-#define UPT_SEGV_IS_FIXABLE(r) \
-	CHOOSE_MODE(SC_SEGV_IS_FIXABLE(UPT_SC(r)), \
-                    REGS_SEGV_IS_FIXABLE(&r->skas))
+#define UPT_SEGV_IS_FIXABLE(r) REGS_SEGV_IS_FIXABLE(&r->skas)
 
-#define UPT_FAULTINFO(r) \
-        CHOOSE_MODE((&(r)->tt.faultinfo), (&(r)->skas.faultinfo))
+#define UPT_FAULTINFO(r) (&(r)->skas.faultinfo)
 
 #endif
diff -puN arch/um/include/um_mmu.h~uml-throw-out-choose_mode arch/um/include/um_mmu.h
--- a/arch/um/include/um_mmu.h~uml-throw-out-choose_mode
+++ a/arch/um/include/um_mmu.h
@@ -7,7 +7,6 @@
 #define __ARCH_UM_MMU_H
 
 #include "uml-config.h"
-#include "choose-mode.h"
 #include "mmu-skas.h"
 
 typedef union mm_context {
diff -puN arch/um/include/um_uaccess.h~uml-throw-out-choose_mode arch/um/include/um_uaccess.h
--- a/arch/um/include/um_uaccess.h~uml-throw-out-choose_mode
+++ a/arch/um/include/um_uaccess.h
@@ -6,8 +6,6 @@
 #ifndef __ARCH_UM_UACCESS_H
 #define __ARCH_UM_UACCESS_H
 
-#include "choose-mode.h"
-#include "uaccess-skas.h"
 #include "asm/fixmap.h"
 
 #define __under_task_size(addr, size) \
@@ -27,20 +25,10 @@
 	(__addr_range_nowrap(addr, size) && \
 	 (__under_task_size(addr, size) || \
 	  __access_ok_vsyscall(type, addr, size) || \
-	  segment_eq(get_fs(), KERNEL_DS) || \
-	  CHOOSE_MODE_PROC(access_ok_tt, access_ok_skas, type, addr, size)))
+	  segment_eq(get_fs(), KERNEL_DS)))
 
-static inline int copy_from_user(void *to, const void __user *from, int n)
-{
-	return(CHOOSE_MODE_PROC(copy_from_user_tt, copy_from_user_skas, to,
-				from, n));
-}
-
-static inline int copy_to_user(void __user *to, const void *from, int n)
-{
-	return(CHOOSE_MODE_PROC(copy_to_user_tt, copy_to_user_skas, to, 
-				from, n));
-}
+extern int copy_from_user(void *to, const void __user *from, int n);
+extern int copy_to_user(void __user *to, const void *from, int n);
 
 /*
  * strncpy_from_user: - Copy a NUL terminated string from userspace.
@@ -61,11 +49,7 @@ static inline int copy_to_user(void __us
  * and returns @count.
  */
 
-static inline int strncpy_from_user(char *dst, const char __user *src, int count)
-{
-	return(CHOOSE_MODE_PROC(strncpy_from_user_tt, strncpy_from_user_skas,
-				dst, src, count));
-}
+extern int strncpy_from_user(char *dst, const char __user *src, int count);
 
 /*
  * __clear_user: - Zero a block of memory in user space, with less checking.
@@ -78,10 +62,7 @@ static inline int strncpy_from_user(char
  * Returns number of bytes that could not be cleared.
  * On success, this will be zero.
  */
-static inline int __clear_user(void *mem, int len)
-{
-	return(CHOOSE_MODE_PROC(__clear_user_tt, __clear_user_skas, mem, len));
-}
+extern int __clear_user(void __user *mem, int len);
 
 /*
  * clear_user: - Zero a block of memory in user space.
@@ -93,10 +74,7 @@ static inline int __clear_user(void *mem
  * Returns number of bytes that could not be cleared.
  * On success, this will be zero.
  */
-static inline int clear_user(void __user *mem, int len)
-{
-	return(CHOOSE_MODE_PROC(clear_user_tt, clear_user_skas, mem, len));
-}
+extern int clear_user(void __user *mem, int len);
 
 /*
  * strlen_user: - Get the size of a string in user space.
@@ -109,10 +87,7 @@ static inline int clear_user(void __user
  * On exception, returns 0.
  * If the string is too long, returns a value greater than @n.
  */
-static inline int strnlen_user(const void __user *str, long len)
-{
-	return(CHOOSE_MODE_PROC(strnlen_user_tt, strnlen_user_skas, str, len));
-}
+extern int strnlen_user(const void __user *str, int len);
 
 #endif
 
diff -puN arch/um/kernel/exec.c~uml-throw-out-choose_mode arch/um/kernel/exec.c
--- a/arch/um/kernel/exec.c~uml-throw-out-choose_mode
+++ a/arch/um/kernel/exec.c
@@ -18,18 +18,17 @@
 #include "irq_user.h"
 #include "tlb.h"
 #include "os.h"
-#include "choose-mode.h"
 #include "mode_kern.h"
 
 void flush_thread(void)
 {
 	arch_flush_thread(&current->thread.arch);
-	CHOOSE_MODE(flush_thread_tt(), flush_thread_skas());
+	flush_thread_skas();
 }
 
 void start_thread(struct pt_regs *regs, unsigned long eip, unsigned long esp)
 {
-	CHOOSE_MODE_PROC(start_thread_tt, start_thread_skas, regs, eip, esp);
+	start_thread_skas(regs, eip, esp);
 }
 
 #ifdef CONFIG_TTY_LOG
diff -puN arch/um/kernel/ksyms.c~uml-throw-out-choose_mode arch/um/kernel/ksyms.c
--- a/arch/um/kernel/ksyms.c~uml-throw-out-choose_mode
+++ a/arch/um/kernel/ksyms.c
@@ -37,11 +37,11 @@ EXPORT_SYMBOL(um_virt_to_phys);
 EXPORT_SYMBOL(handle_page_fault);
 EXPORT_SYMBOL(find_iomem);
 
-EXPORT_SYMBOL(strnlen_user_skas);
-EXPORT_SYMBOL(strncpy_from_user_skas);
-EXPORT_SYMBOL(copy_to_user_skas);
-EXPORT_SYMBOL(copy_from_user_skas);
-EXPORT_SYMBOL(clear_user_skas);
+EXPORT_SYMBOL(strnlen_user);
+EXPORT_SYMBOL(strncpy_from_user);
+EXPORT_SYMBOL(copy_to_user);
+EXPORT_SYMBOL(copy_from_user);
+EXPORT_SYMBOL(clear_user);
 EXPORT_SYMBOL(uml_strdup);
 
 EXPORT_SYMBOL(os_stat_fd);
diff -puN arch/um/kernel/physmem.c~uml-throw-out-choose_mode arch/um/kernel/physmem.c
--- a/arch/um/kernel/physmem.c~uml-throw-out-choose_mode
+++ a/arch/um/kernel/physmem.c
@@ -61,7 +61,7 @@ static unsigned long kmem_top = 0;
 unsigned long get_kmem_end(void)
 {
 	if (kmem_top == 0)
-		kmem_top = CHOOSE_MODE(kmem_end_tt, kmem_end_skas);
+		kmem_top = kmem_end_skas;
 	return kmem_top;
 }
 
diff -puN arch/um/kernel/process.c~uml-throw-out-choose_mode arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-throw-out-choose_mode
+++ a/arch/um/kernel/process.c
@@ -45,7 +45,6 @@
 #include "os.h"
 #include "mode.h"
 #include "mode_kern.h"
-#include "choose-mode.h"
 
 /* This is a per-cpu array.  A processor only modifies its entry and it only
  * cares about its entry, so it's OK if another processor is modifying its
@@ -55,7 +54,7 @@ struct cpu_task cpu_tasks[NR_CPUS] = { [
 
 static inline int external_pid(struct task_struct *task)
 {
-	return CHOOSE_MODE_PROC(external_pid_tt, external_pid_skas, task);
+	return external_pid_skas(task);
 }
 
 int pid_to_processor_id(int pid)
@@ -114,8 +113,8 @@ void *_switch_to(void *prev, void *next,
 	set_current(to);
 
 	do {
-		current->thread.saved_task = NULL ;
-		CHOOSE_MODE_PROC(switch_to_tt, switch_to_skas, prev, next);
+		current->thread.saved_task = NULL;
+		switch_to_skas(prev, next);
 		if(current->thread.saved_task)
 			show_regs(&(current->thread.regs));
 		next= current->thread.saved_task;
@@ -136,7 +135,7 @@ void interrupt_end(void)
 
 void release_thread(struct task_struct *task)
 {
-	CHOOSE_MODE(release_thread_tt(task), release_thread_skas(task));
+	release_thread_skas(task);
 }
 
 void exit_thread(void)
@@ -155,8 +154,7 @@ int copy_thread(int nr, unsigned long cl
 	int ret;
 
 	p->thread = (struct thread_struct) INIT_THREAD;
-	ret = CHOOSE_MODE_PROC(copy_thread_tt, copy_thread_skas, nr,
-				clone_flags, sp, stack_top, p, regs);
+	ret = copy_thread_skas(nr, clone_flags, sp, stack_top, p, regs);
 
 	if (ret || !current->thread.forking)
 		goto out;
@@ -178,15 +176,12 @@ void initial_thread_cb(void (*proc)(void
 	int save_kmalloc_ok = kmalloc_ok;
 
 	kmalloc_ok = 0;
-	CHOOSE_MODE_PROC(initial_thread_cb_tt, initial_thread_cb_skas, proc,
-			 arg);
+	initial_thread_cb_skas(proc, arg);
 	kmalloc_ok = save_kmalloc_ok;
 }
 
 void default_idle(void)
 {
-	CHOOSE_MODE(uml_idle_timer(), (void) 0);
-
 	while(1){
 		/* endless idle loop with no priority at all */
 
@@ -203,7 +198,7 @@ void default_idle(void)
 
 void cpu_idle(void)
 {
-	CHOOSE_MODE(init_idle_tt(), init_idle_skas());
+	init_idle_skas();
 }
 
 void *um_virt_to_phys(struct task_struct *task, unsigned long addr,
diff -puN arch/um/kernel/reboot.c~uml-throw-out-choose_mode arch/um/kernel/reboot.c
--- a/arch/um/kernel/reboot.c~uml-throw-out-choose_mode
+++ a/arch/um/kernel/reboot.c
@@ -10,13 +10,12 @@
 #include "kern.h"
 #include "os.h"
 #include "mode.h"
-#include "choose-mode.h"
 
 void (*pm_power_off)(void);
 
 static void kill_off_processes(void)
 {
-	CHOOSE_MODE(kill_off_processes_tt(), kill_off_processes_skas());
+	kill_off_processes_skas();
 }
 
 void uml_cleanup(void)
@@ -29,13 +28,13 @@ void uml_cleanup(void)
 void machine_restart(char * __unused)
 {
         uml_cleanup();
-	CHOOSE_MODE(reboot_tt(), reboot_skas());
+	reboot_skas();
 }
 
 void machine_power_off(void)
 {
         uml_cleanup();
-	CHOOSE_MODE(halt_tt(), halt_skas());
+	halt_skas();
 }
 
 void machine_halt(void)
diff -puN arch/um/kernel/skas/uaccess.c~uml-throw-out-choose_mode arch/um/kernel/skas/uaccess.c
--- a/arch/um/kernel/skas/uaccess.c~uml-throw-out-choose_mode
+++ a/arch/um/kernel/skas/uaccess.c
@@ -139,7 +139,7 @@ static int copy_chunk_from_user(unsigned
 	return(0);
 }
 
-int copy_from_user_skas(void *to, const void __user *from, int n)
+int copy_from_user(void *to, const void __user *from, int n)
 {
 	if(segment_eq(get_fs(), KERNEL_DS)){
 		memcpy(to, (__force void*)from, n);
@@ -160,7 +160,7 @@ static int copy_chunk_to_user(unsigned l
 	return(0);
 }
 
-int copy_to_user_skas(void __user *to, const void *from, int n)
+int copy_to_user(void __user *to, const void *from, int n)
 {
 	if(segment_eq(get_fs(), KERNEL_DS)){
 		memcpy((__force void*)to, from, n);
@@ -186,7 +186,7 @@ static int strncpy_chunk_from_user(unsig
 	return(0);
 }
 
-int strncpy_from_user_skas(char *dst, const char __user *src, int count)
+int strncpy_from_user(char *dst, const char __user *src, int count)
 {
 	int n;
 	char *ptr = dst;
@@ -212,12 +212,12 @@ static int clear_chunk(unsigned long add
 	return(0);
 }
 
-int __clear_user_skas(void __user *mem, int len)
+int __clear_user(void __user *mem, int len)
 {
 	return(buffer_op((unsigned long) mem, len, 1, clear_chunk, NULL));
 }
 
-int clear_user_skas(void __user *mem, int len)
+int clear_user(void __user *mem, int len)
 {
 	if(segment_eq(get_fs(), KERNEL_DS)){
 		memset((__force void*)mem, 0, len);
@@ -240,7 +240,7 @@ static int strnlen_chunk(unsigned long s
 	return(0);
 }
 
-int strnlen_user_skas(const void __user *str, int len)
+int strnlen_user(const void __user *str, int len)
 {
 	int count = 0, n;
 
diff -puN arch/um/kernel/syscall.c~uml-throw-out-choose_mode arch/um/kernel/syscall.c
--- a/arch/um/kernel/syscall.c~uml-throw-out-choose_mode
+++ a/arch/um/kernel/syscall.c
@@ -21,7 +21,6 @@
 #include "kern_util.h"
 #include "sysdep/syscalls.h"
 #include "mode_kern.h"
-#include "choose-mode.h"
 
 /*  Unlocked, I don't care if this is a bit off */
 int nsyscalls = 0;
diff -puN arch/um/kernel/time.c~uml-throw-out-choose_mode arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-throw-out-choose_mode
+++ a/arch/um/kernel/time.c
@@ -181,9 +181,7 @@ void timer_handler(int sig, union uml_pt
 		timer_irq(regs);
 	local_irq_disable();
 	irq_enter();
-	update_process_times(CHOOSE_MODE(
-	                     (UPT_SC(regs) && user_context(UPT_SP(regs))),
-			     (regs)->skas.is_user));
+	update_process_times((regs)->skas.is_user);
 	irq_exit();
 	local_irq_enable();
 }
diff -puN arch/um/kernel/tlb.c~uml-throw-out-choose_mode arch/um/kernel/tlb.c
--- a/arch/um/kernel/tlb.c~uml-throw-out-choose_mode
+++ a/arch/um/kernel/tlb.c
@@ -8,7 +8,6 @@
 #include "asm/pgalloc.h"
 #include "asm/pgtable.h"
 #include "asm/tlbflush.h"
-#include "choose-mode.h"
 #include "mode_kern.h"
 #include "as-layout.h"
 #include "tlb.h"
@@ -378,35 +377,31 @@ void flush_tlb_all(void)
 
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 {
-	CHOOSE_MODE_PROC(flush_tlb_kernel_range_tt,
-			 flush_tlb_kernel_range_common, start, end);
+	flush_tlb_kernel_range_common(start, end);
 }
 
 void flush_tlb_kernel_vm(void)
 {
-	CHOOSE_MODE(flush_tlb_kernel_vm_tt(),
-		    flush_tlb_kernel_range_common(start_vm, end_vm));
+	flush_tlb_kernel_range_common(start_vm, end_vm);
 }
 
 void __flush_tlb_one(unsigned long addr)
 {
-	CHOOSE_MODE_PROC(__flush_tlb_one_tt, __flush_tlb_one_skas, addr);
+	__flush_tlb_one_skas(addr);
 }
 
 void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
 		     unsigned long end)
 {
-	CHOOSE_MODE_PROC(flush_tlb_range_tt, flush_tlb_range_skas, vma, start,
-			 end);
+	flush_tlb_range_skas(vma, start, end);
 }
 
 void flush_tlb_mm(struct mm_struct *mm)
 {
-	CHOOSE_MODE_PROC(flush_tlb_mm_tt, flush_tlb_mm_skas, mm);
+	flush_tlb_mm_skas(mm);
 }
 
 void force_flush_all(void)
 {
-	CHOOSE_MODE(force_flush_all_tt(), force_flush_all_skas());
+	force_flush_all_skas();
 }
-
diff -puN arch/um/kernel/um_arch.c~uml-throw-out-choose_mode arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-throw-out-choose_mode
+++ a/arch/um/kernel/um_arch.c
@@ -35,7 +35,6 @@
 #include "initrd.h"
 #include "init.h"
 #include "os.h"
-#include "choose-mode.h"
 #include "mode_kern.h"
 #include "mode.h"
 #include "skas.h"
@@ -68,8 +67,7 @@ struct cpuinfo_um boot_cpu_data = {
 
 unsigned long thread_saved_pc(struct task_struct *task)
 {
-	return os_process_pc(CHOOSE_MODE_PROC(thread_pid_tt, thread_pid_skas,
-					      task));
+	return os_process_pc(thread_pid_skas(task));
 }
 
 /* Changed in setup_arch, which is called in early boot */
@@ -88,7 +86,7 @@ static int show_cpuinfo(struct seq_file 
 	seq_printf(m, "processor\t: %d\n", index);
 	seq_printf(m, "vendor_id\t: User Mode Linux\n");
 	seq_printf(m, "model name\t: UML\n");
-	seq_printf(m, "mode\t\t: %s\n", CHOOSE_MODE("tt", "skas"));
+	seq_printf(m, "mode\t\t: skas\n");
 	seq_printf(m, "host\t\t: %s\n", host_info);
 	seq_printf(m, "bogomips\t: %lu.%02lu\n\n",
 		   loops_per_jiffy/(500000/HZ),
@@ -283,8 +281,7 @@ int __init linux_main(int argc, char **a
 
 	printf("UML running in %s mode\n", mode);
 
-	host_task_size = CHOOSE_MODE_PROC(set_task_sizes_tt,
-					  set_task_sizes_skas, &task_size);
+	host_task_size = set_task_sizes_skas(&task_size);
 
 	/*
 	 * Setting up handlers to 'sig_info' struct
@@ -292,7 +289,7 @@ int __init linux_main(int argc, char **a
 	os_fill_handlinfo(handlinfo_kern);
 
 	brk_start = (unsigned long) sbrk(0);
-	CHOOSE_MODE_PROC(before_mem_tt, before_mem_skas, brk_start);
+	before_mem_skas(brk_start);
 	/* Increase physical memory size for exec-shield users
 	so they actually get what they asked for. This should
 	add zero for non-exec shield users */
@@ -357,7 +354,7 @@ int __init linux_main(int argc, char **a
 	stack_protections((unsigned long) &init_thread_info);
 	os_flush_stdout();
 
-	return CHOOSE_MODE(start_uml_tt(), start_uml_skas());
+	return start_uml_skas();
 }
 
 extern int uml_exitcode;
diff -puN arch/um/os-Linux/aio.c~uml-throw-out-choose_mode arch/um/os-Linux/aio.c
--- a/arch/um/os-Linux/aio.c~uml-throw-out-choose_mode
+++ a/arch/um/os-Linux/aio.c
@@ -320,11 +320,6 @@ static int init_aio(void)
 {
 	int err;
 
-	CHOOSE_MODE(({ if(!aio_24){
-			    printk("Disabling 2.6 AIO in tt mode\n");
-			    aio_24 = 1;
-		    } }), (void) 0);
-
 	if(!aio_24){
 		err = init_aio_26();
 		if(err && (errno == ENOSYS)){
diff -puN arch/um/os-Linux/main.c~uml-throw-out-choose_mode arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~uml-throw-out-choose_mode
+++ a/arch/um/os-Linux/main.c
@@ -19,7 +19,6 @@
 #include "user.h"
 #include "init.h"
 #include "mode.h"
-#include "choose-mode.h"
 #include "uml-config.h"
 #include "os.h"
 #include "um_malloc.h"
@@ -189,16 +188,13 @@ int __init main(int argc, char **argv, c
 	return uml_exitcode;
 }
 
-#define CAN_KMALLOC() \
-	(kmalloc_ok && CHOOSE_MODE((os_getpid() != tracing_pid), 1))
-
 extern void *__real_malloc(int);
 
 void *__wrap_malloc(int size)
 {
 	void *ret;
 
-	if(!CAN_KMALLOC())
+	if(!kmalloc_ok)
 		return __real_malloc(size);
 	else if(size <= UM_KERN_PAGE_SIZE)
 		/* finding contiguous pages can be hard*/
@@ -251,11 +247,11 @@ void __wrap_free(void *ptr)
 	 */
 
 	if((addr >= uml_physmem) && (addr < high_physmem)){
-		if(CAN_KMALLOC())
+		if(kmalloc_ok)
 			kfree(ptr);
 	}
 	else if((addr >= start_vm) && (addr < end_vm)){
-		if(CAN_KMALLOC())
+		if(kmalloc_ok)
 			vfree(ptr);
 	}
 	else __real_free(ptr);
diff -puN arch/um/os-Linux/signal.c~uml-throw-out-choose_mode arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-throw-out-choose_mode
+++ a/arch/um/os-Linux/signal.c
@@ -53,8 +53,7 @@ void sig_handler(int sig, struct sigcont
 
 	block_signals();
 
-	CHOOSE_MODE_PROC(sig_handler_common_tt, sig_handler_common_skas,
-			 sig, sc);
+	sig_handler_common_skas(sig, sc);
 
 	set_signals(enabled);
 }
@@ -257,8 +256,7 @@ void unblock_signals(void)
 		 * back here.
 		 */
 		if(save_pending & SIGIO_MASK)
-			CHOOSE_MODE_PROC(sig_handler_common_tt,
-					 sig_handler_common_skas, SIGIO, NULL);
+			sig_handler_common_skas(SIGIO, NULL);
 
 		if(save_pending & SIGALRM_MASK)
 			real_alarm_handler(SIGALRM, NULL);
diff -puN arch/um/os-Linux/start_up.c~uml-throw-out-choose_mode arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-throw-out-choose_mode
+++ a/arch/um/os-Linux/start_up.c
@@ -31,7 +31,6 @@
 #include "init.h"
 #include "os.h"
 #include "uml-config.h"
-#include "choose-mode.h"
 #include "mode.h"
 #include "tempfile.h"
 #include "kern_constants.h"
diff -puN arch/um/os-Linux/trap.c~uml-throw-out-choose_mode arch/um/os-Linux/trap.c
--- a/arch/um/os-Linux/trap.c~uml-throw-out-choose_mode
+++ a/arch/um/os-Linux/trap.c
@@ -12,7 +12,6 @@
 
 void usr2_handler(int sig, union uml_pt_regs *regs)
 {
-	CHOOSE_MODE(syscall_handler_tt(sig, regs), (void) 0);
 }
 
 /* Initialized from linux_main() */
diff -puN arch/um/sys-i386/ldt.c~uml-throw-out-choose_mode arch/um/sys-i386/ldt.c
--- a/arch/um/sys-i386/ldt.c~uml-throw-out-choose_mode
+++ a/arch/um/sys-i386/ldt.c
@@ -12,7 +12,6 @@
 #include "asm/smp.h"
 #include "asm/ldt.h"
 #include "asm/unistd.h"
-#include "choose-mode.h"
 #include "kern.h"
 #include "mode_kern.h"
 #include "os.h"
@@ -506,6 +505,5 @@ void free_ldt(struct mmu_context_skas * 
 
 int sys_modify_ldt(int func, void __user *ptr, unsigned long bytecount)
 {
-	return CHOOSE_MODE_PROC(do_modify_ldt_tt, do_modify_ldt_skas, func,
-	                        ptr, bytecount);
+	return do_modify_ldt_skas(func, ptr, bytecount);
 }
diff -puN arch/um/sys-i386/ptrace.c~uml-throw-out-choose_mode arch/um/sys-i386/ptrace.c
--- a/arch/um/sys-i386/ptrace.c~uml-throw-out-choose_mode
+++ a/arch/um/sys-i386/ptrace.c
@@ -230,13 +230,13 @@ static inline unsigned long twd_fxsr_to_
 static inline int convert_fxsr_to_user(struct _fpstate __user *buf,
 				       struct pt_regs *regs)
 {
-	return(CHOOSE_MODE(convert_fxsr_to_user_tt(buf, regs), 0));
+	return 0;
 }
 
 static inline int convert_fxsr_from_user(struct pt_regs *regs, 
 					 struct _fpstate __user *buf)
 {
-	return(CHOOSE_MODE(convert_fxsr_from_user_tt(regs, buf), 0));
+	return 0;
 }
 
 int get_fpregs(unsigned long buf, struct task_struct *child)
@@ -261,12 +261,12 @@ int set_fpregs(unsigned long buf, struct
 
 int get_fpxregs(unsigned long buf, struct task_struct *tsk)
 {
-	return(CHOOSE_MODE(get_fpxregs_tt(buf, tsk), 0));
+	return 0;
 }
 
 int set_fpxregs(unsigned long buf, struct task_struct *tsk)
 {
-	return(CHOOSE_MODE(set_fpxregs_tt(buf, tsk), 0));
+	return 0;
 }
 
 #ifdef notdef
@@ -286,16 +286,9 @@ int dump_fpu(struct pt_regs *regs, elf_f
 }
 #endif
 
-static inline void copy_fpu_fxsave(struct pt_regs *regs,
-				   struct user_i387_struct *buf)
-{
-	(void) CHOOSE_MODE(copy_fpu_fxsave_tt(regs, buf), 0);
-}
-
 int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpu )
 {
-	copy_fpu_fxsave(regs, (struct user_i387_struct *) fpu);
-	return(1);
+	return 1;
 }
 
 /*
diff -puN arch/um/sys-i386/signal.c~uml-throw-out-choose_mode arch/um/sys-i386/signal.c
--- a/arch/um/sys-i386/signal.c~uml-throw-out-choose_mode
+++ a/arch/um/sys-i386/signal.c
@@ -12,7 +12,6 @@
 #include "frame_kern.h"
 #include "sigcontext.h"
 #include "registers.h"
-#include "mode.h"
 #include "skas.h"
 
 void copy_sc(union uml_pt_regs *regs, void *from)
@@ -108,20 +107,13 @@ int copy_sc_to_user_skas(struct sigconte
 
 static int copy_sc_from_user(struct pt_regs *to, void __user *from)
 {
-	int ret;
-
-	ret = CHOOSE_MODE(copy_sc_from_user_tt(UPT_SC(&to->regs), from,
-					       sizeof(struct _fpstate)),
-			  copy_sc_from_user_skas(to, from));
-	return ret;
+	return copy_sc_from_user_skas(to, from);
 }
 
 static int copy_sc_to_user(struct sigcontext __user *to, struct _fpstate __user *fp,
 			   struct pt_regs *from, unsigned long sp)
 {
-	return CHOOSE_MODE(copy_sc_to_user_tt(to, fp, UPT_SC(&from->regs),
-					      sizeof(*fp), sp),
-                           copy_sc_to_user_skas(to, fp, from, sp));
+	return copy_sc_to_user_skas(to, fp, from, sp);
 }
 
 static int copy_ucontext_to_user(struct ucontext __user *uc, struct _fpstate __user *fp,
diff -puN arch/um/sys-i386/tls.c~uml-throw-out-choose_mode arch/um/sys-i386/tls.c
--- a/arch/um/sys-i386/tls.c~uml-throw-out-choose_mode
+++ a/arch/um/sys-i386/tls.c
@@ -12,7 +12,6 @@
 #include "asm/segment.h"
 #include "asm/smp.h"
 #include "asm/desc.h"
-#include "choose-mode.h"
 #include "kern.h"
 #include "kern_util.h"
 #include "mode_kern.h"
@@ -28,7 +27,7 @@
 static int host_supports_tls = -1;
 int host_gdt_entry_tls_min;
 
-int do_set_thread_area_skas(struct user_desc *info)
+int do_set_thread_area(struct user_desc *info)
 {
 	int ret;
 	u32 cpu;
@@ -39,7 +38,7 @@ int do_set_thread_area_skas(struct user_
 	return ret;
 }
 
-int do_get_thread_area_skas(struct user_desc *info)
+int do_get_thread_area(struct user_desc *info)
 {
 	int ret;
 	u32 cpu;
@@ -277,7 +276,7 @@ asmlinkage int sys_set_thread_area(struc
 			return -EFAULT;
 	}
 
-	ret = CHOOSE_MODE_PROC(do_set_thread_area_tt, do_set_thread_area_skas, &info);
+	ret = do_set_thread_area(&info);
 	if (ret)
 		return ret;
 	return set_tls_entry(current, &info, idx, 1);
diff -puN arch/um/sys-x86_64/signal.c~uml-throw-out-choose_mode arch/um/sys-x86_64/signal.c
--- a/arch/um/sys-x86_64/signal.c~uml-throw-out-choose_mode
+++ a/arch/um/sys-x86_64/signal.c
@@ -12,7 +12,6 @@
 #include "asm/sigcontext.h"
 #include "asm/ptrace.h"
 #include "asm/arch/ucontext.h"
-#include "choose-mode.h"
 #include "sysdep/ptrace.h"
 #include "frame_kern.h"
 #include "skas.h"
@@ -135,9 +134,7 @@ static int copy_sc_from_user(struct pt_r
 {
        int ret;
 
-       ret = CHOOSE_MODE(copy_sc_from_user_tt(UPT_SC(&to->regs), from,
-                                              sizeof(struct _fpstate)),
-                         copy_sc_from_user_skas(to, from));
+       ret = copy_sc_from_user_skas(to, from);
        return(ret);
 }
 
@@ -146,9 +143,7 @@ static int copy_sc_to_user(struct sigcon
 			   struct pt_regs *from, unsigned long mask,
 			   unsigned long sp)
 {
-       return(CHOOSE_MODE(copy_sc_to_user_tt(to, fp, UPT_SC(&from->regs),
-                                             sizeof(*fp), sp),
-                          copy_sc_to_user_skas(to, fp, from, mask, sp)));
+       return copy_sc_to_user_skas(to, fp, from, mask, sp);
 }
 
 struct rt_sigframe
diff -puN arch/um/sys-x86_64/syscalls.c~uml-throw-out-choose_mode arch/um/sys-x86_64/syscalls.c
--- a/arch/um/sys-x86_64/syscalls.c~uml-throw-out-choose_mode
+++ a/arch/um/sys-x86_64/syscalls.c
@@ -14,7 +14,6 @@
 #include "asm/ptrace.h"
 #include "asm/unistd.h"
 #include "asm/prctl.h" /* XXX This should get the constants from libc */
-#include "choose-mode.h"
 #include "kern.h"
 #include "os.h"
 
@@ -92,8 +91,7 @@ long arch_prctl_skas(struct task_struct 
 
 long sys_arch_prctl(int code, unsigned long addr)
 {
-	return CHOOSE_MODE_PROC(arch_prctl_tt, arch_prctl_skas, current, code,
-                                (unsigned long __user *) addr);
+	return arch_prctl_skas(current, code, (unsigned long __user *) addr);
 }
 
 long sys_clone(unsigned long clone_flags, unsigned long newsp,
diff -puN include/asm-um/a.out.h~uml-throw-out-choose_mode include/asm-um/a.out.h
--- a/include/asm-um/a.out.h~uml-throw-out-choose_mode
+++ a/include/asm-um/a.out.h
@@ -2,7 +2,6 @@
 #define __UM_A_OUT_H
 
 #include "asm/arch/a.out.h"
-#include "choose-mode.h"
 
 #undef STACK_TOP
 #undef STACK_TOP_MAX
@@ -13,10 +12,8 @@ extern unsigned long host_task_size;
 
 #define STACK_ROOM (stacksizelim)
 
-extern int honeypot;
-#define STACK_TOP \
-	CHOOSE_MODE((honeypot ? host_task_size : task_size), task_size)
+#define STACK_TOP task_size
 
-#define STACK_TOP_MAX	STACK_TOP
+#define STACK_TOP_MAX STACK_TOP
 
 #endif
diff -puN include/asm-um/mmu_context.h~uml-throw-out-choose_mode include/asm-um/mmu_context.h
--- a/include/asm-um/mmu_context.h~uml-throw-out-choose_mode
+++ a/include/asm-um/mmu_context.h
@@ -9,7 +9,6 @@
 #include <asm-generic/mm_hooks.h>
 
 #include "linux/sched.h"
-#include "choose-mode.h"
 #include "um_mmu.h"
 
 #define get_mmu_context(task) do ; while(0)
@@ -30,8 +29,7 @@ static inline void activate_mm(struct mm
 	 * possible.
 	 */
 	if (old != new && (current->flags & PF_BORROWED_MM))
-		CHOOSE_MODE(force_flush_all(),
-			    switch_mm_skas(&new->context.skas.id));
+		switch_mm_skas(&new->context.skas.id);
 }
 
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next, 
@@ -43,8 +41,7 @@ static inline void switch_mm(struct mm_s
 		cpu_clear(cpu, prev->cpu_vm_mask);
 		cpu_set(cpu, next->cpu_vm_mask);
 		if(next != &init_mm)
-			CHOOSE_MODE((void) 0, 
-				    switch_mm_skas(&next->context.skas.id));
+			switch_mm_skas(&next->context.skas.id);
 	}
 }
 
@@ -59,15 +56,14 @@ extern int init_new_context_skas(struct 
 static inline int init_new_context(struct task_struct *task, 
 				   struct mm_struct *mm)
 {
-	return(CHOOSE_MODE_PROC(init_new_context_tt, init_new_context_skas, 
-				task, mm));
+	return(init_new_context_skas(task, mm));
 }
 
 extern void destroy_context_skas(struct mm_struct *mm);
 
 static inline void destroy_context(struct mm_struct *mm)
 {
-	CHOOSE_MODE((void) 0, destroy_context_skas(mm));
+	destroy_context_skas(mm);
 }
 
 #endif
diff -puN include/asm-um/processor-generic.h~uml-throw-out-choose_mode include/asm-um/processor-generic.h
--- a/include/asm-um/processor-generic.h~uml-throw-out-choose_mode
+++ a/include/asm-um/processor-generic.h
@@ -11,7 +11,6 @@ struct pt_regs;
 struct task_struct;
 
 #include "asm/ptrace.h"
-#include "choose-mode.h"
 #include "registers.h"
 #include "sysdep/archsetjmp.h"
 
diff -puN include/asm-um/ptrace-i386.h~uml-throw-out-choose_mode include/asm-um/ptrace-i386.h
--- a/include/asm-um/ptrace-i386.h~uml-throw-out-choose_mode
+++ a/include/asm-um/ptrace-i386.h
@@ -12,7 +12,6 @@
 #include "sysdep/ptrace.h"
 #include "asm/ptrace-generic.h"
 #include "asm/host_ldt.h"
-#include "choose-mode.h"
 
 #define PT_REGS_EAX(r) UPT_EAX(&(r)->regs)
 #define PT_REGS_EBX(r) UPT_EBX(&(r)->regs)
@@ -59,15 +58,8 @@ extern int arch_switch_tls_tt(struct tas
 extern void arch_switch_to_tt(struct task_struct *from, struct task_struct *to);
 extern void arch_switch_to_skas(struct task_struct *from, struct task_struct *to);
 
-static inline int do_get_thread_area(struct user_desc *info)
-{
-	return CHOOSE_MODE_PROC(do_get_thread_area_tt, do_get_thread_area_skas, info);
-}
-
-static inline int do_set_thread_area(struct user_desc *info)
-{
-	return CHOOSE_MODE_PROC(do_set_thread_area_tt, do_set_thread_area_skas, info);
-}
+extern int do_get_thread_area_skas(struct user_desc *info);
+extern int do_set_thread_area_skas(struct user_desc *info);
 
 struct task_struct;
 
diff -puN include/asm-um/tlbflush.h~uml-throw-out-choose_mode include/asm-um/tlbflush.h
--- a/include/asm-um/tlbflush.h~uml-throw-out-choose_mode
+++ a/include/asm-um/tlbflush.h
@@ -7,7 +7,6 @@
 #define __UM_TLBFLUSH_H
 
 #include <linux/mm.h>
-#include "choose-mode.h"
 
 /*
  * TLB flushing:
@@ -31,10 +30,7 @@ extern void flush_tlb_page_skas(struct v
 static inline void flush_tlb_page(struct vm_area_struct *vma,
 				  unsigned long address)
 {
-	address &= PAGE_MASK;
-
-	CHOOSE_MODE(flush_tlb_range(vma, address, address + PAGE_SIZE),
-		    flush_tlb_page_skas(vma, address));
+	flush_tlb_page_skas(vma, address & PAGE_MASK);
 }
 
 extern void flush_tlb_page(struct vm_area_struct *vma, unsigned long vmaddr);
diff -puN include/asm-um/uaccess.h~uml-throw-out-choose_mode include/asm-um/uaccess.h
--- a/include/asm-um/uaccess.h~uml-throw-out-choose_mode
+++ a/include/asm-um/uaccess.h
@@ -80,7 +80,7 @@
 	 __put_user(x, private_ptr) : -EFAULT); \
 })
 
-#define strlen_user(str) strnlen_user(str, ~0UL >> 1)
+#define strlen_user(str) strnlen_user(str, ~0U >> 1)
 
 struct exception_table_entry
 {
_

Patches currently in -mm which might be from jdike@addtoit.com are

introduce-config_check_signature-was-re-uninline.patch
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
