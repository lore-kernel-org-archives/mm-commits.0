From: akpm@linux-foundation.org
Subject: - char-rio-fix-cirrus-defines.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:58 -0700
Message-ID: <200805010929.m419TwkO030724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752296AbYEAJaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:30:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: rio, fix cirrus defines
has been removed from the -mm tree.  Its filename was
     char-rio-fix-cirrus-defines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: rio, fix cirrus defines
From: Jiri Slaby <jirislaby@gmail.com>

Rename defines to be in RIO* namespace to not to collide with other defines in
tree.  This broke (as akpm correctly pointed out) some allmodconfig builds,
e.g.  on ppc:

In file included from drivers/char/rio/rio_linux.c:81:
drivers/char/rio/cirrus.h:202:1: warning: "COMPLETE" redefined
In file included from include/net/netns/ipv4.h:8,
                 from include/net/net_namespace.h:13,
                 from include/linux/seq_file.h:7,
                 from include/asm/machdep.h:12,
                 from include/asm/pci.h:17,
                 from include/linux/pci.h:951,
                 from drivers/char/rio/rio_linux.c:50:
include/net/inet_frag.h:28:1: warning: this is the location of the previous definition

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rio/cirrus.h    |  202 ++++++++++++++++-----------------
 drivers/char/rio/rio_linux.c |   10 -
 drivers/char/rio/riocmd.c    |   19 +--
 drivers/char/rio/rioctrl.c   |   37 +++---
 drivers/char/rio/riointr.c   |    5 
 drivers/char/rio/rioparam.c  |   70 +++++------
 drivers/char/rio/riotty.c    |   25 ++--
 7 files changed, 187 insertions(+), 181 deletions(-)

diff -puN drivers/char/rio/cirrus.h~char-rio-fix-cirrus-defines drivers/char/rio/cirrus.h
--- a/drivers/char/rio/cirrus.h~char-rio-fix-cirrus-defines
+++ a/drivers/char/rio/cirrus.h
@@ -43,83 +43,83 @@
 /* Bit fields for particular registers shared with driver */
 
 /* COR1 - driver and RTA */
-#define	COR1_ODD	0x80	/* Odd parity */
-#define COR1_EVEN	0x00	/* Even parity */
-#define	COR1_NOP	0x00	/* No parity */
-#define	COR1_FORCE	0x20	/* Force parity */
-#define	COR1_NORMAL	0x40	/* With parity */
-#define	COR1_1STOP	0x00	/* 1 stop bit */
-#define	COR1_15STOP	0x04	/* 1.5 stop bits */
-#define	COR1_2STOP	0x08	/* 2 stop bits */
-#define	COR1_5BITS	0x00	/* 5 data bits */
-#define	COR1_6BITS	0x01	/* 6 data bits */
-#define	COR1_7BITS	0x02	/* 7 data bits */
-#define	COR1_8BITS	0x03	/* 8 data bits */
+#define RIOC_COR1_ODD		0x80	/* Odd parity */
+#define RIOC_COR1_EVEN		0x00	/* Even parity */
+#define RIOC_COR1_NOP		0x00	/* No parity */
+#define RIOC_COR1_FORCE		0x20	/* Force parity */
+#define RIOC_COR1_NORMAL	0x40	/* With parity */
+#define RIOC_COR1_1STOP		0x00	/* 1 stop bit */
+#define RIOC_COR1_15STOP	0x04	/* 1.5 stop bits */
+#define RIOC_COR1_2STOP		0x08	/* 2 stop bits */
+#define RIOC_COR1_5BITS		0x00	/* 5 data bits */
+#define RIOC_COR1_6BITS		0x01	/* 6 data bits */
+#define RIOC_COR1_7BITS		0x02	/* 7 data bits */
+#define RIOC_COR1_8BITS		0x03	/* 8 data bits */
 
-#define COR1_HOST       0xef	/* Safe host bits */
+#define RIOC_COR1_HOST		0xef	/* Safe host bits */
 
 /* RTA only */
-#define COR1_CINPCK     0x00	/* Check parity of received characters */
-#define COR1_CNINPCK    0x10	/* Don't check parity */
+#define RIOC_COR1_CINPCK	0x00	/* Check parity of received characters */
+#define RIOC_COR1_CNINPCK	0x10	/* Don't check parity */
 
 /* COR2 bits for both RTA and driver use */
-#define	COR2_IXANY	0x80	/* IXANY - any character is XON */
-#define	COR2_IXON	0x40	/* IXON - enable tx soft flowcontrol */
-#define	COR2_RTSFLOW	0x02	/* Enable tx hardware flow control */
+#define RIOC_COR2_IXANY		0x80	/* IXANY - any character is XON */
+#define RIOC_COR2_IXON		0x40	/* IXON - enable tx soft flowcontrol */
+#define RIOC_COR2_RTSFLOW	0x02	/* Enable tx hardware flow control */
 
 /* Additional driver bits */
-#define	COR2_HUPCL	0x20	/* Hang up on close */
-#define	COR2_CTSFLOW	0x04	/* Enable rx hardware flow control */
-#define	COR2_IXOFF	0x01	/* Enable rx software flow control */
-#define COR2_DTRFLOW	0x08	/* Enable tx hardware flow control */
+#define RIOC_COR2_HUPCL		0x20	/* Hang up on close */
+#define RIOC_COR2_CTSFLOW	0x04	/* Enable rx hardware flow control */
+#define RIOC_COR2_IXOFF		0x01	/* Enable rx software flow control */
+#define RIOC_COR2_DTRFLOW	0x08	/* Enable tx hardware flow control */
 
 /* RTA use only */
-#define COR2_ETC	0x20	/* Embedded transmit options */
-#define	COR2_LOCAL	0x10	/* Local loopback mode */
-#define	COR2_REMOTE	0x08	/* Remote loopback mode */
-#define	COR2_HOST	0xc2	/* Safe host bits */
+#define RIOC_COR2_ETC		0x20	/* Embedded transmit options */
+#define RIOC_COR2_LOCAL		0x10	/* Local loopback mode */
+#define RIOC_COR2_REMOTE	0x08	/* Remote loopback mode */
+#define RIOC_COR2_HOST		0xc2	/* Safe host bits */
 
 /* COR3 - RTA use only */
