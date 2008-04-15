From: akpm@linux-foundation.org
Subject: + tty-the-big-operations-rework.patch added to -mm tree
Date: Mon, 14 Apr 2008 19:04:51 -0700
Message-ID: <200804150204.m3F24pPY005651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760518AbYDOCFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 22:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     tty: The big operations rework
has been added to the -mm tree.  Its filename is
     tty-the-big-operations-rework.patch

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
Subject: tty: The big operations rework
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

- Operations are now a shared const function block as with most other Linux
  objects

- Introduce wrappers for some optional functions to get consistent behaviour

- Wrap put_char which used to be patched by the tty layer

- Document which functions are needed/optional

- Make put_char report success/fail

- Cache the driver->ops pointer in the tty as tty->ops

- Remove various surplus lock calls we no longer need

- Remove proc_write method as noted by Alexey Dobriyan

- Introduce some missing sanity checks where certain driver/ldisc
  combinations would oops as they didn't check needed methods were present

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/hci_ldisc.c        |   13 -
 drivers/char/ip2/ip2main.c           |   12 -
 drivers/char/keyboard.c              |    2 
 drivers/char/n_hdlc.c                |   11 -
 drivers/char/n_r3964.c               |   17 +-
 drivers/char/n_tty.c                 |  103 ++++++---------
 drivers/char/tty_io.c                |  169 ++++++++++---------------
 drivers/char/tty_ioctl.c             |   62 ++++++---
 drivers/input/serio/serport.c        |    2 
 drivers/isdn/gigaset/ser-gigaset.c   |   15 +-
 drivers/net/hamradio/6pack.c         |   36 ++---
 drivers/net/hamradio/mkiss.c         |   15 +-
 drivers/net/irda/irtty-sir.c         |   95 +++-----------
 drivers/net/ppp_async.c              |    9 -
 drivers/net/ppp_synctty.c            |    9 -
 drivers/net/slip.c                   |   13 +
 drivers/serial/serial_core.c         |   38 +++--
 drivers/usb/serial/digi_acceleport.c |    3 
 drivers/usb/serial/usb-serial.c      |  129 +++----------------
 drivers/usb/serial/whiteheat.c       |    4 
 fs/proc/proc_tty.c                   |    6 
 include/linux/tty.h                  |    8 +
 include/linux/tty_driver.h           |  102 +++++++--------
 kernel/printk.c                      |    4 
 net/irda/ircomm/ircomm_tty.c         |    6 
 25 files changed, 380 insertions(+), 503 deletions(-)

diff -puN drivers/bluetooth/hci_ldisc.c~tty-the-big-operations-rework drivers/bluetooth/hci_ldisc.c
--- a/drivers/bluetooth/hci_ldisc.c~tty-the-big-operations-rework
+++ a/drivers/bluetooth/hci_ldisc.c
@@ -143,7 +143,7 @@ restart:
 		int len;
 
 		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
-		len = tty->driver->write(tty, skb->data, skb->len);
+		len = tty->ops->write(tty, skb->data, skb->len);
 		hdev->stat.byte_tx += len;
 
 		skb_pull(skb, len);
@@ -190,8 +190,7 @@ static int hci_uart_flush(struct hci_dev
 
 	/* Flush any pending characters in the driver and discipline. */
 	tty_ldisc_flush(tty);
-	if (tty->driver && tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	tty_driver_flush_buffer(tty);
 
 	if (test_bit(HCI_UART_PROTO_SET, &hu->flags))
 		hu->proto->flush(hu);
@@ -285,9 +284,7 @@ static int hci_uart_tty_open(struct tty_
 
 	if (tty->ldisc.flush_buffer)
 		tty->ldisc.flush_buffer(tty);
-
-	if (tty->driver && tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	tty_driver_flush_buffer(tty);
 
 	return 0;
 }
@@ -374,8 +371,8 @@ static void hci_uart_tty_receive(struct 
 	spin_unlock(&hu->rx_lock);
 
 	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags) &&
-					tty->driver->unthrottle)
-		tty->driver->unthrottle(tty);
+					tty->ops->unthrottle)
+		tty->ops->unthrottle(tty);
 }
 
 static int hci_uart_register_dev(struct hci_uart *hu)
diff -puN drivers/char/ip2/ip2main.c~tty-the-big-operations-rework drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~tty-the-big-operations-rework
+++ a/drivers/char/ip2/ip2main.c
@@ -168,7 +168,7 @@ static int Fip_firmware_size;
 static int  ip2_open(PTTY, struct file *);
 static void ip2_close(PTTY, struct file *);
 static int  ip2_write(PTTY, const unsigned char *, int);
-static void ip2_putchar(PTTY, unsigned char);
+static int  ip2_putchar(PTTY, unsigned char);
 static void ip2_flush_chars(PTTY);
 static int  ip2_write_room(PTTY);
 static int  ip2_chars_in_buf(PTTY);
