From: akpm@linux-foundation.org
Subject: - ata-ahci-enclosure-management-via-led.patch removed from -mm tree
Date: Fri, 14 Dec 2007 14:40:29 -0800
Message-ID: <200712142240.lBEMeUJx018835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36104 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934544AbXLNWks (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Dec 2007 17:40:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, alan@lxorguk.ukuu.org.uk, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ata: ahci: Enclosure Management via LED
has been removed from the -mm tree.  Its filename was
     ata-ahci-enclosure-management-via-led.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: ata: ahci: Enclosure Management via LED
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Implement Enclosure Management via the LED protocol.  See the AHCI 1.1 spec
for details.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c        |  154 +++++++++++++++++++++++++++++++++++-
 drivers/ata/libata-scsi.c |    5 -
 include/linux/libata.h    |    2 
 3 files changed, 157 insertions(+), 4 deletions(-)

diff -puN drivers/ata/ahci.c~ata-ahci-enclosure-management-via-led drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ata-ahci-enclosure-management-via-led
+++ a/drivers/ata/ahci.c
@@ -44,6 +44,7 @@
 #include <linux/dmi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <linux/libata.h>
 
 #define DRV_NAME	"ahci"
@@ -92,6 +93,8 @@ enum {
 	HOST_IRQ_STAT		= 0x08, /* interrupt status */
 	HOST_PORTS_IMPL		= 0x0c, /* bitmap of implemented ports */
 	HOST_VERSION		= 0x10, /* AHCI spec. version compliancy */
+	HOST_EM_LOC		= 0x1c, /* Enclosure Management location */
+	HOST_EM_CTL		= 0x20, /* Enclosure Management Control */
 
 	/* HOST_CTL bits */
 	HOST_RESET		= (1 << 0),  /* reset controller; self-clear */
@@ -99,6 +102,7 @@ enum {
 	HOST_AHCI_EN		= (1 << 31), /* AHCI enabled */
 
 	/* HOST_CAP bits */
+	HOST_CAP_EMS		= (1 << 6),  /* Enclosure Management support */
 	HOST_CAP_SSC		= (1 << 14), /* Slumber capable */
 	HOST_CAP_PMP		= (1 << 17), /* Port Multiplier support */
 	HOST_CAP_CLO		= (1 << 24), /* Command List Override support */
@@ -194,6 +198,10 @@ enum {
 					  ATA_FLAG_IPM,
 	AHCI_LFLAG_COMMON		= ATA_LFLAG_SKIP_D2H_BSY,
 
+	/* em_ctl bits */
+	EM_CTL_RST			= (1 << 9), /* Reset */
+	EM_CTL_TM			= (1 << 8), /* Transmit Message */
+
 	ICH_MAP				= 0x90, /* ICH MAP register */
 };
 
@@ -218,6 +226,7 @@ struct ahci_host_priv {
 	u32			port_map;	/* port map to use */
 	u32			saved_cap;	/* saved initial cap */
 	u32			saved_port_map;	/* saved initial port_map */
+	u32 			em_loc; /* enclosure management location */
 };
 
 struct ahci_port_priv {
@@ -233,6 +242,7 @@ struct ahci_port_priv {
 	unsigned int		ncq_saw_dmas:1;
 	unsigned int		ncq_saw_sdb:1;
 	u32 			intr_mask;	/* interrupts to enable */
+	u16			led_state;	/* saved current led state */
 };
 
 static int ahci_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
@@ -578,6 +588,11 @@ static struct pci_driver ahci_pci_driver
 #endif
 };
 
+static int ahci_em_messages = 1;
+module_param(ahci_em_messages, int, 0444);
+/* add other LED protocol types when they become supported */
+MODULE_PARM_DESC(ahci_em_messages,
+	"Set AHCI Enclosure Management Message type (0 = disabled, 1 = LED");
 
 static inline int ahci_nr_ports(u32 cap)
 {
@@ -1088,6 +1103,118 @@ static int ahci_reset_controller(struct 
 	return 0;
 }
 
+/****** LED Enclosure Management routines ********/
+static int ahci_reset_em(struct ata_host *host)
+{
+	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+	u32 em_ctl;
+
+	em_ctl = readl(mmio + HOST_EM_CTL);
+	if ((em_ctl & EM_CTL_TM) || (em_ctl & EM_CTL_RST))
+		return -EINVAL;
+
+	writel(em_ctl | EM_CTL_RST, mmio + HOST_EM_CTL);
+	return 0;
+}
+
+static int ahci_transmit_led_message(struct ata_port *ap, int led_num,
+			int state)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
+	struct ahci_port_priv *pp = ap->private_data;
+	u32 em_ctl;
+	u32 message[] = {0, 0};
+	unsigned int flags;
+
+	spin_lock_irqsave(ap->lock, flags);
+
+	/*
+	 * if we are still busy transmitting a previous message,
+	 * do not allow
+	 */
+	em_ctl = readl(mmio + HOST_EM_CTL);
+	if (em_ctl & EM_CTL_TM) {
+		spin_unlock_irqrestore(ap->lock, flags);
+		return -EINVAL;
+	}
+
+	/*
+	 * create message header - this is all zero except for
+	 * the message size, which is 4 bytes.
+	 */
+	message[0] |= (4 << 8);
+
+	pp->led_state &= ~(9 << (3*led_num));
+
+	/*
+	 * create the actual message
+	 * XXX will need Port Multiplier support
+	 */
+	message[1] = (ap->port_no | (pp->led_state << 16));
+
+	/* LED bit locations are determined by the led_num */
+	message[1] |= (state << (16 + (3*led_num)));
+
+	/* write message to EM_LOC */
+	writel(message[0], mmio + hpriv->em_loc);
+	writel(message[1], mmio + hpriv->em_loc+4);
+
+	/* save off new led state */
+	pp->led_state = ((message[1] >> 16) & 0x00ff);
+
+	/*
+	 * tell hardware to transmit the message
+	 */
+	writel(em_ctl | EM_CTL_TM, mmio + HOST_EM_CTL);
+
+	spin_unlock_irqrestore(ap->lock, flags);
+	return 0;
+}
+
+static int ahci_led_store(struct device *dev, const char *buf, int num)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	struct ata_device *atadev = ata_scsi_find_dev(ap, sdev);
+	int state;
+
+	if (!atadev || !ata_dev_enabled(atadev))
+		return -EINVAL;
+
+	state = simple_strtoul(buf, NULL, 0);
+	if (state != 0 && state != 1)
+		return -EINVAL;
+
+	return ahci_transmit_led_message(ap, num, state);
+}
+
+static ssize_t ahci_led_locate_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	int rc = ahci_led_store(dev, buf, 1);
+	if (!rc)
+		return count;
+	return rc;
+}
+static DEVICE_ATTR(locate, S_IWUSR | S_IRUGO, NULL, ahci_led_locate_store);
+
+static ssize_t ahci_led_fault_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	int rc = ahci_led_store(dev, buf, 2);
+	if (!rc)
+		return count;
+	return rc;
+}
+static DEVICE_ATTR(fault, S_IWUGO, NULL, ahci_led_fault_store);
+
+static struct device_attribute *ahci_em_led_attrs[] = {
+	&dev_attr_locate,
+	&dev_attr_fault,
+	NULL
+};
+
 static void ahci_port_init(struct pci_dev *pdev, struct ata_port *ap,
 			   int port_no, void __iomem *mmio,
 			   void __iomem *port_mmio)
