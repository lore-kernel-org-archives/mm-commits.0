From: akpm@linux-foundation.org
Subject: + scsi-megaraid_sas-add-module-param-max_sectors-cmd_per_lun.patch added to -mm tree
Date: Fri, 14 Sep 2007 03:32:40 -0700
Message-ID: <200709141032.l8EAWenv000566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53927 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756341AbXINKcp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 06:32:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bo.yang@lsi.com, James.Bottomley@steeleye.com


The patch titled
     scsi: megaraid_sas: add module param max_sectors, cmd_per_lun
has been added to the -mm tree.  Its filename is
     scsi-megaraid_sas-add-module-param-max_sectors-cmd_per_lun.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: scsi: megaraid_sas: add module param max_sectors, cmd_per_lun
From: Bo Yang <bo.yang@lsi.com>

Adding module parameters to configure max sectors per request & # of cmds for
each lun.

Signed-off-by: Bo Yang <bo.yang@lsi.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |   93 ++++++++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas.h |    2 
 2 files changed, 93 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-add-module-param-max_sectors-cmd_per_lun drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-add-module-param-max_sectors-cmd_per_lun
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -62,6 +62,23 @@ MODULE_PARM_DESC(fast_load,
 	"megasas: Faster loading of the driver, skips physical devices! \
 	 (default = 0)");
 
+/*
+ * Number of sectors per IO command will be set in megasas_init_mfi
+ * if user does not provide
+ */
+static unsigned int max_sectors;
+module_param_named(max_sectors, max_sectors, int, 0);
+MODULE_PARM_DESC(max_sectors,
+	"Maximum number of sectors per IO command");
+
+/*
+ * Number of cmds per logical unit
+ */
+static unsigned int cmd_per_lun = MEGASAS_DEFAULT_CMD_PER_LUN;
+module_param_named(cmd_per_lun, cmd_per_lun, int, 0);
+MODULE_PARM_DESC(cmd_per_lun,
+	"Maximum number of commands per logical unit (default=128)");
+
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MEGASAS_VERSION);
 MODULE_AUTHOR("megaraidlinux@lsi.com");
@@ -2301,6 +2318,30 @@ static int megasas_start_aen(struct mega
 				    class_locale.word);
 }
 
+static ssize_t
+sysfs_max_sectors_read(struct kobject *kobj, char *buf,
+			loff_t off, size_t count)
+{
+	struct Scsi_Host *host = class_to_shost(container_of(kobj,
+					struct class_device, kobj));
+	struct megasas_instance *instance =
+				(struct megasas_instance *)host->hostdata;
+
+	count = sprintf(buf, "%u\n", instance->max_sectors_per_req);
+
+	return count+1;
+}
+
+static struct bin_attribute sysfs_max_sectors_attr = {
+	.attr = {
+		.name = "max_sectors",
+		.mode = S_IRUSR|S_IRGRP|S_IROTH,
+		.owner = THIS_MODULE,
+	},
+	.size = 7,
+	.read = sysfs_max_sectors_read,
+};
+
 /**
  * megasas_io_attach -	Attaches this driver to SCSI mid-layer
  * @instance:		Adapter soft state
@@ -2308,17 +2349,48 @@ static int megasas_start_aen(struct mega
 static int megasas_io_attach(struct megasas_instance *instance)
 {
 	struct Scsi_Host *host = instance->host;
+	int error;
 
 	/*
-	 * Export parameters required by SCSI mid-layer
+	 * Export host parameters required by SCSI
+	 * mid-layer
 	 */
 	host->irq = instance->pdev->irq;
 	host->unique_id = instance->unique_id;
 	host->can_queue = instance->max_fw_cmds - MEGASAS_INT_CMDS;
 	host->this_id = instance->init_id;
 	host->sg_tablesize = instance->max_num_sge;