@@ -1615,10 +1615,9 @@ ip2_close( PTTY tty, struct file *pFile 
 
 	serviceOutgoingFifo ( pCh->pMyBord );
 
-	if ( tty->driver->flush_buffer ) 
-		tty->driver->flush_buffer(tty);
-	if ( tty->ldisc.flush_buffer )  
-		tty->ldisc.flush_buffer(tty);
+	if ( tty->driver->ops->flush_buffer )
+		tty->driver->ops->flush_buffer(tty);
+	tty_ldisc_flush(tty);
 	tty->closing = 0;
 	
 	pCh->pTTY = NULL;
@@ -1737,7 +1736,7 @@ ip2_write( PTTY tty, const unsigned char
 /*                                                                            */
 /*                                                                            */
 /******************************************************************************/
-static void
+static int
 ip2_putchar( PTTY tty, unsigned char ch )
 {
 	i2ChanStrPtr  pCh = tty->driver_data;
@@ -1752,6 +1751,7 @@ ip2_putchar( PTTY tty, unsigned char ch 
 		ip2_flush_chars( tty );
 	} else
 		write_unlock_irqrestore(&pCh->Pbuf_spinlock, flags);
+	return 1;
 
 //	ip2trace (CHANN, ITRC_PUTC, ITRC_RETURN, 1, ch );
 }
diff -puN drivers/char/keyboard.c~tty-the-big-operations-rework drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~tty-the-big-operations-rework
+++ a/drivers/char/keyboard.c
@@ -1228,7 +1228,7 @@ static void kbd_keycode(unsigned int key
 
 	if (rep &&
 	    (!vc_kbd_mode(kbd, VC_REPEAT) ||
-	     (tty && !L_ECHO(tty) && tty->driver->chars_in_buffer(tty)))) {
+	     (tty && !L_ECHO(tty) && tty_chars_in_buffer(tty)))) {
 		/*
 		 * Don't repeat a key if the input buffers are not empty and the
 		 * characters get aren't echoed locally. This makes key repeat
diff -puN drivers/char/n_hdlc.c~tty-the-big-operations-rework drivers/char/n_hdlc.c
--- a/drivers/char/n_hdlc.c~tty-the-big-operations-rework
+++ a/drivers/char/n_hdlc.c
@@ -342,12 +342,10 @@ static int n_hdlc_tty_open (struct tty_s
 #endif
 	
 	/* Flush any pending characters in the driver and discipline. */
-	
 	if (tty->ldisc.flush_buffer)
-		tty->ldisc.flush_buffer (tty);
+		tty->ldisc.flush_buffer(tty);
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer (tty);
+	tty_driver_flush_buffer(tty);
 		
 	if (debuglevel >= DEBUG_LEVEL_INFO)	
 		printk("%s(%d)n_hdlc_tty_open() success\n",__FILE__,__LINE__);
@@ -399,7 +397,7 @@ static void n_hdlc_send_frames(struct n_
 			
 		/* Send the next block of data to device */
 		tty->flags |= (1 << TTY_DO_WRITE_WAKEUP);
-		actual = tty->driver->write(tty, tbuf->buf, tbuf->count);
+		actual = tty->ops->write(tty, tbuf->buf, tbuf->count);
 
 		/* rollback was possible and has been done */
 		if (actual == -ERESTARTSYS) {
@@ -752,8 +750,7 @@ static int n_hdlc_tty_ioctl(struct tty_s
 
 	case TIOCOUTQ:
 		/* get the pending tx byte count in the driver */
-		count = tty->driver->chars_in_buffer ?
-				tty->driver->chars_in_buffer(tty) : 0;
+		count = tty_chars_in_buffer(tty);
 		/* add size of next output frame in queue */
 		spin_lock_irqsave(&n_hdlc->tx_buf_list.spinlock,flags);
 		if (n_hdlc->tx_buf_list.head)
diff -puN drivers/char/n_r3964.c~tty-the-big-operations-rework drivers/char/n_r3964.c
--- a/drivers/char/n_r3964.c~tty-the-big-operations-rework
+++ a/drivers/char/n_r3964.c
@@ -376,8 +376,9 @@ static void put_char(struct r3964_info *
 	if (tty == NULL)
 		return;
 
-	if (tty->driver->put_char) {
-		tty->driver->put_char(tty, ch);
+	/* FIXME: put_char should not be called from an IRQ */
+	if (tty->ops->put_char) {
+		tty->ops->put_char(tty, ch);
 	}
 	pInfo->bcc ^= ch;
 }
@@ -386,12 +387,9 @@ static void flush(struct r3964_info *pIn
 {
 	struct tty_struct *tty = pInfo->tty;
 
-	if (tty == NULL)
+	if (tty == NULL || tty->ops->flush_chars == NULL)
 		return;
-
-	if (tty->driver->flush_chars) {
-		tty->driver->flush_chars(tty);
-	}
+	tty->ops->flush_chars(tty);
 }
 
 static void trigger_transmit(struct r3964_info *pInfo)
@@ -449,12 +447,11 @@ static void transmit_block(struct r3964_
 	struct r3964_block_header *pBlock = pInfo->tx_first;
 	int room = 0;
 
-	if ((tty == NULL) || (pBlock == NULL)) {
+	if (tty == NULL || pBlock == NULL) {
 		return;
 	}
 
-	if (tty->driver->write_room)
-		room = tty->driver->write_room(tty);
+	room = tty_write_room(tty);
 
 	TRACE_PS("transmit_block %p, room %d, length %d",
 		 pBlock, room, pBlock->length);
diff -puN drivers/char/n_tty.c~tty-the-big-operations-rework drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~tty-the-big-operations-rework
+++ a/drivers/char/n_tty.c
@@ -149,8 +149,8 @@ static void check_unthrottle(struct tty_
 {
 	if (tty->count &&
 	    test_and_clear_bit(TTY_THROTTLED, &tty->flags) &&
-	    tty->driver->unthrottle)
-		tty->driver->unthrottle(tty);
+	    tty->ops->unthrottle)
+		tty->ops->unthrottle(tty);
 }
 
 /**
@@ -273,7 +273,7 @@ static int opost(unsigned char c, struct
 {
 	int	space, spaces;
 
-	space = tty->driver->write_room(tty);
+	space = tty_write_room(tty);
 	if (!space)
 		return -1;
 
@@ -286,7 +286,7 @@ static int opost(unsigned char c, struct
 			if (O_ONLCR(tty)) {
 				if (space < 2)
 					return -1;
-				tty->driver->put_char(tty, '\r');
+				tty_put_char(tty, '\r');
 				tty->column = 0;
 			}
 			tty->canon_column = tty->column;
@@ -308,7 +308,7 @@ static int opost(unsigned char c, struct
 				if (space < spaces)
 					return -1;
 				tty->column += spaces;
-				tty->driver->write(tty, "        ", spaces);
+				tty->ops->write(tty, "        ", spaces);
 				return 0;
 			}
 			tty->column += spaces;
@@ -325,7 +325,7 @@ static int opost(unsigned char c, struct
 			break;
 		}
 	}
-	tty->driver->put_char(tty, c);
+	tty_put_char(tty, c);
 	unlock_kernel();
 	return 0;
 }
@@ -352,7 +352,7 @@ static ssize_t opost_block(struct tty_st
 	int 	i;
 	const unsigned char *cp;
 
-	space = tty->driver->write_room(tty);
+	space = tty_write_room(tty);
 	if (!space)
 		return 0;
 	if (nr > space)
@@ -390,28 +390,15 @@ static ssize_t opost_block(struct tty_st
 		}
 	}
 break_out:
-	if (tty->driver->flush_chars)
-		tty->driver->flush_chars(tty);
-	i = tty->driver->write(tty, buf, i);
+	if (tty->ops->flush_chars)
+		tty->ops->flush_chars(tty);
+	i = tty->ops->write(tty, buf, i);
 	unlock_kernel();
 	return i;
 }
 
 
 /**
- *	put_char	-	write character to driver
- *	@c: character (or part of unicode symbol)
- *	@tty: terminal device
- *
- *	Queue a byte to the driver layer for output
- */
-
-static inline void put_char(unsigned char c, struct tty_struct *tty)
-{
-	tty->driver->put_char(tty, c);
-}
-
-/**
  *	echo_char	-	echo characters
  *	@c: unicode byte to echo
  *	@tty: terminal device
@@ -423,8 +410,8 @@ static inline void put_char(unsigned cha
 static void echo_char(unsigned char c, struct tty_struct *tty)
 {
 	if (L_ECHOCTL(tty) && iscntrl(c) && c != '\t') {
-		put_char('^', tty);
-		put_char(c ^ 0100, tty);
+		tty_put_char(tty, '^');
+		tty_put_char(tty, c ^ 0100);
 		tty->column += 2;
 	} else
 		opost(c, tty);
@@ -433,7 +420,7 @@ static void echo_char(unsigned char c, s
 static inline void finish_erasing(struct tty_struct *tty)
 {
 	if (tty->erasing) {
-		put_char('/', tty);
+		tty_put_char(tty, '/');
 		tty->column++;
 		tty->erasing = 0;
 	}
@@ -517,7 +504,7 @@ static void eraser(unsigned char c, stru
 		if (L_ECHO(tty)) {
 			if (L_ECHOPRT(tty)) {
 				if (!tty->erasing) {
-					put_char('\\', tty);
+					tty_put_char(tty, '\\');
 					tty->column++;
 					tty->erasing = 1;
 				}
@@ -525,7 +512,7 @@ static void eraser(unsigned char c, stru
 				echo_char(c, tty);
 				while (--cnt > 0) {
 					head = (head+1) & (N_TTY_BUF_SIZE-1);
-					put_char(tty->read_buf[head], tty);
+					tty_put_char(tty, tty->read_buf[head]);
 				}
 			} else if (kill_type == ERASE && !L_ECHOE(tty)) {
 				echo_char(ERASE_CHAR(tty), tty);
@@ -553,22 +540,22 @@ static void eraser(unsigned char c, stru
 				/* Now backup to that column. */
 				while (tty->column > col) {
 					/* Can't use opost here. */
-					put_char('\b', tty);
+					tty_put_char(tty, '\b');
 					if (tty->column > 0)
 						tty->column--;
 				}
 			} else {
 				if (iscntrl(c) && L_ECHOCTL(tty)) {
-					put_char('\b', tty);
-					put_char(' ', tty);
-					put_char('\b', tty);
+					tty_put_char(tty, '\b');
+					tty_put_char(tty, ' ');
+					tty_put_char(tty, '\b');
 					if (tty->column > 0)
 						tty->column--;
 				}
 				if (!iscntrl(c) || L_ECHOCTL(tty)) {
-					put_char('\b', tty);
-					put_char(' ', tty);
-					put_char('\b', tty);
+					tty_put_char(tty, '\b');
+					tty_put_char(tty, ' ');
+					tty_put_char(tty, '\b');
 					if (tty->column > 0)
 						tty->column--;
 				}
@@ -599,8 +586,7 @@ static inline void isig(int sig, struct 
 		kill_pgrp(tty->pgrp, sig, 1);
 	if (flush || !L_NOFLSH(tty)) {
 		n_tty_flush_buffer(tty);
-		if (tty->driver->flush_buffer)
-			tty->driver->flush_buffer(tty);
+		tty_driver_flush_buffer(tty);
 	}
 }
 
@@ -732,7 +718,7 @@ static inline void n_tty_receive_char(st
 		tty->lnext = 0;
 		if (L_ECHO(tty)) {
 			if (tty->read_cnt >= N_TTY_BUF_SIZE-1) {
-				put_char('\a', tty); /* beep if no space */
+				tty_put_char(tty, '\a'); /* beep if no space */
 				return;
 			}
 			/* Record the column of first canon char. */
@@ -776,8 +762,7 @@ send_signal:
 			 */
 			if (!L_NOFLSH(tty)) {
 				n_tty_flush_buffer(tty);
-				if (tty->driver->flush_buffer)
-					tty->driver->flush_buffer(tty);
+				tty_driver_flush_buffer(tty);
 			}
 			if (L_ECHO(tty))
 				echo_char(c, tty);
@@ -806,8 +791,8 @@ send_signal:
 			if (L_ECHO(tty)) {
 				finish_erasing(tty);
 				if (L_ECHOCTL(tty)) {
-					put_char('^', tty);
-					put_char('\b', tty);
+					tty_put_char(tty, '^');
+					tty_put_char(tty, '\b');
 				}
 			}
 			return;
@@ -828,7 +813,7 @@ send_signal:
 		if (c == '\n') {
 			if (L_ECHO(tty) || L_ECHONL(tty)) {
 				if (tty->read_cnt >= N_TTY_BUF_SIZE-1)
-					put_char('\a', tty);
+					tty_put_char(tty, '\a');
 				opost('\n', tty);
 			}
 			goto handle_newline;
@@ -846,7 +831,7 @@ send_signal:
 			 */
 			if (L_ECHO(tty)) {
 				if (tty->read_cnt >= N_TTY_BUF_SIZE-1)
-					put_char('\a', tty);
+					tty_put_char(tty, '\a');
 				/* Record the column of first canon char. */
 				if (tty->canon_head == tty->read_head)
 					tty->canon_column = tty->column;
@@ -876,7 +861,7 @@ handle_newline:
 	finish_erasing(tty);
 	if (L_ECHO(tty)) {
 		if (tty->read_cnt >= N_TTY_BUF_SIZE-1) {
-			put_char('\a', tty); /* beep if no space */
+			tty_put_char(tty, '\a'); /* beep if no space */
 			return;
 		}
 		if (c == '\n')
@@ -980,8 +965,8 @@ static void n_tty_receive_buf(struct tty
 				break;
 			}
 		}
-		if (tty->driver->flush_chars)
-			tty->driver->flush_chars(tty);
+		if (tty->ops->flush_chars)
+			tty->ops->flush_chars(tty);
 	}
 
 	n_tty_set_room(tty);
@@ -1000,8 +985,8 @@ static void n_tty_receive_buf(struct tty
 	if (tty->receive_room < TTY_THRESHOLD_THROTTLE) {
 		/* check TTY_THROTTLED first so it indicates our state */
 		if (!test_and_set_bit(TTY_THROTTLED, &tty->flags) &&
-		    tty->driver->throttle)
-			tty->driver->throttle(tty);
+		    tty->ops->throttle)
+			tty->ops->throttle(tty);
 	}
 }
 
@@ -1086,6 +1071,9 @@ static void n_tty_set_termios(struct tty
 			tty->real_raw = 0;
 	}
 	n_tty_set_room(tty);
+	/* The termios change make the tty ready for I/O */
+	wake_up_interruptible(&tty->write_wait);
+	wake_up_interruptible(&tty->read_wait);
 }
 
 /**
@@ -1513,11 +1501,11 @@ static ssize_t write_chan(struct tty_str
 					break;
 				b++; nr--;
 			}
-			if (tty->driver->flush_chars)
-				tty->driver->flush_chars(tty);
+			if (tty->ops->flush_chars)
+				tty->ops->flush_chars(tty);
 		} else {
 			while (nr > 0) {
-				c = tty->driver->write(tty, b, nr);
+				c = tty->ops->write(tty, b, nr);
 				if (c < 0) {
 					retval = c;
 					goto break_out;
@@ -1554,11 +1542,6 @@ break_out:
  *
  *	This code must be sure never to sleep through a hangup.
  *	Called without the kernel lock held - fine
- *
- *	FIXME: if someone changes the VMIN or discipline settings for the
- *	terminal while another process is in poll() the poll does not
- *	recompute the new limits. Possibly set_termios should issue
- *	a read wakeup to fix this bug.
  */
 
 static unsigned int normal_poll(struct tty_struct *tty, struct file *file,
@@ -1582,9 +1565,9 @@ static unsigned int normal_poll(struct t
 		else
 			tty->minimum_to_wake = 1;
 	}
-	if (!tty_is_writelocked(tty) &&
-			tty->driver->chars_in_buffer(tty) < WAKEUP_CHARS &&
-			tty->driver->write_room(tty) > 0)
+	if (tty->ops->write && !tty_is_writelocked(tty) &&
+			tty_chars_in_buffer(tty) < WAKEUP_CHARS &&
+			tty_write_room(tty) > 0)
 		mask |= POLLOUT | POLLWRNORM;
 	return mask;
 }
diff -puN drivers/char/tty_io.c~tty-the-big-operations-rework drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-the-big-operations-rework
+++ a/drivers/char/tty_io.c
@@ -1108,8 +1108,8 @@ restart:
 	   a reference to the old ldisc. If we ended up flipping back
 	   to the existing ldisc we have two references to it */
 
-	if (tty->ldisc.num != o_ldisc.num && tty->driver->set_ldisc)
-		tty->driver->set_ldisc(tty);
+	if (tty->ldisc.num != o_ldisc.num && tty->ops->set_ldisc)
+		tty->ops->set_ldisc(tty);
 
 	tty_ldisc_put(o_ldisc.num);
 
@@ -1452,8 +1452,7 @@ static void do_tty_hangup(struct work_st
 		/* We may have no line discipline at this point */
 		if (ld->flush_buffer)
 			ld->flush_buffer(tty);
-		if (tty->driver->flush_buffer)
-			tty->driver->flush_buffer(tty);
+		tty_driver_flush_buffer(tty);
 		if ((test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags)) &&
 		    ld->write_wakeup)
 			ld->write_wakeup(tty);
@@ -1516,11 +1515,11 @@ static void do_tty_hangup(struct work_st
 	 * So we just call close() the right number of times.
 	 */
 	if (cons_filp) {
-		if (tty->driver->close)
+		if (tty->ops->close)
 			for (n = 0; n < closecount; n++)
-				tty->driver->close(tty, cons_filp);
-	} else if (tty->driver->hangup)
-		(tty->driver->hangup)(tty);
+				tty->ops->close(tty, cons_filp);
+	} else if (tty->ops->hangup)
+		(tty->ops->hangup)(tty);
 	/*
 	 * We don't want to have driver/ldisc interactions beyond
 	 * the ones we did here. The driver layer expects no
@@ -1752,8 +1751,8 @@ void stop_tty(struct tty_struct *tty)
 		wake_up_interruptible(&tty->link->read_wait);
 	}
 	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
-	if (tty->driver->stop)
-		(tty->driver->stop)(tty);
+	if (tty->ops->stop)
+		(tty->ops->stop)(tty);
 }
 
 EXPORT_SYMBOL(stop_tty);
@@ -1786,8 +1785,8 @@ void start_tty(struct tty_struct *tty)
 		wake_up_interruptible(&tty->link->read_wait);
 	}
 	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
-	if (tty->driver->start)
-		(tty->driver->start)(tty);
+	if (tty->ops->start)
+		(tty->ops->start)(tty);
 	/* If we have a running line discipline it may need kicking */
 	tty_wakeup(tty);
 }
@@ -1972,10 +1971,13 @@ static ssize_t tty_write(struct file *fi
 	tty = (struct tty_struct *)file->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_write"))
 		return -EIO;
-	if (!tty || !tty->driver->write ||
+	if (!tty || !tty->ops->write ||
 		(test_bit(TTY_IO_ERROR, &tty->flags)))
 			return -EIO;
-
+	/* Short term debug to catch buggy drivers */
+	if (tty->ops->write_room == NULL)
+		printk(KERN_ERR "tty driver %s lacks a write_room method.\n",
+			tty->driver->name);
 	ld = tty_ldisc_ref_wait(tty);
 	if (!ld->write)
 		ret = -EIO;
@@ -2122,6 +2124,7 @@ static int init_dev(struct tty_driver *d
 		goto fail_no_mem;
 	initialize_tty_struct(tty);
 	tty->driver = driver;
+	tty->ops = driver->ops;
 	tty->index = idx;
 	tty_line_name(driver, idx, tty->name);
 
@@ -2152,6 +2155,7 @@ static int init_dev(struct tty_driver *d
 			goto free_mem_out;
 		initialize_tty_struct(o_tty);
 		o_tty->driver = driver->other;
+		o_tty->ops = driver->ops;
 		o_tty->index = idx;
 		tty_line_name(driver->other, idx, o_tty->name);
 
@@ -2456,8 +2460,8 @@ static void release_dev(struct file *fil
 		}
 	}
 #endif
-	if (tty->driver->close)
-		tty->driver->close(tty, filp);
+	if (tty->ops->close)
+		tty->ops->close(tty, filp);
 
 	/*
 	 * Sanity check: if tty->count is going to zero, there shouldn't be
@@ -2740,8 +2744,8 @@ got_driver:
 	printk(KERN_DEBUG "opening %s...", tty->name);
 #endif
 	if (!retval) {
-		if (tty->driver->open)
-			retval = tty->driver->open(tty, filp);
+		if (tty->ops->open)
+			retval = tty->ops->open(tty, filp);
 		else
 			retval = -ENODEV;
 	}
@@ -2840,7 +2844,7 @@ static int ptmx_open(struct inode *inode
 		goto out1;
 
 	check_tty_count(tty, "tty_open");
-	retval = ptm_driver->open(tty, filp);
+	retval = ptm_driver->ops->open(tty, filp);
 	if (!retval)
 		return 0;
 out1:
@@ -3336,25 +3340,20 @@ static int tiocsetd(struct tty_struct *t
 
 static int send_break(struct tty_struct *tty, unsigned int duration)
 {
-	int retval = -EINTR;
-
-	lock_kernel();
 	if (tty_write_lock(tty, 0) < 0)
-		goto out;
-	tty->driver->break_ctl(tty, -1);
+		return -EINTR;
+	tty->ops->break_ctl(tty, -1);
 	if (!signal_pending(current))
 		msleep_interruptible(duration);
-	tty->driver->break_ctl(tty, 0);
+	tty->ops->break_ctl(tty, 0);
 	tty_write_unlock(tty);
 	if (!signal_pending(current))
-		retval = 0;
-out:
-	unlock_kernel();
-	return retval;
+		return -EINTR;
+	return 0;
 }
 
 /**
- *	tiocmget		-	get modem status
+ *	tty_tiocmget		-	get modem status
  *	@tty: tty device
  *	@file: user file pointer
  *	@p: pointer to result
@@ -3369,10 +3368,8 @@ static int tty_tiocmget(struct tty_struc
 {
 	int retval = -EINVAL;
 
-	if (tty->driver->tiocmget) {
-		lock_kernel();
-		retval = tty->driver->tiocmget(tty, file);
-		unlock_kernel();
+	if (tty->ops->tiocmget) {
+		retval = tty->ops->tiocmget(tty, file);
 
 		if (retval >= 0)
 			retval = put_user(retval, p);
@@ -3381,7 +3378,7 @@ static int tty_tiocmget(struct tty_struc
 }
 
 /**
- *	tiocmset		-	set modem status
+ *	tty_tiocmset		-	set modem status
  *	@tty: tty device
  *	@file: user file pointer
  *	@cmd: command - clear bits, set bits or set all
@@ -3398,7 +3395,7 @@ static int tty_tiocmset(struct tty_struc
 {
 	int retval = -EINVAL;
 
-	if (tty->driver->tiocmset) {
+	if (tty->ops->tiocmset) {
 		unsigned int set, clear, val;
 
 		retval = get_user(val, p);
@@ -3422,9 +3419,7 @@ static int tty_tiocmset(struct tty_struc
 		set &= TIOCM_DTR|TIOCM_RTS|TIOCM_OUT1|TIOCM_OUT2|TIOCM_LOOP;
 		clear &= TIOCM_DTR|TIOCM_RTS|TIOCM_OUT1|TIOCM_OUT2|TIOCM_LOOP;
 
-		lock_kernel();
-		retval = tty->driver->tiocmset(tty, file, set, clear);
-		unlock_kernel();
+		retval = tty->ops->tiocmset(tty, file, set, clear);
 	}
 	return retval;
 }
@@ -3455,23 +3450,25 @@ long tty_ioctl(struct file *file, unsign
 
 	retval = -EINVAL;
 
-	if (!tty->driver->break_ctl) {
+	if (!tty->ops->break_ctl) {
 		switch (cmd) {
 		case TIOCSBRK:
 		case TIOCCBRK:
-			if (tty->driver->ioctl)
-				retval = tty->driver->ioctl(tty, file, cmd, arg);
+			if (tty->ops->ioctl)
+				retval = tty->ops->ioctl(tty, file, cmd, arg);
+			if (retval != -EINVAL && retval != -ENOIOCTLCMD)
+				printk(KERN_WARNING "tty: driver %s needs updating to use break_ctl\n", tty->driver->name);
 			return retval;
 
 		/* These two ioctl's always return success; even if */
 		/* the driver doesn't support them. */
 		case TCSBRK:
 		case TCSBRKP:
-			if (!tty->driver->ioctl)
+			if (!tty->ops->ioctl)
 				return 0;
-			lock_kernel();
-			retval = tty->driver->ioctl(tty, file, cmd, arg);
-			unlock_kernel();
+			retval = tty->ops->ioctl(tty, file, cmd, arg);
+			if (retval != -EINVAL && retval != -ENOIOCTLCMD)
+				printk(KERN_WARNING "tty: driver %s needs updating to use break_ctl\n", tty->driver->name);
 			if (retval == -ENOIOCTLCMD)
 				retval = 0;
 			return retval;
@@ -3491,9 +3488,7 @@ long tty_ioctl(struct file *file, unsign
 		if (retval)
 			return retval;
 		if (cmd != TIOCCBRK) {
-			lock_kernel();
 			tty_wait_until_sent(tty, 0);
-			unlock_kernel();
 			if (signal_pending(current))
 				return -EINTR;
 		}
@@ -3531,7 +3526,6 @@ long tty_ioctl(struct file *file, unsign
 	case TIOCGSID:
 		return tiocgsid(tty, real_tty, p);
 	case TIOCGETD:
-		/* FIXME: check this is ok */
 		return put_user(tty->ldisc.num, (int __user *)p);
 	case TIOCSETD:
 		return tiocsetd(tty, p);
@@ -3543,15 +3537,13 @@ long tty_ioctl(struct file *file, unsign
 	 * Break handling
 	 */
 	case TIOCSBRK:	/* Turn break on, unconditionally */
-		lock_kernel();
-		tty->driver->break_ctl(tty, -1);
-		unlock_kernel();
+		if (tty->ops->break_ctl)
+			tty->ops->break_ctl(tty, -1);
 		return 0;
 
 	case TIOCCBRK:	/* Turn break off, unconditionally */
-		lock_kernel();
-		tty->driver->break_ctl(tty, 0);
-		unlock_kernel();
+		if (tty->ops->break_ctl)
+			tty->ops->break_ctl(tty, 0);
 		return 0;
 	case TCSBRK:   /* SVID version: non-zero arg --> no break */
 		/* non-zero arg means wait for all output data
@@ -3580,8 +3572,8 @@ long tty_ioctl(struct file *file, unsign
 		}
 		break;
 	}
-	if (tty->driver->ioctl) {
-		retval = (tty->driver->ioctl)(tty, file, cmd, arg);
+	if (tty->ops->ioctl) {
+		retval = (tty->ops->ioctl)(tty, file, cmd, arg);
 		if (retval != -ENOIOCTLCMD)
 			return retval;
 	}
@@ -3608,8 +3600,8 @@ static long tty_compat_ioctl(struct file
 	if (tty_paranoia_check(tty, inode, "tty_ioctl"))
 		return -EINVAL;
 
-	if (tty->driver->compat_ioctl) {
-		retval = (tty->driver->compat_ioctl)(tty, file, cmd, arg);
+	if (tty->ops->compat_ioctl) {
+		retval = (tty->ops->compat_ioctl)(tty, file, cmd, arg);
 		if (retval != -ENOIOCTLCMD)
 			return retval;
 	}
@@ -3659,8 +3651,7 @@ void __do_SAK(struct tty_struct *tty)
 
 	tty_ldisc_flush(tty);
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	tty_driver_flush_buffer(tty);
 
 	read_lock(&tasklist_lock);
 	/* Kill the entire session */
@@ -3871,15 +3862,27 @@ static void initialize_tty_struct(struct
 	INIT_WORK(&tty->SAK_work, do_SAK_work);
 }
 
-/*
- * The default put_char routine if the driver did not define one.
+/**
+ *	tty_put_char	-	write one character to a tty
+ *	@tty: tty
+ *	@ch: character
+ *
+ *	Write one byte to the tty using the provided put_char method
+ *	if present. Returns the number of characters successfully output.
+ *
+ *	Note: the specific put_char operation in the driver layer may go
+ *	away soon. Don't call it directly, use this method
  */
 
-static void tty_default_put_char(struct tty_struct *tty, unsigned char ch)
+int tty_put_char(struct tty_struct *tty, unsigned char ch)
 {
-	tty->driver->write(tty, &ch, 1);
+	if (tty->ops->put_char)
+		return tty->ops->put_char(tty, ch);
+	return tty->ops->write(tty, &ch, 1);
 }
 
+EXPORT_SYMBOL_GPL(tty_put_char);
+
 static struct class *tty_class;
 
 /**
@@ -3962,37 +3965,8 @@ void put_tty_driver(struct tty_driver *d
 void tty_set_operations(struct tty_driver *driver,
 			const struct tty_operations *op)
 {
-	driver->open = op->open;
-	driver->close = op->close;
-	driver->write = op->write;
-	driver->put_char = op->put_char;
-	driver->flush_chars = op->flush_chars;
-	driver->write_room = op->write_room;
-	driver->chars_in_buffer = op->chars_in_buffer;
-	driver->ioctl = op->ioctl;
-	driver->compat_ioctl = op->compat_ioctl;
-	driver->set_termios = op->set_termios;
-	driver->throttle = op->throttle;
-	driver->unthrottle = op->unthrottle;
-	driver->stop = op->stop;
-	driver->start = op->start;
-	driver->hangup = op->hangup;
-	driver->break_ctl = op->break_ctl;
-	driver->flush_buffer = op->flush_buffer;
-	driver->set_ldisc = op->set_ldisc;
-	driver->wait_until_sent = op->wait_until_sent;
-	driver->send_xchar = op->send_xchar;
-	driver->read_proc = op->read_proc;
-	driver->write_proc = op->write_proc;
-	driver->tiocmget = op->tiocmget;
-	driver->tiocmset = op->tiocmset;
-#ifdef CONFIG_CONSOLE_POLL
-	driver->poll_init = op->poll_init;
-	driver->poll_get_char = op->poll_get_char;
-	driver->poll_put_char = op->poll_put_char;
-#endif
-}
-
+	driver->ops = op;
+};
 
 EXPORT_SYMBOL(alloc_tty_driver);
 EXPORT_SYMBOL(put_tty_driver);
@@ -4055,9 +4029,6 @@ int tty_register_driver(struct tty_drive
 		return error;
 	}
 
-	if (!driver->put_char)
-		driver->put_char = tty_default_put_char;
-
 	mutex_lock(&tty_mutex);
 	list_add(&driver->tty_drivers, &tty_drivers);
 	mutex_unlock(&tty_mutex);
diff -puN drivers/char/tty_ioctl.c~tty-the-big-operations-rework drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty-the-big-operations-rework
+++ a/drivers/char/tty_ioctl.c
@@ -40,6 +40,34 @@
 #define TERMIOS_OLD	8
 
 
+int tty_chars_in_buffer(struct tty_struct *tty)
+{
+	if (tty->ops->chars_in_buffer)
+		return tty->ops->chars_in_buffer(tty);
+	else
+		return 0;
+}
+
+EXPORT_SYMBOL(tty_chars_in_buffer);
+
+int tty_write_room(struct tty_struct *tty)
+{
+	if (tty->ops->write_room)
+		return tty->ops->write_room(tty);
+	return 2048;
+}
+
+EXPORT_SYMBOL(tty_write_room);
+
+void tty_driver_flush_buffer(struct tty_struct *tty)
+{
+	if (tty->ops->flush_buffer)
+		tty->ops->flush_buffer(tty);
+}
+
+EXPORT_SYMBOL(tty_driver_flush_buffer);
+
+
 /**
  *	tty_wait_until_sent	-	wait for I/O to finish
  *	@tty: tty we are waiting for
@@ -58,17 +86,13 @@ void tty_wait_until_sent(struct tty_stru
 
 	printk(KERN_DEBUG "%s wait until sent...\n", tty_name(tty, buf));
 #endif
-	if (!tty->driver->chars_in_buffer)
-		return;
 	if (!timeout)
 		timeout = MAX_SCHEDULE_TIMEOUT;
-	lock_kernel();
 	if (wait_event_interruptible_timeout(tty->write_wait,
-			!tty->driver->chars_in_buffer(tty), timeout) >= 0) {
-		if (tty->driver->wait_until_sent)
-			tty->driver->wait_until_sent(tty, timeout);
+			!tty_chars_in_buffer(tty), timeout) >= 0) {
+		if (tty->ops->wait_until_sent)
+			tty->ops->wait_until_sent(tty, timeout);
 	}
-	unlock_kernel();
 }
 EXPORT_SYMBOL(tty_wait_until_sent);
 
@@ -444,8 +468,8 @@ static void change_termios(struct tty_st
 		}
 	}
 
-	if (tty->driver->set_termios)
-		(*tty->driver->set_termios)(tty, &old_termios);
+	if (tty->ops->set_termios)
+		(*tty->ops->set_termios)(tty, &old_termios);
 	else
 		tty_termios_copy_hw(tty->termios, &old_termios);
 
@@ -748,8 +772,8 @@ static int send_prio_char(struct tty_str
 {
 	int	was_stopped = tty->stopped;
 
-	if (tty->driver->send_xchar) {
-		tty->driver->send_xchar(tty, ch);
+	if (tty->ops->send_xchar) {
+		tty->ops->send_xchar(tty, ch);
 		return 0;
 	}
 
@@ -758,7 +782,7 @@ static int send_prio_char(struct tty_str
 
 	if (was_stopped)
 		start_tty(tty);
-	tty->driver->write(tty, &ch, 1);
+	tty->ops->write(tty, &ch, 1);
 	if (was_stopped)
 		stop_tty(tty);
 	tty_write_unlock(tty);
@@ -778,13 +802,14 @@ static int tty_change_softcar(struct tty
 {
 	int ret = 0;
 	int bit = arg ? CLOCAL : 0;
-	struct ktermios old = *tty->termios;
+	struct ktermios old;
 
 	mutex_lock(&tty->termios_mutex);
+	old = *tty->termios;
 	tty->termios->c_cflag &= ~CLOCAL;
 	tty->termios->c_cflag |= bit;
-	if (tty->driver->set_termios)
-		tty->driver->set_termios(tty, &old);
+	if (tty->ops->set_termios)
+		tty->ops->set_termios(tty, &old);
 	if ((tty->termios->c_cflag & CLOCAL) != bit)
 		ret = -EINVAL;
 	mutex_unlock(&tty->termios_mutex);
@@ -926,8 +951,7 @@ int tty_perform_flush(struct tty_struct 
 			ld->flush_buffer(tty);
 		/* fall through */
 	case TCOFLUSH:
-		if (tty->driver->flush_buffer)
-			tty->driver->flush_buffer(tty);
+		tty_driver_flush_buffer(tty);
 		break;
 	default:
 		tty_ldisc_deref(ld);
@@ -984,9 +1008,7 @@ int n_tty_ioctl(struct tty_struct *tty, 
 	case TCFLSH:
 		return tty_perform_flush(tty, arg);
 	case TIOCOUTQ:
-		return put_user(tty->driver->chars_in_buffer ?
-				tty->driver->chars_in_buffer(tty) : 0,
-				(int __user *) arg);
+		return put_user(tty_chars_in_buffer(tty), (int __user *) arg);
 	case TIOCINQ:
 		retval = tty->read_cnt;
 		if (L_ICANON(tty))
diff -puN drivers/input/serio/serport.c~tty-the-big-operations-rework drivers/input/serio/serport.c
--- a/drivers/input/serio/serport.c~tty-the-big-operations-rework
+++ a/drivers/input/serio/serport.c
@@ -46,7 +46,7 @@ struct serport {
 static int serport_serio_write(struct serio *serio, unsigned char data)
 {
 	struct serport *serport = serio->port_data;
-	return -(serport->tty->driver->write(serport->tty, &data, 1) != 1);
+	return -(serport->tty->ops->write(serport->tty, &data, 1) != 1);
 }
 
 static int serport_serio_open(struct serio *serio)
diff -puN drivers/isdn/gigaset/ser-gigaset.c~tty-the-big-operations-rework drivers/isdn/gigaset/ser-gigaset.c
--- a/drivers/isdn/gigaset/ser-gigaset.c~tty-the-big-operations-rework
+++ a/drivers/isdn/gigaset/ser-gigaset.c
@@ -68,10 +68,10 @@ static int write_modem(struct cardstate 
 	struct tty_struct *tty = cs->hw.ser->tty;
 	struct bc_state *bcs = &cs->bcs[0];	/* only one channel */
 	struct sk_buff *skb = bcs->tx_skb;
-	int sent;
+	int sent = -EOPNOTSUPP;
 
 	if (!tty || !tty->driver || !skb)
-		return -EFAULT;
+		return -EINVAL;
 
 	if (!skb->len) {
 		dev_kfree_skb_any(skb);
@@ -80,7 +80,8 @@ static int write_modem(struct cardstate 
 	}
 
 	set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
-	sent = tty->driver->write(tty, skb->data, skb->len);
+	if (tty->ops->write)
+		sent = tty->ops->write(tty, skb->data, skb->len);
 	gig_dbg(DEBUG_OUTPUT, "write_modem: sent %d", sent);
 	if (sent < 0) {
 		/* error */
@@ -120,7 +121,7 @@ static int send_cb(struct cardstate *cs)
 
 	if (cb->len) {
 		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
-		sent = tty->driver->write(tty, cb->buf + cb->offset, cb->len);
+		sent = tty->ops->write(tty, cb->buf + cb->offset, cb->len);
 		if (sent < 0) {
 			/* error */
 			gig_dbg(DEBUG_OUTPUT, "send_cb: write error %d", sent);
@@ -440,14 +441,14 @@ static int gigaset_set_modem_ctrl(struct
 	struct tty_struct *tty = cs->hw.ser->tty;
 	unsigned int set, clear;
 
-	if (!tty || !tty->driver || !tty->driver->tiocmset)
-		return -EFAULT;
+	if (!tty || !tty->driver || !tty->ops->tiocmset)
+		return -EINVAL;
 	set = new_state & ~old_state;
 	clear = old_state & ~new_state;
 	if (!set && !clear)
 		return 0;
 	gig_dbg(DEBUG_IF, "tiocmset set %x clear %x", set, clear);
-	return tty->driver->tiocmset(tty, NULL, set, clear);
+	return tty->ops->tiocmset(tty, NULL, set, clear);
 }
 
 static int gigaset_baud_rate(struct cardstate *cs, unsigned cflag)
diff -puN drivers/net/hamradio/6pack.c~tty-the-big-operations-rework drivers/net/hamradio/6pack.c
--- a/drivers/net/hamradio/6pack.c~tty-the-big-operations-rework
+++ a/drivers/net/hamradio/6pack.c
@@ -148,13 +148,13 @@ static void sp_xmit_on_air(unsigned long
 
 	if (((sp->status1 & SIXP_DCD_MASK) == 0) && (random < sp->persistence)) {
 		sp->led_state = 0x70;
-		sp->tty->driver->write(sp->tty, &sp->led_state, 1);
+		sp->tty->ops->write(sp->tty, &sp->led_state, 1);
 		sp->tx_enable = 1;
-		actual = sp->tty->driver->write(sp->tty, sp->xbuff, sp->status2);
+		actual = sp->tty->ops->write(sp->tty, sp->xbuff, sp->status2);
 		sp->xleft -= actual;
 		sp->xhead += actual;
 		sp->led_state = 0x60;
-		sp->tty->driver->write(sp->tty, &sp->led_state, 1);
+		sp->tty->ops->write(sp->tty, &sp->led_state, 1);
 		sp->status2 = 0;
 	} else
 		mod_timer(&sp->tx_t, jiffies + ((when + 1) * HZ) / 100);
@@ -220,13 +220,13 @@ static void sp_encaps(struct sixpack *sp
 	 */
 	if (sp->duplex == 1) {
 		sp->led_state = 0x70;
-		sp->tty->driver->write(sp->tty, &sp->led_state, 1);
+		sp->tty->ops->write(sp->tty, &sp->led_state, 1);
 		sp->tx_enable = 1;
-		actual = sp->tty->driver->write(sp->tty, sp->xbuff, count);
+		actual = sp->tty->ops->write(sp->tty, sp->xbuff, count);
 		sp->xleft = count - actual;
 		sp->xhead = sp->xbuff + actual;
 		sp->led_state = 0x60;
-		sp->tty->driver->write(sp->tty, &sp->led_state, 1);
+		sp->tty->ops->write(sp->tty, &sp->led_state, 1);
 	} else {
 		sp->xleft = count;
 		sp->xhead = sp->xbuff;
@@ -444,7 +444,7 @@ static void sixpack_write_wakeup(struct 
 	}
 
 	if (sp->tx_enable) {
-		actual = tty->driver->write(tty, sp->xhead, sp->xleft);
+		actual = tty->ops->write(tty, sp->xhead, sp->xleft);
 		sp->xleft -= actual;
 		sp->xhead += actual;
 	}
@@ -492,8 +492,8 @@ static void sixpack_receive_buf(struct t
 
 	sp_put(sp);
 	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags)
-	    && tty->driver->unthrottle)
-		tty->driver->unthrottle(tty);
+	    && tty->ops->unthrottle)
+		tty->ops->unthrottle(tty);
 }
 
 /*
@@ -554,8 +554,8 @@ static void resync_tnc(unsigned long cha
 	/* resync the TNC */
 
 	sp->led_state = 0x60;
-	sp->tty->driver->write(sp->tty, &sp->led_state, 1);
-	sp->tty->driver->write(sp->tty, &resync_cmd, 1);
+	sp->tty->ops->write(sp->tty, &sp->led_state, 1);
+	sp->tty->ops->write(sp->tty, &resync_cmd, 1);
 
 
 	/* Start resync timer again -- the TNC might be still absent */
@@ -573,7 +573,7 @@ static inline int tnc_init(struct sixpac
 
 	tnc_set_sync_state(sp, TNC_UNSYNC_STARTUP);
 
-	sp->tty->driver->write(sp->tty, &inbyte, 1);
+	sp->tty->ops->write(sp->tty, &inbyte, 1);
 
 	del_timer(&sp->resync_t);
 	sp->resync_t.data = (unsigned long) sp;
@@ -601,6 +601,8 @@ static int sixpack_open(struct tty_struc
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
+	if (tty->ops->write == NULL)
+		return -EOPNOTSUPP;
 
 	dev = alloc_netdev(sizeof(struct sixpack), "sp%d", sp_setup);
 	if (!dev) {
@@ -914,9 +916,9 @@ static void decode_prio_command(struct s
 	} else { /* output watchdog char if idle */
 		if ((sp->status2 != 0) && (sp->duplex == 1)) {
 			sp->led_state = 0x70;
-			sp->tty->driver->write(sp->tty, &sp->led_state, 1);
+			sp->tty->ops->write(sp->tty, &sp->led_state, 1);
 			sp->tx_enable = 1;
-			actual = sp->tty->driver->write(sp->tty, sp->xbuff, sp->status2);
+			actual = sp->tty->ops->write(sp->tty, sp->xbuff, sp->status2);
 			sp->xleft -= actual;
 			sp->xhead += actual;
 			sp->led_state = 0x60;
@@ -926,7 +928,7 @@ static void decode_prio_command(struct s
 	}
 
 	/* needed to trigger the TNC watchdog */
-	sp->tty->driver->write(sp->tty, &sp->led_state, 1);
+	sp->tty->ops->write(sp->tty, &sp->led_state, 1);
 
         /* if the state byte has been received, the TNC is present,
            so the resync timer can be reset. */
@@ -956,12 +958,12 @@ static void decode_std_command(struct si
 			if ((sp->status & SIXP_RX_DCD_MASK) ==
 				SIXP_RX_DCD_MASK) {
 				sp->led_state = 0x68;
-				sp->tty->driver->write(sp->tty, &sp->led_state, 1);
+				sp->tty->ops->write(sp->tty, &sp->led_state, 1);
 			}
 		} else {
 			sp->led_state = 0x60;
 			/* fill trailing bytes with zeroes */
-			sp->tty->driver->write(sp->tty, &sp->led_state, 1);
+			sp->tty->ops->write(sp->tty, &sp->led_state, 1);
 			rest = sp->rx_count;
 			if (rest != 0)
 				 for (i = rest; i <= 3; i++)
diff -puN drivers/net/hamradio/mkiss.c~tty-the-big-operations-rework drivers/net/hamradio/mkiss.c
--- a/drivers/net/hamradio/mkiss.c~tty-the-big-operations-rework
+++ a/drivers/net/hamradio/mkiss.c
@@ -516,7 +516,7 @@ static void ax_encaps(struct net_device 
 	spin_unlock_bh(&ax->buflock);
 
 	set_bit(TTY_DO_WRITE_WAKEUP, &ax->tty->flags);
-	actual = ax->tty->driver->write(ax->tty, ax->xbuff, count);
+	actual = ax->tty->ops->write(ax->tty, ax->xbuff, count);
 	ax->stats.tx_packets++;
 	ax->stats.tx_bytes += actual;
 
@@ -546,7 +546,7 @@ static int ax_xmit(struct sk_buff *skb, 
 		}
 
 		printk(KERN_ERR "mkiss: %s: transmit timed out, %s?\n", dev->name,
-		       (ax->tty->driver->chars_in_buffer(ax->tty) || ax->xleft) ?
+		       (ax->tty->ops->chars_in_buffer(ax->tty) || ax->xleft) ?
 		       "bad line quality" : "driver error");
 
 		ax->xleft = 0;
@@ -736,6 +736,8 @@ static int mkiss_open(struct tty_struct 
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
+	if (tty->ops->write == NULL)
+		return -EOPNOTSUPP;
 
 	dev = alloc_netdev(sizeof(struct mkiss), "ax%d", ax_setup);
 	if (!dev) {
@@ -754,8 +756,7 @@ static int mkiss_open(struct tty_struct 
 	tty->disc_data = ax;
 	tty->receive_room = 65535;
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	tty_driver_flush_buffer(tty);
 
 	/* Restore default settings */
 	dev->type = ARPHRD_AX25;
@@ -936,8 +937,8 @@ static void mkiss_receive_buf(struct tty
 
 	mkiss_put(ax);
 	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags)
-	    && tty->driver->unthrottle)
-		tty->driver->unthrottle(tty);
+	    && tty->ops->unthrottle)
+		tty->ops->unthrottle(tty);
 }
 
 /*
@@ -962,7 +963,7 @@ static void mkiss_write_wakeup(struct tt
 		goto out;
 	}
 
-	actual = tty->driver->write(tty, ax->xhead, ax->xleft);
+	actual = tty->ops->write(tty, ax->xhead, ax->xleft);
 	ax->xleft -= actual;
 	ax->xhead += actual;
 
diff -puN drivers/net/irda/irtty-sir.c~tty-the-big-operations-rework drivers/net/irda/irtty-sir.c
--- a/drivers/net/irda/irtty-sir.c~tty-the-big-operations-rework
+++ a/drivers/net/irda/irtty-sir.c
@@ -64,7 +64,7 @@ static int irtty_chars_in_buffer(struct 
 	IRDA_ASSERT(priv != NULL, return -1;);
 	IRDA_ASSERT(priv->magic == IRTTY_MAGIC, return -1;);
 
-	return priv->tty->driver->chars_in_buffer(priv->tty);
+	return tty_chars_in_buffer(priv->tty);
 }
 
 /* Wait (sleep) until underlaying hardware finished transmission
@@ -93,10 +93,8 @@ static void irtty_wait_until_sent(struct
 	IRDA_ASSERT(priv->magic == IRTTY_MAGIC, return;);
 
 	tty = priv->tty;
-	if (tty->driver->wait_until_sent) {
-		lock_kernel();
-		tty->driver->wait_until_sent(tty, msecs_to_jiffies(100));
-		unlock_kernel();
+	if (tty->ops->wait_until_sent) {
+		tty->ops->wait_until_sent(tty, msecs_to_jiffies(100));
 	}
 	else {
 		msleep(USBSERIAL_TX_DONE_DELAY);
@@ -125,48 +123,14 @@ static int irtty_change_speed(struct sir
 
 	tty = priv->tty;
 
-	lock_kernel();
+	mutex_lock(&tty->termios_mutex);
 	old_termios = *(tty->termios);
 	cflag = tty->termios->c_cflag;
-
-	cflag &= ~CBAUD;
-
-	IRDA_DEBUG(2, "%s(), Setting speed to %d\n", __FUNCTION__, speed);
-
-	switch (speed) {
-	case 1200:
-		cflag |= B1200;
-		break;
-	case 2400:
-		cflag |= B2400;
-		break;
-	case 4800:
-		cflag |= B4800;
-		break;
-	case 19200:
-		cflag |= B19200;
-		break;
-	case 38400:
-		cflag |= B38400;
-		break;
-	case 57600:
-		cflag |= B57600;
-		break;
-	case 115200:
-		cflag |= B115200;
-		break;
-	case 9600:
-	default:
-		cflag |= B9600;
-		break;
-	}	
-
-	tty->termios->c_cflag = cflag;
-	if (tty->driver->set_termios)
-		tty->driver->set_termios(tty, &old_termios);
-	unlock_kernel();
-
+	tty_encode_baud_rate(tty, speed, speed);
+	if (tty->ops->set_termios)
+		tty->ops->set_termios(tty, &old_termios);
 	priv->io.speed = speed;
+	mutex_unlock(&tty->termios_mutex);
 
 	return 0;
 }
@@ -202,8 +166,8 @@ static int irtty_set_dtr_rts(struct sir_
 	 * This function is not yet defined for all tty driver, so
 	 * let's be careful... Jean II
 	 */
-	IRDA_ASSERT(priv->tty->driver->tiocmset != NULL, return -1;);
-	priv->tty->driver->tiocmset(priv->tty, NULL, set, clear);
+	IRDA_ASSERT(priv->tty->ops->tiocmset != NULL, return -1;);
+	priv->tty->ops->tiocmset(priv->tty, NULL, set, clear);
 
 	return 0;
 }
@@ -225,17 +189,13 @@ static int irtty_do_write(struct sir_dev
 	IRDA_ASSERT(priv->magic == IRTTY_MAGIC, return -1;);
 
 	tty = priv->tty;
-	if (!tty->driver->write)
+	if (!tty->ops->write)
 		return 0;
 	tty->flags |= (1 << TTY_DO_WRITE_WAKEUP);
-	if (tty->driver->write_room) {
-		writelen = tty->driver->write_room(tty);
-		if (writelen > len)
-			writelen = len;
-	}
-	else
+	writelen = tty_write_room(tty);
+	if (writelen > len)
 		writelen = len;
-	return tty->driver->write(tty, ptr, writelen);
+	return tty->ops->write(tty, ptr, writelen);
 }
 
 /* ------------------------------------------------------- */
@@ -321,7 +281,7 @@ static inline void irtty_stop_receiver(s
 	struct ktermios old_termios;
 	int cflag;
 
-	lock_kernel();
+	mutex_lock(&tty->termios_mutex);
 	old_termios = *(tty->termios);
 	cflag = tty->termios->c_cflag;
 	
@@ -331,9 +291,9 @@ static inline void irtty_stop_receiver(s
 		cflag |= CREAD;
 
 	tty->termios->c_cflag = cflag;
-	if (tty->driver->set_termios)
-		tty->driver->set_termios(tty, &old_termios);
-	unlock_kernel();
+	if (tty->ops->set_termios)
+		tty->ops->set_termios(tty, &old_termios);
+	mutex_unlock(&tty->termios_mutex);
 }
 
 /*****************************************************************/
@@ -359,8 +319,8 @@ static int irtty_start_dev(struct sir_de
 
 	tty = priv->tty;
 
-	if (tty->driver->start)
-		tty->driver->start(tty);
+	if (tty->ops->start)
+		tty->ops->start(tty);
 	/* Make sure we can receive more data */
 	irtty_stop_receiver(tty, FALSE);
 
@@ -388,8 +348,8 @@ static int irtty_stop_dev(struct sir_dev
 
 	/* Make sure we don't receive more data */
 	irtty_stop_receiver(tty, TRUE);
-	if (tty->driver->stop)
-		tty->driver->stop(tty);
+	if (tty->ops->stop)
+		tty->ops->stop(tty);
 
 	mutex_unlock(&irtty_mutex);
 
@@ -483,11 +443,10 @@ static int irtty_open(struct tty_struct 
 
 	/* stop the underlying  driver */
 	irtty_stop_receiver(tty, TRUE);
-	if (tty->driver->stop)
-		tty->driver->stop(tty);
+	if (tty->ops->stop)
+		tty->ops->stop(tty);
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	tty_driver_flush_buffer(tty);
 	
 	/* apply mtt override */
 	sir_tty_drv.qos_mtt_bits = qos_mtt_bits;
@@ -564,8 +523,8 @@ static void irtty_close(struct tty_struc
 	/* Stop tty */
 	irtty_stop_receiver(tty, TRUE);
 	tty->flags &= ~(1 << TTY_DO_WRITE_WAKEUP);
-	if (tty->driver->stop)
-		tty->driver->stop(tty);
+	if (tty->ops->stop)
+		tty->ops->stop(tty);
 
 	kfree(priv);
 
diff -puN drivers/net/ppp_async.c~tty-the-big-operations-rework drivers/net/ppp_async.c
--- a/drivers/net/ppp_async.c~tty-the-big-operations-rework
+++ a/drivers/net/ppp_async.c
@@ -158,6 +158,9 @@ ppp_asynctty_open(struct tty_struct *tty
 	struct asyncppp *ap;
 	int err;
 
+	if (tty->ops->write == NULL)
+		return -EOPNOTSUPP;
+
 	err = -ENOMEM;
 	ap = kzalloc(sizeof(*ap), GFP_KERNEL);
 	if (!ap)
@@ -359,8 +362,8 @@ ppp_asynctty_receive(struct tty_struct *
 		tasklet_schedule(&ap->tsk);
 	ap_put(ap);
 	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags)
-	    && tty->driver->unthrottle)
-		tty->driver->unthrottle(tty);
+	    && tty->ops->unthrottle)
+		tty->ops->unthrottle(tty);
 }
 
 static void
@@ -676,7 +679,7 @@ ppp_async_push(struct asyncppp *ap)
 		if (!tty_stuffed && ap->optr < ap->olim) {
 			avail = ap->olim - ap->optr;
 			set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
-			sent = tty->driver->write(tty, ap->optr, avail);
+			sent = tty->ops->write(tty, ap->optr, avail);
 			if (sent < 0)
 				goto flush;	/* error, e.g. loss of CD */
 			ap->optr += sent;
diff -puN drivers/net/ppp_synctty.c~tty-the-big-operations-rework drivers/net/ppp_synctty.c
--- a/drivers/net/ppp_synctty.c~tty-the-big-operations-rework
+++ a/drivers/net/ppp_synctty.c
@@ -207,6 +207,9 @@ ppp_sync_open(struct tty_struct *tty)
 	struct syncppp *ap;
 	int err;
 
+	if (tty->ops->write == NULL)
+		return -EOPNOTSUPP;
+
 	ap = kzalloc(sizeof(*ap), GFP_KERNEL);
 	err = -ENOMEM;
 	if (!ap)
@@ -399,8 +402,8 @@ ppp_sync_receive(struct tty_struct *tty,
 		tasklet_schedule(&ap->tsk);
 	sp_put(ap);
 	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags)
-	    && tty->driver->unthrottle)
-		tty->driver->unthrottle(tty);
+	    && tty->ops->unthrottle)
+		tty->ops->unthrottle(tty);
 }
 
 static void
@@ -653,7 +656,7 @@ ppp_sync_push(struct syncppp *ap)
 			tty_stuffed = 0;
 		if (!tty_stuffed && ap->tpkt) {
 			set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
-			sent = tty->driver->write(tty, ap->tpkt->data, ap->tpkt->len);
+			sent = tty->ops->write(tty, ap->tpkt->data, ap->tpkt->len);
 			if (sent < 0)
 				goto flush;	/* error, e.g. loss of CD */
 			if (sent < ap->tpkt->len) {
diff -puN drivers/net/slip.c~tty-the-big-operations-rework drivers/net/slip.c
--- a/drivers/net/slip.c~tty-the-big-operations-rework
+++ a/drivers/net/slip.c
@@ -396,14 +396,14 @@ static void sl_encaps(struct slip *sl, u
 
 	/* Order of next two lines is *very* important.
 	 * When we are sending a little amount of data,
-	 * the transfer may be completed inside driver.write()
+	 * the transfer may be completed inside the ops->write()
 	 * routine, because it's running with interrupts enabled.
 	 * In this case we *never* got WRITE_WAKEUP event,
 	 * if we did not request it before write operation.
 	 *       14 Oct 1994  Dmitry Gorodchanin.
 	 */
 	sl->tty->flags |= (1 << TTY_DO_WRITE_WAKEUP);
-	actual = sl->tty->driver->write(sl->tty, sl->xbuff, count);
+	actual = sl->tty->ops->write(sl->tty, sl->xbuff, count);
 #ifdef SL_CHECK_TRANSMIT
 	sl->dev->trans_start = jiffies;
 #endif
@@ -437,7 +437,7 @@ static void slip_write_wakeup(struct tty
 		return;
 	}
 
-	actual = tty->driver->write(tty, sl->xhead, sl->xleft);
+	actual = tty->ops->write(tty, sl->xhead, sl->xleft);
 	sl->xleft -= actual;
 	sl->xhead += actual;
 }
@@ -462,7 +462,7 @@ static void sl_tx_timeout(struct net_dev
 		}
 		printk(KERN_WARNING "%s: transmit timed out, %s?\n",
 			dev->name,
-			(sl->tty->driver->chars_in_buffer(sl->tty) || sl->xleft) ?
+			(tty_chars_in_buffer(sl->tty) || sl->xleft) ?
 				"bad line quality" : "driver error");
 		sl->xleft = 0;
 		sl->tty->flags &= ~(1 << TTY_DO_WRITE_WAKEUP);
@@ -830,6 +830,9 @@ static int slip_open(struct tty_struct *
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
+	if (tty->ops->write == NULL)
+		return -EOPNOTSUPP;
+
 	/* RTnetlink lock is misused here to serialize concurrent
 	   opens of slip channels. There are better ways, but it is
 	   the simplest one.
@@ -1432,7 +1435,7 @@ static void sl_outfill(unsigned long sls
 			/* put END into tty queue. Is it right ??? */
 			if (!netif_queue_stopped(sl->dev)) {
 				/* if device busy no outfill */
-				sl->tty->driver->write(sl->tty, &s, 1);
+				sl->tty->ops->write(sl->tty, &s, 1);
 			}
 		} else
 			set_bit(SLF_OUTWAIT, &sl->flags);
diff -puN drivers/serial/serial_core.c~tty-the-big-operations-rework drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~tty-the-big-operations-rework
+++ a/drivers/serial/serial_core.c
@@ -532,15 +532,25 @@ uart_write(struct tty_struct *tty, const
 static int uart_write_room(struct tty_struct *tty)
 {
 	struct uart_state *state = tty->driver_data;
+	unsigned long flags;
+	int ret;
 
-	return uart_circ_chars_free(&state->info->xmit);
+	spin_lock_irqsave(&state->port->lock, flags);
+	ret = uart_circ_chars_free(&state->info->xmit);
+	spin_unlock_irqrestore(&state->port->lock, flags);
+	return ret;
 }
 
 static int uart_chars_in_buffer(struct tty_struct *tty)
 {
 	struct uart_state *state = tty->driver_data;
+	unsigned long flags;
+	int ret;
 
-	return uart_circ_chars_pending(&state->info->xmit);
+	spin_lock_irqsave(&state->port->lock, flags);
+	ret = uart_circ_chars_pending(&state->info->xmit);
+	spin_unlock_irqrestore(&state->port->lock, flags);
+	return ret;
 }
 
 static void uart_flush_buffer(struct tty_struct *tty)
@@ -622,6 +632,11 @@ static int uart_get_info(struct uart_sta
 	struct serial_struct tmp;
 
 	memset(&tmp, 0, sizeof(tmp));
+
+	/* Ensure the state we copy is consistent and no hardware changes
+	   occur as we go */
+	mutex_lock(&state->mutex);
+
 	tmp.type	    = port->type;
 	tmp.line	    = port->line;
 	tmp.port	    = port->iobase;
@@ -641,6 +656,8 @@ static int uart_get_info(struct uart_sta
 	tmp.iomem_reg_shift = port->regshift;
 	tmp.iomem_base      = (void *)(unsigned long)port->mapbase;
 
+	mutex_unlock(&state->mutex);
+
 	if (copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
 		return -EFAULT;
 	return 0;
@@ -918,14 +935,12 @@ static void uart_break_ctl(struct tty_st
 	struct uart_state *state = tty->driver_data;
 	struct uart_port *port = state->port;
 
-	lock_kernel();
 	mutex_lock(&state->mutex);
 
 	if (port->type != PORT_UNKNOWN)
 		port->ops->break_ctl(port, break_state);
 
 	mutex_unlock(&state->mutex);
-	unlock_kernel();
 }
 
 static int uart_do_autoconfig(struct uart_state *state)
@@ -1074,7 +1089,6 @@ uart_ioctl(struct tty_struct *tty, struc
 	int ret = -ENOIOCTLCMD;
 
 
-	lock_kernel();
 	/*
 	 * These ioctls don't rely on the hardware to be present.
 	 */
@@ -1144,10 +1158,9 @@ uart_ioctl(struct tty_struct *tty, struc
 		break;
 	}
 	}
- out_up:
+out_up:
 	mutex_unlock(&state->mutex);
- out:
-	unlock_kernel();
+out:
 	return ret;
 }
 
@@ -1173,7 +1186,6 @@ static void uart_set_termios(struct tty_
 		return;
 	}
 
-	lock_kernel();
 	uart_change_speed(state, old_termios);
 
 	/* Handle transition to B0 status */
@@ -1206,7 +1218,6 @@ static void uart_set_termios(struct tty_
 		}
 		spin_unlock_irqrestore(&state->port->lock, flags);
 	}
-	unlock_kernel();
 #if 0
 	/*
 	 * No need to wake up processes in open wait, since they
@@ -1322,11 +1333,11 @@ static void uart_wait_until_sent(struct 
 	struct uart_port *port = state->port;
 	unsigned long char_time, expire;
 
-	BUG_ON(!kernel_locked());
-
 	if (port->type == PORT_UNKNOWN || port->fifosize == 0)
 		return;
 
+	lock_kernel();
+
 	/*
 	 * Set the check interval to be 1/5 of the estimated time to
 	 * send a single character, and make it at least 1.  The check
@@ -1372,6 +1383,7 @@ static void uart_wait_until_sent(struct 
 			break;
 	}
 	set_current_state(TASK_RUNNING); /* might not be needed */
+	unlock_kernel();
 }
 
 /*
@@ -2085,7 +2097,9 @@ int uart_resume_port(struct uart_driver 
 		int ret;
 
 		uart_change_pm(state, 0);
+		spin_lock_irq(&port->lock);
 		ops->set_mctrl(port, 0);
+		spin_unlock_irq(&port->lock);
 		ret = ops->startup(port);
 		if (ret == 0) {
 			uart_change_speed(state, NULL);
diff -puN drivers/usb/serial/digi_acceleport.c~tty-the-big-operations-rework drivers/usb/serial/digi_acceleport.c
--- a/drivers/usb/serial/digi_acceleport.c~tty-the-big-operations-rework
+++ a/drivers/usb/serial/digi_acceleport.c
@@ -1427,8 +1427,7 @@ static void digi_close(struct usb_serial
 		tty_wait_until_sent(tty, DIGI_CLOSE_TIMEOUT);
 
 	/* flush driver and line discipline buffers */
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	tty_driver_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 
 	if (port->serial->dev) {
diff -puN drivers/usb/serial/usb-serial.c~tty-the-big-operations-rework drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c~tty-the-big-operations-rework
+++ a/drivers/usb/serial/usb-serial.c
@@ -296,16 +296,14 @@ static int serial_write (struct tty_stru
 	struct usb_serial_port *port = tty->driver_data;
 	int retval = -ENODEV;
 
-	if (!port || port->serial->dev->state == USB_STATE_NOTATTACHED)
+	if (port->serial->dev->state == USB_STATE_NOTATTACHED)
 		goto exit;
 
 	dbg("%s - port %d, %d byte(s)", __func__, port->number, count);
 
-	if (!port->open_count) {
-		retval = -EINVAL;
-		dbg("%s - port not opened", __func__);
-		goto exit;
-	}
+	/* open_count is managed under the mutex lock for the tty so cannot
+           drop to zero until after the last close completes */
+	WARN_ON(!port->open_count);
 
 	/* pass on to the driver specific version of this function */
 	retval = port->serial->type->write(port, buf, count);
@@ -317,61 +315,28 @@ exit:
 static int serial_write_room (struct tty_struct *tty) 
 {
 	struct usb_serial_port *port = tty->driver_data;
-	int retval = -ENODEV;
-
-	if (!port)
-		goto exit;
-
 	dbg("%s - port %d", __func__, port->number);
-
-	if (!port->open_count) {
-		dbg("%s - port not open", __func__);
-		goto exit;
-	}
-
+	WARN_ON(!port->open_count);
 	/* pass on to the driver specific version of this function */
-	retval = port->serial->type->write_room(port);
-
-exit:
-	return retval;
+	return port->serial->type->write_room(port);
 }
 
 static int serial_chars_in_buffer (struct tty_struct *tty) 
 {
 	struct usb_serial_port *port = tty->driver_data;
-	int retval = -ENODEV;
-
-	if (!port)
-		goto exit;
-
 	dbg("%s = port %d", __func__, port->number);
 
-	if (!port->open_count) {
-		dbg("%s - port not open", __func__);
-		goto exit;
-	}
-
+	WARN_ON(!port->open_count);
 	/* pass on to the driver specific version of this function */
-	retval = port->serial->type->chars_in_buffer(port);
-
-exit:
-	return retval;
+	return port->serial->type->chars_in_buffer(port);
 }
 
 static void serial_throttle (struct tty_struct * tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
-
-	if (!port)
-		return;
-
 	dbg("%s - port %d", __func__, port->number);
 
-	if (!port->open_count) {
-		dbg ("%s - port not open", __func__);
-		return;
-	}
-
+	WARN_ON(!port->open_count);
 	/* pass on to the driver specific version of this function */
 	if (port->serial->type->throttle)
 		port->serial->type->throttle(port);
@@ -380,17 +345,9 @@ static void serial_throttle (struct tty_
 static void serial_unthrottle (struct tty_struct * tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
-
-	if (!port)
-		return;
-
 	dbg("%s - port %d", __func__, port->number);
 
-	if (!port->open_count) {
-		dbg("%s - port not open", __func__);
-		return;
-	}
-
+	WARN_ON(!port->open_count);
 	/* pass on to the driver specific version of this function */
 	if (port->serial->type->unthrottle)
 		port->serial->type->unthrottle(port);
@@ -401,42 +358,27 @@ static int serial_ioctl (struct tty_stru
 	struct usb_serial_port *port = tty->driver_data;
 	int retval = -ENODEV;
 
-	lock_kernel();
-	if (!port)
-		goto exit;
-
 	dbg("%s - port %d, cmd 0x%.4x", __func__, port->number, cmd);
 
-	/* Caution - port->open_count is BKL protected */
-	if (!port->open_count) {
-		dbg ("%s - port not open", __func__);
-		goto exit;
-	}
+	WARN_ON(!port->open_count);
 
 	/* pass on to the driver specific version of this function if it is available */
-	if (port->serial->type->ioctl)
+	if (port->serial->type->ioctl) {
+		lock_kernel();
 		retval = port->serial->type->ioctl(port, file, cmd, arg);
+		unlock_kernel();
+	}
 	else
 		retval = -ENOIOCTLCMD;
-exit:
-	unlock_kernel();
 	return retval;
 }
 
 static void serial_set_termios (struct tty_struct *tty, struct ktermios * old)
 {
 	struct usb_serial_port *port = tty->driver_data;
-
-	if (!port)
-		return;
-
 	dbg("%s - port %d", __func__, port->number);
 
-	if (!port->open_count) {
-		dbg("%s - port not open", __func__);
-		return;
-	}
-
+	WARN_ON(!port->open_count);
 	/* pass on to the driver specific version of this function if it is available */
 	if (port->serial->type->set_termios)
 		port->serial->type->set_termios(port, old);
@@ -448,24 +390,15 @@ static void serial_break (struct tty_str
 {
 	struct usb_serial_port *port = tty->driver_data;
 
-	lock_kernel();
-	if (!port) {
-		unlock_kernel();
-		return;
-	}
-
 	dbg("%s - port %d", __func__, port->number);
 
-	if (!port->open_count) {
-		dbg("%s - port not open", __func__);
-		unlock_kernel();
-		return;
-	}
-
+	WARN_ON(!port->open_count);
 	/* pass on to the driver specific version of this function if it is available */
-	if (port->serial->type->break_ctl)
+	if (port->serial->type->break_ctl) {
+		lock_kernel();
 		port->serial->type->break_ctl(port, break_state);
-	unlock_kernel();
+		unlock_kernel();
+	}
 }
 
 static int serial_read_proc (char *page, char **start, off_t off, int count, int *eof, void *data)
@@ -519,19 +452,11 @@ static int serial_tiocmget (struct tty_s
 {
 	struct usb_serial_port *port = tty->driver_data;
 
-	if (!port)
-		return -ENODEV;
-
 	dbg("%s - port %d", __func__, port->number);
 
-	if (!port->open_count) {
-		dbg("%s - port not open", __func__);
-		return -ENODEV;
-	}
-
+	WARN_ON(!port->open_count);
 	if (port->serial->type->tiocmget)
 		return port->serial->type->tiocmget(port, file);
-
 	return -EINVAL;
 }
 
@@ -540,19 +465,11 @@ static int serial_tiocmset (struct tty_s
 {
 	struct usb_serial_port *port = tty->driver_data;
 
-	if (!port)
-		return -ENODEV;
-
 	dbg("%s - port %d", __func__, port->number);
 
-	if (!port->open_count) {
-		dbg("%s - port not open", __func__);
-		return -ENODEV;
-	}
-
+	WARN_ON(!port->open_count);
 	if (port->serial->type->tiocmset)
 		return port->serial->type->tiocmset(port, file, set, clear);
-
 	return -EINVAL;
 }
 
diff -puN drivers/usb/serial/whiteheat.c~tty-the-big-operations-rework drivers/usb/serial/whiteheat.c
--- a/drivers/usb/serial/whiteheat.c~tty-the-big-operations-rework
+++ a/drivers/usb/serial/whiteheat.c
@@ -679,15 +679,13 @@ static void whiteheat_close(struct usb_s
 	}
 */
 
-	if (port->tty->driver->flush_buffer)
-		port->tty->driver->flush_buffer(port->tty);
+	tty_driver_flush_buffer(port->tty);
 	tty_ldisc_flush(port->tty);
 
 	firm_report_tx_done(port);
 
 	firm_close(port);
 
-printk(KERN_ERR"Before processing rx_urbs_submitted.\n");
 	/* shutdown our bulk reads and writes */
 	mutex_lock(&info->deathwarrant);
 	spin_lock_irq(&info->lock);
diff -puN fs/proc/proc_tty.c~tty-the-big-operations-rework fs/proc/proc_tty.c
--- a/fs/proc/proc_tty.c~tty-the-big-operations-rework
+++ a/fs/proc/proc_tty.c
@@ -177,16 +177,14 @@ void proc_tty_register_driver(struct tty
 {
 	struct proc_dir_entry *ent;
 		
-	if ((!driver->read_proc && !driver->write_proc) ||
-	    !driver->driver_name ||
+	if (!driver->ops->read_proc || !driver->driver_name ||
 	    driver->proc_entry)
 		return;
 
 	ent = create_proc_entry(driver->driver_name, 0, proc_tty_driver);
 	if (!ent)
 		return;
-	ent->read_proc = driver->read_proc;
-	ent->write_proc = driver->write_proc;
+	ent->read_proc = driver->ops->read_proc;
 	ent->owner = driver->owner;
 	ent->data = driver;
 
diff -puN include/linux/tty.h~tty-the-big-operations-rework include/linux/tty.h
--- a/include/linux/tty.h~tty-the-big-operations-rework
+++ a/include/linux/tty.h
@@ -177,9 +177,13 @@ struct signal_struct;
  * size each time the window is created or resized anyway.
  * 						- TYT, 9/14/92
  */
+
+struct tty_operations;
+
 struct tty_struct {
 	int	magic;
 	struct tty_driver *driver;
+	const struct tty_operations *ops;
 	int index;
 	struct tty_ldisc ldisc;
 	struct mutex termios_mutex;
@@ -295,6 +299,10 @@ extern void tty_unregister_device(struct
 extern int tty_read_raw_data(struct tty_struct *tty, unsigned char *bufp,
 			     int buflen);
 extern void tty_write_message(struct tty_struct *tty, char *msg);
+extern int tty_put_char(struct tty_struct *tty, unsigned char c);
+extern int tty_chars_in_buffer(struct tty_struct *tty);
+extern int tty_write_room(struct tty_struct *tty);
+extern void tty_driver_flush_buffer(struct tty_struct *tty);
 
 extern int is_current_pgrp_orphaned(void);
 extern struct pid *tty_get_pgrp(struct tty_struct *tty);
diff -puN include/linux/tty_driver.h~tty-the-big-operations-rework include/linux/tty_driver.h
--- a/include/linux/tty_driver.h~tty-the-big-operations-rework
+++ a/include/linux/tty_driver.h
@@ -12,11 +12,15 @@
  * 	This routine is called when a particular tty device is opened.
  * 	This routine is mandatory; if this routine is not filled in,
  * 	the attempted open will fail with ENODEV.
+ *
+ *	Required method.
  *     
  * void (*close)(struct tty_struct * tty, struct file * filp);
  *
  * 	This routine is called when a particular tty device is closed.
  *
+ *	Required method.
+ *
  * int (*write)(struct tty_struct * tty,
  * 		 const unsigned char *buf, int count);
  *
@@ -26,7 +30,9 @@
  *	number of characters actually accepted for writing.  This
  *	routine is mandatory.
  *
- * void (*put_char)(struct tty_struct *tty, unsigned char ch);
+ *	Optional: Required for writable devices.
+ *
+ * int (*put_char)(struct tty_struct *tty, unsigned char ch);
  *
  * 	This routine is called by the kernel to write a single
  * 	character to the tty device.  If the kernel uses this routine,
@@ -34,10 +40,18 @@
  * 	done stuffing characters into the driver.  If there is no room
  * 	in the queue, the character is ignored.
  *
+ *	Optional: Kernel will use the write method if not provided.
+ *
+ *	Note: Do not call this function directly, call tty_put_char
+ *
  * void (*flush_chars)(struct tty_struct *tty);
  *
  * 	This routine is called by the kernel after it has written a
  * 	series of characters to the tty device using put_char().  
+ *
+ *	Optional:
+ *
+ *	Note: Do not call this function directly, call tty_driver_flush_chars
  * 
  * int  (*write_room)(struct tty_struct *tty);
  *
@@ -45,6 +59,10 @@
  * 	will accept for queuing to be written.  This number is subject
  * 	to change as output buffers get emptied, or if the output flow
  *	control is acted.
+ *
+ *	Required if write method is provided else not needed.
+ *
+ *	Note: Do not call this function directly, call tty_write_room
  * 
  * int  (*ioctl)(struct tty_struct *tty, struct file * file,
  * 	    unsigned int cmd, unsigned long arg);
@@ -53,22 +71,29 @@
  *	device-specific ioctl's.  If the ioctl number passed in cmd
  * 	is not recognized by the driver, it should return ENOIOCTLCMD.
  *
+ *	Optional
+ *
  * long (*compat_ioctl)(struct tty_struct *tty, struct file * file,
  * 	                unsigned int cmd, unsigned long arg);
  *
  * 	implement ioctl processing for 32 bit process on 64 bit system
+ *
+ *	Optional
  * 
  * void (*set_termios)(struct tty_struct *tty, struct ktermios * old);
  *
  * 	This routine allows the tty driver to be notified when
- * 	device's termios settings have changed.  Note that a
- * 	well-designed tty driver should be prepared to accept the case
- * 	where old == NULL, and try to do something rational.
+ * 	device's termios settings have changed.
+ *
+ *	Optional: Called under the termios lock
+ *
  *
  * void (*set_ldisc)(struct tty_struct *tty);
  *
  * 	This routine allows the tty driver to be notified when the
  * 	device's termios settings have changed.
+ *
+ *	Optional: Called under BKL (currently)
  * 
  * void (*throttle)(struct tty_struct * tty);
  *
@@ -86,17 +111,27 @@
  *
  * 	This routine notifies the tty driver that it should stop
  * 	outputting characters to the tty device.  
+ *
+ *	Optional:
+ *
+ *	Note: Call stop_tty not this method.
  * 
  * void (*start)(struct tty_struct *tty);
  *
  * 	This routine notifies the tty driver that it resume sending
  *	characters to the tty device.
+ *
+ *	Optional:
+ *
+ *	Note: Call start_tty not this method.
  * 
  * void (*hangup)(struct tty_struct *tty);
  *
  * 	This routine notifies the tty driver that it should hangup the
  * 	tty device.
  *
+ *	Required:
+ *
  * void (*break_ctl)(struct tty_stuct *tty, int state);
  *
  * 	This optional routine requests the tty driver to turn on or
@@ -106,18 +141,26 @@
  *
  * 	If this routine is implemented, the high-level tty driver will
  * 	handle the following ioctls: TCSBRK, TCSBRKP, TIOCSBRK,
- * 	TIOCCBRK.  Otherwise, these ioctls will be passed down to the
- * 	driver to handle.
+ * 	TIOCCBRK.
+ *
+ *	Optional: Required for TCSBRK/BRKP/etc handling.
  *
  * void (*wait_until_sent)(struct tty_struct *tty, int timeout);
  * 
  * 	This routine waits until the device has written out all of the
  * 	characters in its transmitter FIFO.
  *
+ *	Optional: If not provided the device is assumed to have no FIFO
+ *
+ *	Note: Usually correct to call tty_wait_until_sent
+ *
  * void (*send_xchar)(struct tty_struct *tty, char ch);
  *
  * 	This routine is used to send a high-priority XON/XOFF
  * 	character to the device.
+ *
+ *	Optional: If not provided then the write method is called under
+ *	the atomic write lock to keep it serialized with the ldisc.
  */
 
 #include <linux/fs.h>
@@ -132,7 +175,7 @@ struct tty_operations {
 	void (*close)(struct tty_struct * tty, struct file * filp);
 	int  (*write)(struct tty_struct * tty,
 		      const unsigned char *buf, int count);
-	void (*put_char)(struct tty_struct *tty, unsigned char ch);
+	int  (*put_char)(struct tty_struct *tty, unsigned char ch)
 	void (*flush_chars)(struct tty_struct *tty);
 	int  (*write_room)(struct tty_struct *tty);
 	int  (*chars_in_buffer)(struct tty_struct *tty);
@@ -153,8 +196,6 @@ struct tty_operations {
 	void (*send_xchar)(struct tty_struct *tty, char ch);
 	int (*read_proc)(char *page, char **start, off_t off,
 			  int count, int *eof, void *data);
-	int (*write_proc)(struct file *file, const char __user *buffer,
-			  unsigned long count, void *data);
 	int (*tiocmget)(struct tty_struct *tty, struct file *file);
 	int (*tiocmset)(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
@@ -190,48 +231,13 @@ struct tty_driver {
 	struct tty_struct **ttys;
 	struct ktermios **termios;
 	struct ktermios **termios_locked;
-	void *driver_state;	/* only used for the PTY driver */
-	
+	void *driver_state;
+
 	/*
-	 * Interface routines from the upper tty layer to the tty
-	 * driver.	Will be replaced with struct tty_operations.
+	 * Driver methods
 	 */
-	int  (*open)(struct tty_struct * tty, struct file * filp);
-	void (*close)(struct tty_struct * tty, struct file * filp);
-	int  (*write)(struct tty_struct * tty,
-		      const unsigned char *buf, int count);
-	void (*put_char)(struct tty_struct *tty, unsigned char ch);
-	void (*flush_chars)(struct tty_struct *tty);
-	int  (*write_room)(struct tty_struct *tty);
-	int  (*chars_in_buffer)(struct tty_struct *tty);
-	int  (*ioctl)(struct tty_struct *tty, struct file * file,
-		    unsigned int cmd, unsigned long arg);
-	long (*compat_ioctl)(struct tty_struct *tty, struct file * file,
-			     unsigned int cmd, unsigned long arg);
-	void (*set_termios)(struct tty_struct *tty, struct ktermios * old);
-	void (*throttle)(struct tty_struct * tty);
-	void (*unthrottle)(struct tty_struct * tty);
-	void (*stop)(struct tty_struct *tty);
-	void (*start)(struct tty_struct *tty);
-	void (*hangup)(struct tty_struct *tty);
-	void (*break_ctl)(struct tty_struct *tty, int state);
-	void (*flush_buffer)(struct tty_struct *tty);
-	void (*set_ldisc)(struct tty_struct *tty);
-	void (*wait_until_sent)(struct tty_struct *tty, int timeout);
-	void (*send_xchar)(struct tty_struct *tty, char ch);
-	int (*read_proc)(char *page, char **start, off_t off,
-			  int count, int *eof, void *data);
-	int (*write_proc)(struct file *file, const char __user *buffer,
-			  unsigned long count, void *data);
-	int (*tiocmget)(struct tty_struct *tty, struct file *file);
-	int (*tiocmset)(struct tty_struct *tty, struct file *file,
-			unsigned int set, unsigned int clear);
-#ifdef CONFIG_CONSOLE_POLL
-	int (*poll_init)(struct tty_driver *driver, int line, char *options);
-	int (*poll_get_char)(struct tty_driver *driver, int line);
-	void (*poll_put_char)(struct tty_driver *driver, int line, char ch);
-#endif
 
+	const struct tty_operations *ops;
 	struct list_head tty_drivers;
 };
 
diff -puN kernel/printk.c~tty-the-big-operations-rework kernel/printk.c
--- a/kernel/printk.c~tty-the-big-operations-rework
+++ a/kernel/printk.c
@@ -1262,8 +1262,8 @@ late_initcall(disable_boot_consoles);
  */
 void tty_write_message(struct tty_struct *tty, char *msg)
 {
-	if (tty && tty->driver->write)
-		tty->driver->write(tty, msg, strlen(msg));
+	if (tty && tty->ops->write)
+		tty->ops->write(tty, msg, strlen(msg));
 	return;
 }
 
diff -puN net/irda/ircomm/ircomm_tty.c~tty-the-big-operations-rework net/irda/ircomm/ircomm_tty.c
--- a/net/irda/ircomm/ircomm_tty.c~tty-the-big-operations-rework
+++ a/net/irda/ircomm/ircomm_tty.c
@@ -555,10 +555,8 @@ static void ircomm_tty_close(struct tty_
 
 	ircomm_tty_shutdown(self);
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
-	if (tty->ldisc.flush_buffer)
-		tty->ldisc.flush_buffer(tty);
+	tty_driver_flush_buffer(tty);
+	tty_ldisc_flush(tty);
 
 	tty->closing = 0;
 	self->tty = NULL;
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

