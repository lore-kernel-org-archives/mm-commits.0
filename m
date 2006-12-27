From: akpm@osdl.org
Subject: + pciehp-add-emi-support.patch added to -mm tree
Date: Tue, 26 Dec 2006 23:39:57 -0800
Message-ID: <200612270739.kBR7dvQE004584@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37054 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932970AbWL0HkB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 02:40:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com, greg@kroah.com


The patch titled
     pciehp: add EMI support
has been added to the -mm tree.  Its filename is
     pciehp-add-emi-support.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pciehp: add EMI support
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Add EMI support for PCIE hotplug.  ("Electromechanical Interlock", we think).

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/hotplug/pciehp.h      |    5 +
 drivers/pci/hotplug/pciehp_core.c |   87 ++++++++++++++++++++++++++++
 drivers/pci/hotplug/pciehp_hpc.c  |   55 +++++++++++++++++
 3 files changed, 147 insertions(+)

diff -puN drivers/pci/hotplug/pciehp_core.c~pciehp-add-emi-support drivers/pci/hotplug/pciehp_core.c
--- a/drivers/pci/hotplug/pciehp_core.c~pciehp-add-emi-support
+++ a/drivers/pci/hotplug/pciehp_core.c
@@ -34,6 +34,7 @@
 #include <linux/pci.h>
 #include "pciehp.h"
 #include <linux/interrupt.h>
+#include <linux/time.h>
 
 /* Global variables */
 int pciehp_debug;
@@ -87,6 +88,79 @@ static struct hotplug_slot_ops pciehp_ho
   	.get_cur_bus_speed =	get_cur_bus_speed,
 };
 
+static int get_lock_status(struct hotplug_slot *hotplug_slot, u8 *value)
+{
+	struct slot *slot = hotplug_slot->private;
+	return (slot->hpc_ops->get_emi_status(slot, value));
+}
+
+static ssize_t lock_read_file(struct hotplug_slot *slot, char *buf)
+{
+	int retval;
+	u8 value;
+
+	retval = get_lock_status(slot, &value);
+	if (retval)
+		goto lock_read_exit;
+	retval = sprintf (buf, "%d\n", value);
+
+lock_read_exit:
+	return retval;
+}
+
+static int set_lock_status(struct hotplug_slot *hotplug_slot, u8 status)
+{
+	struct slot *slot = hotplug_slot->private;
+	int retval;
+	u8 value;
+
+	/* has it been >1 sec since our last toggle? */
+	if ((get_seconds() - slot->last_emi_toggle) < 1)
+		return -EINVAL;
+
+	mutex_lock(&slot->ctrl->crit_sect);
+
+	/* see what our current state is */
+	retval = get_lock_status(hotplug_slot, &value);
+	if (retval || (value == status))
+		goto set_lock_exit;
+
+	slot->hpc_ops->toggle_emi(slot);
+set_lock_exit:
+	mutex_unlock(&slot->ctrl->crit_sect);
+	return 0;
+}
+
+static ssize_t lock_write_file(struct hotplug_slot *slot, const char *buf,
+		size_t count)
+{
+	unsigned long llock;
+	u8 lock;
+	int retval = 0;
+
+	llock = simple_strtoul(buf, NULL, 10);
+	lock = (u8)(llock & 0xff);
+
+	switch (lock) {
+		case 0:
+		case 1:
+			retval = set_lock_status(slot, lock);
+			break;
+		default:
+			err ("%d is an invalid lock value\n", lock);
+			retval = -EINVAL;
+	}
+	if (retval)
+		return retval;
+	return count;
+}
+
+static struct hotplug_slot_attribute hotplug_slot_attr_lock = {
+	.attr = {.name = "lock", .mode = S_IFREG | S_IRUGO | S_IWUSR},
+	.show = lock_read_file,
+	.store = lock_write_file
+};
+
 /**
  * release_slot - free up the memory used by a slot
  * @hotplug_slot: slot to free
@@ -159,6 +233,16 @@ static int init_slots(struct controller 
 			err ("pci_hp_register failed with error %d\n", retval);
 			goto error_info;
 		}
+		/* create additional sysfs entries */
+		if (EMI(ctrl->ctrlcap)) {
+			retval = sysfs_create_file(&hotplug_slot->kobj,
+				&hotplug_slot_attr_lock.attr);
+			if (retval) {
+				pci_hp_deregister(hotplug_slot);
+				err("cannot create additional sysfs entries\n");
+				goto error_info;
+			}
+		}
 
 		list_add(&slot->slot_list, &ctrl->slot_list);
 	}
