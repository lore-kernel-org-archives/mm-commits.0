From: akpm@linux-foundation.org
Subject: - mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:09:52 -0800
Message-ID: <200802080809.m1889X5E014842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42651 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932235AbYBHIT6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mxser/mxser_new: first pass over termios reporting for the mxser cards
has been removed from the -mm tree.  Its filename was
     mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
git-watchdog.patch
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
smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch
irq_noprobe-helper-functions.patch
mips-mark-all-but-i8259-interrupts-as-no-probe.patch
