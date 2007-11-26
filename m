From: akpm@linux-foundation.org
Subject: + libsas-use-new-ata-configuration-mechanism.patch added to -mm tree
Date: Sun, 25 Nov 2007 23:44:42 -0800
Message-ID: <200711260744.lAQ7igKW022845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38332 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752920AbXKZHo6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 02:44:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, jeff@garzik.org


The patch titled
     libsas: use new ATA configuration mechanism
has been added to the -mm tree.  Its filename is
     libsas-use-new-ata-configuration-mechanism.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libsas: use new ATA configuration mechanism
From: "Darrick J. Wong" <djwong@us.ibm.com>

Update sas_ata to use the new ata_sas_rphy mechanisms as provided by
Brian King, and simplify ATA device discovery...

WARNING WARNING WARNING!  This patch is experimental, use at your own
risk.

Comments-requested-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/libsas/sas_ata.c       |  206 +++++++++-----------------
 drivers/scsi/libsas/sas_discover.c  |    4 
 drivers/scsi/libsas/sas_scsi_host.c |   37 ----
 include/scsi/libsas.h               |    4 
 4 files changed, 91 insertions(+), 160 deletions(-)

diff -puN drivers/scsi/libsas/sas_ata.c~libsas-use-new-ata-configuration-mechanism drivers/scsi/libsas/sas_ata.c
--- a/drivers/scsi/libsas/sas_ata.c~libsas-use-new-ata-configuration-mechanism
+++ a/drivers/scsi/libsas/sas_ata.c
@@ -35,6 +35,13 @@
 #include "../scsi_transport_api.h"
 #include <scsi/scsi_eh.h>
 
+struct sas_ata_descr {
+	struct ata_sas_rphy rphy;
+	struct scsi_host_template sht;
+};
+
+#define ata_rphy_to_descr(x) container_of((x), struct sas_ata_descr, rphy)
+
 static int sas_issue_ata_srst(struct domain_device *dev);
 
 static enum ata_completion_errors sas_to_ata_err(struct task_status_struct *ts)
@@ -323,55 +330,6 @@ static void sas_ata_tf_read(struct ata_p
 	memcpy(tf, &dev->sata_dev.tf, sizeof (*tf));
 }
 
-static int sas_ata_scr_write(struct ata_port *ap, unsigned int sc_reg_in,
-			      u32 val)
-{
-	struct domain_device *dev = ap->private_data;
-
-	SAS_DPRINTK("STUB %s\n", __FUNCTION__);
-	switch (sc_reg_in) {
-		case SCR_STATUS:
-			dev->sata_dev.sstatus = val;
-			break;
-		case SCR_CONTROL:
-			dev->sata_dev.scontrol = val;
-			break;
-		case SCR_ERROR:
-			dev->sata_dev.serror = val;
-			break;
-		case SCR_ACTIVE:
-			dev->sata_dev.ap->link.sactive = val;
-			break;
-		default:
-			return -EINVAL;
-	}
-	return 0;
-}
-
-static int sas_ata_scr_read(struct ata_port *ap, unsigned int sc_reg_in,
-			    u32 *val)
-{
-	struct domain_device *dev = ap->private_data;
-
-	SAS_DPRINTK("STUB %s\n", __FUNCTION__);
-	switch (sc_reg_in) {
-		case SCR_STATUS:
-			*val = dev->sata_dev.sstatus;
-			return 0;
-		case SCR_CONTROL:
-			*val = dev->sata_dev.scontrol;
-			return 0;
-		case SCR_ERROR:
-			*val = dev->sata_dev.serror;
-			return 0;
-		case SCR_ACTIVE:
-			*val = dev->sata_dev.ap->link.sactive;
-			return 0;
-		default:
-			return -EINVAL;
-	}
-}
-
 static struct ata_port_operations sas_sata_ops = {
 	.check_status		= sas_ata_check_status,
 	.check_altstatus	= sas_ata_check_status,
@@ -385,8 +343,6 @@ static struct ata_port_operations sas_sa
 	.qc_issue		= sas_ata_qc_issue,
 	.port_start		= ata_sas_port_start,
 	.port_stop		= ata_sas_port_stop,
-	.scr_read		= sas_ata_scr_read,
-	.scr_write		= sas_ata_scr_write
 };
 
 static struct ata_port_info sata_port_info = {
@@ -398,33 +354,6 @@ static struct ata_port_info sata_port_in
 	.port_ops = &sas_sata_ops
 };
 
