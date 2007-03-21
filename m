From: akpm@linux-foundation.org
Subject: + rework-pm_ops-pm_disk_mode-kill-misuse.patch added to -mm tree
Date: Wed, 21 Mar 2007 16:34:13 -0700
Message-ID: <200703212334.l2LNYDjj007030__30720.8403283314$1174520207$gmane$org@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58919 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbXCUXgB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 19:36:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, david-b@pacbell.net, greg@kroah.com, lenb@kernel.org, lethal@linux-sh.org, linux-pm@lists.linux-foundation.org, pavel@ucw.cz, rjw@sisk.pl, rmk@arm.linux.org.uk


The patch titled
     rework pm_ops pm_disk_mode, kill misuse
has been added to the -mm tree.  Its filename is
     rework-pm_ops-pm_disk_mode-kill-misuse.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rework pm_ops pm_disk_mode, kill misuse
From: Johannes Berg <johannes@sipsolutions.net>

The pm_ops.pm_disk_mode is used in totally bogus ways since nobody really
seems to understand what it actually does.

This patch clarifies the pm_disk_mode description.

It also removes all the arm and sh users that think they can veto suspend to
disk via pm_ops; not so since the user can always do echo shutdown >
/sys/power/disk, they need to find a better way involving Kconfig or such.

ACPI is the only user left with a non-zero pm_disk_mode.

The patch also sets the default mode to shutdown again, but when a new pm_ops
is registered its pm_disk_mode is selected as default, that way the default
stays for ACPI where it is apparently required.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: David Brownell <david-b@pacbell.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: <linux-pm@lists.linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/common/sharpsl_pm.c |    1 
 arch/arm/mach-at91/pm.c      |    1 
 arch/arm/mach-omap1/pm.c     |    1 
 arch/arm/mach-omap2/pm.c     |    1 
 arch/arm/mach-pxa/pm.c       |    4 --
 arch/arm/mach-sa1100/pm.c    |    7 ----
 arch/arm/plat-s3c24xx/pm.c   |    9 -----
 arch/sh/boards/hp6xx/pm.c    |    7 ----
 include/linux/pm.h           |   23 +++++++------
 kernel/power/disk.c          |   56 +++++++++++++++++++++------------
 kernel/power/main.c          |    6 ++-
 11 files changed, 54 insertions(+), 62 deletions(-)

diff -puN arch/arm/common/sharpsl_pm.c~rework-pm_ops-pm_disk_mode-kill-misuse arch/arm/common/sharpsl_pm.c
--- a/arch/arm/common/sharpsl_pm.c~rework-pm_ops-pm_disk_mode-kill-misuse
+++ a/arch/arm/common/sharpsl_pm.c
@@ -766,7 +766,6 @@ static void sharpsl_apm_get_power_status
 }
 
 static struct pm_ops sharpsl_pm_ops = {
-	.pm_disk_mode	= PM_DISK_FIRMWARE,
 	.prepare	= pxa_pm_prepare,
 	.enter		= corgi_pxa_pm_enter,
 	.finish		= pxa_pm_finish,
diff -puN arch/arm/mach-at91/pm.c~rework-pm_ops-pm_disk_mode-kill-misuse arch/arm/mach-at91/pm.c
--- a/arch/arm/mach-at91/pm.c~rework-pm_ops-pm_disk_mode-kill-misuse
+++ a/arch/arm/mach-at91/pm.c
@@ -201,7 +201,6 @@ error:
 
 
 static struct pm_ops at91_pm_ops ={
-	.pm_disk_mode	= 0,
 	.valid		= at91_pm_valid_state,
 	.prepare	= at91_pm_prepare,
 	.enter		= at91_pm_enter,
diff -puN arch/arm/mach-omap1/pm.c~rework-pm_ops-pm_disk_mode-kill-misuse arch/arm/mach-omap1/pm.c
--- a/arch/arm/mach-omap1/pm.c~rework-pm_ops-pm_disk_mode-kill-misuse
+++ a/arch/arm/mach-omap1/pm.c
@@ -698,7 +698,6 @@ static struct irqaction omap_wakeup_irq 
 
 
 static struct pm_ops omap_pm_ops ={
-	.pm_disk_mode	= 0,
 	.prepare	= omap_pm_prepare,
 	.enter		= omap_pm_enter,
 	.finish		= omap_pm_finish,
diff -puN arch/arm/mach-omap2/pm.c~rework-pm_ops-pm_disk_mode-kill-misuse arch/arm/mach-omap2/pm.c
--- a/arch/arm/mach-omap2/pm.c~rework-pm_ops-pm_disk_mode-kill-misuse
+++ a/arch/arm/mach-omap2/pm.c
@@ -370,7 +370,6 @@ static int omap2_pm_finish(suspend_state
 }
 
 static struct pm_ops omap_pm_ops = {
-	.pm_disk_mode	= 0,
 	.prepare	= omap2_pm_prepare,
 	.enter		= omap2_pm_enter,
 	.finish		= omap2_pm_finish,
diff -puN arch/arm/mach-pxa/pm.c~rework-pm_ops-pm_disk_mode-kill-misuse arch/arm/mach-pxa/pm.c
--- a/arch/arm/mach-pxa/pm.c~rework-pm_ops-pm_disk_mode-kill-misuse
+++ a/arch/arm/mach-pxa/pm.c
@@ -223,11 +223,7 @@ int pxa_pm_finish(suspend_state_t state)
 
 EXPORT_SYMBOL_GPL(pxa_pm_finish);
 
-/*
- * Set to PM_DISK_FIRMWARE so we can quickly veto suspend-to-disk.
- */
 static struct pm_ops pxa_pm_ops = {
-	.pm_disk_mode	= PM_DISK_FIRMWARE,
 	.prepare	= pxa_pm_prepare,
 	.enter		= pxa_pm_enter,
 	.finish		= pxa_pm_finish,
diff -puN arch/arm/mach-sa1100/pm.c~rework-pm_ops-pm_disk_mode-kill-misuse arch/arm/mach-sa1100/pm.c
--- a/arch/arm/mach-sa1100/pm.c~rework-pm_ops-pm_disk_mode-kill-misuse
+++ a/arch/arm/mach-sa1100/pm.c
@@ -59,9 +59,6 @@ static int sa11x0_pm_enter(suspend_state
 	unsigned long gpio, sleep_save[SLEEP_SAVE_SIZE];
 	struct timespec delta, rtc;
 
-	if (state != PM_SUSPEND_MEM)
-		return -EINVAL;
-
 	/* preserve current time */
 	rtc.tv_sec = RCNR;
 	rtc.tv_nsec = 0;
@@ -134,11 +131,7 @@ unsigned long sleep_phys_sp(void *sp)
 	return virt_to_phys(sp);
 }
 
-/*
- * Set to PM_DISK_FIRMWARE so we can quickly veto suspend-to-disk.
- */
 static struct pm_ops sa11x0_pm_ops = {
-	.pm_disk_mode	= PM_DISK_FIRMWARE,
 	.enter		= sa11x0_pm_enter,
 };
 
diff -puN arch/arm/plat-s3c24xx/pm.c~rework-pm_ops-pm_disk_mode-kill-misuse arch/arm/plat-s3c24xx/pm.c
--- a/arch/arm/plat-s3c24xx/pm.c~rework-pm_ops-pm_disk_mode-kill-misuse
+++ a/arch/arm/plat-s3c24xx/pm.c
@@ -511,11 +511,6 @@ static int s3c2410_pm_enter(suspend_stat
 		return -EINVAL;
 	}
 
-	if (state != PM_SUSPEND_MEM) {
-		printk(KERN_ERR PFX "error: only PM_SUSPEND_MEM supported\n");
-		return -EINVAL;
-	}
-
 	/* check if we have anything to wake-up with... bad things seem
 	 * to happen if you suspend with no wakeup (system will often
 	 * require a full power-cycle)
@@ -633,11 +628,7 @@ static int s3c2410_pm_finish(suspend_sta
 	return 0;
 }
 
-/*
- * Set to PM_DISK_FIRMWARE so we can quickly veto suspend-to-disk.
- */
 static struct pm_ops s3c2410_pm_ops = {
-	.pm_disk_mode	= PM_DISK_FIRMWARE,
 	.prepare	= s3c2410_pm_prepare,
 	.enter		= s3c2410_pm_enter,
 	.finish		= s3c2410_pm_finish,
diff -puN arch/sh/boards/hp6xx/pm.c~rework-pm_ops-pm_disk_mode-kill-misuse arch/sh/boards/hp6xx/pm.c
--- a/arch/sh/boards/hp6xx/pm.c~rework-pm_ops-pm_disk_mode-kill-misuse
+++ a/arch/sh/boards/hp6xx/pm.c
@@ -27,9 +27,6 @@ static int hp6x0_pm_enter(suspend_state_
 	u16 hd64461_stbcr;
 #endif
 
-	if (state != PM_SUSPEND_MEM)
-		return -EINVAL;
-
 #ifdef CONFIG_HD64461_ENABLER
 	outb(0, HD64461_PCC1CSCIER);
 
@@ -70,11 +67,7 @@ static int hp6x0_pm_enter(suspend_state_
 	return 0;
 }
 
-/*
- * Set to PM_DISK_FIRMWARE so we can quickly veto suspend-to-disk.
- */
 static struct pm_ops hp6x0_pm_ops = {
-	.pm_disk_mode	= PM_DISK_FIRMWARE,
 	.enter		= hp6x0_pm_enter,
 };
 
diff -puN include/linux/pm.h~rework-pm_ops-pm_disk_mode-kill-misuse include/linux/pm.h
--- a/include/linux/pm.h~rework-pm_ops-pm_disk_mode-kill-misuse
+++ a/include/linux/pm.h
@@ -112,6 +112,8 @@ typedef int __bitwise suspend_state_t;
 
 typedef int __bitwise suspend_disk_method_t;
 
+/* invalid must be 0 so struct pm_ops initialisers can leave it out */
+#define PM_DISK_INVALID		((__force suspend_disk_method_t) 0)
 #define	PM_DISK_FIRMWARE	((__force suspend_disk_method_t) 1)
 #define	PM_DISK_PLATFORM	((__force suspend_disk_method_t) 2)
 #define	PM_DISK_SHUTDOWN	((__force suspend_disk_method_t) 3)
@@ -137,17 +139,16 @@ typedef int __bitwise suspend_disk_metho
  * @finish: Called when the system has left the given state and all devices
  *	are resumed. The return value is ignored.
  *
- * @pm_disk_mode: Set to the disk method that the user should be able to
- *	configure for suspend-to-disk. Since %PM_DISK_SHUTDOWN,
- *	%PM_DISK_REBOOT, %PM_DISK_TEST and %PM_DISK_TESTPROC
- *	are always allowed, currently only %PM_DISK_PLATFORM
- *	makes sense. If the user then choses %PM_DISK_PLATFORM,
- *	the @prepare call will be called before suspending to disk
- *	(if present), the @enter call should be present and will
- *	be called after all state has been saved and the machine
- *	is ready to be shut down/suspended/..., and the @finish
- *	callback is called after state has been restored. All
- *	these calls are called with %PM_SUSPEND_DISK as the state.
+ * @pm_disk_mode: The generic code always allows one of the shutdown methods
+ *	%PM_DISK_SHUTDOWN, %PM_DISK_REBOOT, %PM_DISK_TEST and
+ *	%PM_DISK_TESTPROC. If this variable is set, the mode it is set
+ *	to is allowed in addition to those modes and is also made default.
+ *	When this mode is sent selected, the @prepare call will be called
+ *	before suspending to disk (if present), the @enter call should be
+ *	present and will be called after all state has been saved and the
+ *	machine is ready to be powered off; the @finish callback is called
+ *	after state has been restored. All these calls are called with
+ *	%PM_SUSPEND_DISK as the state.
  */
 struct pm_ops {
 	int (*valid)(suspend_state_t state);
diff -puN kernel/power/disk.c~rework-pm_ops-pm_disk_mode-kill-misuse kernel/power/disk.c
--- a/kernel/power/disk.c~rework-pm_ops-pm_disk_mode-kill-misuse
+++ a/kernel/power/disk.c
@@ -39,7 +39,13 @@ static inline int platform_prepare(void)
 {
 	int error = 0;
 
-	if (pm_disk_mode == PM_DISK_PLATFORM) {
+	switch (pm_disk_mode) {
+	case PM_DISK_TEST:
+	case PM_DISK_TESTPROC:
+	case PM_DISK_SHUTDOWN:
+	case PM_DISK_REBOOT:
+		break;
+	default:
 		if (pm_ops && pm_ops->prepare)
 			error = pm_ops->prepare(PM_SUSPEND_DISK);
 	}
@@ -48,31 +54,33 @@ static inline int platform_prepare(void)
 
 /**
  *	power_down - Shut machine down for hibernate.
- *	@mode:		Suspend-to-disk mode
  *
- *	Use the platform driver, if configured so, and return gracefully if it
- *	fails.
- *	Otherwise, try to power off and reboot. If they fail, halt the machine,
- *	there ain't no turning back.
+ *	Use the platform driver, if configured so; otherwise try
+ *	to power off or reboot.
  */
 
-static void power_down(suspend_disk_method_t mode)
+static void power_down(void)
 {
 	disable_nonboot_cpus();
-	switch(mode) {
-	case PM_DISK_PLATFORM:
-		if (pm_ops && pm_ops->enter) {
-			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
-			pm_ops->enter(PM_SUSPEND_DISK);
-			break;
-		}
+
+	switch (pm_disk_mode) {
+	case PM_DISK_TEST:
+	case PM_DISK_TESTPROC:
+		break;
 	case PM_DISK_SHUTDOWN:
 		kernel_power_off();
 		break;
 	case PM_DISK_REBOOT:
 		kernel_restart(NULL);
 		break;
+	default:
+		if (pm_ops && pm_ops->enter) {
+			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
+			pm_ops->enter(PM_SUSPEND_DISK);
+			break;
+		}
 	}
+
 	kernel_halt();
 	/* Valid image is on the disk, if we continue we risk serious data corruption
 	   after resume. */
@@ -82,7 +90,13 @@ static void power_down(suspend_disk_meth
 
 static inline void platform_finish(void)
 {
-	if (pm_disk_mode == PM_DISK_PLATFORM) {
+	switch (pm_disk_mode) {
+	case PM_DISK_TEST:
+	case PM_DISK_TESTPROC:
+	case PM_DISK_SHUTDOWN:
+	case PM_DISK_REBOOT:
+		break;
+	default:
 		if (pm_ops && pm_ops->finish)
 			pm_ops->finish(PM_SUSPEND_DISK);
 	}
@@ -177,7 +191,7 @@ int pm_suspend_disk(void)
 		pr_debug("PM: writing image.\n");
 		error = swsusp_write();
 		if (!error)
-			power_down(pm_disk_mode);
+			power_down();
 		else {
 			swsusp_free();
 			goto Thaw;
@@ -373,10 +387,14 @@ static ssize_t disk_store(struct subsyst
 		}
 	}
 	if (mode) {
-		if (mode == PM_DISK_SHUTDOWN || mode == PM_DISK_REBOOT ||
-		     mode == PM_DISK_TEST || mode == PM_DISK_TESTPROC) {
+		switch (mode) {
+		case PM_DISK_SHUTDOWN:
+		case PM_DISK_REBOOT:
+		case PM_DISK_TEST:
+		case PM_DISK_TESTPROC:
 			pm_disk_mode = mode;
-		} else {
+			break;
+		default:
 			if (pm_ops && pm_ops->enter &&
 			    (mode == pm_ops->pm_disk_mode))
 				pm_disk_mode = mode;
diff -puN kernel/power/main.c~rework-pm_ops-pm_disk_mode-kill-misuse kernel/power/main.c
--- a/kernel/power/main.c~rework-pm_ops-pm_disk_mode-kill-misuse
+++ a/kernel/power/main.c
@@ -30,7 +30,7 @@
 DEFINE_MUTEX(pm_mutex);
 
 struct pm_ops *pm_ops;
-suspend_disk_method_t pm_disk_mode = PM_DISK_PLATFORM;
+suspend_disk_method_t pm_disk_mode = PM_DISK_SHUTDOWN;
 
 /**
  *	pm_set_ops - Set the global power method table. 
@@ -41,6 +41,10 @@ void pm_set_ops(struct pm_ops * ops)
 {
 	mutex_lock(&pm_mutex);
 	pm_ops = ops;
+	if (ops && ops->pm_disk_mode != PM_DISK_INVALID) {
+		pm_disk_mode = ops->pm_disk_mode;
+	} else
+		pm_disk_mode = PM_DISK_SHUTDOWN;
 	mutex_unlock(&pm_mutex);
 }
 
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
git-alsa.patch
git-wireless.patch
hack-to-make-wireless-work.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
