From: akpm@linux-foundation.org
Subject: - pci-pm-make-more-pci-pm-core-functionality-available-to-drivers.patch removed from -mm tree
Date: Wed, 23 Jul 2008 14:02:42 -0700
Message-ID: <200807232102.m6NL2glK011782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753508AbYGWVD3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 17:03:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, jbarnes@virtuousgeek.org, jeff@garzik.org, shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     pci pm: make more PCI PM core functionality available to drivers
has been removed from the -mm tree.  Its filename was
     pci-pm-make-more-pci-pm-core-functionality-available-to-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci pm: make more PCI PM core functionality available to drivers
From: Rafael J. Wysocki <rjw@sisk.pl>

Make more PCI PM core functionality available to drivers

* Export pci_pme_capable() so that it can be called directly by
  drivers (for example, tg3 needs that).

* Move the state choosing part of pci_prepare_to_sleep() to a
  separate function, pci_target_state(), that can be called directly
  by drivers (for example, tg3 needs that).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c   |   34 +++++++++++++++++++++++++---------
 include/linux/pci.h |    2 ++
 2 files changed, 27 insertions(+), 9 deletions(-)

diff -puN drivers/pci/pci.c~pci-pm-make-more-pci-pm-core-functionality-available-to-drivers drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci-pm-make-more-pci-pm-core-functionality-available-to-drivers
+++ a/drivers/pci/pci.c
@@ -1040,7 +1040,7 @@ int pci_set_pcie_reset_state(struct pci_
  * @dev: PCI device to handle.
  * @state: PCI state from which device will issue PME#.
  */
-static bool pci_pme_capable(struct pci_dev *dev, pci_power_t state)
+bool pci_pme_capable(struct pci_dev *dev, pci_power_t state)
 {
 	if (!dev->pm_cap)
 		return false;
@@ -1123,17 +1123,11 @@ int pci_enable_wake(struct pci_dev *dev,
 }
 
 /**
- * pci_prepare_to_sleep - prepare PCI device for system-wide transition into a sleep state
- * @dev: Device to handle.
  *
- * Choose the power state appropriate for the device depending on whether
- * it can wake up the system and/or is power manageable by the platform
- * (PCI_D3hot is the default) and put the device into that state.
  */
-int pci_prepare_to_sleep(struct pci_dev *dev)
+pci_power_t pci_target_state(struct pci_dev *dev)
 {
 	pci_power_t target_state = PCI_D3hot;
-	int error;
 
 	if (platform_pci_power_manageable(dev)) {
 		/*
@@ -1160,7 +1154,7 @@ int pci_prepare_to_sleep(struct pci_dev 
 		 * to generate PME#.
 		 */
 		if (!dev->pm_cap)
-			return -EIO;
+			return PCI_POWER_ERROR;
 
 		if (dev->pme_support) {
 			while (target_state
@@ -1169,6 +1163,26 @@ int pci_prepare_to_sleep(struct pci_dev 
 		}
 	}
 
+	return target_state;
+}
+
+/**
+ * pci_prepare_to_sleep - prepare PCI device for system-wide transition into
+ *                        a sleep state
+ * @dev: Device to handle.
+ *
+ * Choose the power state appropriate for the device depending on whether
+ * it can wake up the system and/or is power manageable by the platform
+ * (PCI_D3hot is the default) and put the device into that state.
+ */
+int pci_prepare_to_sleep(struct pci_dev *dev)
+{
+	pci_power_t target_state = pci_target_state(dev);
+	int error;
+
+	if (target_state == PCI_POWER_ERROR)
+		return -EIO;
+
 	pci_enable_wake(dev, target_state, true);
 
 	error = pci_set_power_state(dev, target_state);
@@ -1918,7 +1932,9 @@ EXPORT_SYMBOL(pci_select_bars);
 EXPORT_SYMBOL(pci_set_power_state);
 EXPORT_SYMBOL(pci_save_state);
 EXPORT_SYMBOL(pci_restore_state);
+EXPORT_SYMBOL(pci_pme_capable);
 EXPORT_SYMBOL(pci_enable_wake);
+EXPORT_SYMBOL(pci_target_state);
 EXPORT_SYMBOL(pci_prepare_to_sleep);
 EXPORT_SYMBOL(pci_back_from_sleep);
 EXPORT_SYMBOL_GPL(pci_set_pcie_reset_state);
diff -puN include/linux/pci.h~pci-pm-make-more-pci-pm-core-functionality-available-to-drivers include/linux/pci.h
--- a/include/linux/pci.h~pci-pm-make-more-pci-pm-core-functionality-available-to-drivers
+++ a/include/linux/pci.h
@@ -638,7 +638,9 @@ int pci_save_state(struct pci_dev *dev);
 int pci_restore_state(struct pci_dev *dev);
 int pci_set_power_state(struct pci_dev *dev, pci_power_t state);
 pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state);
+bool pci_pme_capable(struct pci_dev *dev, pci_power_t state);
 int pci_enable_wake(struct pci_dev *dev, pci_power_t state, int enable);
+pci_power_t pci_target_state(struct pci_dev *dev);
 int pci_prepare_to_sleep(struct pci_dev *dev);
 int pci_back_from_sleep(struct pci_dev *dev);
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
tg3-adapt-tg3-to-use-reworked-pci-pm-code.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
pm-boot-time-suspend-selftest.patch
pm-boot-time-suspend-selftest-vs-linux-next.patch
pm-boot-time-suspend-selftest-update.patch
remove-include-linux-pm_legacyh.patch
pm-remove-definition-of-struct-pm_dev.patch
pm-remove-remaining-obsolete-definitions-from-pmh.patch
pm-remove-obsolete-piece-of-pm-documentation-rev-2.patch
pm-drop-unnecessary-includes-from-pmh.patch
pm-add-new-pm_event-codes-for-runtime-power-transitions.patch
pm-hibernation-simplify-memory-bitmap.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup.patch
pm-schedule-sysrq-poweroff-on-boot-cpu.patch
pm-schedule-sysrq-poweroff-on-boot-cpu-fix.patch
pm-acpi-hibernation-utilize-hardware-signature.patch
pm-acpi-hibernation-utilize-hardware-signaturepatch-causes-build-error.patch
pm-acpi-pm-add-dmi-quirk-list-for-acpi-10-suspend-ordering.patch
pm-fix-try_to_freeze_taskss-use-of-do_div.patch
drivers-power-fix-platform-driver-hotplug-coldplug.patch
mfd-fix-platform-driver-hotplug-coldplug.patch
parport-fix-platform-driver-hotplug-coldplug.patch
kexec-jump.patch
kexec-jump-save-restore-device-state.patch
shrink_slab-handle-bad-shrinkers.patch

