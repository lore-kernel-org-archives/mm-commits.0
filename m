From: akpm@linux-foundation.org
Subject: + isicom-bring-into-coding-style.patch added to -mm tree
Date: Mon, 14 Apr 2008 19:04:49 -0700
Message-ID: <200804150204.m3F24nbj005648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760518AbYDOCFf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 22:05:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com


The patch titled
     isicom: bring into coding style
has been added to the -mm tree.  Its filename is
     isicom-bring-into-coding-style.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isicom: bring into coding style
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |  107 ++++++++++++++++++++--------------------
 1 file changed, 55 insertions(+), 52 deletions(-)

diff -puN drivers/char/isicom.c~isicom-bring-into-coding-style drivers/char/isicom.c
--- a/drivers/char/isicom.c~isicom-bring-into-coding-style
+++ a/drivers/char/isicom.c
@@ -126,8 +126,8 @@
 #include <linux/delay.h>
 #include <linux/ioport.h>
 
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 #include <asm/system.h>
 
 #include <linux/pci.h>
@@ -189,7 +189,7 @@ struct	isi_board {
 	unsigned short		status;
 	unsigned short		port_status; /* each bit for each port */
 	unsigned short		shift_count;
-	struct isi_port		* ports;
+	struct isi_port		*ports;
 	signed char		count;
 	spinlock_t		card_lock; /* Card wide lock 11/5/00 -sameer */
 	unsigned long		flags;
@@ -205,11 +205,11 @@ struct	isi_port {
 	u16			channel;
 	u16			status;
 	u16			closing_wait;
-	struct isi_board	* card;
-	struct tty_struct 	* tty;
+	struct isi_board	*card;
+	struct tty_struct 	*tty;
 	wait_queue_head_t	close_wait;
 	wait_queue_head_t	open_wait;
-	unsigned char		* xmit_buf;
+	unsigned char		*xmit_buf;
 	int			xmit_head;
 	int			xmit_tail;
 	int			xmit_cnt;
@@ -405,7 +405,7 @@ static void isicom_tx(unsigned long _dat
 
 	/*	find next active board	*/
 	card = (prev_card + 1) & 0x0003;
-	while(count-- > 0) {
+	while (count-- > 0) {
 		if (isi_card[card].status & BOARD_ACTIVE)
 			break;
 		card = (card + 1) & 0x0003;
@@ -428,7 +428,7 @@ static void isicom_tx(unsigned long _dat
 	if (retries >= 100)
 		goto unlock;
 
-	for (;count > 0;count--, port++) {
+	for (; count > 0; count--, port++) {
 		/* port not active or tx disabled to force flow control */
 		if (!(port->flags & ASYNC_INITIALIZED) ||
 				!(port->status & ISI_TXOK))
@@ -471,9 +471,10 @@ static void isicom_tx(unsigned long _dat
 					break;
 				}
 			}
-			if (cnt <= 0) break;
+			if (cnt <= 0)
+				break;
 			word_count = cnt >> 1;
-			outsw(base, port->xmit_buf+port->xmit_tail,word_count);
+			outsw(base, port->xmit_buf+port->xmit_tail, word_count);
 			port->xmit_tail = (port->xmit_tail
 				+ (word_count << 1)) & (SERIAL_XMIT_SIZE - 1);
 			txcount -= (word_count << 1);
@@ -556,7 +557,7 @@ static irqreturn_t isicom_interrupt(int 
 	tty = port->tty;
 	if (tty == NULL) {
 		word_count = byte_count >> 1;
-		while(byte_count > 1) {
+		while (byte_count > 1) {
 			inw(base);
 			byte_count -= 2;
 		}
@@ -569,7 +570,7 @@ static irqreturn_t isicom_interrupt(int 
 
 	if (header & 0x8000) {		/* Status Packet */
 		header = inw(base);
-		switch(header & 0xff) {
+		switch (header & 0xff) {
 		case 0:	/* Change in EIA signals */
 			if (port->flags & ASYNC_CHECK_CD) {
 				if (port->status & ISI_DCD) {
@@ -656,7 +657,8 @@ static irqreturn_t isicom_interrupt(int 
 		if (byte_count > 0) {
 			pr_dbg("Intr(0x%lx:%d): Flip buffer overflow! dropping "
 				"bytes...\n", base, channel + 1);
-			while(byte_count > 0) { /* drain out unread xtra data */
+		/* drain out unread xtra data */
+		while (byte_count > 0) {
 				inw(base);
 				byte_count -= 2;
 			}
@@ -679,8 +681,11 @@ static void isicom_config_port(struct is
 		shift_count = card->shift_count;
 	unsigned char flow_ctrl;
 
-	if (!(tty = port->tty) || !tty->termios)
+	tty = port->tty;
+
+	if (tty == NULL)
 		return;
+	/* FIXME: Switch to new tty baud API */
 	baud = C_BAUD(tty);
 	if (baud & CBAUDEX) {
 		baud &= ~CBAUDEX;
@@ -706,7 +711,7 @@ static void isicom_config_port(struct is
 		if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
 			baud++; /*  57.6 Kbps */
 		if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
-			baud +=2; /*  115  Kbps */
+			baud += 2; /*  115  Kbps */
 		if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
 			baud += 3; /* 230 kbps*/
 		if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
@@ -716,15 +721,14 @@ static void isicom_config_port(struct is
 		/* hang up */
 		drop_dtr(port);
 		return;
-	}
-	else
+	} else
 		raise_dtr(port);
 
 	if (WaitTillCardIsFree(base) == 0) {
-		outw(0x8000 | (channel << shift_count) |0x03, base);
+		outw(0x8000 | (channel << shift_count) | 0x03, base);
 		outw(linuxb_to_isib[baud] << 8 | 0x03, base);
 		channel_setup = 0;
-		switch(C_CSIZE(tty)) {
+		switch (C_CSIZE(tty)) {
 		case CS5:
 			channel_setup |= ISICOM_CS5;
 			break;
@@ -767,7 +771,7 @@ static void isicom_config_port(struct is
 		flow_ctrl |= ISICOM_INITIATE_XONXOFF;
 
 	if (WaitTillCardIsFree(base) == 0) {
-		outw(0x8000 | (channel << shift_count) |0x04, base);
+		outw(0x8000 | (channel << shift_count) | 0x04, base);
 		outw(flow_ctrl << 8 | 0x05, base);
 		outw((STOP_CHAR(tty)) << 8 | (START_CHAR(tty)), base);
 		InterruptTheCard(base);
@@ -805,15 +809,13 @@ static int isicom_setup_port(struct isi_
 	struct isi_board *card = port->card;
 	unsigned long flags;
 
-	if (port->flags & ASYNC_INITIALIZED) {
+	if (port->flags & ASYNC_INITIALIZED)
 		return 0;
-	}
 	if (!port->xmit_buf) {
-		unsigned long page;
-
-		if (!(page = get_zeroed_page(GFP_KERNEL)))
+		/* Relies on BKL */
+		unsigned long page  = get_zeroed_page(GFP_KERNEL);
+		if (page == NULL)
 			return -ENOMEM;
-
 		if (port->xmit_buf) {
 			free_page(page);
 			return -ERESTARTSYS;
@@ -949,21 +951,18 @@ static int isicom_open(struct tty_struct
 	port->count++;
 	tty->driver_data = port;
 	port->tty = tty;
-	if ((error = isicom_setup_port(port))!=0)
-		return error;
-	if ((error = block_til_ready(tty, filp, port))!=0)
-		return error;
-
-	return 0;
+	error = isicom_setup_port(port);
+	if (error == 0)
+		error = block_til_ready(tty, filp, port);
+	return error;
 }
 
 /* close et all */
 
 static inline void isicom_shutdown_board(struct isi_board *bp)
 {
-	if (bp->status & BOARD_ACTIVE) {
+	if (bp->status & BOARD_ACTIVE)
 		bp->status &= ~BOARD_ACTIVE;
-	}
 }
 
 /* card->lock HAS to be held */
@@ -1119,7 +1118,7 @@ static int isicom_write(struct tty_struc
 
 	spin_lock_irqsave(&card->card_lock, flags);
 
-	while(1) {
+	while (1) {
 		cnt = min_t(int, count, min(SERIAL_XMIT_SIZE - port->xmit_cnt
 				- 1, SERIAL_XMIT_SIZE - port->xmit_head));
 		if (cnt <= 0)
@@ -1140,28 +1139,29 @@ static int isicom_write(struct tty_struc
 }
 
 /* put_char et all */
-static void isicom_put_char(struct tty_struct *tty, unsigned char ch)
+static int isicom_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct isi_port *port = tty->driver_data;
 	struct isi_board *card = port->card;
 	unsigned long flags;
 
 	if (isicom_paranoia_check(port, tty->name, "isicom_put_char"))
-		return;
+		return 0;
 
 	if (!port->xmit_buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&card->card_lock, flags);
 	if (port->xmit_cnt >= SERIAL_XMIT_SIZE - 1) {
 		spin_unlock_irqrestore(&card->card_lock, flags);
-		return;
+		return 0;
 	}
 
 	port->xmit_buf[port->xmit_head++] = ch;
 	port->xmit_head &= (SERIAL_XMIT_SIZE - 1);
 	port->xmit_cnt++;
 	spin_unlock_irqrestore(&card->card_lock, flags);
+	return 1;
 }
 
 /* flush_chars et all */
@@ -1286,10 +1286,9 @@ static int isicom_set_serial_info(struct
 			unlock_kernel();
 			return -EPERM;
 		}
-		port->flags = ((port->flags & ~ ASYNC_USR_MASK) |
+		port->flags = ((port->flags & ~ASYNC_USR_MASK) |
 				(newinfo.flags & ASYNC_USR_MASK));
-	}
-	else {
+	} else {
 		port->close_delay = newinfo.close_delay;
 		port->closing_wait = newinfo.closing_wait;
 		port->flags = ((port->flags & ~ASYNC_FLAGS) |
@@ -1336,7 +1335,7 @@ static int isicom_ioctl(struct tty_struc
 	if (isicom_paranoia_check(port, tty->name, "isicom_ioctl"))
 		return -ENODEV;
 
-	switch(cmd) {
+	switch (cmd) {
 	case TCSBRK:
 		retval = tty_check_change(tty);
 		if (retval)
@@ -1585,7 +1584,7 @@ static int __devinit load_firmware(struc
 	default:
 		dev_err(&pdev->dev, "Unknown signature.\n");
 		goto end;
- 	}
+	}
 
 	retval = request_firmware(&fw, name, &pdev->dev);
 	if (retval)
@@ -1613,7 +1612,8 @@ static int __devinit load_firmware(struc
 		if (WaitTillCardIsFree(base))
 			goto errrelfw;
 
-		if ((status = inw(base + 0x4)) != 0) {
+		status = inw(base + 0x4);
+		if (status != 0) {
 			dev_warn(&pdev->dev, "Card%d rejected load header:\n"
 				KERN_WARNING "Address:0x%x\n"
 				KERN_WARNING "Count:0x%x\n"
@@ -1630,12 +1630,13 @@ static int __devinit load_firmware(struc
 		if (WaitTillCardIsFree(base))
 			goto errrelfw;
 
-		if ((status = inw(base + 0x4)) != 0) {
+		status = inw(base + 0x4);
+		if (status != 0) {
 			dev_err(&pdev->dev, "Card%d got out of sync.Card "
 				"Status:0x%x\n", index + 1, status);
 			goto errrelfw;
 		}
- 	}
+	}
 
 /* XXX: should we test it by reading it back and comparing with original like
  * in load firmware package? */
@@ -1659,7 +1660,8 @@ static int __devinit load_firmware(struc
 		if (WaitTillCardIsFree(base))
 			goto errrelfw;
 
-		if ((status = inw(base + 0x4)) != 0) {
+		status = inw(base + 0x4);
+		if (status != 0) {
 			dev_warn(&pdev->dev, "Card%d rejected verify header:\n"
 				KERN_WARNING "Address:0x%x\n"
 				KERN_WARNING "Count:0x%x\n"
@@ -1692,7 +1694,8 @@ static int __devinit load_firmware(struc
 		if (WaitTillCardIsFree(base))
 			goto errrelfw;
 
-		if ((status = inw(base + 0x4)) != 0) {
+		status = inw(base + 0x4);
+		if (status != 0) {
 			dev_err(&pdev->dev, "Card%d verify got out of sync. "
 				"Card Status:0x%x\n", index + 1, status);
 			goto errrelfw;
@@ -1757,7 +1760,7 @@ static int __devinit isicom_probe(struct
 			index + 1);
 		retval = -EBUSY;
 		goto errdec;
- 	}
+	}
 
 	retval = request_irq(board->irq, isicom_interrupt,
 			IRQF_SHARED | IRQF_DISABLED, ISICOM_NAME, board);
@@ -1811,7 +1814,7 @@ static int __init isicom_init(void)
 	int retval, idx, channel;
 	struct isi_port *port;
 
-	for(idx = 0; idx < BOARD_COUNT; idx++) {
+	for (idx = 0; idx < BOARD_COUNT; idx++) {
 		port = &isi_ports[idx * 16];
 		isi_card[idx].ports = port;
 		spin_lock_init(&isi_card[idx].card_lock);
@@ -1825,7 +1828,7 @@ static int __init isicom_init(void)
 			init_waitqueue_head(&port->open_wait);
 			init_waitqueue_head(&port->close_wait);
 			/*  . . .  */
- 		}
+		}
 		isi_card[idx].base = 0;
 		isi_card[idx].irq = 0;
 	}
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
git-libata-all.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-simplex-clear-fix.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
parisc-new-termios-definitions.patch
aacraid-fix-unchecked-down_interruptible.patch
crisv10-prepare-for-bkl-push-down.patch
fix-tty-speed-handling-on-8250.patch
uart_get_baud_rate-stop-mangling-termios.patch
serial-8250-tighten-test-for-using-backup-timer.patch
x86-geode-add-virtual-systems-architecture-detection.patch
do_task_stat-dont-take-rcu_read_lock.patch
amiserial-prepare-for-locking-relaxation-in-caller.patch
cyclades-prepare-for-relaxed-locking-in-callers.patch
epca-lock_kernel-push-down.patch
esp-lock_kernel-push-down.patch
isicom-prepare-for-lock_kernel-push-down.patch
isicom-istallion-prepare-for-lock_kernel-pushdown.patch
mxser-prepare-for-bkl-pushdown.patch
riscom8-prepare-for-bkl-pushdown.patch
rocket-prepare-for-bkl-pushdown.patch
serial167-prepare-to-push-bkl-down-into-drivers.patch
specialix-prepare-for-bkl-pushdown.patch
stallion-prepare-for-bkl-push-down.patch
sx-prepare-for-bkl-pushdown.patch
synclink-series-prepare-for-bkl-pushdown.patch
viocons-bkl-locking.patch
vt_ioctl-prepare-for-bkl-push-down.patch
isdn_tty-prepare-for-bkl-push-down.patch
68360serial-note-that-there-isnt-any-info-mcr-locking.patch
serial_core-prepare-for-bkl-push-down.patch
tty-bkl-pushdown.patch
tty-bkl-pushdown-fix1.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
tty_ioctl-locking-for-tty_wait_until_sent.patch
tty_ioctl-soft-carrier-handling.patch
tty-drop-the-bkl-for-driver-ldisc-ioctl-methods.patch
sxc-fix-printk-warnings-on-sparc32.patch
istallion-tiocg-ssoftcar-handling-removal.patch
tty-serial-lay-the-foundations-for-the-next-set-of-reworks.patch
s390-tty-prepare-for-put_char-to-return-success-fail.patch
serial-m68k-put_char-returns.patch
usb-gadget-switch-to-put_char-returning-int.patch
amiserial-switch-put-char-to-return-success-fail.patch
char-switch-gs-cyclades-and-esp-to-return-int-for-put_char.patch
mxser-switch-to-put_char-being-int.patch
pcmcia-serial-to-int-put_char-method.patch
riscom-rocket-switch-to-int-put_char-method.patch
serial167-switch-to-int-put_char-method.patch
specialix-switch-to-int-put_char-method.patch
synclink-series-switch-to-int-put_char-method.patch
consoles-switch-to-int-put_char-method.patch
isdn-switch-to-int-put_char-method.patch
pty-prepare-for-tty-ops-changes.patch
pc300-update-to-tty_set_operations.patch
serial-switch-the-serial-core-to-int-put_char-methods.patch
isicom-bring-into-coding-style.patch
tty-the-big-operations-rework.patch
strip-fix-up-strip-for-the-new-order.patch
edac-new-support-for-intel-3100-chipset.patch
edac-add-e752x-parameter-for-sysbus_parity-selection.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
edac-fix-module-initialization-on-several-modules-2nd-time.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

