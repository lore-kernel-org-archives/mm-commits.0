From: akpm@linux-foundation.org
Subject: + define-platform-wakeup-hook-use-in-pci_enable_wake-update.patch added to -mm tree
Date: Thu, 19 Apr 2007 20:11:45 -0700
Message-ID: <200704200311.l3K3BjB3005698@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754384AbXDTDL4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 23:11:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     define platform wakeup hook, use in pci_enable_wake() (update)
has been added to the -mm tree.  Its filename is
     define-platform-wakeup-hook-use-in-pci_enable_wake-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: define platform wakeup hook, use in pci_enable_wake() (update)
From: David Brownell <david-b@pacbell.net>

Minor cleanups as suggested by Andrew.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/main.c |    2 +-
 drivers/pci/pci.c         |    5 ++++-
 include/linux/pm.h        |    1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/base/power/main.c~define-platform-wakeup-hook-use-in-pci_enable_wake-update drivers/base/power/main.c
--- a/drivers/base/power/main.c~define-platform-wakeup-hook-use-in-pci_enable_wake-update
+++ a/drivers/base/power/main.c
@@ -29,7 +29,7 @@ LIST_HEAD(dpm_off_irq);
 DECLARE_MUTEX(dpm_sem);
 DECLARE_MUTEX(dpm_list_sem);
 
-int (*platform_enable_wakeup)(struct device *dev, int is_on) = NULL;
+int (*platform_enable_wakeup)(struct device *dev, int is_on);
 
 
 /**
diff -puN drivers/pci/pci.c~define-platform-wakeup-hook-use-in-pci_enable_wake-update drivers/pci/pci.c
--- a/drivers/pci/pci.c~define-platform-wakeup-hook-use-in-pci_enable_wake-update
+++ a/drivers/pci/pci.c
@@ -947,8 +947,11 @@ int pci_enable_wake(struct pci_dev *dev,
 
 	/* Check if it can generate PME# from requested state. */
 	if (!value || !(value & (1 << state))) {
+		/* if it can't, revert what the platform hook changed,
+		 * always reporting the base "EINVAL, can't PME#" error
+		 */
 		if (enable && platform_enable_wakeup)
-			(void) platform_enable_wakeup(&dev->dev, 0);
+			platform_enable_wakeup(&dev->dev, 0);
 		return enable ? -EINVAL : 0;
 	}
 
diff -puN include/linux/pm.h~define-platform-wakeup-hook-use-in-pci_enable_wake-update include/linux/pm.h
--- a/include/linux/pm.h~define-platform-wakeup-hook-use-in-pci_enable_wake-update
+++ a/include/linux/pm.h
@@ -275,6 +275,7 @@ extern void __suspend_report_result(cons
 
 /* platform hook to activate device wakeup capability, if
  * that's not already handled by enable_irq_wake() etc
+ * returns zero on success, else negative errno
  */
 extern int (*platform_enable_wakeup)(struct device *dev, int is_on);
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

make-proc-acpi-wakeup-more-useful.patch
define-platform-wakeup-hook-use-in-pci_enable_wake.patch
define-platform-wakeup-hook-use-in-pci_enable_wake-update.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
at91_cf-minor-fix.patch
scsi-newstyle-hotplug-coldplug-support.patch
usb-gadget-rndis-fix-struct-rndis_packet_msg_type.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
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
