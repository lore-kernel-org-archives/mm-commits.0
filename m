From: akpm@linux-foundation.org
Subject: - riscom8-fix-smp-brokenness.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:20:32 -0800
Message-ID: <200802070020.m170KD8h006102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49183 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761713AbYBGAVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:21:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, jgarzik@redhat.com, mm-commits@vger.kernel.org


The patch titled
     riscom8: fix SMP brokenness
has been removed from the -mm tree.  Its filename was
     riscom8-fix-smp-brokenness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: riscom8: fix SMP brokenness
From: Jeff Garzik <jeff@garzik.org>

After analyzing the elements that save_flags/cli/sti/restore_flags were
protecting, convert their usages to a global spinlock (the easiest and
most obvious next-step).  There were some usages of flags being
intentionally cached, because the code already knew the state of
interrupts.  These have been taken into account.

This allows us to remove CONFIG_BROKEN_ON_SMP.  Completely untested.

[akpm@linux-foundation.org: use DEFINE_SPINLOCK]
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig   |    2 
 drivers/char/riscom8.c |  147 ++++++++++++++++++++++++---------------
 2 files changed, 94 insertions(+), 55 deletions(-)

diff -puN drivers/char/Kconfig~riscom8-fix-smp-brokenness drivers/char/Kconfig
--- a/drivers/char/Kconfig~riscom8-fix-smp-brokenness
+++ a/drivers/char/Kconfig
@@ -276,7 +276,7 @@ config N_HDLC
 
 config RISCOM8
 	tristate "SDL RISCom/8 card support"
-	depends on SERIAL_NONSTANDARD && BROKEN_ON_SMP
+	depends on SERIAL_NONSTANDARD
 	help
 	  This is a driver for the SDL Communications RISCom/8 multiport card,
 	  which gives you many serial ports. You would need something like
diff -puN drivers/char/riscom8.c~riscom8-fix-smp-brokenness drivers/char/riscom8.c
--- a/drivers/char/riscom8.c~riscom8-fix-smp-brokenness
+++ a/drivers/char/riscom8.c
@@ -47,6 +47,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/tty_flip.h>
+#include <linux/spinlock.h>
 
 #include <asm/uaccess.h>
 
@@ -81,6 +82,8 @@
 
 static struct tty_driver *riscom_driver;
 
