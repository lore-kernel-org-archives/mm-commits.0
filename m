From: akpm@linux-foundation.org
Subject: - drivers-atm-iphasec-mostly-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:12:57 -0700
Message-ID: <200708141912.l7EJCv8m016450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49461 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765169AbXHNTUf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     drivers/atm/iphase.c: mostly kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-atm-iphasec-mostly-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/atm/iphase.c: mostly kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/atm/iphase.c | 111508 -> 111431 (-77 bytes)
 drivers/atm/iphase.o | 254740 -> 254260 (-480 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/iphase.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/atm/iphase.c~drivers-atm-iphasec-mostly-kmalloc-memset-conversion-to-kzalloc drivers/atm/iphase.c
--- a/drivers/atm/iphase.c~drivers-atm-iphasec-mostly-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/atm/iphase.c
@@ -1601,14 +1601,14 @@ static int rx_init(struct atm_dev *dev) 
   
 	skb_queue_head_init(&iadev->rx_dma_q);  
 	iadev->rx_free_desc_qhead = NULL;   
-	iadev->rx_open = kmalloc(4*iadev->num_vc,GFP_KERNEL);
-	if (!iadev->rx_open)  
-	{  
+
+	iadev->rx_open = kzalloc(4 * iadev->num_vc, GFP_KERNEL);
+	if (!iadev->rx_open) {
 		printk(KERN_ERR DEV_LABEL "itf %d couldn't get free page\n",
 		dev->number);  
 		goto err_free_dle;
 	}  
-	memset(iadev->rx_open, 0, 4*iadev->num_vc);  
+
         iadev->rxing = 1;
         iadev->rx_pkt_cnt = 0;
 	/* Mode Register */  
@@ -3171,12 +3171,12 @@ static int __devinit ia_init_one(struct 
         unsigned long flags;
 	int ret;
 
-	iadev = kmalloc(sizeof(*iadev), GFP_KERNEL); 
+	iadev = kzalloc(sizeof(*iadev), GFP_KERNEL);
 	if (!iadev) {
 		ret = -ENOMEM;
 		goto err_out;
 	}
-	memset(iadev, 0, sizeof(*iadev));
+
 	iadev->pci = pdev;
 
 	IF_INIT(printk("ia detected at bus:%d dev: %d function:%d\n",
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
git-alsa.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-hw-handlerc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-path-selectorc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-tablec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-targetc-kmalloc-memset-conversion-to-kzalloc.patch
git-dvb.patch
drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
git-mmc.patch
drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-netdev-all.patch
drivers-scsi-a4000tc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-bvme6000_scsic-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-gdthc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-lpfc-lpfc_debugfsc-kmalloc-memset-conversion-to-kcalloc.patch
drivers-scsi-lpfc-lpfc_initc-kmalloc-memset-conversion-to-kcalloc.patch
drivers-scsi-lpfc-lpfc_scsic-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-megaraidc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-dpt_i2oc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
message-fusion-remove-redundant-memset.patch
drivers-usb-misc-ftdi-elanc-kmalloc-memset-conversion-to-kzalloc.patch
usb-remove-redundant-memset-from-amd5536udc.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
