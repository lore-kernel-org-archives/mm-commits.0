From: akpm@linux-foundation.org
Subject: + vmi-sched-clock-paravirt-op-fix.patch added to -mm tree
Date: Thu, 01 Mar 2007 19:37:16 -0800
Message-ID: <200703020337.l223bGhf031337@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39675 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422802AbXCBDhS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 22:37:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com


The patch titled
     vmi: sched clock paravirt op fix
has been added to the -mm tree.  Its filename is
     vmi-sched-clock-paravirt-op-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vmi: sched clock paravirt op fix
From: Zachary Amsden <zach@vmware.com>

The custom_sched_clock hook is broken.  The result from sched_clock needs to
be in nanoseconds, not in CPU cycles.  The TSC is insufficient for this
purpose, because TSC is poorly defined in a virtual environment, and mostly
represents real world time instead of scheduled process time (which can be
interrupted without notice when a virtual machine is descheduled).

To make the scheduler consistent, we must expose a different nature of time,
that is scheduled time.  So deprecate this custom_sched_clock hack and turn it
into a paravirt-op, as it should have been all along.  This allows the tsc.c
code which converts cycles to nanoseconds to be shared by all paravirt-ops
backends.

It is unfortunate to add a new paravirt-op, but this is a very distinct
abstraction which is clearly different for all virtual machine
implementations, and it gets rid of an ugly indirect function which I
ashamedly admit I hacked in to try to get this to work earlier, and then even
got in the wrong units.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c |    2 ++
 arch/i386/kernel/tsc.c      |    6 ++----
 arch/i386/kernel/vmi.c      |    2 +-
 arch/i386/kernel/vmitime.c  |    2 +-
 include/asm-i386/paravirt.h |    3 +++
 include/asm-i386/time.h     |    1 -
 include/asm-i386/timer.h    |    8 +++++++-
 include/asm-i386/vmi_time.h |    2 +-
 8 files changed, 17 insertions(+), 9 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~vmi-sched-clock-paravirt-op-fix arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~vmi-sched-clock-paravirt-op-fix
+++ a/arch/i386/kernel/paravirt.c
@@ -32,6 +32,7 @@
 #include <asm/fixmap.h>
 #include <asm/apic.h>
 #include <asm/tlbflush.h>
+#include <asm/timer.h>
 
 /* nop stub */
 static void native_nop(void)
