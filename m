From: akpm@linux-foundation.org
Subject: + alpm-enable-link-power-management-for-ata-drivers.patch added to -mm tree
Date: Mon, 06 Aug 2007 11:26:59 -0700
Message-ID: <200708061826.l76IQxnl008161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45524 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754756AbXHFS1N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 14:27:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     ALPM: enable link power management for ata drivers
has been added to the -mm tree.  Its filename is
     alpm-enable-link-power-management-for-ata-drivers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ALPM: enable link power management for ata drivers
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

libata drivers can define a function (enable_pm) that will perform hardware
specific actions to enable whatever power management policy the user set up
from the scsi sysfs interface if the driver supports it.  This power
management policy will be activated after all disks have been enumerated and
intialized.  Drivers should also define disable_pm, which will turn off link
power management, but not change link power management policy.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/scsi/link_power_management_policy.txt |   19 +
 drivers/ata/libata-core.c                           |   41 +++
 drivers/ata/libata-scsi.c                           |  113 ++++++++++
 include/linux/ata.h                                 |    6 
 include/linux/libata.h                              |   23 +-
 5 files changed, 198 insertions(+), 4 deletions(-)

diff -puN /dev/null Documentation/scsi/link_power_management_policy.txt
--- /dev/null
+++ a/Documentation/scsi/link_power_management_policy.txt
@@ -0,0 +1,19 @@
+This parameter allows the user to set the link (interface) power management.
+There are 3 possible options:
+
+Value			Effect
+----------------------------------------------------------------------------
+min_power		Tell the controller to try to make the link use the
+			least possible power when possible.  This may
+			sacrifice some performance due to increased latency
+			when coming out of lower power states.
+
+max_performance		Generally, this means no power management.  Tell
+			the controller to have performance be a priority
+			over power management.
+
+medium_power		Tell the controller to enter a lower power state
+			when possible, but do not enter the lowest power
+			state, thus improving latency over min_power setting.
+
+
diff -puN drivers/ata/libata-core.c~alpm-enable-link-power-management-for-ata-drivers drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~alpm-enable-link-power-management-for-ata-drivers
+++ a/drivers/ata/libata-core.c
@@ -1993,6 +1993,9 @@ int ata_dev_configure(struct ata_device 
 	if (dev->flags & ATA_DFLAG_LBA48)
 		dev->max_sectors = ATA_MAX_SECTORS_LBA48;
 
+	if (ata_id_has_hipm(dev->id) || ata_id_has_dipm(dev->id))
+		dev->flags |= ATA_DFLAG_IPM;
+
 	if (dev->horkage & ATA_HORKAGE_DIAGNOSTIC) {
 		/* Let the user know. We don't want to disallow opens for
 		   rescue purposes, or in case the vendor is just a blithering
@@ -2018,6 +2021,13 @@ int ata_dev_configure(struct ata_device 
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
 					 dev->max_sectors);
 
+	if (ata_dev_blacklisted(dev) & ATA_HORKAGE_IPM) {
+		dev->horkage |= ATA_HORKAGE_IPM;
+
+		/* reset link pm_policy for this port to no pm */
+		ap->pm_policy = MAX_PERFORMANCE;
+	}
+
 	if (ap->ops->dev_config)
 		ap->ops->dev_config(dev);
 
@@ -5913,6 +5923,27 @@ int ata_flush_cache(struct ata_device *d
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
+		ata_scsi_set_link_pm_policy(ap, ap->pm_policy);
+	}
+}
+
 #ifdef CONFIG_PM
 static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
 			       unsigned int action, unsigned int ehi_flags,
