From: akpm@linux-foundation.org
Subject: + uml-move-sig_handler_common_skas.patch added to -mm tree
Date: Wed, 12 Dec 2007 13:20:10 -0800
Message-ID: <200712122120.lBCLKAUB030273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37970 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332AbXLLVUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 16:20:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: move sig_handler_common_skas
has been added to the -mm tree.  Its filename is
     uml-move-sig_handler_common_skas.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: move sig_handler_common_skas
From: Jeff Dike <jdike@addtoit.com>

This patch moves sig_handler_common_skas from
arch/um/os-Linux/skas/trap.c to its only caller in
arch/um/os-Linux/signal.c.  trap.c is now empty, so it can be removed.

This is code movement only - the significant cleanup needed here is
done in the next patch.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h           |    3 -
 arch/um/os-Linux/signal.c      |   62 ++++++++++++++++++++++++++
 arch/um/os-Linux/skas/Makefile |    6 +-
 arch/um/os-Linux/skas/trap.c   |   73 -------------------------------
 4 files changed, 65 insertions(+), 79 deletions(-)

diff -puN arch/um/include/os.h~uml-move-sig_handler_common_skas arch/um/include/os.h
--- a/arch/um/include/os.h~uml-move-sig_handler_common_skas
+++ a/arch/um/include/os.h
@@ -292,9 +292,6 @@ extern int add_sigio_fd(int fd);
 extern int ignore_sigio_fd(int fd);
 extern void maybe_sigio_broken(int fd, int read);
 
-/* skas/trap */
-extern void sig_handler_common_skas(int sig, void *sc_ptr);
-
 /* sys-x86_64/prctl.c */
 extern int os_arch_prctl(int pid, int code, unsigned long *addr);
 
diff -puN arch/um/os-Linux/signal.c~uml-move-sig_handler_common_skas arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-move-sig_handler_common_skas
+++ a/arch/um/os-Linux/signal.c
@@ -9,12 +9,74 @@
 #include <errno.h>
 #include <signal.h>
 #include <strings.h>
+#include "as-layout.h"
+#include "kern_constants.h"
 #include "kern_util.h"
 #include "os.h"
 #include "sysdep/barrier.h"
 #include "sysdep/sigcontext.h"
+#include "task.h"
 #include "user.h"
 
+void (*sig_info[NSIG])(int, struct uml_pt_regs *) = {
+	[SIGTRAP]	= relay_signal,
+	[SIGFPE]	= relay_signal,
+	[SIGILL]	= relay_signal,
+	[SIGWINCH]	= winch,
+	[SIGBUS]	= bus_handler,
+	[SIGSEGV]	= segv_handler,
+	[SIGIO]		= sigio_handler,
+	[SIGVTALRM]	= timer_handler };
+
+static struct uml_pt_regs ksig_regs[UM_NR_CPUS];
+
+void sig_handler_common_skas(int sig, void *sc_ptr)
+{
+	struct sigcontext *sc = sc_ptr;
+	struct uml_pt_regs *r;
+	void (*handler)(int, struct uml_pt_regs *);
+	int save_user, save_errno = errno;
+
+	/*
+	 * This is done because to allow SIGSEGV to be delivered inside a SEGV
+	 * handler.  This can happen in copy_user, and if SEGV is disabled,
+	 * the process will die.
+	 * XXX Figure out why this is better than SA_NODEFER
+	 */
+	if (sig == SIGSEGV) {
+		change_sig(SIGSEGV, 1);
+		/*
+		 * For segfaults, we want the data from the
+		 * sigcontext.  In this case, we don't want to mangle
+		 * the process registers, so use a static set of
+		 * registers.  For other signals, the process
+		 * registers are OK.
+		 */
+		r = &ksig_regs[cpu()];
+		copy_sc(r, sc_ptr);
+	} else
+		r = TASK_REGS(get_current());
+
+	save_user = r->is_user;
+	r->is_user = 0;
+	if ((sig == SIGFPE) || (sig == SIGSEGV) || (sig == SIGBUS) ||
+	    (sig == SIGILL) || (sig == SIGTRAP))
+		GET_FAULTINFO_FROM_SC(r->faultinfo, sc);
+
+	change_sig(SIGUSR1, 1);
+
+	handler = sig_info[sig];
+
+	/* unblock SIGVTALRM, SIGIO if sig isn't IRQ signal */
+	if ((sig != SIGIO) && (sig != SIGWINCH) && (sig != SIGVTALRM))
+		unblock_signals();
+
+	handler(sig, r);
+
+	errno = save_errno;
+	r->is_user = save_user;
+}
+
 /* Copied from linux/compiler-gcc.h since we can't include it directly */
 #define barrier() __asm__ __volatile__("": : :"memory")
 
