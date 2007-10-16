From: akpm@linux-foundation.org
Subject: - uml-separate-timer-initialization.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:38:42 -0700
Message-ID: <200710162038.l9GKcgjK015474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36814 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762437AbXJPVWv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:22:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     uml: separate timer initialization
has been removed from the -mm tree.  Its filename was
     uml-separate-timer-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: separate timer initialization
From: Jeff Dike <jdike@addtoit.com>

Move timer signal initialization from init_irq_signals to a new function,
timer_init.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h      |    1 +
 arch/um/kernel/time.c     |    2 ++
 arch/um/os-Linux/irq.c    |    4 ----
 arch/um/os-Linux/signal.c |   10 ++++++++++
 4 files changed, 13 insertions(+), 4 deletions(-)

diff -puN arch/um/include/os.h~uml-separate-timer-initialization arch/um/include/os.h
--- a/arch/um/include/os.h~uml-separate-timer-initialization
+++ a/arch/um/include/os.h
@@ -227,6 +227,7 @@ extern int set_umid(char *name);
 extern char *get_umid(void);
 
 /* signal.c */
+extern void timer_init(void);
 extern void set_sigstack(void *sig_stack, int size);
 extern void remove_sigstack(void);
 extern void set_handler(int sig, void (*handler)(int), int flags, ...);
diff -puN arch/um/kernel/time.c~uml-separate-timer-initialization arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-separate-timer-initialization
+++ a/arch/um/kernel/time.c
@@ -97,6 +97,8 @@ static void register_timer(void)
 {
 	int err;
 
+	timer_init();
+
 	err = request_irq(TIMER_IRQ, um_timer, IRQF_DISABLED, "timer", NULL);
 	if (err != 0)
 		printk(KERN_ERR "register_timer : request_irq failed - "
diff -puN arch/um/os-Linux/irq.c~uml-separate-timer-initialization arch/um/os-Linux/irq.c
--- a/arch/um/os-Linux/irq.c~uml-separate-timer-initialization
+++ a/arch/um/os-Linux/irq.c
@@ -145,10 +145,6 @@ void init_irq_signals(int on_sigstack)
 
 	flags = on_sigstack ? SA_ONSTACK : 0;
 
-	set_handler(SIGVTALRM, (__sighandler_t) alarm_handler,
-		    flags | SA_RESTART, SIGUSR1, SIGIO, SIGWINCH, SIGALRM, -1);
-	set_handler(SIGALRM, (__sighandler_t) alarm_handler,
-		    flags | SA_RESTART, SIGUSR1, SIGIO, SIGWINCH, SIGALRM, -1);
 	set_handler(SIGIO, (__sighandler_t) sig_handler, flags | SA_RESTART,
 		    SIGUSR1, SIGIO, SIGWINCH, SIGALRM, SIGVTALRM, -1);
 	signal(SIGWINCH, SIG_IGN);
diff -puN arch/um/os-Linux/signal.c~uml-separate-timer-initialization arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-separate-timer-initialization
+++ a/arch/um/os-Linux/signal.c
@@ -85,6 +85,16 @@ void alarm_handler(int sig, struct sigco
 	set_signals(enabled);
 }
 
+void timer_init(void)
+{
+	set_handler(SIGVTALRM, (__sighandler_t) alarm_handler,
+		    SA_ONSTACK | SA_RESTART, SIGUSR1, SIGIO, SIGWINCH,
+		    SIGALRM, -1);
+	set_handler(SIGALRM, (__sighandler_t) alarm_handler,
+		    SA_ONSTACK | SA_RESTART, SIGUSR1, SIGIO, SIGWINCH,
+		    SIGALRM, -1);
+}
+
 void set_sigstack(void *sig_stack, int size)
 {
 	stack_t stack = ((stack_t) { .ss_flags	= 0,
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
