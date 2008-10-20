From: akpm@linux-foundation.org
Subject: - x86-sysfs-kill-owner-field-from-attribute.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:38:06 -0700
Message-ID: <200810202038.m9KKc6WN011797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752761AbYJTUjk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:39:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: parag.lkml@gmail.com, a.zummo@towertech.it, david-b@pacbell.net, greg@kroah.com, htejun@gmail.com, jens.axboe@oracle.com, khali@linux-fr.org, lenb@kernel.org, mingo@elte.hu, rolandd@c


The patch titled
     x86: sysfs: kill owner field from attribute
has been removed from the -mm tree.  Its filename was
     x86-sysfs-kill-owner-field-from-attribute.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: sysfs: kill owner field from attribute
From: "Parag Warudkar" <parag.lkml@gmail.com>

Tejun's commit 7b595756ec1f49e0049a9e01a1298d53a7faaa15 made sysfs
attribute->owner unnecessary.  But the field was left in the structure to
ease the merge.  It's been over a year since that change and it is now
time to start killing attribute->owner along with its users - one arch at
a time!

This patch is attempt #1 to get rid of attribute->owner only for
CONFIG_X86_64 or CONFIG_X86_32 .  We will deal with other arches later on
as and when possible - avr32 will be the next since that is something I
can test.  Compile (make allyesconfig / make allmodconfig / custom config)
and boot tested.

