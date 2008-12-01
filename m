From: akpm@linux-foundation.org
Subject: - pcie-add-option-to-passively-listen-for-pcie-hotplug-events.patch removed from -mm tree
Date: Mon, 01 Dec 2008 14:28:36 -0800
Message-ID: <200812012228.mB1MSaut017431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752269AbYLAW3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 17:29:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg59@srcf.ucam.org, jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pcie: add option to passively listen for PCIE hotplug events
has been removed from the -mm tree.  Its filename was
     pcie-add-option-to-passively-listen-for-pcie-hotplug-events.patch

This patch was dropped because it was folded into pci-uninline-pci_ioremap_bar.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcie: add option to passively listen for PCIE hotplug events
From: Matthew Garrett <mjg59@srcf.ucam.org>

Various pieces of hardware (such as the Acer Aspire One and Asus EEE) use
PCIE hotplug to change the state of devices in response to events such as
the removal of SD cards or disabling the wireless radio.  However, they do
not provide firmware support for this.  As a consequence pciehp will
refuse to load and various things break.

The existing workaround has been to use the pciehp_force option.  This is
undesirable as there is little guarantee that manipulating the power file
in the slot directory will actually result in anything happening, leading
to potential user confusion and hardware damage.  This patch adds a new
option, pciehp_passive.  In this configuration pciehp will listen for
events and notify the PCI core appropriately.  However, it will not
provide any user controllable sysfs attributes and so the risk of
confusion or damage is averted.  Any system slots that do have firmware
support will continue to provide full functionality.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/pciehp_core.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff -puN drivers/pci/hotplug/pciehp_core.c~pcie-add-option-to-passively-listen-for-pcie-hotplug-events drivers/pci/hotplug/pciehp_core.c
--- a/drivers/pci/hotplug/pciehp_core.c~pcie-add-option-to-passively-listen-for-pcie-hotplug-events
+++ a/drivers/pci/hotplug/pciehp_core.c
@@ -41,6 +41,7 @@ int pciehp_debug;
 int pciehp_poll_mode;
 int pciehp_poll_time;
 int pciehp_force;
+int pciehp_passive;
 struct workqueue_struct *pciehp_wq;
 
 #define DRIVER_VERSION	"0.4"
@@ -55,10 +56,12 @@ module_param(pciehp_debug, bool, 0644);
 module_param(pciehp_poll_mode, bool, 0644);
 module_param(pciehp_poll_time, int, 0644);
 module_param(pciehp_force, bool, 0644);
+module_param(pciehp_passive, bool, 0644);
 MODULE_PARM_DESC(pciehp_debug, "Debugging mode enabled or not");
 MODULE_PARM_DESC(pciehp_poll_mode, "Using polling mechanism for hot-plug events or not");
 MODULE_PARM_DESC(pciehp_poll_time, "Polling mechanism frequency, in seconds");
 MODULE_PARM_DESC(pciehp_force, "Force pciehp, even if _OSC and OSHP are missing");
+MODULE_PARM_DESC(pciehp_passive, "Listen for pciehp events, even if _OSC and OSHP are missing");
 
 #define PCIE_MODULE_NAME "pciehp"
 
@@ -85,6 +88,13 @@ static struct hotplug_slot_ops pciehp_ho
   	.get_cur_bus_speed =	get_cur_bus_speed,
 };
 
+static struct hotplug_slot_ops pciehp_passive_hotplug_slot_ops = {
+	.owner =		THIS_MODULE,
+	.get_adapter_status =	get_adapter_status,
+  	.get_max_bus_speed =	get_max_bus_speed,
+  	.get_cur_bus_speed =	get_cur_bus_speed,
+};
+
 /*
  * Check the status of the Electro Mechanical Interlock (EMI)
  */
@@ -212,7 +222,11 @@ static int init_slots(struct controller 
 		hotplug_slot->info = info;
 		hotplug_slot->private = slot;
 		hotplug_slot->release = &release_slot;
-		hotplug_slot->ops = &pciehp_hotplug_slot_ops;
+		if (pciehp_passive &&
+		    pciehp_get_hp_hw_control_from_firmware(ctrl->pci_dev))
+			hotplug_slot->ops = &pciehp_passive_hotplug_slot_ops;
+		else
+			hotplug_slot->ops = &pciehp_hotplug_slot_ops;
 		slot->hotplug_slot = hotplug_slot;
 		snprintf(name, SLOT_NAME_SIZE, "%u", slot->number);
 
@@ -407,7 +421,7 @@ static int pciehp_probe(struct pcie_devi
 	u8 value;
 	struct pci_dev *pdev = dev->port;
 
-	if (pciehp_force)
+	if (pciehp_force || pciehp_passive)
 		dev_info(&dev->device,
 			 "Bypassing BIOS check for pciehp use on %s\n",
 			 pci_name(pdev));
@@ -435,7 +449,7 @@ static int pciehp_probe(struct pcie_devi
 	t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
 
 	t_slot->hpc_ops->get_adapter_status(t_slot, &value); /* Check if slot is occupied */
-	if (value && pciehp_force) {
+	if (value && (pciehp_force || pciehp_passive)) {
 		rc = pciehp_enable_slot(t_slot);
 		if (rc)	/* -ENODEV: shouldn't happen, but deal with it */
 			value = 0;
@@ -474,7 +488,7 @@ static int pciehp_suspend (struct pcie_d
 static int pciehp_resume (struct pcie_device *dev)
 {
 	dev_info(&dev->device, "%s ENTRY\n", __func__);
-	if (pciehp_force) {
+	if (pciehp_force || pciehp_passive) {
 		struct controller *ctrl = get_service_data(dev);
 		struct slot *t_slot;
 		u8 status;
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

linux-next.patch
acpiphp-identify-more-removable-slots.patch
pci-uninline-pci_ioremap_bar.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch
hp-wmi-handle-rfkill_register-failure.patch

