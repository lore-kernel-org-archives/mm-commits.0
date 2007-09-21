From: akpm@linux-foundation.org
Subject: + uml-use-sec_per_sec-constants.patch added to -mm tree
Date: Thu, 20 Sep 2007 21:45:37 -0700
Message-ID: <200709210445.l8L4jb5E019121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34971 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbXIUEqT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 00:46:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, tglx@linutronix.de


The patch titled
     uml: use *SEC_PER_*SEC constants
has been added to the -mm tree.  Its filename is
     uml-use-sec_per_sec-constants.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 arch/um/os-Linux/time.c          |   16 ++++++++--------
 5 files changed, 24 insertions(+), 19 deletions(-)

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
@@ -119,8 +119,9 @@ void __init time_init(void)
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
@@ -47,8 +47,8 @@ static inline unsigned long long tv_to_n
 	 * return.
 	 */
 
-	return ((unsigned long long) tv->tv_sec) * BILLION +
-		tv->tv_usec * 1000;
+	return ((unsigned long long) tv->tv_sec) * UM_NSEC_PER_SEC +
+		tv->tv_usec * UM_NSEC_PER_USEC;
 }
 
 unsigned long long disable_timer(void)
@@ -74,8 +74,8 @@ extern void alarm_handler(int sig, struc
 
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
uml-stop-saving-process-fp-state-fix.patch
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
uml-rename-pt_regs-general-purpose-register-file-fix.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
uml-fix-inlines.patch
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
uml-remove-unused-file.patch
uml-more-idiomatic-parameter-parsing.patch
uml-eliminate-hz.patch
uml-fix-timer-switching.patch
uml-simplify-interval-setting.patch
uml-separate-timer-initialization.patch
uml-generic_time-support.patch
uml-generic_clockevents-support.patch
uml-clocksource-support.patch
uml-tickless-support.patch
uml-eliminate-interrupts-in-the-idle-loop.patch
uml-eliminate-sigalrm.patch
uml-use-sec_per_sec-constants.patch
bitops-introduce-lock-ops.patch
