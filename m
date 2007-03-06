From: akpm@linux-foundation.org
Subject: + paravirt-build-fixes.patch added to -mm tree
Date: Tue, 06 Mar 2007 01:43:34 -0800
Message-ID: <200703060943.l269hY2I018363@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60114 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030495AbXCFJnr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 04:43:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     paravirt build fixes
has been added to the -mm tree.  Its filename is
     paravirt-build-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: paravirt build fixes
From: Zachary Amsden <zach@vmware.com>

Ingo Molnar dropped support for NO_IDLE_HZ, which both VMI and the unmerged
Xen code depended on under config option PARAVIRT.  This broke the VMI
compile.  Since NO_IDLE_HZ is obsolete, and all paravirt guests will need
idle HZ timer support, make PARAVIRT select NO_HZ and drop NO_IDLE_HZ
specifics from the VMI backend that caused it to fail to compile.

Also, export next_timer_interrupt() in both NO_IDLE_HZ and NO_HZ builds,
as it is needed in both.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig           |    1 +
 arch/i386/kernel/vmitime.c  |   10 ----------
 include/asm-i386/vmi_time.h |   10 ----------
 kernel/timer.c              |    2 +-
 4 files changed, 2 insertions(+), 21 deletions(-)

diff -puN arch/i386/Kconfig~paravirt-build-fixes arch/i386/Kconfig
--- a/arch/i386/Kconfig~paravirt-build-fixes
+++ a/arch/i386/Kconfig
@@ -210,6 +210,7 @@ config PARAVIRT
 	bool "Paravirtualization support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	depends on !(X86_VISWS || X86_VOYAGER)
+	select NO_HZ
 	help
 	  Paravirtualization is a way of running multiple instances of
 	  Linux on the same machine, under a hypervisor.  This option
diff -puN arch/i386/kernel/vmitime.c~paravirt-build-fixes arch/i386/kernel/vmitime.c
--- a/arch/i386/kernel/vmitime.c~paravirt-build-fixes
+++ a/arch/i386/kernel/vmitime.c
@@ -59,8 +59,6 @@
 /* Cached VMI operations */
 struct vmi_timer_ops vmi_timer_ops;
 
-#ifdef CONFIG_NO_IDLE_HZ
-
 /* /proc/sys/kernel/hz_timer state. */
 int sysctl_hz_timer;
 
@@ -69,8 +67,6 @@ static DEFINE_PER_CPU(unsigned long, vmi
 static DEFINE_PER_CPU(unsigned long, vmi_idle_no_hz_jiffies);
 static DEFINE_PER_CPU(unsigned long, idle_start_jiffies);
 
-#endif /* CONFIG_NO_IDLE_HZ */
-
 /* Number of alarms per second. By default this is CONFIG_VMI_ALARM_HZ. */
 static int alarm_hz = CONFIG_VMI_ALARM_HZ;
 
@@ -298,7 +294,6 @@ static void vmi_account_process_times_cy
 	}
 }
 
-#ifdef CONFIG_NO_IDLE_HZ
 /* Update per-cpu idle times.  Used when a no-hz halt is ended. */
 static void vmi_account_no_hz_idle_cycles(int cpu,
 					  unsigned long long cur_process_times_cycles)
@@ -317,7 +312,6 @@ static void vmi_account_no_hz_idle_cycle
 	/* Account time to the idle process. */
 	account_steal_time(idle_task(cpu), jiffies_to_cputime(no_idle_hz_jiffies));
 }
-#endif
 
 /* Update per-cpu stolen time. */
 static void vmi_account_stolen_cycles(int cpu,
@@ -358,8 +352,6 @@ static void vmi_local_timer_interrupt(in
 	vmi_account_stolen_cycles(cpu, cur_real_cycles, cur_process_times_cycles);
 }
 
-#ifdef CONFIG_NO_IDLE_HZ
-
 /* Must be called only from idle loop, with interrupts disabled. */
 int vmi_stop_hz_timer(void)
 {
@@ -436,8 +428,6 @@ void vmi_account_time_restart_hz_timer(v
 	vmi_reenable_hz_timer(cpu);
 }
 
-#endif /* CONFIG_NO_IDLE_HZ */
-
 /* UP (and no local-APIC) VMI-timer alarm interrupt handler.
  * Handler for IRQ0. Not used when SMP or X86_LOCAL_APIC after
  * APIC setup and setup_boot_vmi_alarm() is called.  */
diff -puN include/asm-i386/vmi_time.h~paravirt-build-fixes include/asm-i386/vmi_time.h
--- a/include/asm-i386/vmi_time.h~paravirt-build-fixes
+++ a/include/asm-i386/vmi_time.h
@@ -58,18 +58,8 @@ extern void __init vmi_timer_setup_secon
 extern void apic_vmi_timer_interrupt(void);
 #endif
 
-#ifdef CONFIG_NO_IDLE_HZ
 extern int vmi_stop_hz_timer(void);
 extern void vmi_account_time_restart_hz_timer(void);
-#else
-static inline int vmi_stop_hz_timer(void)
-{
-	return 0;
-}
-static inline void vmi_account_time_restart_hz_timer(void)
-{
-}
-#endif
 
 /*
  * When run under a hypervisor, a vcpu is always in one of three states:
diff -puN kernel/timer.c~paravirt-build-fixes kernel/timer.c
--- a/kernel/timer.c~paravirt-build-fixes
+++ a/kernel/timer.c
@@ -728,7 +728,7 @@ unsigned long get_next_timer_interrupt(u
 	return cmp_next_hrtimer_event(now, expires);
 }
 
-#ifdef CONFIG_NO_IDLE_HZ
+#if defined(CONFIG_NO_IDLE_HZ) || defined(CONFIG_NO_HZ)
 unsigned long next_timer_interrupt(void)
 {
 	return get_next_timer_interrupt(jiffies);
_

Patches currently in -mm which might be from zach@vmware.com are

origin.patch
fix-build-with-config_no_idle_hz=n.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
remove-arch-i386-kernel-tscccustom_sched_clock.patch
paravirt-build-fixes.patch
make-struct-vmi_ops-static.patch
