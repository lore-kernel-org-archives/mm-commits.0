From: akpm@linux-foundation.org
Subject: + sysfs-kill-unnecessary-attribute-owner.patch added to -mm tree
Date: Tue, 10 Apr 2007 13:47:59 -0700
Message-ID: <200704102048.l3AKm3Fk016967@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44804 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030632AbXDJUst (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 16:48:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, cornelia.huck@de.ibm.com, dipankar@in.ibm.com, greg@kroah.com, maneesh@in.ibm.com


The patch titled
     sysfs: kill unnecessary attribute->owner
has been added to the -mm tree.  Its filename is
     sysfs-kill-unnecessary-attribute-owner.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysfs: kill unnecessary attribute->owner
From: Tejun Heo <htejun@gmail.com>

sysfs is now completely out of driver/module lifetime game.  After deletion, a
sysfs node doesn't access anything outside sysfs proper, so there's no reason
to hold onto the attribute owners.  Note that often the wrong modules were
accounted for as owners leading to accessing removed modules.

This patch kills now unnecessary attribute->owner.  Note that with this
change, userland holding a sysfs node does not prevent the backing module from
being unloaded.

For more info regarding lifetime rule cleanup, please read the following
message.

  http://article.gmane.org/gmane.linux.kernel/510293

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/class.c                        |    2 -
 drivers/base/core.c                         |    4 ---
 drivers/base/firmware_class.c               |    2 -
 drivers/block/pktcdvd.c                     |    3 --
 drivers/char/ipmi/ipmi_msghandler.c         |   10 --------
 drivers/cpufreq/cpufreq_stats.c             |    3 --
 drivers/cpufreq/cpufreq_userspace.c         |    2 -
 drivers/cpufreq/freq_table.c                |    1 
 drivers/firmware/dcdbas.h                   |    3 --
 drivers/firmware/dell_rbu.c                 |    6 ++---
 drivers/firmware/edd.c                      |    2 -
 drivers/firmware/efivars.c                  |    6 ++---
 drivers/i2c/chips/eeprom.c                  |    1 
 drivers/i2c/chips/max6875.c                 |    1 
 drivers/infiniband/core/sysfs.c             |    1 
 drivers/input/mouse/psmouse.h               |    1 
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c |   13 -----------
 drivers/misc/asus-laptop.c                  |    3 --
 drivers/pci/hotplug/acpiphp_ibm.c           |    1 
 drivers/pci/pci-sysfs.c                     |    4 ---
 drivers/pcmcia/socket_sysfs.c               |    2 -
 drivers/rtc/rtc-ds1553.c                    |    1 
 drivers/rtc/rtc-ds1742.c                    |    1 
 drivers/scsi/arcmsr/arcmsr_attr.c           |    3 --
 drivers/scsi/lpfc/lpfc_attr.c               |    2 -
 drivers/scsi/qla2xxx/qla_attr.c             |    6 -----
 drivers/spi/at25.c                          |    1 
 drivers/video/aty/radeon_base.c             |    2 -
 drivers/video/backlight/backlight.c         |    2 -
 drivers/video/backlight/lcd.c               |    2 -
 drivers/w1/slaves/w1_ds2433.c               |    1 
 drivers/w1/slaves/w1_therm.c                |    1 
 drivers/w1/w1.c                             |    2 -
 fs/ecryptfs/main.c                          |    2 -
 fs/ocfs2/cluster/masklog.c                  |    1 
 fs/partitions/check.c                       |    1 
 fs/sysfs/bin.c                              |   19 ++++------------
 fs/sysfs/file.c                             |   21 ++++--------------
 include/linux/sysdev.h                      |    3 --
 include/linux/sysfs.h                       |    7 ++----
 kernel/module.c                             |    9 ++-----
 kernel/params.c                             |    1 
 net/bridge/br_sysfs_br.c                    |    3 --
 net/bridge/br_sysfs_if.c                    |    3 --
 44 files changed, 35 insertions(+), 130 deletions(-)

diff -puN drivers/base/class.c~sysfs-kill-unnecessary-attribute-owner drivers/base/class.c
--- a/drivers/base/class.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/base/class.c
@@ -624,7 +624,6 @@ int class_device_add(struct class_device
 		goto out3;
 	class_dev->uevent_attr.attr.name = "uevent";
 	class_dev->uevent_attr.attr.mode = S_IWUSR;
-	class_dev->uevent_attr.attr.owner = parent_class->owner;
 	class_dev->uevent_attr.store = store_uevent;
 	error = class_device_create_file(class_dev, &class_dev->uevent_attr);
 	if (error)
@@ -639,7 +638,6 @@ int class_device_add(struct class_device
 		}
 		attr->attr.name = "dev";
 		attr->attr.mode = S_IRUGO;
-		attr->attr.owner = parent_class->owner;
 		attr->show = show_dev;
 		error = class_device_create_file(class_dev, attr);
 		if (error) {
diff -puN drivers/base/core.c~sysfs-kill-unnecessary-attribute-owner drivers/base/core.c
--- a/drivers/base/core.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/base/core.c
@@ -622,8 +622,6 @@ int device_add(struct device *dev)
 
 	dev->uevent_attr.attr.name = "uevent";
 	dev->uevent_attr.attr.mode = S_IWUSR;
-	if (dev->driver)
-		dev->uevent_attr.attr.owner = dev->driver->owner;
 	dev->uevent_attr.store = store_uevent;
 	error = device_create_file(dev, &dev->uevent_attr);
 	if (error)
@@ -638,8 +636,6 @@ int device_add(struct device *dev)
 		}
 		attr->attr.name = "dev";
 		attr->attr.mode = S_IRUGO;
-		if (dev->driver)
-			attr->attr.owner = dev->driver->owner;
 		attr->show = show_dev;
 		error = device_create_file(dev, attr);
 		if (error) {
diff -puN drivers/base/firmware_class.c~sysfs-kill-unnecessary-attribute-owner drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/base/firmware_class.c
@@ -271,7 +271,7 @@ out:
 }
 
 static struct bin_attribute firmware_attr_data_tmpl = {
-	.attr = {.name = "data", .mode = 0644, .owner = THIS_MODULE},
+	.attr = {.name = "data", .mode = 0644},
 	.size = 0,
 	.read = firmware_data_read,
 	.write = firmware_data_write,
diff -puN drivers/block/pktcdvd.c~sysfs-kill-unnecessary-attribute-owner drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/block/pktcdvd.c
@@ -146,8 +146,7 @@ static void pkt_kobj_release(struct kobj
  **********************************************************/
 
 #define DEF_ATTR(_obj,_name,_mode) \
-	static struct attribute _obj = { \
-		.name = _name, .owner = THIS_MODULE, .mode = _mode }
+	static struct attribute _obj = { .name = _name, .mode = _mode }
 
 /**********************************************************
   /sys/class/pktcdvd/pktcdvd[0-7]/
diff -puN drivers/char/ipmi/ipmi_msghandler.c~sysfs-kill-unnecessary-attribute-owner drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -2171,52 +2171,42 @@ static int create_files(struct bmc_devic
 	int err;
 
 	bmc->device_id_attr.attr.name = "device_id";
-	bmc->device_id_attr.attr.owner = THIS_MODULE;
 	bmc->device_id_attr.attr.mode = S_IRUGO;
 	bmc->device_id_attr.show = device_id_show;
 
 	bmc->provides_dev_sdrs_attr.attr.name = "provides_device_sdrs";
-	bmc->provides_dev_sdrs_attr.attr.owner = THIS_MODULE;
 	bmc->provides_dev_sdrs_attr.attr.mode = S_IRUGO;
 	bmc->provides_dev_sdrs_attr.show = provides_dev_sdrs_show;
 
 	bmc->revision_attr.attr.name = "revision";
-	bmc->revision_attr.attr.owner = THIS_MODULE;
 	bmc->revision_attr.attr.mode = S_IRUGO;
 	bmc->revision_attr.show = revision_show;
 
 	bmc->firmware_rev_attr.attr.name = "firmware_revision";
-	bmc->firmware_rev_attr.attr.owner = THIS_MODULE;
 	bmc->firmware_rev_attr.attr.mode = S_IRUGO;
 	bmc->firmware_rev_attr.show = firmware_rev_show;
 
 	bmc->version_attr.attr.name = "ipmi_version";
-	bmc->version_attr.attr.owner = THIS_MODULE;
 	bmc->version_attr.attr.mode = S_IRUGO;
 	bmc->version_attr.show = ipmi_version_show;
 
 	bmc->add_dev_support_attr.attr.name = "additional_device_support";
-	bmc->add_dev_support_attr.attr.owner = THIS_MODULE;
 	bmc->add_dev_support_attr.attr.mode = S_IRUGO;
 	bmc->add_dev_support_attr.show = add_dev_support_show;
 
 	bmc->manufacturer_id_attr.attr.name = "manufacturer_id";
-	bmc->manufacturer_id_attr.attr.owner = THIS_MODULE;
 	bmc->manufacturer_id_attr.attr.mode = S_IRUGO;
 	bmc->manufacturer_id_attr.show = manufacturer_id_show;
 
 	bmc->product_id_attr.attr.name = "product_id";
-	bmc->product_id_attr.attr.owner = THIS_MODULE;
 	bmc->product_id_attr.attr.mode = S_IRUGO;
 	bmc->product_id_attr.show = product_id_show;
 
 	bmc->guid_attr.attr.name = "guid";
-	bmc->guid_attr.attr.owner = THIS_MODULE;
 	bmc->guid_attr.attr.mode = S_IRUGO;
 	bmc->guid_attr.show = guid_show;
 
 	bmc->aux_firmware_rev_attr.attr.name = "aux_firmware_revision";
-	bmc->aux_firmware_rev_attr.attr.owner = THIS_MODULE;
 	bmc->aux_firmware_rev_attr.attr.mode = S_IRUGO;
 	bmc->aux_firmware_rev_attr.show = aux_firmware_rev_show;
 
diff -puN drivers/cpufreq/cpufreq_stats.c~sysfs-kill-unnecessary-attribute-owner drivers/cpufreq/cpufreq_stats.c
--- a/drivers/cpufreq/cpufreq_stats.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/cpufreq/cpufreq_stats.c
@@ -25,8 +25,7 @@ static spinlock_t cpufreq_stats_lock;
 
 #define CPUFREQ_STATDEVICE_ATTR(_name,_mode,_show) \
 static struct freq_attr _attr_##_name = {\
-	.attr = {.name = __stringify(_name), .owner = THIS_MODULE, \
-		.mode = _mode, }, \
+	.attr = {.name = __stringify(_name), .mode = _mode, }, \
 	.show = _show,\
 };
 
diff -puN drivers/cpufreq/cpufreq_userspace.c~sysfs-kill-unnecessary-attribute-owner drivers/cpufreq/cpufreq_userspace.c
--- a/drivers/cpufreq/cpufreq_userspace.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/cpufreq/cpufreq_userspace.c
@@ -120,7 +120,7 @@ store_speed (struct cpufreq_policy *poli
 
 static struct freq_attr freq_attr_scaling_setspeed =
 {
-	.attr = { .name = "scaling_setspeed", .mode = 0644, .owner = THIS_MODULE },
+	.attr = { .name = "scaling_setspeed", .mode = 0644 },
 	.show = show_speed,
 	.store = store_speed,
 };
diff -puN drivers/cpufreq/freq_table.c~sysfs-kill-unnecessary-attribute-owner drivers/cpufreq/freq_table.c
--- a/drivers/cpufreq/freq_table.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/cpufreq/freq_table.c
@@ -199,7 +199,6 @@ static ssize_t show_available_freqs (str
 struct freq_attr cpufreq_freq_attr_scaling_available_freqs = {
 	.attr = { .name = "scaling_available_frequencies",
 		  .mode = 0444,
-		  .owner=THIS_MODULE
 		},
 	.show = show_available_freqs,
 };
diff -puN drivers/firmware/dcdbas.h~sysfs-kill-unnecessary-attribute-owner drivers/firmware/dcdbas.h
--- a/drivers/firmware/dcdbas.h~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/firmware/dcdbas.h
@@ -67,8 +67,7 @@
 #define DCDBAS_BIN_ATTR_RW(_name) \
 struct bin_attribute bin_attr_##_name = { \
 	.attr =  { .name = __stringify(_name), \
-		   .mode = 0600, \
-		   .owner = THIS_MODULE }, \
+		   .mode = 0600 }, \
 	.read =  _name##_read, \
 	.write = _name##_write, \
 }
diff -puN drivers/firmware/dell_rbu.c~sysfs-kill-unnecessary-attribute-owner drivers/firmware/dell_rbu.c
--- a/drivers/firmware/dell_rbu.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/firmware/dell_rbu.c
@@ -687,18 +687,18 @@ static ssize_t write_rbu_packet_size(str
 }
 
 static struct bin_attribute rbu_data_attr = {
-	.attr = {.name = "data",.owner = THIS_MODULE,.mode = 0444},
+	.attr = {.name = "data", .mode = 0444},
 	.read = read_rbu_data,
 };
 
 static struct bin_attribute rbu_image_type_attr = {
-	.attr = {.name = "image_type",.owner = THIS_MODULE,.mode = 0644},
+	.attr = {.name = "image_type", .mode = 0644},
 	.read = read_rbu_image_type,
 	.write = write_rbu_image_type,
 };
 
 static struct bin_attribute rbu_packet_size_attr = {
-	.attr = {.name = "packet_size",.owner = THIS_MODULE,.mode = 0644},
+	.attr = {.name = "packet_size", .mode = 0644},
 	.read = read_rbu_packet_size,
 	.write = write_rbu_packet_size,
 };
diff -puN drivers/firmware/edd.c~sysfs-kill-unnecessary-attribute-owner drivers/firmware/edd.c
--- a/drivers/firmware/edd.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/firmware/edd.c
@@ -74,7 +74,7 @@ static struct edd_device *edd_devices[ED
 
 #define EDD_DEVICE_ATTR(_name,_mode,_show,_test) \
 struct edd_attribute edd_attr_##_name = { 	\
-	.attr = {.name = __stringify(_name), .mode = _mode, .owner = THIS_MODULE },	\
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.show	= _show,				\
 	.test	= _test,				\
 };
diff -puN drivers/firmware/efivars.c~sysfs-kill-unnecessary-attribute-owner drivers/firmware/efivars.c
--- a/drivers/firmware/efivars.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/firmware/efivars.c
@@ -131,21 +131,21 @@ struct efivar_attribute {
 
 #define EFI_ATTR(_name, _mode, _show, _store) \
 struct subsys_attribute efi_attr_##_name = { \
-	.attr = {.name = __stringify(_name), .mode = _mode, .owner = THIS_MODULE}, \
+	.attr = {.name = __stringify(_name), .mode = _mode}, \
 	.show = _show, \
 	.store = _store, \
 };
 
 #define EFIVAR_ATTR(_name, _mode, _show, _store) \
 struct efivar_attribute efivar_attr_##_name = { \
-	.attr = {.name = __stringify(_name), .mode = _mode, .owner = THIS_MODULE}, \
+	.attr = {.name = __stringify(_name), .mode = _mode}, \
 	.show = _show, \
 	.store = _store, \
 };
 
 #define VAR_SUBSYS_ATTR(_name, _mode, _show, _store) \
 struct subsys_attribute var_subsys_attr_##_name = { \
-	.attr = {.name = __stringify(_name), .mode = _mode, .owner = THIS_MODULE}, \
+	.attr = {.name = __stringify(_name), .mode = _mode}, \
 	.show = _show, \
 	.store = _store, \
 };
diff -puN drivers/i2c/chips/eeprom.c~sysfs-kill-unnecessary-attribute-owner drivers/i2c/chips/eeprom.c
--- a/drivers/i2c/chips/eeprom.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/i2c/chips/eeprom.c
@@ -143,7 +143,6 @@ static struct bin_attribute eeprom_attr 
 	.attr = {
 		.name = "eeprom",
 		.mode = S_IRUGO,
-		.owner = THIS_MODULE,
 	},
 	.size = EEPROM_SIZE,
 	.read = eeprom_read,
diff -puN drivers/i2c/chips/max6875.c~sysfs-kill-unnecessary-attribute-owner drivers/i2c/chips/max6875.c
--- a/drivers/i2c/chips/max6875.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/i2c/chips/max6875.c
@@ -152,7 +152,6 @@ static struct bin_attribute user_eeprom_
 	.attr = {
 		.name = "eeprom",
 		.mode = S_IRUGO,
-		.owner = THIS_MODULE,
 	},
 	.size = USER_EEPROM_SIZE,
 	.read = max6875_read,
diff -puN drivers/infiniband/core/sysfs.c~sysfs-kill-unnecessary-attribute-owner drivers/infiniband/core/sysfs.c
--- a/drivers/infiniband/core/sysfs.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/infiniband/core/sysfs.c
@@ -479,7 +479,6 @@ alloc_group_attrs(ssize_t (*show)(struct
 
 		element->attr.attr.name  = element->name;
 		element->attr.attr.mode  = S_IRUGO;
-		element->attr.attr.owner = THIS_MODULE;
 		element->attr.show       = show;
 		element->index		 = i;
 
diff -puN drivers/input/mouse/psmouse.h~sysfs-kill-unnecessary-attribute-owner drivers/input/mouse/psmouse.h
--- a/drivers/input/mouse/psmouse.h~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/input/mouse/psmouse.h
@@ -117,7 +117,6 @@ static struct psmouse_attribute psmouse_
 		.attr	= {							\
 			.name	= __stringify(_name),				\
 			.mode	= _mode,					\
-			.owner	= THIS_MODULE,					\
 		},								\
 		.show	= psmouse_attr_show_helper,				\
 		.store	= psmouse_attr_set_helper,				\
diff -puN drivers/media/video/pvrusb2/pvrusb2-sysfs.c~sysfs-kill-unnecessary-attribute-owner drivers/media/video/pvrusb2/pvrusb2-sysfs.c
--- a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
@@ -516,40 +516,32 @@ static void pvr2_sysfs_add_control(struc
 	}
 	sfp->item_last = cip;
 
-	cip->attr_name.attr.owner = THIS_MODULE;
 	cip->attr_name.attr.name = "name";
 	cip->attr_name.attr.mode = S_IRUGO;
 	cip->attr_name.show = fp->show_name;
 
-	cip->attr_type.attr.owner = THIS_MODULE;
 	cip->attr_type.attr.name = "type";
 	cip->attr_type.attr.mode = S_IRUGO;
 	cip->attr_type.show = fp->show_type;
 
-	cip->attr_min.attr.owner = THIS_MODULE;
 	cip->attr_min.attr.name = "min_val";
 	cip->attr_min.attr.mode = S_IRUGO;
 	cip->attr_min.show = fp->show_min;
 
-	cip->attr_max.attr.owner = THIS_MODULE;
 	cip->attr_max.attr.name = "max_val";
 	cip->attr_max.attr.mode = S_IRUGO;
 	cip->attr_max.show = fp->show_max;
 
-	cip->attr_val.attr.owner = THIS_MODULE;
 	cip->attr_val.attr.name = "cur_val";
 	cip->attr_val.attr.mode = S_IRUGO;
 
-	cip->attr_custom.attr.owner = THIS_MODULE;
 	cip->attr_custom.attr.name = "custom_val";
 	cip->attr_custom.attr.mode = S_IRUGO;
 
-	cip->attr_enum.attr.owner = THIS_MODULE;
 	cip->attr_enum.attr.name = "enum_val";
 	cip->attr_enum.attr.mode = S_IRUGO;
 	cip->attr_enum.show = fp->show_enum;
 
-	cip->attr_bits.attr.owner = THIS_MODULE;
 	cip->attr_bits.attr.name = "bit_val";
 	cip->attr_bits.attr.mode = S_IRUGO;
 	cip->attr_bits.show = fp->show_bits;
@@ -614,12 +606,10 @@ static void pvr2_sysfs_add_debugifc(stru
 
 	dip = kzalloc(sizeof(*dip),GFP_KERNEL);
 	if (!dip) return;
-	dip->attr_debugcmd.attr.owner = THIS_MODULE;
 	dip->attr_debugcmd.attr.name = "debugcmd";
 	dip->attr_debugcmd.attr.mode = S_IRUGO|S_IWUSR|S_IWGRP;
 	dip->attr_debugcmd.show = debugcmd_show;
 	dip->attr_debugcmd.store = debugcmd_store;
-	dip->attr_debuginfo.attr.owner = THIS_MODULE;
 	dip->attr_debuginfo.attr.name = "debuginfo";
 	dip->attr_debuginfo.attr.mode = S_IRUGO;
 	dip->attr_debuginfo.show = debuginfo_show;
@@ -795,7 +785,6 @@ static void class_dev_create(struct pvr2
 		return;
 	}
 
-	sfp->attr_v4l_minor_number.attr.owner = THIS_MODULE;
 	sfp->attr_v4l_minor_number.attr.name = "v4l_minor_number";
 	sfp->attr_v4l_minor_number.attr.mode = S_IRUGO;
 	sfp->attr_v4l_minor_number.show = v4l_minor_number_show;
@@ -809,7 +798,6 @@ static void class_dev_create(struct pvr2
 		sfp->v4l_minor_number_created_ok = !0;
 	}
 
-	sfp->attr_v4l_radio_minor_number.attr.owner = THIS_MODULE;
 	sfp->attr_v4l_radio_minor_number.attr.name = "v4l_radio_minor_number";
 	sfp->attr_v4l_radio_minor_number.attr.mode = S_IRUGO;
 	sfp->attr_v4l_radio_minor_number.show = v4l_radio_minor_number_show;
@@ -823,7 +811,6 @@ static void class_dev_create(struct pvr2
 		sfp->v4l_radio_minor_number_created_ok = !0;
 	}
 
-	sfp->attr_unit_number.attr.owner = THIS_MODULE;
 	sfp->attr_unit_number.attr.name = "unit_number";
 	sfp->attr_unit_number.attr.mode = S_IRUGO;
 	sfp->attr_unit_number.show = unit_number_show;
diff -puN drivers/misc/asus-laptop.c~sysfs-kill-unnecessary-attribute-owner drivers/misc/asus-laptop.c
--- a/drivers/misc/asus-laptop.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/misc/asus-laptop.c
@@ -695,8 +695,7 @@ static void asus_hotk_notify(acpi_handle
 	struct device_attribute dev_attr_##_name = {			\
 		.attr = {						\
 			.name = __stringify(_name),			\
-			.mode = 0,					\
-			.owner = THIS_MODULE },				\
+			.mode = 0 },					\
 		.show   = NULL,						\
 		.store  = NULL,						\
 	}
diff -puN drivers/pci/hotplug/acpiphp_ibm.c~sysfs-kill-unnecessary-attribute-owner drivers/pci/hotplug/acpiphp_ibm.c
--- a/drivers/pci/hotplug/acpiphp_ibm.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/pci/hotplug/acpiphp_ibm.c
@@ -117,7 +117,6 @@ static struct notification ibm_note;
 static struct bin_attribute ibm_apci_table_attr = {
 	    .attr = {
 		    .name = "apci_table",
-		    .owner = THIS_MODULE,
 		    .mode = S_IRUGO,
 	    },
 	    .read = ibm_read_apci_table,
diff -puN drivers/pci/pci-sysfs.c~sysfs-kill-unnecessary-attribute-owner drivers/pci/pci-sysfs.c
--- a/drivers/pci/pci-sysfs.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/pci/pci-sysfs.c
@@ -499,7 +499,6 @@ static int pci_create_resource_files(str
 			sprintf(res_attr_name, "resource%d", i);
 			res_attr->attr.name = res_attr_name;
 			res_attr->attr.mode = S_IRUSR | S_IWUSR;
-			res_attr->attr.owner = THIS_MODULE;
 			res_attr->size = pci_resource_len(pdev, i);
 			res_attr->mmap = pci_mmap_resource;
 			res_attr->private = &pdev->resource[i];
@@ -582,7 +581,6 @@ static struct bin_attribute pci_config_a
 	.attr =	{
 		.name = "config",
 		.mode = S_IRUGO | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 256,
 	.read = pci_read_config,
@@ -593,7 +591,6 @@ static struct bin_attribute pcie_config_
 	.attr =	{
 		.name = "config",
 		.mode = S_IRUGO | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 4096,
 	.read = pci_read_config,
@@ -628,7 +625,6 @@ int __must_check pci_create_sysfs_dev_fi
 			rom_attr->size = pci_resource_len(pdev, PCI_ROM_RESOURCE);
 			rom_attr->attr.name = "rom";
 			rom_attr->attr.mode = S_IRUSR;
-			rom_attr->attr.owner = THIS_MODULE;
 			rom_attr->read = pci_read_rom;
 			rom_attr->write = pci_write_rom;
 			retval = sysfs_create_bin_file(&pdev->dev.kobj, rom_attr);
diff -puN drivers/pcmcia/socket_sysfs.c~sysfs-kill-unnecessary-attribute-owner drivers/pcmcia/socket_sysfs.c
--- a/drivers/pcmcia/socket_sysfs.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/pcmcia/socket_sysfs.c
@@ -367,7 +367,7 @@ static struct device_attribute *pccard_s
 };
 
 static struct bin_attribute pccard_cis_attr = {
-	.attr = { .name = "cis", .mode = S_IRUGO | S_IWUSR, .owner = THIS_MODULE},
+	.attr = { .name = "cis", .mode = S_IRUGO | S_IWUSR },
 	.size = 0x200,
 	.read = pccard_show_cis,
 	.write = pccard_store_cis,
diff -puN drivers/rtc/rtc-ds1553.c~sysfs-kill-unnecessary-attribute-owner drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/rtc/rtc-ds1553.c
@@ -290,7 +290,6 @@ static struct bin_attribute ds1553_nvram
 	.attr = {
 		.name = "nvram",
 		.mode = S_IRUGO | S_IWUGO,
-		.owner = THIS_MODULE,
 	},
 	.size = RTC_OFFSET,
 	.read = ds1553_nvram_read,
diff -puN drivers/rtc/rtc-ds1742.c~sysfs-kill-unnecessary-attribute-owner drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/rtc/rtc-ds1742.c
@@ -159,7 +159,6 @@ static struct bin_attribute ds1742_nvram
 	.attr = {
 		.name = "nvram",
 		.mode = S_IRUGO | S_IWUGO,
-		.owner = THIS_MODULE,
 	},
 	.read = ds1742_nvram_read,
 	.write = ds1742_nvram_write,
diff -puN drivers/scsi/arcmsr/arcmsr_attr.c~sysfs-kill-unnecessary-attribute-owner drivers/scsi/arcmsr/arcmsr_attr.c
--- a/drivers/scsi/arcmsr/arcmsr_attr.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -189,7 +189,6 @@ static struct bin_attribute arcmsr_sysfs
 	.attr = {
 		.name = "mu_read",
 		.mode = S_IRUSR ,
-		.owner = THIS_MODULE,
 	},
 	.size = 1032,
 	.read = arcmsr_sysfs_iop_message_read,
@@ -199,7 +198,6 @@ static struct bin_attribute arcmsr_sysfs
 	.attr = {
 		.name = "mu_write",
 		.mode = S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 1032,
 	.write = arcmsr_sysfs_iop_message_write,
@@ -209,7 +207,6 @@ static struct bin_attribute arcmsr_sysfs
 	.attr = {
 		.name = "mu_clear",
 		.mode = S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 1,
 	.write = arcmsr_sysfs_iop_message_clear,
diff -puN drivers/scsi/lpfc/lpfc_attr.c~sysfs-kill-unnecessary-attribute-owner drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/scsi/lpfc/lpfc_attr.c
@@ -1145,7 +1145,6 @@ static struct bin_attribute sysfs_ctlreg
 	.attr = {
 		.name = "ctlreg",
 		.mode = S_IRUSR | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 256,
 	.read = sysfs_ctlreg_read,
@@ -1356,7 +1355,6 @@ static struct bin_attribute sysfs_mbox_a
 	.attr = {
 		.name = "mbox",
 		.mode = S_IRUSR | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = sizeof(MAILBOX_t),
 	.read = sysfs_mbox_read,
diff -puN drivers/scsi/qla2xxx/qla_attr.c~sysfs-kill-unnecessary-attribute-owner drivers/scsi/qla2xxx/qla_attr.c
--- a/drivers/scsi/qla2xxx/qla_attr.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/scsi/qla2xxx/qla_attr.c
@@ -73,7 +73,6 @@ static struct bin_attribute sysfs_fw_dum
 	.attr = {
 		.name = "fw_dump",
 		.mode = S_IRUSR | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 0,
 	.read = qla2x00_sysfs_read_fw_dump,
@@ -149,7 +148,6 @@ static struct bin_attribute sysfs_nvram_
 	.attr = {
 		.name = "nvram",
 		.mode = S_IRUSR | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 512,
 	.read = qla2x00_sysfs_read_nvram,
@@ -198,7 +196,6 @@ static struct bin_attribute sysfs_optrom
 	.attr = {
 		.name = "optrom",
 		.mode = S_IRUSR | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = OPTROM_SIZE_24XX,
 	.read = qla2x00_sysfs_read_optrom,
@@ -279,7 +276,6 @@ static struct bin_attribute sysfs_optrom
 	.attr = {
 		.name = "optrom_ctl",
 		.mode = S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 0,
 	.write = qla2x00_sysfs_write_optrom_ctl,
@@ -327,7 +323,6 @@ static struct bin_attribute sysfs_vpd_at
 	.attr = {
 		.name = "vpd",
 		.mode = S_IRUSR | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 0,
 	.read = qla2x00_sysfs_read_vpd,
@@ -375,7 +370,6 @@ static struct bin_attribute sysfs_sfp_at
 	.attr = {
 		.name = "sfp",
 		.mode = S_IRUSR | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = SFP_DEV_SIZE * 2,
 	.read = qla2x00_sysfs_read_sfp,
diff -puN drivers/spi/at25.c~sysfs-kill-unnecessary-attribute-owner drivers/spi/at25.c
--- a/drivers/spi/at25.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/spi/at25.c
@@ -314,7 +314,6 @@ static int at25_probe(struct spi_device 
 	 */
 	at25->bin.attr.name = "eeprom";
 	at25->bin.attr.mode = S_IRUSR;
-	at25->bin.attr.owner = THIS_MODULE;
 	at25->bin.read = at25_bin_read;
 
 	at25->bin.size = at25->chip.byte_len;
diff -puN drivers/video/aty/radeon_base.c~sysfs-kill-unnecessary-attribute-owner drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/video/aty/radeon_base.c
@@ -2123,7 +2123,6 @@ static ssize_t radeon_show_edid2(struct 
 static struct bin_attribute edid1_attr = {
 	.attr   = {
 		.name	= "edid1",
-		.owner	= THIS_MODULE,
 		.mode	= 0444,
 	},
 	.size	= EDID_LENGTH,
@@ -2133,7 +2132,6 @@ static struct bin_attribute edid1_attr =
 static struct bin_attribute edid2_attr = {
 	.attr   = {
 		.name	= "edid2",
-		.owner	= THIS_MODULE,
 		.mode	= 0444,
 	},
 	.size	= EDID_LENGTH,
diff -puN drivers/video/backlight/backlight.c~sysfs-kill-unnecessary-attribute-owner drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/video/backlight/backlight.c
@@ -172,7 +172,7 @@ static struct class backlight_class = {
 
 #define DECLARE_ATTR(_name,_mode,_show,_store)			\
 {							 	\
-	.attr	= { .name = __stringify(_name), .mode = _mode, .owner = THIS_MODULE },	\
+	.attr	= { .name = __stringify(_name), .mode = _mode }, \
 	.show	= _show,					\
 	.store	= _store,					\
 }
diff -puN drivers/video/backlight/lcd.c~sysfs-kill-unnecessary-attribute-owner drivers/video/backlight/lcd.c
--- a/drivers/video/backlight/lcd.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/video/backlight/lcd.c
@@ -157,7 +157,7 @@ static struct class lcd_class = {
 
 #define DECLARE_ATTR(_name,_mode,_show,_store)			\
 {							 	\
-	.attr	= { .name = __stringify(_name), .mode = _mode, .owner = THIS_MODULE },	\
+	.attr	= { .name = __stringify(_name), .mode = _mode }, \
 	.show	= _show,					\
 	.store	= _store,					\
 }
diff -puN drivers/w1/slaves/w1_ds2433.c~sysfs-kill-unnecessary-attribute-owner drivers/w1/slaves/w1_ds2433.c
--- a/drivers/w1/slaves/w1_ds2433.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/w1/slaves/w1_ds2433.c
@@ -252,7 +252,6 @@ static struct bin_attribute w1_f23_bin_a
 	.attr = {
 		.name = "eeprom",
 		.mode = S_IRUGO | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = W1_EEPROM_SIZE,
 	.read = w1_f23_read_bin,
diff -puN drivers/w1/slaves/w1_therm.c~sysfs-kill-unnecessary-attribute-owner drivers/w1/slaves/w1_therm.c
--- a/drivers/w1/slaves/w1_therm.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/w1/slaves/w1_therm.c
@@ -48,7 +48,6 @@ static struct bin_attribute w1_therm_bin
 	.attr = {
 		.name = "w1_slave",
 		.mode = S_IRUGO,
-		.owner = THIS_MODULE,
 	},
 	.size = W1_SLAVE_DATA_SIZE,
 	.read = w1_therm_read_bin,
diff -puN drivers/w1/w1.c~sysfs-kill-unnecessary-attribute-owner drivers/w1/w1.c
--- a/drivers/w1/w1.c~sysfs-kill-unnecessary-attribute-owner
+++ a/drivers/w1/w1.c
@@ -128,7 +128,6 @@ static struct bin_attribute w1_slave_att
       .attr = {
               .name = "id",
               .mode = S_IRUGO,
-              .owner = THIS_MODULE,
       },
       .size = 8,
       .read = w1_slave_read_id,
@@ -167,7 +166,6 @@ static struct bin_attribute w1_default_a
       .attr = {
               .name = "rw",
               .mode = S_IRUGO | S_IWUSR,
-              .owner = THIS_MODULE,
       },
       .size = PAGE_SIZE,
       .read = w1_default_read,
diff -puN fs/ecryptfs/main.c~sysfs-kill-unnecessary-attribute-owner fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~sysfs-kill-unnecessary-attribute-owner
+++ a/fs/ecryptfs/main.c
@@ -842,8 +842,6 @@ static int __init ecryptfs_init(void)
 		goto out;
 	}
 	kset_set_kset_s(&ecryptfs_subsys, fs_subsys);
-	sysfs_attr_version.attr.owner = THIS_MODULE;
-	sysfs_attr_version_str.attr.owner = THIS_MODULE;
 	rc = do_sysfs_registration();
 	if (rc) {
 		printk(KERN_ERR "sysfs registration failed\n");
diff -puN fs/ocfs2/cluster/masklog.c~sysfs-kill-unnecessary-attribute-owner fs/ocfs2/cluster/masklog.c
--- a/fs/ocfs2/cluster/masklog.c~sysfs-kill-unnecessary-attribute-owner
+++ a/fs/ocfs2/cluster/masklog.c
@@ -74,7 +74,6 @@ struct mlog_attribute {
 #define define_mask(_name) {			\
 	.attr = {				\
 		.name = #_name,			\
-		.owner = THIS_MODULE,		\
 		.mode = S_IRUGO | S_IWUSR,	\
 	},					\
 	.mask = ML_##_name,			\
diff -puN fs/partitions/check.c~sysfs-kill-unnecessary-attribute-owner fs/partitions/check.c
--- a/fs/partitions/check.c~sysfs-kill-unnecessary-attribute-owner
+++ a/fs/partitions/check.c
@@ -393,7 +393,6 @@ void add_partition(struct gendisk *disk,
 		static struct attribute addpartattr = {
 			.name = "whole_disk",
 			.mode = S_IRUSR | S_IRGRP | S_IROTH,
-			.owner = THIS_MODULE,
 		};
 
 		sysfs_create_file(&p->kobj, &addpartattr);
diff -puN fs/sysfs/bin.c~sysfs-kill-unnecessary-attribute-owner fs/sysfs/bin.c
--- a/fs/sysfs/bin.c~sysfs-kill-unnecessary-attribute-owner
+++ a/fs/sysfs/bin.c
@@ -175,25 +175,20 @@ static int open(struct inode * inode, st
 	if (!sysfs_get_active(attr_sd))
 		return -ENODEV;
 
-	/* Grab the module reference for this attribute */
-	error = -ENODEV;
-	if (!try_module_get(attr->attr.owner))
-		goto err_sput;
-
 	error = -EACCES;
 	if ((file->f_mode & FMODE_WRITE) && !(attr->write || attr->mmap))
-		goto err_mput;
+		goto err_out;
 	if ((file->f_mode & FMODE_READ) && !(attr->read || attr->mmap))
-		goto err_mput;
+		goto err_out;
 
 	error = -ENOMEM;
 	bb = kzalloc(sizeof(*bb), GFP_KERNEL);
 	if (!bb)
-		goto err_mput;
+		goto err_out;
 
 	bb->buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!bb->buffer)
-		goto err_mput;
+		goto err_out;
 
 	mutex_init(&bb->mutex);
 	file->private_data = bb;
@@ -203,9 +198,7 @@ static int open(struct inode * inode, st
 	sysfs_get(attr_sd);
 	return 0;
 
- err_mput:
-	module_put(attr->attr.owner);
- err_sput:
+ err_out:
 	sysfs_put_active(attr_sd);
 	kfree(bb);
 	return error;
@@ -214,13 +207,11 @@ static int open(struct inode * inode, st
 static int release(struct inode * inode, struct file * file)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
 	struct bin_buffer *bb = file->private_data;
 
 	if (bb->mmapped)
 		sysfs_put_active_two(attr_sd);
 	sysfs_put(attr_sd);
-	module_put(attr->attr.owner);
 	kfree(bb->buffer);
 	kfree(bb);
 	return 0;
diff -puN fs/sysfs/file.c~sysfs-kill-unnecessary-attribute-owner fs/sysfs/file.c
--- a/fs/sysfs/file.c~sysfs-kill-unnecessary-attribute-owner
+++ a/fs/sysfs/file.c
@@ -271,7 +271,6 @@ sysfs_write_file(struct file *file, cons
 static int sysfs_open_file(struct inode *inode, struct file *file)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct attribute *attr = attr_sd->s_elem.attr.attr;
 	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
 	struct sysfs_buffer * buffer;
 	struct sysfs_ops * ops = NULL;
@@ -281,11 +280,6 @@ static int sysfs_open_file(struct inode 
 	if (!sysfs_get_active_two(attr_sd))
 		return -ENODEV;
 
-	/* Grab the module reference for this attribute */
-	error = -ENODEV;
-	if (!try_module_get(attr->owner))
-		goto err_sput;
-
 	/* if the kobject has no ktype, then we assume that it is a subsystem
 	 * itself, and use ops for it.
 	 */
@@ -302,7 +296,7 @@ static int sysfs_open_file(struct inode 
 	 * or the subsystem have no operations.
 	 */
 	if (!ops)
-		goto err_mput;
+		goto err_out;
 
 	/* File needs write support.
 	 * The inode's perms must say it's ok, 
@@ -310,7 +304,7 @@ static int sysfs_open_file(struct inode 
 	 */
 	if (file->f_mode & FMODE_WRITE) {
 		if (!(inode->i_mode & S_IWUGO) || !ops->store)
-			goto err_mput;
+			goto err_out;
 	}
 
 	/* File needs read support.
@@ -319,7 +313,7 @@ static int sysfs_open_file(struct inode 
 	 */
 	if (file->f_mode & FMODE_READ) {
 		if (!(inode->i_mode & S_IRUGO) || !ops->show)
-			goto err_mput;
+			goto err_out;
 	}
 
 	/* No error? Great, allocate a buffer for the file, and store it
@@ -328,7 +322,7 @@ static int sysfs_open_file(struct inode 
 	error = -ENOMEM;
 	buffer = kzalloc(sizeof(struct sysfs_buffer), GFP_KERNEL);
 	if (!buffer)
-		goto err_mput;
+		goto err_out;
 
 	init_MUTEX(&buffer->sem);
 	buffer->needs_read_fill = 1;
@@ -340,9 +334,7 @@ static int sysfs_open_file(struct inode 
 	sysfs_get(attr_sd);
 	return 0;
 
- err_mput:
-	module_put(attr->owner);
- err_sput:
+ err_out:
 	sysfs_put_active_two(attr_sd);
 	return error;
 }
@@ -350,12 +342,9 @@ static int sysfs_open_file(struct inode 
 static int sysfs_release(struct inode * inode, struct file * filp)
 {
 	struct sysfs_dirent *attr_sd = filp->f_path.dentry->d_fsdata;
-	struct attribute *attr = attr_sd->s_elem.attr.attr;
 	struct sysfs_buffer *buffer = filp->private_data;
 
 	sysfs_put(attr_sd);
-	/* After this point, attr should not be accessed. */
-	module_put(attr->owner);
 
 	if (buffer) {
 		if (buffer->page)
diff -puN include/linux/sysdev.h~sysfs-kill-unnecessary-attribute-owner include/linux/sysdev.h
--- a/include/linux/sysdev.h~sysfs-kill-unnecessary-attribute-owner
+++ a/include/linux/sysdev.h
@@ -100,8 +100,7 @@ struct sysdev_attribute { 
 
 #define _SYSDEV_ATTR(_name,_mode,_show,_store)			\
 {								\
-	.attr = { .name = __stringify(_name), .mode = _mode,	\
-		 .owner = THIS_MODULE },			\
+	.attr = { .name = __stringify(_name), .mode = _mode },	\
 	.show	= _show,					\
 	.store	= _store,					\
 }
diff -puN include/linux/sysfs.h~sysfs-kill-unnecessary-attribute-owner include/linux/sysfs.h
--- a/include/linux/sysfs.h~sysfs-kill-unnecessary-attribute-owner
+++ a/include/linux/sysfs.h
@@ -22,7 +22,6 @@ struct dentry;
 
 struct attribute {
 	const char		* name;
-	struct module 		* owner;
 	mode_t			mode;
 };
 
@@ -39,14 +38,14 @@ struct attribute_group {
  */
 
 #define __ATTR(_name,_mode,_show,_store) { \
-	.attr = {.name = __stringify(_name), .mode = _mode, .owner = THIS_MODULE },	\
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.show	= _show,					\
 	.store	= _store,					\
 }
 
 #define __ATTR_RO(_name) { \
-	.attr	= { .name = __stringify(_name), .mode = 0444, .owner = THIS_MODULE },	\
-	.show	= _name##_show,	\
+	.attr	= { .name = __stringify(_name), .mode = 0444 },	\
+	.show	= _name##_show,					\
 }
 
 #define __ATTR_NULL { .attr = { .name = NULL } }
diff -puN kernel/module.c~sysfs-kill-unnecessary-attribute-owner kernel/module.c
--- a/kernel/module.c~sysfs-kill-unnecessary-attribute-owner
+++ a/kernel/module.c
@@ -485,8 +485,7 @@ static void free_modinfo_##field(struct 
         mod->field = NULL;                                            \
 }                                                                     \
 static struct module_attribute modinfo_##field = {                    \
-	.attr = { .name = __stringify(field), .mode = 0444,           \
-		  .owner = THIS_MODULE },                             \
+	.attr = { .name = __stringify(field), .mode = 0444 },         \
 	.show = show_modinfo_##field,                                 \
 	.setup = setup_modinfo_##field,                               \
 	.test = modinfo_##field##_exists,                             \
@@ -790,7 +789,7 @@ static ssize_t show_refcnt(struct module
 }
 
 static struct module_attribute refcnt = {
-	.attr = { .name = "refcnt", .mode = 0444, .owner = THIS_MODULE },
+	.attr = { .name = "refcnt", .mode = 0444 },
 	.show = show_refcnt,
 };
 
@@ -848,7 +847,7 @@ static ssize_t show_initstate(struct mod
 }
 
 static struct module_attribute initstate = {
-	.attr = { .name = "initstate", .mode = 0444, .owner = THIS_MODULE },
+	.attr = { .name = "initstate", .mode = 0444 },
 	.show = show_initstate,
 };
 
@@ -1029,7 +1028,6 @@ static void add_sect_attrs(struct module
 		sattr->mattr.show = module_sect_show;
 		sattr->mattr.store = NULL;
 		sattr->mattr.attr.name = sattr->name;
-		sattr->mattr.attr.owner = mod;
 		sattr->mattr.attr.mode = S_IRUGO;
 		*(gattr++) = &(sattr++)->mattr.attr;
 	}
@@ -1087,7 +1085,6 @@ int module_add_modinfo_attrs(struct modu
 		if (!attr->test ||
 		    (attr->test && attr->test(mod))) {
 			memcpy(temp_attr, attr, sizeof(*temp_attr));
-			temp_attr->attr.owner = mod;
 			error = sysfs_create_file(&mod->mkobj.kobj,&temp_attr->attr);
 			++temp_attr;
 		}
diff -puN kernel/params.c~sysfs-kill-unnecessary-attribute-owner kernel/params.c
--- a/kernel/params.c~sysfs-kill-unnecessary-attribute-owner
+++ a/kernel/params.c
@@ -491,7 +491,6 @@ param_sysfs_setup(struct module_kobject 
 			pattr->mattr.show = param_attr_show;
 			pattr->mattr.store = param_attr_store;
 			pattr->mattr.attr.name = (char *)&kp->name[name_skip];
-			pattr->mattr.attr.owner = mk->mod;
 			pattr->mattr.attr.mode = kp->perm;
 			*(gattr++) = &(pattr++)->mattr.attr;
 		}
diff -puN net/bridge/br_sysfs_br.c~sysfs-kill-unnecessary-attribute-owner net/bridge/br_sysfs_br.c
--- a/net/bridge/br_sysfs_br.c~sysfs-kill-unnecessary-attribute-owner
+++ a/net/bridge/br_sysfs_br.c
@@ -365,8 +365,7 @@ static ssize_t brforward_read(struct kob
 
 static struct bin_attribute bridge_forward = {
 	.attr = { .name = SYSFS_BRIDGE_FDB,
-		  .mode = S_IRUGO,
-		  .owner = THIS_MODULE, },
+		  .mode = S_IRUGO, },
 	.read = brforward_read,
 };
 
diff -puN net/bridge/br_sysfs_if.c~sysfs-kill-unnecessary-attribute-owner net/bridge/br_sysfs_if.c
--- a/net/bridge/br_sysfs_if.c~sysfs-kill-unnecessary-attribute-owner
+++ a/net/bridge/br_sysfs_if.c
@@ -29,8 +29,7 @@ struct brport_attribute {
 #define BRPORT_ATTR(_name,_mode,_show,_store)		        \
 struct brport_attribute brport_attr_##_name = { 	        \
 	.attr = {.name = __stringify(_name), 			\
-		 .mode = _mode, 				\
-		 .owner = THIS_MODULE, },			\
+		 .mode = _mode },				\
 	.show	= _show,					\
 	.store	= _store,					\
 };
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
revert-gregkh-driver-sysfs-crash-debugging.patch
sysfs-fix-i_ino-handling-in-sysfs.patch
sysfs-fix-error-handling-in-binattr-write.patch
sysfs-move-release_sysfs_dirent-to-dirc.patch
sysfs-flatten-cleanup-paths-in-sysfs_add_link-and-create_dir.patch
sysfs-consolidate-sysfs_dirent-creation-functions.patch
sysfs-add-sysfs_dirent-s_parent.patch
sysfs-add-sysfs_dirent-s_name.patch
sysfs-make-sysfs_dirent-s_element-a-union.patch
sysfs-implement-kobj_sysfs_assoc_lock.patch
sysfs-reimplement-symlink-using-sysfs_dirent-tree.patch
sysfs-implement-bin_buffer.patch
sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect.patch
sysfs-kill-attribute-file-orphaning.patch
sysfs-kill-unnecessary-attribute-owner.patch
sysfs-kill-unnecessary-attribute-owner-fix.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
