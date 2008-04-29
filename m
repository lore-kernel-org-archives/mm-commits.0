From: akpm@linux-foundation.org
Subject: + riscom8-coding-style.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:24:50 -0700
Message-ID: <200804291924.m3TJOo4s005567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758947AbYD2T0P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:26:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com


The patch titled
     riscom8: coding style
has been added to the -mm tree.  Its filename is
     riscom8-coding-style.patch

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
Subject: riscom8: coding style
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/riscom8.c |  644 ++++++++++++++++++---------------------
 1 file changed, 304 insertions(+), 340 deletions(-)

diff -puN drivers/char/riscom8.c~riscom8-coding-style drivers/char/riscom8.c
--- a/drivers/char/riscom8.c~riscom8-coding-style
+++ a/drivers/char/riscom8.c
@@ -4,9 +4,9 @@
  *      Copyright (C) 1994-1996  Dmitry Gorodchanin (pgmdsg@ibi.com)
  *
  *      This code is loosely based on the Linux serial driver, written by
- *      Linus Torvalds, Theodore T'so and others. The RISCom/8 card 
- *      programming info was obtained from various drivers for other OSes 
- *	(FreeBSD, ISC, etc), but no source code from those drivers were 
+ *      Linus Torvalds, Theodore T'so and others. The RISCom/8 card
+ *      programming info was obtained from various drivers for other OSes
+ *	(FreeBSD, ISC, etc), but no source code from those drivers were
  *	directly included in this driver.
  *
  *
@@ -33,7 +33,7 @@
 
 #include <linux/module.h>
 
-#include <asm/io.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/ioport.h>
@@ -49,7 +49,7 @@
 #include <linux/tty_flip.h>
 #include <linux/spinlock.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "riscom8.h"
 #include "riscom8_reg.h"
@@ -57,15 +57,15 @@
 /* Am I paranoid or not ? ;-) */
 #define RISCOM_PARANOIA_CHECK
 
-/* 
- * Crazy InteliCom/8 boards sometimes has swapped CTS & DSR signals.
+/*
+ * Crazy InteliCom/8 boards sometimes have swapped CTS & DSR signals.
  * You can slightly speed up things by #undefing the following option,
- * if you are REALLY sure that your board is correct one. 
+ * if you are REALLY sure that your board is correct one.
  */
 
 #define RISCOM_BRAIN_DAMAGED_CTS
 
-/* 
+/*
  * The following defines are mostly for testing purposes. But if you need
  * some nice reporting in your syslog, you can define them also.
  */
