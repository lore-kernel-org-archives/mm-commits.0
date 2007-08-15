From: akpm@linux-foundation.org
Subject: - x86_64-efi-runtime-service-support-efi-runtime-services.patch removed from -mm tree
Date: Wed, 15 Aug 2007 16:17:50 -0700
Message-ID: <200708152317.l7FNHoZd020119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53220 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934060AbXHOXSN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 19:18:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, adurbin@google.com, ak@suse.de, mouli@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     x86_64 EFI runtime service support: EFI runtime services
has been removed from the -mm tree.  Its filename was
     x86_64-efi-runtime-service-support-efi-runtime-services.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: x86_64 EFI runtime service support: EFI runtime services
From: "Huang, Ying" <ying.huang@intel.com>

Add support for several EFI runtime services for EFI x86_64 system.

The EFI support for emergency_restart and RTC clock is added.  The EFI based
implementation and legacy BIOS or CMOS based implementation are put in
separate functions and can be chosen with kernel boot options.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Aaron Durbin <adurbin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/reboot.c            |   23 +++++++----
 arch/x86_64/kernel/time.c              |   48 +++++++++++++++--------
 include/asm-x86_64/emergency-restart.h |    9 ++++
 include/asm-x86_64/time.h              |    7 +++
 4 files changed, 63 insertions(+), 24 deletions(-)

diff -puN arch/x86_64/kernel/reboot.c~x86_64-efi-runtime-service-support-efi-runtime-services arch/x86_64/kernel/reboot.c
--- a/arch/x86_64/kernel/reboot.c~x86_64-efi-runtime-service-support-efi-runtime-services
+++ a/arch/x86_64/kernel/reboot.c
@@ -9,6 +9,8 @@
 #include <linux/pm.h>
 #include <linux/kdebug.h>
 #include <linux/sched.h>
+#include <linux/efi.h>
+
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/delay.h>
@@ -27,19 +29,16 @@ void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
 static long no_idt[3];
-static enum { 
-	BOOT_TRIPLE = 't',
-	BOOT_KBD = 'k',
-	BOOT_ACPI = 'a'
-} reboot_type = BOOT_KBD;
-static int reboot_mode = 0;
+enum reboot_type reboot_type = BOOT_KBD;
+static int reboot_mode;
 int reboot_force;
 
-/* reboot=t[riple] | k[bd] [, [w]arm | [c]old]
+/* reboot=t[riple] | k[bd] | e[fi] | a[cpi] | [, [w]arm | [c]old]
    warm   Don't set the cold reboot flag
    cold   Set the cold reboot flag
    triple Force a triple fault (init)
    kbd    Use the keyboard controller. cold reset (default)
+   efi    Use efi reset_system runtime service. cold reset (default)
    acpi   Use the RESET_REG in the FADT
    force  Avoid anything that could hang.
  */ 
@@ -59,6 +58,7 @@ static int __init reboot_setup(char *str
 		case 'a':
 		case 'b':
 		case 'k':
+		case 'e':
 			reboot_type = *str;
 			break;
 		case 'f':
@@ -151,7 +151,14 @@ void machine_emergency_restart(void)
 			acpi_reboot();
 			reboot_type = BOOT_KBD;
 			break;
-		}      
+
+		case BOOT_EFI:
+			if (efi_enabled)
+				efi.reset_system(reboot_mode ? EFI_RESET_WARM : EFI_RESET_COLD,
+						 EFI_SUCCESS, 0, NULL);
+			reboot_type = BOOT_KBD;
+			break;
+		}
 	}      
 }
 
diff -puN arch/x86_64/kernel/time.c~x86_64-efi-runtime-service-support-efi-runtime-services arch/x86_64/kernel/time.c
--- a/arch/x86_64/kernel/time.c~x86_64-efi-runtime-service-support-efi-runtime-services
+++ a/arch/x86_64/kernel/time.c
@@ -27,6 +27,7 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/kallsyms.h>
+#include <linux/efi.h>
 #include <linux/acpi.h>
 #ifdef CONFIG_ACPI
 #include <acpi/achware.h>	/* for PM timer frequency */
@@ -46,6 +47,7 @@
 #include <asm/mpspec.h>
 #include <asm/nmi.h>
 #include <asm/vgtod.h>
+#include <asm/time.h>
 
 static char *timename = NULL;
 
@@ -56,6 +58,12 @@ EXPORT_SYMBOL(i8253_lock);
 
 volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
 