-#define	COR3_SCDRNG	0x80	/* Enable special char detect for range */
-#define	COR3_SCD34	0x40	/* Special character detect for SCHR's 3 + 4 */
-#define	COR3_FCT	0x20	/* Flow control transparency */
-#define	COR3_SCD12	0x10	/* Special character detect for SCHR's 1 + 2 */
-#define	COR3_FIFO12	0x0c	/* 12 chars for receive FIFO threshold */
-#define COR3_FIFO10     0x0a	/* 10 chars for receive FIFO threshold */
-#define COR3_FIFO8      0x08	/* 8 chars for receive FIFO threshold */
-#define COR3_FIFO6      0x06	/* 6 chars for receive FIFO threshold */
+#define RIOC_COR3_SCDRNG	0x80	/* Enable special char detect for range */
+#define RIOC_COR3_SCD34		0x40	/* Special character detect for SCHR's 3 + 4 */
+#define RIOC_COR3_FCT		0x20	/* Flow control transparency */
+#define RIOC_COR3_SCD12		0x10	/* Special character detect for SCHR's 1 + 2 */
+#define RIOC_COR3_FIFO12	0x0c	/* 12 chars for receive FIFO threshold */
+#define RIOC_COR3_FIFO10	0x0a	/* 10 chars for receive FIFO threshold */
+#define RIOC_COR3_FIFO8		0x08	/* 8 chars for receive FIFO threshold */
+#define RIOC_COR3_FIFO6		0x06	/* 6 chars for receive FIFO threshold */
 
-#define COR3_THRESHOLD  COR3_FIFO8	/* MUST BE LESS THAN MCOR_THRESHOLD */
+#define RIOC_COR3_THRESHOLD	RIOC_COR3_FIFO8	/* MUST BE LESS THAN MCOR_THRESHOLD */
 
-#define	COR3_DEFAULT	(COR3_FCT | COR3_THRESHOLD)
+#define RIOC_COR3_DEFAULT	(RIOC_COR3_FCT | RIOC_COR3_THRESHOLD)
 				/* Default bits for COR3 */
 
 /* COR4 driver and RTA use */
-#define	COR4_IGNCR	0x80	/* Throw away CR's on input */
-#define	COR4_ICRNL	0x40	/* Map CR -> NL on input */
-#define	COR4_INLCR	0x20	/* Map NL -> CR on input */
-#define	COR4_IGNBRK	0x10	/* Ignore Break */
-#define	COR4_NBRKINT	0x08	/* No interrupt on break (-BRKINT) */
-#define COR4_RAISEMOD	0x01	/* Raise modem output lines on non-zero baud */
+#define RIOC_COR4_IGNCR		0x80	/* Throw away CR's on input */
+#define RIOC_COR4_ICRNL		0x40	/* Map CR -> NL on input */
+#define RIOC_COR4_INLCR		0x20	/* Map NL -> CR on input */
+#define RIOC_COR4_IGNBRK	0x10	/* Ignore Break */
+#define RIOC_COR4_NBRKINT	0x08	/* No interrupt on break (-BRKINT) */
+#define RIOC_COR4_RAISEMOD	0x01	/* Raise modem output lines on non-zero baud */
 
 
 /* COR4 driver only */
-#define COR4_IGNPAR	0x04	/* IGNPAR (ignore characters with errors) */
-#define COR4_PARMRK	0x02	/* PARMRK */
+#define RIOC_COR4_IGNPAR	0x04	/* IGNPAR (ignore characters with errors) */
+#define RIOC_COR4_PARMRK	0x02	/* PARMRK */
 
-#define COR4_HOST	0xf8	/* Safe host bits */
+#define RIOC_COR4_HOST		0xf8	/* Safe host bits */
 
 /* COR4 RTA only */
-#define COR4_CIGNPAR	0x02	/* Thrown away bad characters */
-#define COR4_CPARMRK	0x04	/* PARMRK characters */
-#define COR4_CNPARMRK	0x03	/* Don't PARMRK */
+#define RIOC_COR4_CIGNPAR	0x02	/* Thrown away bad characters */
+#define RIOC_COR4_CPARMRK	0x04	/* PARMRK characters */
+#define RIOC_COR4_CNPARMRK	0x03	/* Don't PARMRK */
 
 /* COR5 driver and RTA use */
-#define	COR5_ISTRIP	0x80	/* Strip input chars to 7 bits */
-#define	COR5_LNE	0x40	/* Enable LNEXT processing */
-#define	COR5_CMOE	0x20	/* Match good and errored characters */
-#define	COR5_ONLCR	0x02	/* NL -> CR NL on output */
-#define	COR5_OCRNL	0x01	/* CR -> NL on output */
+#define RIOC_COR5_ISTRIP	0x80	/* Strip input chars to 7 bits */
+#define RIOC_COR5_LNE		0x40	/* Enable LNEXT processing */
+#define RIOC_COR5_CMOE		0x20	/* Match good and errored characters */
+#define RIOC_COR5_ONLCR		0x02	/* NL -> CR NL on output */
+#define RIOC_COR5_OCRNL		0x01	/* CR -> NL on output */
 
 /*
 ** Spare bits - these are not used in the CIRRUS registers, so we use
@@ -128,86 +128,86 @@
 /*
 ** tstop and tbusy indication
 */
-#define	COR5_TSTATE_ON	0x08	/* Turn on monitoring of tbusy and tstop */
-#define	COR5_TSTATE_OFF	0x04	/* Turn off monitoring of tbusy and tstop */
+#define RIOC_COR5_TSTATE_ON	0x08	/* Turn on monitoring of tbusy and tstop */
+#define RIOC_COR5_TSTATE_OFF	0x04	/* Turn off monitoring of tbusy and tstop */
 /*
 ** TAB3
 */
-#define	COR5_TAB3	0x10	/* TAB3 mode */
+#define RIOC_COR5_TAB3		0x10	/* TAB3 mode */
 
-#define	COR5_HOST	0xc3	/* Safe host bits */
+#define RIOC_COR5_HOST		0xc3	/* Safe host bits */
 
 /* CCSR */
-#define	CCSR_TXFLOFF	0x04	/* Tx is xoffed */
+#define RIOC_CCSR_TXFLOFF	0x04	/* Tx is xoffed */
 
 /* MSVR1 */
 /* NB. DTR / CD swapped from Cirrus spec as the pins are also reversed on the
    RTA. This is because otherwise DCD would get lost on the 1 parallel / 3
    serial option.
 */
