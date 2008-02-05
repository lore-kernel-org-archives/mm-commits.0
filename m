From: akpm@linux-foundation.org
Subject: - uml-remove-init_irq_signals.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:38:06 -0800
Message-ID: <200802052237.m15Mbla8012889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41830 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762292AbYBEWla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: remove init_irq_signals
has been removed from the -mm tree.  Its filename was
     uml-remove-init_irq_signals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
