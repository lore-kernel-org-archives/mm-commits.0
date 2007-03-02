From: akpm@linux-foundation.org
Subject: + libata-dev_config-does-not-need-ap-and-adev-passing.patch added to -mm tree
Date: Thu, 01 Mar 2007 17:13:16 -0800
Message-ID: <200703020113.l221DGku028388@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33528 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964795AbXCBBN3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 20:13:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     libata: dev_config does not need ap and adev passing
has been added to the -mm tree.  Its filename is
     libata-dev_config-does-not-need-ap-and-adev-passing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: dev_config does not need ap and adev passing
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

It used to be impossible to get from ata_device to ata_port but that is no
longer true.  Various methods have been cleaned up over time but dev_config
still takes both and most users don't need both anyway.  Tidy this one up

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c       |    2 +-
 drivers/ata/pata_ali.c          |    2 +-
 drivers/ata/pata_it821x.c       |    3 +--
 drivers/ata/pata_pdc202xx_old.c |    3 +--
 drivers/ata/sata_inic162x.c     |    2 +-
 drivers/ata/sata_sil.c          |    6 +++---
 drivers/ata/sata_sil24.c        |    6 +++---
 include/linux/libata.h          |    2 +-
 8 files changed, 12 insertions(+), 14 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-dev_config-does-not-need-ap-and-adev-passing drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-dev_config-does-not-need-ap-and-adev-passing
+++ a/drivers/ata/libata-core.c
@@ -1785,7 +1785,7 @@ int ata_dev_configure(struct ata_device 
 	}
 
 	if (ap->ops->dev_config)