-#define	MSVR1_CD	0x80	/* CD (DSR on Cirrus) */
-#define	MSVR1_RTS	0x40	/* RTS (CTS on Cirrus) */
-#define	MSVR1_RI	0x20	/* RI */
-#define	MSVR1_DTR	0x10	/* DTR (CD on Cirrus) */
-#define	MSVR1_CTS	0x01	/* CTS output pin (RTS on Cirrus) */
+#define RIOC_MSVR1_CD		0x80	/* CD (DSR on Cirrus) */
+#define RIOC_MSVR1_RTS		0x40	/* RTS (CTS on Cirrus) */
+#define RIOC_MSVR1_RI		0x20	/* RI */
+#define RIOC_MSVR1_DTR		0x10	/* DTR (CD on Cirrus) */
+#define RIOC_MSVR1_CTS		0x01	/* CTS output pin (RTS on Cirrus) */
 /* Next two used to indicate state of tbusy and tstop to driver */
-#define	MSVR1_TSTOP	0x08	/* Set if port flow controlled */
-#define	MSVR1_TEMPTY	0x04	/* Set if port tx buffer empty */
+#define RIOC_MSVR1_TSTOP	0x08	/* Set if port flow controlled */
+#define RIOC_MSVR1_TEMPTY	0x04	/* Set if port tx buffer empty */
 
-#define	MSVR1_HOST	0xf3	/* The bits the host wants */
+#define RIOC_MSVR1_HOST		0xf3	/* The bits the host wants */
 
 /* Defines for the subscripts of a CONFIG packet */
-#define	CONFIG_COR1	1	/* Option register 1 */
-#define	CONFIG_COR2	2	/* Option register 2 */
-#define	CONFIG_COR4	3	/* Option register 4 */
-#define	CONFIG_COR5	4	/* Option register 5 */
-#define	CONFIG_TXXON	5	/* Tx XON character */
-#define	CONFIG_TXXOFF	6	/* Tx XOFF character */
-#define	CONFIG_RXXON	7	/* Rx XON character */
-#define	CONFIG_RXXOFF	8	/* Rx XOFF character */
-#define CONFIG_LNEXT	9	/* LNEXT character */
-#define	CONFIG_TXBAUD	10	/* Tx baud rate */
-#define	CONFIG_RXBAUD	11	/* Rx baud rate */
+#define RIOC_CONFIG_COR1	1	/* Option register 1 */
+#define RIOC_CONFIG_COR2	2	/* Option register 2 */
+#define RIOC_CONFIG_COR4	3	/* Option register 4 */
+#define RIOC_CONFIG_COR5	4	/* Option register 5 */
+#define RIOC_CONFIG_TXXON	5	/* Tx XON character */
+#define RIOC_CONFIG_TXXOFF	6	/* Tx XOFF character */
+#define RIOC_CONFIG_RXXON	7	/* Rx XON character */
+#define RIOC_CONFIG_RXXOFF	8	/* Rx XOFF character */
+#define RIOC_CONFIG_LNEXT	9	/* LNEXT character */
+#define RIOC_CONFIG_TXBAUD	10	/* Tx baud rate */
+#define RIOC_CONFIG_RXBAUD	11	/* Rx baud rate */
 
-#define	PRE_EMPTIVE	0x80	/* Pre-emptive bit in command field */
+#define RIOC_PRE_EMPTIVE	0x80	/* Pre-emptive bit in command field */
 
 /* Packet types going from Host to remote - with the exception of OPEN, MOPEN,
    CONFIG, SBREAK and MEMDUMP the remaining bytes of the data array will not
    be used 
 */
-#define	OPEN		0x00	/* Open a port */
-#define CONFIG		0x01	/* Configure a port */
-#define	MOPEN		0x02	/* Modem open (block for DCD) */
-#define	CLOSE		0x03	/* Close a port */
-#define	WFLUSH		(0x04 | PRE_EMPTIVE)	/* Write flush */
-#define	RFLUSH		(0x05 | PRE_EMPTIVE)	/* Read flush */
-#define	RESUME		(0x06 | PRE_EMPTIVE)	/* Resume if xoffed */
-#define	SBREAK		0x07	/* Start break */
-#define	EBREAK		0x08	/* End break */
-#define	SUSPEND		(0x09 | PRE_EMPTIVE)	/* Susp op (behave as tho xoffed) */
-#define FCLOSE          (0x0a | PRE_EMPTIVE)	/* Force close */
-#define XPRINT          0x0b	/* Xprint packet */
-#define MBIS		(0x0c | PRE_EMPTIVE)	/* Set modem lines */
-#define MBIC		(0x0d | PRE_EMPTIVE)	/* Clear modem lines */
-#define MSET		(0x0e | PRE_EMPTIVE)	/* Set modem lines */
-#define PCLOSE		0x0f	/* Pseudo close - Leaves rx/tx enabled */
-#define MGET		(0x10 | PRE_EMPTIVE)	/* Force update of modem status */
-#define MEMDUMP		(0x11 | PRE_EMPTIVE)	/* Send back mem from addr supplied */
-#define	READ_REGISTER	(0x12 | PRE_EMPTIVE)	/* Read CD1400 register (debug) */
+#define RIOC_OPEN		0x00	/* Open a port */
+#define RIOC_CONFIG		0x01	/* Configure a port */
+#define RIOC_MOPEN		0x02	/* Modem open (block for DCD) */
+#define RIOC_CLOSE		0x03	/* Close a port */
+#define RIOC_WFLUSH		(0x04 | RIOC_PRE_EMPTIVE)	/* Write flush */
+#define RIOC_RFLUSH		(0x05 | RIOC_PRE_EMPTIVE)	/* Read flush */
+#define RIOC_RESUME		(0x06 | RIOC_PRE_EMPTIVE)	/* Resume if xoffed */
+#define RIOC_SBREAK		0x07	/* Start break */
+#define RIOC_EBREAK		0x08	/* End break */
+#define RIOC_SUSPEND		(0x09 | RIOC_PRE_EMPTIVE)	/* Susp op (behave as tho xoffed) */
+#define RIOC_FCLOSE		(0x0a | RIOC_PRE_EMPTIVE)	/* Force close */
+#define RIOC_XPRINT		0x0b	/* Xprint packet */
+#define RIOC_MBIS		(0x0c | RIOC_PRE_EMPTIVE)	/* Set modem lines */
+#define RIOC_MBIC		(0x0d | RIOC_PRE_EMPTIVE)	/* Clear modem lines */
+#define RIOC_MSET		(0x0e | RIOC_PRE_EMPTIVE)	/* Set modem lines */
+#define RIOC_PCLOSE		0x0f	/* Pseudo close - Leaves rx/tx enabled */
+#define RIOC_MGET		(0x10 | RIOC_PRE_EMPTIVE)	/* Force update of modem status */
+#define RIOC_MEMDUMP		(0x11 | RIOC_PRE_EMPTIVE)	/* Send back mem from addr supplied */
+#define RIOC_READ_REGISTER	(0x12 | RIOC_PRE_EMPTIVE)	/* Read CD1400 register (debug) */
 
 /* "Command" packets going from remote to host COMPLETE and MODEM_STATUS
    use data[4] / data[3] to indicate current state and modem status respectively
 */
 