+static int set_rtc_mmss(unsigned long nowtime);
+static unsigned long read_cmos_clock(void);
+
+unsigned long (*get_wallclock)(void) = read_cmos_clock;
+int (*set_wallclock)(unsigned long nowtime) = set_rtc_mmss;
+
 unsigned long profile_pc(struct pt_regs *regs)
 {
 	unsigned long pc = instruction_pointer(regs);
@@ -89,13 +97,6 @@ static int set_rtc_mmss(unsigned long no
 	unsigned char control, freq_select;
 
 /*
- * IRQs are disabled when we're called from the timer interrupt,
- * no need for spin_lock_irqsave()
- */
-
-	spin_lock(&rtc_lock);
-
-/*
  * Tell the clock it's being set and stop it.
  */
 
@@ -143,14 +144,23 @@ static int set_rtc_mmss(unsigned long no
 	CMOS_WRITE(control, RTC_CONTROL);
 	CMOS_WRITE(freq_select, RTC_FREQ_SELECT);
 
-	spin_unlock(&rtc_lock);
-
 	return retval;
 }
 
 int update_persistent_clock(struct timespec now)
 {
-	return set_rtc_mmss(now.tv_sec);
+	int retval;
+
+/*
+ * IRQs are disabled when we're called from the timer interrupt,
+ * no need for spin_lock_irqsave()
+ */
+
+	spin_lock(&rtc_lock);
+	retval = set_wallclock(now.tv_sec);
+	spin_unlock(&rtc_lock);
+
+	return retval;
 }
 
 void main_timer_handler(void)
@@ -195,14 +205,11 @@ static irqreturn_t timer_interrupt(int i
 	return IRQ_HANDLED;
 }
 
-unsigned long read_persistent_clock(void)
+static unsigned long read_cmos_clock(void)
 {
 	unsigned int year, mon, day, hour, min, sec;
-	unsigned long flags;
 	unsigned century = 0;
 
-	spin_lock_irqsave(&rtc_lock, flags);
-
 	do {
 		sec = CMOS_READ(RTC_SECONDS);
 		min = CMOS_READ(RTC_MINUTES);
@@ -217,8 +224,6 @@ unsigned long read_persistent_clock(void
 #endif
 	} while (sec != CMOS_READ(RTC_SECONDS));
 
-	spin_unlock_irqrestore(&rtc_lock, flags);
-
 	/*
 	 * We know that x86-64 always uses BCD format, no need to check the
 	 * config register.
@@ -246,6 +251,17 @@ unsigned long read_persistent_clock(void
 	return mktime(year, mon, day, hour, min, sec);
 }
 
+unsigned long read_persistent_clock(void)
+{
+	unsigned long flags, retval;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	retval = get_wallclock();
+	spin_unlock_irqrestore(&rtc_lock, flags);
+
+	return retval;
+}
+
 /* calibrate_cpu is used on systems with fixed rate TSCs to determine
  * processor frequency */
 #define TICK_COUNT 100000000
diff -puN include/asm-x86_64/emergency-restart.h~x86_64-efi-runtime-service-support-efi-runtime-services include/asm-x86_64/emergency-restart.h
--- a/include/asm-x86_64/emergency-restart.h~x86_64-efi-runtime-service-support-efi-runtime-services
+++ a/include/asm-x86_64/emergency-restart.h
@@ -1,6 +1,15 @@
 #ifndef _ASM_EMERGENCY_RESTART_H
 #define _ASM_EMERGENCY_RESTART_H
 
+enum reboot_type {
+	BOOT_TRIPLE = 't',
+	BOOT_KBD = 'k',
+	BOOT_ACPI = 'a',
+	BOOT_EFI = 'e'
+};
+
+extern enum reboot_type reboot_type;
+
 extern void machine_emergency_restart(void);
 
 #endif /* _ASM_EMERGENCY_RESTART_H */
diff -puN /dev/null include/asm-x86_64/time.h
--- /dev/null
+++ a/include/asm-x86_64/time.h
@@ -0,0 +1,7 @@
+#ifndef __ASM_X86_64_TIME_H
+#define __ASM_X86_64_TIME_H
+
+extern unsigned long (*get_wallclock)(void);
+extern int (*set_wallclock)(unsigned long nowtime);
+
+#endif
_

Patches currently in -mm which might be from ying.huang@intel.com are

x86_64-efi-runtime-service-support-efi-runtime-services.patch
x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
x86_64-efi-boot-support-efi-frame-buffer-driver.patch
x86_64-efi-boot-support-efi-boot-document.patch
