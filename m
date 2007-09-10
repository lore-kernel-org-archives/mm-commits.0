From: akpm@linux-foundation.org
Subject: + ahci-raid-mode-sata-patch-for-intel-tolapai.patch added to -mm tree
Date: Mon, 10 Sep 2007 02:51:25 -0700
Message-ID: <200709100951.l8A9pPlf018127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755728AbXIJJva (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 05:51:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jason.d.gaston@intel.com


The patch titled
     ahci: RAID mode SATA patch for Intel Tolapai
has been added to the -mm tree.  Its filename is
     ahci-raid-mode-sata-patch-for-intel-tolapai.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ahci: RAID mode SATA patch for Intel Tolapai
From: Jason Gaston <jason.d.gaston@intel.com>

This patch adds the Intel Tolapai RAID controller DID's for SATA support.

Signed-off-by: Jason Gaston <jason.d.gaston@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c      |    2 ++
 drivers/ata/ahci.c.orig |   15 ++++++---------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/ata/ahci.c~ahci-raid-mode-sata-patch-for-intel-tolapai drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ahci-raid-mode-sata-patch-for-intel-tolapai
+++ a/drivers/ata/ahci.c
@@ -409,6 +409,8 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(INTEL, 0x292f), board_ahci_pi }, /* ICH9M */
 	{ PCI_VDEVICE(INTEL, 0x294d), board_ahci_pi }, /* ICH9 */
 	{ PCI_VDEVICE(INTEL, 0x294e), board_ahci_pi }, /* ICH9M */
+	{ PCI_VDEVICE(INTEL, 0x502a), board_ahci }, /* Tolapai */
+	{ PCI_VDEVICE(INTEL, 0x502b), board_ahci }, /* Tolapai */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
diff -puN drivers/ata/ahci.c.orig~ahci-raid-mode-sata-patch-for-intel-tolapai drivers/ata/ahci.c.orig
--- a/drivers/ata/ahci.c.orig~ahci-raid-mode-sata-patch-for-intel-tolapai
+++ a/drivers/ata/ahci.c.orig
@@ -1084,15 +1084,8 @@ static int ahci_do_softreset(struct ata_
 	tf.ctl &= ~ATA_SRST;
 	ahci_exec_polled_cmd(ap, pmp, &tf, 0, 0, 0);
 
-	/* spec mandates ">= 2ms" before checking status.
-	 * We wait 150ms, because that was the magic delay used for
-	 * ATAPI devices in Hale Landis's ATADRVR, for the period of time
-	 * between when the ATA command register is written, and then
-	 * status is checked.  Because waiting for "a while" before
-	 * checking status is fine, post SRST, we perform this magic
-	 * delay here as well.
-	 */
-	msleep(150);
+	/* wait a while before checking status */
+	ata_wait_after_reset(ap, deadline);
 
 	rc = ata_wait_ready(ap, deadline);
 	/* link occupied, -ENODEV too is an error */
@@ -1885,6 +1878,10 @@ static int ahci_init_one(struct pci_dev 
 		struct ata_port *ap = host->ports[i];
 		void __iomem *port_mmio = ahci_port_base(ap);
 
+		ata_port_pbar_desc(ap, AHCI_PCI_BAR, -1, "abar");
+		ata_port_pbar_desc(ap, AHCI_PCI_BAR,
+				   0x100 + ap->port_no * 0x80, "port");
+
 		/* standard SATA port setup */
 		if (hpriv->port_map & (1 << i))
 			ap->ioaddr.cmd_addr = port_mmio;
_

Patches currently in -mm which might be from jason.d.gaston@intel.com are

irq-irq-and-pci_ids-patch-for-intel-tolapai.patch
irq-irq-and-pci_ids-patch-for-intel-tolapai-fix.patch
i2c-i801-documentation-patch-for-intel-tolapai.patch
i2c-i801-smbus-patch-for-intel-tolapai.patch
i2c-i801-smbus-patch-for-intel-tolapai-fix.patch
ahci-raid-mode-sata-patch-for-intel-tolapai.patch
