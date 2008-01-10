From: akpm@linux-foundation.org
Subject: + uml-remove-init_irq_signals.patch added to -mm tree
Date: Wed, 09 Jan 2008 23:59:46 -0800
Message-ID: <200801100759.m0A7xQ28011867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59712 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754301AbYAJH7c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 02:59:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: remove init_irq_signals
has been added to the -mm tree.  Its filename is
     uml-remove-init_irq_signals.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: remove init_irq_signals
From: Jeff Dike <jdike@addtoit.com>

init_irq_signals doesn't need to be called from the context of a new process. 
It initializes handlers, which are useless in process context.  With that call
gone, init_irq_signals has only one caller, so it can be inlined into
init_new_thread_signals.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h       |    1 -
 arch/um/os-Linux/irq.c     |   11 -----------
 arch/um/os-Linux/process.c |    5 ++++-
 3 files changed, 4 insertions(+), 13 deletions(-)

diff -puN arch/um/include/os.h~uml-remove-init_irq_signals arch/um/include/os.h
--- a/arch/um/include/os.h~uml-remove-init_irq_signals
+++ a/arch/um/include/os.h
@@ -285,7 +285,6 @@ extern void os_free_irq_later(struct irq
 extern int os_get_pollfd(int i);
 extern void os_set_pollfd(int i, int fd);
 extern void os_set_ioignore(void);
-extern void init_irq_signals(int on_sigstack);
 
 /* sigio.c */
 extern int add_sigio_fd(int fd);
diff -puN arch/um/os-Linux/irq.c~uml-remove-init_irq_signals arch/um/os-Linux/irq.c
--- a/arch/um/os-Linux/irq.c~uml-remove-init_irq_signals
+++ a/arch/um/os-Linux/irq.c
@@ -136,14 +136,3 @@ void os_set_ioignore(void)
 {
 	signal(SIGIO, SIG_IGN);
 }
-
-void init_irq_signals(int on_sigstack)
-{
-	int flags;
-
-	flags = on_sigstack ? SA_ONSTACK : 0;
-
-	set_handler(SIGIO, (__sighandler_t) sig_handler, flags | SA_RESTART,
-		    SIGUSR1, SIGIO, SIGWINCH, SIGVTALRM, -1);
-	signal(SIGWINCH, SIG_IGN);
-}
diff -puN arch/um/os-Linux/process.c~uml-remove-init_irq_signals arch/um/os-Linux/process.c
--- a/arch/um/os-Linux/process.c~uml-remove-init_irq_signals
+++ a/arch/um/os-Linux/process.c
@@ -249,7 +249,10 @@ void init_new_thread_signals(void)
 		    SIGUSR1, SIGIO, SIGWINCH, SIGVTALRM, -1);
 	signal(SIGHUP, SIG_IGN);
 
-	init_irq_signals(1);
+	set_handler(SIGIO, (__sighandler_t) sig_handler,
+		    SA_ONSTACK | SA_RESTART, SIGUSR1, SIGIO, SIGWINCH, SIGALRM,
+		    SIGVTALRM, -1);
+	signal(SIGWINCH, SIG_IGN);
 }
 
 int run_kernel_thread(int (*fn)(void *), void *arg, jmp_buf **jmp_ptr)
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
git-x86.patch
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
uml-header-untangling-fix.patch
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
uml-eliminate-setjmp_wrapper.patch
uml-install-panic-notifier-earlier.patch
uml-use-barrier-instead-of-mb.patch
uml-tidy-helper-code.patch
uml-dont-kill-pid-0.patch
uml-get-rid-of-syscall-counters.patch
uml-dont-allow-processes-to-call-into-stub.patch
uml-move-sig_handler_common_skas.patch
uml-clean-up-sig_handler_common_skas.patch
uml-style-fixes-in-arch-um-kernel.patch
uml-signal-handling-tidying.patch
uml-remove-init_irq_signals.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
uml-re-remove-accidentally-restored-code.patch
