From: akpm@linux-foundation.org
Subject: + uml-simplify-interval-setting.patch added to -mm tree
Date: Thu, 20 Sep 2007 21:45:24 -0700
Message-ID: <200709210445.l8L4jOBs019097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41279 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751907AbXIUEq3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 00:46:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, tglx@linutronix.de


The patch titled
     uml: simplify interval setting
has been added to the -mm tree.  Its filename is
     uml-simplify-interval-setting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: simplify interval setting
From: Jeff Dike <jdike@addtoit.com>

set_interval took a timer type as an argument, but it always specified a
virtual timer.  So, it is not needed, and it is gone, and set_interval is
simplified appropriately.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h            |    2 +-
 arch/um/kernel/time.c           |    2 +-
 arch/um/os-Linux/skas/process.c |    2 +-
 arch/um/os-Linux/time.c         |    5 ++---
 4 files changed, 5 insertions(+), 6 deletions(-)

diff -puN arch/um/include/os.h~uml-simplify-interval-setting arch/um/include/os.h
--- a/arch/um/include/os.h~uml-simplify-interval-setting
+++ a/arch/um/include/os.h
@@ -252,7 +252,7 @@ extern void os_dump_core(void);
 
 extern int switch_timers(int to_real);
 extern void idle_sleep(int secs);
-extern int set_interval(int is_virtual);
+extern int set_interval(void);
 extern void disable_timer(void);
 extern void uml_idle_timer(void);
 extern unsigned long long os_nsecs(void);
diff -puN arch/um/kernel/time.c~uml-simplify-interval-setting arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-simplify-interval-setting
+++ a/arch/um/kernel/time.c
@@ -102,7 +102,7 @@ static void register_timer(void)
 		printk(KERN_ERR "register_timer : request_irq failed - "
 		       "errno = %d\n", -err);
 
-	err = set_interval(1);
+	err = set_interval();
 	if (err != 0)
 		printk(KERN_ERR "register_timer : set_interval failed - "
 		       "errno = %d\n", -err);
diff -puN arch/um/os-Linux/skas/process.c~uml-simplify-interval-setting arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-simplify-interval-setting
+++ a/arch/um/os-Linux/skas/process.c
@@ -178,7 +178,7 @@ static int userspace_tramp(void *stack)
 	ptrace(PTRACE_TRACEME, 0, 0, 0);
 
 	init_new_thread_signals();
-	err = set_interval(1);
+	err = set_interval();
 	if (err)
 		panic("userspace_tramp - setting timer failed, errno = %d\n",
 		      err);
diff -puN arch/um/os-Linux/time.c~uml-simplify-interval-setting arch/um/os-Linux/time.c
--- a/arch/um/os-Linux/time.c~uml-simplify-interval-setting
+++ a/arch/um/os-Linux/time.c
@@ -14,14 +14,13 @@
 
 static int is_real_timer = 0;
 
-int set_interval(int is_virtual)
+int set_interval(void)
 {
 	int usec = 1000000/UM_HZ;
-	int timer_type = is_virtual ? ITIMER_VIRTUAL : ITIMER_REAL;
 	struct itimerval interval = ((struct itimerval) { { 0, usec },
 							  { 0, usec } });
 
-	if (setitimer(timer_type, &interval, NULL) == -1)
+	if (setitimer(ITIMER_VIRTUAL, &interval, NULL) == -1)
 		return -errno;
 
 	return 0;
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