akpm: the idea is that we put the declaration of sttribute.owner inside
`#ifndef CONFIG_X86'.  But that proved to be too ambitious for now because
new usages kept on turning up in subsystem trees.

[akpm: remove the ifdef for now]
Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/battery.c              |    2 +-
 drivers/acpi/sbs.c                  |    2 +-
 drivers/acpi/system.c               |    1 -
 drivers/block/aoe/aoeblk.c          |    2 +-
 drivers/block/nbd.c                 |    2 +-
 drivers/firmware/iscsi_ibft.c       |    1 -
 drivers/i2c/chips/at24.c            |    1 -
 drivers/i2c/chips/ds1682.c          |    1 -
 drivers/infiniband/core/cm.c        |    2 +-
 drivers/memstick/core/mspro_block.c |    1 -
 drivers/power/power_supply_sysfs.c  |    2 +-
 drivers/rtc/rtc-cmos.c              |    1 -
 drivers/rtc/rtc-ds1305.c            |    1 -
 drivers/rtc/rtc-ds1307.c            |    1 -
 drivers/rtc/rtc-ds1511.c            |    1 -
 drivers/rtc/rtc-m48t59.c            |    1 -
 drivers/rtc/rtc-stk17ta8.c          |    1 -
 drivers/scsi/arcmsr/arcmsr_attr.c   |    3 ---
 drivers/w1/slaves/w1_ds2760.c       |    1 -
 include/linux/sysfs.h               |    5 +++--
 20 files changed, 9 insertions(+), 23 deletions(-)

diff -puN drivers/acpi/battery.c~x86-sysfs-kill-owner-field-from-attribute drivers/acpi/battery.c
--- a/drivers/acpi/battery.c~x86-sysfs-kill-owner-field-from-attribute
+++ a/drivers/acpi/battery.c
@@ -431,7 +431,7 @@ static ssize_t acpi_battery_alarm_store(
 }
 
 static struct device_attribute alarm_attr = {
-	.attr = {.name = "alarm", .mode = 0644, .owner = THIS_MODULE},
+	.attr = {.name = "alarm", .mode = 0644},
 	.show = acpi_battery_alarm_show,
 	.store = acpi_battery_alarm_store,
 };
diff -puN drivers/acpi/sbs.c~x86-sysfs-kill-owner-field-from-attribute drivers/acpi/sbs.c
--- a/drivers/acpi/sbs.c~x86-sysfs-kill-owner-field-from-attribute
+++ a/drivers/acpi/sbs.c
@@ -463,7 +463,7 @@ static ssize_t acpi_battery_alarm_store(
 }
 
 static struct device_attribute alarm_attr = {
-	.attr = {.name = "alarm", .mode = 0644, .owner = THIS_MODULE},
+	.attr = {.name = "alarm", .mode = 0644},
 	.show = acpi_battery_alarm_show,
 	.store = acpi_battery_alarm_store,
 };
diff -puN drivers/acpi/system.c~x86-sysfs-kill-owner-field-from-attribute drivers/acpi/system.c
--- a/drivers/acpi/system.c~x86-sysfs-kill-owner-field-from-attribute
+++ a/drivers/acpi/system.c
@@ -115,7 +115,6 @@ static void acpi_table_attr_init(struct 
 	table_attr->attr.read = acpi_table_show;
 	table_attr->attr.attr.name = table_attr->name;
 	table_attr->attr.attr.mode = 0444;
-	table_attr->attr.attr.owner = THIS_MODULE;
 
 	return;
 }
diff -puN drivers/block/aoe/aoeblk.c~x86-sysfs-kill-owner-field-from-attribute drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~x86-sysfs-kill-owner-field-from-attribute
+++ a/drivers/block/aoe/aoeblk.c
@@ -90,7 +90,7 @@ static DEVICE_ATTR(state, S_IRUGO, aoedi
 static DEVICE_ATTR(mac, S_IRUGO, aoedisk_show_mac, NULL);
 static DEVICE_ATTR(netif, S_IRUGO, aoedisk_show_netif, NULL);
 static struct device_attribute dev_attr_firmware_version = {
-	.attr = { .name = "firmware-version", .mode = S_IRUGO, .owner = THIS_MODULE },
+	.attr = { .name = "firmware-version", .mode = S_IRUGO },
 	.show = aoedisk_show_fwver,
 };
 
diff -puN drivers/block/nbd.c~x86-sysfs-kill-owner-field-from-attribute drivers/block/nbd.c
--- a/drivers/block/nbd.c~x86-sysfs-kill-owner-field-from-attribute
+++ a/drivers/block/nbd.c
@@ -391,7 +391,7 @@ static ssize_t pid_show(struct device *d
 }
 
 static struct device_attribute pid_attr = {
-	.attr = { .name = "pid", .mode = S_IRUGO, .owner = THIS_MODULE },
+	.attr = { .name = "pid", .mode = S_IRUGO},
 	.show = pid_show,
 };
 
diff -puN drivers/firmware/iscsi_ibft.c~x86-sysfs-kill-owner-field-from-attribute drivers/firmware/iscsi_ibft.c
--- a/drivers/firmware/iscsi_ibft.c~x86-sysfs-kill-owner-field-from-attribute
+++ a/drivers/firmware/iscsi_ibft.c
@@ -732,7 +732,6 @@ static int __init ibft_create_attribute(
 
 	attr->attr.name = name;
 	attr->attr.mode = S_IRUSR;
-	attr->attr.owner = THIS_MODULE;
 
 	attr->hdr = hdr;
 	attr->show = show;
diff -puN drivers/i2c/chips/at24.c~x86-sysfs-kill-owner-field-from-attribute drivers/i2c/chips/at24.c
--- a/drivers/i2c/chips/at24.c~x86-sysfs-kill-owner-field-from-attribute
+++ a/drivers/i2c/chips/at24.c
@@ -460,7 +460,6 @@ static int at24_probe(struct i2c_client 
 	 */
 	at24->bin.attr.name = "eeprom";
 	at24->bin.attr.mode = chip.flags & AT24_FLAG_IRUGO ? S_IRUGO : S_IRUSR;
-	at24->bin.attr.owner = THIS_MODULE;
 	at24->bin.read = at24_bin_read;
 	at24->bin.size = chip.byte_len;
 
diff -puN drivers/i2c/chips/ds1682.c~x86-sysfs-kill-owner-field-from-attribute drivers/i2c/chips/ds1682.c
--- a/drivers/i2c/chips/ds1682.c~x86-sysfs-kill-owner-field-from-attribute
+++ a/drivers/i2c/chips/ds1682.c
@@ -190,7 +190,6 @@ static struct bin_attribute ds1682_eepro
 	.attr = {
 		.name = "eeprom",
 		.mode = S_IRUGO | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = DS1682_EEPROM_SIZE,
 	.read = ds1682_eeprom_read,
diff -puN drivers/infiniband/core/cm.c~x86-sysfs-kill-owner-field-from-attribute drivers/infiniband/core/cm.c
--- a/drivers/infiniband/core/cm.c~x86-sysfs-kill-owner-field-from-attribute
+++ a/drivers/infiniband/core/cm.c
@@ -122,7 +122,7 @@ struct cm_counter_attribute {
 
 #define CM_COUNTER_ATTR(_name, _index) \
 struct cm_counter_attribute cm_##_name##_counter_attr = { \
-	.attr = { .name = __stringify(_name), .mode = 0444, .owner = THIS_MODULE }, \
+	.attr = { .name = __stringify(_name), .mode = 0444 }, \
 	.index = _index \
 }
 
diff -puN drivers/memstick/core/mspro_block.c~x86-sysfs-kill-owner-field-from-attribute drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~x86-sysfs-kill-owner-field-from-attribute
+++ a/drivers/memstick/core/mspro_block.c
@@ -1044,7 +1044,6 @@ static int mspro_block_read_attributes(s
 
 		s_attr->dev_attr.attr.name = s_attr->name;
 		s_attr->dev_attr.attr.mode = S_IRUGO;
-		s_attr->dev_attr.attr.owner = THIS_MODULE;
 		s_attr->dev_attr.show = mspro_block_attr_show(s_attr->id);
 
 		if (!rc)
diff -puN drivers/power/power_supply_sysfs.c~x86-sysfs-kill-owner-field-from-attribute drivers/power/power_supply_sysfs.c
--- a/drivers/power/power_supply_sysfs.c~x86-sysfs-kill-owner-field-from-attribute
+++ a/drivers/power/power_supply_sysfs.c
@@ -30,7 +30,7 @@
 
 #define POWER_SUPPLY_ATTR(_name)					\
 {									\
-	.attr = { .name = #_name, .mode = 0444, .owner = THIS_MODULE },	\
+	.attr = { .name = #_name, .mode = 0444 },	\
 	.show = power_supply_show_property,				\
 	.store = NULL,							\
 }
diff -puN drivers/rtc/rtc-cmos.c~x86-sysfs-kill-owner-field-from-attribute drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~x86-sysfs-kill-owner-field-from-attribute
+++ a/drivers/rtc/rtc-cmos.c
@@ -592,7 +592,6 @@ static struct bin_attribute nvram = {
 	.attr = {
 		.name	= "nvram",
 		.mode	= S_IRUGO | S_IWUSR,
-		.owner	= THIS_MODULE,
 	},
 
 	.read	= cmos_nvram_read,
diff -puN drivers/rtc/rtc-ds1305.c~x86-sysfs-kill-owner-field-from-attribute drivers/rtc/rtc-ds1305.c
--- a/drivers/rtc/rtc-ds1305.c~x86-sysfs-kill-owner-field-from-attribute
+++ a/drivers/rtc/rtc-ds1305.c
@@ -606,7 +606,6 @@ ds1305_nvram_write(struct kobject *kobj,
 static struct bin_attribute nvram = {
 	.attr.name	= "nvram",
 	.attr.mode	= S_IRUGO | S_IWUSR,
-	.attr.owner	= THIS_MODULE,
 	.read		= ds1305_nvram_read,
 	.write		= ds1305_nvram_write,
 	.size		= DS1305_NVRAM_LEN,
diff -puN drivers/rtc/rtc-ds1307.c~x86-sysfs-kill-owner-field-from-attribute drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~x86-sysfs-kill-owner-field-from-attribute
+++ a/drivers/rtc/rtc-ds1307.c
@@ -551,7 +551,6 @@ static struct bin_attribute nvram = {
 	.attr = {
 		.name	= "nvram",
 		.mode	= S_IRUGO | S_IWUSR,
-		.owner	= THIS_MODULE,
 	},
 
 	.read	= ds1307_nvram_read,
diff -puN drivers/rtc/rtc-ds1511.c~x86-sysfs-kill-owner-field-from-attribute drivers/rtc/rtc-ds1511.c
--- a/drivers/rtc/rtc-ds1511.c~x86-sysfs-kill-owner-field-from-attribute
+++ a/drivers/rtc/rtc-ds1511.c
@@ -481,7 +481,6 @@ static struct bin_attribute ds1511_nvram
 	.attr = {
 		.name = "nvram",
 		.mode = S_IRUGO | S_IWUGO,
-		.owner = THIS_MODULE,
 	},
 	.size = DS1511_RAM_MAX,
 	.read = ds1511_nvram_read,
diff -puN drivers/rtc/rtc-m48t59.c~x86-sysfs-kill-owner-field-from-attribute drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~x86-sysfs-kill-owner-field-from-attribute
+++ a/drivers/rtc/rtc-m48t59.c
@@ -360,7 +360,6 @@ static struct bin_attribute m48t59_nvram
 	.attr = {
 		.name = "nvram",
 		.mode = S_IRUGO | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.read = m48t59_nvram_read,
 	.write = m48t59_nvram_write,
diff -puN drivers/rtc/rtc-stk17ta8.c~x86-sysfs-kill-owner-field-from-attribute drivers/rtc/rtc-stk17ta8.c
--- a/drivers/rtc/rtc-stk17ta8.c~x86-sysfs-kill-owner-field-from-attribute
+++ a/drivers/rtc/rtc-stk17ta8.c
@@ -280,7 +280,6 @@ static struct bin_attribute stk17ta8_nvr
 	.attr = {
 		.name = "nvram",
 		.mode = S_IRUGO | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = RTC_OFFSET,
 	.read = stk17ta8_nvram_read,
diff -puN drivers/scsi/arcmsr/arcmsr_attr.c~x86-sysfs-kill-owner-field-from-attribute drivers/scsi/arcmsr/arcmsr_attr.c
--- a/drivers/scsi/arcmsr/arcmsr_attr.c~x86-sysfs-kill-owner-field-from-attribute
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
diff -puN drivers/w1/slaves/w1_ds2760.c~x86-sysfs-kill-owner-field-from-attribute drivers/w1/slaves/w1_ds2760.c
--- a/drivers/w1/slaves/w1_ds2760.c~x86-sysfs-kill-owner-field-from-attribute
+++ a/drivers/w1/slaves/w1_ds2760.c
@@ -80,7 +80,6 @@ static struct bin_attribute w1_ds2760_bi
 	.attr = {
 		.name = "w1_slave",
 		.mode = S_IRUGO,
-		.owner = THIS_MODULE,
 	},
 	.size = DS2760_DATA_SIZE,
 	.read = w1_ds2760_read_bin,
diff -puN include/linux/sysfs.h~x86-sysfs-kill-owner-field-from-attribute include/linux/sysfs.h
--- a/include/linux/sysfs.h~x86-sysfs-kill-owner-field-from-attribute
+++ a/include/linux/sysfs.h
@@ -21,8 +21,9 @@ struct kobject;
 struct module;
 
 /* FIXME
- * The *owner field is no longer used, but leave around
- * until the tree gets cleaned up fully.
+ * The *owner field is no longer used.
+ * x86 tree has been cleaned up. The owner
+ * attribute is still left for other arches.
  */
 struct attribute {
 	const char		*name;
_

Patches currently in -mm which might be from parag.lkml@gmail.com are

origin.patch