-int sas_ata_init_host_and_port(struct domain_device *found_dev,
-			       struct scsi_target *starget)
-{
-	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
-	struct sas_ha_struct *ha = SHOST_TO_SAS_HA(shost);
-	struct ata_port *ap;
-
-	ata_host_init(&found_dev->sata_dev.ata_host,
-		      ha->dev,
-		      sata_port_info.flags,
-		      &sas_sata_ops);
-	ap = ata_sas_port_alloc(&found_dev->sata_dev.ata_host,
-				&sata_port_info,
-				shost);
-	if (!ap) {
-		SAS_DPRINTK("ata_sas_port_alloc failed.\n");
-		return -ENODEV;
-	}
-
-	ap->private_data = found_dev;
-	ap->cbl = ATA_CBL_SATA;
-	ap->scsi_host = shost;
-	found_dev->sata_dev.ap = ap;
-
-	return 0;
-}
-
 void sas_ata_task_abort(struct sas_task *task)
 {
 	struct ata_queued_cmd *qc = task->uldd_task;
@@ -601,50 +530,6 @@ out:
 }
 
 /* ---------- SATA ---------- */
-
-static void sas_get_ata_command_set(struct domain_device *dev)
-{
-	struct dev_to_host_fis *fis =
-		(struct dev_to_host_fis *) dev->frame_rcvd;
-
-	if ((fis->sector_count == 1 && /* ATA */
-	     fis->lbal         == 1 &&
-	     fis->lbam         == 0 &&
-	     fis->lbah         == 0 &&
-	     fis->device       == 0)
-	    ||
-	    (fis->sector_count == 0 && /* CE-ATA (mATA) */
-	     fis->lbal         == 0 &&
-	     fis->lbam         == 0xCE &&
-	     fis->lbah         == 0xAA &&
-	     (fis->device & ~0x10) == 0))
-
-		dev->sata_dev.command_set = ATA_COMMAND_SET;
-
-	else if ((fis->interrupt_reason == 1 &&	/* ATAPI */
-		  fis->lbal             == 1 &&
-		  fis->byte_count_low   == 0x14 &&
-		  fis->byte_count_high  == 0xEB &&
-		  (fis->device & ~0x10) == 0))
-
-		dev->sata_dev.command_set = ATAPI_COMMAND_SET;
-
-	else if ((fis->sector_count == 1 && /* SEMB */
-		  fis->lbal         == 1 &&
-		  fis->lbam         == 0x3C &&
-		  fis->lbah         == 0xC3 &&
-		  fis->device       == 0)
-		||
-		 (fis->interrupt_reason == 1 &&	/* SATA PM */
-		  fis->lbal             == 1 &&
-		  fis->byte_count_low   == 0x69 &&
-		  fis->byte_count_high  == 0x96 &&
-		  (fis->device & ~0x10) == 0))
-
-		/* Treat it as a superset? */
-		dev->sata_dev.command_set = ATAPI_COMMAND_SET;
-}
-
 /**
  * sas_issue_ata_cmd -- Basic SATA command processing for discovery
  * @dev: the device to send the command to
@@ -827,6 +712,23 @@ static int sas_discover_sata_pm(struct d
 	return -ENODEV;
 }
 
+static struct scsi_host_template sas_ata_driver_template = {
+	/* name and module will be filled in the real template */
+	.ioctl			= ata_scsi_ioctl,
+	.queuecommand		= ata_scsi_queuecmd,
+	.slave_configure	= ata_scsi_slave_config,
+	.slave_destroy		= ata_scsi_slave_destroy,
+	.change_queue_depth	= ata_scsi_change_queue_depth,
+	.bios_param		= ata_std_bios_param,
+	.can_queue		= 1,
+	.this_id		= -1,
+	.sg_tablesize		= SG_ALL,
+	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
+	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
+	.emulated		= ATA_SHT_EMULATED,
+	.use_clustering		= ATA_SHT_USE_CLUSTERING,
+};
+
 /**
  * sas_discover_sata -- discover an STP/SATA domain device
  * @dev: pointer to struct domain_device of interest
@@ -844,13 +746,16 @@ static int sas_discover_sata_pm(struct d
  */
 int sas_discover_sata(struct domain_device *dev)
 {
+	struct sas_ha_struct *sas_ha = dev->port->ha;
+	struct Scsi_Host *shost = sas_ha->core.shost;
+	struct ata_sas_rphy *rphy;
+	struct sas_ata_descr *descr;
 	int res;
 
-	sas_get_ata_command_set(dev);
-
+	/* Set up SAS connection parameters */
 	res = sas_notify_lldd_dev_found(dev);
 	if (res)
-		return res;
+		goto out;
 
 	switch (dev->dev_type) {
 	case SATA_DEV:
@@ -862,11 +767,56 @@ int sas_discover_sata(struct domain_devi
 	default:
 		break;
 	}
+	if (res)
+		goto err_lldd_remove;
+
+	rphy = ata_sas_rphy_alloc(&shost->shost_gendev, sas_ha->dev,
+				  &sata_port_info,
+				  sizeof(struct sas_ata_descr) - sizeof(*rphy));
+	if (!rphy) {
+		res = -ENODEV;
+		goto err_lldd_remove;
+	}
+
+	rphy->host->ports[0]->private_data = dev;
+	dev->sata_dev.ap = rphy->host->ports[0];
+	dev->sata_dev.rphy = rphy;
+	descr = ata_rphy_to_descr(rphy);
+	memcpy(&descr->sht, &sas_ata_driver_template,
+	       sizeof(struct scsi_host_template));
+	descr->sht.module = shost->hostt->module;
+	descr->sht.name = shost->hostt->name;
+	descr->sht.proc_name = shost->hostt->proc_name;
+
+	res = ata_sas_rphy_add(rphy, &descr->sht);
+	if (res) {
+		printk(KERN_ERR "ata_sas_rphy_add fails %d\n", res);
+		goto err_arphy_free;
+	}
+
 	sas_notify_lldd_dev_gone(dev);
-	if (!res) {
-		sas_notify_lldd_dev_found(dev);
-		res = sas_rphy_add(dev->rphy);
+	res = sas_notify_lldd_dev_found(dev);
+	if (res) {
+		printk(KERN_ERR "sas_notify_lldd_dev_found fails %d\n", res);
+		goto err_arphy_del;
 	}
 
+	goto out;
+
+err_arphy_del:
+	ata_sas_rphy_delete(rphy);
+err_arphy_free:
+	ata_sas_rphy_free(rphy);
+err_lldd_remove:
+	sas_notify_lldd_dev_gone(dev);
+out:
 	return res;
 }
+
+void sas_unregister_sata_dev(struct domain_device *dev)
+{
+	ata_sas_rphy_delete(dev->sata_dev.rphy);
+	sas_remove_children(&dev->rphy->dev);
+	sas_rphy_free(dev->rphy);
+	dev->rphy = NULL;
+}
diff -puN drivers/scsi/libsas/sas_discover.c~libsas-use-new-ata-configuration-mechanism drivers/scsi/libsas/sas_discover.c
--- a/drivers/scsi/libsas/sas_discover.c~libsas-use-new-ata-configuration-mechanism
+++ a/drivers/scsi/libsas/sas_discover.c
@@ -30,6 +30,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
 #include "../scsi_sas_internal.h"
+#include <scsi/sas_ata.h>
 
 /* ---------- Basic task processing for discovery purposes ---------- */
 
@@ -230,6 +231,9 @@ static inline void sas_unregister_common
 
 void sas_unregister_dev(struct domain_device *dev)
 {
+	if (dev_is_sata(dev))
+		sas_unregister_sata_dev(dev);
+
 	if (dev->rphy) {
 		sas_remove_children(&dev->rphy->dev);
 		sas_rphy_delete(dev->rphy);
diff -puN drivers/scsi/libsas/sas_scsi_host.c~libsas-use-new-ata-configuration-mechanism drivers/scsi/libsas/sas_scsi_host.c
--- a/drivers/scsi/libsas/sas_scsi_host.c~libsas-use-new-ata-configuration-mechanism
+++ a/drivers/scsi/libsas/sas_scsi_host.c
@@ -201,8 +201,6 @@ int sas_queue_up(struct sas_task *task)
 int sas_queuecommand(struct scsi_cmnd *cmd,
 		     void (*scsi_done)(struct scsi_cmnd *))
 	__releases(host->host_lock)
-	__acquires(dev->sata_dev.ap->lock)
-	__releases(dev->sata_dev.ap->lock)
 	__acquires(host->host_lock)
 {
 	int res = 0;
@@ -216,15 +214,7 @@ int sas_queuecommand(struct scsi_cmnd *c
 		struct sas_ha_struct *sas_ha = dev->port->ha;
 		struct sas_task *task;
 
-		if (dev_is_sata(dev)) {
-			unsigned long flags;
-
-			spin_lock_irqsave(dev->sata_dev.ap->lock, flags);
-			res = ata_sas_queuecmd(cmd, scsi_done,
-					       dev->sata_dev.ap);
-			spin_unlock_irqrestore(dev->sata_dev.ap->lock, flags);
-			goto out;
-		}
+		BUG_ON(dev_is_sata(dev));
 
 		res = -ENOMEM;
 		task = sas_create_task(cmd, dev, GFP_ATOMIC);
@@ -701,8 +691,7 @@ int sas_ioctl(struct scsi_device *sdev, 
 {
 	struct domain_device *dev = sdev_to_domain_dev(sdev);
 
-	if (dev_is_sata(dev))
-		return ata_scsi_ioctl(sdev, cmd, arg);
+	BUG_ON(dev_is_sata(dev));
 
 	return -EINVAL;
 }
@@ -746,16 +735,11 @@ static inline struct domain_device *sas_
 int sas_target_alloc(struct scsi_target *starget)
 {
 	struct domain_device *found_dev = sas_find_target(starget);
-	int res;
 
 	if (!found_dev)
 		return -ENODEV;
 
-	if (dev_is_sata(found_dev)) {
-		res = sas_ata_init_host_and_port(found_dev, starget);
-		if (res)
-			return res;
-	}
+	BUG_ON(dev_is_sata(found_dev));
 
 	starget->hostdata = found_dev;
 	return 0;
@@ -770,11 +754,7 @@ int sas_slave_configure(struct scsi_devi
 	struct sas_ha_struct *sas_ha;
 
 	BUG_ON(dev->rphy->identify.device_type != SAS_END_DEVICE);
-
-	if (dev_is_sata(dev)) {
-		ata_sas_slave_configure(scsi_dev, dev->sata_dev.ap);
-		return 0;
-	}
+	BUG_ON(dev_is_sata(dev));
 
 	sas_ha = dev->port->ha;
 
@@ -801,8 +781,7 @@ void sas_slave_destroy(struct scsi_devic
 {
 	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
 
-	if (dev_is_sata(dev))
-		ata_port_disable(dev->sata_dev.ap);
+	BUG_ON(dev_is_sata(dev));
 }
 
 int sas_change_queue_depth(struct scsi_device *scsi_dev, int new_depth)
@@ -1032,8 +1011,7 @@ int sas_slave_alloc(struct scsi_device *
 {
 	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
 
-	if (dev_is_sata(dev))
-		return ata_sas_port_init(dev->sata_dev.ap);
+	BUG_ON(dev_is_sata(dev));
 
 	return 0;
 }
@@ -1045,8 +1023,7 @@ void sas_target_destroy(struct scsi_targ
 	if (!found_dev)
 		return;
 
-	if (dev_is_sata(found_dev))
-		ata_sas_port_destroy(found_dev->sata_dev.ap);
+	BUG_ON(dev_is_sata(found_dev));
 
 	return;
 }
diff -puN include/scsi/libsas.h~libsas-use-new-ata-configuration-mechanism include/scsi/libsas.h
--- a/include/scsi/libsas.h~libsas-use-new-ata-configuration-mechanism
+++ a/include/scsi/libsas.h
@@ -168,7 +168,7 @@ struct sata_device {
         struct list_head children; /* PM Ports if this is a PM */
 
 	struct ata_port *ap;
-	struct ata_host ata_host;
+	struct ata_sas_rphy *rphy;
 	struct ata_taskfile tf;
 	u32 sstatus;
 	u32 serror;
@@ -658,7 +658,7 @@ int  sas_discover_event(struct asd_sas_p
 
 int  sas_discover_sata(struct domain_device *);
 int  sas_discover_end_dev(struct domain_device *);
-
+void sas_unregister_sata_dev(struct domain_device *dev);
 void sas_unregister_dev(struct domain_device *);
 
 void sas_init_dev(struct domain_device *);
_

Patches currently in -mm which might be from djwong@us.ibm.com are

git-scsi-misc.patch
mptbase-reset-ioc-initiator-during-pci-resume.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
libsas-convert-ata-bridge-to-use-new-eh-checkpatch-fixes.patch
libsas-use-new-ata-configuration-mechanism.patch
