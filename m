From: akpm@linux-foundation.org
Subject: + uml-simplify-sigsegv-handling.patch added to -mm tree
Date: Tue, 20 Nov 2007 13:25:16 -0800
Message-ID: <200711202125.lAKLPGYG024213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39216 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752836AbXKTVZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 16:25:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: simplify SIGSEGV handling
has been added to the -mm tree.  Its filename is
     uml-simplify-sigsegv-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: simplify SIGSEGV handling
From: Jeff Dike <jdike@addtoit.com>

Simplify the page fault stub by not masking signals while it is running.  This
allows it to signal that it is done by executing an instruction which will
generate a SIGTRAP (int3 on x86) rather than running sigreturn by hand after
queueing a blocked SIGUSR1.

userspace_tramp now no longer puts anything in the SIGSEGV sa_mask, but it
does add SA_NODEFER to sa_flags so that SIGSEGV is still enabled after the
signal handler fails to run sigreturn.

SIGWINCH is just blocked so that we don't have to deal with it and the signal
masks used by wait_stub_done are updated to reflect the smaller number of
signals that it has to worry about.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/skas/process.c |   11 +++-----
 arch/um/sys-i386/stub_segv.c    |   19 +-------------
 arch/um/sys-x86_64/stub_segv.c  |   39 +++---------------------------
 3 files changed, 11 insertions(+), 58 deletions(-)

diff -puN arch/um/os-Linux/skas/process.c~uml-simplify-sigsegv-handling arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-simplify-sigsegv-handling
+++ a/arch/um/os-Linux/skas/process.c
@@ -55,10 +55,10 @@ static int ptrace_dump_regs(int pid)
  * Signals that are OK to receive in the stub - we'll just continue it.
  * SIGWINCH will happen when UML is inside a detached screen.
  */
-#define STUB_SIG_MASK ((1 << SIGVTALRM) | (1 << SIGWINCH))
+#define STUB_SIG_MASK (1 << SIGVTALRM)
 
 /* Signals that the stub will finish with - anything else is an error */
-#define STUB_DONE_MASK ((1 << SIGUSR1) | (1 << SIGTRAP))
+#define STUB_DONE_MASK (1 << SIGTRAP)
 
 void wait_stub_done(int pid)
 {
@@ -179,6 +179,7 @@ static int userspace_tramp(void *stack)
 	ptrace(PTRACE_TRACEME, 0, 0, 0);
 
 	signal(SIGTERM, SIG_DFL);
+	signal(SIGWINCH, SIG_IGN);
 	err = set_interval();
 	if (err)
 		panic("userspace_tramp - setting timer failed, errno = %d\n",
@@ -222,11 +223,7 @@ static int userspace_tramp(void *stack)
 
 		set_sigstack((void *) STUB_DATA, UM_KERN_PAGE_SIZE);
 		sigemptyset(&sa.sa_mask);
-		sigaddset(&sa.sa_mask, SIGIO);
-		sigaddset(&sa.sa_mask, SIGWINCH);
-		sigaddset(&sa.sa_mask, SIGVTALRM);
-		sigaddset(&sa.sa_mask, SIGUSR1);
-		sa.sa_flags = SA_ONSTACK;
+		sa.sa_flags = SA_ONSTACK | SA_NODEFER;
 		sa.sa_handler = (void *) v;
 		sa.sa_restorer = NULL;
 		if (sigaction(SIGSEGV, &sa, NULL) < 0)
diff -puN arch/um/sys-i386/stub_segv.c~uml-simplify-sigsegv-handling arch/um/sys-i386/stub_segv.c
--- a/arch/um/sys-i386/stub_segv.c~uml-simplify-sigsegv-handling
+++ a/arch/um/sys-i386/stub_segv.c
@@ -1,32 +1,17 @@
 /*
- * Copyright (C) 2004 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2004 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <signal.h>
-#include <sys/select.h> /* The only way I can see to get sigset_t */
-#include <asm/unistd.h>
-#include "as-layout.h"
-#include "uml-config.h"
 #include "sysdep/stub.h"
 #include "sysdep/sigcontext.h"
-#include "sysdep/faultinfo.h"
 
 void __attribute__ ((__section__ (".__syscall_stub")))
 stub_segv_handler(int sig)
 {
 	struct sigcontext *sc = (struct sigcontext *) (&sig + 1);
-	int pid;
 
 	GET_FAULTINFO_FROM_SC(*((struct faultinfo *) STUB_DATA), sc);
 
-	pid = stub_syscall0(__NR_getpid);
-	stub_syscall2(__NR_kill, pid, SIGUSR1);
-
-	/* Load pointer to sigcontext into esp, since we need to leave
-	 * the stack in its original form when we do the sigreturn here, by
-	 * hand.
-	 */
-	__asm__ __volatile__("mov %0,%%esp ; movl %1, %%eax ; "
-			     "int $0x80" : : "a" (sc), "g" (__NR_sigreturn));
+	trap_myself();
 }
diff -puN arch/um/sys-x86_64/stub_segv.c~uml-simplify-sigsegv-handling arch/um/sys-x86_64/stub_segv.c
--- a/arch/um/sys-x86_64/stub_segv.c~uml-simplify-sigsegv-handling
+++ a/arch/um/sys-x86_64/stub_segv.c
@@ -1,51 +1,22 @@
 /*
- * Copyright (C) 2004 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2004 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <stddef.h>
 #include <signal.h>
-#include <asm/unistd.h>
 #include "as-layout.h"
-#include "uml-config.h"
-#include "sysdep/sigcontext.h"
-#include "sysdep/faultinfo.h"
 #include "sysdep/stub.h"
-
-/* Copied from sys-x86_64/signal.c - Can't find an equivalent definition
- * in the libc headers anywhere.
- */
-struct rt_sigframe
-{
-	char *pretcode;
-	struct ucontext uc;
-	struct siginfo info;
-};
-
-/* Copied here from <linux/kernel.h> - we're userspace. */
-#define container_of(ptr, type, member) ({                   \
-	const typeof( ((type *)0)->member ) *__mptr = (ptr); \
-	(type *)( (char *)__mptr - offsetof(type,member) );})
+#include "sysdep/faultinfo.h"
+#include "sysdep/sigcontext.h"
 
 void __attribute__ ((__section__ (".__syscall_stub")))
 stub_segv_handler(int sig)
 {
 	struct ucontext *uc;
-        int pid;
 
 	__asm__ __volatile__("movq %%rdx, %0" : "=g" (uc) :);
 	GET_FAULTINFO_FROM_SC(*((struct faultinfo *) STUB_DATA),
 			      &uc->uc_mcontext);
-
-	pid = stub_syscall0(__NR_getpid);
-	stub_syscall2(__NR_kill, pid, SIGUSR1);
-
-	/* sys_sigreturn expects that the stack pointer will be 8 bytes into
-	 * the signal frame.  So, we use the ucontext pointer, which we know
-	 * already, to get the signal frame pointer, and add 8 to that.
-	 */
-	__asm__ __volatile__("movq %0, %%rsp; movq %1, %%rax ; syscall": :
-                             "g" ((unsigned long)
-                                  container_of(uc, struct rt_sigframe, uc) + 8),
-                             "g" (__NR_rt_sigreturn));
+	trap_myself();
 }
+
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
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
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