+static DEFINE_SPINLOCK(riscom_lock);
+
 static struct riscom_board rc_board[RC_NBOARD] =  {
 	{
 		.base	= RC_IOBASE1,
@@ -217,13 +220,14 @@ static void __init rc_init_CD180(struct 
 {
 	unsigned long flags;
 	
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	rc_out(bp, RC_CTOUT, 0);     	           /* Clear timeout             */
 	rc_wait_CCR(bp);			   /* Wait for CCR ready        */
 	rc_out(bp, CD180_CCR, CCR_HARDRESET);      /* Reset CD180 chip          */
-	sti();
+	spin_unlock_irqrestore(&riscom_lock, flags);
 	msleep(50);				   /* Delay 0.05 sec            */
-	cli();
+	spin_lock_irqsave(&riscom_lock, flags);
 	rc_out(bp, CD180_GIVR, RC_ID);             /* Set ID for this chip      */
 	rc_out(bp, CD180_GICR, 0);                 /* Clear all bits            */
 	rc_out(bp, CD180_PILR1, RC_ACK_MINT);      /* Prio for modem intr       */
@@ -234,7 +238,7 @@ static void __init rc_init_CD180(struct 
 	rc_out(bp, CD180_PPRH, (RC_OSCFREQ/(1000000/RISCOM_TPS)) >> 8);
 	rc_out(bp, CD180_PPRL, (RC_OSCFREQ/(1000000/RISCOM_TPS)) & 0xff);
 	
-	restore_flags(flags);
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 /* Main probing routine, also sets irq. */
@@ -812,9 +816,9 @@ static int rc_setup_port(struct riscom_b
 		}
 		port->xmit_buf = (unsigned char *) tmp;
 	}
-		
-	save_flags(flags); cli();
-		
+
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	if (port->tty) 
 		clear_bit(TTY_IO_ERROR, &port->tty->flags);
 		
@@ -825,7 +829,7 @@ static int rc_setup_port(struct riscom_b
 	rc_change_speed(bp, port);
 	port->flags |= ASYNC_INITIALIZED;
 		
-	restore_flags(flags);
+	spin_unlock_irqrestore(&riscom_lock, flags);
 	return 0;
 }
 
@@ -901,6 +905,7 @@ static int block_til_ready(struct tty_st
 	int    retval;
 	int    do_clocal = 0;
 	int    CD;
+	unsigned long flags;
 
 	/*
 	 * If the device is in the middle of being closed, then block
@@ -936,19 +941,26 @@ static int block_til_ready(struct tty_st
 	 */
 	retval = 0;
 	add_wait_queue(&port->open_wait, &wait);
-	cli();
+
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	if (!tty_hung_up_p(filp))
 		port->count--;
-	sti();
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
+
 	port->blocked_open++;
 	while (1) {
-		cli();
+		spin_lock_irqsave(&riscom_lock, flags);
+
 		rc_out(bp, CD180_CAR, port_No(port));
 		CD = rc_in(bp, CD180_MSVR) & MSVR_CD;
 		rc_out(bp, CD180_MSVR, MSVR_RTS);
 		bp->DTR &= ~(1u << port_No(port));
 		rc_out(bp, RC_DTR, bp->DTR);
-		sti();
+
+		spin_unlock_irqrestore(&riscom_lock, flags);
+
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (tty_hung_up_p(filp) ||
 		    !(port->flags & ASYNC_INITIALIZED)) {
@@ -1020,8 +1032,9 @@ static void rc_close(struct tty_struct *
 	
 	if (!port || rc_paranoia_check(port, tty->name, "close"))
 		return;
-	
-	save_flags(flags); cli();
+
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	if (tty_hung_up_p(filp))
 		goto out;
 	
@@ -1088,7 +1101,9 @@ static void rc_close(struct tty_struct *
 	}
 	port->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
 	wake_up_interruptible(&port->close_wait);
-out:	restore_flags(flags);
+
+out:
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 static int rc_write(struct tty_struct * tty, 
@@ -1107,34 +1122,33 @@ static int rc_write(struct tty_struct * 
 	if (!tty || !port->xmit_buf)
 		return 0;
 
-	save_flags(flags);
 	while (1) {
-		cli();		
+		spin_lock_irqsave(&riscom_lock, flags);
+
 		c = min_t(int, count, min(SERIAL_XMIT_SIZE - port->xmit_cnt - 1,
 					  SERIAL_XMIT_SIZE - port->xmit_head));
-		if (c <= 0) {
-			restore_flags(flags);
-			break;
-		}
+		if (c <= 0)
+			break;	/* lock continues to be held */
 
 		memcpy(port->xmit_buf + port->xmit_head, buf, c);
 		port->xmit_head = (port->xmit_head + c) & (SERIAL_XMIT_SIZE-1);
 		port->xmit_cnt += c;
-		restore_flags(flags);
+
+		spin_unlock_irqrestore(&riscom_lock, flags);
 
 		buf += c;
 		count -= c;
 		total += c;
 	}
 
-	cli();
 	if (port->xmit_cnt && !tty->stopped && !tty->hw_stopped &&
 	    !(port->IER & IER_TXRDY)) {
 		port->IER |= IER_TXRDY;
 		rc_out(bp, CD180_CAR, port_No(port));
 		rc_out(bp, CD180_IER, port->IER);
 	}
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
 
 	return total;
 }
@@ -1150,7 +1164,7 @@ static void rc_put_char(struct tty_struc
 	if (!tty || !port->xmit_buf)
 		return;
 
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
 	
 	if (port->xmit_cnt >= SERIAL_XMIT_SIZE - 1)
 		goto out;
@@ -1158,7 +1172,9 @@ static void rc_put_char(struct tty_struc
 	port->xmit_buf[port->xmit_head++] = ch;
 	port->xmit_head &= SERIAL_XMIT_SIZE - 1;
 	port->xmit_cnt++;
-out:	restore_flags(flags);
+
+out:
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 static void rc_flush_chars(struct tty_struct * tty)
@@ -1173,11 +1189,13 @@ static void rc_flush_chars(struct tty_st
 	    !port->xmit_buf)
 		return;
 
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	port->IER |= IER_TXRDY;
 	rc_out(port_Board(port), CD180_CAR, port_No(port));
 	rc_out(port_Board(port), CD180_IER, port->IER);
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 static int rc_write_room(struct tty_struct * tty)
@@ -1212,9 +1230,11 @@ static void rc_flush_buffer(struct tty_s
 	if (rc_paranoia_check(port, tty->name, "rc_flush_buffer"))
 		return;
 
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
 	
 	tty_wakeup(tty);
 }
@@ -1231,11 +1251,15 @@ static int rc_tiocmget(struct tty_struct
 		return -ENODEV;
 
 	bp = port_Board(port);
-	save_flags(flags); cli();
+
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	rc_out(bp, CD180_CAR, port_No(port));
 	status = rc_in(bp, CD180_MSVR);
 	result = rc_in(bp, RC_RI) & (1u << port_No(port)) ? 0 : TIOCM_RNG;
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
+
 	result |= ((status & MSVR_RTS) ? TIOCM_RTS : 0)
 		| ((status & MSVR_DTR) ? TIOCM_DTR : 0)
 		| ((status & MSVR_CD)  ? TIOCM_CAR : 0)
@@ -1256,7 +1280,8 @@ static int rc_tiocmset(struct tty_struct
 
 	bp = port_Board(port);
 
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	if (set & TIOCM_RTS)
 		port->MSVR |= MSVR_RTS;
 	if (set & TIOCM_DTR)
@@ -1270,7 +1295,9 @@ static int rc_tiocmset(struct tty_struct
 	rc_out(bp, CD180_CAR, port_No(port));
 	rc_out(bp, CD180_MSVR, port->MSVR);
 	rc_out(bp, RC_DTR, bp->DTR);
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
+
 	return 0;
 }
 
@@ -1279,7 +1306,8 @@ static inline void rc_send_break(struct 
 	struct riscom_board *bp = port_Board(port);
 	unsigned long flags;
 	
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	port->break_length = RISCOM_TPS / HZ * length;
 	port->COR2 |= COR2_ETC;
 	port->IER  |= IER_TXRDY;
@@ -1289,7 +1317,8 @@ static inline void rc_send_break(struct 
 	rc_wait_CCR(bp);
 	rc_out(bp, CD180_CCR, CCR_CORCHG2);
 	rc_wait_CCR(bp);
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 static inline int rc_set_serial_info(struct riscom_port * port,
@@ -1298,7 +1327,6 @@ static inline int rc_set_serial_info(str
 	struct serial_struct tmp;
 	struct riscom_board *bp = port_Board(port);
 	int change_speed;
-	unsigned long flags;
 	
 	if (copy_from_user(&tmp, newinfo, sizeof(tmp)))
 		return -EFAULT;
@@ -1332,9 +1360,11 @@ static inline int rc_set_serial_info(str
 		port->closing_wait = tmp.closing_wait;
 	}
 	if (change_speed)  {
-		save_flags(flags); cli();
+		unsigned long flags;
+
+		spin_lock_irqsave(&riscom_lock, flags);
 		rc_change_speed(bp, port);
-		restore_flags(flags);
+		spin_unlock_irqrestore(&riscom_lock, flags);
 	}
 	return 0;
 }
@@ -1414,17 +1444,19 @@ static void rc_throttle(struct tty_struc
 		return;
 	
 	bp = port_Board(port);
-	
-	save_flags(flags); cli();
+
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	port->MSVR &= ~MSVR_RTS;
 	rc_out(bp, CD180_CAR, port_No(port));
-	if (I_IXOFF(tty))  {
+	if (I_IXOFF(tty)) {
 		rc_wait_CCR(bp);
 		rc_out(bp, CD180_CCR, CCR_SSCH2);
 		rc_wait_CCR(bp);
 	}
 	rc_out(bp, CD180_MSVR, port->MSVR);
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 static void rc_unthrottle(struct tty_struct * tty)
@@ -1438,7 +1470,8 @@ static void rc_unthrottle(struct tty_str
 	
 	bp = port_Board(port);
 	
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	port->MSVR |= MSVR_RTS;
 	rc_out(bp, CD180_CAR, port_No(port));
 	if (I_IXOFF(tty))  {
@@ -1447,7 +1480,8 @@ static void rc_unthrottle(struct tty_str
 		rc_wait_CCR(bp);
 	}
 	rc_out(bp, CD180_MSVR, port->MSVR);
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 static void rc_stop(struct tty_struct * tty)
@@ -1461,11 +1495,13 @@ static void rc_stop(struct tty_struct * 
 	
 	bp = port_Board(port);
 	
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	port->IER &= ~IER_TXRDY;
 	rc_out(bp, CD180_CAR, port_No(port));
 	rc_out(bp, CD180_IER, port->IER);
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 static void rc_start(struct tty_struct * tty)
@@ -1479,13 +1515,15 @@ static void rc_start(struct tty_struct *
 	
 	bp = port_Board(port);
 	
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	if (port->xmit_cnt && port->xmit_buf && !(port->IER & IER_TXRDY))  {
 		port->IER |= IER_TXRDY;
 		rc_out(bp, CD180_CAR, port_No(port));
 		rc_out(bp, CD180_IER, port->IER);
 	}
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 /*
@@ -1537,9 +1575,9 @@ static void rc_set_termios(struct tty_st
 	    tty->termios->c_iflag == old_termios->c_iflag)
 		return;
 
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
 	rc_change_speed(port_Board(port), port);
-	restore_flags(flags);
+	spin_unlock_irqrestore(&riscom_lock, flags);
 
 	if ((old_termios->c_cflag & CRTSCTS) &&
 	    !(tty->termios->c_cflag & CRTSCTS)) {
@@ -1627,11 +1665,12 @@ static void rc_release_drivers(void)
 {
 	unsigned long flags;
 
-	save_flags(flags);
-	cli();
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	tty_unregister_driver(riscom_driver);
 	put_tty_driver(riscom_driver);
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 #ifndef MODULE
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-libata-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls-x86-fix.patch
i8k-allow-i8k-driver-to-be-built-on-x86_64-systems.patch
i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch
i8k-inspiron-e1705-fix.patch
smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch
