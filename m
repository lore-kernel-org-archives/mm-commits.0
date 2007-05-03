From: akpm@linux-foundation.org
Subject: - power-management-implement-pm_opsvalid-for-everybody.patch removed from -mm tree
Date: Thu, 03 May 2007 12:30:23 -0700
Message-ID: <200705031930.l43JUNVk018183@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767906AbXECTed (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:34:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, david-b@pacbell.net, greg@kroah.com, lenb@kernel.org, lethal@linux-sh.org, pavel@ucw.cz, rjw@sisk.pl, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     power management: implement pm_ops.valid for everybody
has been removed from the -mm tree.  Its filename was
     power-management-implement-pm_opsvalid-for-everybody.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: power management: implement pm_ops.valid for everybody
From: Johannes Berg <johannes@sipsolutions.net>

Almost all users of pm_ops only support mem sleep, don't check in .valid and
don't reject any others in .prepare so users can be confused if they check
/sys/power/state, especially when new states are added (these would then
result in s-t-r although they're supposed to be something different).

This patch implements a generic pm_valid_only_mem function that is then
exported for users and puts it to use in almost all existing pm_ops.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: David Brownell <david-b@pacbell.net>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: linux-pm@lists.linux-foundation.org
Cc: Len Brown <lenb@kernel.org>
Acked-by: Russell King <rmk@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/common/sharpsl_pm.c |    1 
 arch/arm/mach-omap1/pm.c     |    1 
 arch/arm/mach-omap2/pm.c     |    1 
 arch/arm/mach-pnx4008/pm.c   |   39 +++------------------------------
 arch/arm/mach-pxa/pm.c       |    1 
 arch/arm/mach-sa1100/pm.c    |    1 
 arch/arm/plat-s3c24xx/pm.c   |   19 ----------------
 arch/sh/boards/hp6xx/pm.c    |    1 
 drivers/acpi/sleep/main.c    |   13 +++++++++--
 include/linux/pm.h           |    4 +++
 kernel/power/main.c          |   13 +++++++++++
 11 files changed, 39 insertions(+), 55 deletions(-)

diff -puN arch/arm/common/sharpsl_pm.c~power-management-implement-pm_opsvalid-for-everybody arch/arm/common/sharpsl_pm.c
--- a/arch/arm/common/sharpsl_pm.c~power-management-implement-pm_opsvalid-for-everybody
+++ a/arch/arm/common/sharpsl_pm.c
@@ -769,6 +769,7 @@ static struct pm_ops sharpsl_pm_ops = {
 	.prepare	= pxa_pm_prepare,
 	.enter		= corgi_pxa_pm_enter,
 	.finish		= pxa_pm_finish,
+	.valid		= pm_valid_only_mem,
 };
 
 static int __init sharpsl_pm_probe(struct platform_device *pdev)
diff -puN arch/arm/mach-omap1/pm.c~power-management-implement-pm_opsvalid-for-everybody arch/arm/mach-omap1/pm.c
--- a/arch/arm/mach-omap1/pm.c~power-management-implement-pm_opsvalid-for-everybody
+++ a/arch/arm/mach-omap1/pm.c
@@ -701,6 +701,7 @@ static struct pm_ops omap_pm_ops ={
 	.prepare	= omap_pm_prepare,
 	.enter		= omap_pm_enter,
 	.finish		= omap_pm_finish,
+	.valid		= pm_valid_only_mem,
 };
 
 static int __init omap_pm_init(void)
diff -puN arch/arm/mach-omap2/pm.c~power-management-implement-pm_opsvalid-for-everybody arch/arm/mach-omap2/pm.c
--- a/arch/arm/mach-omap2/pm.c~power-management-implement-pm_opsvalid-for-everybody
+++ a/arch/arm/mach-omap2/pm.c
@@ -373,6 +373,7 @@ static struct pm_ops omap_pm_ops = {
 	.prepare	= omap2_pm_prepare,
 	.enter		= omap2_pm_enter,
 	.finish		= omap2_pm_finish,
+	.valid		= pm_valid_only_mem,
 };
 
 int __init omap2_pm_init(void)
diff -puN arch/arm/mach-pnx4008/pm.c~power-management-implement-pm_opsvalid-for-everybody arch/arm/mach-pnx4008/pm.c
--- a/arch/arm/mach-pnx4008/pm.c~power-management-implement-pm_opsvalid-for-everybody
+++ a/arch/arm/mach-pnx4008/pm.c
@@ -107,50 +107,19 @@ static int pnx4008_pm_enter(suspend_stat
 	case PM_SUSPEND_MEM:
 		pnx4008_suspend();
 		break;
-	case PM_SUSPEND_DISK:
-		return -ENOTSUPP;
-	default:
-		return -EINVAL;
 	}
 	return 0;
 }
 
-/*
- * Called after processes are frozen, but before we shut down devices.
- */
-static int pnx4008_pm_prepare(suspend_state_t state)
+static int pnx4008_pm_valid(suspend_state_t state)
 {
-	switch (state) {
-	case PM_SUSPEND_STANDBY:
-	case PM_SUSPEND_MEM:
-		break;
-
-	case PM_SUSPEND_DISK:
-		return -ENOTSUPP;
-		break;
-
-	default:
-		return -EINVAL;
-		break;
-	}
-	return 0;
-}
-
-/*
- * Called after devices are re-setup, but before processes are thawed.
- */
-static int pnx4008_pm_finish(suspend_state_t state)
-{
-	return 0;
+	return (state == PM_SUSPEND_STANDBY) ||
+	       (state == PM_SUSPEND_MEM);
 }
 
-/*
- * Set to PM_DISK_FIRMWARE so we can quickly veto suspend-to-disk.
- */
 static struct pm_ops pnx4008_pm_ops = {
-	.prepare = pnx4008_pm_prepare,
 	.enter = pnx4008_pm_enter,
-	.finish = pnx4008_pm_finish,
+	.valid = pnx4008_pm_valid,
 };
 
 static int __init pnx4008_pm_init(void)
diff -puN arch/arm/mach-pxa/pm.c~power-management-implement-pm_opsvalid-for-everybody arch/arm/mach-pxa/pm.c
--- a/arch/arm/mach-pxa/pm.c~power-management-implement-pm_opsvalid-for-everybody
+++ a/arch/arm/mach-pxa/pm.c
@@ -227,6 +227,7 @@ static struct pm_ops pxa_pm_ops = {
 	.prepare	= pxa_pm_prepare,
 	.enter		= pxa_pm_enter,
 	.finish		= pxa_pm_finish,
+	.valid		= pm_valid_only_mem,
 };
 
 static int __init pxa_pm_init(void)
diff -puN arch/arm/mach-sa1100/pm.c~power-management-implement-pm_opsvalid-for-everybody arch/arm/mach-sa1100/pm.c
--- a/arch/arm/mach-sa1100/pm.c~power-management-implement-pm_opsvalid-for-everybody
+++ a/arch/arm/mach-sa1100/pm.c
@@ -133,6 +133,7 @@ unsigned long sleep_phys_sp(void *sp)
 
 static struct pm_ops sa11x0_pm_ops = {
 	.enter		= sa11x0_pm_enter,
+	.valid		= pm_valid_only_mem,
 };
 
 static int __init sa11x0_pm_init(void)
diff -puN arch/arm/plat-s3c24xx/pm.c~power-management-implement-pm_opsvalid-for-everybody arch/arm/plat-s3c24xx/pm.c
--- a/arch/arm/plat-s3c24xx/pm.c~power-management-implement-pm_opsvalid-for-everybody
+++ a/arch/arm/plat-s3c24xx/pm.c
@@ -612,26 +612,9 @@ static int s3c2410_pm_enter(suspend_stat
 	return 0;
 }
 
-/*
- * Called after processes are frozen, but before we shut down devices.
- */
-static int s3c2410_pm_prepare(suspend_state_t state)
-{
-	return 0;
-}
-
-/*
- * Called after devices are re-setup, but before processes are thawed.
- */
-static int s3c2410_pm_finish(suspend_state_t state)
-{
-	return 0;
-}
-
 static struct pm_ops s3c2410_pm_ops = {
-	.prepare	= s3c2410_pm_prepare,
 	.enter		= s3c2410_pm_enter,
-	.finish		= s3c2410_pm_finish,
+	.valid		= pm_valid_only_mem,
 };
 
 /* s3c2410_pm_init
diff -puN arch/sh/boards/hp6xx/pm.c~power-management-implement-pm_opsvalid-for-everybody arch/sh/boards/hp6xx/pm.c
--- a/arch/sh/boards/hp6xx/pm.c~power-management-implement-pm_opsvalid-for-everybody
+++ a/arch/sh/boards/hp6xx/pm.c
@@ -69,6 +69,7 @@ static int hp6x0_pm_enter(suspend_state_
 
 static struct pm_ops hp6x0_pm_ops = {
 	.enter		= hp6x0_pm_enter,
+	.valid		= pm_valid_only_mem,
 };
 
 static int __init hp6x0_pm_init(void)
diff -puN drivers/acpi/sleep/main.c~power-management-implement-pm_opsvalid-for-everybody drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~power-management-implement-pm_opsvalid-for-everybody
+++ a/drivers/acpi/sleep/main.c
@@ -168,9 +168,18 @@ int acpi_suspend(u32 acpi_state)
 
 static int acpi_pm_state_valid(suspend_state_t pm_state)
 {
-	u32 acpi_state = acpi_suspend_states[pm_state];
+	u32 acpi_state;
 
-	return sleep_states[acpi_state];
+	switch (pm_state) {
+	case PM_SUSPEND_ON:
+	case PM_SUSPEND_STANDBY:
+	case PM_SUSPEND_MEM:
+		acpi_state = acpi_suspend_states[pm_state];
+
+		return sleep_states[acpi_state];
+	default:
+		return 0;
+	}
 }
 
 static struct pm_ops acpi_pm_ops = {
diff -puN include/linux/pm.h~power-management-implement-pm_opsvalid-for-everybody include/linux/pm.h
--- a/include/linux/pm.h~power-management-implement-pm_opsvalid-for-everybody
+++ a/include/linux/pm.h
@@ -128,6 +128,9 @@ typedef int __bitwise suspend_disk_metho
  *	always valid and never passed to this call.
  *	If not assigned, all suspend states are advertised as valid
  *	in /sys/power/state (but can still be rejected by prepare or enter.)
+ *	Since new states can be added for other platforms, you should
+ *	assign this callback. There is a %pm_valid_only_mem function
+ *	available if you only implemented mem sleep.
  *
  * @prepare: Prepare the platform for the given suspend state. Can return a
  *	negative error code if necessary.
@@ -165,6 +168,7 @@ extern void pm_set_ops(struct pm_ops *pm
 extern struct pm_ops *pm_ops;
 extern int pm_suspend(suspend_state_t state);
 
+extern int pm_valid_only_mem(suspend_state_t state);
 
 /**
  * arch_suspend_disable_irqs - disable IRQs for suspend
diff -puN kernel/power/main.c~power-management-implement-pm_opsvalid-for-everybody kernel/power/main.c
--- a/kernel/power/main.c~power-management-implement-pm_opsvalid-for-everybody
+++ a/kernel/power/main.c
@@ -48,6 +48,19 @@ void pm_set_ops(struct pm_ops * ops)
 	mutex_unlock(&pm_mutex);
 }
 
+/**
+ * pm_valid_only_mem - generic memory-only valid callback
+ *
+ * pm_ops drivers that implement mem suspend only and only need
+ * to check for that in their .valid callback can use this instead
+ * of rolling their own .valid callback.
+ */
+int pm_valid_only_mem(suspend_state_t state)
+{
+	return state == PM_SUSPEND_MEM;
+}
+
+
 static inline void pm_finish(suspend_state_t state)
 {
 	if (pm_ops->finish)
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
remove-software_suspend.patch
power-management-change-sys-power-disk-display.patch
git-alsa.patch
git-powerpc.patch
power-management-remove-some-useless-code-from-arm.patch
git-wireless.patch
fix-sscanf-%n-match-at-end-of-input-string.patch
kernel-doc-html-mode-struct-highlights.patch
