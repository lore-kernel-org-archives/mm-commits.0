From: akpm@linux-foundation.org
Subject: + drivers-serial-sunzilog-interrupt-enable-before-isr-handler.patch added to -mm tree
Date: Wed, 09 May 2007 19:54:49 -0700
Message-ID: <200705100254.l4A2sneJ010545@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754060AbXEJCzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 22:55:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mark@mtfhpc.demon.co.uk


The patch titled
     drivers/serial/sunzilog: Interrupt enable before ISR handler installed
has been added to the -mm tree.  Its filename is
     drivers-serial-sunzilog-interrupt-enable-before-isr-handler.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/serial/sunzilog: Interrupt enable before ISR handler installed
From: Mark Fortescue <mark@mtfhpc.demon.co.uk>

This patch changes the interrupt enable sequence for the sunzilog driver so
that interrupts are not enabled untill after the interrupt handler has been
installed.  If this is not done, some SS1 and SS2 sun4c systems panic on
un-handled interrupt before the handler gets installed preventing boot.

It also adds in support for the ESCC version of the zilog chips.  The changes
mean that the FIFO will be enabled for ESCC versions of the SCC UART.  My
interpretation of the SCC manual and the existing interrupt handler code is
that it sould be able to make good use of the FIFO without issues.

Signed-off-by: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/sunzilog.c |  138 +++++++++++++++++++++++++++---------
 drivers/serial/sunzilog.h |   19 ++++
 2 files changed, 122 insertions(+), 35 deletions(-)

