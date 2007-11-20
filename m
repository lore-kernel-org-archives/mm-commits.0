From: akpm@linux-foundation.org
Subject: + moxa-first-pass-at-termios-reporting.patch added to -mm tree
Date: Mon, 19 Nov 2007 23:10:24 -0800
Message-ID: <200711200710.lAK7AOXU020084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53155 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752198AbXKTHKp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 02:10:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com


The patch titled
     moxa: first pass at termios reporting
has been added to the -mm tree.  Its filename is
     moxa-first-pass-at-termios-reporting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: moxa: first pass at termios reporting
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN drivers/char/moxa.c~moxa-first-pass-at-termios-reporting drivers/char/moxa.c
--- a/drivers/char/moxa.c~moxa-first-pass-at-termios-reporting
+++ a/drivers/char/moxa.c
@@ -207,7 +207,7 @@ static int moxa_tiocmget(struct tty_stru
 static int moxa_tiocmset(struct tty_struct *tty, struct file *file,
 			 unsigned int set, unsigned int clear);
 static void moxa_poll(unsigned long);
-static void moxa_set_tty_param(struct tty_struct *);
+static void moxa_set_tty_param(struct tty_struct *, struct ktermios *);
 static int moxa_block_till_ready(struct tty_struct *, struct file *,
 			    struct moxa_port *);
 static void moxa_setup_empty_event(struct tty_struct *);
@@ -500,7 +500,7 @@ static int moxa_open(struct tty_struct *
 	ch->tty = tty;
 	if (!(ch->asyncflags & ASYNC_INITIALIZED)) {
 		ch->statusflags = 0;
-		moxa_set_tty_param(tty);
+		moxa_set_tty_param(tty, tty->termios);
 		MoxaPortLineCtrl(ch->port, 1, 1);
 		MoxaPortEnable(ch->port);
 		ch->asyncflags |= ASYNC_INITIALIZED;
@@ -803,7 +803,7 @@ static void moxa_set_termios(struct tty_
 
 	if (ch == NULL)
 		return;
-	moxa_set_tty_param(tty);
+	moxa_set_tty_param(tty, old_termios);
 	if (!(old_termios->c_cflag & CLOCAL) &&
 	    (tty->termios->c_cflag & CLOCAL))
 		wake_up_interruptible(&ch->open_wait);
@@ -903,11 +903,11 @@ static void moxa_poll(unsigned long igno
 
 /******************************************************************************/
 
-static void moxa_set_tty_param(struct tty_struct *tty)
+static void moxa_set_tty_param(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	register struct ktermios *ts;
 	struct moxa_port *ch;
-	int rts, cts, txflow, rxflow, xany;
+	int rts, cts, txflow, rxflow, xany, baud;
 
 	ch = (struct moxa_port *) tty->driver_data;
 	ts = tty->termios;
@@ -924,8 +924,15 @@ static void moxa_set_tty_param(struct tt
 		rxflow = 1;
 	if (ts->c_iflag & IXANY)
 		xany = 1;
+		
+	/* Clear the features we don't support */
+	ts->c_cflag &= ~CMSPAR;
 	MoxaPortFlowCtrl(ch->port, rts, cts, txflow, rxflow, xany);
-	MoxaPortSetTermio(ch->port, ts, tty_get_baud_rate(tty));
+	baud = MoxaPortSetTermio(ch->port, ts, tty_get_baud_rate(tty));
+	if (baud == -1)
+		baud = tty_termios_baud_rate(old_termios);
+	/* Not put the baud rate into the termios data */
+	tty_encode_baud_rate(tty, baud, baud);
 }
 
 static int moxa_block_till_ready(struct tty_struct *tty, struct file *filp,
@@ -2065,7 +2072,7 @@ int MoxaPortSetTermio(int port, struct k
 		if (baud >= 921600L)
 			return (-1);
 	}
-	MoxaPortSetBaud(port, baud);
+	baud = MoxaPortSetBaud(port, baud);
 
 	if (termio->c_iflag & (IXON | IXOFF | IXANY)) {
 		writeb(termio->c_cc[VSTART], ofsAddr + FuncArg);
@@ -2074,7 +2081,7 @@ int MoxaPortSetTermio(int port, struct k
 		moxa_wait_finish(ofsAddr);
 
 	}
-	return (0);
+	return (baud);
 }
 
 int MoxaPortGetLineOut(int port, int *dtrState, int *rtsState)
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