+
+	/*
+	 * Check if the module parameter value for max_sectors can be used
+	 */
+	if (max_sectors && max_sectors <= instance->max_sectors_per_req)
+		instance->max_sectors_per_req = max_sectors;
+	else {
+		if (max_sectors)
+			printk(KERN_INFO
+				"megasas: max_sectors should be > 0 and"
+				"<= %d\n",
+				instance->max_sectors_per_req);
+	}
+
 	host->max_sectors = instance->max_sectors_per_req;
-	host->cmd_per_lun = 128;
+
+	/*
+	 * Check if the module parameter value for cmd_per_lun can be used
+	 */
+	instance->cmd_per_lun = MEGASAS_DEFAULT_CMD_PER_LUN;
+	if (cmd_per_lun && cmd_per_lun <= MEGASAS_DEFAULT_CMD_PER_LUN)
+		instance->cmd_per_lun = cmd_per_lun;
+	else
+		printk(KERN_INFO "megasas: cmd_per_lun should be > 0 and"
+			"<= %d\n", MEGASAS_DEFAULT_CMD_PER_LUN);
+
+	host->cmd_per_lun = instance->cmd_per_lun;
+
+	printk(KERN_DEBUG "megasas: max_sectors : 0x%x, cmd_per_lun : 0x%x\n",
+			instance->max_sectors_per_req, instance->cmd_per_lun);
+
 	host->max_channel = MEGASAS_MAX_CHANNELS - 1;
 	host->max_id = MEGASAS_MAX_DEV_PER_CHANNEL;
 	host->max_lun = MEGASAS_MAX_LUN;
@@ -2333,10 +2405,25 @@ static int megasas_io_attach(struct mega
 	}
 
 	/*
+	 * Create sysfs entries for module paramaters
+	 */
+	error = sysfs_create_bin_file(&instance->host->shost_classdev.kobj,
+			&sysfs_max_sectors_attr);
+	if (error) {
+		printk(KERN_INFO "megasas: Error in creating the sysfs entry"
+				" max_sectors.\n");
+		goto out_remove_host;
+	}
+
+	/*
 	 * Trigger SCSI to scan our drives
 	 */
 	scsi_scan_host(host);
 	return 0;
+
+out_remove_host:
+	scsi_remove_host(host);
+	return error;
 }
 
 static int
@@ -2757,6 +2844,8 @@ static void megasas_detach_one(struct pc
 	instance = pci_get_drvdata(pdev);
 	host = instance->host;
 
+	sysfs_remove_bin_file(&host->shost_classdev.kobj,
+				&sysfs_max_sectors_attr);
 	scsi_remove_host(instance->host);
 	megasas_flush_cache(instance);
 	megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
diff -puN drivers/scsi/megaraid/megaraid_sas.h~scsi-megaraid_sas-add-module-param-max_sectors-cmd_per_lun drivers/scsi/megaraid/megaraid_sas.h
--- a/drivers/scsi/megaraid/megaraid_sas.h~scsi-megaraid_sas-add-module-param-max_sectors-cmd_per_lun
+++ a/drivers/scsi/megaraid/megaraid_sas.h
@@ -537,6 +537,7 @@ struct megasas_ctrl_info {
 #define MEGASAS_DEFAULT_INIT_ID			-1
 #define MEGASAS_MAX_LUN				8
 #define MEGASAS_MAX_LD				64
+#define MEGASAS_DEFAULT_CMD_PER_LUN		128
 
 #define MEGASAS_DBG_LVL				1
 
@@ -1080,6 +1081,7 @@ struct megasas_instance {
 	u16 max_num_sge;
 	u16 max_fw_cmds;
 	u32 max_sectors_per_req;
+	u32 cmd_per_lun;
 
 	struct megasas_cmd **cmd_list;
 	struct list_head cmd_pool;
_

Patches currently in -mm which might be from bo.yang@lsi.com are

scsi-megaraid_sas-add-hibernation-support.patch
scsi-megaraid_sas-add-module-param-fast_load.patch
scsi-megaraid_sas-add-module-param-max_sectors-cmd_per_lun.patch
scsi-megaraid_sas-update-version-and-changelog.patch
