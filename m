From: akpm@osdl.org
Subject: + arm-convert-to-use-shared-apm-emulation.patch added to -mm tree
Date: Wed, 24 Jan 2007 23:42:10 -0800
Message-ID: <200701250742.l0P7gAgN009414@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52476 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbXAYHpl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 02:45:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, lethal@linux-sh.org, rmk@arm.linux.org.uk


The patch titled
     ARM: convert to use shared APM emulation
has been added to the -mm tree.  Its filename is
     arm-convert-to-use-shared-apm-emulation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ARM: convert to use shared APM emulation
From: Ralf Baechle <ralf@linux-mips.org>

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/arm/Kconfig               |   29 +-------------
 arch/arm/common/sharpsl_pm.c   |    2 
 arch/arm/kernel/Makefile       |    1 
 arch/arm/mach-pxa/corgi_pm.c   |    2 
 arch/arm/mach-pxa/sharpsl_pm.c |    2 
 arch/arm/mach-pxa/spitz_pm.c   |    2 
 include/asm-arm/apm.h          |   64 -------------------------------
 7 files changed, 8 insertions(+), 94 deletions(-)

diff -puN arch/arm/Kconfig~arm-convert-to-use-shared-apm-emulation arch/arm/Kconfig
--- a/arch/arm/Kconfig~arm-convert-to-use-shared-apm-emulation
+++ a/arch/arm/Kconfig
@@ -9,6 +9,7 @@ config ARM
 	bool
 	default y
 	select RTC_LIB
+	select SYS_SUPPORTS_APM_EMULATION
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
@@ -17,6 +18,9 @@ config ARM
 	  Europe.  There is an ARM Linux project with a web page at
 	  <http://www.arm.linux.org.uk/>.
 
+config SYS_SUPPORTS_APM_EMULATION
+	bool
+
 config GENERIC_TIME
 	bool
 	default n
@@ -860,31 +864,6 @@ menu "Power management options"
 
 source "kernel/power/Kconfig"
 
-config APM
-	tristate "Advanced Power Management Emulation"
-	---help---
-	  APM is a BIOS specification for saving power using several different
-	  techniques. This is mostly useful for battery powered laptops with
-	  APM compliant BIOSes. If you say Y here, the system time will be
-	  reset after a RESUME operation, the /proc/apm device will provide
-	  battery status information, and user-space programs will receive
-	  notification of APM "events" (e.g. battery status change).
-
-	  In order to use APM, you will need supporting software. For location
-	  and more information, read <file:Documentation/pm.txt> and the
-	  Battery Powered Linux mini-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
-
-	  This driver does not spin down disk drives (see the hdparm(8)
-	  manpage ("man 8 hdparm") for that), and it doesn't turn off
-	  VESA-compliant "green" monitors.
-
-	  Generally, if you don't have a battery in your machine, there isn't
-	  much point in using this driver and you should say N. If you get
-	  random kernel OOPSes or reboots that don't seem to be related to
-	  anything, try disabling/enabling this option (or disabling/enabling
-	  APM in your BIOS).
-
 endmenu
 
 source "net/Kconfig"
diff -puN arch/arm/common/sharpsl_pm.c~arm-convert-to-use-shared-apm-emulation arch/arm/common/sharpsl_pm.c
--- a/arch/arm/common/sharpsl_pm.c~arm-convert-to-use-shared-apm-emulation
+++ a/arch/arm/common/sharpsl_pm.c
@@ -27,7 +27,7 @@
 #include <asm/hardware.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
-#include <asm/apm.h>
+#include <asm/apm-emulation.h>
 #include <asm/arch/pm.h>
 #include <asm/arch/pxa-regs.h>
 #include <asm/arch/sharpsl.h>
diff -puN arch/arm/kernel/Makefile~arm-convert-to-use-shared-apm-emulation arch/arm/kernel/Makefile
--- a/arch/arm/kernel/Makefile~arm-convert-to-use-shared-apm-emulation
+++ a/arch/arm/kernel/Makefile
@@ -10,7 +10,6 @@ obj-y		:= compat.o entry-armv.o entry-co
 		   process.o ptrace.o semaphore.o setup.o signal.o sys_arm.o \
 		   time.o traps.o
 
-obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_ISA_DMA_API)	+= dma.o
 obj-$(CONFIG_ARCH_ACORN)	+= ecard.o 
 obj-$(CONFIG_FIQ)		+= fiq.o
diff -puN arch/arm/mach-pxa/corgi_pm.c~arm-convert-to-use-shared-apm-emulation arch/arm/mach-pxa/corgi_pm.c
--- a/arch/arm/mach-pxa/corgi_pm.c~arm-convert-to-use-shared-apm-emulation
+++ a/arch/arm/mach-pxa/corgi_pm.c
@@ -16,7 +16,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
-#include <asm/apm.h>
+#include <asm/apm-emulation.h>
 #include <asm/irq.h>
 #include <asm/mach-types.h>
 #include <asm/hardware.h>
diff -puN arch/arm/mach-pxa/sharpsl_pm.c~arm-convert-to-use-shared-apm-emulation arch/arm/mach-pxa/sharpsl_pm.c
--- a/arch/arm/mach-pxa/sharpsl_pm.c~arm-convert-to-use-shared-apm-emulation
+++ a/arch/arm/mach-pxa/sharpsl_pm.c
@@ -23,7 +23,7 @@
 
 #include <asm/hardware.h>
 #include <asm/mach-types.h>