-#define	COMPLETE	(0x20 | PRE_EMPTIVE)
+#define RIOC_COMPLETE		(0x20 | RIOC_PRE_EMPTIVE)
 				/* Command complete */
-#define BREAK_RECEIVED	(0x21 | PRE_EMPTIVE)
+#define RIOC_BREAK_RECEIVED	(0x21 | RIOC_PRE_EMPTIVE)
 				/* Break received */
-#define MODEM_STATUS	(0x22 | PRE_EMPTIVE)
+#define RIOC_MODEM_STATUS	(0x22 | RIOC_PRE_EMPTIVE)
 				/* Change in modem status */
 
 /* "Command" packet that could go either way - handshake wake-up */
-#define HANDSHAKE	(0x23 | PRE_EMPTIVE)
+#define RIOC_HANDSHAKE		(0x23 | RIOC_PRE_EMPTIVE)
 				/* Wake-up to HOST / RTA */
 
 #endif
diff -puN drivers/char/rio/rio_linux.c~char-rio-fix-cirrus-defines drivers/char/rio/rio_linux.c
--- a/drivers/char/rio/rio_linux.c~char-rio-fix-cirrus-defines
+++ a/drivers/char/rio/rio_linux.c
@@ -344,7 +344,7 @@ int rio_minor(struct tty_struct *tty)
 
 static int rio_set_real_termios(void *ptr)
 {
-	return RIOParam((struct Port *) ptr, CONFIG, 1, 1);
+	return RIOParam((struct Port *) ptr, RIOC_CONFIG, 1, 1);
 }
 
 
@@ -487,7 +487,7 @@ static int rio_get_CD(void *ptr)
 	int rv;
 
 	func_enter();
-	rv = (PortP->ModemState & MSVR1_CD) != 0;
+	rv = (PortP->ModemState & RIOC_MSVR1_CD) != 0;
 
 	rio_dprintk(RIO_DEBUG_INIT, "Getting CD status: %d\n", rv);
 
