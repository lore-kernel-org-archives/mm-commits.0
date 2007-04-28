From: akpm@linux-foundation.org
Subject: - define-platform-wakeup-hook-use-in-pci_enable_wake.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:51:18 -0700
Message-ID: <200704281051.l3SApIXi019978@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031517AbXD1Kw5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:52:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, greg@kroah.com, lenb@kernel.org, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     define platform wakeup hook, use in pci_enable_wake()
has been removed from the -mm tree.  Its filename was
     define-platform-wakeup-hook-use-in-pci_enable_wake.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: define platform wakeup hook, use in pci_enable_wake()
From: David Brownell <david-b@pacbell.net>

This defines a platform hook to enable/disable a device as a wakeup event
source.  It's initially for use with ACPI, but more generally it could be used
whenever enable_irq_wake()/disable_irq_wake() don't suffice.

The hook is called -- if available -- inside pci_enable_wake(); and the
semantics of that call are enhanced so that support for PCI PME# is no longer
needed.  It can now work for devices with "legacy PCI PM", when platform
support allows it.  (That support would use some board-specific signal for for
the same purpose as PME#.)

[akpm@linux-foundation.org: Make it compile with CONFIG_PM=n]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/main.c |    3 +
 drivers/pci/pci.c         |   60 +++++++++++++++++++++++++-----------
 include/linux/pm.h        |   19 +++++++++++
 3 files changed, 64 insertions(+), 18 deletions(-)

diff -puN drivers/base/power/main.c~define-platform-wakeup-hook-use-in-pci_enable_wake drivers/base/power/main.c
--- a/drivers/base/power/main.c~define-platform-wakeup-hook-use-in-pci_enable_wake
+++ a/drivers/base/power/main.c
@@ -29,6 +29,9 @@ LIST_HEAD(dpm_off_irq);
 DECLARE_MUTEX(dpm_sem);
 DECLARE_MUTEX(dpm_list_sem);
 
+int (*platform_enable_wakeup)(struct device *dev, int is_on);
+
+
 /**
  *	device_pm_set_parent - Specify power dependency.
  *	@dev:		Device who needs power.
diff -puN drivers/pci/pci.c~define-platform-wakeup-hook-use-in-pci_enable_wake drivers/pci/pci.c
--- a/drivers/pci/pci.c~define-platform-wakeup-hook-use-in-pci_enable_wake
+++ a/drivers/pci/pci.c
@@ -13,6 +13,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/pm.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
@@ -891,31 +892,48 @@ pci_disable_device(struct pci_dev *dev)
 }
 
 /**
- * pci_enable_wake - enable device to generate PME# when suspended
- * @dev: - PCI device to operate on
- * @state: - Current state of device.
- * @enable: - Flag to enable or disable generation
- * 
- * Set the bits in the device's PM Capabilities to generate PME# when
- * the system is suspended. 
- *
- * -EIO is returned if device doesn't have PM Capabilities. 
- * -EINVAL is returned if device supports it, but can't generate wake events.
- * 0 if operation is successful.
- * 
+ * pci_enable_wake - enable PCI device as wakeup event source
+ * @dev: PCI device affected
+ * @state: PCI state from which device will issue wakeup events
+ * @enable: True to enable event generation; false to disable
+ *
+ * This enables the device as a wakeup event source, or disables it.
+ * When such events involves platform-specific hooks, those hooks are
+ * called automatically by this routine.
+ *
+ * Devices with legacy power management (no standard PCI PM capabilities)
+ * always require such platform hooks.  Depending on the platform, devices
+ * supporting the standard PCI PME# signal may require such platform hooks;
+ * they always update bits in config space to allow PME# generation.
+ *
+ * -EIO is returned if the device can't ever be a wakeup event source.
+ * -EINVAL is returned if the device can't generate wakeup events from
+ * the specified PCI state.  Returns zero if the operation is successful.
  */
 int pci_enable_wake(struct pci_dev *dev, pci_power_t state, int enable)
 {
 	int pm;
+	int status;
 	u16 value;
 
+	/* Note that drivers should verify device_may_wakeup(&dev->dev)
+	 * before calling this function.  Platform code should report
+	 * errors when drivers try to enable wakeup on devices that
+	 * can't issue wakeups, or on which wakeups were disabled by
+	 * userspace updating the /sys/devices.../power/wakeup file.
+	 */
+
+	status = call_platform_enable_wakeup(&dev->dev, enable);
+
 	/* find PCI PM capability in list */
 	pm = pci_find_capability(dev, PCI_CAP_ID_PM);
 
-	/* If device doesn't support PM Capabilities, but request is to disable
-	 * wake events, it's a nop; otherwise fail */
-	if (!pm) 
-		return enable ? -EIO : 0; 
+	/* If device doesn't support PM Capabilities, but caller wants to
+	 * disable wake events, it's a NOP.  Otherwise fail unless the
+	 * platform hooks handled this legacy device already.
+	 */
+	if (!pm)
+		return enable ? status : 0;
 
 	/* Check device's ability to generate PME# */
 	pci_read_config_word(dev,pm+PCI_PM_PMC,&value);
@@ -924,8 +942,14 @@ int pci_enable_wake(struct pci_dev *dev,
 	value >>= ffs(PCI_PM_CAP_PME_MASK) - 1;   /* First bit of mask */
 
 	/* Check if it can generate PME# from requested state. */
-	if (!value || !(value & (1 << state))) 
+	if (!value || !(value & (1 << state))) {
+		/* if it can't, revert what the platform hook changed,
+		 * always reporting the base "EINVAL, can't PME#" error
+		 */
+		if (enable)
+			call_platform_enable_wakeup(&dev->dev, 0);
 		return enable ? -EINVAL : 0;
+	}
 
 	pci_read_config_word(dev, pm + PCI_PM_CTRL, &value);
 
@@ -936,7 +960,7 @@ int pci_enable_wake(struct pci_dev *dev,
 		value &= ~PCI_PM_CTRL_PME_ENABLE;
 
 	pci_write_config_word(dev, pm + PCI_PM_CTRL, value);
-	
+
 	return 0;
 }
 
diff -puN include/linux/pm.h~define-platform-wakeup-hook-use-in-pci_enable_wake include/linux/pm.h
--- a/include/linux/pm.h~define-platform-wakeup-hook-use-in-pci_enable_wake
+++ a/include/linux/pm.h
@@ -273,6 +273,20 @@ extern void __suspend_report_result(cons
 		__suspend_report_result(__FUNCTION__, fn, ret);		\
 	} while (0)
 
+/*
+ * Platform hook to activate device wakeup capability, if that's not already
+ * handled by enable_irq_wake() etc.
+ * Returns zero on success, else negative errno
+ */
+extern int (*platform_enable_wakeup)(struct device *dev, int is_on);
+
+static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
+{
+	if (platform_enable_wakeup)
+		return (*platform_enable_wakeup)(dev, is_on);
+	return 0;
+}
+
 #else /* !CONFIG_PM */
 
 static inline int device_suspend(pm_message_t state)
@@ -294,6 +308,11 @@ static inline void dpm_runtime_resume(st
 
 #define suspend_report_result(fn, ret) do { } while (0)
 
+static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
+{
+	return -EIO;
+}
+
 #endif
 
 /* changes to device_may_wakeup take effect on the next pm state change.
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-implement-pm_opsvalid-for-everybody-fix.patch
git-acpi.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
at91_cf-minor-fix.patch
scsi-newstyle-hotplug-coldplug-support.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
kconfig-mentioneds-hibernation-not-just-swsusp.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
char-cs5535_gpio-add-module_device_table.patch
parport-dev-driver-model-support.patch
parport-dev-driver-model-support-powerpc-fix.patch
layered-parport-code-uses-parport-dev.patch
pnpacpi-sets-pnpdev-devarchdata.patch
pnpacpi-sets-pnpdev-devarchdata-fix.patch
fix-hotplug-for-legacy-platform-drivers.patch
minor-spi_butterfly-cleanup.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
rtc-update-to-class-device-removal-patches.patch
rtc-kconfig-cleanup.patch
rtc-cmos-wakeup-interface.patch
acpi-wakeup-hooks-for-rtc-cmos.patch
workaround-rtc-related-acpi-table-bugs.patch
revert-rtc-add-rtc_merge_alarm.patch
remove-rtc_alm_set-mode-bugs.patch
