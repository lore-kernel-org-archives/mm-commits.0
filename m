From: akpm@linux-foundation.org
Subject: + misdn-annotate-iomem-pointer-and-add-statics.patch added to -mm tree
Date: Mon, 11 Aug 2008 17:14:28 -0700
Message-ID: <200808120014.m7C0ESju029643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753822AbYHLAPE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 20:15:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, kkeil@suse.de


The patch titled
     mISDN: annotate iomem pointer and add statics
has been added to the -mm tree.  Its filename is
     misdn-annotate-iomem-pointer-and-add-statics.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
v4l-drx397xdc-sparse-annotations.patch
input-ads7846c-sparse-lock-annotation.patch
kvm-make-functions-static.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch

