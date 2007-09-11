From: akpm@linux-foundation.org
Subject: + via82cxxx-pata_via-add-support-for-via-vx800-series.patch added to -mm tree
Date: Mon, 10 Sep 2007 22:27:15 -0700
Message-ID: <200709110527.l8B5RFrN027318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57571 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbXIKF10 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 01:27:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JosephChan@via.com.tw, alan@lxorguk.ukuu.org.uk, htejun@gmail.com, jeff@garzik.org, josephchan@via.com.tw


The patch titled
     via82cxxx/pata_via: Add support for VIA VX800 series
has been added to the -mm tree.  Its filename is
     via82cxxx-pata_via-add-support-for-via-vx800-series.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: via82cxxx/pata_via: Add support for VIA VX800 series
From: <JosephChan@via.com.tw>

Add IDE support for VIA's VX800 series in both drivers/ide/pci/via82cxxx.c
and drivers/ata/pata_via.c

Signed-off-by: Joseph Chan <josephchan@via.com.tw>
Cc: Jeff Garzik <jeff@garzik.org>
Reviewed-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_via.c      |    1 +
 drivers/ide/pci/via82cxxx.c |    1 +
 include/linux/pci_ids.h     |    1 +
 3 files changed, 3 insertions(+)

diff -puN drivers/ata/pata_via.c~via82cxxx-pata_via-add-support-for-via-vx800-series drivers/ata/pata_via.c
--- a/drivers/ata/pata_via.c~via82cxxx-pata_via-add-support-for-via-vx800-series
+++ a/drivers/ata/pata_via.c
@@ -97,6 +97,7 @@ static const struct via_isa_bridge {
 	u8 rev_max;
 	u16 flags;
 } via_isa_bridges[] = {
+	{ "vx800 series",	PCI_DEVICE_ID_VIA_VX800,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
diff -puN drivers/ide/pci/via82cxxx.c~via82cxxx-pata_via-add-support-for-via-vx800-series drivers/ide/pci/via82cxxx.c
--- a/drivers/ide/pci/via82cxxx.c~via82cxxx-pata_via-add-support-for-via-vx800-series
+++ a/drivers/ide/pci/via82cxxx.c
@@ -74,6 +74,7 @@ static struct via_isa_bridge {
 	u8 udma_mask;
 	u8 flags;
 } via_isa_bridges[] = {
+	{ "vx800 series",	PCI_DEVICE_ID_VIA_VX800,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
diff -puN include/linux/pci_ids.h~via82cxxx-pata_via-add-support-for-via-vx800-series include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~via82cxxx-pata_via-add-support-for-via-vx800-series
+++ a/include/linux/pci_ids.h
@@ -1343,6 +1343,7 @@
 #define PCI_DEVICE_ID_VIA_8231_4	0x8235
 #define PCI_DEVICE_ID_VIA_8365_1	0x8305
 #define PCI_DEVICE_ID_VIA_CX700		0x8324
+#define PCI_DEVICE_ID_VIA_VX800		0x8353
 #define PCI_DEVICE_ID_VIA_8371_1	0x8391
 #define PCI_DEVICE_ID_VIA_82C598_1	0x8598
 #define PCI_DEVICE_ID_VIA_838X_1	0xB188
_

Patches currently in -mm which might be from JosephChan@via.com.tw are

via82cxxx-pata_via-add-support-for-via-vx800-series.patch
