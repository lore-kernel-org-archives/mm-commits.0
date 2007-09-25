From: akpm@linux-foundation.org
Subject: + uml-time-build-fix.patch added to -mm tree
Date: Tue, 25 Sep 2007 10:52:33 -0700
Message-ID: <200709251752.l8PHqXww029610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50624 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942AbXIYRxJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 13:53:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: time build fix
has been added to the -mm tree.  Its filename is
     uml-time-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: time build fix
From: Jeff Dike <jdike@addtoit.com>

Put back an implementation of timeval_to_ns in arch/um/os-Linux/time.c. 
tglx pointed out in his review of tickless support that there was a
perfectly good implementation of it in linux/time.h.  The problem is that
this is userspace code which can't pull in kernel headers and there doesn't
seem to be a libc version.

So, I'm copying the version from linux/time.h rather than resurrecting my
version.  This causes some declaration changes as it now returns a signed
value rather than an unsigned value.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h    |    4 ++--
 arch/um/os-Linux/time.c |   22 +++++++++++++++++++---
 2 files changed, 21 insertions(+), 5 deletions(-)

diff -puN arch/um/include/os.h~uml-time-build-fix arch/um/include/os.h
--- a/arch/um/include/os.h~uml-time-build-fix
+++ a/arch/um/include/os.h
@@ -254,9 +254,9 @@ extern void os_dump_core(void);
 extern void idle_sleep(unsigned long long nsecs);
 extern int set_interval(void);
 extern int timer_one_shot(int ticks);
-extern unsigned long long disable_timer(void);
+extern long long disable_timer(void);
 extern void uml_idle_timer(void);
-extern unsigned long long os_nsecs(void);
+extern long long os_nsecs(void);
 
 /* skas/mem.c */
 extern long run_syscall_stub(struct mm_id * mm_idp,
diff -puN arch/um/os-Linux/time.c~uml-time-build-fix arch/um/os-Linux/time.c
--- a/arch/um/os-Linux/time.c~uml-time-build-fix
+++ a/arch/um/os-Linux/time.c
@@ -39,7 +39,23 @@ int timer_one_shot(int ticks)
 	return 0;
 }
 
-unsigned long long disable_timer(void)
+/**
+ * timeval_to_ns - Convert timeval to nanoseconds
+ * @ts:		pointer to the timeval variable to be converted
+ *
+ * Returns the scalar nanosecond representation of the timeval
+ * parameter.
+ *
+ * Ripped from linux/time.h because it's a kernel header, and thus
+ * unusable from here.
+ */
+static inline long long timeval_to_ns(const struct timeval *tv)
+{
+	return ((long long) tv->tv_sec * UM_NSEC_PER_SEC) +
+		tv->tv_usec * UM_NSEC_PER_USEC;
+}
+
+long long disable_timer(void)
 {
 	struct itimerval time = ((struct itimerval) { { 0, 0 }, { 0, 0 } });
 
@@ -47,10 +63,10 @@ unsigned long long disable_timer(void)
 		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
 		       "errno = %d\n", errno);
 
-	return tv_to_nsec(&time.it_value);
+	return timeval_to_ns(&time.it_value);
 }
 
-unsigned long long os_nsecs(void)
+long long os_nsecs(void)
 {
 	struct timeval tv;
 
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
uml-clocksource-support-fix.patch
uml-tickless-support.patch
uml-tickless-support-fix.patch
uml-eliminate-interrupts-in-the-idle-loop.patch
uml-time-build-fix.patch
uml-eliminate-sigalrm.patch
uml-use-sec_per_sec-constants.patch
bitops-introduce-lock-ops.patch
