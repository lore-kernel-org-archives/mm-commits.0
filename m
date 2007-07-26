From: akpm@linux-foundation.org
Subject: - acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1.patch removed from -mm tree
Date: Wed, 25 Jul 2007 22:01:46 -0700
Message-ID: <200707260501.l6Q51kHk014943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40380 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243AbXGZFCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 01:02:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lenb@kernel.org, len.brown@intel.com, mm-commits@vger.kernel.org


The patch titled
     ACPI: revert d-states branch from Jun-17 to Jun-19 for 2.6.23-rc1-mm1
has been removed from the -mm tree.  Its filename was
     acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: ACPI: revert d-states branch from Jun-17 to Jun-19 for 2.6.23-rc1-mm1
From: Len Brown <lenb@kernel.org>

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c  |   75 -----------------------------------
 drivers/pci/pci-acpi.c     |   26 +-----------
 drivers/pci/pci.c          |    8 +--
 drivers/pci/pci.h          |    2 
 drivers/pnp/driver.c       |    5 --
 drivers/pnp/pnpacpi/core.c |   14 ------
 include/acpi/acpi_bus.h    |    2 
 include/linux/pnp.h        |    4 -
 8 files changed, 8 insertions(+), 128 deletions(-)

diff -puN drivers/acpi/sleep/main.c~acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1 drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1
+++ a/drivers/acpi/sleep/main.c
@@ -261,81 +261,6 @@ static struct platform_hibernation_ops a
 };
 #endif				/* CONFIG_SOFTWARE_SUSPEND */
 
-/**
- *	acpi_pm_device_sleep_state - return preferred power state of ACPI device
- *		in the system sleep state given by %acpi_target_sleep_state
- *	@dev: device to examine
- *	@wake: if set, the device should be able to wake up the system
- *	@d_min_p: used to store the upper limit of allowed states range
- *	Return value: preferred power state of the device on success, -ENODEV on
- *		failure (ie. if there's no 'struct acpi_device' for @dev)
- *
- *	Find the lowest power (highest number) ACPI device power state that
- *	device @dev can be in while the system is in the sleep state represented
- *	by %acpi_target_sleep_state.  If @wake is nonzero, the device should be
- *	able to wake up the system from this sleep state.  If @d_min_p is set,
- *	the highest power (lowest number) device power state of @dev allowed
- *	in this system sleep state is stored at the location pointed to by it.
- *
- *	The caller must ensure that @dev is valid before using this function.
- *	The caller is also responsible for figuring out if the device is
- *	supposed to be able to wake up the system and passing this information
- *	via @wake.
- */
-
-int acpi_pm_device_sleep_state(struct device *dev, int wake, int *d_min_p)
-{
-	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
-	struct acpi_device *adev;
-	char acpi_method[] = "_SxD";
-	unsigned long d_min, d_max;
-
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
-		printk(KERN_ERR "ACPI handle has no context!\n");
-		return -ENODEV;
-	}
-
-	acpi_method[2] = '0' + acpi_target_sleep_state;
-	/*
-	 * If the sleep state is S0, we will return D3, but if the device has
-	 * _S0W, we will use the value from _S0W
-	 */
-	d_min = ACPI_STATE_D0;
-	d_max = ACPI_STATE_D3;
-
-	/*
-	 * If present, _SxD methods return the minimum D-state (highest power
-	 * state) we can use for the corresponding S-states.  Otherwise, the
-	 * minimum D-state is D0 (ACPI 3.x).
-	 *
-	 * NOTE: We rely on acpi_evaluate_integer() not clobbering the integer
-	 * provided -- that's our fault recovery, we ignore retval.
-	 */
-	if (acpi_target_sleep_state > ACPI_STATE_S0)
-		acpi_evaluate_integer(handle, acpi_method, NULL, &d_min);
-
-	/*
-	 * If _PRW says we can wake up the system from the target sleep state,
-	 * the D-state returned by _SxD is sufficient for that (we assume a
-	 * wakeup-aware driver if wake is set).  Still, if _SxW exists
-	 * (ACPI 3.x), it should return the maximum (lowest power) D-state that
-	 * can wake the system.  _S0W may be valid, too.
-	 */
-	if (acpi_target_sleep_state == ACPI_STATE_S0 ||
-	    (wake && adev->wakeup.state.enabled &&
-	     adev->wakeup.sleep_state <= acpi_target_sleep_state)) {
-		acpi_method[3] = 'W';
-		acpi_evaluate_integer(handle, acpi_method, NULL, &d_max);
-		/* Sanity check */
-		if (d_max < d_min)
-			d_min = d_max;
-	}
-
-	if (d_min_p)
-		*d_min_p = d_min;
-	return d_max;
-}
-
 /*
  * Toshiba fails to preserve interrupts over S1, reinitialization
  * of 8259 is needed after S1 resume.
diff -puN drivers/pci/pci-acpi.c~acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1 drivers/pci/pci-acpi.c
--- a/drivers/pci/pci-acpi.c~acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1
+++ a/drivers/pci/pci-acpi.c
@@ -245,33 +245,16 @@ EXPORT_SYMBOL(pci_osc_control_set);
  * currently we simply return _SxD, if present.
  */
 