@@ -112,7 +112,7 @@ static unsigned short rc_ioport[] =  {
 #define RC_NIOPORT	ARRAY_SIZE(rc_ioport)
 
 
-static inline int rc_paranoia_check(struct riscom_port const * port,
+static int rc_paranoia_check(struct riscom_port const *port,
 				    char *name, const char *routine)
 {
 #ifdef RISCOM_PARANOIA_CHECK
@@ -134,52 +134,53 @@ static inline int rc_paranoia_check(stru
 }
 
 /*
- * 
+ *
  *  Service functions for RISCom/8 driver.
- * 
+ *
  */
 
 /* Get board number from pointer */
-static inline int board_No (struct riscom_board const * bp)
+static inline int board_No(struct riscom_board const *bp)
 {
 	return bp - rc_board;
 }
 
 /* Get port number from pointer */
-static inline int port_No (struct riscom_port const * port)
+static inline int port_No(struct riscom_port const *port)
 {
-	return RC_PORT(port - rc_port); 
+	return RC_PORT(port - rc_port);
 }
 
 /* Get pointer to board from pointer to port */
-static inline struct riscom_board * port_Board(struct riscom_port const * port)
+static inline struct riscom_board *port_Board(struct riscom_port const *port)
 {
 	return &rc_board[RC_BOARD(port - rc_port)];
 }
 
 /* Input Byte from CL CD180 register */
-static inline unsigned char rc_in(struct riscom_board const * bp, unsigned short reg)
+static inline unsigned char rc_in(struct riscom_board const *bp,
+							unsigned short reg)
 {
 	return inb(bp->base + RC_TO_ISA(reg));
 }
 
 /* Output Byte to CL CD180 register */
-static inline void rc_out(struct riscom_board const * bp, unsigned short reg,
+static inline void rc_out(struct riscom_board const *bp, unsigned short reg,
 			  unsigned char val)
 {
 	outb(val, bp->base + RC_TO_ISA(reg));
 }
 
 /* Wait for Channel Command Register ready */
-static inline void rc_wait_CCR(struct riscom_board const * bp)
+static void rc_wait_CCR(struct riscom_board const *bp)
 {
 	unsigned long delay;
 
 	/* FIXME: need something more descriptive then 100000 :) */
-	for (delay = 100000; delay; delay--) 
+	for (delay = 100000; delay; delay--)
 		if (!rc_in(bp, CD180_CCR))
 			return;
-	
+
 	printk(KERN_INFO "rc%d: Timeout waiting for CCR.\n", board_No(bp));
 }
 
@@ -187,11 +188,11 @@ static inline void rc_wait_CCR(struct ri
  *  RISCom/8 probe functions.
  */
 
-static inline int rc_request_io_range(struct riscom_board * const bp)
+static int rc_request_io_range(struct riscom_board * const bp)
 {
 	int i;
-	
-	for (i = 0; i < RC_NIOPORT; i++)  
+
+	for (i = 0; i < RC_NIOPORT; i++)
 		if (!request_region(RC_TO_ISA(rc_ioport[i]) + bp->base, 1,
 				   "RISCom/8"))  {
 			goto out_release;
@@ -200,42 +201,42 @@ static inline int rc_request_io_range(st
 out_release:
 	printk(KERN_INFO "rc%d: Skipping probe at 0x%03x. IO address in use.\n",
 			 board_No(bp), bp->base);
-	while(--i >= 0)
+	while (--i >= 0)
 		release_region(RC_TO_ISA(rc_ioport[i]) + bp->base, 1);
 	return 1;
 }
 
-static inline void rc_release_io_range(struct riscom_board * const bp)
+static void rc_release_io_range(struct riscom_board * const bp)
 {
 	int i;
-	
-	for (i = 0; i < RC_NIOPORT; i++)  
+
+	for (i = 0; i < RC_NIOPORT; i++)
 		release_region(RC_TO_ISA(rc_ioport[i]) + bp->base, 1);
 }
-	
+
 /* Reset and setup CD180 chip */
-static void __init rc_init_CD180(struct riscom_board const * bp)
+static void __init rc_init_CD180(struct riscom_board const *bp)
 {
 	unsigned long flags;
-	
+
 	spin_lock_irqsave(&riscom_lock, flags);
 
-	rc_out(bp, RC_CTOUT, 0);     	           /* Clear timeout             */
-	rc_wait_CCR(bp);			   /* Wait for CCR ready        */
-	rc_out(bp, CD180_CCR, CCR_HARDRESET);      /* Reset CD180 chip          */
+	rc_out(bp, RC_CTOUT, 0);     	           /* Clear timeout        */
+	rc_wait_CCR(bp);			   /* Wait for CCR ready   */
+	rc_out(bp, CD180_CCR, CCR_HARDRESET);      /* Reset CD180 chip     */
 	spin_unlock_irqrestore(&riscom_lock, flags);
-	msleep(50);				   /* Delay 0.05 sec            */
+	msleep(50);				   /* Delay 0.05 sec       */
 	spin_lock_irqsave(&riscom_lock, flags);
-	rc_out(bp, CD180_GIVR, RC_ID);             /* Set ID for this chip      */
-	rc_out(bp, CD180_GICR, 0);                 /* Clear all bits            */
-	rc_out(bp, CD180_PILR1, RC_ACK_MINT);      /* Prio for modem intr       */
-	rc_out(bp, CD180_PILR2, RC_ACK_TINT);      /* Prio for transmitter intr */
-	rc_out(bp, CD180_PILR3, RC_ACK_RINT);      /* Prio for receiver intr    */
-	
+	rc_out(bp, CD180_GIVR, RC_ID);             /* Set ID for this chip */
+	rc_out(bp, CD180_GICR, 0);                 /* Clear all bits       */
+	rc_out(bp, CD180_PILR1, RC_ACK_MINT);      /* Prio for modem intr  */
+	rc_out(bp, CD180_PILR2, RC_ACK_TINT);      /* Prio for tx intr     */
+	rc_out(bp, CD180_PILR3, RC_ACK_RINT);      /* Prio for rx intr	   */
+
 	/* Setting up prescaler. We need 4 ticks per 1 ms */
 	rc_out(bp, CD180_PPRH, (RC_OSCFREQ/(1000000/RISCOM_TPS)) >> 8);
 	rc_out(bp, CD180_PPRL, (RC_OSCFREQ/(1000000/RISCOM_TPS)) & 0xff);
-	
+
 	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
@@ -245,12 +246,12 @@ static int __init rc_probe(struct riscom
 	unsigned char val1, val2;
 	int irqs = 0;
 	int retries;
-	
+
 	bp->irq = 0;
 
 	if (rc_request_io_range(bp))
 		return 1;
-	
+
 	/* Are the I/O ports here ? */
 	rc_out(bp, CD180_PPRL, 0x5a);
 	outb(0xff, 0x80);
@@ -258,34 +259,34 @@ static int __init rc_probe(struct riscom
 	rc_out(bp, CD180_PPRL, 0xa5);
 	outb(0x00, 0x80);
 	val2 = rc_in(bp, CD180_PPRL);
-	
+
 	if ((val1 != 0x5a) || (val2 != 0xa5))  {
 		printk(KERN_ERR "rc%d: RISCom/8 Board at 0x%03x not found.\n",
 		       board_No(bp), bp->base);
 		goto out_release;
 	}
-	
+
 	/* It's time to find IRQ for this board */
-	for (retries = 0; retries < 5 && irqs <= 0; retries++)  {
+	for (retries = 0; retries < 5 && irqs <= 0; retries++) {
 		irqs = probe_irq_on();
-		rc_init_CD180(bp);	       		/* Reset CD180 chip       */
-		rc_out(bp, CD180_CAR, 2);               /* Select port 2          */
+		rc_init_CD180(bp);		 /* Reset CD180 chip	     */
+		rc_out(bp, CD180_CAR, 2);	 /* Select port 2	     */
 		rc_wait_CCR(bp);
-		rc_out(bp, CD180_CCR, CCR_TXEN);        /* Enable transmitter     */
-		rc_out(bp, CD180_IER, IER_TXRDY);       /* Enable tx empty intr   */
+		rc_out(bp, CD180_CCR, CCR_TXEN); /* Enable transmitter	     */
+		rc_out(bp, CD180_IER, IER_TXRDY);/* Enable tx empty intr     */
 		msleep(50);
 		irqs = probe_irq_off(irqs);
-		val1 = rc_in(bp, RC_BSR);		/* Get Board Status reg   */
-		val2 = rc_in(bp, RC_ACK_TINT);          /* ACK interrupt          */
-		rc_init_CD180(bp);	       		/* Reset CD180 again      */
-	
+		val1 = rc_in(bp, RC_BSR);	/* Get Board Status reg	     */
+		val2 = rc_in(bp, RC_ACK_TINT);  /* ACK interrupt	     */
+		rc_init_CD180(bp);	       	/* Reset CD180 again	     */
+
 		if ((val1 & RC_BSR_TINT) || (val2 != (RC_ID | GIVR_IT_TX)))  {
 			printk(KERN_ERR "rc%d: RISCom/8 Board at 0x%03x not "
 					"found.\n", board_No(bp), bp->base);
 			goto out_release;
 		}
 	}
-	
+
 	if (irqs <= 0)  {
 		printk(KERN_ERR "rc%d: Can't find IRQ for RISCom/8 board "
 				"at 0x%03x.\n", board_No(bp), bp->base);
@@ -293,113 +294,112 @@ static int __init rc_probe(struct riscom
 	}
 	bp->irq = irqs;
 	bp->flags |= RC_BOARD_PRESENT;
-	
+
 	printk(KERN_INFO "rc%d: RISCom/8 Rev. %c board detected at "
 			 "0x%03x, IRQ %d.\n",
 	       board_No(bp),
 	       (rc_in(bp, CD180_GFRCR) & 0x0f) + 'A',   /* Board revision */
 	       bp->base, bp->irq);
-	
+
 	return 0;
 out_release:
 	rc_release_io_range(bp);
 	return 1;
 }
 
-/* 
- * 
+/*
+ *
  *  Interrupt processing routines.
- * 
+ *
  */
 
-static inline struct riscom_port * rc_get_port(struct riscom_board const * bp,
-					       unsigned char const * what)
+static struct riscom_port *rc_get_port(struct riscom_board const *bp,
+					       unsigned char const *what)
 {
 	unsigned char channel;
-	struct riscom_port * port;
-	
+	struct riscom_port *port;
+
 	channel = rc_in(bp, CD180_GICR) >> GICR_CHAN_OFF;
 	if (channel < CD180_NCH)  {
 		port = &rc_port[board_No(bp) * RC_NPORT + channel];
-		if (port->flags & ASYNC_INITIALIZED)  {
+		if (port->flags & ASYNC_INITIALIZED)
 			return port;
-		}
 	}
-	printk(KERN_ERR "rc%d: %s interrupt from invalid port %d\n", 
+	printk(KERN_ERR "rc%d: %s interrupt from invalid port %d\n",
 	       board_No(bp), what, channel);
 	return NULL;
 }
 
-static inline void rc_receive_exc(struct riscom_board const * bp)
+static void rc_receive_exc(struct riscom_board const *bp)
 {
 	struct riscom_port *port;
 	struct tty_struct *tty;
 	unsigned char status;
 	unsigned char ch, flag;
-	
-	if (!(port = rc_get_port(bp, "Receive")))
+
+	port = rc_get_port(bp, "Receive");
+	if (port == NULL)
 		return;
 
 	tty = port->tty;
-	
-#ifdef RC_REPORT_OVERRUN	
+
+#ifdef RC_REPORT_OVERRUN
 	status = rc_in(bp, CD180_RCSR);
 	if (status & RCSR_OE)
 		port->overrun++;
 	status &= port->mark_mask;
-#else	
+#else
 	status = rc_in(bp, CD180_RCSR) & port->mark_mask;
-#endif	
+#endif
 	ch = rc_in(bp, CD180_RDR);
-	if (!status)  {
+	if (!status)
 		return;
-	}
 	if (status & RCSR_TOUT)  {
 		printk(KERN_WARNING "rc%d: port %d: Receiver timeout. "
-				    "Hardware problems ?\n", 
+				    "Hardware problems ?\n",
 		       board_No(bp), port_No(port));
 		return;
-		
+
 	} else if (status & RCSR_BREAK)  {
 		printk(KERN_INFO "rc%d: port %d: Handling break...\n",
 		       board_No(bp), port_No(port));
 		flag = TTY_BREAK;
 		if (port->flags & ASYNC_SAK)
 			do_SAK(tty);
-		
-	} else if (status & RCSR_PE) 
+
+	} else if (status & RCSR_PE)
 		flag = TTY_PARITY;
-	
-	else if (status & RCSR_FE) 
+
+	else if (status & RCSR_FE)
 		flag = TTY_FRAME;
-	
-        else if (status & RCSR_OE)
+
+	else if (status & RCSR_OE)
 		flag = TTY_OVERRUN;
-	
 	else
 		flag = TTY_NORMAL;
-	
+
 	tty_insert_flip_char(tty, ch, flag);
 	tty_flip_buffer_push(tty);
 }
 
-static inline void rc_receive(struct riscom_board const * bp)
+static void rc_receive(struct riscom_board const *bp)
 {
 	struct riscom_port *port;
 	struct tty_struct *tty;
 	unsigned char count;
-	
-	if (!(port = rc_get_port(bp, "Receive")))
+
+	port = rc_get_port(bp, "Receive");
+	if (port == NULL)
 		return;
-	
+
 	tty = port->tty;
-	
+
 	count = rc_in(bp, CD180_RDCR);
-	
+
 #ifdef RC_REPORT_FIFO
 	port->hits[count > 8 ? 9 : count]++;
-#endif	
-	
+#endif
+
 	while (count--)  {
 		if (tty_buffer_request_room(tty, 1) == 0)  {
 			printk(KERN_WARNING "rc%d: port %d: Working around "
@@ -412,26 +412,26 @@ static inline void rc_receive(struct ris
 	tty_flip_buffer_push(tty);
 }
 
-static inline void rc_transmit(struct riscom_board const * bp)
+static void rc_transmit(struct riscom_board const *bp)
 {
 	struct riscom_port *port;
 	struct tty_struct *tty;
 	unsigned char count;
-	
-	
-	if (!(port = rc_get_port(bp, "Transmit")))
+
+	port = rc_get_port(bp, "Transmit");
+	if (port == NULL)
 		return;
-	
+
 	tty = port->tty;
-	
-	if (port->IER & IER_TXEMPTY)  {
+
+	if (port->IER & IER_TXEMPTY) {
 		/* FIFO drained */
 		rc_out(bp, CD180_CAR, port_No(port));
 		port->IER &= ~IER_TXEMPTY;
 		rc_out(bp, CD180_IER, port->IER);
 		return;
 	}
-	
+
 	if ((port->xmit_cnt <= 0 && !port->break_length)
 	    || tty->stopped || tty->hw_stopped)  {
 		rc_out(bp, CD180_CAR, port_No(port));
@@ -439,7 +439,7 @@ static inline void rc_transmit(struct ri
 		rc_out(bp, CD180_IER, port->IER);
 		return;
 	}
-	
+
 	if (port->break_length)  {
 		if (port->break_length > 0)  {
 			if (port->COR2 & COR2_ETC)  {
@@ -451,7 +451,8 @@ static inline void rc_transmit(struct ri
 			rc_out(bp, CD180_TDR, CD180_C_ESC);
 			rc_out(bp, CD180_TDR, CD180_C_DELAY);
 			rc_out(bp, CD180_TDR, count);
-			if (!(port->break_length -= count))
+			port->break_length -= count;
+			if (port->break_length == 0)
 				port->break_length--;
 		} else  {
 			rc_out(bp, CD180_TDR, CD180_C_ESC);
@@ -463,7 +464,7 @@ static inline void rc_transmit(struct ri
 		}
 		return;
 	}
-	
+
 	count = CD180_NFIFO;
 	do {
 		rc_out(bp, CD180_TDR, port->xmit_buf[port->xmit_tail++]);
@@ -471,7 +472,7 @@ static inline void rc_transmit(struct ri
 		if (--port->xmit_cnt <= 0)
 			break;
 	} while (--count > 0);
-	
+
 	if (port->xmit_cnt <= 0)  {
 		rc_out(bp, CD180_CAR, port_No(port));
 		port->IER &= ~IER_TXRDY;
@@ -481,25 +482,26 @@ static inline void rc_transmit(struct ri
 		tty_wakeup(tty);
 }
 
-static inline void rc_check_modem(struct riscom_board const * bp)
+static void rc_check_modem(struct riscom_board const *bp)
 {
 	struct riscom_port *port;
 	struct tty_struct *tty;
 	unsigned char mcr;
-	
-	if (!(port = rc_get_port(bp, "Modem")))
+
+	port = rc_get_port(bp, "Modem");
+	if (port == NULL)
 		return;
-	
+
 	tty = port->tty;
-	
+
 	mcr = rc_in(bp, CD180_MCR);
-	if (mcr & MCR_CDCHG)  {
-		if (rc_in(bp, CD180_MSVR) & MSVR_CD) 
+	if (mcr & MCR_CDCHG) {
+		if (rc_in(bp, CD180_MSVR) & MSVR_CD)
 			wake_up_interruptible(&port->open_wait);
 		else
 			tty_hangup(tty);
 	}
-	
+
 #ifdef RISCOM_BRAIN_DAMAGED_CTS
 	if (mcr & MCR_CTSCHG)  {
 		if (rc_in(bp, CD180_MSVR) & MSVR_CTS)  {
@@ -526,13 +528,13 @@ static inline void rc_check_modem(struct
 		rc_out(bp, CD180_IER, port->IER);
 	}
 #endif /* RISCOM_BRAIN_DAMAGED_CTS */
-	
+
 	/* Clear change bits */
 	rc_out(bp, CD180_MCR, 0);
 }
 
 /* The main interrupt processing routine */
-static irqreturn_t rc_interrupt(int dummy, void * dev_id)
+static irqreturn_t rc_interrupt(int dummy, void *dev_id)
 {
 	unsigned char status;
 	unsigned char ack;
@@ -547,13 +549,11 @@ static irqreturn_t rc_interrupt(int dumm
 				 (RC_BSR_TOUT | RC_BSR_TINT |
 				  RC_BSR_MINT | RC_BSR_RINT))) {
 		handled = 1;
-		if (status & RC_BSR_TOUT) 
+		if (status & RC_BSR_TOUT)
 			printk(KERN_WARNING "rc%d: Got timeout. Hardware "
 					    "error?\n", board_No(bp));
-		
 		else if (status & RC_BSR_RINT) {
 			ack = rc_in(bp, RC_ACK_RINT);
-		
 			if (ack == (RC_ID | GIVR_IT_RCV))
 				rc_receive(bp);
 			else if (ack == (RC_ID | GIVR_IT_REXC))
@@ -562,29 +562,23 @@ static irqreturn_t rc_interrupt(int dumm
 				printk(KERN_WARNING "rc%d: Bad receive ack "
 						    "0x%02x.\n",
 				       board_No(bp), ack);
-		
 		} else if (status & RC_BSR_TINT) {
 			ack = rc_in(bp, RC_ACK_TINT);
-		
 			if (ack == (RC_ID | GIVR_IT_TX))
 				rc_transmit(bp);
 			else
 				printk(KERN_WARNING "rc%d: Bad transmit ack "
 						    "0x%02x.\n",
 				       board_No(bp), ack);
-		
 		} else /* if (status & RC_BSR_MINT) */ {
 			ack = rc_in(bp, RC_ACK_MINT);
-		
-			if (ack == (RC_ID | GIVR_IT_MODEM)) 
+			if (ack == (RC_ID | GIVR_IT_MODEM))
 				rc_check_modem(bp);
 			else
 				printk(KERN_WARNING "rc%d: Bad modem ack "
 						    "0x%02x.\n",
 				       board_No(bp), ack);
-		
-		} 
-
+		}
 		rc_out(bp, CD180_EOIR, 0);   /* Mark end of interrupt */
 		rc_out(bp, RC_CTOUT, 0);     /* Clear timeout flag    */
 	}
@@ -596,24 +590,24 @@ static irqreturn_t rc_interrupt(int dumm
  */
 
 /* Called with disabled interrupts */
-static int rc_setup_board(struct riscom_board * bp)
+static int rc_setup_board(struct riscom_board *bp)
 {
 	int error;
 
-	if (bp->flags & RC_BOARD_ACTIVE) 
+	if (bp->flags & RC_BOARD_ACTIVE)
 		return 0;
-	
+
 	error = request_irq(bp->irq, rc_interrupt, IRQF_DISABLED,
 			    "RISCom/8", bp);
-	if (error) 
+	if (error)
 		return error;
-	
+
 	rc_out(bp, RC_CTOUT, 0);       		/* Just in case         */
 	bp->DTR = ~0;
 	rc_out(bp, RC_DTR, bp->DTR);	        /* Drop DTR on all ports */
-	
+
 	bp->flags |= RC_BOARD_ACTIVE;
-	
+
 	return 0;
 }
 
@@ -622,40 +616,40 @@ static void rc_shutdown_board(struct ris
 {
 	if (!(bp->flags & RC_BOARD_ACTIVE))
 		return;
-	
+
 	bp->flags &= ~RC_BOARD_ACTIVE;
-	
+
 	free_irq(bp->irq, NULL);
-	
+
 	bp->DTR = ~0;
 	rc_out(bp, RC_DTR, bp->DTR);	       /* Drop DTR on all ports */
-	
+
 }
 
 /*
- * Setting up port characteristics. 
+ * Setting up port characteristics.
  * Must be called with disabled interrupts
  */
 static void rc_change_speed(struct riscom_board *bp, struct riscom_port *port)
 {
-	struct tty_struct *tty;
+	struct tty_struct *tty = port->tty;
 	unsigned long baud;
 	long tmp;
 	unsigned char cor1 = 0, cor3 = 0;
 	unsigned char mcor1 = 0, mcor2 = 0;
-	
-	if (!(tty = port->tty) || !tty->termios)
+
+	if (tty == NULL || tty->termios == NULL)
 		return;
 
 	port->IER  = 0;
 	port->COR2 = 0;
 	port->MSVR = MSVR_RTS;
-	
+
 	baud = tty_get_baud_rate(tty);
-	
+
 	/* Select port on the board */
 	rc_out(bp, CD180_CAR, port_No(port));
-	
+
 	if (!baud)  {
 		/* Drop DTR & exit */
 		bp->DTR |= (1u << port_No(port));
@@ -666,69 +660,68 @@ static void rc_change_speed(struct risco
 		bp->DTR &= ~(1u << port_No(port));
 		rc_out(bp, RC_DTR, bp->DTR);
 	}
-	
+
 	/*
-	 * Now we must calculate some speed depended things 
+	 * Now we must calculate some speed depended things
 	 */
-	
+
 	/* Set baud rate for port */
 	tmp = (((RC_OSCFREQ + baud/2) / baud +
 		CD180_TPC/2) / CD180_TPC);
 
-	rc_out(bp, CD180_RBPRH, (tmp >> 8) & 0xff); 
-	rc_out(bp, CD180_TBPRH, (tmp >> 8) & 0xff); 
-	rc_out(bp, CD180_RBPRL, tmp & 0xff); 
+	rc_out(bp, CD180_RBPRH, (tmp >> 8) & 0xff);
+	rc_out(bp, CD180_TBPRH, (tmp >> 8) & 0xff);
+	rc_out(bp, CD180_RBPRL, tmp & 0xff);
 	rc_out(bp, CD180_TBPRL, tmp & 0xff);
-	
+
 	baud = (baud + 5) / 10;   /* Estimated CPS */
-	
+
 	/* Two timer ticks seems enough to wakeup something like SLIP driver */
-	tmp = ((baud + HZ/2) / HZ) * 2 - CD180_NFIFO;		
+	tmp = ((baud + HZ/2) / HZ) * 2 - CD180_NFIFO;
 	port->wakeup_chars = (tmp < 0) ? 0 : ((tmp >= SERIAL_XMIT_SIZE) ?
 					      SERIAL_XMIT_SIZE - 1 : tmp);
-	
+
 	/* Receiver timeout will be transmission time for 1.5 chars */
 	tmp = (RISCOM_TPS + RISCOM_TPS/2 + baud/2) / baud;
 	tmp = (tmp > 0xff) ? 0xff : tmp;
 	rc_out(bp, CD180_RTPR, tmp);
-	
-	switch (C_CSIZE(tty))  {
-	 case CS5:
+
+	switch (C_CSIZE(tty)) {
+	case CS5:
 		cor1 |= COR1_5BITS;
 		break;
-	 case CS6:
+	case CS6:
 		cor1 |= COR1_6BITS;
 		break;
-	 case CS7:
+	case CS7:
 		cor1 |= COR1_7BITS;
 		break;
-	 case CS8:
+	case CS8:
 		cor1 |= COR1_8BITS;
 		break;
 	}
-	
-	if (C_CSTOPB(tty)) 
+	if (C_CSTOPB(tty))
 		cor1 |= COR1_2SB;
-	
+
 	cor1 |= COR1_IGNORE;
-	if (C_PARENB(tty))  {
+	if (C_PARENB(tty)) {
 		cor1 |= COR1_NORMPAR;
-		if (C_PARODD(tty)) 
+		if (C_PARODD(tty))
 			cor1 |= COR1_ODDP;
-		if (I_INPCK(tty)) 
+		if (I_INPCK(tty))
 			cor1 &= ~COR1_IGNORE;
 	}
 	/* Set marking of some errors */
 	port->mark_mask = RCSR_OE | RCSR_TOUT;
-	if (I_INPCK(tty)) 
+	if (I_INPCK(tty))
 		port->mark_mask |= RCSR_FE | RCSR_PE;
-	if (I_BRKINT(tty) || I_PARMRK(tty)) 
+	if (I_BRKINT(tty) || I_PARMRK(tty))
 		port->mark_mask |= RCSR_BREAK;
-	if (I_IGNPAR(tty)) 
+	if (I_IGNPAR(tty))
 		port->mark_mask &= ~(RCSR_FE | RCSR_PE);
-	if (I_IGNBRK(tty))  {
+	if (I_IGNBRK(tty)) {
 		port->mark_mask &= ~RCSR_BREAK;
-		if (I_IGNPAR(tty)) 
+		if (I_IGNPAR(tty))
 			/* Real raw mode. Ignore all */
 			port->mark_mask &= ~RCSR_OE;
 	}
@@ -738,7 +731,8 @@ static void rc_change_speed(struct risco
 		port->IER |= IER_DSR | IER_CTS;
 		mcor1 |= MCOR1_DSRZD | MCOR1_CTSZD;
 		mcor2 |= MCOR2_DSROD | MCOR2_CTSOD;
-		tty->hw_stopped = !(rc_in(bp, CD180_MSVR) & (MSVR_CTS|MSVR_DSR));
+		tty->hw_stopped = !(rc_in(bp, CD180_MSVR) &
+						(MSVR_CTS|MSVR_DSR));
 #else
 		port->COR2 |= COR2_CTSAE;
 #endif
@@ -761,13 +755,13 @@ static void rc_change_speed(struct risco
 		mcor1 |= MCOR1_CDZD;
 		mcor2 |= MCOR2_CDOD;
 	}
-	
-	if (C_CREAD(tty)) 
+
+	if (C_CREAD(tty))
 		/* Enable receiver */
 		port->IER |= IER_RXD;
-	
+
 	/* Set input FIFO size (1-8 bytes) */
-	cor3 |= RISCOM_RXFIFO; 
+	cor3 |= RISCOM_RXFIFO;
 	/* Setting up CD180 channel registers */
 	rc_out(bp, CD180_COR1, cor1);
 	rc_out(bp, CD180_COR2, port->COR2);
@@ -791,36 +785,30 @@ static void rc_change_speed(struct risco
 static int rc_setup_port(struct riscom_board *bp, struct riscom_port *port)
 {
 	unsigned long flags;
-	
+
 	if (port->flags & ASYNC_INITIALIZED)
 		return 0;
-	
+
 	if (!port->xmit_buf) {
 		/* We may sleep in get_zeroed_page() */
-		unsigned long tmp;
-		
-		if (!(tmp = get_zeroed_page(GFP_KERNEL)))
+		unsigned long tmp = get_zeroed_page(GFP_KERNEL);
+		if (tmp == 0)
 			return -ENOMEM;
-		    
-		if (port->xmit_buf) {
+		if (port->xmit_buf)
 			free_page(tmp);
-			return -ERESTARTSYS;
-		}
-		port->xmit_buf = (unsigned char *) tmp;
+		else
+			port->xmit_buf = (unsigned char *) tmp;
 	}
-
 	spin_lock_irqsave(&riscom_lock, flags);
 
-	if (port->tty) 
+	if (port->tty)
 		clear_bit(TTY_IO_ERROR, &port->tty->flags);
-		
-	if (port->count == 1) 
+	if (port->count == 1)
 		bp->count++;
-		
 	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
 	rc_change_speed(bp, port);
 	port->flags |= ASYNC_INITIALIZED;
-		
+
 	spin_unlock_irqrestore(&riscom_lock, flags);
 	return 0;
 }
@@ -829,38 +817,39 @@ static int rc_setup_port(struct riscom_b
 static void rc_shutdown_port(struct riscom_board *bp, struct riscom_port *port)
 {
 	struct tty_struct *tty;
-	
-	if (!(port->flags & ASYNC_INITIALIZED)) 
+
+	if (!(port->flags & ASYNC_INITIALIZED))
 		return;
-	
+
 #ifdef RC_REPORT_OVERRUN
 	printk(KERN_INFO "rc%d: port %d: Total %ld overruns were detected.\n",
 	       board_No(bp), port_No(port), port->overrun);
-#endif	
+#endif
 #ifdef RC_REPORT_FIFO
 	{
 		int i;
-		
+
 		printk(KERN_INFO "rc%d: port %d: FIFO hits [ ",
 		       board_No(bp), port_No(port));
-		for (i = 0; i < 10; i++)  {
+		for (i = 0; i < 10; i++)
 			printk("%ld ", port->hits[i]);
-		}
 		printk("].\n");
 	}
-#endif	
+#endif
 	if (port->xmit_buf)  {
 		free_page((unsigned long) port->xmit_buf);
 		port->xmit_buf = NULL;
 	}
 
-	if (!(tty = port->tty) || C_HUPCL(tty))  {
+	tty = port->tty;
+
+	if (tty == NULL || C_HUPCL(tty)) {
 		/* Drop DTR */
 		bp->DTR |= (1u << port_No(port));
 		rc_out(bp, RC_DTR, bp->DTR);
 	}
-	
-        /* Select port */
+
+	/* Select port */
 	rc_out(bp, CD180_CAR, port_No(port));
 	/* Reset port */
 	rc_wait_CCR(bp);
@@ -868,28 +857,26 @@ static void rc_shutdown_port(struct risc
 	/* Disable all interrupts from this port */
 	port->IER = 0;
 	rc_out(bp, CD180_IER, port->IER);
-	
-	if (tty)  
+
+	if (tty)
 		set_bit(TTY_IO_ERROR, &tty->flags);
 	port->flags &= ~ASYNC_INITIALIZED;
-	
+
 	if (--bp->count < 0)  {
 		printk(KERN_INFO "rc%d: rc_shutdown_port: "
 				 "bad board count: %d\n",
 		       board_No(bp), bp->count);
 		bp->count = 0;
 	}
-	
 	/*
 	 * If this is the last opened port on the board
 	 * shutdown whole board
 	 */
-	if (!bp->count) 
+	if (!bp->count)
 		rc_shutdown_board(bp);
 }
 
-	
-static int block_til_ready(struct tty_struct *tty, struct file * filp,
+static int block_til_ready(struct tty_struct *tty, struct file *filp,
 			   struct riscom_port *port)
 {
 	DECLARE_WAITQUEUE(wait, current);
@@ -921,7 +908,7 @@ static int block_til_ready(struct tty_st
 		return 0;
 	}
 
-	if (C_CLOCAL(tty))  
+	if (C_CLOCAL(tty))
 		do_clocal = 1;
 
 	/*
@@ -959,7 +946,7 @@ static int block_til_ready(struct tty_st
 			if (port->flags & ASYNC_HUP_NOTIFY)
 				retval = -EAGAIN;
 			else
-				retval = -ERESTARTSYS;	
+				retval = -ERESTARTSYS;
 			break;
 		}
 		if (!(port->flags & ASYNC_CLOSING) &&
@@ -978,41 +965,39 @@ static int block_til_ready(struct tty_st
 	port->blocked_open--;
 	if (retval)
 		return retval;
-	
+
 	port->flags |= ASYNC_NORMAL_ACTIVE;
 	return 0;
-}	
+}
 
-static int rc_open(struct tty_struct * tty, struct file * filp)
+static int rc_open(struct tty_struct *tty, struct file *filp)
 {
 	int board;
 	int error;
-	struct riscom_port * port;
-	struct riscom_board * bp;
-	
+	struct riscom_port *port;
+	struct riscom_board *bp;
+
 	board = RC_BOARD(tty->index);
 	if (board >= RC_NBOARD || !(rc_board[board].flags & RC_BOARD_PRESENT))
 		return -ENODEV;
-	
+
 	bp = &rc_board[board];
 	port = rc_port + board * RC_NPORT + RC_PORT(tty->index);
 	if (rc_paranoia_check(port, tty->name, "rc_open"))
 		return -ENODEV;
-	
-	if ((error = rc_setup_board(bp))) 
+
+	error = rc_setup_board(bp);
+	if (error)
 		return error;
-		
+
 	port->count++;
 	tty->driver_data = port;
 	port->tty = tty;
-	
-	if ((error = rc_setup_port(bp, port))) 
-		return error;
-	
-	if ((error = block_til_ready(tty, filp, port)))
-		return error;
-	
-	return 0;
+
+	error = rc_setup_port(bp, port);
+	if (error == 0)
+		error = block_til_ready(tty, filp, port);
+	return error;
 }
 
 static void rc_flush_buffer(struct tty_struct *tty)
@@ -1024,22 +1009,19 @@ static void rc_flush_buffer(struct tty_s
 		return;
 
 	spin_lock_irqsave(&riscom_lock, flags);
-
 	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
-
 	spin_unlock_irqrestore(&riscom_lock, flags);
 
 	tty_wakeup(tty);
 }
 
-
-static void rc_close(struct tty_struct * tty, struct file * filp)
+static void rc_close(struct tty_struct *tty, struct file *filp)
 {
 	struct riscom_port *port = (struct riscom_port *) tty->driver_data;
 	struct riscom_board *bp;
 	unsigned long flags;
 	unsigned long timeout;
-	
+
 	if (!port || rc_paranoia_check(port, tty->name, "close"))
 		return;
 
@@ -1047,7 +1029,7 @@ static void rc_close(struct tty_struct *
 
 	if (tty_hung_up_p(filp))
 		goto out;
-	
+
 	bp = port_Board(port);
 	if ((tty->count == 1) && (port->count != 1))  {
 		printk(KERN_INFO "rc%d: rc_close: bad port count;"
@@ -1065,7 +1047,7 @@ static void rc_close(struct tty_struct *
 		goto out;
 	port->flags |= ASYNC_CLOSING;
 	/*
-	 * Now we wait for the transmit buffer to clear; and we notify 
+	 * Now we wait for the transmit buffer to clear; and we notify
 	 * the line discipline to only process XON/XOFF characters.
 	 */
 	tty->closing = 1;
@@ -1088,8 +1070,8 @@ static void rc_close(struct tty_struct *
 		 * has completely drained; this is especially
 		 * important if there is a transmit FIFO!
 		 */
-		timeout = jiffies+HZ;
-		while(port->IER & IER_TXEMPTY)  {
+		timeout = jiffies + HZ;
+		while (port->IER & IER_TXEMPTY) {
 			msleep_interruptible(jiffies_to_msecs(port->timeout));
 			if (time_after(jiffies, timeout))
 				break;
@@ -1102,9 +1084,8 @@ static void rc_close(struct tty_struct *
 	tty->closing = 0;
 	port->tty = NULL;
 	if (port->blocked_open) {
-		if (port->close_delay) {
+		if (port->close_delay)
 			msleep_interruptible(jiffies_to_msecs(port->close_delay));
-		}
 		wake_up_interruptible(&port->open_wait);
 	}
 	port->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
@@ -1114,17 +1095,17 @@ out:
 	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
-static int rc_write(struct tty_struct * tty, 
+static int rc_write(struct tty_struct *tty,
 		    const unsigned char *buf, int count)
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
 	struct riscom_board *bp;
 	int c, total = 0;
 	unsigned long flags;
-				
+
 	if (rc_paranoia_check(port, tty->name, "rc_write"))
 		return 0;
-	
+
 	bp = port_Board(port);
 
 	if (!tty || !port->xmit_buf)
@@ -1161,7 +1142,7 @@ static int rc_write(struct tty_struct * 
 	return total;
 }
 
-static int rc_put_char(struct tty_struct * tty, unsigned char ch)
+static int rc_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
 	unsigned long flags;
@@ -1174,7 +1155,7 @@ static int rc_put_char(struct tty_struct
 		return 0;
 
 	spin_lock_irqsave(&riscom_lock, flags);
-	
+
 	if (port->xmit_cnt >= SERIAL_XMIT_SIZE - 1)
 		goto out;
 
@@ -1188,14 +1169,14 @@ out:
 	return ret;
 }
 
-static void rc_flush_chars(struct tty_struct * tty)
+static void rc_flush_chars(struct tty_struct *tty)
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
 	unsigned long flags;
-				
+
 	if (rc_paranoia_check(port, tty->name, "rc_flush_chars"))
 		return;
-	
+
 	if (port->xmit_cnt <= 0 || tty->stopped || tty->hw_stopped ||
 	    !port->xmit_buf)
 		return;
@@ -1209,11 +1190,11 @@ static void rc_flush_chars(struct tty_st
 	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
-static int rc_write_room(struct tty_struct * tty)
+static int rc_write_room(struct tty_struct *tty)
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
 	int	ret;
-				
+
 	if (rc_paranoia_check(port, tty->name, "rc_write_room"))
 		return 0;
 
@@ -1226,17 +1207,17 @@ static int rc_write_room(struct tty_stru
 static int rc_chars_in_buffer(struct tty_struct *tty)
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
-				
+
 	if (rc_paranoia_check(port, tty->name, "rc_chars_in_buffer"))
 		return 0;
-	
+
 	return port->xmit_cnt;
 }
 
 static int rc_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
-	struct riscom_board * bp;
+	struct riscom_board *bp;
 	unsigned char status;
 	unsigned int result;
 	unsigned long flags;
@@ -1295,11 +1276,11 @@ static int rc_tiocmset(struct tty_struct
 	return 0;
 }
 
-static inline void rc_send_break(struct riscom_port * port, unsigned long length)
+static void rc_send_break(struct riscom_port *port, unsigned long length)
 {
 	struct riscom_board *bp = port_Board(port);
 	unsigned long flags;
-	
+
 	spin_lock_irqsave(&riscom_lock, flags);
 
 	port->break_length = RISCOM_TPS / HZ * length;
@@ -1315,17 +1296,17 @@ static inline void rc_send_break(struct 
 	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
-static inline int rc_set_serial_info(struct riscom_port * port,
-				     struct serial_struct __user * newinfo)
+static int rc_set_serial_info(struct riscom_port *port,
+				     struct serial_struct __user *newinfo)
 {
 	struct serial_struct tmp;
 	struct riscom_board *bp = port_Board(port);
 	int change_speed;
-	
+
 	if (copy_from_user(&tmp, newinfo, sizeof(tmp)))
 		return -EFAULT;
-	
-#if 0	
+
+#if 0
 	if ((tmp.irq != bp->irq) ||
 	    (tmp.port != bp->base) ||
 	    (tmp.type != PORT_CIRRUS) ||
@@ -1334,16 +1315,16 @@ static inline int rc_set_serial_info(str
 	    (tmp.xmit_fifo_size != CD180_NFIFO) ||
 	    (tmp.flags & ~RISCOM_LEGAL_FLAGS))
 		return -EINVAL;
-#endif	
-	
+#endif
+
 	change_speed = ((port->flags & ASYNC_SPD_MASK) !=
 			(tmp.flags & ASYNC_SPD_MASK));
-	
+
 	if (!capable(CAP_SYS_ADMIN)) {
 		if ((tmp.close_delay != port->close_delay) ||
 		    (tmp.closing_wait != port->closing_wait) ||
 		    ((tmp.flags & ~ASYNC_USR_MASK) !=
-		     (port->flags & ~ASYNC_USR_MASK)))  
+		     (port->flags & ~ASYNC_USR_MASK)))
 			return -EPERM;
 		port->flags = ((port->flags & ~ASYNC_USR_MASK) |
 			       (tmp.flags & ASYNC_USR_MASK));
@@ -1363,12 +1344,12 @@ static inline int rc_set_serial_info(str
 	return 0;
 }
 
-static inline int rc_get_serial_info(struct riscom_port * port,
+static int rc_get_serial_info(struct riscom_port *port,
 				     struct serial_struct __user *retinfo)
 {
 	struct serial_struct tmp;
 	struct riscom_board *bp = port_Board(port);
-	
+
 	memset(&tmp, 0, sizeof(tmp));
 	tmp.type = PORT_CIRRUS;
 	tmp.line = port - rc_port;
@@ -1382,19 +1363,18 @@ static inline int rc_get_serial_info(str
 	return copy_to_user(retinfo, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
 
-static int rc_ioctl(struct tty_struct * tty, struct file * filp, 
+static int rc_ioctl(struct tty_struct *tty, struct file *filp,
 		    unsigned int cmd, unsigned long arg)
-		    
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
 	void __user *argp = (void __user *)arg;
 	int retval = 0;
-				
+
 	if (rc_paranoia_check(port, tty->name, "rc_ioctl"))
 		return -ENODEV;
-	
+
 	switch (cmd) {
-	 case TCSBRK:	/* SVID version: non-zero arg --> no break */
+	case TCSBRK:	/* SVID version: non-zero arg --> no break */
 		retval = tty_check_change(tty);
 		if (retval)
 			return retval;
@@ -1402,42 +1382,40 @@ static int rc_ioctl(struct tty_struct * 
 		if (!arg)
 			rc_send_break(port, HZ/4);	/* 1/4 second */
 		break;
-	 case TCSBRKP:	/* support for POSIX tcsendbreak() */
+	case TCSBRKP:	/* support for POSIX tcsendbreak() */
 		retval = tty_check_change(tty);
 		if (retval)
 			return retval;
 		tty_wait_until_sent(tty, 0);
 		rc_send_break(port, arg ? arg*(HZ/10) : HZ/4);
 		break;
-	 case TIOCGSERIAL:
-	 	lock_kernel();
+	case TIOCGSERIAL:
+		lock_kernel();
 		retval = rc_get_serial_info(port, argp);
 		unlock_kernel();
 		break;
-	 case TIOCSSERIAL:	
-	 	lock_kernel();
+	case TIOCSSERIAL:
+		lock_kernel();
 		retval = rc_set_serial_info(port, argp);
 		unlock_kernel();
 		break;
-	 default:
+	default:
 		retval = -ENOIOCTLCMD;
 	}
 	return retval;
 }
 
-static void rc_throttle(struct tty_struct * tty)
+static void rc_throttle(struct tty_struct *tty)
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
 	struct riscom_board *bp;
 	unsigned long flags;
-				
+
 	if (rc_paranoia_check(port, tty->name, "rc_throttle"))
 		return;
-	
 	bp = port_Board(port);
 
 	spin_lock_irqsave(&riscom_lock, flags);
-
 	port->MSVR &= ~MSVR_RTS;
 	rc_out(bp, CD180_CAR, port_No(port));
 	if (I_IXOFF(tty)) {
@@ -1446,23 +1424,20 @@ static void rc_throttle(struct tty_struc
 		rc_wait_CCR(bp);
 	}
 	rc_out(bp, CD180_MSVR, port->MSVR);
-
 	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
-static void rc_unthrottle(struct tty_struct * tty)
+static void rc_unthrottle(struct tty_struct *tty)
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
 	struct riscom_board *bp;
 	unsigned long flags;
-				
+
 	if (rc_paranoia_check(port, tty->name, "rc_unthrottle"))
 		return;
-	
 	bp = port_Board(port);
-	
-	spin_lock_irqsave(&riscom_lock, flags);
 
+	spin_lock_irqsave(&riscom_lock, flags);
 	port->MSVR |= MSVR_RTS;
 	rc_out(bp, CD180_CAR, port_No(port));
 	if (I_IXOFF(tty))  {
@@ -1471,62 +1446,58 @@ static void rc_unthrottle(struct tty_str
 		rc_wait_CCR(bp);
 	}
 	rc_out(bp, CD180_MSVR, port->MSVR);
-
 	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
-static void rc_stop(struct tty_struct * tty)
+static void rc_stop(struct tty_struct *tty)
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
 	struct riscom_board *bp;
 	unsigned long flags;
-				
+
 	if (rc_paranoia_check(port, tty->name, "rc_stop"))
 		return;
-	
+
 	bp = port_Board(port);
-	
-	spin_lock_irqsave(&riscom_lock, flags);
 
+	spin_lock_irqsave(&riscom_lock, flags);
 	port->IER &= ~IER_TXRDY;
 	rc_out(bp, CD180_CAR, port_No(port));
 	rc_out(bp, CD180_IER, port->IER);
-
 	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
-static void rc_start(struct tty_struct * tty)
+static void rc_start(struct tty_struct *tty)
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
 	struct riscom_board *bp;
 	unsigned long flags;
-				
+
 	if (rc_paranoia_check(port, tty->name, "rc_start"))
 		return;
-	
+
 	bp = port_Board(port);
-	
+
 	spin_lock_irqsave(&riscom_lock, flags);
 
-	if (port->xmit_cnt && port->xmit_buf && !(port->IER & IER_TXRDY))  {
+	if (port->xmit_cnt && port->xmit_buf && !(port->IER & IER_TXRDY)) {
 		port->IER |= IER_TXRDY;
 		rc_out(bp, CD180_CAR, port_No(port));
 		rc_out(bp, CD180_IER, port->IER);
 	}
-
 	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
-static void rc_hangup(struct tty_struct * tty)
+static void rc_hangup(struct tty_struct *tty)
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
 	struct riscom_board *bp;
-				
+
 	if (rc_paranoia_check(port, tty->name, "rc_hangup"))
 		return;
-	
+
 	bp = port_Board(port);
-	
+
 	rc_shutdown_port(bp, port);
 	port->count = 0;
 	port->flags &= ~ASYNC_NORMAL_ACTIVE;
@@ -1534,17 +1505,14 @@ static void rc_hangup(struct tty_struct 
 	wake_up_interruptible(&port->open_wait);
 }
 
-static void rc_set_termios(struct tty_struct * tty, struct ktermios * old_termios)
+static void rc_set_termios(struct tty_struct *tty,
+					struct ktermios *old_termios)
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
 	unsigned long flags;
-				
+
 	if (rc_paranoia_check(port, tty->name, "rc_set_termios"))
 		return;
-	
-	if (tty->termios->c_cflag == old_termios->c_cflag &&
-	    tty->termios->c_iflag == old_termios->c_iflag)
-		return;
 
 	spin_lock_irqsave(&riscom_lock, flags);
 	rc_change_speed(port_Board(port), port);
@@ -1583,9 +1551,9 @@ static int __init rc_init_drivers(void)
 	int i;
 
 	riscom_driver = alloc_tty_driver(RC_NBOARD * RC_NPORT);
-	if (!riscom_driver)	
+	if (!riscom_driver)
 		return -ENOMEM;
-	
+
 	riscom_driver->owner = THIS_MODULE;
 	riscom_driver->name = "ttyL";
 	riscom_driver->major = RISCOM8_NORMAL_MAJOR;
@@ -1598,23 +1566,21 @@ static int __init rc_init_drivers(void)
 	riscom_driver->init_termios.c_ospeed = 9600;
 	riscom_driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(riscom_driver, &riscom_ops);
-	if ((error = tty_register_driver(riscom_driver)))  {
+	error = tty_register_driver(riscom_driver);
+	if (error != 0) {
 		put_tty_driver(riscom_driver);
 		printk(KERN_ERR "rc: Couldn't register RISCom/8 driver, "
-				"error = %d\n",
-		       error);
+				"error = %d\n", error);
 		return 1;
 	}
-
 	memset(rc_port, 0, sizeof(rc_port));
 	for (i = 0; i < RC_NPORT * RC_NBOARD; i++)  {
 		rc_port[i].magic = RISCOM8_MAGIC;
-		rc_port[i].close_delay = 50 * HZ/100;
-		rc_port[i].closing_wait = 3000 * HZ/100;
+		rc_port[i].close_delay = 50 * HZ / 100;
+		rc_port[i].closing_wait = 3000 * HZ / 100;
 		init_waitqueue_head(&rc_port[i].open_wait);
 		init_waitqueue_head(&rc_port[i].close_wait);
 	}
-	
 	return 0;
 }
 
@@ -1627,13 +1593,13 @@ static void rc_release_drivers(void)
 #ifndef MODULE
 /*
  * Called at boot time.
- * 
+ *
  * You can specify IO base for up to RC_NBOARD cards,
  * using line "riscom8=0xiobase1,0xiobase2,.." at LILO prompt.
  * Note that there will be no probing at default
  * addresses in this case.
  *
- */ 
+ */
 static int __init riscom8_setup(char *str)
 {
 	int ints[RC_NBOARD];
@@ -1644,7 +1610,7 @@ static int __init riscom8_setup(char *st
 	for (i = 0; i < RC_NBOARD; i++) {
 		if (i < ints[0])
 			rc_board[i].base = ints[i+1];
-		else 
+		else
 			rc_board[i].base = 0;
 	}
 	return 1;
@@ -1659,8 +1625,8 @@ static char banner[] __initdata =
 static char no_boards_msg[] __initdata =
 	KERN_INFO "rc: No RISCom/8 boards detected.\n";
 
-/* 
- * This routine must be called by kernel at boot time 
+/*
+ * This routine must be called by kernel at boot time
  */
 static int __init riscom8_init(void)
 {
@@ -1669,13 +1635,12 @@ static int __init riscom8_init(void)
 
 	printk(banner);
 
-	if (rc_init_drivers()) 
+	if (rc_init_drivers())
 		return -EIO;
 
-	for (i = 0; i < RC_NBOARD; i++) 
-		if (rc_board[i].base && !rc_probe(&rc_board[i]))  
+	for (i = 0; i < RC_NBOARD; i++)
+		if (rc_board[i].base && !rc_probe(&rc_board[i]))
 			found++;
-	
 	if (!found)  {
 		rc_release_drivers();
 		printk(no_boards_msg);
@@ -1702,13 +1667,13 @@ MODULE_LICENSE("GPL");
  * by specifying "iobase=0xXXX iobase1=0xXXX ..." as insmod parameter.
  *
  */
-static int __init riscom8_init_module (void)
+static int __init riscom8_init_module(void)
 {
 #ifdef MODULE
 	int i;
 
 	if (iobase || iobase1 || iobase2 || iobase3) {
-		for(i = 0; i < RC_NBOARD; i++)
+		for (i = 0; i < RC_NBOARD; i++)
 			rc_board[i].base = 0;
 	}
 
@@ -1724,18 +1689,17 @@ static int __init riscom8_init_module (v
 
 	return riscom8_init();
 }
-	
-static void __exit riscom8_exit_module (void)
+
+static void __exit riscom8_exit_module(void)
 {
 	int i;
-	
+
 	rc_release_drivers();
-	for (i = 0; i < RC_NBOARD; i++)  
-		if (rc_board[i].flags & RC_BOARD_PRESENT) 
+	for (i = 0; i < RC_NBOARD; i++)
+		if (rc_board[i].flags & RC_BOARD_PRESENT)
 			rc_release_io_range(&rc_board[i]);
-	
+
 }
 
 module_init(riscom8_init_module);
 module_exit(riscom8_exit_module);
-
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
vt-fix-background-color-on-line-feed.patch
proc-convert-proc-tty-ldiscs-to-seq_file-interface.patch
edac-new-support-for-intel-3100-chipset.patch
edac-add-e752x-parameter-for-sysbus_parity-selection.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
edac-fix-module-initialization-on-several-modules-2nd-time.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
libata-more-tsstcorp-pain-keep-in-sync-with-legacy-ide.patch
pata_atiixp-simplex-clear.patch
pata_via-fix-6410-misdetect.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
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
cyclades-coding-style-review.patch
cyclades-use-ioremap_nocache-for-clarity-as-proposed.patch
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
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework.patch
tty-the-big-operations-rework-broke-wan-x25_asy-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
strip-fix-up-strip-for-the-new-order.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
riscom8-coding-style.patch
epca-coding-style.patch
esp-clean-up-to-modern-coding-style.patch
toshiba-use-ioremap_cached.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch
tty-add-throttle-unthrottle-helpers.patch
ip2-switch-remaining-direct-call-of-ops-flush_buffer.patch
x25_asy-code-cleanup.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
maintainers-sort-ordering.patch
char-serial-switch-drivers-to-ioremap_nocache.patch
isicom-fix-buffer-allocation.patch

