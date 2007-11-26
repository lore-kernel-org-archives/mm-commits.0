From: akpm@linux-foundation.org
Subject: + mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch added to -mm tree
Date: Mon, 26 Nov 2007 14:47:18 -0800
Message-ID: <200711262247.lAQMlIaq026970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33292 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756059AbXKZWsi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 17:48:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com


The patch titled
     mxser/mxser_new: first pass over termios reporting for the mxser cards
has been added to the -mm tree.  Its filename is
     mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mxser/mxser_new: first pass over termios reporting for the mxser cards
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c     |   27 +++++++++++++++++++--------
 drivers/char/mxser_new.c |   16 +++++++++-------
 2 files changed, 28 insertions(+), 15 deletions(-)

diff -puN drivers/char/mxser.c~mxser-mxser_new-first-pass-over-termios-reporting-for-the drivers/char/mxser.c
--- a/drivers/char/mxser.c~mxser-mxser_new-first-pass-over-termios-reporting-for-the
+++ a/drivers/char/mxser.c
@@ -1391,7 +1391,8 @@ static int mxser_ioctl(struct tty_struct
 			long baud;
 			if (get_user(baud, (long __user *)argp))
 				return -EFAULT;
-			mxser_set_baud(info, baud);
+			if (mxser_set_baud(info, baud) == -1)
+				return -1;
 			return 0;
 		}
 	case MOXA_ASPP_GETBAUD:
@@ -2517,7 +2518,13 @@ static int mxser_change_speed(struct mxs
 #endif
 	if (mxser_set_baud_method[info->port] == 0) {
 		baud = tty_get_baud_rate(info->tty);
-		mxser_set_baud(info, baud);
+		if (mxser_set_baud(info, baud) == -1) {
+			/* Use previous rate on a failure */
+			if (old_termios) {
+				baud = tty_termios_baud_rate(old_termios);
+				tty_encode_baud_rate(info->tty, baud, baud);
+			}
+		}
 	}
 
 	/* byte size and parity */
@@ -2691,27 +2698,31 @@ static int mxser_set_baud(struct mxser_s
 {
 	int quot = 0;
 	unsigned char cval;
-	int ret = 0;
 	unsigned long flags;
+	unsigned int baud;
 
 	if (!info->tty || !info->tty->termios)
-		return ret;
+		return -1;
 
 	if (!(info->base))
-		return ret;
+		return -1;
 
 	if (newspd > info->MaxCanSetBaudRate)
-		return 0;
+		return -1;
 
 	info->realbaud = newspd;
 	if (newspd == 134) {
 		quot = (2 * info->baud_base / 269);
+		tty_encode_baud_rate(info->tty, 134, 134);
 	} else if (newspd) {
 		quot = info->baud_base / newspd;
 		if (quot == 0)
 			quot = 1;
+		baud = info->baud_base / quot;
+		tty_encode_baud_rate(info->tty, baud, baud);
 	} else {
 		quot = 0;
+		tty_encode_baud_rate(info->tty, 0, 0);
 	}
 
 	info->timeout = ((info->xmit_fifo_size * HZ * 10 * quot) / info->baud_base);
@@ -2727,7 +2738,7 @@ static int mxser_set_baud(struct mxser_s
 		info->MCR &= ~UART_MCR_DTR;
 		outb(info->MCR, info->base + UART_MCR);
 		spin_unlock_irqrestore(&info->slock, flags);
-		return ret;
+		return 0;
 	}
 
 	cval = inb(info->base + UART_LCR);
@@ -2739,7 +2750,7 @@ static int mxser_set_baud(struct mxser_s
 	outb(cval, info->base + UART_LCR);	/* reset DLAB */
 
 
-	return ret;
+	return 0;
 }
 
 /*
diff -puN drivers/char/mxser_new.c~mxser-mxser_new-first-pass-over-termios-reporting-for-the drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~mxser-mxser_new-first-pass-over-termios-reporting-for-the
+++ a/drivers/char/mxser_new.c
@@ -452,18 +452,17 @@ static int mxser_block_til_ready(struct 
 static int mxser_set_baud(struct mxser_port *info, long newspd)
 {
 	unsigned int i;
-	int quot = 0;
+	int quot = 0, baud;
 	unsigned char cval;
-	int ret = 0;
 
 	if (!info->tty || !info->tty->termios)
-		return ret;
+		return -1;
 
 	if (!(info->ioaddr))
-		return ret;
+		return -1;
 
 	if (newspd > info->max_baud)
-		return 0;
+		return -1;
 
 	info->realbaud = newspd;
 	for (i = 0; i < BAUD_TABLE_NO; i++)
@@ -476,10 +475,13 @@ static int mxser_set_baud(struct mxser_p
 	} else {
 		if (newspd == 134) {
 			quot = (2 * info->baud_base / 269);
+			tty_encode_baud_rate(info->tty, 134, 134);
 		} else if (newspd) {
 			quot = info->baud_base / newspd;
 			if (quot == 0)
 				quot = 1;
+			baud = info->baud_base/quot;
+			tty_encode_baud_rate(info->tty, baud, baud);
 		} else {
 			quot = 0;
 		}
@@ -494,7 +496,7 @@ static int mxser_set_baud(struct mxser_p
 	} else {
 		info->MCR &= ~UART_MCR_DTR;
 		outb(info->MCR, info->ioaddr + UART_MCR);
-		return ret;
+		return 0;
 	}
 
 	cval = inb(info->ioaddr + UART_LCR);
@@ -518,7 +520,7 @@ static int mxser_set_baud(struct mxser_p
 	} else
 		SET_MOXA_MUST_ENUM_VALUE(info->ioaddr, 0);
 
-	return ret;
+	return 0;
 }
 
 /*
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
bluetooth-rfcomm-tty_close-before-destruct.patch
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
mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch
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
