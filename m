From: akpm@linux-foundation.org
Subject: + ide-hpt3xx-fix-pointer-arithmetic.patch added to -mm tree
Date: Mon, 08 Sep 2008 15:21:06 -0700
Message-ID: <200809082221.m88ML6bf013229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752987AbYIHW0Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 18:26:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: masouds@google.com, bzolnier@gmail.com, rjw@sisk.pl, sshtylyov@ru.mvista.com


The patch titled
     ide: hpt3xx: fix pointer arithmetic
has been added to the -mm tree.  Its filename is
     ide-hpt3xx-fix-pointer-arithmetic.patch

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
Subject: ide: hpt3xx: fix pointer arithmetic
From: Masoud Sharbiani <masouds@google.com>

git commit 74811f355f4f69a187fa74892dcf2a684b84ce99 ("hpt366: convert to
use ->host_priv") causes a crash at module load (or boot) time on my
machine with a hpt374 controller.  Sergei says this is due to the pointer
arithmetic.  This patch fixes that and makes my machine boot again.

Signed-off-by: Masoud Sharbiani <masouds@google.com>
Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/pci/hpt366.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff -puN drivers/ide/pci/hpt366.c~ide-hpt3xx-fix-pointer-arithmetic drivers/ide/pci/hpt366.c
--- a/drivers/ide/pci/hpt366.c~ide-hpt3xx-fix-pointer-arithmetic
+++ a/drivers/ide/pci/hpt366.c
@@ -612,6 +612,14 @@ static int check_in_drive_list(ide_drive
 	return 0;
 }
 
+static struct hpt_info *hpt3xx_get_info(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct ide_host *host	= pci_get_drvdata(pci_dev);
+	struct hpt_info *info	= (struct hpt_info *)host->host_priv;
+	return dev == host->dev[1] ? info + 1 : info;
+}
+
 /*
  * The Marvell bridge chips used on the HighPoint SATA cards do not seem
  * to support the UltraDMA modes 1, 2, and 3 as well as any MWDMA modes...
@@ -620,9 +628,7 @@ static int check_in_drive_list(ide_drive
 static u8 hpt3xx_udma_filter(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
+	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 	u8 mask 		= hwif->ultra_mask;
 
 	switch (info->chip_type) {
@@ -661,9 +667,7 @@ static u8 hpt3xx_udma_filter(ide_drive_t
 static u8 hpt3xx_mdma_filter(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
+	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 
 	switch (info->chip_type) {
 	case HPT372 :
@@ -699,8 +703,7 @@ static void hpt3xx_set_mode(ide_drive_t 
 {
 	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
+	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 	struct hpt_timings *t	= info->timings;
 	u8  itr_addr		= 0x40 + (drive->dn * 4);
 	u32 old_itr		= 0;
@@ -742,9 +745,8 @@ static void hpt3xx_quirkproc(ide_drive_t
 static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
-	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
+	struct pci_dev  *dev    = to_pci_dev(hwif->dev);
+	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 
 	if (drive->quirk_list) {
 		if (info->chip_type >= HPT370) {
@@ -999,8 +1001,7 @@ static void hpt3xx_disable_fast_irq(stru
 static unsigned int init_chipset_hpt366(struct pci_dev *dev)
 {
 	unsigned long io_base	= pci_resource_start(dev, 4);
-	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (&dev->dev == host->dev[1]);
+	struct hpt_info *info	= hpt3xx_get_info(&dev->dev);
 	const char *name	= DRV_NAME;
 	u8 pci_clk,  dpll_clk	= 0;	/* PCI and DPLL clock in MHz */
 	u8 chip_type;
@@ -1245,8 +1246,7 @@ static unsigned int init_chipset_hpt366(
 static u8 hpt3xx_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
-	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
+	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 	u8 chip_type		= info->chip_type;
 	u8 scr1 = 0, ata66	= hwif->channel ? 0x01 : 0x02;
 
@@ -1290,8 +1290,7 @@ static u8 hpt3xx_cable_detect(ide_hwif_t
 static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
+	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 	int serialize		= HPT_SERIALIZE_IO;
 	u8  chip_type		= info->chip_type;
 
_

Patches currently in -mm which might be from masouds@google.com are

ide-hpt3xx-fix-pointer-arithmetic.patch

