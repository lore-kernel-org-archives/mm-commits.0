From: akpm@osdl.org
Subject: + mark-tsc-on-geodelx-reliable.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:36:17 -0800
Message-ID: <200701250636.l0P6aHEA008318@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50410 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965560AbXAYGhc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:37:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcelo@kvack.org, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     Mark TSC on GeodeLX reliable
has been added to the -mm tree.  Its filename is
     mark-tsc-on-geodelx-reliable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
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
@@ -310,4 +310,7 @@ void wrmsr_on_cpu(unsigned int cpu, u32 
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x38f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x390
 
+/* Geode defined MSRs */
+#define MSR_GEODE_BUSCONT_CONF0         0x1900
+
 #endif /* __ASM_MSR_H */
_

Patches currently in -mm which might be from marcelo@kvack.org are

mark-tsc-on-geodelx-reliable.patch