diff -puN drivers/serial/sunzilog.c~drivers-serial-sunzilog-interrupt-enable-before-isr-handler drivers/serial/sunzilog.c
--- a/drivers/serial/sunzilog.c~drivers-serial-sunzilog-interrupt-enable-before-isr-handler
+++ a/drivers/serial/sunzilog.c
@@ -92,6 +92,8 @@ struct uart_sunzilog_port {
 #define SUNZILOG_FLAG_REGS_HELD		0x00000040
 #define SUNZILOG_FLAG_TX_STOPPED	0x00000080
 #define SUNZILOG_FLAG_TX_ACTIVE		0x00000100
+#define SUNZILOG_FLAG_ESCC		0x00000200
+#define SUNZILOG_FLAG_ISR_HANDLER	0x00000400
 
 	unsigned int cflag;
 
@@ -174,9 +176,11 @@ static void sunzilog_clear_fifo(struct z
 /* This function must only be called when the TX is not busy.  The UART
  * port lock must be held and local interrupts disabled.
  */
-static void __load_zsregs(struct zilog_channel __iomem *channel, unsigned char *regs)
+static int __load_zsregs(struct zilog_channel __iomem *channel, unsigned char *regs)
 {
 	int i;
+	int escc;
+	unsigned char r15;
 
 	/* Let pending transmits finish.  */
 	for (i = 0; i < 1000; i++) {
@@ -229,11 +233,25 @@ static void __load_zsregs(struct zilog_c
 	write_zsreg(channel, R14, regs[R14]);
 
 	/* External status interrupt control.  */
-	write_zsreg(channel, R15, regs[R15]);
+	write_zsreg(channel, R15, (regs[R15] | WR7pEN) & ~FIFOEN);
+
+	/* ESCC Extension Register */
+	r15 = read_zsreg(channel, R15);
+	if (r15 & 0x01)	{
+		write_zsreg(channel, R7,  regs[R7p]);
+
+		/* External status interrupt and FIFO control.  */
+		write_zsreg(channel, R15, regs[R15] & ~WR7pEN);
+		escc = 1;
+	} else {
+		 /* Clear FIFO bit case it is an issue */
+		regs[R15] &= ~FIFOEN;
+		escc = 0;
+	}
 
 	/* Reset external status interrupts.  */
-	write_zsreg(channel, R0, RES_EXT_INT);
-	write_zsreg(channel, R0, RES_EXT_INT);
+	write_zsreg(channel, R0, RES_EXT_INT); /* First Latch  */
+	write_zsreg(channel, R0, RES_EXT_INT); /* Second Latch */
 
 	/* Rewrite R3/R5, this time without enables masked.  */
 	write_zsreg(channel, R3, regs[R3]);
@@ -241,6 +259,8 @@ static void __load_zsregs(struct zilog_c
 
 	/* Rewrite R1, this time without IRQ enabled masked.  */
 	write_zsreg(channel, R1, regs[R1]);
+
+	return escc;
 }
 
 /* Reprogram the Zilog channel HW registers with the copies found in the
@@ -731,7 +751,7 @@ static void sunzilog_enable_ms(struct ua
 		up->curregs[R15] = new_reg;
 
 		/* NOTE: Not subject to 'transmitter active' rule.  */ 
-		write_zsreg(channel, R15, up->curregs[R15]);
+		write_zsreg(channel, R15, up->curregs[R15] & ~WR7pEN);
 	}
 }
 
@@ -861,44 +881,44 @@ sunzilog_convert_to_zs(struct uart_sunzi
 	up->curregs[R14] = BRSRC | BRENAB;
 
 	/* Character size, stop bits, and parity. */
-	up->curregs[3] &= ~RxN_MASK;
-	up->curregs[5] &= ~TxN_MASK;
+	up->curregs[R3] &= ~RxN_MASK;
+	up->curregs[R5] &= ~TxN_MASK;
 	switch (cflag & CSIZE) {
 	case CS5:
-		up->curregs[3] |= Rx5;
-		up->curregs[5] |= Tx5;
+		up->curregs[R3] |= Rx5;
+		up->curregs[R5] |= Tx5;
 		up->parity_mask = 0x1f;
 		break;
 	case CS6:
-		up->curregs[3] |= Rx6;
-		up->curregs[5] |= Tx6;
+		up->curregs[R3] |= Rx6;
+		up->curregs[R5] |= Tx6;
 		up->parity_mask = 0x3f;
 		break;
 	case CS7:
-		up->curregs[3] |= Rx7;
-		up->curregs[5] |= Tx7;
+		up->curregs[R3] |= Rx7;
+		up->curregs[R5] |= Tx7;
 		up->parity_mask = 0x7f;
 		break;
 	case CS8:
 	default:
-		up->curregs[3] |= Rx8;
-		up->curregs[5] |= Tx8;
+		up->curregs[R3] |= Rx8;
+		up->curregs[R5] |= Tx8;
 		up->parity_mask = 0xff;
 		break;
 	};
-	up->curregs[4] &= ~0x0c;
+	up->curregs[R4] &= ~0x0c;
 	if (cflag & CSTOPB)
-		up->curregs[4] |= SB2;
+		up->curregs[R4] |= SB2;
 	else
-		up->curregs[4] |= SB1;
+		up->curregs[R4] |= SB1;
 	if (cflag & PARENB)
-		up->curregs[4] |= PAR_ENAB;
+		up->curregs[R4] |= PAR_ENAB;
 	else
-		up->curregs[4] &= ~PAR_ENAB;
+		up->curregs[R4] &= ~PAR_ENAB;
 	if (!(cflag & PARODD))
-		up->curregs[4] |= PAR_EVEN;
+		up->curregs[R4] |= PAR_EVEN;
 	else
-		up->curregs[4] &= ~PAR_EVEN;
+		up->curregs[R4] &= ~PAR_EVEN;
 
 	up->port.read_status_mask = Rx_OVR;
 	if (iflag & INPCK)
@@ -952,7 +972,9 @@ sunzilog_set_termios(struct uart_port *p
 
 static const char *sunzilog_type(struct uart_port *port)
 {
-	return "zs";
+	struct uart_sunzilog_port *up = UART_ZILOG(port);
+
+	return (up->flags & SUNZILOG_FLAG_ESCC) ? "zs (ESCC)" : "zs";
 }
 
 /* We do not request/release mappings of the registers here, this
@@ -1170,7 +1192,7 @@ static int __init sunzilog_console_setup
 
 	spin_lock_irqsave(&up->port.lock, flags);
 
-	up->curregs[R15] = BRKIE;
+	up->curregs[R15] |= BRKIE;
 	sunzilog_convert_to_zs(up, con->cflag, 0, brg);
 
 	sunzilog_set_mctrl(&up->port, TIOCM_DTR | TIOCM_RTS);
@@ -1229,7 +1251,7 @@ static void __init sunzilog_init_kbdms(s
 		baud = 4800;
 	}
 
-	up->curregs[R15] = BRKIE;
+	up->curregs[R15] |= BRKIE;
 	brg = BPS_TO_BRG(baud, ZS_CLOCK / ZS_CLOCK_DIVISOR);
 	sunzilog_convert_to_zs(up, up->cflag, 0, brg);
 	sunzilog_set_mctrl(&up->port, TIOCM_DTR | TIOCM_RTS);
@@ -1283,8 +1305,18 @@ static void __devinit sunzilog_init_hw(s
 
 	if (up->flags & (SUNZILOG_FLAG_CONS_KEYB |
 			 SUNZILOG_FLAG_CONS_MOUSE)) {
+		up->curregs[R1] = EXT_INT_ENAB | INT_ALL_Rx | TxINT_ENAB;
+		up->curregs[R4] = PAR_EVEN | X16CLK | SB1;
+		up->curregs[R3] = RxENAB | Rx8;
+		up->curregs[R5] = TxENAB | Tx8;
+		up->curregs[R6] = 0x00; /* SDLC Address */
+		up->curregs[R7] = 0x7E; /* SDLC Flag    */
+		up->curregs[R9] = NV;
+		up->curregs[R7p] = 0x00;
 		sunzilog_init_kbdms(up, up->port.line);
-		up->curregs[R9] |= (NV | MIE);
+		/* Only enable interrupts if an ISR handler available */
+		if (up->flags & SUNZILOG_FLAG_ISR_HANDLER)
+			up->curregs[R9] |= MIE;
 		write_zsreg(channel, R9, up->curregs[R9]);
 	} else {
 		/* Normal serial TTY. */
@@ -1293,7 +1325,9 @@ static void __devinit sunzilog_init_hw(s
 		up->curregs[R4] = PAR_EVEN | X16CLK | SB1;
 		up->curregs[R3] = RxENAB | Rx8;
 		up->curregs[R5] = TxENAB | Tx8;
-		up->curregs[R9] = NV | MIE;
+		up->curregs[R6] = 0x00; /* SDLC Address */
+		up->curregs[R7] = 0x7E; /* SDLC Flag    */
+		up->curregs[R9] = NV;
 		up->curregs[R10] = NRZ;
 		up->curregs[R11] = TCBR | RCBR;
 		baud = 9600;
@@ -1301,7 +1335,14 @@ static void __devinit sunzilog_init_hw(s
 		up->curregs[R12] = (brg & 0xff);
 		up->curregs[R13] = (brg >> 8) & 0xff;
 		up->curregs[R14] = BRSRC | BRENAB;
-		__load_zsregs(channel, up->curregs);
+		up->curregs[R15] = FIFOEN; /* Use FIFO if on ESCC */
+		up->curregs[R7p] = TxFIFO_LVL | RxFIFO_LVL;
+		if (__load_zsregs(channel, up->curregs)) {
+			up->flags |= SUNZILOG_FLAG_ESCC;
+		}
+		/* Only enable interrupts if an ISR handler available */
+		if (up->flags & SUNZILOG_FLAG_ISR_HANDLER)
+			up->curregs[R9] |= MIE;
 		write_zsreg(channel, R9, up->curregs[R9]);
 	}
 
@@ -1390,12 +1431,14 @@ static int __devinit zs_probe(struct of_
 			return err;
 		}
 	} else {
-		printk(KERN_INFO "%s: Keyboard at MMIO %lx (irq = %d) "
-		       "is a zs\n",
-		       op->dev.bus_id, up[0].port.mapbase, op->irqs[0]);
-		printk(KERN_INFO "%s: Mouse at MMIO %lx (irq = %d) "
-		       "is a zs\n",
-		       op->dev.bus_id, up[1].port.mapbase, op->irqs[0]);
+		printk(KERN_INFO "%s: Keyboard at MMIO 0x%lx (irq = %d) "
+		       "is a %s\n",
+		       op->dev.bus_id, up[0].port.mapbase, op->irqs[0],
+		       sunzilog_type (&up[0].port));
+		printk(KERN_INFO "%s: Mouse at MMIO 0x%lx (irq = %d) "
+		       "is a %s\n",
+		       op->dev.bus_id, up[1].port.mapbase, op->irqs[0],
+		       sunzilog_type (&up[1].port));
 	}
 
 	dev_set_drvdata(&op->dev, &up[0]);
@@ -1487,10 +1530,23 @@ static int __init sunzilog_init(void)
 		goto out_unregister_uart;
 
 	if (zilog_irq != -1) {
+		struct uart_sunzilog_port *up = sunzilog_irq_chain;
 		err = request_irq(zilog_irq, sunzilog_interrupt, IRQF_SHARED,
 				  "zs", sunzilog_irq_chain);
 		if (err)
 			goto out_unregister_driver;
+
+		/* Enable Interrupts */
+		while (up) {
+			struct zilog_channel __iomem *channel;
+
+			/* printk (KERN_INFO "Enable IRQ for ZILOG Hardware %p\n", up); */
+			channel          = ZILOG_CHANNEL_FROM_PORT(&up->port);
+			up->flags       |= SUNZILOG_FLAG_ISR_HANDLER;
+			up->curregs[R9] |= MIE;
+			write_zsreg(channel, R9, up->curregs[R9]);
+			up = up->next;
+		}
 	}
 
 out:
@@ -1515,6 +1571,20 @@ static void __exit sunzilog_exit(void)
 	of_unregister_driver(&zs_driver);
 
 	if (zilog_irq != -1) {
+		struct uart_sunzilog_port *up = sunzilog_irq_chain;
+
+		/* Disable Interrupts */
+		while (up) {
+			struct zilog_channel __iomem *channel;
+
+			/* printk (KERN_INFO "Disable IRQ for ZILOG Hardware %p\n", up); */
+			channel          = ZILOG_CHANNEL_FROM_PORT(&up->port);
+			up->flags       &= ~SUNZILOG_FLAG_ISR_HANDLER;
+			up->curregs[R9] &= ~MIE;
+			write_zsreg(channel, R9, up->curregs[R9]);
+			up = up->next;
+		}
+
 		free_irq(zilog_irq, sunzilog_irq_chain);
 		zilog_irq = -1;
 	}
diff -puN drivers/serial/sunzilog.h~drivers-serial-sunzilog-interrupt-enable-before-isr-handler drivers/serial/sunzilog.h
--- a/drivers/serial/sunzilog.h~drivers-serial-sunzilog-interrupt-enable-before-isr-handler
+++ a/drivers/serial/sunzilog.h
@@ -13,7 +13,8 @@ struct zilog_layout {
 	struct zilog_channel channelA;
 };
 
-#define NUM_ZSREGS    16
+#define	NUM_ZSREGS	17
+#define	R7p		16 /* Written as R7 with P15 bit 0 set */
 
 /* Conversion routines to/from brg time constants from/to bits
  * per second.
@@ -127,6 +128,15 @@ struct zilog_layout {
 
 /* Write Register 7 (Sync bits 8-15/SDLC 01111110) */
 
+/* Write Register 7' (ESCC Only) */
+#define	AUTO_TxFLAG	1	/* Automatic Tx SDLC Flag */
+#define	AUTO_EOM_RST	2	/* Automatic EOM Reset */
+#define	AUTOnRTS	4	/* Automatic /RTS pin deactivation */
+#define	RxFIFO_LVL	8	/* Receive FIFO interrupt level */
+#define	nDTRnREQ	0x10	/* /DTR/REQ timing */
+#define	TxFIFO_LVL	0x20	/* Transmit FIFO interrupt level */
+#define	EXT_RD_EN	0x40	/* Extended read register enable */
+
 /* Write Register 8 (transmit buffer) */
 
 /* Write Register 9 (Master interrupt control) */
@@ -135,6 +145,7 @@ struct zilog_layout {
 #define	DLC	4	/* Disable Lower Chain */
 #define	MIE	8	/* Master Interrupt Enable */
 #define	STATHI	0x10	/* Status high */
+#define	SWIACK  0x20    /* Software Interrupt Ack (not on NMOS) */
 #define	NORESET	0	/* No reset on write to R9 */
 #define	CHRB	0x40	/* Reset channel B */
 #define	CHRA	0x80	/* Reset channel A */
@@ -187,7 +198,9 @@ struct zilog_layout {
 #define	SNRZI	0xe0	/* Set NRZI mode */
 
 /* Write Register 15 (external/status interrupt control) */
+#define	WR7pEN	1	/* WR7' Enable (ESCC only) */
 #define	ZCIE	2	/* Zero count IE */
+#define	FIFOEN	4	/* FIFO Enable (ESCC only) */
 #define	DCDIE	8	/* DCD IE */
 #define	SYNCIE	0x10	/* Sync/hunt IE */
 #define	CTSIE	0x20	/* CTS IE */
@@ -241,6 +254,10 @@ struct zilog_layout {
 #define	CHATxIP	0x10		/* Channel A Tx IP */
 #define	CHARxIP	0x20		/* Channel A Rx IP */
 
+/* Read Register 6 (LSB frame byte count [Not on NMOS]) */
+
+/* Read Register 7 (MSB frame byte count and FIFO status [Not on NMOS]) */
+
 /* Read Register 8 (receive data register) */
 
 /* Read Register 10  (misc status bits) */
_

Patches currently in -mm which might be from mark@mtfhpc.demon.co.uk are

drivers-serial-sunzilog-interrupt-enable-before-isr-handler.patch
