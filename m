From: akpm@osdl.org
Subject: + pdc202xx_-remove-check_in_drive_lists-abomination.patch added to -mm tree
Date: Sun, 10 Dec 2006 11:25:55 -0800
Message-ID: <200612101925.kBAJPtwT000771@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52963 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762408AbWLJT0N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 14:26:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sshtylyov@ru.mvista.com, alan@lxorguk.ukuu.org.uk


The patch titled
     pdc202xx_*: remove check_in_drive_lists() abomination
has been added to the -mm tree.  Its filename is
     pdc202xx_-remove-check_in_drive_lists-abomination.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pdc202xx_*: remove check_in_drive_lists() abomination
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Fold check_in_drive_lists() into quirkproc() handler in both PDC202xx
drivers-- this function was never called with a list other than
pdc_quirk_drives and was a bad example of code overall...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/pdc202xx_new.c |   27 ++++++---------------------
 drivers/ide/pci/pdc202xx_old.c |   27 ++++++---------------------
 2 files changed, 12 insertions(+), 42 deletions(-)

diff -puN drivers/ide/pci/pdc202xx_new.c~pdc202xx_-remove-check_in_drive_lists-abomination drivers/ide/pci/pdc202xx_new.c
--- a/drivers/ide/pci/pdc202xx_new.c~pdc202xx_-remove-check_in_drive_lists-abomination
+++ a/drivers/ide/pci/pdc202xx_new.c
@@ -92,26 +92,6 @@ static u8 pdcnew_ratemask(ide_drive_t *d
 	return	mode;
 }
 
-static int check_in_drive_lists(ide_drive_t *drive, const char **list)
-{
-	struct hd_driveid *id = drive->id;
-
-	if (pdc_quirk_drives == list) {
-		while (*list) {
-			if (strstr(id->model, *list++)) {
-				return 2;
-			}
-		}
-	} else {
-		while (*list) {
-			if (!strcmp(*list++,id->model)) {
-				return 1;
-			}
-		}
-	}
-	return 0;
-}
-
 /**
  * get_indexed_reg - Get indexed register
  * @hwif: for the port address
@@ -324,7 +304,12 @@ fast_ata_pio:
 
 static int pdcnew_quirkproc(ide_drive_t *drive)
 {
-	return check_in_drive_lists(drive, pdc_quirk_drives);
+	const char **list, *model = drive->id->model;
+
+	for (list = pdc_quirk_drives; *list != NULL; list++)
+		if (strstr(model, *list) != NULL)
+			return 2;
+	return 0;
 }
 
 static void pdcnew_reset(ide_drive_t *drive)
diff -puN drivers/ide/pci/pdc202xx_old.c~pdc202xx_-remove-check_in_drive_lists-abomination drivers/ide/pci/pdc202xx_old.c
--- a/drivers/ide/pci/pdc202xx_old.c~pdc202xx_-remove-check_in_drive_lists-abomination
+++ a/drivers/ide/pci/pdc202xx_old.c
@@ -123,26 +123,6 @@ static u8 pdc202xx_ratemask (ide_drive_t
 	return mode;
 }
 
-static int check_in_drive_lists (ide_drive_t *drive, const char **list)
-{
-	struct hd_driveid *id = drive->id;
-
-	if (pdc_quirk_drives == list) {
-		while (*list) {
-			if (strstr(id->model, *list++)) {
-				return 2;
-			}
-		}
-	} else {
-		while (*list) {
-			if (!strcmp(*list++,id->model)) {
-				return 1;
-			}
-		}
-	}
-	return 0;
-}
-
 static int pdc202xx_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
@@ -377,7 +357,12 @@ fast_ata_pio:
 
 static int pdc202xx_quirkproc (ide_drive_t *drive)
 {
-	return ((int) check_in_drive_lists(drive, pdc_quirk_drives));
+	const char **list, *model = drive->id->model;
+
+	for (list = pdc_quirk_drives; *list != NULL; list++)
+		if (strstr(model, *list) != NULL)
+			return 2;
+	return 0;
 }
 
 static void pdc202xx_old_ide_dma_start(ide_drive_t *drive)
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

origin.patch
pdc202xx_new-fix-pll-timing-issues.patch
git-mtd.patch
3x59x-fix-pci-resource-management.patch
ide-hpt3xxn-clocking-fixes.patch
ide-fix-hpt37x-timing-tables.patch
ide-optimize-hpt37x-timing-tables.patch
ide-fix-hpt3xx-hotswap-support.patch
ide-fix-the-case-of-multiple-hpt3xx-chips-present.patch
ide-hpt3xx-fix-pci-clock-detection.patch
ide-hpt3xx-fix-pci-clock-detection-fix-2.patch
piix-fix-82371mx-enablebits.patch
piix-remove-check-for-broken-mw-dma-mode-0.patch
piix-slc90e66-pio-mode-fallback-fix.patch
hpt3xx-rework-rate-filtering.patch
hpt3xx-rework-rate-filtering-tidy.patch
hpt3xx-print-the-real-chip-name-at-startup.patch
hpt3xx-switch-to-using-pci_get_slot.patch
hpt3xx-cache-channels-mcr-address.patch
hpt3x7-merge-speedproc-handlers.patch
hpt370-clean-up-dma-timeout-handling.patch
hpt3xx-init-code-rewrite.patch
pdc202xx_new-remove-useless-code.patch
pdc202xx_-remove-check_in_drive_lists-abomination.patch