diff -puN arch/um/os-Linux/skas/Makefile~uml-move-sig_handler_common_skas arch/um/os-Linux/skas/Makefile
--- a/arch/um/os-Linux/skas/Makefile~uml-move-sig_handler_common_skas
+++ a/arch/um/os-Linux/skas/Makefile
@@ -1,10 +1,10 @@
 #
-# Copyright (C) 2002 - 2004 Jeff Dike (jdike@addtoit.com)
+# Copyright (C) 2002 - 2007 Jeff Dike (jdike@{linux.intel,addtoit}.com)
 # Licensed under the GPL
 #
 
-obj-y := mem.o process.o trap.o
+obj-y := mem.o process.o
 
-USER_OBJS := mem.o process.o trap.o
+USER_OBJS := $(obj-y)
 
 include arch/um/scripts/Makefile.rules
diff -puN arch/um/os-Linux/skas/trap.c~uml-move-sig_handler_common_skas /dev/null
--- a/arch/um/os-Linux/skas/trap.c
+++ /dev/null
@@ -1,73 +0,0 @@
-/*
- * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Licensed under the GPL
- */
-
-#include <errno.h>
-#include <signal.h>
-#include "sysdep/ptrace.h"
-#include "kern_constants.h"
-#include "as-layout.h"
-#include "kern_util.h"
-#include "os.h"
-#include "sigcontext.h"
-#include "task.h"
-
-void (*sig_info[NSIG])(int, struct uml_pt_regs *) = {
-	[SIGTRAP]	= relay_signal,
-	[SIGFPE]	= relay_signal,
-	[SIGILL]	= relay_signal,
-	[SIGWINCH]	= winch,
-	[SIGBUS]	= bus_handler,
-	[SIGSEGV]	= segv_handler,
-	[SIGIO]		= sigio_handler,
-	[SIGVTALRM]	= timer_handler };
-
-static struct uml_pt_regs ksig_regs[UM_NR_CPUS];
-
-void sig_handler_common_skas(int sig, void *sc_ptr)
-{
-	struct sigcontext *sc = sc_ptr;
-	struct uml_pt_regs *r;
-	void (*handler)(int, struct uml_pt_regs *);
-	int save_user, save_errno = errno;
-
-	/*
-	 * This is done because to allow SIGSEGV to be delivered inside a SEGV
-	 * handler.  This can happen in copy_user, and if SEGV is disabled,
-	 * the process will die.
-	 * XXX Figure out why this is better than SA_NODEFER
-	 */
-	if (sig == SIGSEGV) {
-		change_sig(SIGSEGV, 1);
-		/*
-		 * For segfaults, we want the data from the
-		 * sigcontext.  In this case, we don't want to mangle
-		 * the process registers, so use a static set of
-		 * registers.  For other signals, the process
-		 * registers are OK.
-		 */
-		r = &ksig_regs[cpu()];
-		copy_sc(r, sc_ptr);
-	}
-	else r = TASK_REGS(get_current());
-
-	save_user = r->is_user;
-	r->is_user = 0;
-	if ((sig == SIGFPE) || (sig == SIGSEGV) || (sig == SIGBUS) ||
-	    (sig == SIGILL) || (sig == SIGTRAP))
-		GET_FAULTINFO_FROM_SC(r->faultinfo, sc);
-
-	change_sig(SIGUSR1, 1);
-
-	handler = sig_info[sig];
-
-	/* unblock SIGVTALRM, SIGIO if sig isn't IRQ signal */
-	if ((sig != SIGIO) && (sig != SIGWINCH) && (sig != SIGVTALRM))
-		unblock_signals();
-
-	handler(sig, r);
-
-	errno = save_errno;
-	r->is_user = save_user;
-}
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
git-x86.patch
uml-add-asm-um-asmh.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
uml-fix-command-line-cflags-and-ldflags-support.patch
uml-style-fixes-in-arch-um-os-linux.patch
uml-miscellaneous-code-cleanups.patch
uml-style-fixes-in-filec.patch
uml-64-bit-tlb-fixes.patch
uml-customize-tlbh.patch
uml-runtime-detection-of-host-vmsplit-on-i386.patch
uml-eliminate-setjmp_wrapper.patch
uml-install-panic-notifier-earlier.patch
uml-use-barrier-instead-of-mb.patch
uml-tidy-helper-code.patch
uml-dont-kill-pid-0.patch
uml-get-rid-of-syscall-counters.patch
uml-dont-allow-processes-to-call-into-stub.patch
uml-move-sig_handler_common_skas.patch
uml-clean-up-sig_handler_common_skas.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
