From: akpm@osdl.org
Subject: + libata-piix3-support.patch added to -mm tree
Date: Wed, 10 Jan 2007 17:18:12 -0800
Message-ID: <200701110118.l0B1ICKp013522@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43355 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030183AbXAKBSX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 20:18:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     libata: PIIX3 support
has been added to the -mm tree.  Its filename is
     libata-piix3-support.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: PIIX3 support
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This I believe completes the PIIX range of support for libata

This adds the table entries needed for the PIIX3, both a new PCI identifier
and a new mode list.  It also fixes an erroneous access to PCI
configuration 0x48 on non UDMA capable chips.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/ata_piix.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff -puN drivers/ata/ata_piix.c~libata-piix3-support drivers/ata/ata_piix.c
--- a/drivers/ata/ata_piix.c~libata-piix3-support
+++ a/drivers/ata/ata_piix.c
@@ -118,7 +118,7 @@ enum {
 	PIIX_80C_SEC		= (1 << 7) | (1 << 6),
 
 	/* controller IDs */
-	piix_pata_33		= 0,	/* PIIX3 or 4 at 33Mhz */
+	piix_pata_33		= 0,	/* PIIX4 at 33Mhz */
 	ich_pata_33		= 1,	/* ICH up to UDMA 33 only */
 	ich_pata_66		= 2,	/* ICH up to 66 Mhz */
 	ich_pata_100		= 3,	/* ICH up to UDMA 100 */
@@ -128,6 +128,7 @@ enum {
 	ich6_sata_ahci		= 7,
 	ich6m_sata_ahci		= 8,
 	ich8_sata_ahci		= 9,
+	piix_pata_mwdma		= 10,	/* PIIX3 MWDMA only */
 
 	/* constants for mapping table */
 	P0			= 0,  /* port 0 */
@@ -165,6 +166,8 @@ static unsigned int in_module_init = 1;
 
 static const struct pci_device_id piix_pci_tbl[] = {
 #ifdef ATA_ENABLE_PATA
+	/* Intel PIIX3 for the 430HX etc */
+	{ 0x8086, 0x7010, PCI_ANY_ID, PCI_ANY_ID, 0, 0, piix_pata_mwdma },
 	/* Intel PIIX4 for the 430TX/440BX/MX chipset: UDMA 33 */
 	/* Also PIIX4E (fn3 rev 2) and PIIX4M (fn3 rev 3) */
 	{ 0x8086, 0x7111, PCI_ANY_ID, PCI_ANY_ID, 0, 0, piix_pata_33 },
@@ -441,7 +444,7 @@ static const struct piix_map_db *piix_ma
 };
 
 static struct ata_port_info piix_port_info[] = {
-	/* piix_pata_33: 0:  PIIX3 or 4 at 33MHz */
+	/* piix_pata_33: 0:  PIIX4 at 33MHz */
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_PATA_FLAGS,
@@ -543,6 +546,14 @@ static struct ata_port_info piix_port_in
 		.port_ops	= &piix_sata_ops,
 	},
 
+	/* piix_pata_mwdma: 10:  PIIX3 MWDMA only */
+	{
+		.sht		= &piix_sht,
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= 0x1f,	/* pio0-4 */
+		.mwdma_mask	= 0x06, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
+		.port_ops	= &piix_pata_ops,
+	},
 };
 
 static struct pci_bits piix_enable_bits[] = {
@@ -787,7 +798,8 @@ static void do_pata_set_dmamode (struct 
 			    { 2, 3 }, };
 
 	pci_read_config_word(dev, master_port, &master_data);
-	pci_read_config_byte(dev, 0x48, &udma_enable);
+	if (ap->udma_mask)
+		pci_read_config_byte(dev, 0x48, &udma_enable);
 
 	if (speed >= XFER_UDMA_0) {
 		unsigned int udma = adev->dma_mode - XFER_UDMA_0;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
add-suport-for-marvell-88se6121-in-pata_marvell.patch
libata-piix3-support.patch
git-mtd.patch
z85230-spinlock-logic.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-tty_wakeup-cleanup.patch
proc-remove-useless-and-buggy-nlink-settings.patch
tty-improve-encode_baud_rate-logic.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
hpt3xx-rework-rate-filtering.patch
hpt3xx-rework-rate-filtering-tidy.patch
hpt3xx-print-the-real-chip-name-at-startup.patch
hpt3xx-switch-to-using-pci_get_slot.patch
hpt3xx-cache-channels-mcr-address.patch
hpt3x7-merge-speedproc-handlers.patch
hpt370-clean-up-dma-timeout-handling.patch
hpt3xx-init-code-rewrite.patch
piix-fix-82371mx-enablebits.patch
pdc202xx_new-remove-useless-code.patch
pdc202xx_-remove-check_in_drive_lists-abomination.patch
piix-tuneproc-fixes-cleanups.patch
slc90e66-carry-over-fixes-from-piix-driver.patch
hpt36x-pci-clock-detection-fix.patch
atiixpc-remove-unused-code.patch
atiixpc-sb600-ide-only-has-one-channel.patch
atiixpc-add-cable-detection-support-for-ati-ide.patch
jmicron-warning-fix.patch
