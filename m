From: akpm@linux-foundation.org
Subject: - uml-eliminate-interrupts-in-the-idle-loop.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:38:52 -0700
Message-ID: <200710162038.l9GKcqs3015489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59739 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933886AbXJPV2Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:28:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     uml: eliminate interrupts in the idle loop
has been removed from the -mm tree.  Its filename was
     uml-eliminate-interrupts-in-the-idle-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: eliminate interrupts in the idle loop
From: Jeff Dike <jdike@addtoit.com>

Now, the idle loop now longer needs SIGALRM firing - it can just sleep for the
requisite amount of time and fake a timer interrupt when it finishes.

Any use of ITIMER_REAL now goes away.  disable_timer only turns off
ITIMER_VIRTUAL.  switch_timers is no longer needed, so it, and all calls, goes
away.

disable_timer now returns the amount of time remaining on the timer. 
default_idle uses this to tell idle_sleep how long to sleep.  idle_sleep will
call alarm_handler if nanosleep returns 0, which is the case if it didn't
return early due to an interrupt.  Otherwise, it just returns.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h      |    5 +--
 arch/um/kernel/process.c  |    7 ++--
 arch/um/os-Linux/signal.c |    3 --
 arch/um/os-Linux/time.c   |   54 +++++++-----------------------------
 4 files changed, 17 insertions(+), 52 deletions(-)

diff -puN arch/um/include/os.h~uml-eliminate-interrupts-in-the-idle-loop arch/um/include/os.h
--- a/arch/um/include/os.h~uml-eliminate-interrupts-in-the-idle-loop
+++ a/arch/um/include/os.h
@@ -251,11 +251,10 @@ extern void os_dump_core(void);
 /* time.c */
 #define BILLION (1000 * 1000 * 1000)
 
-extern int switch_timers(int to_real);
-extern void idle_sleep(int secs);
+extern void idle_sleep(unsigned long long nsecs);
 extern int set_interval(void);
 extern int timer_one_shot(int ticks);
-extern void disable_timer(void);
+extern unsigned long long disable_timer(void);
 extern void uml_idle_timer(void);
 extern unsigned long long os_nsecs(void);
 
diff -puN arch/um/kernel/process.c~uml-eliminate-interrupts-in-the-idle-loop arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-eliminate-interrupts-in-the-idle-loop
+++ a/arch/um/kernel/process.c
@@ -235,6 +235,8 @@ void initial_thread_cb(void (*proc)(void
 
 void default_idle(void)
 {
+	unsigned long long nsecs;
+
 	while(1) {
 		/* endless idle loop with no priority at all */
 
@@ -246,9 +248,8 @@ void default_idle(void)
 			schedule();
 
 		tick_nohz_stop_sched_tick();
-		switch_timers(1);
-		idle_sleep(10);
-		switch_timers(0);
+		nsecs = disable_timer();
+		idle_sleep(nsecs);
 		tick_nohz_restart_sched_tick();
 	}
 }
diff -puN arch/um/os-Linux/signal.c~uml-eliminate-interrupts-in-the-idle-loop arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-eliminate-interrupts-in-the-idle-loop
+++ a/arch/um/os-Linux/signal.c
@@ -120,7 +120,6 @@ void (*handlers[_NSIG])(int sig, struct 
 void handle_signal(int sig, struct sigcontext *sc)
 {
 	unsigned long pending = 1UL << sig;
-	int timer = switch_timers(0);
 
 	do {
 		int nested, bail;
@@ -157,8 +156,6 @@ void handle_signal(int sig, struct sigco
 		if (!nested)
 			pending = from_irq_stack(nested);
 	} while (pending);
-
-	switch_timers(timer);
 }
 
 extern void hard_handler(int sig);
diff -puN arch/um/os-Linux/time.c~uml-eliminate-interrupts-in-the-idle-loop arch/um/os-Linux/time.c
--- a/arch/um/os-Linux/time.c~uml-eliminate-interrupts-in-the-idle-loop
+++ a/arch/um/os-Linux/time.c
@@ -12,8 +12,6 @@
 #include "os.h"
 #include "user.h"
 
-static int is_real_timer = 0;
-
 int set_interval(void)
 {
 	int usec = 1000000/UM_HZ;
@@ -41,47 +39,15 @@ int timer_one_shot(int ticks)
 	return 0;
 }
 
-void disable_timer(void)
+unsigned long long disable_timer(void)
 {
-	struct itimerval disable = ((struct itimerval) { { 0, 0 }, { 0, 0 }});
+	struct itimerval time = ((struct itimerval) { { 0, 0 }, { 0, 0 } });
 
-	if ((setitimer(ITIMER_VIRTUAL, &disable, NULL) < 0) ||
-	    (setitimer(ITIMER_REAL, &disable, NULL) < 0))
+	if(setitimer(ITIMER_VIRTUAL, &time, &time) < 0)
 		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
 		       "errno = %d\n", errno);
-}
-
-int switch_timers(int to_real)
-{
-	struct itimerval disable = ((struct itimerval) { { 0, 0 }, { 0, 0 }});
-	struct itimerval enable;
-	int old, new, old_type = is_real_timer;
-
-	if(to_real == old_type)
-		return to_real;
-
-	if (to_real) {
-		old = ITIMER_VIRTUAL;
-		new = ITIMER_REAL;
-	}
-	else {
-		old = ITIMER_REAL;
-		new = ITIMER_VIRTUAL;
-	}
-
-	if (setitimer(old, &disable, &enable) < 0)
-		printk(UM_KERN_ERR "switch_timers - setitimer disable failed, "
-		       "errno = %d\n", errno);
-
-	if((enable.it_value.tv_sec == 0) && (enable.it_value.tv_usec == 0))
-		enable.it_value = enable.it_interval;
 
-	if (setitimer(new, &enable, NULL))
-		printk(UM_KERN_ERR "switch_timers - setitimer enable failed, "
-		       "errno = %d\n", errno);
-
-	is_real_timer = to_real;
-	return old_type;
+	return tv_to_nsec(&time.it_value);
 }
 
 unsigned long long os_nsecs(void)
@@ -92,11 +58,13 @@ unsigned long long os_nsecs(void)
 	return timeval_to_ns(&tv);
 }
 
-void idle_sleep(int secs)
+extern void alarm_handler(int sig, struct sigcontext *sc);
+
+void idle_sleep(unsigned long long nsecs)
 {
-	struct timespec ts;
+	struct timespec ts = { .tv_sec	= nsecs / BILLION,
+			       .tv_nsec = nsecs % BILLION };
 
-	ts.tv_sec = secs;
-	ts.tv_nsec = 0;
-	nanosleep(&ts, NULL);
+	if (nanosleep(&ts, &ts) == 0)
+		alarm_handler(SIGVTALRM, NULL);
 }
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
