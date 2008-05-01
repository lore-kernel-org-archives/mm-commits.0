From: akpm@linux-foundation.org
Subject: - isicom-bring-into-coding-style.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:42 -0700
Message-ID: <200805010930.m419UgXb030794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755356AbYEAJbV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     isicom: bring into coding style
has been removed from the -mm tree.  Its filename was
     isicom-bring-into-coding-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isicom: bring into coding style
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

[akpm@linux-foundation.org: fix arm, cleanups]
Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |  109 ++++++++++++++++++++--------------------
 1 file changed, 56 insertions(+), 53 deletions(-)

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
@@ -805,20 +809,19 @@ static int isicom_setup_port(struct isi_
 	struct isi_board *card = port->card;
 	unsigned long flags;
 
-	if (port->flags & ASYNC_INITIALIZED) {
+	if (port->flags & ASYNC_INITIALIZED)
 		return 0;
-	}
 	if (!port->xmit_buf) {
-		unsigned long page;
+		/* Relies on BKL */
+		void *xmit_buf = (void *)get_zeroed_page(GFP_KERNEL);
 
-		if (!(page = get_zeroed_page(GFP_KERNEL)))
+		if (xmit_buf == NULL)
 			return -ENOMEM;
-
 		if (port->xmit_buf) {
-			free_page(page);
+			free_page((unsigned long)xmit_buf);
 			return -ERESTARTSYS;
 		}
-		port->xmit_buf = (unsigned char *) page;
+		port->xmit_buf = xmit_buf;
 	}
 
 	spin_lock_irqsave(&card->card_lock, flags);
@@ -949,21 +952,18 @@ static int isicom_open(struct tty_struct
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
@@ -1119,7 +1119,7 @@ static int isicom_write(struct tty_struc
 
 	spin_lock_irqsave(&card->card_lock, flags);
 
-	while(1) {
+	while (1) {
 		cnt = min_t(int, count, min(SERIAL_XMIT_SIZE - port->xmit_cnt
 				- 1, SERIAL_XMIT_SIZE - port->xmit_head));
 		if (cnt <= 0)
@@ -1153,15 +1153,15 @@ static void isicom_put_char(struct tty_s
 		return;
 
 	spin_lock_irqsave(&card->card_lock, flags);
-	if (port->xmit_cnt >= SERIAL_XMIT_SIZE - 1) {
-		spin_unlock_irqrestore(&card->card_lock, flags);
-		return;
-	}
+	if (port->xmit_cnt >= SERIAL_XMIT_SIZE - 1)
+		goto out;
 
 	port->xmit_buf[port->xmit_head++] = ch;
 	port->xmit_head &= (SERIAL_XMIT_SIZE - 1);
 	port->xmit_cnt++;
 	spin_unlock_irqrestore(&card->card_lock, flags);
+out:
+	return;
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

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