@@ -5980,6 +6011,12 @@ int ata_host_suspend(struct ata_host *ho
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
@@ -6002,6 +6039,9 @@ void ata_host_resume(struct ata_host *ho
 	ata_host_request_pm(host, PMSG_ON, ATA_EH_SOFTRESET,
 			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
 	host->dev->power.power_state = PMSG_ON;
+
+	/* reenable link pm */
+	ata_host_enable_link_pm(host);
 }
 #endif
 
@@ -6498,6 +6538,7 @@ int ata_host_register(struct ata_host *h
 		struct ata_port *ap = host->ports[i];
 
 		ata_scsi_scan_host(ap, 1);
+		ata_scsi_set_link_pm_policy(ap, ap->pm_policy);
 	}
 
 	return 0;
diff -puN drivers/ata/libata-scsi.c~alpm-enable-link-power-management-for-ata-drivers drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~alpm-enable-link-power-management-for-ata-drivers
+++ a/drivers/ata/libata-scsi.c
@@ -111,6 +111,78 @@ static struct scsi_transport_template at
 };
 
 
+static const struct {
+	enum link_pm	value;
+	char		*name;
+} link_pm_policy[] = {
+	{ NOT_AVAILABLE, "max_performance" },
+	{ MIN_POWER, "min_power" },
+	{ MAX_PERFORMANCE, "max_performance" },
+	{ MEDIUM_POWER, "medium_power" },
+};
+
+const char *ata_scsi_link_pm_policy(enum link_pm policy)
+{
+	int i;
+	char *name = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(link_pm_policy); i++) {
+		if (link_pm_policy[i].value == policy) {
+			name = link_pm_policy[i].name;
+			break;
+		}
+	}
+	return name;
+}
+
+static ssize_t store_link_pm_policy(struct class_device *class_dev,
+	const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	enum link_pm policy = 0;
+	int i;
+
+	/*
+ 	 * we are skipping array location 0 on purpose - this
+ 	 * is because a value of NOT_AVAILABLE is displayed
+ 	 * to the user as max_performance, but when the user
+ 	 * writes "max_performance", they actually want the
+ 	 * value to match MAX_PERFORMANCE.
+ 	 */
+	for (i = 1; i < ARRAY_SIZE(link_pm_policy); i++) {
+		const int len = strlen(link_pm_policy[i].name);
+		if (strncmp(link_pm_policy[i].name, buf, len) == 0 &&
+		   buf[len] == '\n') {
+			policy = link_pm_policy[i].value;
+			break;
+		}
+	}
+	if (!policy)
+		return -EINVAL;
+
+	if (ata_scsi_set_link_pm_policy(ap, policy))
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t
+show_link_pm_policy(struct class_device *class_dev, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	const char *policy =
+		ata_scsi_link_pm_policy(ap->pm_policy);
+
+	if (!policy)
+		return -EINVAL;
+
+	return snprintf(buf, 23, "%s\n", policy);
+}
+CLASS_DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
+		show_link_pm_policy, store_link_pm_policy);
+EXPORT_SYMBOL_GPL(class_device_attr_link_power_management_policy);
+
 static void ata_scsi_invalid_field(struct scsi_cmnd *cmd,
 				   void (*done)(struct scsi_cmnd *))
 {
@@ -2905,6 +2977,47 @@ void ata_scsi_simulate(struct ata_device
 	}
 }
 
