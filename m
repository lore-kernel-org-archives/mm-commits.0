From: akpm@linux-foundation.org
Subject: + pata_pdc2027x-bring-into-line-with-changes-add-the-mode.patch added to -mm tree
Date: Sun, 25 Mar 2007 00:53:37 -0800
Message-ID: <200703250853.l2P8rbEu024153@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36739 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbXCYIxs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 04:53:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     pata_pdc2027x: Bring into line with changes, add the mode filters as per Jeff's report
has been added to the -mm tree.  Its filename is
     pata_pdc2027x-bring-into-line-with-changes-add-the-mode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_pdc2027x: Bring into line with changes, add the mode filters as per Jeff's report
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

- Fix theoretical pdc2027x crash if the BIOS didn't assign BAR4 for DMA. 
  (Needs a default modefilter)

- Use cable methods

- Replace post_set_mode() use with wrapped set_mode() [Removes last use of
  post_set_mode]

- Mode filter Maxtor UDMA133 rule

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_pdc2027x.c |   60 ++++++++++++++++++++++++++--------
 1 file changed, 47 insertions(+), 13 deletions(-)

diff -puN drivers/ata/pata_pdc2027x.c~pata_pdc2027x-bring-into-line-with-changes-add-the-mode drivers/ata/pata_pdc2027x.c
--- a/drivers/ata/pata_pdc2027x.c~pata_pdc2027x-bring-into-line-with-changes-add-the-mode
+++ a/drivers/ata/pata_pdc2027x.c
@@ -35,7 +35,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_pdc2027x"
-#define DRV_VERSION	"0.8"
+#define DRV_VERSION	"0.9"
 #undef PDC_DEBUG
 
 #ifdef PDC_DEBUG
