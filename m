From: akpm@linux-foundation.org
Subject: - pci-introduce-pci_slot.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:37:16 -0700
Message-ID: <200806122037.m5CKbGUC005413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754021AbYFLUx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:53:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: achiang@hp.com, greg@kroah.com, jbarnes@virtuousgeek.org, kaneshige.kenji@jp.fujitsu.com, kristen.c.accardi@intel.com, lenb@kernel.org, matthew@wil.cx, pbadari@us.ibm.com, mm-commits@


The patch titled
     PCI: Introduce pci_slot
has been removed from the -mm tree.  Its filename was
     pci-introduce-pci_slot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PCI: Introduce pci_slot
From: Alex Chiang <achiang@hp.com>

Currently, /sys/bus/pci/slots/ only exposes hotplug attributes when a
hotplug driver is loaded, but PCI slots have attributes such as address,
speed, width, etc.  that are not related to hotplug at all.

Introduce pci_slot as the primary data structure and kobject model.
Hotplug attributes described in hotplug_slot become a secondary
structure associated with the pci_slot.

This patch only creates the infrastructure that allows the separation of
PCI slot attributes and hotplug attributes.  In this patch, the PCI
hotplug core remains the only user of this infrastructure, and thus,
/sys/bus/pci/slots/ will still only become populated when a hotplug
driver is loaded.

A later patch in this series will add a second user of this new
infrastructure and demonstrate splitting the task of exposing pci_slot
attributes from hotplug_slot attributes.

  - Make pci_slot the primary sysfs entity. hotplug_slot becomes a
    subsidiary structure.
    o pci_create_slot() creates and registers a slot with the PCI core
    o pci_slot_add_hotplug() gives it hotplug capability

  - Change the prototype of pci_hp_register() to take the bus and
    slot number (on parent bus) as parameters.

  - Remove all the ->get_address methods since this functionality is
    now handled by pci_slot directly.

