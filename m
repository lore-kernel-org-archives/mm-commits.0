From: akpm@linux-foundation.org
Subject: - mark-tsc-on-geodelx-reliable.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:14:11 -0800
Message-ID: <200702170714.l1H7EB3g021509@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51481 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946454AbXBQHX6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:23:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcelo@kvack.org, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Mark TSC on GeodeLX reliable
has been removed from the -mm tree.  Its filename was
     mark-tsc-on-geodelx-reliable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Mark TSC on GeodeLX reliable
From: Marcelo Tosatti <marcelo@kvack.org>

The Geode can safely use the TSC for highres, since:

1) Does not support frequency scaling,

2) The TSC _does_ count when the CPU is halted.  Furthermore, the Geode
   supports a mode called "suspension on halt", where Suspend mode (which
   interacts with the power management states) is entered.  TSC counting
   during suspend mode is controlled by bit 8 of the Bus Controller
   Configuration Register #0 (thanks Tom!).

3) no SMP :)

Check if "RTSC counts during suspension" and remove the requirement for
verification, so the clocksource code can safely select it as an timesource
for the highres timers subsystem.

Signed-off-by: Marcelo Tosatti <marcelo@kvack.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/tsc.c |   20 ++++++++++++++++++++
 include/asm-i386/msr.h |    3 +++
 2 files changed, 23 insertions(+)

diff -puN arch/i386/kernel/tsc.c~mark-tsc-on-geodelx-reliable arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~mark-tsc-on-geodelx-reliable
+++ a/arch/i386/kernel/tsc.c
@@ -364,6 +364,25 @@ __cpuinit int unsynchronized_tsc(void)
 	return tsc_unstable;
 }
 
+/*
+ * Geode_LX - the OLPC CPU has a possibly a very reliable TSC
+ */
+#ifdef CONFIG_MGEODE_LX
+/* RTSC counts during suspend */
+#define RTSC_SUSP 0x100
+
+static void __init check_geode_tsc_reliable(void)
+{
+	unsigned long val;
+
+	rdmsrl(MSR_GEODE_BUSCONT_CONF0, val);
+	if ((val & RTSC_SUSP))
+		clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
+}
+#else
+static inline void check_geode_tsc_reliable(void) { }
+#endif
+
 static int __init init_tsc_clocksource(void)
 {
 
@@ -372,6 +391,7 @@ static int __init init_tsc_clocksource(v
 		dmi_check_system(bad_tsc_dmi_table);
 
 		unsynchronized_tsc();
+		check_geode_tsc_reliable();
 		current_tsc_khz = tsc_khz;
 		clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
 							clocksource_tsc.shift);
diff -puN include/asm-i386/msr.h~mark-tsc-on-geodelx-reliable include/asm-i386/msr.h
--- a/include/asm-i386/msr.h~mark-tsc-on-geodelx-reliable
+++ a/include/asm-i386/msr.h
@@ -307,4 +307,7 @@ static inline void wrmsrl (unsigned long
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x38f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x390
 
+/* Geode defined MSRs */
+#define MSR_GEODE_BUSCONT_CONF0         0x1900
+
 #endif /* __ASM_MSR_H */
_

Patches currently in -mm which might be from marcelo@kvack.org are

origin.patch
