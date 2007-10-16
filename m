From: akpm@linux-foundation.org
Subject: - uml-fix-timer-switching.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:38:38 -0700
Message-ID: <200710162038.l9GKcc6M015466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40473 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964886AbXJPV1V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:27:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     uml: fix timer switching
has been removed from the -mm tree.  Its filename was
     uml-fix-timer-switching.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix timer switching
From: Jeff Dike <jdike@addtoit.com>

Fix up the switching between virtual and real timers.  The idle loop sleeps,
so the timer at that point must be real time.  At all other times, the timer
must be virtual.  Even when userspace is running, and the kernel is asleep,
the virtual timer is correct because the process timer will be running and the
process timer will be firing.

The timer switch used to be in the context switch and timer handler code. 
This is moved to the idle loop and the signal handler, making it much more
clear why it is happening.

switch_timers now returns the old timer type so that it may be restored.  The
signal handler uses this in order to restore the previous timer type when it
returns.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h      |    2 +-
 arch/um/kernel/process.c  |    9 ++-------
 arch/um/os-Linux/signal.c |    9 +++------
 arch/um/os-Linux/time.c   |   27 ++++++++++++++++++++-------
 4 files changed, 26 insertions(+), 21 deletions(-)

diff -puN arch/um/include/os.h~uml-fix-timer-switching arch/um/include/os.h
--- a/arch/um/include/os.h~uml-fix-timer-switching
+++ a/arch/um/include/os.h
@@ -250,7 +250,7 @@ extern void os_dump_core(void);
 /* time.c */
 #define BILLION (1000 * 1000 * 1000)
 
-extern void switch_timers(int to_real);
+extern int switch_timers(int to_real);
 extern void idle_sleep(int secs);
 extern int set_interval(int is_virtual);
 extern void disable_timer(void);
diff -puN arch/um/kernel/process.c~uml-fix-timer-switching arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-fix-timer-switching
+++ a/arch/um/kernel/process.c
@@ -95,18 +95,11 @@ void *_switch_to(void *prev, void *next,
 	do {
 		current->thread.saved_task = NULL;
 
-		/* XXX need to check runqueues[cpu].idle */
-		if (current->pid == 0)
-			switch_timers(0);
-
 		switch_threads(&from->thread.switch_buf,
 			       &to->thread.switch_buf);
 
 		arch_switch_to(current->thread.prev_sched, current);
 
-		if (current->pid == 0)
-			switch_timers(1);
-
 		if (current->thread.saved_task)
 			show_regs(&(current->thread.regs));
 		next= current->thread.saved_task;
@@ -251,7 +244,9 @@ void default_idle(void)
 		if (need_resched())
 			schedule();
 
+		switch_timers(1);
 		idle_sleep(10);
+		switch_timers(0);
 	}
 }
 
diff -puN arch/um/os-Linux/signal.c~uml-fix-timer-switching arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-fix-timer-switching
+++ a/arch/um/os-Linux/signal.c
@@ -59,17 +59,11 @@ static void real_alarm_handler(int sig, 
 {
 	struct uml_pt_regs regs;
 
-	if (sig == SIGALRM)
-		switch_timers(0);
-
 	if (sc != NULL)
 		copy_sc(&regs, sc);
 	regs.is_user = 0;
 	unblock_signals();
 	timer_handler(sig, &regs);
-
-	if (sig == SIGALRM)
-		switch_timers(1);
 }
 
 void alarm_handler(int sig, struct sigcontext *sc)
@@ -116,6 +110,7 @@ void (*handlers[_NSIG])(int sig, struct 
 void handle_signal(int sig, struct sigcontext *sc)
 {
 	unsigned long pending = 1UL << sig;
+	int timer = switch_timers(0);
 
 	do {
 		int nested, bail;
@@ -152,6 +147,8 @@ void handle_signal(int sig, struct sigco
 		if (!nested)
 			pending = from_irq_stack(nested);
 	} while (pending);
+
+	switch_timers(timer);
 }
 
 extern void hard_handler(int sig);
diff -puN arch/um/os-Linux/time.c~uml-fix-timer-switching arch/um/os-Linux/time.c
--- a/arch/um/os-Linux/time.c~uml-fix-timer-switching
+++ a/arch/um/os-Linux/time.c
@@ -12,6 +12,8 @@
 #include "os.h"
 #include "user.h"
 
+static int is_real_timer = 0;
+
 int set_interval(int is_virtual)
 {
 	int usec = 1000000/UM_HZ;
@@ -39,12 +41,14 @@ void disable_timer(void)
 	signal(SIGVTALRM, SIG_IGN);
 }
 
-void switch_timers(int to_real)
+int switch_timers(int to_real)
 {
 	struct itimerval disable = ((struct itimerval) { { 0, 0 }, { 0, 0 }});
-	struct itimerval enable = ((struct itimerval) { { 0, 1000000/UM_HZ },
-							{ 0, 1000000/UM_HZ }});
-	int old, new;
+	struct itimerval enable;
+	int old, new, old_type = is_real_timer;
+
+	if(to_real == old_type)
+		return to_real;
 
 	if (to_real) {
 		old = ITIMER_VIRTUAL;
@@ -55,10 +59,19 @@ void switch_timers(int to_real)
 		new = ITIMER_VIRTUAL;
 	}
 
-	if ((setitimer(old, &disable, NULL) < 0) ||
-	    (setitimer(new, &enable, NULL)))
-		printk(UM_KERN_ERR "switch_timers - setitimer failed, "
+	if (setitimer(old, &disable, &enable) < 0)
+		printk(UM_KERN_ERR "switch_timers - setitimer disable failed, "
+		       "errno = %d\n", errno);
+
+	if((enable.it_value.tv_sec == 0) && (enable.it_value.tv_usec == 0))
+		enable.it_value = enable.it_interval;
+
+	if (setitimer(new, &enable, NULL))
+		printk(UM_KERN_ERR "switch_timers - setitimer enable failed, "
 		       "errno = %d\n", errno);
+
+	is_real_timer = to_real;
+	return old_type;
 }
 
 unsigned long long os_nsecs(void)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