@@ -183,6 +267,9 @@ static void cleanup_slots(struct control
 	list_for_each_safe(tmp, next, &ctrl->slot_list) {
 		slot = list_entry(tmp, struct slot, slot_list);
 		list_del(&slot->slot_list);
+		if (EMI(ctrl->ctrlcap))
+			sysfs_remove_file(&slot->hotplug_slot->kobj,
+				&hotplug_slot_attr_lock.attr);
 		pci_hp_deregister(slot->hotplug_slot);
 	}
 }
diff -puN drivers/pci/hotplug/pciehp.h~pciehp-add-emi-support drivers/pci/hotplug/pciehp.h
--- a/drivers/pci/hotplug/pciehp.h~pciehp-add-emi-support
+++ a/drivers/pci/hotplug/pciehp.h
@@ -69,6 +69,7 @@ struct slot {
 	struct hotplug_slot *hotplug_slot;
 	struct list_head	slot_list;
 	char name[SLOT_NAME_SIZE];
+	unsigned long last_emi_toggle;
 };
 
 struct event_info {
@@ -138,6 +139,7 @@ struct controller {
 #define ATTN_LED_PRSN	0x00000008
 #define PWR_LED_PRSN	0x00000010
 #define HP_SUPR_RM_SUP	0x00000020
+#define EMI_PRSN	0x00020000
 
 #define ATTN_BUTTN(cap)		(cap & ATTN_BUTTN_PRSN)
 #define POWER_CTRL(cap)		(cap & PWR_CTRL_PRSN)
@@ -145,6 +147,7 @@ struct controller {
 #define ATTN_LED(cap)		(cap & ATTN_LED_PRSN)
 #define PWR_LED(cap)		(cap & PWR_LED_PRSN) 
 #define HP_SUPR_RM(cap)		(cap & HP_SUPR_RM_SUP)
+#define EMI(cap)		(cap & EMI_PRSN)
 
 extern int pciehp_event_start_thread(void);
 extern void pciehp_event_stop_thread(void);
@@ -182,6 +185,8 @@ struct hpc_ops {
 	int (*set_attention_status)(struct slot *slot, u8 status);
 	int (*get_latch_status)(struct slot *slot, u8 *status);
 	int (*get_adapter_status)(struct slot *slot, u8 *status);
+	int (*get_emi_status)(struct slot *slot, u8 *status);
+	int (*toggle_emi)(struct slot *slot);
 	int (*get_max_bus_speed)(struct slot *slot, enum pci_bus_speed *speed);
 	int (*get_cur_bus_speed)(struct slot *slot, enum pci_bus_speed *speed);
 	int (*get_max_lnk_width)(struct slot *slot, enum pcie_link_width *val);
diff -puN drivers/pci/hotplug/pciehp_hpc.c~pciehp-add-emi-support drivers/pci/hotplug/pciehp_hpc.c
--- a/drivers/pci/hotplug/pciehp_hpc.c~pciehp-add-emi-support
+++ a/drivers/pci/hotplug/pciehp_hpc.c
@@ -35,6 +35,7 @@
 #include <linux/timer.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
+#include <linux/time.h>
 
 #include "../pci.h"
 #include "pciehp.h"
@@ -192,6 +193,7 @@ static inline int pciehp_writel(struct c
 #define ATTN_LED_CTRL			0x00C0
 #define PWR_LED_CTRL			0x0300
 #define PWR_CTRL			0x0400
+#define EMI_CTRL			0x0800
 
 /* Attention indicator and Power indicator states */
 #define LED_ON		0x01
@@ -202,6 +204,10 @@ static inline int pciehp_writel(struct c
 #define POWER_ON	0
 #define POWER_OFF	0x0400
 
+/* EMI Status defines */
+#define EMI_DISENGAGED	0
+#define EMI_ENGAGED	1
+
 /* Field definitions in Slot Status Register */
 #define ATTN_BUTTN_PRESSED	0x0001
 #define PWR_FAULT_DETECTED	0x0002
@@ -210,6 +216,8 @@ static inline int pciehp_writel(struct c
 #define CMD_COMPLETED		0x0010
 #define MRL_STATE		0x0020
 #define PRSN_STATE		0x0040
+#define EMI_STATE		0x0080
+#define EMI_STATUS_BIT		7
 
 static spinlock_t hpc_event_lock;
 
@@ -474,6 +482,51 @@ static int hpc_query_power_fault(struct 
 	return pwr_fault;
 }
 
+static int hpc_get_emi_status(struct slot *slot, u8 *status)
+{
+	struct controller *ctrl = slot->ctrl;
+	u16 slot_status;
+	int retval = 0;
+
+	DBG_ENTER_ROUTINE
+
+	retval = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
+	if (retval) {
+		err("%s : Cannot check EMI status\n", __FUNCTION__);
+		return retval;
+	}
+	*status = (slot_status & EMI_STATE) >> EMI_STATUS_BIT;
+
+	DBG_LEAVE_ROUTINE
+	return retval;
+}
+
+static int hpc_toggle_emi(struct slot *slot)
+{
+	struct controller *ctrl = slot->ctrl;
+	u16 slot_cmd = 0;
+	u16 slot_ctrl;
+	int rc = 0;
+
+	DBG_ENTER_ROUTINE
+
+	rc = pciehp_readw(ctrl, SLOTCTRL, &slot_ctrl);
+	if (rc) {
+		err("%s : hp_register_read_word SLOT_CTRL failed\n",
+			__FUNCTION__);
+		return rc;
+	}
+
+	slot_cmd = (slot_ctrl | EMI_CTRL);
+	if (!pciehp_poll_mode)
+		slot_cmd = slot_cmd | HP_INTR_ENABLE;
+
+	pcie_write_cmd(slot, slot_cmd);
+	slot->last_emi_toggle = get_seconds();
+	DBG_LEAVE_ROUTINE
+	return rc;
+}
+
 static int hpc_set_attention_status(struct slot *slot, u8 value)
 {
 	struct controller *ctrl = slot->ctrl;
@@ -1009,6 +1062,8 @@ static struct hpc_ops pciehp_hpc_ops = {
 	.get_attention_status		= hpc_get_attention_status,
 	.get_latch_status		= hpc_get_latch_status,
 	.get_adapter_status		= hpc_get_adapter_status,
+	.get_emi_status			= hpc_get_emi_status,
+	.toggle_emi			= hpc_toggle_emi,
 
 	.get_max_bus_speed		= hpc_get_max_lnk_speed,
 	.get_cur_bus_speed		= hpc_get_cur_lnk_speed,
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

git-acpi.patch
git-libata-all.patch
pciehp-cleanup-init_slot.patch
pciehp-cleanup-slot-list.patch
pciehp-remove-unnecessary-php_ctlr.patch
pciehp-remove-unused-pci_bus-from-struct-controller.patch
pciehp-cleanup-register-access.patch
pciehp-cleanup-pciehph.patch
pciehp-remove-unused-pcie_cap_base.patch
pciehp-cleanup-wait-command-completion.patch
pciehp-fix-wait-command-completion.patch
pciehp-add-emi-support.patch

