From: akpm@linux-foundation.org
Subject: + rocket-first-pass-at-termios-reporting.patch added to -mm tree
Date: Mon, 19 Nov 2007 23:23:12 -0800
Message-ID: <200711200723.lAK7NCis021350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754819AbXKTH3G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 02:29:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     rocket: first pass at termios reporting
has been added to the -mm tree.  Its filename is
     rocket-first-pass-at-termios-reporting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rocket: first pass at termios reporting
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Also removes a cflag comparison that caused some mode changes to get wrongly
ignored

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/char/rocket.c~rocket-first-pass-at-termios-reporting drivers/char/rocket.c
--- a/drivers/char/rocket.c~rocket-first-pass-at-termios-reporting
+++ a/drivers/char/rocket.c
@@ -715,11 +715,10 @@ static void configure_r_port(struct r_po
 	unsigned rocketMode;
 	int bits, baud, divisor;
 	CHANNEL_t *cp;
+	struct ktermios *t = info->tty->termios;
 
-	if (!info->tty || !info->tty->termios)
-		return;
 	cp = &info->channel;
-	cflag = info->tty->termios->c_cflag;
+	cflag = t->c_cflag;
 
 	/* Byte size and parity */
 	if ((cflag & CSIZE) == CS8) {
@@ -754,10 +753,7 @@ static void configure_r_port(struct r_po
 		baud = 9600;
 	divisor = ((rp_baud_base[info->board] + (baud >> 1)) / baud) - 1;
 	if ((divisor >= 8192 || divisor < 0) && old_termios) {
-		info->tty->termios->c_cflag &= ~CBAUD;
-		info->tty->termios->c_cflag |=
-		    (old_termios->c_cflag & CBAUD);
-		baud = tty_get_baud_rate(info->tty);
+		baud = tty_termios_baud_rate(old_termios);
 		if (!baud)
 			baud = 9600;
 		divisor = (rp_baud_base[info->board] / baud) - 1;
@@ -769,6 +765,9 @@ static void configure_r_port(struct r_po
 	info->cps = baud / bits;
 	sSetBaud(cp, divisor);
 
+	/* FIXME: Should really back compute a baud rate from the divisor */
+	tty_encode_baud_rate(info->tty, baud, baud);
+
 	if (cflag & CRTSCTS) {
 		info->intmask |= DELTA_CTS;
 		sEnCTSFlowCtl(cp);
@@ -1202,15 +1201,14 @@ static void rp_set_termios(struct tty_st
 
 	cflag = tty->termios->c_cflag;
 
-	if (cflag == old_termios->c_cflag)
-		return;
-
 	/*
 	 * This driver doesn't support CS5 or CS6
 	 */
 	if (((cflag & CSIZE) == CS5) || ((cflag & CSIZE) == CS6))
 		tty->termios->c_cflag =
 		    ((cflag & ~CSIZE) | (old_termios->c_cflag & CSIZE));
+	/* Or CMSPAR */
+	tty->termios->c_cflag &= ~CMSPAR;
 
 	configure_r_port(info, old_termios);
 
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
