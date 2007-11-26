From: akpm@linux-foundation.org
Subject: - libata-sff-tf_load.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:48:44 -0800
Message-ID: <200711262148.lAQLmi8j024621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51114 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755038AbXKZVtU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:49:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata-sff: tf_load
has been removed from the -mm tree.  Its filename was
     libata-sff-tf_load.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata-sff: tf_load
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Jeff said he preferred that the SFF tf_load followed the spec and we
documented that anyone who needed different overrode it, rather than it
using the ->check_status methods. No driver relies on the current behaviour.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-sff.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/ata/libata-sff.c~libata-sff-tf_load drivers/ata/libata-sff.c
--- a/drivers/ata/libata-sff.c~libata-sff-tf_load
+++ a/drivers/ata/libata-sff.c
@@ -147,7 +147,9 @@ void ata_exec_command(struct ata_port *a
  *	@tf: ATA taskfile register set for storing input
  *
  *	Reads ATA taskfile registers for currently-selected device
- *	into @tf.
+ *	into @tf. Assumes the device has a fully SFF compliant task file
+ *	layout and behaviour. If you device does not (eg has a different
+ *	status method) then you will need to provide a replacement tf_read
  *
  *	LOCKING:
  *	Inherited from caller.
@@ -156,7 +158,7 @@ void ata_tf_read(struct ata_port *ap, st
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
 
-	tf->command = ata_chk_status(ap);
+	tf->command = ata_check_status(ap);
 	tf->feature = ioread8(ioaddr->error_addr);
 	tf->nsect = ioread8(ioaddr->nsect_addr);
 	tf->lbal = ioread8(ioaddr->lbal_addr);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

termios-document-callback-more-clearly.patch
revert-keyspan-init-termios-properly.patch
git-arm.patch
git-libata-all.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes.patch
libata-fix-ata_acpi_gtm_xfermask.patch
libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi.patch
libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch
libata-add-ata_cbl_pata_ign.patch
pata_amd-update-mode-selection-for-nv-patas.patch
pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards.patch
git-netdev-all.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-scsi-rc-fixes.patch
initio-fix-conflict-when-loading-driver.patch
pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
tty-add-the-new-termios2-ioctls-to-the-compatible.patch
geode-lists-are-subscriber-only.patch
tty-kill-tty_flipbuf_size.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
moxa-first-pass-at-termios-reporting.patch
n_tty-clean-up-old-code-to-follow-coding-style-and-mostly-checkpatch.patch
rocket-first-pass-at-termios-reporting.patch
rocket-dont-let-random-users-reset-the-controller.patch
tty_audit-fix-checkpatch-complaint.patch
tty_io-drag-screaming-into-coding-style-compliance.patch
tty_ioctl-drag-screaming-into-compliance-with-the-coding.patch
8250_early-coding-style.patch
8250_gsc-coding-style.patch
8250_hp300-coding-style.patch
8250_hub6-codding-style.patch
8250_pci-coding-style.patch
serial8250-coding-style.patch
8250-enable-rate-reporting-via-termios.patch
serial_core-bring-mostly-into-line-with-coding-style.patch
