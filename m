From: akpm@linux-foundation.org
Subject: + vmi-cpu-cycles-fix.patch added to -mm tree
Date: Thu, 01 Mar 2007 19:37:18 -0800
Message-ID: <200703020337.l223bIEV031340@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39678 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422804AbXCBDhU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 22:37:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com


The patch titled
     vmi: cpu cycles fix
has been added to the -mm tree.  Its filename is
     vmi-cpu-cycles-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vmi: cpu cycles fix
From: Zachary Amsden <zach@vmware.com>

In order to share the common code in tsc.c which does CPU Khz calibration, we
need to make an accurate value of CPU speed available to the tsc.c code.  This
value loses a lot of precision in a VM because of the timing differences with
real hardware, but we need it to be as precise as possible so the guest can
make accurate time calculations with the cycle counters.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c |    1 +
 arch/i386/kernel/tsc.c      |    2 +-
 arch/i386/kernel/vmi.c      |    1 +
 arch/i386/kernel/vmitime.c  |   10 +++++++++-
 include/asm-i386/paravirt.h |    2 ++
 include/asm-i386/timer.h    |    2 ++
 include/asm-i386/vmi_time.h |    1 +
 7 files changed, 17 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~vmi-cpu-cycles-fix arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~vmi-cpu-cycles-fix
+++ a/arch/i386/kernel/paravirt.c
@@ -522,6 +522,7 @@ struct paravirt_ops paravirt_ops = {
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 	.get_scheduled_cycles = native_read_tsc,
+	.get_cpu_khz = native_calculate_cpu_khz,
 	.load_tr_desc = native_load_tr_desc,
 	.set_ldt = native_set_ldt,
 	.load_gdt = native_load_gdt,
diff -puN arch/i386/kernel/tsc.c~vmi-cpu-cycles-fix arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~vmi-cpu-cycles-fix
+++ a/arch/i386/kernel/tsc.c
@@ -117,7 +117,7 @@ unsigned long long sched_clock(void)
 	return cycles_2_ns(this_offset);
 }
 
-static unsigned long calculate_cpu_khz(void)
+unsigned long native_calculate_cpu_khz(void)
 {
 	unsigned long long start, end;
 	unsigned long count;
diff -puN arch/i386/kernel/vmi.c~vmi-cpu-cycles-fix arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~vmi-cpu-cycles-fix
+++ a/arch/i386/kernel/vmi.c
@@ -874,6 +874,7 @@ static inline int __init activate_vmi(vo
 		paravirt_ops.setup_secondary_clock = vmi_timer_setup_secondary_alarm;
 #endif
 		paravirt_ops.get_scheduled_cycles = vmi_get_sched_cycles;
+ 		paravirt_ops.get_cpu_khz = vmi_cpu_khz;
 	}
 	if (!disable_noidle)
 		para_fill(safe_halt, Halt);
diff -puN arch/i386/kernel/vmitime.c~vmi-cpu-cycles-fix arch/i386/kernel/vmitime.c
--- a/arch/i386/kernel/vmitime.c~vmi-cpu-cycles-fix
+++ a/arch/i386/kernel/vmitime.c
@@ -177,6 +177,15 @@ unsigned long long vmi_get_sched_cycles(
 	return read_available_cycles();
 }
 
+unsigned long vmi_cpu_khz(void)
+{
+	unsigned long long khz;
+
+	khz = vmi_timer_ops.get_cycle_frequency();
+	(void)do_div(khz, 1000);
+	return khz;
+}
+
 void __init vmi_time_init(void)
 {
 	unsigned long long cycles_per_sec, cycles_per_msec;
@@ -206,7 +215,6 @@ void __init vmi_time_init(void)
 	(void)do_div(cycles_per_alarm, alarm_hz);
 	cycles_per_msec = cycles_per_sec;
 	(void)do_div(cycles_per_msec, 1000);
-	cpu_khz = cycles_per_msec;
 
 	printk(KERN_WARNING "VMI timer cycles/sec = %llu ; cycles/jiffy = %llu ;"
 	       "cycles/alarm = %llu\n", cycles_per_sec, cycles_per_jiffy,
diff -puN include/asm-i386/paravirt.h~vmi-cpu-cycles-fix include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~vmi-cpu-cycles-fix
+++ a/include/asm-i386/paravirt.h
@@ -95,6 +95,7 @@ struct paravirt_ops
 	u64 (*read_tsc)(void);
 	u64 (*read_pmc)(void);
  	u64 (*get_scheduled_cycles)(void);
+	unsigned long (*get_cpu_khz)(void);
 
 	void (*load_tr_desc)(void);
 	void (*load_gdt)(const struct Xgt_desc_struct *);
@@ -275,6 +276,7 @@ static inline void halt(void)
 #define rdtscll(val) (val = paravirt_ops.read_tsc())
 
 #define get_scheduled_cycles(val) (val = paravirt_ops.get_scheduled_cycles())
+#define calculate_cpu_khz() (paravirt_ops.get_cpu_khz())
 
 #define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
 
diff -puN include/asm-i386/timer.h~vmi-cpu-cycles-fix include/asm-i386/timer.h
--- a/include/asm-i386/timer.h~vmi-cpu-cycles-fix
+++ a/include/asm-i386/timer.h
@@ -7,6 +7,7 @@
 
 void setup_pit_timer(void);
 unsigned long long native_sched_clock(void);
+unsigned long native_calculate_cpu_khz(void);
 
 /* Modifiers for buggy PIT handling */
 extern int pit_latch_buggy;
@@ -17,6 +18,7 @@ extern int recalibrate_cpu_khz(void);
 
 #ifndef CONFIG_PARAVIRT
 #define get_scheduled_cycles(val) rdtscll(val)
+#define calculate_cpu_khz() native_calculate_cpu_khz()
 #endif
 
 #endif
diff -puN include/asm-i386/vmi_time.h~vmi-cpu-cycles-fix include/asm-i386/vmi_time.h
--- a/include/asm-i386/vmi_time.h~vmi-cpu-cycles-fix
+++ a/include/asm-i386/vmi_time.h
@@ -50,6 +50,7 @@ extern void __init vmi_time_init(void);
 extern unsigned long vmi_get_wallclock(void);
 extern int vmi_set_wallclock(unsigned long now);
 extern unsigned long long vmi_get_sched_cycles(void);
+extern unsigned long vmi_cpu_khz(void);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 extern void __init vmi_timer_setup_boot_alarm(void);
_

Patches currently in -mm which might be from zach@vmware.com are

vmi-timer-fixes-round-two.patch
vmi-sched-clock-paravirt-op-fix.patch
vmi-cpu-cycles-fix.patch
vmi-fix-highpte.patch
vmi-paravirt-drop-udelay-op.patch
vmi-pit-override.patch
vmi-fix-nohz-compile.patch
vmi-apic-ops.patch
vmi-smp-fixes.patch
make-struct-vmi_ops-static.patch
xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
xen-paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
xen-paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
xen-paravirt_ops-add-common-patching-machinery.patch
xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