[folded in rpaphp-correctly-pci_hp_register-for-empty-pci-slots]
[akpm@linux-foundation.org: build fix]
[akpm@linux-foundation.org: make headers_check happy]
[akpm@linux-foundation.org: nuther build fix]
[akpm@linux-foundation.org: fix typo in #include]
Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Acked-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Tested-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/Makefile                    |    2 
 drivers/pci/hotplug/acpiphp.h           |    1 
 drivers/pci/hotplug/acpiphp_core.c      |   25 --
 drivers/pci/hotplug/acpiphp_glue.c      |   23 -
 drivers/pci/hotplug/acpiphp_ibm.c       |    6 
 drivers/pci/hotplug/cpci_hotplug_core.c |    2 
 drivers/pci/hotplug/cpqphp_core.c       |    4 
 drivers/pci/hotplug/fakephp.c           |    2 
 drivers/pci/hotplug/ibmphp_ebda.c       |    3 
 drivers/pci/hotplug/pci_hotplug_core.c  |  266 ++++++++--------------
 drivers/pci/hotplug/pciehp_core.c       |   32 +-
 drivers/pci/hotplug/rpadlpar_sysfs.c    |    5 
 drivers/pci/hotplug/rpaphp_slot.c       |   44 ---
 drivers/pci/hotplug/sgi_hotplug.c       |   10 
 drivers/pci/hotplug/shpchp_core.c       |   20 -
 drivers/pci/pci.h                       |   13 +
 drivers/pci/probe.c                     |    1 
 drivers/pci/slot.c                      |  224 ++++++++++++++++++
 include/linux/pci.h                     |   19 +
 include/linux/pci_hotplug.h             |   12 
 20 files changed, 414 insertions(+), 300 deletions(-)

diff -puN drivers/pci/Makefile~pci-introduce-pci_slot drivers/pci/Makefile
--- a/drivers/pci/Makefile~pci-introduce-pci_slot
+++ a/drivers/pci/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the PCI bus specific drivers.
 #
 
-obj-y		+= access.o bus.o probe.o remove.o pci.o quirks.o \
+obj-y		+= access.o bus.o probe.o remove.o pci.o quirks.o slot.o \
 			pci-driver.o search.o pci-sysfs.o rom.o setup-res.o
 obj-$(CONFIG_PROC_FS) += proc.o
 
diff -puN drivers/pci/hotplug/acpiphp.h~pci-introduce-pci_slot drivers/pci/hotplug/acpiphp.h
--- a/drivers/pci/hotplug/acpiphp.h~pci-introduce-pci_slot
+++ a/drivers/pci/hotplug/acpiphp.h
@@ -215,7 +215,6 @@ extern u8 acpiphp_get_power_status (stru
 extern u8 acpiphp_get_attention_status (struct acpiphp_slot *slot);
 extern u8 acpiphp_get_latch_status (struct acpiphp_slot *slot);
 extern u8 acpiphp_get_adapter_status (struct acpiphp_slot *slot);
-extern u32 acpiphp_get_address (struct acpiphp_slot *slot);
 
 /* variables */
 extern int acpiphp_debug;
diff -puN drivers/pci/hotplug/acpiphp_core.c~pci-introduce-pci_slot drivers/pci/hotplug/acpiphp_core.c
--- a/drivers/pci/hotplug/acpiphp_core.c~pci-introduce-pci_slot
+++ a/drivers/pci/hotplug/acpiphp_core.c
@@ -70,7 +70,6 @@ static int disable_slot		(struct hotplug
 static int set_attention_status (struct hotplug_slot *slot, u8 value);
 static int get_power_status	(struct hotplug_slot *slot, u8 *value);
 static int get_attention_status (struct hotplug_slot *slot, u8 *value);
-static int get_address		(struct hotplug_slot *slot, u32 *value);
 static int get_latch_status	(struct hotplug_slot *slot, u8 *value);
 static int get_adapter_status	(struct hotplug_slot *slot, u8 *value);
 
@@ -83,7 +82,6 @@ static struct hotplug_slot_ops acpi_hotp
 	.get_attention_status	= get_attention_status,
 	.get_latch_status	= get_latch_status,
 	.get_adapter_status	= get_adapter_status,
-	.get_address		= get_address,
 };
 
 
@@ -274,23 +272,6 @@ static int get_adapter_status(struct hot
 	return 0;
 }
 
-
-/**
- * get_address - get pci address of a slot
- * @hotplug_slot: slot to get status
- * @value: pointer to struct pci_busdev (seg, bus, dev)
- */
-static int get_address(struct hotplug_slot *hotplug_slot, u32 *value)
-{
-	struct slot *slot = hotplug_slot->private;
-
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
-
-	*value = acpiphp_get_address(slot->acpi_slot);
-
-	return 0;
-}
-
 static int __init init_acpi(void)
 {
 	int retval;
@@ -357,7 +338,11 @@ int acpiphp_register_hotplug_slot(struct
 	acpiphp_slot->slot = slot;
 	snprintf(slot->name, sizeof(slot->name), "%u", slot->acpi_slot->sun);
 
-	retval = pci_hp_register(slot->hotplug_slot);
+	retval = pci_hp_register(slot->hotplug_slot,
+					acpiphp_slot->bridge->pci_bus,
+					acpiphp_slot->device);
+	if (retval == -EBUSY)
+		goto error_hpslot;
 	if (retval) {
 		err("pci_hp_register failed with error %d\n", retval);
 		goto error_hpslot;
diff -puN drivers/pci/hotplug/acpiphp_glue.c~pci-introduce-pci_slot drivers/pci/hotplug/acpiphp_glue.c
--- a/drivers/pci/hotplug/acpiphp_glue.c~pci-introduce-pci_slot
+++ a/drivers/pci/hotplug/acpiphp_glue.c
@@ -258,7 +258,12 @@ register_slot(acpi_handle handle, u32 lv
 				bridge->pci_bus->number, slot->device);
 		retval = acpiphp_register_hotplug_slot(slot);
 		if (retval) {
-			warn("acpiphp_register_hotplug_slot failed(err code = 0x%x)\n", retval);
+			if (retval == -EBUSY)
+				warn("Slot %d already registered by another "
+					"hotplug driver\n", slot->sun);
+			else
+				warn("acpiphp_register_hotplug_slot failed "
+					"(err code = 0x%x)\n", retval);
 			goto err_exit;
 		}
 	}
@@ -1867,19 +1872,3 @@ u8 acpiphp_get_adapter_status(struct acp
 
 	return (sta == 0) ? 0 : 1;
 }
-
-
-/*
- * pci address (seg/bus/dev)
- */
-u32 acpiphp_get_address(struct acpiphp_slot *slot)
-{
-	u32 address;
-	struct pci_bus *pci_bus = slot->bridge->pci_bus;
-
-	address = (pci_domain_nr(pci_bus) << 16) |
-		  (pci_bus->number << 8) |
-		  slot->device;
-
-	return address;
-}
diff -puN drivers/pci/hotplug/acpiphp_ibm.c~pci-introduce-pci_slot drivers/pci/hotplug/acpiphp_ibm.c
--- a/drivers/pci/hotplug/acpiphp_ibm.c~pci-introduce-pci_slot
+++ a/drivers/pci/hotplug/acpiphp_ibm.c
@@ -33,8 +33,10 @@
 #include <linux/kobject.h>
 #include <asm/uaccess.h>
 #include <linux/moduleparam.h>
+#include <linux/pci.h>
 
 #include "acpiphp.h"
+#include "../pci.h"
 
 #define DRIVER_VERSION	"1.0.1"
 #define DRIVER_AUTHOR	"Irene Zubarev <zubarev@us.ibm.com>, Vernon Mauery <vernux@us.ibm.com>"
@@ -430,7 +432,7 @@ static int __init ibm_acpiphp_init(void)
 	int retval = 0;
 	acpi_status status;
 	struct acpi_device *device;
-	struct kobject *sysdir = &pci_hotplug_slots_kset->kobj;
+	struct kobject *sysdir = &pci_slots_kset->kobj;
 
 	dbg("%s\n", __func__);
 
@@ -477,7 +479,7 @@ init_return:
 static void __exit ibm_acpiphp_exit(void)
 {
 	acpi_status status;
-	struct kobject *sysdir = &pci_hotplug_slots_kset->kobj;
+	struct kobject *sysdir = &pci_slots_kset->kobj;
 
 	dbg("%s\n", __func__);
 
diff -puN drivers/pci/hotplug/cpci_hotplug_core.c~pci-introduce-pci_slot drivers/pci/hotplug/cpci_hotplug_core.c
--- a/drivers/pci/hotplug/cpci_hotplug_core.c~pci-introduce-pci_slot
+++ a/drivers/pci/hotplug/cpci_hotplug_core.c
@@ -285,7 +285,7 @@ cpci_hp_register_bus(struct pci_bus *bus
 		info->attention_status = cpci_get_attention_status(slot);
 
 		dbg("registering slot %s", slot->hotplug_slot->name);
-		status = pci_hp_register(slot->hotplug_slot);
+		status = pci_hp_register(slot->hotplug_slot, bus, i);
 		if (status) {
 			err("pci_hp_register failed with error %d", status);
 			goto error_name;
diff -puN drivers/pci/hotplug/cpqphp_core.c~pci-introduce-pci_slot drivers/pci/hotplug/cpqphp_core.c
--- a/drivers/pci/hotplug/cpqphp_core.c~pci-introduce-pci_slot
+++ a/drivers/pci/hotplug/cpqphp_core.c
@@ -434,7 +434,9 @@ static int ctrl_slot_setup(struct contro
 				slot->bus, slot->device,
 				slot->number, ctrl->slot_device_offset,
 				slot_number);
-		result = pci_hp_register(hotplug_slot);
+		result = pci_hp_register(hotplug_slot,
+					 ctrl->pci_dev->subordinate,
+					 slot->device);
 		if (result) {
 			err("pci_hp_register failed with error %d\n", result);
 			goto error_name;
diff -puN drivers/pci/hotplug/fakephp.c~pci-introduce-pci_slot drivers/pci/hotplug/fakephp.c
--- a/drivers/pci/hotplug/fakephp.c~pci-introduce-pci_slot
+++ a/drivers/pci/hotplug/fakephp.c
@@ -127,7 +127,7 @@ static int add_slot(struct pci_dev *dev)
 	slot->release = &dummy_release;
 	slot->private = dslot;
 
-	retval = pci_hp_register(slot);
+	retval = pci_hp_register(slot, dev->bus, PCI_SLOT(dev->devfn));
 	if (retval) {
 		err("pci_hp_register failed with error %d\n", retval);
 		goto error_dslot;
diff -puN drivers/pci/hotplug/ibmphp_ebda.c~pci-introduce-pci_slot drivers/pci/hotplug/ibmphp_ebda.c
--- a/drivers/pci/hotplug/ibmphp_ebda.c~pci-introduce-pci_slot
+++ a/drivers/pci/hotplug/ibmphp_ebda.c
@@ -1001,7 +1001,8 @@ static int __init ebda_rsrc_controller (
 		tmp_slot = list_entry (list, struct slot, ibm_slot_list);
 
 		snprintf (tmp_slot->hotplug_slot->name, 30, "%s", create_file_name (tmp_slot));
-		pci_hp_register (tmp_slot->hotplug_slot);
+		pci_hp_register(tmp_slot->hotplug_slot,
+			pci_find_bus(0, tmp_slot->bus), tmp_slot->device);
 	}
 
 	print_ebda_hpc ();
diff -puN drivers/pci/hotplug/pci_hotplug_core.c~pci-introduce-pci_slot drivers/pci/hotplug/pci_hotplug_core.c
--- a/drivers/pci/hotplug/pci_hotplug_core.c~pci-introduce-pci_slot
+++ a/drivers/pci/hotplug/pci_hotplug_core.c
@@ -40,6 +40,7 @@
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
 #include <asm/uaccess.h>
+#include "../pci.h"
 
 #define MY_NAME	"pci_hotplug"
 
@@ -60,41 +61,7 @@ static int debug;
 //////////////////////////////////////////////////////////////////
 
 static LIST_HEAD(pci_hotplug_slot_list);
-
-struct kset *pci_hotplug_slots_kset;
-
-static ssize_t hotplug_slot_attr_show(struct kobject *kobj,
-		struct attribute *attr, char *buf)
-{
-	struct hotplug_slot *slot = to_hotplug_slot(kobj);
-	struct hotplug_slot_attribute *attribute = to_hotplug_attr(attr);
-	return attribute->show ? attribute->show(slot, buf) : -EIO;
-}
-
-static ssize_t hotplug_slot_attr_store(struct kobject *kobj,
-		struct attribute *attr, const char *buf, size_t len)
-{
-	struct hotplug_slot *slot = to_hotplug_slot(kobj);
-	struct hotplug_slot_attribute *attribute = to_hotplug_attr(attr);
-	return attribute->store ? attribute->store(slot, buf, len) : -EIO;
-}
-
-static struct sysfs_ops hotplug_slot_sysfs_ops = {
-	.show = hotplug_slot_attr_show,
-	.store = hotplug_slot_attr_store,
-};
-
-static void hotplug_slot_release(struct kobject *kobj)
-{
-	struct hotplug_slot *slot = to_hotplug_slot(kobj);
-	if (slot->release)
-		slot->release(slot);
-}
-
-static struct kobj_type hotplug_slot_ktype = {
-	.sysfs_ops = &hotplug_slot_sysfs_ops,
-	.release = &hotplug_slot_release,
-};
+static DEFINE_SPINLOCK(pci_hotplug_slot_list_lock);
 
 /* these strings match up with the values in pci_bus_speed */
 static char *pci_bus_speed_strings[] = {
@@ -149,16 +116,15 @@ GET_STATUS(power_status, u8)
 GET_STATUS(attention_status, u8)
 GET_STATUS(latch_status, u8)
 GET_STATUS(adapter_status, u8)
-GET_STATUS(address, u32)
 GET_STATUS(max_bus_speed, enum pci_bus_speed)
 GET_STATUS(cur_bus_speed, enum pci_bus_speed)
 
-static ssize_t power_read_file (struct hotplug_slot *slot, char *buf)
+static ssize_t power_read_file(struct pci_slot *slot, char *buf)
 {
 	int retval;
 	u8 value;
 
-	retval = get_power_status (slot, &value);
+	retval = get_power_status(slot->hotplug, &value);
 	if (retval)
 		goto exit;
 	retval = sprintf (buf, "%d\n", value);
@@ -166,9 +132,10 @@ exit:
 	return retval;
 }
 
-static ssize_t power_write_file (struct hotplug_slot *slot, const char *buf,
+static ssize_t power_write_file(struct pci_slot *pci_slot, const char *buf,
 		size_t count)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	unsigned long lpower;
 	u8 power;
 	int retval = 0;
@@ -204,29 +171,30 @@ exit:	
 	return count;
 }
 
-static struct hotplug_slot_attribute hotplug_slot_attr_power = {
+static struct pci_slot_attribute hotplug_slot_attr_power = {
 	.attr = {.name = "power", .mode = S_IFREG | S_IRUGO | S_IWUSR},
 	.show = power_read_file,
 	.store = power_write_file
 };
 
-static ssize_t attention_read_file (struct hotplug_slot *slot, char *buf)
+static ssize_t attention_read_file(struct pci_slot *slot, char *buf)
 {
 	int retval;
 	u8 value;
 
-	retval = get_attention_status (slot, &value);
+	retval = get_attention_status(slot->hotplug, &value);
 	if (retval)
 		goto exit;
-	retval = sprintf (buf, "%d\n", value);
+	retval = sprintf(buf, "%d\n", value);
 
 exit:
 	return retval;
 }
 
-static ssize_t attention_write_file (struct hotplug_slot *slot, const char *buf,
+static ssize_t attention_write_file(struct pci_slot *slot, const char *buf,
 		size_t count)
 {
+	struct hotplug_slot_ops *ops = slot->hotplug->ops;
 	unsigned long lattention;
 	u8 attention;
 	int retval = 0;
@@ -235,13 +203,13 @@ static ssize_t attention_write_file (str
 	attention = (u8)(lattention & 0xff);
 	dbg (" - attention = %d\n", attention);
 
-	if (!try_module_get(slot->ops->owner)) {
+	if (!try_module_get(ops->owner)) {
 		retval = -ENODEV;
 		goto exit;
 	}
-	if (slot->ops->set_attention_status)
-		retval = slot->ops->set_attention_status(slot, attention);
-	module_put(slot->ops->owner);
+	if (ops->set_attention_status)
+		retval = ops->set_attention_status(slot->hotplug, attention);
+	module_put(ops->owner);
 
 exit:	
 	if (retval)
@@ -249,18 +217,18 @@ exit:	
 	return count;
 }
 
-static struct hotplug_slot_attribute hotplug_slot_attr_attention = {
+static struct pci_slot_attribute hotplug_slot_attr_attention = {
 	.attr = {.name = "attention", .mode = S_IFREG | S_IRUGO | S_IWUSR},
 	.show = attention_read_file,
 	.store = attention_write_file
 };
 
-static ssize_t latch_read_file (struct hotplug_slot *slot, char *buf)
+static ssize_t latch_read_file(struct pci_slot *slot, char *buf)
 {
 	int retval;
 	u8 value;
 
-	retval = get_latch_status (slot, &value);
+	retval = get_latch_status(slot->hotplug, &value);
 	if (retval)
 		goto exit;
 	retval = sprintf (buf, "%d\n", value);
@@ -269,17 +237,17 @@ exit:
 	return retval;
 }
 
-static struct hotplug_slot_attribute hotplug_slot_attr_latch = {
+static struct pci_slot_attribute hotplug_slot_attr_latch = {
 	.attr = {.name = "latch", .mode = S_IFREG | S_IRUGO},
 	.show = latch_read_file,
 };
 
-static ssize_t presence_read_file (struct hotplug_slot *slot, char *buf)
+static ssize_t presence_read_file(struct pci_slot *slot, char *buf)
 {
 	int retval;
 	u8 value;
 
-	retval = get_adapter_status (slot, &value);
+	retval = get_adapter_status(slot->hotplug, &value);
 	if (retval)
 		goto exit;
 	retval = sprintf (buf, "%d\n", value);
@@ -288,42 +256,20 @@ exit:
 	return retval;
 }
 
-static struct hotplug_slot_attribute hotplug_slot_attr_presence = {
+static struct pci_slot_attribute hotplug_slot_attr_presence = {
 	.attr = {.name = "adapter", .mode = S_IFREG | S_IRUGO},
 	.show = presence_read_file,
 };
 
-static ssize_t address_read_file (struct hotplug_slot *slot, char *buf)
-{
-	int retval;
-	u32 address;
-
-	retval = get_address (slot, &address);
-	if (retval)
-		goto exit;
-	retval = sprintf (buf, "%04x:%02x:%02x\n",
-			  (address >> 16) & 0xffff,
-			  (address >> 8) & 0xff,
-			  address & 0xff);
-
-exit:
-	return retval;
-}
-
-static struct hotplug_slot_attribute hotplug_slot_attr_address = {
-	.attr = {.name = "address", .mode = S_IFREG | S_IRUGO},
-	.show = address_read_file,
-};
-
 static char *unknown_speed = "Unknown bus speed";
 
-static ssize_t max_bus_speed_read_file (struct hotplug_slot *slot, char *buf)
+static ssize_t max_bus_speed_read_file(struct pci_slot *slot, char *buf)
 {
 	char *speed_string;
 	int retval;
 	enum pci_bus_speed value;
 	
-	retval = get_max_bus_speed (slot, &value);
+	retval = get_max_bus_speed(slot->hotplug, &value);
 	if (retval)
 		goto exit;
 
@@ -338,18 +284,18 @@ exit:
 	return retval;
 }
 
-static struct hotplug_slot_attribute hotplug_slot_attr_max_bus_speed = {
+static struct pci_slot_attribute hotplug_slot_attr_max_bus_speed = {
 	.attr = {.name = "max_bus_speed", .mode = S_IFREG | S_IRUGO},
 	.show = max_bus_speed_read_file,
 };
 
-static ssize_t cur_bus_speed_read_file (struct hotplug_slot *slot, char *buf)
+static ssize_t cur_bus_speed_read_file(struct pci_slot *slot, char *buf)
 {
 	char *speed_string;
 	int retval;
 	enum pci_bus_speed value;
 
-	retval = get_cur_bus_speed (slot, &value);
+	retval = get_cur_bus_speed(slot->hotplug, &value);
 	if (retval)
 		goto exit;
 
@@ -364,14 +310,15 @@ exit:
 	return retval;
 }
 
-static struct hotplug_slot_attribute hotplug_slot_attr_cur_bus_speed = {
+static struct pci_slot_attribute hotplug_slot_attr_cur_bus_speed = {
 	.attr = {.name = "cur_bus_speed", .mode = S_IFREG | S_IRUGO},
 	.show = cur_bus_speed_read_file,
 };
 
-static ssize_t test_write_file (struct hotplug_slot *slot, const char *buf,
+static ssize_t test_write_file(struct pci_slot *pci_slot, const char *buf,
 		size_t count)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	unsigned long ltest;
 	u32 test;
 	int retval = 0;
@@ -394,13 +341,14 @@ exit:	
 	return count;
 }
 
-static struct hotplug_slot_attribute hotplug_slot_attr_test = {
+static struct pci_slot_attribute hotplug_slot_attr_test = {
 	.attr = {.name = "test", .mode = S_IFREG | S_IRUGO | S_IWUSR},
 	.store = test_write_file
 };
 
-static int has_power_file (struct hotplug_slot *slot)
+static int has_power_file(struct pci_slot *pci_slot)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	if ((!slot) || (!slot->ops))
 		return -ENODEV;
 	if ((slot->ops->enable_slot) ||
@@ -410,8 +358,9 @@ static int has_power_file (struct hotplu
 	return -ENOENT;
 }
 
-static int has_attention_file (struct hotplug_slot *slot)
+static int has_attention_file(struct pci_slot *pci_slot)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	if ((!slot) || (!slot->ops))
 		return -ENODEV;
 	if ((slot->ops->set_attention_status) ||
@@ -420,8 +369,9 @@ static int has_attention_file (struct ho
 	return -ENOENT;
 }
 
-static int has_latch_file (struct hotplug_slot *slot)
+static int has_latch_file(struct pci_slot *pci_slot)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	if ((!slot) || (!slot->ops))
 		return -ENODEV;
 	if (slot->ops->get_latch_status)
@@ -429,8 +379,9 @@ static int has_latch_file (struct hotplu
 	return -ENOENT;
 }
 
-static int has_adapter_file (struct hotplug_slot *slot)
+static int has_adapter_file(struct pci_slot *pci_slot)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	if ((!slot) || (!slot->ops))
 		return -ENODEV;
 	if (slot->ops->get_adapter_status)
@@ -438,17 +389,9 @@ static int has_adapter_file (struct hotp
 	return -ENOENT;
 }
 
-static int has_address_file (struct hotplug_slot *slot)
-{
-	if ((!slot) || (!slot->ops))
-		return -ENODEV;
-	if (slot->ops->get_address)
-		return 0;
-	return -ENOENT;
-}
-
-static int has_max_bus_speed_file (struct hotplug_slot *slot)
+static int has_max_bus_speed_file(struct pci_slot *pci_slot)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	if ((!slot) || (!slot->ops))
 		return -ENODEV;
 	if (slot->ops->get_max_bus_speed)
@@ -456,8 +399,9 @@ static int has_max_bus_speed_file (struc
 	return -ENOENT;
 }
 
-static int has_cur_bus_speed_file (struct hotplug_slot *slot)
+static int has_cur_bus_speed_file(struct pci_slot *pci_slot)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	if ((!slot) || (!slot->ops))
 		return -ENODEV;
 	if (slot->ops->get_cur_bus_speed)
@@ -465,8 +409,9 @@ static int has_cur_bus_speed_file (struc
 	return -ENOENT;
 }
 
-static int has_test_file (struct hotplug_slot *slot)
+static int has_test_file(struct pci_slot *pci_slot)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	if ((!slot) || (!slot->ops))
 		return -ENODEV;
 	if (slot->ops->hardware_test)
@@ -474,7 +419,7 @@ static int has_test_file (struct hotplug
 	return -ENOENT;
 }
 
-static int fs_add_slot (struct hotplug_slot *slot)
+static int fs_add_slot(struct pci_slot *slot)
 {
 	int retval = 0;
 
@@ -505,13 +450,6 @@ static int fs_add_slot (struct hotplug_s
 			goto exit_adapter;
 	}
 
-	if (has_address_file(slot) == 0) {
-		retval = sysfs_create_file(&slot->kobj,
-					   &hotplug_slot_attr_address.attr);
-		if (retval)
-			goto exit_address;
-	}
-
 	if (has_max_bus_speed_file(slot) == 0) {
 		retval = sysfs_create_file(&slot->kobj,
 					   &hotplug_slot_attr_max_bus_speed.attr);
@@ -544,10 +482,6 @@ exit_cur_speed:
 		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_max_bus_speed.attr);
 
 exit_max_speed:
-	if (has_address_file(slot) == 0)
-		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_address.attr);
-
-exit_address:
 	if (has_adapter_file(slot) == 0)
 		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_presence.attr);
 
@@ -567,7 +501,7 @@ exit:
 	return retval;
 }
 
-static void fs_remove_slot (struct hotplug_slot *slot)
+static void fs_remove_slot(struct pci_slot *slot)
 {
 	if (has_power_file(slot) == 0)
 		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_power.attr);
@@ -581,9 +515,6 @@ static void fs_remove_slot (struct hotpl
 	if (has_adapter_file(slot) == 0)
 		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_presence.attr);
 
-	if (has_address_file(slot) == 0)
-		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_address.attr);
-
 	if (has_max_bus_speed_file(slot) == 0)
 		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_max_bus_speed.attr);
 
@@ -599,12 +530,16 @@ static struct hotplug_slot *get_slot_fro
 	struct hotplug_slot *slot;
 	struct list_head *tmp;
 
+	spin_lock(&pci_hotplug_slot_list_lock);
 	list_for_each (tmp, &pci_hotplug_slot_list) {
 		slot = list_entry (tmp, struct hotplug_slot, slot_list);
 		if (strcmp(slot->name, name) == 0)
-			return slot;
+			goto out;
 	}
-	return NULL;
+	slot = NULL;
+out:
+	spin_unlock(&pci_hotplug_slot_list_lock);
+	return slot;
 }
 
 /**
@@ -616,10 +551,10 @@ static struct hotplug_slot *get_slot_fro
  *
  * Returns 0 if successful, anything else for an error.
  */
-int pci_hp_register (struct hotplug_slot *slot)
+int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr)
 {
 	int result;
-	struct hotplug_slot *tmp;
+	struct pci_slot *pci_slot;
 
 	if (slot == NULL)
 		return -ENODEV;
@@ -631,24 +566,28 @@ int pci_hp_register (struct hotplug_slot
 		return -EINVAL;
 	}
 
-	/* Check if we have already registered a slot with the same name. */
-	tmp = get_slot_from_name(slot->name);
-	if (tmp)
-		return -EEXIST;
-
-	slot->kobj.kset = pci_hotplug_slots_kset;
-	result = kobject_init_and_add(&slot->kobj, &hotplug_slot_ktype, NULL,
-				      "%s", slot->name);
-	if (result) {
-		err("Unable to register kobject '%s'", slot->name);
-		return -EINVAL;
-	}
+	pci_slot = pci_create_slot(bus, slot_nr, slot->name);
+	if (IS_ERR(pci_slot))
+		return PTR_ERR(pci_slot);
+
+	if (pci_slot->hotplug) {
+		dbg("%s: already claimed\n", __func__);
+		pci_destroy_slot(pci_slot);
+		return -EBUSY;
+	}
+
+	slot->pci_slot = pci_slot;
+	pci_slot->hotplug = slot;
+
+	spin_lock(&pci_hotplug_slot_list_lock);
+	list_add(&slot->slot_list, &pci_hotplug_slot_list);
+	spin_unlock(&pci_hotplug_slot_list_lock);
+
+	result = fs_add_slot(pci_slot);
+	kobject_uevent(&pci_slot->kobj, KOBJ_ADD);
+	dbg("Added slot %s to the list\n", slot->name);
 
-	list_add (&slot->slot_list, &pci_hotplug_slot_list);
 
-	result = fs_add_slot (slot);
-	kobject_uevent(&slot->kobj, KOBJ_ADD);
-	dbg ("Added slot %s to the list\n", slot->name);
 	return result;
 }
 
@@ -661,22 +600,30 @@ int pci_hp_register (struct hotplug_slot
  *
  * Returns 0 if successful, anything else for an error.
  */
-int pci_hp_deregister (struct hotplug_slot *slot)
+int pci_hp_deregister(struct hotplug_slot *hotplug)
 {
 	struct hotplug_slot *temp;
+	struct pci_slot *slot;
 
-	if (slot == NULL)
+	if (!hotplug)
 		return -ENODEV;
 
-	temp = get_slot_from_name (slot->name);
-	if (temp != slot) {
+	temp = get_slot_from_name(hotplug->name);
+	if (temp != hotplug)
 		return -ENODEV;
-	}
-	list_del (&slot->slot_list);
 
-	fs_remove_slot (slot);
-	dbg ("Removed slot %s from the list\n", slot->name);
-	kobject_put(&slot->kobj);
+	spin_lock(&pci_hotplug_slot_list_lock);
+	list_del(&hotplug->slot_list);
+	spin_unlock(&pci_hotplug_slot_list_lock);
+
+	slot = hotplug->pci_slot;
+	fs_remove_slot(slot);
+	dbg("Removed slot %s from the list\n", hotplug->name);
+
+	hotplug->release(hotplug);
+	slot->hotplug = NULL;
+	pci_destroy_slot(slot);
+
 	return 0;
 }
 
@@ -690,13 +637,15 @@ int pci_hp_deregister (struct hotplug_sl
  *
  * Returns 0 if successful, anything else for an error.
  */
-int __must_check pci_hp_change_slot_info(struct hotplug_slot *slot,
+int __must_check pci_hp_change_slot_info(struct hotplug_slot *hotplug,
 					 struct hotplug_slot_info *info)
 {
-	if ((slot == NULL) || (info == NULL))
+	struct pci_slot *slot;
+	if (!hotplug || !info)
 		return -ENODEV;
+	slot = hotplug->pci_slot;
 
-	memcpy (slot->info, info, sizeof (struct hotplug_slot_info));
+	memcpy(hotplug->info, info, sizeof(struct hotplug_slot_info));
 
 	return 0;
 }
@@ -704,36 +653,22 @@ int __must_check pci_hp_change_slot_info
 static int __init pci_hotplug_init (void)
 {
 	int result;
-	struct kset *pci_bus_kset;
-
-	pci_bus_kset = bus_get_kset(&pci_bus_type);
 
-	pci_hotplug_slots_kset = kset_create_and_add("slots", NULL,
-						     &pci_bus_kset->kobj);
-	if (!pci_hotplug_slots_kset) {
-		result = -ENOMEM;
-		err("Register subsys error\n");
-		goto exit;
-	}
 	result = cpci_hotplug_init(debug);
 	if (result) {
 		err ("cpci_hotplug_init with error %d\n", result);
-		goto err_subsys;
+		goto err_cpci;
 	}
 
 	info (DRIVER_DESC " version: " DRIVER_VERSION "\n");
-	goto exit;
 
-err_subsys:
-	kset_unregister(pci_hotplug_slots_kset);
-exit:
+err_cpci:
 	return result;
 }
 
 static void __exit pci_hotplug_exit (void)
 {
 	cpci_hotplug_exit();
-	kset_unregister(pci_hotplug_slots_kset);
 }
 
 module_init(pci_hotplug_init);
@@ -745,7 +680,6 @@ MODULE_LICENSE("GPL");
 module_param(debug, bool, 0644);
 MODULE_PARM_DESC(debug, "Debugging mode enabled or not");
 
-EXPORT_SYMBOL_GPL(pci_hotplug_slots_kset);
 EXPORT_SYMBOL_GPL(pci_hp_register);
 EXPORT_SYMBOL_GPL(pci_hp_deregister);
 EXPORT_SYMBOL_GPL(pci_hp_change_slot_info);
diff -puN drivers/pci/hotplug/pciehp_core.c~pci-introduce-pci_slot drivers/pci/hotplug/pciehp_core.c
--- a/drivers/pci/hotplug/pciehp_core.c~pci-introduce-pci_slot
+++ a/drivers/pci/hotplug/pciehp_core.c
@@ -72,7 +72,6 @@ static int get_power_status	(struct hotp
 static int get_attention_status	(struct hotplug_slot *slot, u8 *value);
 static int get_latch_status	(struct hotplug_slot *slot, u8 *value);
 static int get_adapter_status	(struct hotplug_slot *slot, u8 *value);
-static int get_address		(struct hotplug_slot *slot, u32 *value);
 static int get_max_bus_speed	(struct hotplug_slot *slot, enum pci_bus_speed *value);
 static int get_cur_bus_speed	(struct hotplug_slot *slot, enum pci_bus_speed *value);
 
@@ -85,7 +84,6 @@ static struct hotplug_slot_ops pciehp_ho
 	.get_attention_status =	get_attention_status,
 	.get_latch_status =	get_latch_status,
 	.get_adapter_status =	get_adapter_status,
-	.get_address =		get_address,
   	.get_max_bus_speed =	get_max_bus_speed,
   	.get_cur_bus_speed =	get_cur_bus_speed,
 };
@@ -252,7 +250,9 @@ static int init_slots(struct controller 
 		dbg("Registering bus=%x dev=%x hp_slot=%x sun=%x "
 		    "slot_device_offset=%x\n", slot->bus, slot->device,
 		    slot->hp_slot, slot->number, ctrl->slot_device_offset);
-		retval = pci_hp_register(hotplug_slot);
+		retval = pci_hp_register(hotplug_slot,
+					 ctrl->pci_dev->subordinate,
+					 slot->device);
 		if (retval) {
 			err("pci_hp_register failed with error %d\n", retval);
 			if (retval == -EEXIST)
@@ -263,7 +263,7 @@ static int init_slots(struct controller 
 		}
 		/* create additional sysfs entries */
 		if (EMI(ctrl)) {
-			retval = sysfs_create_file(&hotplug_slot->kobj,
+			retval = sysfs_create_file(&hotplug_slot->pci_slot->kobj,
 				&hotplug_slot_attr_lock.attr);
 			if (retval) {
 				pci_hp_deregister(hotplug_slot);
@@ -296,7 +296,7 @@ static void cleanup_slots(struct control
 		slot = list_entry(tmp, struct slot, slot_list);
 		list_del(&slot->slot_list);
 		if (EMI(ctrl))
-			sysfs_remove_file(&slot->hotplug_slot->kobj,
+			sysfs_remove_file(&slot->hotplug_slot->pci_slot->kobj,
 				&hotplug_slot_attr_lock.attr);
 		cancel_delayed_work(&slot->work);
 		flush_scheduled_work();
@@ -398,19 +398,8 @@ static int get_adapter_status(struct hot
 	return 0;
 }
 
-static int get_address(struct hotplug_slot *hotplug_slot, u32 *value)
-{
-	struct slot *slot = hotplug_slot->private;
-	struct pci_bus *bus = slot->ctrl->pci_dev->subordinate;
-
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
-
-	*value = (pci_domain_nr(bus) << 16) | (slot->bus << 8) | slot->device;
-
-	return 0;
-}
-
-static int get_max_bus_speed(struct hotplug_slot *hotplug_slot, enum pci_bus_speed *value)
+static int get_max_bus_speed(struct hotplug_slot *hotplug_slot,
+				enum pci_bus_speed *value)
 {
 	struct slot *slot = hotplug_slot->private;
 	int retval;
@@ -474,7 +463,12 @@ static int pciehp_probe(struct pcie_devi
 	/* Setup the slot information structures */
 	rc = init_slots(ctrl);
 	if (rc) {
-		err("%s: slot initialization failed\n", PCIE_MODULE_NAME);
+		if (rc == -EBUSY)
+			warn("%s: slot already registered by another "
+				"hotplug driver\n", PCIE_MODULE_NAME);
+		else
+			err("%s: slot initialization failed\n",
+				PCIE_MODULE_NAME);
 		goto err_out_release_ctlr;
 	}
 
diff -puN drivers/pci/hotplug/rpadlpar_sysfs.c~pci-introduce-pci_slot drivers/pci/hotplug/rpadlpar_sysfs.c
--- a/drivers/pci/hotplug/rpadlpar_sysfs.c~pci-introduce-pci_slot
+++ a/drivers/pci/hotplug/rpadlpar_sysfs.c
@@ -14,8 +14,10 @@
  */
 #include <linux/kobject.h>
 #include <linux/string.h>
+#include <linux/pci.h>
 #include <linux/pci_hotplug.h>
 #include "rpadlpar.h"
+#include "../pci.h"
 
 #define DLPAR_KOBJ_NAME       "control"
 
@@ -27,7 +29,6 @@
 
 #define MAX_DRC_NAME_LEN 64
 
-
 static ssize_t add_slot_store(struct kobject *kobj, struct kobj_attribute *attr,
 			      const char *buf, size_t nbytes)
 {
@@ -112,7 +113,7 @@ int dlpar_sysfs_init(void)
 	int error;
 
 	dlpar_kobj = kobject_create_and_add(DLPAR_KOBJ_NAME,
-					    &pci_hotplug_slots_kset->kobj);
+					    &pci_slots_kset->kobj);
 	if (!dlpar_kobj)
 		return -EINVAL;
 
diff -puN drivers/pci/hotplug/rpaphp_slot.c~pci-introduce-pci_slot drivers/pci/hotplug/rpaphp_slot.c
--- a/drivers/pci/hotplug/rpaphp_slot.c~pci-introduce-pci_slot
+++ a/drivers/pci/hotplug/rpaphp_slot.c
@@ -33,33 +33,6 @@
 #include <asm/rtas.h>
 #include "rpaphp.h"
 
-static ssize_t address_read_file (struct hotplug_slot *php_slot, char *buf)
-{
-	int retval;
-	struct slot *slot = (struct slot *)php_slot->private;
-	struct pci_bus *bus;
-
-	if (!slot)
-		return -ENOENT;
-
-	bus = slot->bus;
-	if (!bus)
-		return -ENOENT;
-
-	if (bus->self)
-		retval = sprintf(buf, pci_name(bus->self));
-	else
-		retval = sprintf(buf, "%04x:%02x:00.0",
-		        pci_domain_nr(bus), bus->number);
-
-	return retval;
-}
-
-static struct hotplug_slot_attribute php_attr_address = {
-	.attr = {.name = "address", .mode = S_IFREG | S_IRUGO},
-	.show = address_read_file,
-};
-
 /* free up the memory used by a slot */
 static void rpaphp_release_slot(struct hotplug_slot *hotplug_slot)
 {
@@ -135,9 +108,6 @@ int rpaphp_deregister_slot(struct slot *
 
 	list_del(&slot->rpaphp_slot_list);
 	
-	/* remove "address" file */
-	sysfs_remove_file(&php_slot->kobj, &php_attr_address.attr);
-
 	retval = pci_hp_deregister(php_slot);
 	if (retval)
 		err("Problem unregistering a slot %s\n", slot->name);
@@ -151,6 +121,7 @@ int rpaphp_register_slot(struct slot *sl
 {
 	struct hotplug_slot *php_slot = slot->hotplug_slot;
 	int retval;
+	int slotno;
 
 	dbg("%s registering slot:path[%s] index[%x], name[%s] pdomain[%x] type[%d]\n", 
 		__func__, slot->dn->full_name, slot->index, slot->name,
@@ -162,19 +133,16 @@ int rpaphp_register_slot(struct slot *sl
 		return -EAGAIN;
 	}	
 
-	retval = pci_hp_register(php_slot);
+	if (slot->dn->child)
+		slotno = PCI_SLOT(PCI_DN(slot->dn->child)->devfn);
+	else
+		slotno = -1;
+	retval = pci_hp_register(php_slot, slot->bus, slotno);
 	if (retval) {
 		err("pci_hp_register failed with error %d\n", retval);
 		return retval;
 	}
 
-	/* create "address" file */
-	retval = sysfs_create_file(&php_slot->kobj, &php_attr_address.attr);
-	if (retval) {
-		err("sysfs_create_file failed with error %d\n", retval);
-		goto sysfs_fail;
-	}
-
 	/* add slot to our internal list */
 	list_add(&slot->rpaphp_slot_list, &rpaphp_slot_head);
 	info("Slot [%s] registered\n", slot->name);
diff -puN drivers/pci/hotplug/sgi_hotplug.c~pci-introduce-pci_slot drivers/pci/hotplug/sgi_hotplug.c
--- a/drivers/pci/hotplug/sgi_hotplug.c~pci-introduce-pci_slot
+++ a/drivers/pci/hotplug/sgi_hotplug.c
@@ -197,13 +197,15 @@ static int sn_hp_slot_private_alloc(stru
 static struct hotplug_slot * sn_hp_destroy(void)
 {
 	struct slot *slot;
+	struct pci_slot *pci_slot;
 	struct hotplug_slot *bss_hotplug_slot = NULL;
 
 	list_for_each_entry(slot, &sn_hp_list, hp_list) {
 		bss_hotplug_slot = slot->hotplug_slot;
+		pci_slot = bss_hotplug_slot->pci_slot;
 		list_del(&((struct slot *)bss_hotplug_slot->private)->
 			 hp_list);
-		sysfs_remove_file(&bss_hotplug_slot->kobj,
+		sysfs_remove_file(&pci_slot->kobj,
 				  &sn_slot_path_attr.attr);
 		break;
 	}
@@ -614,6 +616,7 @@ static void sn_release_slot(struct hotpl
 static int sn_hotplug_slot_register(struct pci_bus *pci_bus)
 {
 	int device;
+	struct pci_slot *pci_slot;
 	struct hotplug_slot *bss_hotplug_slot;
 	int rc = 0;
 
@@ -650,11 +653,12 @@ static int sn_hotplug_slot_register(stru
 		bss_hotplug_slot->ops = &sn_hotplug_slot_ops;
 		bss_hotplug_slot->release = &sn_release_slot;
 
-		rc = pci_hp_register(bss_hotplug_slot);
+		rc = pci_hp_register(bss_hotplug_slot, pci_bus, device);
 		if (rc)
 			goto register_err;
 
-		rc = sysfs_create_file(&bss_hotplug_slot->kobj,
+		pci_slot = bss_hotplug_slot->pci_slot;
+		rc = sysfs_create_file(&pci_slot->kobj,
 				       &sn_slot_path_attr.attr);
 		if (rc)
 			goto register_err;
diff -puN drivers/pci/hotplug/shpchp_core.c~pci-introduce-pci_slot drivers/pci/hotplug/shpchp_core.c
--- a/drivers/pci/hotplug/shpchp_core.c~pci-introduce-pci_slot
+++ a/drivers/pci/hotplug/shpchp_core.c
@@ -68,7 +68,6 @@ static int get_power_status	(struct hotp
 static int get_attention_status	(struct hotplug_slot *slot, u8 *value);
 static int get_latch_status	(struct hotplug_slot *slot, u8 *value);
 static int get_adapter_status	(struct hotplug_slot *slot, u8 *value);
-static int get_address		(struct hotplug_slot *slot, u32 *value);
 static int get_max_bus_speed	(struct hotplug_slot *slot, enum pci_bus_speed *value);
 static int get_cur_bus_speed	(struct hotplug_slot *slot, enum pci_bus_speed *value);
 
@@ -81,7 +80,6 @@ static struct hotplug_slot_ops shpchp_ho
 	.get_attention_status =	get_attention_status,
 	.get_latch_status =	get_latch_status,
 	.get_adapter_status =	get_adapter_status,
-	.get_address =		get_address,
 	.get_max_bus_speed =	get_max_bus_speed,
 	.get_cur_bus_speed =	get_cur_bus_speed,
 };
@@ -159,7 +157,8 @@ static int init_slots(struct controller 
 		dbg("Registering bus=%x dev=%x hp_slot=%x sun=%x "
 		    "slot_device_offset=%x\n", slot->bus, slot->device,
 		    slot->hp_slot, slot->number, ctrl->slot_device_offset);
-		retval = pci_hp_register(slot->hotplug_slot);
+		retval = pci_hp_register(slot->hotplug_slot,
+				ctrl->pci_dev->subordinate, slot->device);
 		if (retval) {
 			err("pci_hp_register failed with error %d\n", retval);
 			if (retval == -EEXIST)
@@ -288,19 +287,8 @@ static int get_adapter_status (struct ho
 	return 0;
 }
 
-static int get_address (struct hotplug_slot *hotplug_slot, u32 *value)
-{
-	struct slot *slot = get_slot(hotplug_slot);
-	struct pci_bus *bus = slot->ctrl->pci_dev->subordinate;
-
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
-
-	*value = (pci_domain_nr(bus) << 16) | (slot->bus << 8) | slot->device;
-
-	return 0;
-}
-
-static int get_max_bus_speed (struct hotplug_slot *hotplug_slot, enum pci_bus_speed *value)
+static int get_max_bus_speed(struct hotplug_slot *hotplug_slot,
+				enum pci_bus_speed *value)
 {
 	struct slot *slot = get_slot(hotplug_slot);
 	int retval;
diff -puN drivers/pci/pci.h~pci-introduce-pci_slot drivers/pci/pci.h
--- a/drivers/pci/pci.h~pci-introduce-pci_slot
+++ a/drivers/pci/pci.h
@@ -106,3 +106,16 @@ pci_match_one_device(const struct pci_de
 }
 
 struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
+
+/* PCI slot sysfs helper code */
+#define to_pci_slot(s) container_of(s, struct pci_slot, kobj)
+
+extern struct kset *pci_slots_kset;
+
+struct pci_slot_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct pci_slot *, char *);
+	ssize_t (*store)(struct pci_slot *, const char *, size_t);
+};
+#define to_pci_slot_attr(s) container_of(s, struct pci_slot_attribute, attr)
+
diff -puN drivers/pci/probe.c~pci-introduce-pci_slot drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-introduce-pci_slot
+++ a/drivers/pci/probe.c
@@ -414,6 +414,7 @@ static struct pci_bus * pci_alloc_bus(vo
 		INIT_LIST_HEAD(&b->node);
 		INIT_LIST_HEAD(&b->children);
 		INIT_LIST_HEAD(&b->devices);
+		INIT_LIST_HEAD(&b->slots);
 	}
 	return b;
 }
diff -puN /dev/null drivers/pci/slot.c
--- /dev/null
+++ a/drivers/pci/slot.c
@@ -0,0 +1,224 @@
+/*
+ * drivers/pci/slot.c
+ * Copyright (C) 2006 Matthew Wilcox <matthew@wil.cx>
+ * Copyright (C) 2006-2008 Hewlett-Packard Development Company, L.P.
+ * 	Alex Chiang <achiang@hp.com>
+ */
+
+#include <linux/kobject.h>
+#include <linux/pci.h>
+#include <linux/err.h>
+#include "pci.h"
+
+struct kset *pci_slots_kset;
+EXPORT_SYMBOL_GPL(pci_slots_kset);
+
+static ssize_t pci_slot_attr_show(struct kobject *kobj,
+					struct attribute *attr, char *buf)
+{
+	struct pci_slot *slot = to_pci_slot(kobj);
+	struct pci_slot_attribute *attribute = to_pci_slot_attr(attr);
+	return attribute->show ? attribute->show(slot, buf) : -EIO;
+}
+
+static ssize_t pci_slot_attr_store(struct kobject *kobj,
+			struct attribute *attr, const char *buf, size_t len)
+{
+	struct pci_slot *slot = to_pci_slot(kobj);
+	struct pci_slot_attribute *attribute = to_pci_slot_attr(attr);
+	return attribute->store ? attribute->store(slot, buf, len) : -EIO;
+}
+
+static struct sysfs_ops pci_slot_sysfs_ops = {
+	.show = pci_slot_attr_show,
+	.store = pci_slot_attr_store,
+};
+
+static ssize_t address_read_file(struct pci_slot *slot, char *buf)
+{
+	if (slot->number == 0xff)
+		return sprintf(buf, "%04x:%02x\n",
+				pci_domain_nr(slot->bus),
+				slot->bus->number);
+	else
+		return sprintf(buf, "%04x:%02x:%02x\n",
+				pci_domain_nr(slot->bus),
+				slot->bus->number,
+				slot->number);
+}
+
+static void pci_slot_release(struct kobject *kobj)
+{
+	struct pci_slot *slot = to_pci_slot(kobj);
+
+	pr_debug("%s: releasing pci_slot on %x:%d\n", __func__,
+		 slot->bus->number, slot->number);
+
+	list_del(&slot->list);
+
+	kfree(slot);
+}
+
+static struct pci_slot_attribute pci_slot_attr_address =
+	__ATTR(address, (S_IFREG | S_IRUGO), address_read_file, NULL);
+
+static struct attribute *pci_slot_default_attrs[] = {
+	&pci_slot_attr_address.attr,
+	NULL,
+};
+
+static struct kobj_type pci_slot_ktype = {
+	.sysfs_ops = &pci_slot_sysfs_ops,
+	.release = &pci_slot_release,
+	.default_attrs = pci_slot_default_attrs,
+};
+
+/**
+ * pci_create_slot - create or increment refcount for physical PCI slot
+ * @parent: struct pci_bus of parent bridge
+ * @slot_nr: PCI_SLOT(pci_dev->devfn) or -1 for placeholder
+ * @name: user visible string presented in /sys/bus/pci/slots/<name>
+ *
+ * PCI slots have first class attributes such as address, speed, width,
+ * and a &struct pci_slot is used to manage them. This interface will
+ * either return a new &struct pci_slot to the caller, or if the pci_slot
+ * already exists, its refcount will be incremented.
+ *
+ * Slots are uniquely identified by a @pci_bus, @slot_nr, @name tuple.
+ *
+ * Placeholder slots:
+ * In most cases, @pci_bus, @slot_nr will be sufficient to uniquely identify
+ * a slot. There is one notable exception - pSeries (rpaphp), where the
+ * @slot_nr cannot be determined until a device is actually inserted into
+ * the slot. In this scenario, the caller may pass -1 for @slot_nr.
+ *
+ * The following semantics are imposed when the caller passes @slot_nr ==
+ * -1. First, the check for existing %struct pci_slot is skipped, as the
+ * caller may know about several unpopulated slots on a given %struct
+ * pci_bus, and each slot would have a @slot_nr of -1.  Uniqueness for
+ * these slots is then determined by the @name parameter. We expect
+ * kobject_init_and_add() to warn us if the caller attempts to create
+ * multiple slots with the same name. The other change in semantics is
+ * user-visible, which is the 'address' parameter presented in sysfs will
+ * consist solely of a dddd:bb tuple, where dddd is the PCI domain of the
+ * %struct pci_bus and bb is the bus number. In other words, the devfn of
+ * the 'placeholder' slot will not be displayed.
+ */
+
+struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
+				 const char *name)
+{
+	struct pci_slot *slot;
+	int err;
+
+	down_write(&pci_bus_sem);
+
+	if (slot_nr == -1)
+		goto placeholder;
+
+	/* If we've already created this slot, bump refcount and return. */
+	list_for_each_entry(slot, &parent->slots, list) {
+		if (slot->number == slot_nr) {
+			kobject_get(&slot->kobj);
+			pr_debug("%s: inc refcount to %d on %04x:%02x:%02x\n",
+				 __func__,
+				 atomic_read(&slot->kobj.kref.refcount),
+				 pci_domain_nr(parent), parent->number,
+				 slot_nr);
+			goto out;
+		}
+	}
+
+placeholder:
+	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
+	if (!slot) {
+		slot = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+
+	slot->bus = parent;
+	slot->number = slot_nr;
+
+	slot->kobj.kset = pci_slots_kset;
+	err = kobject_init_and_add(&slot->kobj, &pci_slot_ktype, NULL,
+				   "%s", name);
+	if (err) {
+		printk(KERN_ERR "Unable to register kobject %s\n", name);
+		goto err;
+	}
+
+	INIT_LIST_HEAD(&slot->list);
+	list_add(&slot->list, &parent->slots);
+
+	/* Don't care if debug printk has a -1 for slot_nr */
+	pr_debug("%s: created pci_slot on %04x:%02x:%02x\n",
+		 __func__, pci_domain_nr(parent), parent->number, slot_nr);
+
+ out:
+	up_write(&pci_bus_sem);
+	return slot;
+ err:
+	kfree(slot);
+	slot = ERR_PTR(err);
+	goto out;
+}
+EXPORT_SYMBOL_GPL(pci_create_slot);
+
+/**
+ * pci_update_slot_number - update %struct pci_slot -> number
+ * @slot - %struct pci_slot to update
+ * @slot_nr - new number for slot
+ *
+ * The primary purpose of this interface is to allow callers who earlier
+ * created a placeholder slot in pci_create_slot() by passing a -1 as
+ * slot_nr, to update their %struct pci_slot with the correct @slot_nr.
+ */
+
+void pci_update_slot_number(struct pci_slot *slot, int slot_nr)
+{
+	down_write(&pci_bus_sem);
+
+	list_for_each_entry(slot, &slot->bus->slots, list)
+		WARN_ON(slot->number == slot_nr);
+
+	slot->number = slot_nr;
+	up_write(&pci_bus_sem);
+}
+EXPORT_SYMBOL_GPL(pci_update_slot_number);
+
+/**
+ * pci_destroy_slot - decrement refcount for physical PCI slot
+ * @slot: struct pci_slot to decrement
+ *
+ * %struct pci_slot is refcounted, so destroying them is really easy; we
+ * just call kobject_put on its kobj and let our release methods do the
+ * rest.
+ */
+
+void pci_destroy_slot(struct pci_slot *slot)
+{
+	pr_debug("%s: dec refcount to %d on %04x:%02x:%02x\n", __func__,
+		 atomic_read(&slot->kobj.kref.refcount) - 1,
+		 pci_domain_nr(slot->bus), slot->bus->number, slot->number);
+
+	down_write(&pci_bus_sem);
+	kobject_put(&slot->kobj);
+	up_write(&pci_bus_sem);
+}
+EXPORT_SYMBOL_GPL(pci_destroy_slot);
+
+static int pci_slot_init(void)
+{
+	struct kset *pci_bus_kset;
+
+	pci_bus_kset = bus_get_kset(&pci_bus_type);
+	pci_slots_kset = kset_create_and_add("slots", NULL,
+						&pci_bus_kset->kobj);
+	if (!pci_slots_kset) {
+		printk(KERN_ERR "PCI: Slot initialization failure\n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+subsys_initcall(pci_slot_init);
diff -puN include/linux/pci.h~pci-introduce-pci_slot include/linux/pci.h
--- a/include/linux/pci.h~pci-introduce-pci_slot
+++ a/include/linux/pci.h
@@ -17,8 +17,7 @@
 #ifndef LINUX_PCI_H
 #define LINUX_PCI_H
 
-/* Include the pci register defines */
-#include <linux/pci_regs.h>
+#include <linux/pci_regs.h>	/* The pci register defines */
 
 /*
  * The PCI interface treats multi-function devices as independent
@@ -49,12 +48,22 @@
 #include <linux/list.h>
 #include <linux/compiler.h>
 #include <linux/errno.h>
+#include <linux/kobject.h>
 #include <asm/atomic.h>
 #include <linux/device.h>
 
 /* Include the ID list */
 #include <linux/pci_ids.h>
 
+/* pci_slot represents a physical slot */
+struct pci_slot {
+	struct pci_bus *bus;		/* The bus this slot is on */
+	struct list_head list;		/* node in list of slots on this bus */
+	struct hotplug_slot *hotplug;	/* Hotplug info (migrate over time) */
+	unsigned char number;		/* PCI_SLOT(pci_dev->devfn) */
+	struct kobject kobj;
+};
+
 /* File state for mmap()s on /proc/bus/pci/X/Y */
 enum pci_mmap_state {
 	pci_mmap_io,
@@ -142,6 +151,7 @@ struct pci_dev {
 
 	void		*sysdata;	/* hook for sys-specific extension */
 	struct proc_dir_entry *procent;	/* device entry in /proc/bus/pci */
+	struct pci_slot	*slot;		/* Physical slot this device is in */
 
 	unsigned int	devfn;		/* encoded device & function index */
 	unsigned short	vendor;
@@ -267,6 +277,7 @@ struct pci_bus {
 	struct list_head children;	/* list of child buses */
 	struct list_head devices;	/* list of devices on this bus */
 	struct pci_dev	*self;		/* bridge device as seen by parent */
+	struct list_head slots;		/* list of slots on this bus */
 	struct resource	*resource[PCI_BUS_NUM_RESOURCES];
 					/* address space routed to this bus */
 
@@ -489,6 +500,10 @@ struct pci_bus *pci_create_bus(struct de
 			       struct pci_ops *ops, void *sysdata);
 struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev,
 				int busnr);
+struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
+				 const char *name);
+void pci_destroy_slot(struct pci_slot *slot);
+void pci_update_slot_number(struct pci_slot *slot, int slot_nr);
 int pci_scan_slot(struct pci_bus *bus, int devfn);
 struct pci_dev *pci_scan_single_device(struct pci_bus *bus, int devfn);
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus);
diff -puN include/linux/pci_hotplug.h~pci-introduce-pci_slot include/linux/pci_hotplug.h
--- a/include/linux/pci_hotplug.h~pci-introduce-pci_slot
+++ a/include/linux/pci_hotplug.h
@@ -95,9 +95,6 @@ struct hotplug_slot_attribute {
  * @get_adapter_status: Called to get see if an adapter is present in the slot or not.
  *	If this field is NULL, the value passed in the struct hotplug_slot_info
  *	will be used when this value is requested by a user.
- * @get_address: Called to get pci address of a slot.
- *	If this field is NULL, the value passed in the struct hotplug_slot_info
- *	will be used when this value is requested by a user.
  * @get_max_bus_speed: Called to get the max bus speed for a slot.
  *	If this field is NULL, the value passed in the struct hotplug_slot_info
  *	will be used when this value is requested by a user.
@@ -120,7 +117,6 @@ struct hotplug_slot_ops {
 	int (*get_attention_status)	(struct hotplug_slot *slot, u8 *value);
 	int (*get_latch_status)		(struct hotplug_slot *slot, u8 *value);
 	int (*get_adapter_status)	(struct hotplug_slot *slot, u8 *value);
-	int (*get_address)		(struct hotplug_slot *slot, u32 *value);
 	int (*get_max_bus_speed)	(struct hotplug_slot *slot, enum pci_bus_speed *value);
 	int (*get_cur_bus_speed)	(struct hotplug_slot *slot, enum pci_bus_speed *value);
 };
@@ -140,7 +136,6 @@ struct hotplug_slot_info {
 	u8	attention_status;
 	u8	latch_status;
 	u8	adapter_status;
-	u32	address;
 	enum pci_bus_speed	max_bus_speed;
 	enum pci_bus_speed	cur_bus_speed;
 };
@@ -166,15 +161,14 @@ struct hotplug_slot {
 
 	/* Variables below this are for use only by the hotplug pci core. */
 	struct list_head		slot_list;
-	struct kobject			kobj;
+	struct pci_slot			*pci_slot;
 };
 #define to_hotplug_slot(n) container_of(n, struct hotplug_slot, kobj)
 
-extern int pci_hp_register		(struct hotplug_slot *slot);
-extern int pci_hp_deregister		(struct hotplug_slot *slot);
+extern int pci_hp_register(struct hotplug_slot *, struct pci_bus *, int nr);
+extern int pci_hp_deregister(struct hotplug_slot *slot);
 extern int __must_check pci_hp_change_slot_info	(struct hotplug_slot *slot,
 						 struct hotplug_slot_info *info);
-extern struct kset *pci_hotplug_slots_kset;
 
 /* PCI Setting Record (Type 0) */
 struct hpp_type0 {
_

Patches currently in -mm which might be from achiang@hp.com are

linux-next.patch
acpi-pci-slot-detection-driver-fix.patch