@@ -66,8 +66,10 @@ static int pdc2027x_init_one(struct pci_
 static void pdc2027x_error_handler(struct ata_port *ap);
 static void pdc2027x_set_piomode(struct ata_port *ap, struct ata_device *adev);
 static void pdc2027x_set_dmamode(struct ata_port *ap, struct ata_device *adev);
-static void pdc2027x_post_set_mode(struct ata_port *ap);
 static int pdc2027x_check_atapi_dma(struct ata_queued_cmd *qc);
+static unsigned long pdc2027x_mode_filter(struct ata_device *adev, unsigned long mask);
+static int pdc2027x_cable_detect(struct ata_port *ap);
+static int pdc2027x_set_mode(struct ata_port *ap, struct ata_device **r_failed);
 
 /*
  * ATA Timing Tables based on 133MHz controller clock.
@@ -146,6 +148,7 @@ static struct scsi_host_template pdc2027
 
 static struct ata_port_operations pdc2027x_pata100_ops = {
 	.port_disable		= ata_port_disable,
+	.mode_filter		= ata_pci_default_filter,
 
 	.tf_load		= ata_tf_load,
 	.tf_read		= ata_tf_read,
@@ -166,6 +169,7 @@ static struct ata_port_operations pdc202
 	.thaw			= ata_bmdma_thaw,
 	.error_handler		= pdc2027x_error_handler,
 	.post_internal_cmd 	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= pdc2027x_cable_detect,
 
 	.irq_handler		= ata_interrupt,
 	.irq_clear		= ata_bmdma_irq_clear,
@@ -179,7 +183,8 @@ static struct ata_port_operations pdc202
 	.port_disable		= ata_port_disable,
 	.set_piomode		= pdc2027x_set_piomode,
 	.set_dmamode		= pdc2027x_set_dmamode,
-	.post_set_mode		= pdc2027x_post_set_mode,
+	.set_mode		= pdc2027x_set_mode,
+	.mode_filter		= pdc2027x_mode_filter,
 
 	.tf_load		= ata_tf_load,
 	.tf_read		= ata_tf_read,
@@ -200,6 +205,7 @@ static struct ata_port_operations pdc202
 	.thaw			= ata_bmdma_thaw,
 	.error_handler		= pdc2027x_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= pdc2027x_cable_detect,
 
 	.irq_handler		= ata_interrupt,
 	.irq_clear		= ata_bmdma_irq_clear,
@@ -261,7 +267,7 @@ static inline void __iomem *dev_mmio(str
 }
 
 /**
- *	pdc2027x_pata_cbl_detect - Probe host controller cable detect info
+ *	pdc2027x_pata_cable_detect - Probe host controller cable detect info
  *	@ap: Port for which cable detect info is desired
  *
  *	Read 80c cable indicator from Promise extended register.
@@ -270,7 +276,7 @@ static inline void __iomem *dev_mmio(str
  *	LOCKING:
  *	None (inherited from caller).
  */
-static void pdc2027x_cbl_detect(struct ata_port *ap)
+static int pdc2027x_cable_detect(struct ata_port *ap)
 {
 	u32 cgcr;
 
@@ -281,13 +287,10 @@ static void pdc2027x_cbl_detect(struct a
 
 	PDPRINTK("No cable or 80-conductor cable on port %d\n", ap->port_no);
 
-	ap->cbl = ATA_CBL_PATA80;
-	return;
-
+	return ATA_CBL_PATA80;
 cbl40:
 	printk(KERN_INFO DRV_NAME ": 40-conductor cable detected on port %d\n", ap->port_no);
-	ap->cbl = ATA_CBL_PATA40;
-	ap->udma_mask &= ATA_UDMA_MASK_40C;
+	return ATA_CBL_PATA40;
 }
 
 /**
@@ -315,7 +318,6 @@ static int pdc2027x_prereset(struct ata_
 	/* Check whether port enabled */
 	if (!pdc2027x_port_enabled(ap))
 		return -ENOENT;
-	pdc2027x_cbl_detect(ap);
 	return ata_std_prereset(ap, deadline);
 }
 
@@ -335,6 +337,32 @@ static void pdc2027x_error_handler(struc
 }
 
 /**
+ *	pdc2720x_mode_filter	-	mode selection filter
+ *	@adev: ATA device
+ *	@mask: list of modes proposed
+ *
+ *	Block UDMA on devices that cause trouble with this controller.
+ */
+
+static unsigned long pdc2027x_mode_filter(struct ata_device *adev, unsigned long mask)
+{
+	unsigned char model_num[ATA_ID_PROD_LEN + 1];
+	struct ata_device *pair = ata_dev_pair(adev);
+
+	if (adev->class != ATA_DEV_ATA || adev->devno == 0 || pair == NULL)
+		return ata_pci_default_filter(adev, mask);
+
+	/* Check for slave of a Maxtor at UDMA6 */
+	ata_id_c_string(pair->id, model_num, ATA_ID_PROD,
+			  ATA_ID_PROD_LEN + 1);
+	/* If the master is a maxtor in UDMA6 then the slave should not use UDMA 6 */
+	if(strstr(model_num, "Maxtor") == 0 && pair->dma_mode == XFER_UDMA_6)
+		mask &= ~ (1 << (6 + ATA_SHIFT_UDMA));
+
+	return ata_pci_default_filter(adev, mask);
+}
+
+/**
  *	pdc2027x_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port to configure
  *	@adev: um
@@ -445,17 +473,22 @@ static void pdc2027x_set_dmamode(struct 
 }
 
 /**
- *	pdc2027x_post_set_mode - Set the timing registers back to correct values.
+ *	pdc2027x_set_mode - Set the timing registers back to correct values.
  *	@ap: Port to configure
+ *	@r_failed: Returned device for failure
  *
  *	The pdc2027x hardware will look at "SET FEATURES" and change the timing registers
  *	automatically. The values set by the hardware might be incorrect, under 133Mhz PLL.
  *	This function overwrites the possibly incorrect values set by the hardware to be correct.
  */
-static void pdc2027x_post_set_mode(struct ata_port *ap)
+static int pdc2027x_set_mode(struct ata_port *ap, struct ata_device **r_failed)
 {
 	int i;
 
+	i = ata_do_set_mode(ap, r_failed);
+	if (i < 0)
+		return i;
+
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		struct ata_device *dev = &ap->device[i];
 
@@ -477,6 +510,7 @@ static void pdc2027x_post_set_mode(struc
 			}
 		}
 	}
+	return 0;
 }
 
 /**
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

generic_serial-fix-decoding-of-baud-rate.patch
git-libata-all.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
libata-misc-minor-merge-fixups.patch
tty-minor-merge-correction.patch
pata_pdc202xx_old-lba48-bug.patch
pata_hpt37x-further-small-fixes.patch
pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
pata_pdc2027x-bring-into-line-with-changes-add-the-mode.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
baycom_ser_fdx-also-allow-i-o-ports-=-0x1000-and-enhanced.patch
resend-iphase-64bit-cleanup.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
protect-tty-drivers-list-with-tty_mutex.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
