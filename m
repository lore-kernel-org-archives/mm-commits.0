From: akpm@linux-foundation.org
Subject: - time-x86_64-hpet_address-cleanup.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:15:32 -0800
Message-ID: <200702170715.l1H7FW4s021634@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51297 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946570AbXBQHTL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:19:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, ak@muc.de, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     time: x86_64: hpet_address cleanup
has been removed from the -mm tree.  Its filename was
     time-x86_64-hpet_address-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: time: x86_64: hpet_address cleanup
From: john stultz <johnstul@us.ibm.com>

In preparation for supporting generic timekeeping, this patch cleans up
x86-64's use of vxtime.hpet_address, changing it to just hpet_address as is
also used in i386.  This is necessary since the vxtime structure will be going
away.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@muc.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/acpi/boot.c |   20 +++---------------
 arch/x86_64/kernel/apic.c    |    3 +-
 arch/x86_64/kernel/time.c    |   36 +++++++++++++++++----------------
 include/asm-x86_64/hpet.h    |    1 
 4 files changed, 26 insertions(+), 34 deletions(-)

diff -puN arch/i386/kernel/acpi/boot.c~time-x86_64-hpet_address-cleanup arch/i386/kernel/acpi/boot.c
--- a/arch/i386/kernel/acpi/boot.c~time-x86_64-hpet_address-cleanup
+++ a/arch/i386/kernel/acpi/boot.c
@@ -616,6 +616,7 @@ static int __init acpi_parse_sbf(struct 
 }
 
 #ifdef CONFIG_HPET_TIMER