-static pci_power_t acpi_pci_choose_state(struct pci_dev *pdev,
-	pm_message_t state)
+static int acpi_pci_choose_state(struct pci_dev *pdev, pm_message_t state)
 {
-	int acpi_state;
+	/* TBD */
 
-	acpi_state = acpi_pm_device_sleep_state(&pdev->dev,
-		device_may_wakeup(&pdev->dev), NULL);
-	if (acpi_state < 0)
-		return PCI_POWER_ERROR;
-
-	switch (acpi_state) {
-	case ACPI_STATE_D0:
-		return PCI_D0;
-	case ACPI_STATE_D1:
-		return PCI_D1;
-	case ACPI_STATE_D2:
-		return PCI_D2;
-	case ACPI_STATE_D3:
-		return PCI_D3hot;
-	}
-	return PCI_POWER_ERROR;
+	return -ENODEV;
 }
 
 static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 {
 	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
-	acpi_handle tmp;
 	static int state_conv[] = {
 		[0] = 0,
 		[1] = 1,
@@ -283,9 +266,6 @@ static int acpi_pci_set_power_state(stru
 
 	if (!handle)
 		return -ENODEV;
-	/* If the ACPI device has _EJ0, ignore the device */
-	if (ACPI_SUCCESS(acpi_get_handle(handle, "_EJ0", &tmp)))
-		return 0;
 	return acpi_bus_set_power(handle, acpi_state);
 }
 
diff -puN drivers/pci/pci.c~acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1 drivers/pci/pci.c
--- a/drivers/pci/pci.c~acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1
+++ a/drivers/pci/pci.c
@@ -499,7 +499,7 @@ pci_set_power_state(struct pci_dev *dev,
 	return 0;
 }
 
-pci_power_t (*platform_pci_choose_state)(struct pci_dev *dev, pm_message_t state);
+int (*platform_pci_choose_state)(struct pci_dev *dev, pm_message_t state);
  
 /**
  * pci_choose_state - Choose the power state of a PCI device
@@ -513,15 +513,15 @@ pci_power_t (*platform_pci_choose_state)
 
 pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state)
 {
-	pci_power_t ret;
+	int ret;
 
 	if (!pci_find_capability(dev, PCI_CAP_ID_PM))
 		return PCI_D0;
 
 	if (platform_pci_choose_state) {
 		ret = platform_pci_choose_state(dev, state);
-		if (ret != PCI_POWER_ERROR)
-			return ret;
+		if (ret >= 0)
+			state.event = ret;
 	}
 
 	switch (state.event) {
diff -puN drivers/pci/pci.h~acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1 drivers/pci/pci.h
--- a/drivers/pci/pci.h~acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1
+++ a/drivers/pci/pci.h
@@ -7,7 +7,7 @@ extern void pci_remove_sysfs_dev_files(s
 extern void pci_cleanup_rom(struct pci_dev *dev);
 
 /* Firmware callbacks */
-extern pci_power_t (*platform_pci_choose_state)(struct pci_dev *dev, pm_message_t state);
+extern int (*platform_pci_choose_state)(struct pci_dev *dev, pm_message_t state);
 extern int (*platform_pci_set_power_state)(struct pci_dev *dev, pci_power_t state);
 
 extern int pci_user_read_config_byte(struct pci_dev *dev, int where, u8 *val);
diff -puN drivers/pnp/driver.c~acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1 drivers/pnp/driver.c
--- a/drivers/pnp/driver.c~acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1
+++ a/drivers/pnp/driver.c
@@ -167,8 +167,6 @@ static int pnp_bus_suspend(struct device
 	    		return error;
 	}
 
-	if (pnp_dev->protocol && pnp_dev->protocol->suspend)
-		pnp_dev->protocol->suspend(pnp_dev, state);
 	return 0;
 }
 
@@ -181,9 +179,6 @@ static int pnp_bus_resume(struct device 
 	if (!pnp_drv)
 		return 0;
 
-	if (pnp_dev->protocol && pnp_dev->protocol->resume)
-		pnp_dev->protocol->resume(pnp_dev);
-
 	if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE)) {
 		error = pnp_start_dev(pnp_dev);
 		if (error)
diff -puN drivers/pnp/pnpacpi/core.c~acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1 drivers/pnp/pnpacpi/core.c
--- a/drivers/pnp/pnpacpi/core.c~acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1
+++ a/drivers/pnp/pnpacpi/core.c
@@ -119,25 +119,11 @@ static int pnpacpi_disable_resources(str
 	return ACPI_FAILURE(status) ? -ENODEV : 0;
 }
 
-static int pnpacpi_suspend(struct pnp_dev *dev, pm_message_t state)
-{
-	return acpi_bus_set_power((acpi_handle)dev->data,
-		acpi_pm_device_sleep_state(&dev->dev,
-		device_may_wakeup(&dev->dev), NULL));
-}
-
-static int pnpacpi_resume(struct pnp_dev *dev)
-{
-	return acpi_bus_set_power((acpi_handle)dev->data, ACPI_STATE_D0);
-}
-
 static struct pnp_protocol pnpacpi_protocol = {
 	.name	= "Plug and Play ACPI",
 	.get	= pnpacpi_get_resources,
 	.set	= pnpacpi_set_resources,
 	.disable = pnpacpi_disable_resources,
-	.suspend = pnpacpi_suspend,
-	.resume = pnpacpi_resume,
 };
 
 static int __init pnpacpi_add_device(struct acpi_device *device)
diff -puN include/acpi/acpi_bus.h~acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1 include/acpi/acpi_bus.h
--- a/include/acpi/acpi_bus.h~acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1
+++ a/include/acpi/acpi_bus.h
@@ -365,8 +365,6 @@ acpi_handle acpi_get_child(acpi_handle, 
 acpi_handle acpi_get_pci_rootbridge_handle(unsigned int, unsigned int);
 #define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)((dev)->archdata.acpi_handle))
 
-int acpi_pm_device_sleep_state(struct device *, int, int *);
-
 #endif				/* CONFIG_ACPI */
 
 #endif /*__ACPI_BUS_H__*/
diff -puN include/linux/pnp.h~acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1 include/linux/pnp.h
--- a/include/linux/pnp.h~acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1
+++ a/include/linux/pnp.h
@@ -335,10 +335,6 @@ struct pnp_protocol {
 	int (*set)(struct pnp_dev *dev, struct pnp_resource_table *res);
 	int (*disable)(struct pnp_dev *dev);
 
-	/* protocol specific suspend/resume */
-	int (*suspend)(struct pnp_dev *dev, pm_message_t state);
-	int (*resume)(struct pnp_dev *dev);
-
 	/* used by pnp layer only (look but don't touch) */
 	unsigned char		number;		/* protocol number*/
 	struct device		dev;		/* link to driver model */
_

Patches currently in -mm which might be from lenb@kernel.org are

x86_powernow_k8_acpi-must-depend-on-acpi.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
exit-acpi-processor-module-gracefully-if-acpi-is-disabled.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-add-reboot-mechanism.patch
acpi-add-reboot-mechanism-fix.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
x86_64-add-acpi-reboot-option.patch
x86_64-make-acpi-the-default-reset-option.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1.patch
