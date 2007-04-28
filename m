From: akpm@linux-foundation.org
Subject: + s2ram-add-arch-irq-disable-enable-hooks.patch added to -mm tree
Date: Fri, 27 Apr 2007 18:55:46 -0700
Message-ID: <200704280155.l3S1tk6A012885@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030905AbXD1B42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 21:56:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, benh@kernel.crashing.org, greg@kroah.com, paulus@samba.org, pavel@ucw.cz


The patch titled
     s2ram: add arch irq disable/enable hooks
has been added to the -mm tree.  Its filename is
     s2ram-add-arch-irq-disable-enable-hooks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s2ram: add arch irq disable/enable hooks
From: Johannes Berg <johannes@sipsolutions.net>

For powermac, we need to do some things between suspending devices and
device_power_off, for example setting the decrementer.  This patch allows
architectures to define arch_s2ram_{en,dis}able_irqs in their asm/suspend.h
to have control over this step.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pm.h  |   18 ++++++++++++++++++
 kernel/power/main.c |   18 +++++++++++++++---
 2 files changed, 33 insertions(+), 3 deletions(-)

diff -puN include/linux/pm.h~s2ram-add-arch-irq-disable-enable-hooks include/linux/pm.h
--- a/include/linux/pm.h~s2ram-add-arch-irq-disable-enable-hooks
+++ a/include/linux/pm.h
@@ -170,6 +170,24 @@ extern int pm_suspend(suspend_state_t st
 
 extern int pm_valid_only_mem(suspend_state_t state);
 
+/**
+ * arch_suspend_disable_irqs - disable IRQs for suspend
+ *
+ * Disables IRQs (in the default case). This is a weak symbol in the common
+ * code and thus allows architectures to override it if more needs to be
+ * done. Not called for suspend to disk.
+ */
+extern void arch_suspend_disable_irqs(void);
+
+/**
+ * arch_suspend_enable_irqs - enable IRQs after suspend
+ *
+ * Enables IRQs (in the default case). This is a weak symbol in the common
+ * code and thus allows architectures to override it if more needs to be
+ * done. Not called for suspend to disk.
+ */
+extern void arch_suspend_enable_irqs(void);
+
 /*
  * Device power management
  */
diff -puN kernel/power/main.c~s2ram-add-arch-irq-disable-enable-hooks kernel/power/main.c
--- a/kernel/power/main.c~s2ram-add-arch-irq-disable-enable-hooks
+++ a/kernel/power/main.c
@@ -128,13 +128,24 @@ static int suspend_prepare(suspend_state
 	return error;
 }
 
+/* default implementation */
+void __attribute__ ((weak)) arch_suspend_disable_irqs(void)
+{
+	local_irq_disable();
+}
+
+/* default implementation */
+void __attribute__ ((weak)) arch_suspend_enable_irqs(void)
+{
+	local_irq_enable();
+}
 
 int suspend_enter(suspend_state_t state)
 {
 	int error = 0;
-	unsigned long flags;
 
-	local_irq_save(flags);
+	arch_suspend_disable_irqs();
+	BUG_ON(!irqs_disabled());
 
 	if ((error = device_power_down(PMSG_SUSPEND))) {
 		printk(KERN_ERR "Some devices failed to power down\n");
@@ -143,7 +154,8 @@ int suspend_enter(suspend_state_t state)
 	error = pm_ops->enter(state);
 	device_power_up();
  Done:
-	local_irq_restore(flags);
+	arch_suspend_enable_irqs();
+	BUG_ON(irqs_disabled());
 	return error;
 }
 
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-implement-pm_opsvalid-for-everybody-fix.patch
power-management-force-pm_opsvalid-callback-to-be.patch
git-alsa.patch
git-powerpc.patch
git-powerpc-arch-powerpc-sysdev-timerc-build-fix.patch
s2ram-add-arch-irq-disable-enable-hooks.patch
power-management-remove-some-useless-code-from-arm.patch
git-netdev-all-export-ieee80211_debug_level.patch
git-net.patch
remove-software_suspend.patch
power-management-change-sys-power-disk-display.patch
fix-sscanf-%n-match-at-end-of-input-string.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
kernel-doc-html-mode-struct-highlights.patch
