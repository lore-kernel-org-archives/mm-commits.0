From: akpm@linux-foundation.org
Subject: - uml-use-sec_per_sec-constants.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:38:58 -0700
Message-ID: <200710162038.l9GKcwIj015501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43037 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933886AbXJPV2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     uml: use *SEC_PER_*SEC constants
has been removed from the -mm tree.  Its filename was
     uml-use-sec_per_sec-constants.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: use *SEC_PER_*SEC constants
From: Jeff Dike <jdike@addtoit.com>

There are various uses of powers of 1000, plus the odd BILLION constant in the
time code.  However, there are perfectly good definitions of *SEC_PER_*SEC in
linux/time.h which can be used instaed.

These are replaced directly in kernel code.  Userspace code imports those
constants as UM_*SEC_PER_*SEC and uses these.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/common-offsets.h |    4 ++++
 arch/um/include/os.h             |    2 --
 arch/um/kernel/time.c            |    9 +++++----
 arch/um/os-Linux/skas/process.c  |   12 +++++++-----
 arch/um/os-Linux/time.c          |   12 ++++++------
 5 files changed, 22 insertions(+), 17 deletions(-)

diff -puN arch/um/include/common-offsets.h~uml-use-sec_per_sec-constants arch/um/include/common-offsets.h
--- a/arch/um/include/common-offsets.h~uml-use-sec_per_sec-constants
+++ a/arch/um/include/common-offsets.h
@@ -34,3 +34,7 @@ DEFINE(crypto_tfm_ctx_offset, offsetof(s
 DEFINE(UM_THREAD_SIZE, THREAD_SIZE);
 
 DEFINE(UM_HZ, HZ);
+
+DEFINE(UM_USEC_PER_SEC, USEC_PER_SEC);
+DEFINE(UM_NSEC_PER_SEC, NSEC_PER_SEC);
+DEFINE(UM_NSEC_PER_USEC, NSEC_PER_USEC);
diff -puN arch/um/include/os.h~uml-use-sec_per_sec-constants arch/um/include/os.h
--- a/arch/um/include/os.h~uml-use-sec_per_sec-constants
+++ a/arch/um/include/os.h
@@ -249,8 +249,6 @@ extern int setjmp_wrapper(void (*proc)(v
 extern void os_dump_core(void);
 
 /* time.c */
-#define BILLION (1000 * 1000 * 1000)
-
 extern void idle_sleep(unsigned long long nsecs);
 extern int set_interval(void);
 extern int timer_one_shot(int ticks);
diff -puN arch/um/kernel/time.c~uml-use-sec_per_sec-constants arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-use-sec_per_sec-constants
+++ a/arch/um/kernel/time.c
@@ -17,7 +17,7 @@
  */
 unsigned long long sched_clock(void)
 {
-	return (unsigned long long)jiffies_64 * (1000000000 / HZ);
+	return (unsigned long long)jiffies_64 * (NSEC_PER_SEC / HZ);
 }
 
 void timer_handler(int sig, struct uml_pt_regs *regs)
@@ -118,8 +118,9 @@ void __init time_init(void)
 	timer_init();
 
 	nsecs = os_nsecs();
-	set_normalized_timespec(&wall_to_monotonic, -nsecs / BILLION,
-				-nsecs % BILLION);
-	set_normalized_timespec(&xtime, nsecs / BILLION, nsecs % BILLION);
+	set_normalized_timespec(&wall_to_monotonic, -nsecs / NSEC_PER_SEC,
+				-nsecs % NSEC_PER_SEC);
+	set_normalized_timespec(&xtime, nsecs / NSEC_PER_SEC,
+				nsecs % NSEC_PER_SEC);
 	late_time_init = setup_itimer;
 }
diff -puN arch/um/os-Linux/skas/process.c~uml-use-sec_per_sec-constants arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-use-sec_per_sec-constants
+++ a/arch/um/os-Linux/skas/process.c
@@ -294,8 +294,8 @@ void userspace(struct uml_pt_regs *regs)
 
 	if (getitimer(ITIMER_VIRTUAL, &timer))
 		printk("Failed to get itimer, errno = %d\n", errno);
-	nsecs = timer.it_value.tv_sec * BILLION +
-		timer.it_value.tv_usec * 1000;
+	nsecs = timer.it_value.tv_sec * UM_NSEC_PER_SEC +
+		timer.it_value.tv_usec * UM_NSEC_PER_USEC;
 	nsecs += os_nsecs();
 
 	while (1) {
@@ -347,8 +347,10 @@ void userspace(struct uml_pt_regs *regs)
 				block_signals();
 				(*sig_info[sig])(sig, regs);
 				unblock_signals();
-				nsecs = timer.it_value.tv_sec * BILLION +
-					timer.it_value.tv_usec * 1000;
+				nsecs = timer.it_value.tv_sec *
+					UM_NSEC_PER_SEC +
+					timer.it_value.tv_usec *
+					UM_NSEC_PER_USEC;
 				nsecs += os_nsecs();
 				break;
 			case SIGIO:
@@ -395,7 +397,7 @@ __initcall(init_thread_regs);
 
 int copy_context_skas0(unsigned long new_stack, int pid)
 {
-	struct timeval tv = { .tv_sec = 0, .tv_usec = 1000000 / UM_HZ };
+	struct timeval tv = { .tv_sec = 0, .tv_usec = UM_USEC_PER_SEC / UM_HZ };
 	int err;
 	unsigned long current_stack = current_stub_stack();
 	struct stub_data *data = (struct stub_data *) current_stack;
diff -puN arch/um/os-Linux/time.c~uml-use-sec_per_sec-constants arch/um/os-Linux/time.c
--- a/arch/um/os-Linux/time.c~uml-use-sec_per_sec-constants
+++ a/arch/um/os-Linux/time.c
@@ -14,7 +14,7 @@
 
 int set_interval(void)
 {
-	int usec = 1000000/UM_HZ;
+	int usec = UM_USEC_PER_SEC / UM_HZ;
 	struct itimerval interval = ((struct itimerval) { { 0, usec },
 							  { 0, usec } });
 
@@ -26,11 +26,11 @@ int set_interval(void)
 
 int timer_one_shot(int ticks)
 {
-	unsigned long usec = ticks * 1000000 / UM_HZ;
-	unsigned long sec = usec / 1000000;
+	unsigned long usec = ticks * UM_USEC_PER_SEC / UM_HZ;
+	unsigned long sec = usec / UM_USEC_PER_SEC;
 	struct itimerval interval;
 
-	usec %= 1000000;
+	usec %= UM_USEC_PER_SEC;
 	interval = ((struct itimerval) { { 0, 0 }, { sec, usec } });
 
 	if (setitimer(ITIMER_VIRTUAL, &interval, NULL) == -1)
@@ -78,8 +78,8 @@ extern void alarm_handler(int sig, struc
 
 void idle_sleep(unsigned long long nsecs)
 {
-	struct timespec ts = { .tv_sec	= nsecs / BILLION,
-			       .tv_nsec = nsecs % BILLION };
+	struct timespec ts = { .tv_sec	= nsecs / UM_NSEC_PER_SEC,
+			       .tv_nsec = nsecs % UM_NSEC_PER_SEC };
 
 	if (nanosleep(&ts, &ts) == 0)
 		alarm_handler(SIGVTALRM, NULL);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