@@ -2116,7 +2243,8 @@ static void ahci_print_info(struct ata_h
 	dev_printk(KERN_INFO, &pdev->dev,
 		"flags: "
 		"%s%s%s%s%s%s%s"
-		"%s%s%s%s%s%s%s\n"
+		"%s%s%s%s%s%s%s"
+		"%s\n"
 		,
 
 		cap & (1 << 31) ? "64bit " : "",
@@ -2133,7 +2261,8 @@ static void ahci_print_info(struct ata_h
 		cap & (1 << 17) ? "pmp " : "",
 		cap & (1 << 15) ? "pio " : "",
 		cap & (1 << 14) ? "slum " : "",
-		cap & (1 << 13) ? "part " : ""
+		cap & (1 << 13) ? "part " : "",
+		cap & (1 << 6) ? "ems ": ""
 		);
 }
 
@@ -2285,6 +2414,27 @@ static int ahci_init_one(struct pci_dev 
 	ahci_init_controller(host);
 	ahci_print_info(host);
 
+	if (ahci_em_messages && (hpriv->cap & HOST_CAP_EMS)) {
+		u8 messages;
+		void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+		u32 em_loc = readl(mmio + HOST_EM_LOC);
+		u32 em_ctl = readl(mmio + HOST_EM_CTL);
+
+		messages = (em_ctl & 0x000f0000) >> 16;
+
+		/* we only support LED message type right now */
+		if ((messages & 0x01) && (ahci_em_messages == 1)) {
+			/* store em_loc */
+			hpriv->em_loc = ((em_loc >> 16) * 4);
+
+			/* reset the LEDs */
+			ahci_reset_em(host);
+
+			/* modify sht to add led sysfs files */
+			ahci_sht.sdev_attrs = ahci_em_led_attrs;
+		}
+	}
+
 	pci_set_master(pdev);
 	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
 				 &ahci_sht);
diff -puN drivers/ata/libata-scsi.c~ata-ahci-enclosure-management-via-led drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~ata-ahci-enclosure-management-via-led
+++ a/drivers/ata/libata-scsi.c
@@ -55,7 +55,7 @@ typedef unsigned int (*ata_xlat_func_t)(
 
 static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
 					const struct scsi_device *scsidev);
-static struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
+struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
 					    const struct scsi_device *scsidev);
 static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
 			      unsigned int id, unsigned int lun);
@@ -2622,7 +2622,7 @@ static int ata_scsi_dev_enabled(struct a
  *	RETURNS:
  *	Associated ATA device, or %NULL if not found.
  */
-static struct ata_device *
+struct ata_device *
 ata_scsi_find_dev(struct ata_port *ap, const struct scsi_device *scsidev)
 {
 	struct ata_device *dev = __ata_scsi_find_dev(ap, scsidev);
@@ -2632,6 +2632,7 @@ ata_scsi_find_dev(struct ata_port *ap, c
 
 	return dev;
 }
+EXPORT_SYMBOL_GPL(ata_scsi_find_dev);
 
 /*
  *	ata_scsi_map_proto - Map pass-thru protocol value to taskfile value.
diff -puN include/linux/libata.h~ata-ahci-enclosure-management-via-led include/linux/libata.h
--- a/include/linux/libata.h~ata-ahci-enclosure-management-via-led
+++ a/include/linux/libata.h
@@ -919,6 +919,8 @@ extern int ata_scsi_slave_config(struct 
 extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth);
+struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
+				      const struct scsi_device *scsidev);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);
 extern int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
 extern u8 ata_irq_on(struct ata_port *ap);
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

ata-ahci-enclosure-management-via-led.patch
pcie-fix-double-initialization-bug.patch
pcie-aer-dont-check-_osc-when-acpi-is-disabled.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
pnp-do-not-stop-start-devices-in-suspend-resume-path.patch
