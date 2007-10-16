From: akpm@linux-foundation.org
Subject: - uml-generic_time-support.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:38:44 -0700
Message-ID: <200710162038.l9GKcirS015477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54640 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760423AbXJPV3K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:29:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     uml: GENERIC_TIME support
has been removed from the -mm tree.  Its filename was
     uml-generic_time-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
