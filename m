From: akpm@linux-foundation.org
Subject: + uml-generic_time-support.patch added to -mm tree
Date: Thu, 20 Sep 2007 21:45:27 -0700
Message-ID: <200709210445.l8L4jRGP019103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58203 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332AbXIUEqJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 00:46:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, tglx@linutronix.de


The patch titled
     uml: GENERIC_TIME support
has been added to the -mm tree.  Its filename is
     uml-generic_time-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: GENERIC_TIME support
From: Jeff Dike <jdike@addtoit.com>

Enable CONFIG_GENERIC_TIME.

As a side-effect of this, the UML implementations of do_gettimeofday and
do_settimeofday go away, as these are provided by generic code.  set_time also
goes away since it was only used by do_settimeofday.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig        |    5 ++++
 arch/um/kernel/ksyms.c |    3 --
 arch/um/kernel/time.c  |   40 ---------------------------------------
 3 files changed, 5 insertions(+), 43 deletions(-)

diff -puN arch/um/Kconfig~uml-generic_time-support arch/um/Kconfig
--- a/arch/um/Kconfig~uml-generic_time-support
+++ a/arch/um/Kconfig
@@ -55,6 +55,10 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
+config GENERIC_TIME
+	bool
+	default y
+
 # Used in kernel/irq/manage.c and include/linux/irq.h
 config IRQ_RELEASE_METHOD
 	bool
@@ -75,6 +79,7 @@ config STATIC_LINK
 
 source "arch/um/Kconfig.arch"
 source "mm/Kconfig"
+source "kernel/time/Kconfig"
 
 config LD_SCRIPT_STATIC
 	bool
diff -puN arch/um/kernel/ksyms.c~uml-generic_time-support arch/um/kernel/ksyms.c
--- a/arch/um/kernel/ksyms.c~uml-generic_time-support
+++ a/arch/um/kernel/ksyms.c
@@ -67,9 +67,6 @@ EXPORT_SYMBOL(run_helper);
 EXPORT_SYMBOL(start_thread);
 EXPORT_SYMBOL(dump_thread);
 
-EXPORT_SYMBOL(do_gettimeofday);
-EXPORT_SYMBOL(do_settimeofday);
-
 #ifdef CONFIG_SMP
 
 /* required for SMP */
diff -puN arch/um/kernel/time.c~uml-generic_time-support arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-generic_time-support
+++ a/arch/um/kernel/time.c
@@ -123,46 +123,6 @@ void time_init(void)
 	late_time_init = register_timer;
 }
 
-void do_gettimeofday(struct timeval *tv)
-{
-#ifdef CONFIG_UML_REAL_TIME_CLOCK
-	unsigned long long nsecs = get_time();
-#else
-	unsigned long long nsecs = (unsigned long long) xtime.tv_sec * BILLION +
-		xtime.tv_nsec;
-#endif
-	tv->tv_sec = nsecs / NSEC_PER_SEC;
-	/*
-	 * Careful about calculations here - this was originally done as
-	 * (nsecs - tv->tv_sec * NSEC_PER_SEC) / NSEC_PER_USEC
-	 * which gave bogus (> 1000000) values.  Dunno why, suspect gcc
-	 * (4.0.0) miscompiled it, or there's a subtle 64/32-bit conversion
-	 * problem that I missed.
-	 */
-	nsecs -= tv->tv_sec * NSEC_PER_SEC;
-	tv->tv_usec = (unsigned long) nsecs / NSEC_PER_USEC;
-}
-
-static inline void set_time(unsigned long long nsecs)
-{
-	unsigned long long now;
-	unsigned long flags;
-
-	spin_lock_irqsave(&timer_spinlock, flags);
-	now = os_nsecs();
-	local_offset = nsecs - now;
-	spin_unlock_irqrestore(&timer_spinlock, flags);
-
-	clock_was_set();
-}
-
-int do_settimeofday(struct timespec *tv)
-{
-	set_time((unsigned long long) tv->tv_sec * NSEC_PER_SEC + tv->tv_nsec);
-
-	return 0;
-}
-
 void timer_handler(int sig, struct uml_pt_regs *regs)
 {
 	if (current_thread->cpu == 0)
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
