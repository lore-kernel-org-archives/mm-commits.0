From: akpm@linux-foundation.org
Subject: - ata-ahci-alpm-enable-link-power-management-for-ata-drivers.patch removed from -mm tree
Date: Mon, 06 Aug 2007 11:25:29 -0700
Message-ID: <200708061825.l76IPTWR008140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33432 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758852AbXHFSZm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 14:25:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, James.Bottomley@steeleye.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ata ahci ALPM: Enable link power management for ata drivers
has been removed from the -mm tree.  Its filename was
     ata-ahci-alpm-enable-link-power-management-for-ata-drivers.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: ata ahci ALPM: Enable link power management for ata drivers
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

libata drivers can define a function (enable_pm) that will perform hardware
specific actions to enable whatever power management policy the user set up
from the scsi sysfs interface if the driver supports it.  This power
management policy will be activated after all disks have been enumerated and
intialized.  Drivers should also define disable_pm, which will turn off link
power management, but not change link power management policy.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   43 ++++++++++++++++++++++++++++++++
 drivers/ata/libata-scsi.c |   47 +++++++++++++++++++++++++++++++++++-
 include/linux/ata.h       |    2 +
 include/linux/libata.h    |   16 +++++++-----
 4 files changed, 101 insertions(+), 7 deletions(-)

diff -puN drivers/ata/libata-core.c~ata-ahci-alpm-enable-link-power-management-for-ata-drivers drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~ata-ahci-alpm-enable-link-power-management-for-ata-drivers
+++ a/drivers/ata/libata-core.c
@@ -2010,6 +2010,9 @@ int ata_dev_configure(struct ata_device 
 	if (dev->flags & ATA_DFLAG_LBA48)
 		dev->max_sectors = ATA_MAX_SECTORS_LBA48;
 
+	if (ata_id_has_hipm(dev->id) || ata_id_has_dipm(dev->id))
+		dev->flags |= ATA_DFLAG_IPM;
+
 	if (dev->horkage & ATA_HORKAGE_DIAGNOSTIC) {
 		/* Let the user know. We don't want to disallow opens for
 		   rescue purposes, or in case the vendor is just a blithering
@@ -2035,6 +2038,13 @@ int ata_dev_configure(struct ata_device 
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
 					 dev->max_sectors);
 
+	if (ata_device_blacklisted(dev) & ATA_HORKAGE_ALPM) {
+		dev->horkage |= ATA_HORKAGE_ALPM;
+
+		/* reset link pm_policy for this port to no pm */
+		ap->pm_policy = SHOST_MAX_PERFORMANCE;
+	}
+
 	if (ap->ops->dev_config)
 		ap->ops->dev_config(dev);
 
@@ -5964,6 +5974,28 @@ int ata_flush_cache(struct ata_device *d
 	return 0;
 }
 
+static void ata_host_disable_link_pm(struct ata_host *host)
+{
+	int i;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+		if (ap->ops->disable_pm)
+			ap->ops->disable_pm(ap);
+	}
+}
+
+static void ata_host_enable_link_pm(struct ata_host *host)
+{
+	int i;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+		ata_scsi_set_link_pm_policy(ap->scsi_host,
+				ap->pm_policy);
+	}
+}
+
 #ifdef CONFIG_PM
 static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
 			       unsigned int action, unsigned int ehi_flags,