-#include <asm/apm.h>
+#include <asm/apm-emulation.h>
 #include <asm/arch/pm.h>
 #include <asm/arch/pxa-regs.h>
 #include <asm/arch/sharpsl.h>
diff -puN arch/arm/mach-pxa/spitz_pm.c~arm-convert-to-use-shared-apm-emulation arch/arm/mach-pxa/spitz_pm.c
--- a/arch/arm/mach-pxa/spitz_pm.c~arm-convert-to-use-shared-apm-emulation
+++ a/arch/arm/mach-pxa/spitz_pm.c
@@ -16,7 +16,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
-#include <asm/apm.h>
+#include <asm/apm-emulation.h>
 #include <asm/irq.h>
 #include <asm/mach-types.h>
 #include <asm/hardware.h>
diff -puN include/asm-arm/apm.h~arm-convert-to-use-shared-apm-emulation /dev/null
--- a/include/asm-arm/apm.h
+++ /dev/null
@@ -1,64 +0,0 @@
-/* -*- linux-c -*-
- *
- * (C) 2003 zecke@handhelds.org
- *
- * GPL version 2
- *
- * based on arch/arm/kernel/apm.c
- * factor out the information needed by architectures to provide
- * apm status
- *
- *
- */
-#ifndef ARM_ASM_SA1100_APM_H
-#define ARM_ASM_SA1100_APM_H
-
-#include <linux/apm_bios.h>
-
-/*
- * This structure gets filled in by the machine specific 'get_power_status'
- * implementation.  Any fields which are not set default to a safe value.
- */
-struct apm_power_info {
-	unsigned char	ac_line_status;
-#define APM_AC_OFFLINE			0
-#define APM_AC_ONLINE			1
-#define APM_AC_BACKUP			2
-#define APM_AC_UNKNOWN			0xff
-
-	unsigned char	battery_status;
-#define APM_BATTERY_STATUS_HIGH		0
-#define APM_BATTERY_STATUS_LOW		1
-#define APM_BATTERY_STATUS_CRITICAL	2
-#define APM_BATTERY_STATUS_CHARGING	3
-#define APM_BATTERY_STATUS_NOT_PRESENT	4
-#define APM_BATTERY_STATUS_UNKNOWN	0xff
-
-	unsigned char	battery_flag;
-#define APM_BATTERY_FLAG_HIGH		(1 << 0)
-#define APM_BATTERY_FLAG_LOW		(1 << 1)
-#define APM_BATTERY_FLAG_CRITICAL	(1 << 2)
-#define APM_BATTERY_FLAG_CHARGING	(1 << 3)
-#define APM_BATTERY_FLAG_NOT_PRESENT	(1 << 7)
-#define APM_BATTERY_FLAG_UNKNOWN	0xff
-
-	int		battery_life;
-	int		time;
-	int		units;
-#define APM_UNITS_MINS			0
-#define APM_UNITS_SECS			1
-#define APM_UNITS_UNKNOWN		-1
-
-};
-
-/*
- * This allows machines to provide their own "apm get power status" function.
- */
-extern void (*apm_get_power_status)(struct apm_power_info *);
-
-/*
- * Queue an event (APM_SYS_SUSPEND or APM_CRITICAL_SUSPEND)
- */
-void apm_queue_event(apm_event_t event);
-
-#endif
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
git-dvb.patch
git-mips.patch
mips-dbg_io-stray-brackets-fix.patch
mips-turbochannel-update-to-the-driver-model.patch
mips-turbochannel-update-to-the-driver-model-fix.patch
mips-turbochannel-support-for-the-decstation.patch
mips-eisa-registration-with-config_eisa.patch
mips-declance-driver-model-for-the-pmad-a.patch
mips-defxx-turbochannel-support.patch
mips-pmag-ba-fb-convert-to-the-driver-model.patch
mips-pmagb-b-fb-convert-to-the-driver-model.patch
mips-dec_esp-driver-model-for-the-pmaz-a.patch
mips-remove-smp_tune_scheduling.patch
fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
make-cardbus_mem_size-and-cardbus_io_size-boot-options.patch
make-cardbus_mem_size-and-cardbus_io_size-boot-options-fix.patch
xfs-remove-useless-wmb-memory-barrier.patch
ioc3-ioc4-pci-mem-space-resources.patch
proc-remove-useless-and-buggy-nlink-settings.patch
simplify-the-stacktrace-code.patch
extend-the-set-of-__attribute__-shortcut-macros.patch
add-shared-version-of-apm-emulation.patch
arm-convert-to-use-shared-apm-emulation.patch
mips-convert-to-use-shared-apm-emulation.patch
clocksource-fixup-is_continous-changes-on-mips.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-mips.patch
dynamic-kernel-command-line-parisc.patch
cyber2010-framebuffer-on-arm-netwinder-fix.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
sysctl-x25-remove-unnecessary-insert_at_head-from-register_sysctl_table.patch
sysctl-rose-remove-unnecessary-insert_at_head-flag.patch
sysctl-netrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-ax25-remove-unnecessary-insert_at_head-flag.patch
sysctl-mips-au1000-remove-sys_sysctl-support.patch
sysctl-c99-convert-the-ctl_tables-in-arch-mips-au1000-common-powerc.patch
sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage.patch
sysctl-remove-sys_sysctl-support-from-drivers-char-rtcc.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
