From: akpm@osdl.org
Subject: - pdc202xx_-remove-check_in_drive_lists-abomination.patch removed from -mm tree
Date: Mon, 22 Jan 2007 13:11:08 -0800
Message-ID: <200701222111.l0MLB8Ql002223@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52273 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932737AbXAVVL2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 16:11:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pdc202xx_*: remove check_in_drive_lists() abomination
has been removed from the -mm tree.  Its filename was
     pdc202xx_-remove-check_in_drive_lists-abomination.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-mtd.patch
3x59x-fix-pci-resource-management.patch
