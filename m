From: akpm@linux-foundation.org
Subject: - s2ram-add-arch-irq-disable-enable-hooks.patch removed from -mm tree
Date: Fri, 27 Apr 2007 18:54:20 -0700
Message-ID: <200704280154.l3S1sLSg012868@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030912AbXD1BzH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 21:55:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     s2ram: add arch irq disable/enable hooks
has been removed from the -mm tree.  Its filename was
     s2ram-add-arch-irq-disable-enable-hooks.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: s2ram: add arch irq disable/enable hooks
From: Johannes Berg <johannes@sipsolutions.net>

For powermac, we need to do some things between suspending devices and
device_power_off, for example setting the decrementer. This patch
allows architectures to define arch_s2ram_{en,dis}able_irqs in their
asm/suspend.h to have control over this step.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/main.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN kernel/power/main.c~s2ram-add-arch-irq-disable-enable-hooks kernel/power/main.c
--- a/kernel/power/main.c~s2ram-add-arch-irq-disable-enable-hooks
+++ a/kernel/power/main.c
@@ -111,13 +111,22 @@ static int suspend_prepare(suspend_state
 	return error;
 }
 
+#ifndef arch_s2ram_disable_irqs
+#define arch_s2ram_disable_irqs(flags) local_irq_save(*flags)
+#endif
+
+#ifndef arch_s2ram_enable_irqs
+#define arch_s2ram_enable_irqs(flags) local_irq_restore(*flags)
+#endif
+
 
 int suspend_enter(suspend_state_t state)
 {
 	int error = 0;
 	unsigned long flags;
 
-	local_irq_save(flags);
+	arch_s2ram_disable_irqs(&flags);
+	BUG_ON(!irqs_disabled());
 
 	if ((error = device_power_down(PMSG_SUSPEND))) {
 		printk(KERN_ERR "Some devices failed to power down\n");
@@ -126,7 +135,8 @@ int suspend_enter(suspend_state_t state)
 	error = pm_ops->enter(state);
 	device_power_up();
  Done:
-	local_irq_restore(flags);
+	arch_s2ram_enable_irqs(&flags);
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
