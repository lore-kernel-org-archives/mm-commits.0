From: akpm@linux-foundation.org
Subject: + pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm.patch added to -mm tree
Date: Wed, 27 Jun 2007 14:24:19 -0700
Message-ID: <200706272124.l5RLOJxi007420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60296 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759604AbXF0VYn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 17:24:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, david-b@pacbell.net, greg@kroah.com, rmk@arm.linux.org.uk


The patch titled
     PM: do not use saved_state from struct dev_pm_info on ARM
has been added to the -mm tree.  Its filename is
     pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 arch/arm/common/locomo.c        |   17 +++--------------
 arch/arm/common/sa1111.c        |   12 +++++++-----
 arch/arm/mach-sa1100/neponset.c |   15 ++++-----------
 3 files changed, 14 insertions(+), 30 deletions(-)

diff -puN arch/arm/common/locomo.c~pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm arch/arm/common/locomo.c
--- a/arch/arm/common/locomo.c~pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm
+++ a/arch/arm/common/locomo.c
@@ -553,20 +553,14 @@ struct locomo_save_data {
 	u16	LCM_GPE;
 	u16	LCM_ASD;
 	u16	LCM_SPIMD;
-};
+} locomo_saved_state;
 
 static int locomo_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct locomo *lchip = platform_get_drvdata(dev);
-	struct locomo_save_data *save;
+	struct locomo_save_data *save = &locomo_saved_state;
 	unsigned long flags;
 
-	save = kmalloc(sizeof(struct locomo_save_data), GFP_KERNEL);
-	if (!save)
-		return -ENOMEM;
-
-	dev->dev.power.saved_state = (void *) save;
-
 	spin_lock_irqsave(&lchip->lock, flags);
 
 	save->LCM_GPO     = locomo_readl(lchip->base + LOCOMO_GPO);	/* GPIO */
@@ -602,13 +596,9 @@ static int locomo_suspend(struct platfor
 static int locomo_resume(struct platform_device *dev)
 {
 	struct locomo *lchip = platform_get_drvdata(dev);
-	struct locomo_save_data *save;
+	struct locomo_save_data *save = &locomo_saved_state;
 	unsigned long r;
 	unsigned long flags;
-	
-	save = (struct locomo_save_data *) dev->dev.power.saved_state;
-	if (!save)
-		return 0;
 
 	spin_lock_irqsave(&lchip->lock, flags);
 
@@ -628,7 +618,6 @@ static int locomo_resume(struct platform
 	locomo_writel(0x1, lchip->base + LOCOMO_KEYBOARD + LOCOMO_KCMD);
 
 	spin_unlock_irqrestore(&lchip->lock, flags);
-	kfree(save);
 
 	return 0;
 }
diff -puN arch/arm/common/sa1111.c~pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm arch/arm/common/sa1111.c
--- a/arch/arm/common/sa1111.c~pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm
+++ a/arch/arm/common/sa1111.c
@@ -811,6 +811,8 @@ struct sa1111_save_data {
 
 #ifdef CONFIG_PM
 
+static struct sa1111_save_data *sa1111_saved_state;
+
 static int sa1111_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct sa1111 *sachip = platform_get_drvdata(dev);
@@ -822,7 +824,7 @@ static int sa1111_suspend(struct platfor
 	save = kmalloc(sizeof(struct sa1111_save_data), GFP_KERNEL);
 	if (!save)
 		return -ENOMEM;
-	dev->dev.power.saved_state = save;
+	sa1111_saved_state = save;
 
 	spin_lock_irqsave(&sachip->lock, flags);
 
@@ -878,7 +880,7 @@ static int sa1111_resume(struct platform
 	unsigned long flags, id;
 	void __iomem *base;
 
-	save = (struct sa1111_save_data *)dev->dev.power.saved_state;
+	save = sa1111_saved_state;
 	if (!save)
 		return 0;
 
@@ -923,7 +925,7 @@ static int sa1111_resume(struct platform
 
 	spin_unlock_irqrestore(&sachip->lock, flags);
 
-	dev->dev.power.saved_state = NULL;
+	sa1111_saved_state = NULL;
 	kfree(save);
 
 	return 0;
@@ -958,8 +960,8 @@ static int sa1111_remove(struct platform
 		platform_set_drvdata(pdev, NULL);
 
 #ifdef CONFIG_PM
-		kfree(pdev->dev.power.saved_state);
-		pdev->dev.power.saved_state = NULL;
+		kfree(sa1111_saved_state);
+		sa1111_saved_state = NULL;
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
pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm.patch
x86_64-pm_trace-support.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-introduce-hibernation-and-suspend-notifiers-fix.patch
pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
pm-introduce-hibernation-and-suspend-notifiers-fix-fix.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
pm-disable-usermode-helper-before-hibernation-and-suspend-fix.patch
pm-reduce-code-duplication-between-mainc-and-userc.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
shrink_slab-handle-bad-shrinkers.patch
beeping-patch-for-debugging-acpi-sleep.patch
