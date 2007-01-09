From: akpm@osdl.org
Subject: - ahci-remove-jmicron-fixup.patch removed from -mm tree
Date: Tue, 09 Jan 2007 12:28:48 -0800
Message-ID: <200701092028.l09KSmqI014330@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41071 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397AbXAIU3B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:29:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ahci: remove jmicron fixup
has been removed from the -mm tree.  Its filename was
     ahci-remove-jmicron-fixup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ahci: remove jmicron fixup
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The AHCI set up is handled properly along with the other bits in the JMICRON
quirk.  Remove the code whacking it in ahci.c as its un-needed and also
blindly fiddles with bits it doesn't own.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/ahci.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/ata/ahci.c~ahci-remove-jmicron-fixup drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ahci-remove-jmicron-fixup
+++ a/drivers/ata/ahci.c
@@ -1660,13 +1660,9 @@ static int ahci_init_one (struct pci_dev
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
 
-	/* JMicron-specific fixup: make sure we're in AHCI mode */
-	/* This is protected from races with ata_jmicron by the pci probe
-	   locking */
 	if (pdev->vendor == PCI_VENDOR_ID_JMICRON) {
-		/* AHCI enable, AHCI on function 0 */
-		pci_write_config_byte(pdev, 0x41, 0xa1);
-		/* Function 1 is the PATA controller */
+		/* Function 1 is the PATA controller except on the 368, where
+		   we are not AHCI anyway */
 		if (PCI_FUNC(pdev->devfn))
 			return -ENODEV;
 	}
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
add-suport-for-marvell-88se6121-in-pata_marvell.patch
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
