From: akpm@linux-foundation.org
Subject: - vmi-fix-nohz-compile.patch removed from -mm tree
Date: Mon, 05 Mar 2007 15:55:25 -0800
Message-ID: <200703052355.l25NtPok005185@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41947 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932696AbXCEXz1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 18:55:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     vmi: fix nohz compile
has been removed from the -mm tree.  Its filename was
     vmi-fix-nohz-compile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vmi: fix nohz compile
From: Zachary Amsden <zach@vmware.com>

More goo from hrtimers integration.  We do compile and run properly with NO_HZ
enabled.  There was a period when we didn't because of a missing export, but
that was since fixed.

And with the clocksource code now firmly in place, we can get rid of code that
fixes up the wallclock, since this is done in the common infrastructure.  This
actually fixes a timer bug as well, that was caused by do_settimeofday no
longer being callable with interrupts disabled due to the use of
on_each_cpu().

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig          |    2 +-
 arch/i386/kernel/vmi.c     |    1 +
 arch/i386/kernel/vmitime.c |   15 ---------------
 3 files changed, 2 insertions(+), 16 deletions(-)

diff -puN arch/i386/Kconfig~vmi-fix-nohz-compile arch/i386/Kconfig
--- a/arch/i386/Kconfig~vmi-fix-nohz-compile
+++ a/arch/i386/Kconfig
@@ -220,7 +220,7 @@ config PARAVIRT
 
 config VMI
 	bool "VMI Paravirt-ops support"
-	depends on PARAVIRT && !NO_HZ
+	depends on PARAVIRT
 	default y
 	help
 	  VMI provides a paravirtualized interface to multiple hypervisors
diff -puN arch/i386/kernel/vmi.c~vmi-fix-nohz-compile arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~vmi-fix-nohz-compile
+++ a/arch/i386/kernel/vmi.c
@@ -934,6 +934,7 @@ void __init vmi_init(void)
 #ifdef CONFIG_X86_IO_APIC
 	no_timer_check = 1;
 #endif
+	no_sync_cmos_clock = 1;
 
 	local_irq_restore(flags & X86_EFLAGS_IF);
 }
diff -puN arch/i386/kernel/vmitime.c~vmi-fix-nohz-compile arch/i386/kernel/vmitime.c
--- a/arch/i386/kernel/vmitime.c~vmi-fix-nohz-compile
+++ a/arch/i386/kernel/vmitime.c
@@ -153,13 +153,6 @@ static void vmi_get_wallclock_ts(struct 
 	ts->tv_sec = wallclock;
 }
 
-static void update_xtime_from_wallclock(void)
-{
-	struct timespec ts;
-	vmi_get_wallclock_ts(&ts);
-	do_settimeofday(&ts);
-}
-
 unsigned long vmi_get_wallclock(void)
 {
 	struct timespec ts;
@@ -197,18 +190,10 @@ void __init vmi_time_init(void)
 	set_intr_gate(LOCAL_TIMER_VECTOR, apic_vmi_timer_interrupt);
 #endif
 
-	no_sync_cmos_clock = 1;
-
-	vmi_get_wallclock_ts(&xtime);
-	set_normalized_timespec(&wall_to_monotonic,
-		-xtime.tv_sec, -xtime.tv_nsec);
-
 	real_cycles_accounted_system = read_real_cycles();
-	update_xtime_from_wallclock();
 	per_cpu(process_times_cycles_accounted_cpu, 0) = read_available_cycles();
 
 	cycles_per_sec = vmi_timer_ops.get_cycle_frequency();
-
 	cycles_per_jiffy = cycles_per_sec;
 	(void)do_div(cycles_per_jiffy, HZ);
 	cycles_per_alarm = cycles_per_sec;
_

Patches currently in -mm which might be from zach@vmware.com are

origin.patch
make-struct-vmi_ops-static.patch
