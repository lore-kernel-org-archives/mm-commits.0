From: akpm@linux-foundation.org
Subject: - pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm-update.patch removed from -mm tree
Date: Mon, 09 Jul 2007 11:38:30 -0700
Message-ID: <200707091838.l69IcUGl000792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724AbXGISjJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 14:39:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, david-b@pacbell.net, greg@kroah.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm update
has been removed from the -mm tree.  Its filename was
     pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm-update.patch

This patch was dropped because it was folded into pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm.patch

------------------------------------------------------
Subject: pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm update
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Russell says that the affected drivers were coded to support multiple instances
of the same device which the $subject patch doesn't take into account (still,
as far as the neponset is concerned, I think that there can be only one
instance of NCR_0 in the system).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/common/locomo.c |   22 +++++++++++++++++++---
 arch/arm/common/sa1111.c |   15 ++++++++-------
 2 files changed, 27 insertions(+), 10 deletions(-)

diff -puN arch/arm/common/locomo.c~pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm-update arch/arm/common/locomo.c
--- a/arch/arm/common/locomo.c~pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm-update
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
@@ -553,14 +556,20 @@ struct locomo_save_data {
 	u16	LCM_GPE;
 	u16	LCM_ASD;
 	u16	LCM_SPIMD;
-} locomo_saved_state;
+};
 
 static int locomo_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct locomo *lchip = platform_get_drvdata(dev);
-	struct locomo_save_data *save = &locomo_saved_state;
+	struct locomo_save_data *save;
 	unsigned long flags;
 
+	save = kmalloc(sizeof(struct locomo_save_data), GFP_KERNEL);
+	if (!save)
+		return -ENOMEM;
+
+	lchip->saved_state = save;
+
 	spin_lock_irqsave(&lchip->lock, flags);
 
 	save->LCM_GPO     = locomo_readl(lchip->base + LOCOMO_GPO);	/* GPIO */
@@ -596,10 +605,14 @@ static int locomo_suspend(struct platfor
 static int locomo_resume(struct platform_device *dev)
 {
 	struct locomo *lchip = platform_get_drvdata(dev);
-	struct locomo_save_data *save = &locomo_saved_state;
+	struct locomo_save_data *save;
 	unsigned long r;
 	unsigned long flags;
 
+	save = lchip->saved_state;
+	if (!save)
+		return 0;
+
 	spin_lock_irqsave(&lchip->lock, flags);
 
 	locomo_writel(save->LCM_GPO, lchip->base + LOCOMO_GPO);
@@ -619,6 +632,9 @@ static int locomo_resume(struct platform
 
 	spin_unlock_irqrestore(&lchip->lock, flags);
 
+	lchip->saved_state = NULL;
+	kfree(save);
+
 	return 0;
 }
 #endif
diff -puN arch/arm/common/sa1111.c~pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm-update arch/arm/common/sa1111.c
--- a/arch/arm/common/sa1111.c~pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm-update
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
@@ -811,8 +814,6 @@ struct sa1111_save_data {
 
 #ifdef CONFIG_PM
 
-static struct sa1111_save_data *sa1111_saved_state;
-
 static int sa1111_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct sa1111 *sachip = platform_get_drvdata(dev);
@@ -824,7 +825,7 @@ static int sa1111_suspend(struct platfor
 	save = kmalloc(sizeof(struct sa1111_save_data), GFP_KERNEL);
 	if (!save)
 		return -ENOMEM;
-	sa1111_saved_state = save;
+	sachip->saved_state = save;
 
 	spin_lock_irqsave(&sachip->lock, flags);
 
@@ -880,7 +881,7 @@ static int sa1111_resume(struct platform
 	unsigned long flags, id;
 	void __iomem *base;
 
-	save = sa1111_saved_state;
+	save = sachip->saved_state;
 	if (!save)
 		return 0;
 
@@ -925,7 +926,7 @@ static int sa1111_resume(struct platform
 
 	spin_unlock_irqrestore(&sachip->lock, flags);
 
-	sa1111_saved_state = NULL;
+	sachip->saved_state = NULL;
 	kfree(save);
 
 	return 0;
@@ -960,8 +961,8 @@ static int sa1111_remove(struct platform
 		platform_set_drvdata(pdev, NULL);
 
 #ifdef CONFIG_PM
-		kfree(sa1111_saved_state);
-		sa1111_saved_state = NULL;
+		kfree(sachip->saved_state);
+		sachip->saved_state = NULL;
 #endif
 	}
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm.patch
pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm-update.patch
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
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
pm-reduce-code-duplication-between-mainc-and-userc-updated.patch
acpi-do-not-prepare-for-hibernation-in-acpi_shutdown.patch
pm-introduce-pm_power_off_prepare.patch
pm-optional-beeping-during-resume-from-suspend-to-ram.patch
pm-integrate-beeping-flag-with-existing-acpi_sleep-flags.patch
shrink_slab-handle-bad-shrinkers.patch
