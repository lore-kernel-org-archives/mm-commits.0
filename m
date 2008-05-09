From: akpm@linux-foundation.org
Subject: - ide-eliminate-fit-macro.patch removed from -mm tree
Date: Fri, 09 May 2008 14:47:03 -0700
Message-ID: <200805092147.m49Ll3F0027181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbYEIV4K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:56:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ide: eliminate FIT() macro
has been removed from the -mm tree.  Its filename was
     ide-eliminate-fit-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ide: eliminate FIT() macro
From: Harvey Harrison <harvey.harrison@gmail.com>

Replace the FIT() macro with the kernel-provided clamp_val() macro.

FIT was always being called with a member of a struct ide_timing,
which are shorts, and constant constraints for the min and max.

Thus we can use clamp_val, rather than clamp_t.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-timing.h    |    1 -
 drivers/ide/pci/amd74xx.c   |   14 +++++++-------
 drivers/ide/pci/via82cxxx.c |   14 +++++++-------
 3 files changed, 14 insertions(+), 15 deletions(-)

diff -puN drivers/ide/ide-timing.h~ide-eliminate-fit-macro drivers/ide/ide-timing.h
--- a/drivers/ide/ide-timing.h~ide-eliminate-fit-macro
+++ a/drivers/ide/ide-timing.h
@@ -95,7 +95,6 @@ static struct ide_timing ide_timing[] = 
 #define IDE_TIMING_UDMA		0x80
 #define IDE_TIMING_ALL		0xff
 
-#define FIT(v,vmin,vmax)	max_t(short,min_t(short,v,vmax),vmin)
 #define ENOUGH(v,unit)		(((v)-1)/(unit)+1)
 #define EZ(v,unit)		((v)?ENOUGH(v,unit):0)
 
diff -puN drivers/ide/pci/amd74xx.c~ide-eliminate-fit-macro drivers/ide/pci/amd74xx.c
--- a/drivers/ide/pci/amd74xx.c~ide-eliminate-fit-macro
+++ a/drivers/ide/pci/amd74xx.c
@@ -53,20 +53,20 @@ static void amd_set_speed(struct pci_dev
 	u8 t = 0, offset = amd_offset(dev);
 
 	pci_read_config_byte(dev, AMD_ADDRESS_SETUP + offset, &t);
-	t = (t & ~(3 << ((3 - dn) << 1))) | ((FIT(timing->setup, 1, 4) - 1) << ((3 - dn) << 1));
+	t = (t & ~(3 << ((3 - dn) << 1))) | ((clamp_val(timing->setup, 1, 4) - 1) << ((3 - dn) << 1));
 	pci_write_config_byte(dev, AMD_ADDRESS_SETUP + offset, t);
 
 	pci_write_config_byte(dev, AMD_8BIT_TIMING + offset + (1 - (dn >> 1)),
-		((FIT(timing->act8b, 1, 16) - 1) << 4) | (FIT(timing->rec8b, 1, 16) - 1));
+		((clamp_val(timing->act8b, 1, 16) - 1) << 4) | (clamp_val(timing->rec8b, 1, 16) - 1));
 
 	pci_write_config_byte(dev, AMD_DRIVE_TIMING + offset + (3 - dn),
-		((FIT(timing->active, 1, 16) - 1) << 4) | (FIT(timing->recover, 1, 16) - 1));
+		((clamp_val(timing->active, 1, 16) - 1) << 4) | (clamp_val(timing->recover, 1, 16) - 1));
 
 	switch (udma_mask) {
-	case ATA_UDMA2: t = timing->udma ? (0xc0 | (FIT(timing->udma, 2, 5) - 2)) : 0x03; break;
-	case ATA_UDMA4: t = timing->udma ? (0xc0 | amd_cyc2udma[FIT(timing->udma, 2, 10)]) : 0x03; break;
-	case ATA_UDMA5: t = timing->udma ? (0xc0 | amd_cyc2udma[FIT(timing->udma, 1, 10)]) : 0x03; break;
-	case ATA_UDMA6: t = timing->udma ? (0xc0 | amd_cyc2udma[FIT(timing->udma, 1, 15)]) : 0x03; break;
+	case ATA_UDMA2: t = timing->udma ? (0xc0 | (clamp_val(timing->udma, 2, 5) - 2)) : 0x03; break;
+	case ATA_UDMA4: t = timing->udma ? (0xc0 | amd_cyc2udma[clamp_val(timing->udma, 2, 10)]) : 0x03; break;
+	case ATA_UDMA5: t = timing->udma ? (0xc0 | amd_cyc2udma[clamp_val(timing->udma, 1, 10)]) : 0x03; break;
+	case ATA_UDMA6: t = timing->udma ? (0xc0 | amd_cyc2udma[clamp_val(timing->udma, 1, 15)]) : 0x03; break;
 	default: return;
 	}
 
