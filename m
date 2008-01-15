From: akpm@linux-foundation.org
Subject: - libata-xfer_mask-is-unsigned-int-not-unsigned-long.patch removed from -mm tree
Date: Tue, 15 Jan 2008 13:43:38 -0800
Message-ID: <200801152143.m0FLhcPI004819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40535 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757544AbYAOVoF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 16:44:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     libata: xfer_mask is unsigned int not unsigned long
has been removed from the -mm tree.  Its filename was
     libata-xfer_mask-is-unsigned-int-not-unsigned-long.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libata: xfer_mask is unsigned int not unsigned long
From: Tejun Heo <htejun@gmail.com>

xfer_mask is unsigned int not unsigned long.  Change ->mode_filter to
take and return unsigned int.

While at it, rename @adev of ata_pci_default_filter() to @dev for
consistency.

[akpm@linux-foundation.org: fix types]
Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-sff.c       |    5 +++--
 drivers/ata/pata_acpi.c        |    2 +-
 drivers/ata/pata_ali.c         |    2 +-
 drivers/ata/pata_amd.c         |   10 +++++-----
 drivers/ata/pata_hpt366.c      |    2 +-
 drivers/ata/pata_hpt37x.c      |    4 ++--
 drivers/ata/pata_pdc2027x.c    |    4 ++--
 drivers/ata/pata_scc.c         |    2 +-
 drivers/ata/pata_serverworks.c |    4 ++--
 include/linux/libata.h         |    9 +++++----
 10 files changed, 23 insertions(+), 21 deletions(-)

diff -puN drivers/ata/libata-sff.c~libata-xfer_mask-is-unsigned-int-not-unsigned-long drivers/ata/libata-sff.c
--- a/drivers/ata/libata-sff.c~libata-xfer_mask-is-unsigned-int-not-unsigned-long
+++ a/drivers/ata/libata-sff.c
@@ -879,12 +879,13 @@ int ata_pci_clear_simplex(struct pci_dev
 	return 0;
 }
 
-unsigned long ata_pci_default_filter(struct ata_device *adev, unsigned long xfer_mask)
+unsigned int ata_pci_default_filter(struct ata_device *dev,
+				    unsigned int xfer_mask)
 {
 	/* Filter out DMA modes if the device has been configured by
 	   the BIOS as PIO only */
 
-	if (adev->link->ap->ioaddr.bmdma_addr == NULL)
+	if (dev->link->ap->ioaddr.bmdma_addr == NULL)
 		xfer_mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
 	return xfer_mask;
 }
diff -puN drivers/ata/pata_acpi.c~libata-xfer_mask-is-unsigned-int-not-unsigned-long drivers/ata/pata_acpi.c
--- a/drivers/ata/pata_acpi.c~libata-xfer_mask-is-unsigned-int-not-unsigned-long
+++ a/drivers/ata/pata_acpi.c
@@ -117,7 +117,7 @@ static unsigned long pacpi_discover_mode
  *	this case the list of discovered valid modes obtained by ACPI probing
  */
 
