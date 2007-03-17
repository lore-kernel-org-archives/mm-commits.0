From: akpm@linux-foundation.org
Subject: - replace-get_scheduled_cycles-with-sched_clock-paravirt_op.patch removed from -mm tree
Date: Fri, 16 Mar 2007 17:28:42 -0700
Message-ID: <200703170030.l2H0UZ81025413@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44270 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932825AbXCQAao (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 20:30:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, dhecht@vmware.com, jeremy@xensource.com, johnstul@us.ibm.com, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     replace get_scheduled_cycles with sched_clock paravirt_op
has been removed from the -mm tree.  Its filename was
     replace-get_scheduled_cycles-with-sched_clock-paravirt_op.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: replace get_scheduled_cycles with sched_clock paravirt_op
From: Jeremy Fitzhardinge <jeremy@goop.org>

The tsc-based get_scheduled_cycles interface is not a good match for Xen's
runstate accounting, which reports everything in nanoseconds.

This patch replaces this interface with a sched_clock interface, which
matches both Xen and VMI's requirements.

In order to do this, we:
   1. replace get_scheduled_cycles with sched_clock
   2. hoist cycles_2_ns into a common header
   3. update vmi accordingly

One thing to note: because sched_clock is implemented as a weak function in
kernel/sched.c, we must define a real function in order to override this
weak binding.  This means the usual paravirt_ops technique of using an
inline function won't work in this case.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Acked-by: Zachary Amsden <zach@vmware.com>
Cc: Dan Hecht <dhecht@vmware.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c |    2 +-
 arch/i386/kernel/tsc.c      |   23 +++++++++++++++--------
 arch/i386/kernel/vmi.c      |    2 +-
 arch/i386/kernel/vmitime.c  |    4 ++--
 include/asm-i386/paravirt.h |    7 +++++--
 include/asm-i386/timer.h    |   32 +++++++++++++++++++++++++++++++-
 include/asm-i386/vmi_time.h |    2 +-
 7 files changed, 56 insertions(+), 16 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~replace-get_scheduled_cycles-with-sched_clock-paravirt_op arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~replace-get_scheduled_cycles-with-sched_clock-paravirt_op
+++ a/arch/i386/kernel/paravirt.c
@@ -521,7 +521,7 @@ struct paravirt_ops paravirt_ops = {
 	.write_msr = native_write_msr,
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
-	.get_scheduled_cycles = native_read_tsc,
+	.sched_clock = native_sched_clock,
 	.get_cpu_khz = native_calculate_cpu_khz,
 	.load_tr_desc = native_load_tr_desc,
 	.set_ldt = native_set_ldt,
diff -puN arch/i386/kernel/tsc.c~replace-get_scheduled_cycles-with-sched_clock-paravirt_op arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~replace-get_scheduled_cycles-with-sched_clock-paravirt_op
+++ a/arch/i386/kernel/tsc.c
@@ -81,7 +81,7 @@ static inline int check_tsc_unstable(voi
  *
  *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
  */
-static unsigned long cyc2ns_scale __read_mostly;
+unsigned long cyc2ns_scale __read_mostly;
 
 #define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
 
@@ -90,15 +90,10 @@ static inline void set_cyc2ns_scale(unsi
 	cyc2ns_scale = (1000000 << CYC2NS_SCALE_FACTOR)/cpu_khz;
 }
 
-static inline unsigned long long cycles_2_ns(unsigned long long cyc)
-{
-	return (cyc * cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
-}
-
 /*
  * Scheduler clock - returns current time in nanosec units.
  */
-unsigned long long sched_clock(void)
+unsigned long long native_sched_clock(void)
 {
 	unsigned long long this_offset;
 
@@ -110,12 +105,24 @@ unsigned long long sched_clock(void)
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 
 	/* read the Time Stamp Counter: */
-	get_scheduled_cycles(this_offset);
+	rdtscll(this_offset);
 
 	/* return the value in ns */
 	return cycles_2_ns(this_offset);
 }
 
+/* We need to define a real function for sched_clock, to override the
+   weak default version */
+#ifdef CONFIG_PARAVIRT
+unsigned long long sched_clock(void)
+{
+	return paravirt_sched_clock();
+}
+#else
+unsigned long long sched_clock(void)
+	__attribute__((alias("native_sched_clock")));
+#endif
+
 unsigned long native_calculate_cpu_khz(void)
 {
 	unsigned long long start, end;
diff -puN arch/i386/kernel/vmi.c~replace-get_scheduled_cycles-with-sched_clock-paravirt_op arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~replace-get_scheduled_cycles-with-sched_clock-paravirt_op
+++ a/arch/i386/kernel/vmi.c
@@ -900,7 +900,7 @@ static inline int __init activate_vmi(vo
 		paravirt_ops.setup_boot_clock = vmi_timer_setup_boot_alarm;
 		paravirt_ops.setup_secondary_clock = vmi_timer_setup_secondary_alarm;
 #endif
-		paravirt_ops.get_scheduled_cycles = vmi_get_sched_cycles;
+		paravirt_ops.sched_clock = vmi_sched_clock;
  		paravirt_ops.get_cpu_khz = vmi_cpu_khz;
 
 		/* We have true wallclock functions; disable CMOS clock sync */
diff -puN arch/i386/kernel/vmitime.c~replace-get_scheduled_cycles-with-sched_clock-paravirt_op arch/i386/kernel/vmitime.c
--- a/arch/i386/kernel/vmitime.c~replace-get_scheduled_cycles-with-sched_clock-paravirt_op
+++ a/arch/i386/kernel/vmitime.c
@@ -159,9 +159,9 @@ int vmi_set_wallclock(unsigned long now)
 	return -1;
 }
 
-unsigned long long vmi_get_sched_cycles(void)
+unsigned long long vmi_sched_clock(void)
 {
-	return read_available_cycles();
+	return cycles_2_ns(read_available_cycles());
 }
 
 unsigned long vmi_cpu_khz(void)
diff -puN include/asm-i386/paravirt.h~replace-get_scheduled_cycles-with-sched_clock-paravirt_op include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~replace-get_scheduled_cycles-with-sched_clock-paravirt_op
+++ a/include/asm-i386/paravirt.h
@@ -94,7 +94,7 @@ struct paravirt_ops
 
 	u64 (*read_tsc)(void);
 	u64 (*read_pmc)(void);
- 	u64 (*get_scheduled_cycles)(void);
+ 	unsigned long long (*sched_clock)(void);
 	unsigned long (*get_cpu_khz)(void);
 
 	void (*load_tr_desc)(void);
@@ -276,7 +276,10 @@ static inline void halt(void)
 
 #define rdtscll(val) (val = paravirt_ops.read_tsc())
 
-#define get_scheduled_cycles(val) (val = paravirt_ops.get_scheduled_cycles())
+static inline unsigned long long paravirt_sched_clock(void)
+{
+	return PVOP_CALL0(unsigned long long, sched_clock);
+}
 #define calculate_cpu_khz() (paravirt_ops.get_cpu_khz())
 
 #define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
diff -puN include/asm-i386/timer.h~replace-get_scheduled_cycles-with-sched_clock-paravirt_op include/asm-i386/timer.h
--- a/include/asm-i386/timer.h~replace-get_scheduled_cycles-with-sched_clock-paravirt_op
+++ a/include/asm-i386/timer.h
@@ -15,8 +15,38 @@ extern int no_sync_cmos_clock;
 extern int recalibrate_cpu_khz(void);
 
 #ifndef CONFIG_PARAVIRT
-#define get_scheduled_cycles(val) rdtscll(val)
 #define calculate_cpu_khz() native_calculate_cpu_khz()
 #endif
 
+/* Accellerators for sched_clock()
+ * convert from cycles(64bits) => nanoseconds (64bits)
+ *  basic equation:
+ *		ns = cycles / (freq / ns_per_sec)
+ *		ns = cycles * (ns_per_sec / freq)
+ *		ns = cycles * (10^9 / (cpu_khz * 10^3))
+ *		ns = cycles * (10^6 / cpu_khz)
+ *
+ *	Then we use scaling math (suggested by george@mvista.com) to get:
+ *		ns = cycles * (10^6 * SC / cpu_khz) / SC
+ *		ns = cycles * cyc2ns_scale / SC
+ *
+ *	And since SC is a constant power of two, we can convert the div
+ *  into a shift.
+ *
+ *  We can use khz divisor instead of mhz to keep a better percision, since
+ *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
+ *  (mathieu.desnoyers@polymtl.ca)
+ *
+ *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
+ */
+extern unsigned long cyc2ns_scale __read_mostly;
+
+#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
+
+static inline unsigned long long cycles_2_ns(unsigned long long cyc)
+{
+	return (cyc * cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
+}
+
+
 #endif
diff -puN include/asm-i386/vmi_time.h~replace-get_scheduled_cycles-with-sched_clock-paravirt_op include/asm-i386/vmi_time.h
--- a/include/asm-i386/vmi_time.h~replace-get_scheduled_cycles-with-sched_clock-paravirt_op
+++ a/include/asm-i386/vmi_time.h
@@ -49,7 +49,7 @@ extern struct vmi_timer_ops {
 extern void __init vmi_time_init(void);
 extern unsigned long vmi_get_wallclock(void);
 extern int vmi_set_wallclock(unsigned long now);
-extern unsigned long long vmi_get_sched_cycles(void);
+extern unsigned long long vmi_sched_clock(void);
 extern unsigned long vmi_cpu_khz(void);
 
 #ifdef CONFIG_X86_LOCAL_APIC
_

Patches currently in -mm which might be from jeremy@goop.org are

replace-get_scheduled_cycles-with-sched_clock-paravirt_op.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