+int ata_scsi_set_link_pm_policy(struct ata_port *ap,
+		enum link_pm policy)
+{
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
+		if ((dev->horkage & ATA_HORKAGE_IPM) ||
+			!(dev->flags & ATA_DFLAG_IPM)) {
+			ata_dev_printk(dev, KERN_ERR,
+				"Unable to set Link PM policy\n");
+			ap->pm_policy = MAX_PERFORMANCE;
+		}
+	}
+
+	if (ap->ops->enable_pm)
+		rc = ap->ops->enable_pm(ap, policy);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ata_scsi_set_link_pm_policy);
+
 int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 {
 	int i, rc;
diff -puN include/linux/ata.h~alpm-enable-link-power-management-for-ata-drivers include/linux/ata.h
--- a/include/linux/ata.h~alpm-enable-link-power-management-for-ata-drivers
+++ a/include/linux/ata.h
@@ -355,6 +355,12 @@ struct ata_taskfile {
 	  ((u64) (id)[(n) + 0]) )
 
 #define ata_id_cdb_intr(id)	(((id)[0] & 0x60) == 0x20)
+#define ata_id_has_hipm(id)	\
+	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
+	  ((id)[76] & (1 << 9)) )
+#define ata_id_has_dipm(id)	\
+	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
+	  ((id)[78] & (1 << 3)) )
 
 static inline unsigned int ata_id_major_version(const u16 *id)
 {
diff -puN include/linux/libata.h~alpm-enable-link-power-management-for-ata-drivers include/linux/libata.h
--- a/include/linux/libata.h~alpm-enable-link-power-management-for-ata-drivers
+++ a/include/linux/libata.h
@@ -139,7 +139,8 @@ enum {
 	ATA_DFLAG_FLUSH_EXT	= (1 << 4), /* do FLUSH_EXT instead of FLUSH */
 	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
 	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
-	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,
+	ATA_DFLAG_IPM		= (1 << 7), /* device supports IPM */
+	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
 
 	ATA_DFLAG_PIO		= (1 << 8), /* device limited to PIO mode */
 	ATA_DFLAG_NCQ_OFF	= (1 << 9), /* device limited to non-NCQ mode */
@@ -310,6 +311,7 @@ enum {
 	ATA_HORKAGE_NODMA	= (1 << 1),	/* DMA problems */
 	ATA_HORKAGE_NONCQ	= (1 << 2),	/* Don't use NCQ */
 	ATA_HORKAGE_MAX_SEC_128	= (1 << 3),	/* Limit max sects to 128 */
+	ATA_HORKAGE_IPM		= (1 << 4), 	/* LPM problems */
 };
 
 enum hsm_task_states {
@@ -348,6 +350,18 @@ typedef int (*ata_reset_fn_t)(struct ata
 			      unsigned long deadline);
 typedef void (*ata_postreset_fn_t)(struct ata_port *ap, unsigned int *classes);
 
+/*
+ * host pm policy: If you alter this, you also need to alter scsi_sysfs.c
+ * (for the ascii descriptions)
+ */
+enum link_pm {
+	NOT_AVAILABLE,
+	MIN_POWER,
+	MAX_PERFORMANCE,
+	MEDIUM_POWER,
+};
+extern struct class_device_attribute class_device_attr_link_power_management_policy;
+
 struct ata_ioports {
 	void __iomem		*cmd_addr;
 	void __iomem		*data_addr;
@@ -574,6 +588,7 @@ struct ata_port {
 
 	pm_message_t		pm_mesg;
 	int			*pm_result;
+	enum link_pm		pm_policy;
 
 	struct timer_list	fastdrain_timer;
 	unsigned long		fastdrain_cnt;
@@ -639,7 +654,8 @@ struct ata_port_operations {
 
 	int (*port_suspend) (struct ata_port *ap, pm_message_t mesg);
 	int (*port_resume) (struct ata_port *ap);
-
+	int (*enable_pm) (struct ata_port *ap, enum link_pm policy);
+	int (*disable_pm) (struct ata_port *ap);
 	int (*port_start) (struct ata_port *ap);
 	void (*port_stop) (struct ata_port *ap);
 
@@ -847,7 +863,7 @@ extern int ata_cable_40wire(struct ata_p
 extern int ata_cable_80wire(struct ata_port *ap);
 extern int ata_cable_sata(struct ata_port *ap);
 extern int ata_cable_unknown(struct ata_port *ap);
-
+extern int ata_scsi_set_link_pm_policy(struct ata_port *ap, enum link_pm);
 /*
  * Timing helpers
  */
@@ -876,7 +892,6 @@ enum {
 				  ATA_TIMING_CYCLE | ATA_TIMING_UDMA,
 };
 
-
 #ifdef CONFIG_PCI
 struct pci_bits {
 	unsigned int		reg;	/* PCI config register to read */
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

alpm-store-interrupt-value.patch
alpm-enable-link-power-management-for-ata-drivers.patch
alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
acpiphp_ibm-add-missing-n.patch
cpqphp_ctrlc-remove-dead-code.patch
acpi-bay-send-envp-with-uevent-fix.patch
acpi-dock-send-key=value-pair-instead-of-plain-value.patch