@@ -520,6 +521,7 @@ struct paravirt_ops paravirt_ops = {
 	.write_msr = native_write_msr,
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
+	.get_scheduled_cycles = native_read_tsc,
 	.load_tr_desc = native_load_tr_desc,
 	.set_ldt = native_set_ldt,
 	.load_gdt = native_load_gdt,
diff -puN arch/i386/kernel/tsc.c~vmi-sched-clock-paravirt-op-fix arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~vmi-sched-clock-paravirt-op-fix
+++ a/arch/i386/kernel/tsc.c
@@ -14,6 +14,7 @@
 #include <asm/delay.h>
 #include <asm/tsc.h>
 #include <asm/io.h>
+#include <asm/timer.h>
 
 #include "mach_timer.h"
 
@@ -102,9 +103,6 @@ unsigned long long sched_clock(void)
 {
 	unsigned long long this_offset;
 
-	if (unlikely(custom_sched_clock))
-		return (*custom_sched_clock)();
-
 	/*
 	 * Fall back to jiffies if there's no TSC available:
 	 */
@@ -113,7 +111,7 @@ unsigned long long sched_clock(void)
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 
 	/* read the Time Stamp Counter: */
-	rdtscll(this_offset);
+	get_scheduled_cycles(this_offset);
 
 	/* return the value in ns */
 	return cycles_2_ns(this_offset);
diff -puN arch/i386/kernel/vmi.c~vmi-sched-clock-paravirt-op-fix arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~vmi-sched-clock-paravirt-op-fix
+++ a/arch/i386/kernel/vmi.c
@@ -873,7 +873,7 @@ static inline int __init activate_vmi(vo
 		paravirt_ops.setup_boot_clock = vmi_timer_setup_boot_alarm;
 		paravirt_ops.setup_secondary_clock = vmi_timer_setup_secondary_alarm;
 #endif
-		custom_sched_clock = vmi_sched_clock;
+		paravirt_ops.get_scheduled_cycles = vmi_get_sched_cycles;
 	}
 	if (!disable_noidle)
 		para_fill(safe_halt, Halt);
diff -puN arch/i386/kernel/vmitime.c~vmi-sched-clock-paravirt-op-fix arch/i386/kernel/vmitime.c
--- a/arch/i386/kernel/vmitime.c~vmi-sched-clock-paravirt-op-fix
+++ a/arch/i386/kernel/vmitime.c
@@ -172,7 +172,7 @@ int vmi_set_wallclock(unsigned long now)
 	return -1;
 }
 
-unsigned long long vmi_sched_clock(void)
+unsigned long long vmi_get_sched_cycles(void)
 {
 	return read_available_cycles();
 }
diff -puN include/asm-i386/paravirt.h~vmi-sched-clock-paravirt-op-fix include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~vmi-sched-clock-paravirt-op-fix
+++ a/include/asm-i386/paravirt.h
@@ -94,6 +94,7 @@ struct paravirt_ops
 
 	u64 (*read_tsc)(void);
 	u64 (*read_pmc)(void);
+ 	u64 (*get_scheduled_cycles)(void);
 
 	void (*load_tr_desc)(void);
 	void (*load_gdt)(const struct Xgt_desc_struct *);
@@ -273,6 +274,8 @@ static inline void halt(void)
 
 #define rdtscll(val) (val = paravirt_ops.read_tsc())
 
+#define get_scheduled_cycles(val) (val = paravirt_ops.get_scheduled_cycles())
+
 #define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
 
 #define rdpmc(counter,low,high) do {				\
diff -puN include/asm-i386/time.h~vmi-sched-clock-paravirt-op-fix include/asm-i386/time.h
--- a/include/asm-i386/time.h~vmi-sched-clock-paravirt-op-fix
+++ a/include/asm-i386/time.h
@@ -30,7 +30,6 @@ static inline int native_set_wallclock(u
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
-extern unsigned long long native_sched_clock(void);
 #else /* !CONFIG_PARAVIRT */
 
 #define get_wallclock() native_get_wallclock()
diff -puN include/asm-i386/timer.h~vmi-sched-clock-paravirt-op-fix include/asm-i386/timer.h
--- a/include/asm-i386/timer.h~vmi-sched-clock-paravirt-op-fix
+++ a/include/asm-i386/timer.h
@@ -4,13 +4,19 @@
 #include <linux/pm.h>
 
 #define TICK_SIZE (tick_nsec / 1000)
+
 void setup_pit_timer(void);
+unsigned long long native_sched_clock(void);
+
 /* Modifiers for buggy PIT handling */
 extern int pit_latch_buggy;
 extern int timer_ack;
 extern int no_timer_check;
-extern unsigned long long (*custom_sched_clock)(void);
 extern int no_sync_cmos_clock;
 extern int recalibrate_cpu_khz(void);
 
+#ifndef CONFIG_PARAVIRT
+#define get_scheduled_cycles(val) rdtscll(val)
+#endif
+
 #endif
diff -puN include/asm-i386/vmi_time.h~vmi-sched-clock-paravirt-op-fix include/asm-i386/vmi_time.h
--- a/include/asm-i386/vmi_time.h~vmi-sched-clock-paravirt-op-fix
+++ a/include/asm-i386/vmi_time.h
@@ -49,7 +49,7 @@ extern struct vmi_timer_ops {
 extern void __init vmi_time_init(void);
 extern unsigned long vmi_get_wallclock(void);
 extern int vmi_set_wallclock(unsigned long now);
-extern unsigned long long vmi_sched_clock(void);
+extern unsigned long long vmi_get_sched_cycles(void);
 
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