diff -puN drivers/ide/pci/via82cxxx.c~ide-eliminate-fit-macro drivers/ide/pci/via82cxxx.c
--- a/drivers/ide/pci/via82cxxx.c~ide-eliminate-fit-macro
+++ a/drivers/ide/pci/via82cxxx.c
@@ -120,21 +120,21 @@ static void via_set_speed(ide_hwif_t *hw
 
 	if (~vdev->via_config->flags & VIA_BAD_AST) {
 		pci_read_config_byte(dev, VIA_ADDRESS_SETUP, &t);
-		t = (t & ~(3 << ((3 - dn) << 1))) | ((FIT(timing->setup, 1, 4) - 1) << ((3 - dn) << 1));
+		t = (t & ~(3 << ((3 - dn) << 1))) | ((clamp_val(timing->setup, 1, 4) - 1) << ((3 - dn) << 1));
 		pci_write_config_byte(dev, VIA_ADDRESS_SETUP, t);
 	}
 
 	pci_write_config_byte(dev, VIA_8BIT_TIMING + (1 - (dn >> 1)),
-		((FIT(timing->act8b, 1, 16) - 1) << 4) | (FIT(timing->rec8b, 1, 16) - 1));
+		((clamp_val(timing->act8b, 1, 16) - 1) << 4) | (clamp_val(timing->rec8b, 1, 16) - 1));
 
 	pci_write_config_byte(dev, VIA_DRIVE_TIMING + (3 - dn),
-		((FIT(timing->active, 1, 16) - 1) << 4) | (FIT(timing->recover, 1, 16) - 1));
+		((clamp_val(timing->active, 1, 16) - 1) << 4) | (clamp_val(timing->recover, 1, 16) - 1));
 
 	switch (vdev->via_config->udma_mask) {
-	case ATA_UDMA2: t = timing->udma ? (0xe0 | (FIT(timing->udma, 2, 5) - 2)) : 0x03; break;
-	case ATA_UDMA4: t = timing->udma ? (0xe8 | (FIT(timing->udma, 2, 9) - 2)) : 0x0f; break;
-	case ATA_UDMA5: t = timing->udma ? (0xe0 | (FIT(timing->udma, 2, 9) - 2)) : 0x07; break;
-	case ATA_UDMA6: t = timing->udma ? (0xe0 | (FIT(timing->udma, 2, 9) - 2)) : 0x07; break;
+	case ATA_UDMA2: t = timing->udma ? (0xe0 | (clamp_val(timing->udma, 2, 5) - 2)) : 0x03; break;
+	case ATA_UDMA4: t = timing->udma ? (0xe8 | (clamp_val(timing->udma, 2, 9) - 2)) : 0x0f; break;
+	case ATA_UDMA5: t = timing->udma ? (0xe0 | (clamp_val(timing->udma, 2, 9) - 2)) : 0x07; break;
+	case ATA_UDMA6: t = timing->udma ? (0xe0 | (clamp_val(timing->udma, 2, 9) - 2)) : 0x07; break;
 	default: return;
 	}
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
git-input.patch
ata-remove-fit-macro.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
wireless-use-get-put_unaligned_-helpers.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
lib-add-ascii-hex-helper-functions.patch
lib-add-ascii-hex-helper-functions-update.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch
aacraid-linitc-make-aac_show_serial_number-static.patch