-		ap->ops->dev_config(ap, dev);
+		ap->ops->dev_config(dev);
 
 	if (ata_msg_probe(ap))
 		ata_dev_printk(dev, KERN_DEBUG, "%s: EXIT, drv_stat = 0x%x\n",
diff -puN drivers/ata/pata_ali.c~libata-dev_config-does-not-need-ap-and-adev-passing drivers/ata/pata_ali.c
--- a/drivers/ata/pata_ali.c~libata-dev_config-does-not-need-ap-and-adev-passing
+++ a/drivers/ata/pata_ali.c
@@ -324,7 +324,7 @@ static void ali_set_dmamode(struct ata_p
  *	slower PIO methods
  */
 
-static void ali_lock_sectors(struct ata_port *ap, struct ata_device *adev)
+static void ali_lock_sectors(struct ata_device *adev)
 {
 	adev->max_sectors = 255;
 }
diff -puN drivers/ata/pata_it821x.c~libata-dev_config-does-not-need-ap-and-adev-passing drivers/ata/pata_it821x.c
--- a/drivers/ata/pata_it821x.c~libata-dev_config-does-not-need-ap-and-adev-passing
+++ a/drivers/ata/pata_it821x.c
@@ -520,7 +520,6 @@ static int it821x_smart_set_mode(struct 
 
 /**
  *	it821x_dev_config	-	Called each device identify
- *	@ap: ATA port
  *	@adev: Device that has just been identified
  *
  *	Perform the initial setup needed for each device that is chip
@@ -531,7 +530,7 @@ static int it821x_smart_set_mode(struct 
  *	basically we need to filter commands for this chip.
  */
 
-static void it821x_dev_config(struct ata_port *ap, struct ata_device *adev)
+static void it821x_dev_config(struct ata_device *adev)
 {
 	unsigned char model_num[ATA_ID_PROD_LEN + 1];
 
diff -puN drivers/ata/pata_pdc202xx_old.c~libata-dev_config-does-not-need-ap-and-adev-passing drivers/ata/pata_pdc202xx_old.c
--- a/drivers/ata/pata_pdc202xx_old.c~libata-dev_config-does-not-need-ap-and-adev-passing
+++ a/drivers/ata/pata_pdc202xx_old.c
@@ -238,7 +238,6 @@ static void pdc2026x_bmdma_stop(struct a
 
 /**
  *	pdc2026x_dev_config	-	device setup hook
- *	@ap: ATA port
  *	@adev: newly found device
  *
  *	Perform chip specific early setup. We need to lock the transfer
@@ -246,7 +245,7 @@ static void pdc2026x_bmdma_stop(struct a
  *	barf.
  */
 
-static void pdc2026x_dev_config(struct ata_port *ap, struct ata_device *adev)
+static void pdc2026x_dev_config(struct ata_device *adev)
 {
 	adev->max_sectors = 256;
 }
diff -puN drivers/ata/sata_inic162x.c~libata-dev_config-does-not-need-ap-and-adev-passing drivers/ata/sata_inic162x.c
--- a/drivers/ata/sata_inic162x.c~libata-dev_config-does-not-need-ap-and-adev-passing
+++ a/drivers/ata/sata_inic162x.c
@@ -490,7 +490,7 @@ static void inic_post_internal_cmd(struc
 		inic_reset_port(inic_port_base(qc->ap));
 }
 
-static void inic_dev_config(struct ata_port *ap, struct ata_device *dev)
+static void inic_dev_config(struct ata_device *dev)
 {
 	/* inic can only handle upto LBA28 max sectors */
 	if (dev->max_sectors > ATA_MAX_SECTORS)
diff -puN drivers/ata/sata_sil.c~libata-dev_config-does-not-need-ap-and-adev-passing drivers/ata/sata_sil.c
--- a/drivers/ata/sata_sil.c~libata-dev_config-does-not-need-ap-and-adev-passing
+++ a/drivers/ata/sata_sil.c
@@ -114,7 +114,7 @@ static int sil_init_one (struct pci_dev 
 #ifdef CONFIG_PM
 static int sil_pci_device_resume(struct pci_dev *pdev);
 #endif
-static void sil_dev_config(struct ata_port *ap, struct ata_device *dev);
+static void sil_dev_config(struct ata_device *dev);
 static u32 sil_scr_read (struct ata_port *ap, unsigned int sc_reg);
 static void sil_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
 static void sil_post_set_mode (struct ata_port *ap);
@@ -519,7 +519,6 @@ static void sil_thaw(struct ata_port *ap
 
 /**
  *	sil_dev_config - Apply device/host-specific errata fixups
- *	@ap: Port containing device to be examined
  *	@dev: Device to be examined
  *
  *	After the IDENTIFY [PACKET] DEVICE step is complete, and a
@@ -546,8 +545,9 @@ static void sil_thaw(struct ata_port *ap
  *	appreciated.
  *	- But then again UDMA5 is hardly anything to complain about
  */
-static void sil_dev_config(struct ata_port *ap, struct ata_device *dev)
+static void sil_dev_config(struct ata_device *dev)
 {
+	struct ata_port *ap = dev->ap;
 	int print_info = ap->eh_context.i.flags & ATA_EHI_PRINTINFO;
 	unsigned int n, quirks = 0;
 	unsigned char model_num[ATA_ID_PROD_LEN + 1];
diff -puN drivers/ata/sata_sil24.c~libata-dev_config-does-not-need-ap-and-adev-passing drivers/ata/sata_sil24.c
--- a/drivers/ata/sata_sil24.c~libata-dev_config-does-not-need-ap-and-adev-passing
+++ a/drivers/ata/sata_sil24.c
@@ -323,7 +323,7 @@ struct sil24_port_priv {
 	struct ata_taskfile tf;			/* Cached taskfile registers */
 };
 
-static void sil24_dev_config(struct ata_port *ap, struct ata_device *dev);
+static void sil24_dev_config(struct ata_device *dev);
 static u8 sil24_check_status(struct ata_port *ap);
 static u32 sil24_scr_read(struct ata_port *ap, unsigned sc_reg);
 static void sil24_scr_write(struct ata_port *ap, unsigned sc_reg, u32 val);
@@ -459,9 +459,9 @@ static int sil24_tag(int tag)
 	return tag;
 }
 
-static void sil24_dev_config(struct ata_port *ap, struct ata_device *dev)
+static void sil24_dev_config(struct ata_device *dev)
 {
-	void __iomem *port = ap->ioaddr.cmd_addr;
+	void __iomem *port = dev->ap->ioaddr.cmd_addr;
 
 	if (dev->cdb_len == 16)
 		writel(PORT_CS_CDB16, port + PORT_CTRL_STAT);
diff -puN include/linux/libata.h~libata-dev_config-does-not-need-ap-and-adev-passing include/linux/libata.h
--- a/include/linux/libata.h~libata-dev_config-does-not-need-ap-and-adev-passing
+++ a/include/linux/libata.h
@@ -595,7 +595,7 @@ struct ata_port {
 struct ata_port_operations {
 	void (*port_disable) (struct ata_port *);
 
-	void (*dev_config) (struct ata_port *, struct ata_device *);
+	void (*dev_config) (struct ata_device *);
 
 	void (*set_piomode) (struct ata_port *, struct ata_device *);
 	void (*set_dmamode) (struct ata_port *, struct ata_device *);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

cyclades-return-closing_wait.patch
libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
acpi-driver-support-for-pata.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
libata-cable-detection-fixes.patch
libata-dev_config-does-not-need-ap-and-adev-passing.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
resend-iphase-64bit-cleanup.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-clarify-documentation-of-write.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