+#include <asm/hpet.h>
 
 static int __init acpi_parse_hpet(struct acpi_table_header *table)
 {
@@ -646,24 +647,11 @@ static int __init acpi_parse_hpet(struct
 		hpet_res->end = (1 * 1024) - 1;
 	}
 
-#ifdef CONFIG_X86_64
-	vxtime.hpet_address = hpet_tbl->address.address;
-
+	hpet_address = hpet_tbl->address.address;
 	printk(KERN_INFO PREFIX "HPET id: %#x base: %#lx\n",
-		hpet_tbl->id, vxtime.hpet_address);
-
-	res_start = vxtime.hpet_address;
-#else                          /* X86 */
-	{
-		extern unsigned long hpet_address;
+	       hpet_tbl->id, hpet_address);
 
-		hpet_address = hpet_tbl->address.address;
-		printk(KERN_INFO PREFIX "HPET id: %#x base: %#lx\n",
-			hpet_tbl->id, hpet_address);
-
-		res_start = hpet_address;
-	}
-#endif                         /* X86 */
+	res_start = hpet_address;
 
 	if (hpet_res) {
 		hpet_res->start = res_start;
diff -puN arch/x86_64/kernel/apic.c~time-x86_64-hpet_address-cleanup arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~time-x86_64-hpet_address-cleanup
+++ a/arch/x86_64/kernel/apic.c
@@ -37,6 +37,7 @@
 #include <asm/idle.h>
 #include <asm/proto.h>
 #include <asm/timex.h>
+#include <asm/hpet.h>
 #include <asm/apic.h>
 
 int apic_mapped;
@@ -763,7 +764,7 @@ static void setup_APIC_timer(unsigned in
 	local_irq_save(flags);
 
 	/* wait for irq slice */
- 	if (vxtime.hpet_address && hpet_use_timer) {
+ 	if (hpet_address && hpet_use_timer) {
  		int trigger = hpet_readl(HPET_T0_CMP);
  		while (hpet_readl(HPET_COUNTER) >= trigger)
  			/* do nothing */ ;
diff -puN arch/x86_64/kernel/time.c~time-x86_64-hpet_address-cleanup arch/x86_64/kernel/time.c
--- a/arch/x86_64/kernel/time.c~time-x86_64-hpet_address-cleanup
+++ a/arch/x86_64/kernel/time.c
@@ -67,6 +67,7 @@ static int notsc __initdata = 0;
 
 unsigned int cpu_khz;					/* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
+unsigned long hpet_address;
 static unsigned long hpet_period;			/* fsecs / HPET clock */
 unsigned long hpet_tick;				/* HPET clocks / interrupt */
 int hpet_use_timer;				/* Use counter of hpet for time keeping, otherwise PIT */
@@ -316,7 +317,7 @@ static noinline void handle_lost_ticks(i
 		       KERN_WARNING "Your time source seems to be instable or "
 		   		"some driver is hogging interupts\n");
 		print_symbol("rip %s\n", get_irq_regs()->rip);
-		if (vxtime.mode == VXTIME_TSC && vxtime.hpet_address) {
+		if (vxtime.mode == VXTIME_TSC && hpet_address) {
 			printk(KERN_WARNING "Falling back to HPET\n");
 			if (hpet_use_timer)
 				vxtime.last = hpet_readl(HPET_T0_CMP) - 
@@ -324,6 +325,7 @@ static noinline void handle_lost_ticks(i
 			else
 				vxtime.last = hpet_readl(HPET_COUNTER);
 			vxtime.mode = VXTIME_HPET;
+			vxtime.hpet_address = hpet_address;
 			do_gettimeoffset = do_gettimeoffset_hpet;
 		}
 		/* else should fall back to PIT, but code missing. */
@@ -354,7 +356,7 @@ void main_timer_handler(void)
 
 	write_seqlock(&xtime_lock);
 
-	if (vxtime.hpet_address)
+	if (hpet_address)
 		offset = hpet_readl(HPET_COUNTER);
 
 	if (hpet_use_timer) {
@@ -739,7 +741,7 @@ static __init int late_hpet_init(void)
 	struct hpet_data	hd;
 	unsigned int 		ntimer;
 
-	if (!vxtime.hpet_address)
+	if (!hpet_address)
         	return 0;
 
 	memset(&hd, 0, sizeof (hd));
@@ -752,7 +754,7 @@ static __init int late_hpet_init(void)
 	 * Register with driver.
 	 * Timer0 and Timer1 is used by platform.
 	 */
-	hd.hd_phys_address = vxtime.hpet_address;
+	hd.hd_phys_address = hpet_address;
 	hd.hd_address = (void __iomem *)fix_to_virt(FIX_HPET_BASE);
 	hd.hd_nirqs = ntimer;
 	hd.hd_flags = HPET_DATA_PLATFORM;
@@ -821,10 +823,10 @@ static int hpet_init(void)
 {
 	unsigned int id;
 
-	if (!vxtime.hpet_address)
+	if (!hpet_address)
 		return -1;
-	set_fixmap_nocache(FIX_HPET_BASE, vxtime.hpet_address);
-	__set_fixmap(VSYSCALL_HPET, vxtime.hpet_address, PAGE_KERNEL_VSYSCALL_NOCACHE);
+	set_fixmap_nocache(FIX_HPET_BASE, hpet_address);
+	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VSYSCALL_NOCACHE);
 
 /*
  * Read the period, compute tick and quotient.
@@ -878,7 +880,7 @@ void __init pit_stop_interrupt(void)
 void __init stop_timer_interrupt(void)
 {
 	char *name;
-	if (vxtime.hpet_address) {
+	if (hpet_address) {
 		name = "HPET";
 		hpet_timer_stop_set_go(0);
 	} else {
@@ -901,8 +903,7 @@ static struct irqaction irq0 = {
 void __init time_init(void)
 {
 	if (nohpet)
-		vxtime.hpet_address = 0;
-
+		hpet_address = 0;
 	xtime.tv_sec = get_cmos_time();
 	xtime.tv_nsec = 0;
 
@@ -912,7 +913,7 @@ void __init time_init(void)
 	if (!hpet_init())
                 vxtime_hz = (FSEC_PER_SEC + hpet_period / 2) / hpet_period;
 	else
-		vxtime.hpet_address = 0;
+		hpet_address = 0;
 
 	if (hpet_use_timer) {
 		/* set tick_nsec to use the proper rate for HPET */
@@ -920,7 +921,7 @@ void __init time_init(void)
 		cpu_khz = hpet_calibrate_tsc();
 		timename = "HPET";
 #ifdef CONFIG_X86_PM_TIMER
-	} else if (pmtmr_ioport && !vxtime.hpet_address) {
+	} else if (pmtmr_ioport && !hpet_address) {
 		vxtime_hz = PM_TIMER_FREQUENCY;
 		timename = "PM";
 		pit_init();
@@ -990,23 +991,24 @@ void time_init_gtod(void)
 	if (unsynchronized_tsc())
 		notsc = 1;
 
- 	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
+	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
 		vgetcpu_mode = VGETCPU_RDTSCP;
 	else
 		vgetcpu_mode = VGETCPU_LSL;
 
-	if (vxtime.hpet_address && notsc) {
+	if (hpet_address && notsc) {
 		timetype = hpet_use_timer ? "HPET" : "PIT/HPET";
 		if (hpet_use_timer)
 			vxtime.last = hpet_readl(HPET_T0_CMP) - hpet_tick;
 		else
 			vxtime.last = hpet_readl(HPET_COUNTER);
 		vxtime.mode = VXTIME_HPET;
+		vxtime.hpet_address = hpet_address;
 		do_gettimeoffset = do_gettimeoffset_hpet;
 #ifdef CONFIG_X86_PM_TIMER
 	/* Using PM for gettimeofday is quite slow, but we have no other
 	   choice because the TSC is too unreliable on some systems. */
-	} else if (pmtmr_ioport && !vxtime.hpet_address && notsc) {
+	} else if (pmtmr_ioport && !hpet_address && notsc) {
 		timetype = "PM";
 		do_gettimeoffset = do_gettimeoffset_pm;
 		vxtime.mode = VXTIME_PMTMR;
@@ -1066,7 +1068,7 @@ static int timer_resume(struct sys_devic
 		sleep_length = 0;
 		ctime = sleep_start;
 	}
-	if (vxtime.hpet_address)
+	if (hpet_address)
 		hpet_reenable();
 	else
 		i8254_timer_resume();
@@ -1150,7 +1152,7 @@ static unsigned int hpet_t1_cmp; /* cach
 
 int is_hpet_enabled(void)
 {
-	return vxtime.hpet_address != 0;
+	return hpet_address != 0;
 }
 
 /*
diff -puN include/asm-x86_64/hpet.h~time-x86_64-hpet_address-cleanup include/asm-x86_64/hpet.h
--- a/include/asm-x86_64/hpet.h~time-x86_64-hpet_address-cleanup
+++ a/include/asm-x86_64/hpet.h
@@ -58,6 +58,7 @@ extern int hpet_rtc_timer_init(void);
 extern int apic_is_clustered_box(void);
 
 extern int hpet_use_timer;
+extern unsigned long hpet_address;
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 extern int hpet_mask_rtc_irq_bit(unsigned long bit_mask);
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
git-acpi.patch
profile-likely-unlikely-macros-x86_64-fix.patch