@@ -6031,6 +6063,12 @@ int ata_host_suspend(struct ata_host *ho
 {
 	int rc;
 
+	/*
+ 	 * disable link pm on all ports before requesting
+ 	 * any pm activity
+ 	 */
+	ata_host_disable_link_pm(host);
+
 	rc = ata_host_request_pm(host, mesg, 0, ATA_EHI_QUIET, 1);
 	if (rc == 0)
 		host->dev->power.power_state = mesg;
@@ -6053,6 +6091,9 @@ void ata_host_resume(struct ata_host *ho
 	ata_host_request_pm(host, PMSG_ON, ATA_EH_SOFTRESET,
 			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
 	host->dev->power.power_state = PMSG_ON;
+
+	/* reenable link pm */
+	ata_host_enable_link_pm(host);
 }
 #endif
 
@@ -6549,6 +6590,8 @@ int ata_host_register(struct ata_host *h
 		struct ata_port *ap = host->ports[i];
 
 		ata_scsi_scan_host(ap, 1);
+		ata_scsi_set_link_pm_policy(ap->scsi_host,
+				ap->pm_policy);
 	}
 
 	return 0;
diff -puN drivers/ata/libata-scsi.c~ata-ahci-alpm-enable-link-power-management-for-ata-drivers drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~ata-ahci-alpm-enable-link-power-management-for-ata-drivers
+++ a/drivers/ata/libata-scsi.c
@@ -2908,6 +2908,51 @@ void ata_scsi_simulate(struct ata_device
 	}
 }
 
+int ata_scsi_set_link_pm_policy(struct Scsi_Host *shost,
+		enum scsi_host_link_pm policy)
+{
+	struct ata_port *ap = ata_shost_to_port(shost);
+	int rc = -EINVAL;
+	int i;
+
+	/*
+ 	 * make sure no broken devices are on this port,
+ 	 * and that all devices support interface power
+ 	 * management
+ 	 */
+	for (i = 0; i < ATA_MAX_DEVICES; i++) {
+		struct ata_device *dev = &ap->device[i];
+
+		/* only check drives which exist */
+		if (!ata_dev_enabled(dev))
+			continue;
+
+		/*
+ 		 * do we need to handle the case where we've hotplugged
+ 		 * a broken drive (since hotplug and ALPM are mutually
+ 		 * exclusive) ?
+ 		 *
+ 		 * If so, if we detect a broken drive on a port with
+ 		 * alpm already enabled, then we should reset the policy
+ 		 * to off for the entire port.
+ 		 */
+		if ((dev->horkage & ATA_HORKAGE_ALPM) ||
+			!(dev->flags & ATA_DFLAG_IPM)) {
+			ata_dev_printk(dev, KERN_ERR,
+				"Unable to set Link PM policy\n");
+			ap->pm_policy = SHOST_MAX_PERFORMANCE;
+		}
+	}
+
+	if (ap->ops->enable_pm)
+		rc = ap->ops->enable_pm(ap, policy);
+
+	if (!rc)
+		shost->shost_link_pm_policy = ap->pm_policy;
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ata_scsi_set_link_pm_policy);
+
 int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 {
 	int i, rc;
@@ -2930,7 +2975,7 @@ int ata_scsi_add_hosts(struct ata_host *
 		shost->max_lun = 1;
 		shost->max_channel = 1;
 		shost->max_cmd_len = 16;
-
+		shost->shost_link_pm_policy = ap->pm_policy;
 		rc = scsi_add_host(ap->scsi_host, ap->host->dev);
 		if (rc)
 			goto err_add;
diff -puN include/linux/ata.h~ata-ahci-alpm-enable-link-power-management-for-ata-drivers include/linux/ata.h
--- a/include/linux/ata.h~ata-ahci-alpm-enable-link-power-management-for-ata-drivers
+++ a/include/linux/ata.h
@@ -364,6 +364,8 @@ struct ata_taskfile {
 	  ((u64) (id)[(n) + 0]) )
 
 #define ata_id_cdb_intr(id)	(((id)[0] & 0x60) == 0x20)
+#define ata_id_has_hipm(id)	((id)[76] & (1 << 9))
+#define ata_id_has_dipm(id)	((id)[78] & (1 << 3))
 
 static inline unsigned int ata_id_major_version(const u16 *id)
 {
diff -puN include/linux/libata.h~ata-ahci-alpm-enable-link-power-management-for-ata-drivers include/linux/libata.h
--- a/include/linux/libata.h~ata-ahci-alpm-enable-link-power-management-for-ata-drivers
+++ a/include/linux/libata.h
@@ -140,11 +140,12 @@ enum {
 	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
 	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
 	ATA_DFLAG_AN		= (1 << 7), /* device supports Async notification */
-	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,
+	ATA_DFLAG_IPM		= (1 << 8), /* device supports interface PM */
+	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
 
-	ATA_DFLAG_PIO		= (1 << 8), /* device limited to PIO mode */
-	ATA_DFLAG_NCQ_OFF	= (1 << 9), /* device limited to non-NCQ mode */
-	ATA_DFLAG_SPUNDOWN	= (1 << 10), /* XXX: for spindown_compat */
+	ATA_DFLAG_PIO		= (1 << 12), /* device limited to PIO mode */
+	ATA_DFLAG_NCQ_OFF	= (1 << 13), /* device limited to non-NCQ mode */
+	ATA_DFLAG_SPUNDOWN	= (1 << 14), /* XXX: for spindown_compat */
 	ATA_DFLAG_INIT_MASK	= (1 << 16) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 16),
@@ -312,6 +313,7 @@ enum {
 	ATA_HORKAGE_NODMA	= (1 << 1),	/* DMA problems */
 	ATA_HORKAGE_NONCQ	= (1 << 2),	/* Don't use NCQ */
 	ATA_HORKAGE_MAX_SEC_128	= (1 << 3),	/* Limit max sects to 128 */
+	ATA_HORKAGE_ALPM	= (1 << 4), 	/* ALPM problems */
 };
 
 enum hsm_task_states {
@@ -576,6 +578,7 @@ struct ata_port {
 
 	pm_message_t		pm_mesg;
 	int			*pm_result;
+	enum scsi_host_link_pm	pm_policy;
 
 	struct timer_list	fastdrain_timer;
 	unsigned long		fastdrain_cnt;
@@ -641,7 +644,8 @@ struct ata_port_operations {
 
 	int (*port_suspend) (struct ata_port *ap, pm_message_t mesg);
 	int (*port_resume) (struct ata_port *ap);
-
+	int (*enable_pm) (struct ata_port *ap, enum scsi_host_link_pm policy);
+	int (*disable_pm) (struct ata_port *ap);
 	int (*port_start) (struct ata_port *ap);
 	void (*port_stop) (struct ata_port *ap);
 
@@ -850,7 +854,7 @@ extern int ata_cable_40wire(struct ata_p
 extern int ata_cable_80wire(struct ata_port *ap);
 extern int ata_cable_sata(struct ata_port *ap);
 extern int ata_cable_unknown(struct ata_port *ap);
-
+extern int ata_scsi_set_link_pm_policy(struct Scsi_Host *shost, enum scsi_host_link_pm);
 /*
  * Timing helpers
  */
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

store-interrupt-value.patch
enable-link-power-management-for-ata-drivers.patch
enable-aggressive-link-power-management-for-ahci.patch
ata-ahci-alpm-enable-link-power-management-for-ata-drivers.patch
ata-ahci-alpm-enable-link-power-management-for-ata-drivers-fix.patch
ata-ahci-alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
acpiphp_ibm-add-missing-n.patch
cpqphp_ctrlc-remove-dead-code.patch
acpi-bay-send-envp-with-uevent-fix.patch
acpi-dock-send-key=value-pair-instead-of-plain-value.patch
