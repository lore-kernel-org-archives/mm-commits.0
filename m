From: akpm@linux-foundation.org
Subject: - scsi-megaraid_sas-add-module-param-fast_load.patch removed from -mm tree
Date: Fri, 14 Sep 2007 14:01:26 -0700
Message-ID: <200709142101.l8EL1QtK024258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53532 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756077AbXINVBb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 17:01:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bo.yang@lsi.com, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     scsi: megaraid_sas: add module param fast_load
has been removed from the -mm tree.  Its filename was
     scsi-megaraid_sas-add-module-param-fast_load.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: scsi: megaraid_sas: add module param fast_load
From: Bo Yang <bo.yang@lsi.com>

Driver will skip physical devices scan for the first time if the fast_load is
set

Signed-off-by: Bo Yang <bo.yang@lsi.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |   69 +++++++++++++++++++------
 1 file changed, 55 insertions(+), 14 deletions(-)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-add-module-param-fast_load drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-add-module-param-fast_load
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -46,6 +46,22 @@
 #include <scsi/scsi_host.h>
 #include "megaraid_sas.h"
 
+/*
+ * Module parameters
+ */
+
+/*
+ * Fast driver load option, skip scanning for physical devices during
+ * load.  This would result in physical devices being skipped during
+ * driver load time. These can be later added though,
+ * using /proc/scsi/scsi
+ */
+static unsigned int fast_load;
+module_param_named(fast_load, fast_load, int, 0);
+MODULE_PARM_DESC(fast_load,
+	"megasas: Faster loading of the driver, skips physical devices! \
+	 (default = 0)");
+
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MEGASAS_VERSION);
 MODULE_AUTHOR("megaraidlinux@lsi.com");
@@ -1094,6 +1110,44 @@ megasas_service_aen(struct megasas_insta
 	megasas_return_cmd(instance, cmd);
 }
 
+static struct megasas_instance *megasas_lookup_instance(u16 host_no)
+{
+	int i;
+
+	for (i = 0; i < megasas_mgmt_info.max_index; i++) {
+		if ((megasas_mgmt_info.instance[i]) &&
+			(megasas_mgmt_info.instance[i]->host->host_no
+			== host_no))
+			return megasas_mgmt_info.instance[i];
+	}
+
+	return NULL;
+}
+
+static int megasas_slave_alloc(struct scsi_device *sdev)
+{
+	struct megasas_instance *instance;
+	int tmp_fastload = fast_load;
+
+	instance = megasas_lookup_instance(sdev->host->host_no);
+
+	if (tmp_fastload && sdev->channel < MEGASAS_MAX_PD_CHANNELS) {
+		if ((sdev->id == MEGASAS_MAX_DEV_PER_CHANNEL -1) &&
+			(sdev->channel == MEGASAS_MAX_PD_CHANNELS - 1)) {
+
+		/*
+		 * If fast load option was set and scan for last device is
+		 * over, reset the fast_load flag so that during a possible
+		 * next scan, devices can be made available
+		 */
+			fast_load = 0;
+		}
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
 /*
  * Scsi host template for megaraid_sas driver
  */
@@ -1103,6 +1157,7 @@ static struct scsi_host_template megasas
 	.name = "LSI Logic SAS based MegaRAID driver",
 	.proc_name = "megaraid_sas",
 	.slave_configure = megasas_slave_configure,
+	.slave_alloc = megasas_slave_alloc,
 	.queuecommand = megasas_queue_command,
 	.eh_device_reset_handler = megasas_reset_device,
 	.eh_bus_reset_handler = megasas_reset_bus_host,
@@ -2968,20 +3023,6 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	return error;
 }
 
-static struct megasas_instance *megasas_lookup_instance(u16 host_no)
-{
-	int i;
-
-	for (i = 0; i < megasas_mgmt_info.max_index; i++) {
-
-		if ((megasas_mgmt_info.instance[i]) &&
-		    (megasas_mgmt_info.instance[i]->host->host_no == host_no))
-			return megasas_mgmt_info.instance[i];
-	}
-
-	return NULL;
-}
-
 static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 {
 	struct megasas_iocpacket __user *user_ioc =
_

Patches currently in -mm which might be from bo.yang@lsi.com are

scsi-megaraid_sas-add-module-param-fast_load.patch
scsi-megaraid_sas-add-module-param-max_sectors-cmd_per_lun.patch
scsi-megaraid_sas-update-version-and-changelog.patch