@@ -607,7 +607,8 @@ static int rio_ioctl(struct tty_struct *
 			rio_dprintk(RIO_DEBUG_TTY, "BREAK on deleted RTA\n");
 			rc = -EIO;
 		} else {
-			if (RIOShortCommand(p, PortP, SBREAK, 2, 250) == RIO_FAIL) {
+			if (RIOShortCommand(p, PortP, RIOC_SBREAK, 2, 250) ==
+					RIO_FAIL) {
 				rio_dprintk(RIO_DEBUG_INTR, "SBREAK RIOShortCommand failed\n");
 				rc = -EIO;
 			}
@@ -622,7 +623,8 @@ static int rio_ioctl(struct tty_struct *
 			l = arg ? arg * 100 : 250;
 			if (l > 255)
 				l = 255;
-			if (RIOShortCommand(p, PortP, SBREAK, 2, arg ? arg * 100 : 250) == RIO_FAIL) {
+			if (RIOShortCommand(p, PortP, RIOC_SBREAK, 2,
+					arg ? arg * 100 : 250) == RIO_FAIL) {
 				rio_dprintk(RIO_DEBUG_INTR, "SBREAK RIOShortCommand failed\n");
 				rc = -EIO;
 			}
diff -puN drivers/char/rio/riocmd.c~char-rio-fix-cirrus-defines drivers/char/rio/riocmd.c
--- a/drivers/char/rio/riocmd.c~char-rio-fix-cirrus-defines
+++ a/drivers/char/rio/riocmd.c
@@ -417,7 +417,7 @@ static int RIOCommandRup(struct rio_info
 	PortP = p->RIOPortp[SysPort];
 	rio_spin_lock_irqsave(&PortP->portSem, flags);
 	switch (readb(&PktCmdP->Command)) {
-	case BREAK_RECEIVED:
+	case RIOC_BREAK_RECEIVED:
 		rio_dprintk(RIO_DEBUG_CMD, "Received a break!\n");
 		/* If the current line disc. is not multi-threading and
 		   the current processor is not the default, reset rup_intr
@@ -428,16 +428,16 @@ static int RIOCommandRup(struct rio_info
 		gs_got_break(&PortP->gs);
 		break;
 
-	case COMPLETE:
+	case RIOC_COMPLETE:
 		rio_dprintk(RIO_DEBUG_CMD, "Command complete on phb %d host %Zd\n", readb(&PktCmdP->PhbNum), HostP - p->RIOHosts);
 		subCommand = 1;
 		switch (readb(&PktCmdP->SubCommand)) {
-		case MEMDUMP:
+		case RIOC_MEMDUMP:
 			rio_dprintk(RIO_DEBUG_CMD, "Memory dump cmd (0x%x) from addr 0x%x\n", readb(&PktCmdP->SubCommand), readw(&PktCmdP->SubAddr));
 			break;
-		case READ_REGISTER:
+		case RIOC_READ_REGISTER:
 			rio_dprintk(RIO_DEBUG_CMD, "Read register (0x%x)\n", readw(&PktCmdP->SubAddr));
-			p->CdRegister = (readb(&PktCmdP->ModemStatus) & MSVR1_HOST);
+			p->CdRegister = (readb(&PktCmdP->ModemStatus) & RIOC_MSVR1_HOST);
 			break;
 		default:
 			subCommand = 0;
@@ -456,14 +456,15 @@ static int RIOCommandRup(struct rio_info
 			rio_dprintk(RIO_DEBUG_CMD, "No change\n");
 
 		/* FALLTHROUGH */
-	case MODEM_STATUS:
+	case RIOC_MODEM_STATUS:
 		/*
 		 ** Knock out the tbusy and tstop bits, as these are not relevant
 		 ** to the check for modem status change (they're just there because
 		 ** it's a convenient place to put them!).
 		 */
 		ReportedModemStatus = readb(&PktCmdP->ModemStatus);
-		if ((PortP->ModemState & MSVR1_HOST) == (ReportedModemStatus & MSVR1_HOST)) {
+		if ((PortP->ModemState & RIOC_MSVR1_HOST) ==
+				(ReportedModemStatus & RIOC_MSVR1_HOST)) {
 			rio_dprintk(RIO_DEBUG_CMD, "Modem status unchanged 0x%x\n", PortP->ModemState);
 			/*
 			 ** Update ModemState just in case tbusy or tstop states have
@@ -497,7 +498,7 @@ static int RIOCommandRup(struct rio_info
 					/*
 					 ** Is there a carrier?
 					 */
-					if (PortP->ModemState & MSVR1_CD) {
+					if (PortP->ModemState & RIOC_MSVR1_CD) {
 						/*
 						 ** Has carrier just appeared?
 						 */
@@ -691,7 +692,7 @@ void RIOPollHostCommands(struct rio_info
 				 */
 				rio_spin_unlock_irqrestore(&UnixRupP->RupLock, flags);
 				FreeMe = RIOCommandRup(p, Rup, HostP, PacketP);
-				if (readb(&PacketP->data[5]) == MEMDUMP) {
+				if (readb(&PacketP->data[5]) == RIOC_MEMDUMP) {
 					rio_dprintk(RIO_DEBUG_CMD, "Memdump from 0x%x complete\n", readw(&(PacketP->data[6])));
 					rio_memcpy_fromio(p->RIOMemDump, &(PacketP->data[8]), 32);
 				}
diff -puN drivers/char/rio/rioctrl.c~char-rio-fix-cirrus-defines drivers/char/rio/rioctrl.c
--- a/drivers/char/rio/rioctrl.c~char-rio-fix-cirrus-defines
+++ a/drivers/char/rio/rioctrl.c
@@ -422,7 +422,8 @@ int riocontrol(struct rio_info *p, dev_t
 		}
 
 		rio_spin_lock_irqsave(&PortP->portSem, flags);
-		if (RIOPreemptiveCmd(p, (p->RIOPortp[port]), RESUME) == RIO_FAIL) {
+		if (RIOPreemptiveCmd(p, (p->RIOPortp[port]), RIOC_RESUME) ==
+				RIO_FAIL) {
 			rio_dprintk(RIO_DEBUG_CTRL, "RIO_RESUME failed\n");
 			rio_spin_unlock_irqrestore(&PortP->portSem, flags);
 			return -EBUSY;
@@ -636,7 +637,8 @@ int riocontrol(struct rio_info *p, dev_t
 			return -ENXIO;
 		}
 		PortP = (p->RIOPortp[PortTty.port]);
-		RIOParam(PortP, CONFIG, PortP->State & RIO_MODEM, OK_TO_SLEEP);
+		RIOParam(PortP, RIOC_CONFIG, PortP->State & RIO_MODEM,
+				OK_TO_SLEEP);
 		return retval;
 
 	case RIO_SET_PORT_PARAMS:
@@ -1247,7 +1249,7 @@ int riocontrol(struct rio_info *p, dev_t
 
 		rio_spin_lock_irqsave(&PortP->portSem, flags);
 
-		if (RIOPreemptiveCmd(p, PortP, MEMDUMP) == RIO_FAIL) {
+		if (RIOPreemptiveCmd(p, PortP, RIOC_MEMDUMP) == RIO_FAIL) {
 			rio_dprintk(RIO_DEBUG_CTRL, "RIO_MEM_DUMP failed\n");
 			rio_spin_unlock_irqrestore(&PortP->portSem, flags);
 			return -EBUSY;
@@ -1313,7 +1315,8 @@ int riocontrol(struct rio_info *p, dev_t
 
 		rio_spin_lock_irqsave(&PortP->portSem, flags);
 
-		if (RIOPreemptiveCmd(p, PortP, READ_REGISTER) == RIO_FAIL) {
+		if (RIOPreemptiveCmd(p, PortP, RIOC_READ_REGISTER) ==
+				RIO_FAIL) {
 			rio_dprintk(RIO_DEBUG_CTRL, "RIO_READ_REGISTER failed\n");
 			rio_spin_unlock_irqrestore(&PortP->portSem, flags);
 			return -EBUSY;
@@ -1434,50 +1437,50 @@ int RIOPreemptiveCmd(struct rio_info *p,
 	PktCmdP->PhbNum = port;
 
 	switch (Cmd) {
-	case MEMDUMP:
+	case RIOC_MEMDUMP:
 		rio_dprintk(RIO_DEBUG_CTRL, "Queue MEMDUMP command blk %p "
 				"(addr 0x%x)\n", CmdBlkP, (int) SubCmd.Addr);
-		PktCmdP->SubCommand = MEMDUMP;
+		PktCmdP->SubCommand = RIOC_MEMDUMP;
 		PktCmdP->SubAddr = SubCmd.Addr;
 		break;
-	case FCLOSE:
+	case RIOC_FCLOSE:
 		rio_dprintk(RIO_DEBUG_CTRL, "Queue FCLOSE command blk %p\n",
 				CmdBlkP);
 		break;
-	case READ_REGISTER:
+	case RIOC_READ_REGISTER:
 		rio_dprintk(RIO_DEBUG_CTRL, "Queue READ_REGISTER (0x%x) "
 				"command blk %p\n", (int) SubCmd.Addr, CmdBlkP);
-		PktCmdP->SubCommand = READ_REGISTER;
+		PktCmdP->SubCommand = RIOC_READ_REGISTER;
 		PktCmdP->SubAddr = SubCmd.Addr;
 		break;
-	case RESUME:
+	case RIOC_RESUME:
 		rio_dprintk(RIO_DEBUG_CTRL, "Queue RESUME command blk %p\n",
 				CmdBlkP);
 		break;
-	case RFLUSH:
+	case RIOC_RFLUSH:
 		rio_dprintk(RIO_DEBUG_CTRL, "Queue RFLUSH command blk %p\n",
 				CmdBlkP);
 		CmdBlkP->PostFuncP = RIORFlushEnable;
 		break;
-	case SUSPEND:
+	case RIOC_SUSPEND:
 		rio_dprintk(RIO_DEBUG_CTRL, "Queue SUSPEND command blk %p\n",
 				CmdBlkP);
 		break;
 
-	case MGET:
+	case RIOC_MGET:
 		rio_dprintk(RIO_DEBUG_CTRL, "Queue MGET command blk %p\n",
 				CmdBlkP);
 		break;
 
-	case MSET:
-	case MBIC:
-	case MBIS:
+	case RIOC_MSET:
+	case RIOC_MBIC:
+	case RIOC_MBIS:
 		CmdBlkP->Packet.data[4] = (char) PortP->ModemLines;
 		rio_dprintk(RIO_DEBUG_CTRL, "Queue MSET/MBIC/MBIS command "
 				"blk %p\n", CmdBlkP);
 		break;
 
-	case WFLUSH:
+	case RIOC_WFLUSH:
 		/*
 		 ** If we have queued up the maximum number of Write flushes
 		 ** allowed then we should not bother sending any more to the
diff -puN drivers/char/rio/riointr.c~char-rio-fix-cirrus-defines drivers/char/rio/riointr.c
--- a/drivers/char/rio/riointr.c~char-rio-fix-cirrus-defines
+++ a/drivers/char/rio/riointr.c
@@ -401,9 +401,8 @@ void RIOServiceHost(struct rio_info *p, 
 					PortP->InUse = NOT_INUSE;
 
 					rio_spin_unlock(&PortP->portSem);
-					if (RIOParam(PortP, OPEN, ((PortP->Cor2Copy & (COR2_RTSFLOW | COR2_CTSFLOW)) == (COR2_RTSFLOW | COR2_CTSFLOW)) ? 1 : 0, DONT_SLEEP) == RIO_FAIL) {
+					if (RIOParam(PortP, RIOC_OPEN, ((PortP->Cor2Copy & (RIOC_COR2_RTSFLOW | RIOC_COR2_CTSFLOW)) == (RIOC_COR2_RTSFLOW | RIOC_COR2_CTSFLOW)) ? 1 : 0, DONT_SLEEP) == RIO_FAIL)
 						continue;	/* with next port */
-					}
 					rio_spin_lock(&PortP->portSem);
 					PortP->MagicFlags &= ~MAGIC_REBOOT;
 				}
@@ -429,7 +428,7 @@ void RIOServiceHost(struct rio_info *p, 
 					 */
 					PktCmdP = (struct PktCmd __iomem *) &PacketP->data[0];
 
-					writeb(WFLUSH, &PktCmdP->Command);
+					writeb(RIOC_WFLUSH, &PktCmdP->Command);
 
 					p = PortP->HostPort % (u16) PORTS_PER_RTA;
 
diff -puN drivers/char/rio/rioparam.c~char-rio-fix-cirrus-defines drivers/char/rio/rioparam.c
--- a/drivers/char/rio/rioparam.c~char-rio-fix-cirrus-defines
+++ a/drivers/char/rio/rioparam.c
@@ -177,7 +177,7 @@ int RIOParam(struct Port *PortP, int cmd
 	}
 	rio_spin_lock_irqsave(&PortP->portSem, flags);
 
-	if (cmd == OPEN) {
+	if (cmd == RIOC_OPEN) {
 		/*
 		 ** If the port is set to store or lock the parameters, and it is
 		 ** paramed with OPEN, we want to restore the saved port termio, but
@@ -241,50 +241,50 @@ int RIOParam(struct Port *PortP, int cmd
 	case CS5:
 		{
 			rio_dprintk(RIO_DEBUG_PARAM, "5 bit data\n");
-			Cor1 |= COR1_5BITS;
+			Cor1 |= RIOC_COR1_5BITS;
 			break;
 		}
 	case CS6:
 		{
 			rio_dprintk(RIO_DEBUG_PARAM, "6 bit data\n");
-			Cor1 |= COR1_6BITS;
+			Cor1 |= RIOC_COR1_6BITS;
 			break;
 		}
 	case CS7:
 		{
 			rio_dprintk(RIO_DEBUG_PARAM, "7 bit data\n");
-			Cor1 |= COR1_7BITS;
+			Cor1 |= RIOC_COR1_7BITS;
 			break;
 		}
 	case CS8:
 		{
 			rio_dprintk(RIO_DEBUG_PARAM, "8 bit data\n");
-			Cor1 |= COR1_8BITS;
+			Cor1 |= RIOC_COR1_8BITS;
 			break;
 		}
 	}
 
 	if (TtyP->termios->c_cflag & CSTOPB) {
 		rio_dprintk(RIO_DEBUG_PARAM, "2 stop bits\n");
-		Cor1 |= COR1_2STOP;
+		Cor1 |= RIOC_COR1_2STOP;
 	} else {
 		rio_dprintk(RIO_DEBUG_PARAM, "1 stop bit\n");
-		Cor1 |= COR1_1STOP;
+		Cor1 |= RIOC_COR1_1STOP;
 	}
 
 	if (TtyP->termios->c_cflag & PARENB) {
 		rio_dprintk(RIO_DEBUG_PARAM, "Enable parity\n");
-		Cor1 |= COR1_NORMAL;
+		Cor1 |= RIOC_COR1_NORMAL;
 	} else {
 		rio_dprintk(RIO_DEBUG_PARAM, "Disable parity\n");
-		Cor1 |= COR1_NOP;
+		Cor1 |= RIOC_COR1_NOP;
 	}
 	if (TtyP->termios->c_cflag & PARODD) {
 		rio_dprintk(RIO_DEBUG_PARAM, "Odd parity\n");
-		Cor1 |= COR1_ODD;
+		Cor1 |= RIOC_COR1_ODD;
 	} else {
 		rio_dprintk(RIO_DEBUG_PARAM, "Even parity\n");
-		Cor1 |= COR1_EVEN;
+		Cor1 |= RIOC_COR1_EVEN;
 	}
 
 	/*
@@ -292,11 +292,11 @@ int RIOParam(struct Port *PortP, int cmd
 	 */
 	if (TtyP->termios->c_iflag & IXON) {
 		rio_dprintk(RIO_DEBUG_PARAM, "Enable start/stop output control\n");
-		Cor2 |= COR2_IXON;
+		Cor2 |= RIOC_COR2_IXON;
 	} else {
 		if (PortP->Config & RIO_IXON) {
 			rio_dprintk(RIO_DEBUG_PARAM, "Force enable start/stop output control\n");
-			Cor2 |= COR2_IXON;
+			Cor2 |= RIOC_COR2_IXON;
 		} else
 			rio_dprintk(RIO_DEBUG_PARAM, "IXON has been disabled.\n");
 	}
@@ -304,29 +304,29 @@ int RIOParam(struct Port *PortP, int cmd
 	if (TtyP->termios->c_iflag & IXANY) {
 		if (PortP->Config & RIO_IXANY) {
 			rio_dprintk(RIO_DEBUG_PARAM, "Enable any key to restart output\n");
-			Cor2 |= COR2_IXANY;
+			Cor2 |= RIOC_COR2_IXANY;
 		} else
 			rio_dprintk(RIO_DEBUG_PARAM, "IXANY has been disabled due to sanity reasons.\n");
 	}
 
 	if (TtyP->termios->c_iflag & IXOFF) {
 		rio_dprintk(RIO_DEBUG_PARAM, "Enable start/stop input control 2\n");
-		Cor2 |= COR2_IXOFF;
+		Cor2 |= RIOC_COR2_IXOFF;
 	}
 
 	if (TtyP->termios->c_cflag & HUPCL) {
 		rio_dprintk(RIO_DEBUG_PARAM, "Hangup on last close\n");
-		Cor2 |= COR2_HUPCL;
+		Cor2 |= RIOC_COR2_HUPCL;
 	}
 
 	if (C_CRTSCTS(TtyP)) {
 		rio_dprintk(RIO_DEBUG_PARAM, "Rx hardware flow control enabled\n");
-		Cor2 |= COR2_CTSFLOW;
-		Cor2 |= COR2_RTSFLOW;
+		Cor2 |= RIOC_COR2_CTSFLOW;
+		Cor2 |= RIOC_COR2_RTSFLOW;
 	} else {
 		rio_dprintk(RIO_DEBUG_PARAM, "Rx hardware flow control disabled\n");
-		Cor2 &= ~COR2_CTSFLOW;
-		Cor2 &= ~COR2_RTSFLOW;
+		Cor2 &= ~RIOC_COR2_CTSFLOW;
+		Cor2 &= ~RIOC_COR2_RTSFLOW;
 	}
 
 
@@ -341,36 +341,36 @@ int RIOParam(struct Port *PortP, int cmd
 	 */
 	if (TtyP->termios->c_iflag & IGNBRK) {
 		rio_dprintk(RIO_DEBUG_PARAM, "Ignore break condition\n");
-		Cor4 |= COR4_IGNBRK;
+		Cor4 |= RIOC_COR4_IGNBRK;
 	}
 	if (!(TtyP->termios->c_iflag & BRKINT)) {
 		rio_dprintk(RIO_DEBUG_PARAM, "Break generates NULL condition\n");
-		Cor4 |= COR4_NBRKINT;
+		Cor4 |= RIOC_COR4_NBRKINT;
 	} else {
 		rio_dprintk(RIO_DEBUG_PARAM, "Interrupt on	break condition\n");
 	}
 
 	if (TtyP->termios->c_iflag & INLCR) {
 		rio_dprintk(RIO_DEBUG_PARAM, "Map newline to carriage return on input\n");
-		Cor4 |= COR4_INLCR;
+		Cor4 |= RIOC_COR4_INLCR;
 	}
 
 	if (TtyP->termios->c_iflag & IGNCR) {
 		rio_dprintk(RIO_DEBUG_PARAM, "Ignore carriage return on input\n");
-		Cor4 |= COR4_IGNCR;
+		Cor4 |= RIOC_COR4_IGNCR;
 	}
 
 	if (TtyP->termios->c_iflag & ICRNL) {
 		rio_dprintk(RIO_DEBUG_PARAM, "Map carriage return to newline on input\n");
-		Cor4 |= COR4_ICRNL;
+		Cor4 |= RIOC_COR4_ICRNL;
 	}
 	if (TtyP->termios->c_iflag & IGNPAR) {
 		rio_dprintk(RIO_DEBUG_PARAM, "Ignore characters with parity errors\n");
-		Cor4 |= COR4_IGNPAR;
+		Cor4 |= RIOC_COR4_IGNPAR;
 	}
 	if (TtyP->termios->c_iflag & PARMRK) {
 		rio_dprintk(RIO_DEBUG_PARAM, "Mark parity errors\n");
-		Cor4 |= COR4_PARMRK;
+		Cor4 |= RIOC_COR4_PARMRK;
 	}
 
 	/*
@@ -378,22 +378,22 @@ int RIOParam(struct Port *PortP, int cmd
 	 ** on reception of a config packet.
 	 ** The download code handles the zero baud condition.
 	 */
-	Cor4 |= COR4_RAISEMOD;
+	Cor4 |= RIOC_COR4_RAISEMOD;
 
 	/*
 	 ** COR 5
 	 */
 
-	Cor5 = COR5_CMOE;
+	Cor5 = RIOC_COR5_CMOE;
 
 	/*
 	 ** Set to monitor tbusy/tstop (or not).
 	 */
 
 	if (PortP->MonitorTstate)
-		Cor5 |= COR5_TSTATE_ON;
+		Cor5 |= RIOC_COR5_TSTATE_ON;
 	else
-		Cor5 |= COR5_TSTATE_OFF;
+		Cor5 |= RIOC_COR5_TSTATE_OFF;
 
 	/*
 	 ** Could set LNE here if you wanted LNext processing. SVR4 will use it.
@@ -401,24 +401,24 @@ int RIOParam(struct Port *PortP, int cmd
 	if (TtyP->termios->c_iflag & ISTRIP) {
 		rio_dprintk(RIO_DEBUG_PARAM, "Strip input characters\n");
 		if (!(PortP->State & RIO_TRIAD_MODE)) {
-			Cor5 |= COR5_ISTRIP;
+			Cor5 |= RIOC_COR5_ISTRIP;
 		}
 	}
 
 	if (TtyP->termios->c_oflag & ONLCR) {
 		rio_dprintk(RIO_DEBUG_PARAM, "Map newline to carriage-return, newline on output\n");
 		if (PortP->CookMode == COOK_MEDIUM)
-			Cor5 |= COR5_ONLCR;
+			Cor5 |= RIOC_COR5_ONLCR;
 	}
 	if (TtyP->termios->c_oflag & OCRNL) {
 		rio_dprintk(RIO_DEBUG_PARAM, "Map carriage return to newline on output\n");
 		if (PortP->CookMode == COOK_MEDIUM)
-			Cor5 |= COR5_OCRNL;
+			Cor5 |= RIOC_COR5_OCRNL;
 	}
 	if ((TtyP->termios->c_oflag & TABDLY) == TAB3) {
 		rio_dprintk(RIO_DEBUG_PARAM, "Tab delay 3 set\n");
 		if (PortP->CookMode == COOK_MEDIUM)
-			Cor5 |= COR5_TAB3;
+			Cor5 |= RIOC_COR5_TAB3;
 	}
 
 	/*
diff -puN drivers/char/rio/riotty.c~char-rio-fix-cirrus-defines drivers/char/rio/riotty.c
--- a/drivers/char/rio/riotty.c~char-rio-fix-cirrus-defines
+++ a/drivers/char/rio/riotty.c
@@ -211,7 +211,7 @@ int riotopen(struct tty_struct *tty, str
 		rio_dprintk(RIO_DEBUG_TTY, "Waiting for RIO_CLOSING to go away\n");
 		if (repeat_this-- <= 0) {
 			rio_dprintk(RIO_DEBUG_TTY, "Waiting for not idle closed broken by signal\n");
-			RIOPreemptiveCmd(p, PortP, FCLOSE);
+			RIOPreemptiveCmd(p, PortP, RIOC_FCLOSE);
 			retval = -EINTR;
 			goto bombout;
 		}
@@ -264,7 +264,7 @@ int riotopen(struct tty_struct *tty, str
 		   here. If I read the docs correctly the "open"
 		   command piggybacks the parameters immediately.
 		   -- REW */
-		RIOParam(PortP, OPEN, 1, OK_TO_SLEEP);	/* Open the port */
+		RIOParam(PortP, RIOC_OPEN, 1, OK_TO_SLEEP); /* Open the port */
 		rio_spin_lock_irqsave(&PortP->portSem, flags);
 
 		/*
@@ -275,7 +275,7 @@ int riotopen(struct tty_struct *tty, str
 			rio_spin_unlock_irqrestore(&PortP->portSem, flags);
 			if (RIODelay(PortP, HUNDRED_MS) == RIO_FAIL) {
 				rio_dprintk(RIO_DEBUG_TTY, "Waiting for open to finish broken by signal\n");
-				RIOPreemptiveCmd(p, PortP, FCLOSE);
+				RIOPreemptiveCmd(p, PortP, RIOC_FCLOSE);
 				func_exit();
 				return -EINTR;
 			}
@@ -297,7 +297,8 @@ int riotopen(struct tty_struct *tty, str
 	 ** insert test for carrier here. -- ???
 	 ** I already see that test here. What's the deal? -- REW
 	 */
-	if ((PortP->gs.tty->termios->c_cflag & CLOCAL) || (PortP->ModemState & MSVR1_CD)) {
+	if ((PortP->gs.tty->termios->c_cflag & CLOCAL) ||
+			(PortP->ModemState & RIOC_MSVR1_CD)) {
 		rio_dprintk(RIO_DEBUG_TTY, "open(%d) Modem carr on\n", SysPort);
 		/*
 		   tp->tm.c_state |= CARR_ON;
@@ -325,7 +326,7 @@ int riotopen(struct tty_struct *tty, str
 				 ** I think it's OK. -- REW
 				 */
 				rio_dprintk(RIO_DEBUG_TTY, "open(%d) sleeping for carr broken by signal\n", SysPort);
-				RIOPreemptiveCmd(p, PortP, FCLOSE);
+				RIOPreemptiveCmd(p, PortP, RIOC_FCLOSE);
 				/*
 				   tp->tm.c_state &= ~WOPEN;
 				 */
@@ -416,7 +417,7 @@ int riotclose(void *ptr)
 	 */
 	PortP->State &= ~RIO_MOPEN;
 	PortP->State &= ~RIO_CARR_ON;
-	PortP->ModemState &= ~MSVR1_CD;
+	PortP->ModemState &= ~RIOC_MSVR1_CD;
 	/*
 	 ** If the device was open as both a Modem and a tty line
 	 ** then we need to wimp out here, as the port has not really
@@ -453,7 +454,7 @@ int riotclose(void *ptr)
 			if (repeat_this-- <= 0) {
 				rv = -EINTR;
 				rio_dprintk(RIO_DEBUG_TTY, "Waiting for not idle closed broken by signal\n");
-				RIOPreemptiveCmd(p, PortP, FCLOSE);
+				RIOPreemptiveCmd(p, PortP, RIOC_FCLOSE);
 				goto close_end;
 			}
 			rio_dprintk(RIO_DEBUG_TTY, "Calling timeout to flush in closing\n");
@@ -492,8 +493,8 @@ int riotclose(void *ptr)
 	/* Can't call RIOShortCommand with the port locked. */
 	rio_spin_unlock_irqrestore(&PortP->portSem, flags);
 
-	if (RIOShortCommand(p, PortP, CLOSE, 1, 0) == RIO_FAIL) {
-		RIOPreemptiveCmd(p, PortP, FCLOSE);
+	if (RIOShortCommand(p, PortP, RIOC_CLOSE, 1, 0) == RIO_FAIL) {
+		RIOPreemptiveCmd(p, PortP, RIOC_FCLOSE);
 		rio_spin_lock_irqsave(&PortP->portSem, flags);
 		goto close_end;
 	}
@@ -503,7 +504,7 @@ int riotclose(void *ptr)
 			try--;
 			if (time_after(jiffies, end_time)) {
 				rio_dprintk(RIO_DEBUG_TTY, "Run out of tries - force the bugger shut!\n");
-				RIOPreemptiveCmd(p, PortP, FCLOSE);
+				RIOPreemptiveCmd(p, PortP, RIOC_FCLOSE);
 				break;
 			}
 			rio_dprintk(RIO_DEBUG_TTY, "Close: PortState:ISOPEN is %d\n", PortP->PortState & PORT_ISOPEN);
@@ -515,14 +516,14 @@ int riotclose(void *ptr)
 			}
 			if (RIODelay(PortP, HUNDRED_MS) == RIO_FAIL) {
 				rio_dprintk(RIO_DEBUG_TTY, "RTA EINTR in delay \n");
-				RIOPreemptiveCmd(p, PortP, FCLOSE);
+				RIOPreemptiveCmd(p, PortP, RIOC_FCLOSE);
 				break;
 			}
 		}
 	rio_spin_lock_irqsave(&PortP->portSem, flags);
 	rio_dprintk(RIO_DEBUG_TTY, "Close: try was %d on completion\n", try);
 
-	/* RIOPreemptiveCmd(p, PortP, FCLOSE); */
+	/* RIOPreemptiveCmd(p, PortP, RIOC_FCLOSE); */
 
 /*
 ** 15.10.1998 ARG - ESIL 0761 part fix
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