-static unsigned long pacpi_mode_filter(struct ata_device *adev, unsigned long mask)
+static unsigned int pacpi_mode_filter(struct ata_device *adev, unsigned int mask)
 {
 	struct pata_acpi *acpi = adev->link->ap->private_data;
 	return ata_pci_default_filter(adev, mask & acpi->mask[adev->devno]);
diff -puN drivers/ata/pata_ali.c~libata-xfer_mask-is-unsigned-int-not-unsigned-long drivers/ata/pata_ali.c
--- a/drivers/ata/pata_ali.c~libata-xfer_mask-is-unsigned-int-not-unsigned-long
+++ a/drivers/ata/pata_ali.c
@@ -108,7 +108,7 @@ static int ali_c2_cable_detect(struct at
  *	fix that later on. Also ensure we do not do UDMA on WDC drives
  */
 
-static unsigned long ali_20_filter(struct ata_device *adev, unsigned long mask)
+static unsigned int ali_20_filter(struct ata_device *adev, unsigned int mask)
 {
 	char model_num[ATA_ID_PROD_LEN + 1];
 	/* No DMA on anything but a disk for now */
diff -puN drivers/ata/pata_amd.c~libata-xfer_mask-is-unsigned-int-not-unsigned-long drivers/ata/pata_amd.c
--- a/drivers/ata/pata_amd.c~libata-xfer_mask-is-unsigned-int-not-unsigned-long
+++ a/drivers/ata/pata_amd.c
@@ -226,8 +226,8 @@ static void amd133_set_dmamode(struct at
  * cached during driver attach and are consulted to select transfer
  * mode.
  */
-static unsigned long nv_mode_filter(struct ata_device *dev,
-				    unsigned long xfer_mask)
+static unsigned int nv_mode_filter(struct ata_device *dev,
+				    unsigned int xfer_mask)
 {
 	static const unsigned int udma_mask_map[] =
 		{ ATA_UDMA2, ATA_UDMA1, ATA_UDMA0, 0,
@@ -236,7 +236,7 @@ static unsigned long nv_mode_filter(stru
 	char acpi_str[32] = "";
 	u32 saved_udma, udma;
 	const struct ata_acpi_gtm *gtm;
-	unsigned long bios_limit = 0, acpi_limit = 0, limit;
+	unsigned int bios_limit = 0, acpi_limit = 0, limit;
 
 	/* find out what BIOS configured */
 	udma = saved_udma = (unsigned long)ap->host->private_data;
@@ -269,8 +269,8 @@ static unsigned long nv_mode_filter(stru
 	if (!(limit & (ATA_MASK_MWDMA | ATA_MASK_UDMA)))
 		limit |= ATA_MASK_MWDMA | ATA_MASK_UDMA;
 
-	ata_port_printk(ap, KERN_DEBUG, "nv_mode_filter: 0x%lx&0x%lx->0x%lx, "
-			"BIOS=0x%lx (0x%x) ACPI=0x%lx%s\n",
+	ata_port_printk(ap, KERN_DEBUG, "nv_mode_filter: 0x%x&0x%x->0x%x, "
+			"BIOS=0x%x (0x%x) ACPI=0x%x%s\n",
 			xfer_mask, limit, xfer_mask & limit, bios_limit,
 			saved_udma, acpi_limit, acpi_str);
 
diff -puN drivers/ata/pata_hpt366.c~libata-xfer_mask-is-unsigned-int-not-unsigned-long drivers/ata/pata_hpt366.c
--- a/drivers/ata/pata_hpt366.c~libata-xfer_mask-is-unsigned-int-not-unsigned-long
+++ a/drivers/ata/pata_hpt366.c
@@ -174,7 +174,7 @@ static int hpt_dma_blacklisted(const str
  *	Block UDMA on devices that cause trouble with this controller.
  */
 
-static unsigned long hpt366_filter(struct ata_device *adev, unsigned long mask)
+static unsigned int hpt366_filter(struct ata_device *adev, unsigned int mask)
 {
 	if (adev->class == ATA_DEV_ATA) {
 		if (hpt_dma_blacklisted(adev, "UDMA",  bad_ata33))
diff -puN drivers/ata/pata_hpt37x.c~libata-xfer_mask-is-unsigned-int-not-unsigned-long drivers/ata/pata_hpt37x.c
--- a/drivers/ata/pata_hpt37x.c~libata-xfer_mask-is-unsigned-int-not-unsigned-long
+++ a/drivers/ata/pata_hpt37x.c
@@ -275,7 +275,7 @@ static const char *bad_ata100_5[] = {
  *	Block UDMA on devices that cause trouble with this controller.
  */
 
-static unsigned long hpt370_filter(struct ata_device *adev, unsigned long mask)
+static unsigned int hpt370_filter(struct ata_device *adev, unsigned int mask)
 {
 	if (adev->class == ATA_DEV_ATA) {
 		if (hpt_dma_blacklisted(adev, "UDMA", bad_ata33))
@@ -293,7 +293,7 @@ static unsigned long hpt370_filter(struc
  *	Block UDMA on devices that cause trouble with this controller.
  */
 
-static unsigned long hpt370a_filter(struct ata_device *adev, unsigned long mask)
+static unsigned int hpt370a_filter(struct ata_device *adev, unsigned int mask)
 {
 	if (adev->class == ATA_DEV_ATA) {
 		if (hpt_dma_blacklisted(adev, "UDMA100", bad_ata100_5))
diff -puN drivers/ata/pata_pdc2027x.c~libata-xfer_mask-is-unsigned-int-not-unsigned-long drivers/ata/pata_pdc2027x.c
--- a/drivers/ata/pata_pdc2027x.c~libata-xfer_mask-is-unsigned-int-not-unsigned-long
+++ a/drivers/ata/pata_pdc2027x.c
@@ -67,7 +67,7 @@ static void pdc2027x_error_handler(struc
 static void pdc2027x_set_piomode(struct ata_port *ap, struct ata_device *adev);
 static void pdc2027x_set_dmamode(struct ata_port *ap, struct ata_device *adev);
 static int pdc2027x_check_atapi_dma(struct ata_queued_cmd *qc);
-static unsigned long pdc2027x_mode_filter(struct ata_device *adev, unsigned long mask);
+static unsigned int pdc2027x_mode_filter(struct ata_device *adev, unsigned int mask);
 static int pdc2027x_cable_detect(struct ata_port *ap);
 static int pdc2027x_set_mode(struct ata_link *link, struct ata_device **r_failed);
 
@@ -336,7 +336,7 @@ static void pdc2027x_error_handler(struc
  *	Block UDMA on devices that cause trouble with this controller.
  */
 
-static unsigned long pdc2027x_mode_filter(struct ata_device *adev, unsigned long mask)
+static unsigned int pdc2027x_mode_filter(struct ata_device *adev, unsigned int mask)
 {
 	unsigned char model_num[ATA_ID_PROD_LEN + 1];
 	struct ata_device *pair = ata_dev_pair(adev);
diff -puN drivers/ata/pata_scc.c~libata-xfer_mask-is-unsigned-int-not-unsigned-long drivers/ata/pata_scc.c
--- a/drivers/ata/pata_scc.c~libata-xfer_mask-is-unsigned-int-not-unsigned-long
+++ a/drivers/ata/pata_scc.c
@@ -258,7 +258,7 @@ static void scc_set_dmamode (struct ata_
 		 JCTSStbl[offset][idx] << 16 | JCENVTtbl[offset][idx]);
 }
 
-unsigned long scc_mode_filter(struct ata_device *adev, unsigned long mask)
+unsigned int scc_mode_filter(struct ata_device *adev, unsigned int mask)
 {
 	/* errata A308 workaround: limit ATAPI UDMA mode to UDMA4 */
 	if (adev->class == ATA_DEV_ATAPI &&
diff -puN drivers/ata/pata_serverworks.c~libata-xfer_mask-is-unsigned-int-not-unsigned-long drivers/ata/pata_serverworks.c
--- a/drivers/ata/pata_serverworks.c~libata-xfer_mask-is-unsigned-int-not-unsigned-long
+++ a/drivers/ata/pata_serverworks.c
@@ -195,7 +195,7 @@ static u8 serverworks_is_csb(struct pci_
  *	bug we hit.
  */
 
-static unsigned long serverworks_osb4_filter(struct ata_device *adev, unsigned long mask)
+static unsigned int serverworks_osb4_filter(struct ata_device *adev, unsigned int mask)
 {
 	if (adev->class == ATA_DEV_ATA)
 		mask &= ~ATA_MASK_UDMA;
@@ -211,7 +211,7 @@ static unsigned long serverworks_osb4_fi
  *	Check the blacklist and disable UDMA5 if matched
  */
 
-static unsigned long serverworks_csb_filter(struct ata_device *adev, unsigned long mask)
+static unsigned int serverworks_csb_filter(struct ata_device *adev, unsigned int mask)
 {
 	const char *p;
 	char model_num[ATA_ID_PROD_LEN + 1];
diff -puN include/linux/libata.h~libata-xfer_mask-is-unsigned-int-not-unsigned-long include/linux/libata.h
--- a/include/linux/libata.h~libata-xfer_mask-is-unsigned-int-not-unsigned-long
+++ a/include/linux/libata.h
@@ -680,7 +680,7 @@ struct ata_port_operations {
 
 	void (*set_piomode) (struct ata_port *, struct ata_device *);
 	void (*set_dmamode) (struct ata_port *, struct ata_device *);
-	unsigned long (*mode_filter) (struct ata_device *, unsigned long);
+	unsigned int (*mode_filter) (struct ata_device *, unsigned int);
 
 	void (*tf_load) (struct ata_port *ap, const struct ata_taskfile *tf);
 	void (*tf_read) (struct ata_port *ap, struct ata_taskfile *tf);
@@ -1035,9 +1035,10 @@ extern int ata_pci_init_bmdma(struct ata
 extern int ata_pci_prepare_sff_host(struct pci_dev *pdev,
 				    const struct ata_port_info * const * ppi,
 				    struct ata_host **r_host);
-extern int pci_test_config_bits(struct pci_dev *pdev, const struct pci_bits *bits);
-extern unsigned long ata_pci_default_filter(struct ata_device *dev,
-					    unsigned long xfer_mask);
+extern int pci_test_config_bits(struct pci_dev *pdev,
+				const struct pci_bits *bits);
+extern unsigned int ata_pci_default_filter(struct ata_device *dev,
+					    unsigned int xfer_mask);
 #endif /* CONFIG_PCI */
 
 /*
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
git-kbuild.patch
git-libata-all.patch
libata-xfer_mask-is-unsigned-int-not-unsigned-long.patch
libata-add-toshiba-mk1637gsx-to-spurious-command-completion-list.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
pata_legacy-resychronize-with-upstream-changes-and-resubmit.patch
git-scsi-misc.patch
libata-correct-handling-of-tss-dvd.patch
libata-relocate-sdev-manage_start_stop-configuration.patch
