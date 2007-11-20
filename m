From: akpm@linux-foundation.org
Subject: + pata_isapnp-polled-devices.patch added to -mm tree
Date: Mon, 19 Nov 2007 23:09:18 -0800
Message-ID: <200711200709.lAK79IfP019975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34746 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755248AbXKTHJg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 02:09:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     pata_isapnp: polled devices
has been added to the -mm tree.  Its filename is
     pata_isapnp-polled-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_isapnp: polled devices
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

If a card has no IRQ then pass no interrupt handler but allow polled
usage.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_isapnp.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN drivers/ata/pata_isapnp.c~pata_isapnp-polled-devices drivers/ata/pata_isapnp.c
--- a/drivers/ata/pata_isapnp.c~pata_isapnp-polled-devices
+++ a/drivers/ata/pata_isapnp.c
@@ -75,13 +75,16 @@ static int isapnp_init_one(struct pnp_de
 	struct ata_host *host;
 	struct ata_port *ap;
 	void __iomem *cmd_addr, *ctl_addr;
+	int irq = 0;
+	irq_handler_t handler = NULL;
 
 	if (pnp_port_valid(idev, 0) == 0)
 		return -ENODEV;
 
-	/* FIXME: Should selected polled PIO here not fail */
-	if (pnp_irq_valid(idev, 0) == 0)
-		return -ENODEV;
+	if (pnp_irq_valid(idev, 0)) {
+		irq = pnp_irq(idev, 0);
+		handler = ata_interrupt;
+	}
 
 	/* allocate host */
 	host = ata_host_alloc(&idev->dev, 1);
@@ -115,7 +118,7 @@ static int isapnp_init_one(struct pnp_de
 		      (unsigned long long)pnp_port_start(idev, 1));
 
 	/* activate */
-	return ata_host_activate(host, pnp_irq(idev, 0), ata_interrupt, 0,
+	return ata_host_activate(host, irq, handler, 0,
 				 &isapnp_sht);
 }
 
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
ahci-invalid-use-of-writel-readl-with-iomap.patch
libata-core-list-more-documentation-sources-for-reference.patch
libata-iordy-handling.patch
libata-sff-tf_load.patch
pata_ali-add-mitac-8317-and-derivatives.patch
pata_ali-lots-of-problems-still-showing-up-with-small-atapi-dma.patch
pata_hpt37x-fix-cable-detect-bug-spotted-by-sergei.patch
pata_isapnp-polled-devices.patch
pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards.patch
pata_ninja32-cardbus-ata-initial-support.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
quirk_vialatency-omit-reading-pci-revision-id.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
git-scsi-rc-fixes.patch
initio-fix-conflict-when-loading-driver.patch
pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
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
tty-add-the-new-termios2-ioctls-to-the-compatible.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
