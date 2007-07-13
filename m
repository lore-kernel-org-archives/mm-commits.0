From: akpm@linux-foundation.org
Subject: - pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm.patch removed from -mm tree
Date: Fri, 13 Jul 2007 15:32:28 -0700
Message-ID: <200707132232.l6DMWS7U025007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57176 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759755AbXGMWde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 18:33:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, david-b@pacbell.net, greg@kroah.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     PM: do not use saved_state from struct dev_pm_info on ARM
has been removed from the -mm tree.  Its filename was
     pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PM: do not use saved_state from struct dev_pm_info on ARM
From: Rafael J. Wysocki <rjw@sisk.pl>

The saved_state member of 'struct dev_pm_info' that's going to be removed
is used in arch/arm/common/locomo.c, arch/arm/common/sa1111.c and
arch/arm/mach-sa1100/neponset.c.  Change the code in there to use local
variables for saving the state of devices during suspend.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/common/locomo.c        |   11 ++++++++---
 arch/arm/common/sa1111.c        |   13 ++++++++-----
 arch/arm/mach-sa1100/neponset.c |   15 ++++-----------
 3 files changed, 20 insertions(+), 19 deletions(-)

diff -puN arch/arm/common/locomo.c~pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm arch/arm/common/locomo.c
--- a/arch/arm/common/locomo.c~pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm
+++ a/arch/arm/common/locomo.c
@@ -60,6 +60,9 @@ struct locomo {
 	unsigned int irq;
 	spinlock_t lock;
 	void __iomem *base;
+#ifdef CONFIG_PM
+	void *saved_state;
+#endif
 };
 
 struct locomo_dev_info {
@@ -565,7 +568,7 @@ static int locomo_suspend(struct platfor
 	if (!save)
 		return -ENOMEM;
 
-	dev->dev.power.saved_state = (void *) save;
+	lchip->saved_state = save;
 
 	spin_lock_irqsave(&lchip->lock, flags);
 
@@ -605,8 +608,8 @@ static int locomo_resume(struct platform
 	struct locomo_save_data *save;
 	unsigned long r;
 	unsigned long flags;
-	
-	save = (struct locomo_save_data *) dev->dev.power.saved_state;
+
+	save = lchip->saved_state;
 	if (!save)
 		return 0;
 
@@ -628,6 +631,8 @@ static int locomo_resume(struct platform
 	locomo_writel(0x1, lchip->base + LOCOMO_KEYBOARD + LOCOMO_KCMD);
 
 	spin_unlock_irqrestore(&lchip->lock, flags);
+
+	lchip->saved_state = NULL;
 	kfree(save);
 
 	return 0;
diff -puN arch/arm/common/sa1111.c~pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm arch/arm/common/sa1111.c
--- a/arch/arm/common/sa1111.c~pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm
+++ a/arch/arm/common/sa1111.c
@@ -51,6 +51,9 @@ struct sa1111 {
 	int		irq;
 	spinlock_t	lock;
 	void __iomem	*base;
+#ifdef CONFIG_PM
+	void		*saved_state;
+#endif
 };
 
 /*
@@ -822,7 +825,7 @@ static int sa1111_suspend(struct platfor
 	save = kmalloc(sizeof(struct sa1111_save_data), GFP_KERNEL);
 	if (!save)
 		return -ENOMEM;
-	dev->dev.power.saved_state = save;
+	sachip->saved_state = save;
 
 	spin_lock_irqsave(&sachip->lock, flags);
 
@@ -878,7 +881,7 @@ static int sa1111_resume(struct platform
 	unsigned long flags, id;
 	void __iomem *base;
 
-	save = (struct sa1111_save_data *)dev->dev.power.saved_state;
+	save = sachip->saved_state;
 	if (!save)
 		return 0;
 
@@ -923,7 +926,7 @@ static int sa1111_resume(struct platform
 
 	spin_unlock_irqrestore(&sachip->lock, flags);
 
-	dev->dev.power.saved_state = NULL;
+	sachip->saved_state = NULL;
 	kfree(save);
 
 	return 0;
@@ -958,8 +961,8 @@ static int sa1111_remove(struct platform
 		platform_set_drvdata(pdev, NULL);
 
 #ifdef CONFIG_PM
-		kfree(pdev->dev.power.saved_state);
-		pdev->dev.power.saved_state = NULL;
+		kfree(sachip->saved_state);
+		sachip->saved_state = NULL;
 #endif
 	}
 
diff -puN arch/arm/mach-sa1100/neponset.c~pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm arch/arm/mach-sa1100/neponset.c
--- a/arch/arm/mach-sa1100/neponset.c~pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm
+++ a/arch/arm/mach-sa1100/neponset.c
@@ -185,28 +185,21 @@ static int __devinit neponset_probe(stru
 /*
  * LDM power management.
  */
+static unsigned int neponset_saved_state;
+
 static int neponset_suspend(struct platform_device *dev, pm_message_t state)
 {
 	/*
 	 * Save state.
 	 */
-	if (!dev->dev.power.saved_state)
-		dev->dev.power.saved_state = kmalloc(sizeof(unsigned int), GFP_KERNEL);
-	if (!dev->dev.power.saved_state)
-		return -ENOMEM;
-
-	*(unsigned int *)dev->dev.power.saved_state = NCR_0;
+	neponset_saved_state = NCR_0;
 
 	return 0;
 }
 
 static int neponset_resume(struct platform_device *dev)
 {
-	if (dev->dev.power.saved_state) {
-		NCR_0 = *(unsigned int *)dev->dev.power.saved_state;
-		kfree(dev->dev.power.saved_state);
-		dev->dev.power.saved_state = NULL;
-	}
+	NCR_0 = neponset_saved_state;
 
 	return 0;
 }
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
x86_64-pm_trace-support.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
pm-reduce-code-duplication-between-mainc-and-userc-updated.patch
acpi-do-not-prepare-for-hibernation-in-acpi_shutdown.patch
pm-introduce-pm_power_off_prepare.patch
pm-optional-beeping-during-resume-from-suspend-to-ram.patch
pm-integrate-beeping-flag-with-existing-acpi_sleep-flags.patch
pm-remove-deprecated-sysfs-files.patch
pm-remove-deprecated-dpm_runtime_-routines.patch
suspend-maintainers-update.patch
shrink_slab-handle-bad-shrinkers.patch
