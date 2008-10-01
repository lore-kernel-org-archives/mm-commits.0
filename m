From: akpm@linux-foundation.org
Subject: - misdn-annotate-iomem-pointer-and-add-statics.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:51:11 -0700
Message-ID: <200810012151.m91LpBDk005906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811AbYJAVvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:51:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     mISDN: annotate iomem pointer and add statics
has been removed from the -mm tree.  Its filename was
     misdn-annotate-iomem-pointer-and-add-statics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mISDN: annotate iomem pointer and add statics
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/mISDN/hfcpci.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/isdn/hardware/mISDN/hfcpci.c~misdn-annotate-iomem-pointer-and-add-statics drivers/isdn/hardware/mISDN/hfcpci.c
--- a/drivers/isdn/hardware/mISDN/hfcpci.c~misdn-annotate-iomem-pointer-and-add-statics
+++ a/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -43,7 +43,7 @@ MODULE_LICENSE("GPL");
 module_param(debug, uint, 0);
 
 static LIST_HEAD(HFClist);
-DEFINE_RWLOCK(HFClock);
+static DEFINE_RWLOCK(HFClock);
 
 enum {
 	HFC_CCD_2BD0,
@@ -88,7 +88,7 @@ struct hfcPCI_hw {
 	unsigned char		bswapped;
 	unsigned char		protocol;
 	int			nt_timer;
-	unsigned char		*pci_io; /* start of PCI IO memory */
+	unsigned char __iomem 	*pci_io; /* start of PCI IO memory */
 	dma_addr_t		dmahandle;
 	void			*fifos; /* FIFO memory */
 	int			last_bfifo_cnt[2];
@@ -153,7 +153,7 @@ release_io_hfcpci(struct hfc_pci *hc)
 	pci_write_config_word(hc->pdev, PCI_COMMAND, 0);
 	del_timer(&hc->hw.timer);
 	pci_free_consistent(hc->pdev, 0x8000, hc->hw.fifos, hc->hw.dmahandle);
-	iounmap((void *)hc->hw.pci_io);
+	iounmap(hc->hw.pci_io);
 }
 
 /*
@@ -522,7 +522,7 @@ receive_dmsg(struct hfc_pci *hc)
 /*
  * check for transparent receive data and read max one threshold size if avail
  */
-int
+static int
 hfcpci_empty_fifo_trans(struct bchannel *bch, struct bzfifo *bz, u_char *bdata)
 {
 	 __le16 *z1r, *z2r;
@@ -575,7 +575,7 @@ hfcpci_empty_fifo_trans(struct bchannel 
 /*
  * B-channel main receive routine
  */
-void
+static void
 main_rec_hfcpci(struct bchannel *bch)
 {
 	struct hfc_pci	*hc = bch->hw;
@@ -1678,7 +1678,7 @@ hfcpci_l2l1B(struct mISDNchannel *ch, st
  * called for card init message
  */
 
-void
+static void
 inithfcpci(struct hfc_pci *hc)
 {
 	printk(KERN_DEBUG "inithfcpci: entered\n");
@@ -1965,7 +1965,7 @@ setup_hw(struct hfc_pci *hc)
 		printk(KERN_WARNING "HFC-PCI: No IRQ for PCI card found\n");
 		return 1;
 	}
-	hc->hw.pci_io = (char *)(ulong)hc->pdev->resource[1].start;
+	hc->hw.pci_io = (char __iomem *)(unsigned long)hc->pdev->resource[1].start;
 
 	if (!hc->hw.pci_io) {
 		printk(KERN_WARNING "HFC-PCI: No IO-Mem for PCI card found\n");
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

fbcon-fix-monochrome-color-value-calculation.patch
git-avr32.patch
git-powerpc.patch
git-x86.patch
git-xtensa.patch
git-hid.patch
git-v4l-dvb.patch
git-xfs.patch
git-net.patch
git-sound.patch
git-block.patch
git-pcmcia.patch
git-battery.patch
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
char-moxac-sparse-annotation.patch
byteorder-add-new-headers-for-make-headers-install.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch
lib-pull-base-guessing-logic-to-helper-function.patch
lib-trivial-whitespace-tidy.patch
lib-remove-defining-macros-for-strict_strto.patch

