From: akpm@linux-foundation.org
Subject: + rm9000-serial-driver.patch added to -mm tree
Date: Wed, 21 Feb 2007 13:48:37 -0800
Message-ID: <200702212148.l1LLmcLA027453@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50760 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbXBUVwK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 16:52:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas.koeller@baslerweb.com, ralf@linux-mips.org, rmk@arm.linux.org.uk


The patch titled
     RM9000 serial driver
has been added to the -mm tree.  Its filename is
     rm9000-serial-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: RM9000 serial driver
From: Thomas Koeller <thomas.koeller@baslerweb.com>

Add support for the integrated serial ports of the MIPS RM9122 processor
and its relatives.

The patch also does some whitespace cleanup.

Signed-off-by: Thomas Koeller <thomas.koeller@baslerweb.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig           |    3 +
 drivers/serial/8250.c       |   84 +++++++++++++++++++++++++++++-----
 drivers/serial/Kconfig      |    9 +++
 include/linux/serial_core.h |    4 +
 4 files changed, 87 insertions(+), 13 deletions(-)

diff -puN arch/mips/Kconfig~rm9000-serial-driver arch/mips/Kconfig
--- a/arch/mips/Kconfig~rm9000-serial-driver
+++ a/arch/mips/Kconfig
@@ -1021,6 +1021,9 @@ config SOC_AU1X00
 	select SYS_SUPPORTS_APM_EMULATION
 	select SYS_SUPPORTS_KGDB
 
+config SERIAL_RM9000
+	bool
+
 config PNX8550
 	bool
 	select SOC_PNX8550
diff -puN drivers/serial/8250.c~rm9000-serial-driver drivers/serial/8250.c
--- a/drivers/serial/8250.c~rm9000-serial-driver
+++ a/drivers/serial/8250.c
@@ -251,9 +251,16 @@ static const struct serial8250_config ua
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
 		.flags		= UART_CAP_FIFO | UART_CAP_UUE,
 	},
+	[PORT_RM9000] = {
+		.name		= "RM9000",
+		.fifo_size	= 16,
+		.tx_loadsz	= 16,
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+		.flags		= UART_CAP_FIFO,
+	},
 };
 
-#ifdef CONFIG_SERIAL_8250_AU1X00
+#if defined (CONFIG_SERIAL_8250_AU1X00)
 
 /* Au1x00 UART hardware has a weird register layout */
 static const u8 au_io_in_map[] = {
@@ -289,6 +296,36 @@ static inline int map_8250_out_reg(struc
 	return au_io_out_map[offset];
 }
 
+#elif defined (CONFIG_SERIAL_8250_RM9K)
+
+static const u8
+	regmap_in[8] = {
+		[UART_RX]	= 0x00,
+		[UART_IER]	= 0x0c,
+		[UART_IIR]	= 0x14,
+		[UART_LCR]	= 0x1c,
+		[UART_MCR]	= 0x20,
+		[UART_LSR]	= 0x24,
+		[UART_MSR]	= 0x28,
+		[UART_SCR]	= 0x2c
+	},
+	regmap_out[8] = {
+		[UART_TX] 	= 0x04,
+		[UART_IER]	= 0x0c,
+		[UART_FCR]	= 0x18,
+		[UART_LCR]	= 0x1c,
+		[UART_MCR]	= 0x20,
+		[UART_LSR]	= 0x24,
+		[UART_MSR]	= 0x28,
+		[UART_SCR]	= 0x2c
+	};
+
+#define map_8250_in_reg(up, offset) \
+	(((up)->port.iotype == UPIO_RM9000) ? regmap_in[offset] : (offset))
+#define map_8250_out_reg(up, offset) \
+	(((up)->port.iotype == UPIO_RM9000) ? regmap_out[offset] : (offset))
+
+
 #else
 
 /* sane hardware needs no mapping */
@@ -310,6 +347,7 @@ static unsigned int serial_in(struct uar
 	case UPIO_MEM:
 		return readb(up->port.membase + offset);
 
+	case UPIO_RM9000:
 	case UPIO_MEM32:
 		return readl(up->port.membase + offset);
 
@@ -345,6 +383,7 @@ serial_out(struct uart_8250_port *up, in
 		writeb(value, up->port.membase + offset);
 		break;
 
+	case UPIO_RM9000:
 	case UPIO_MEM32:
 		writel(value, up->port.membase + offset);
 		break;
@@ -403,7 +442,7 @@ static inline void _serial_dl_write(stru
 	serial_outp(up, UART_DLM, value >> 8 & 0xff);
 }
 
-#ifdef CONFIG_SERIAL_8250_AU1X00
+#if defined (CONFIG_SERIAL_8250_AU1X00)
 /* Au1x00 haven't got a standard divisor latch */
 static int serial_dl_read(struct uart_8250_port *up)
 {
@@ -420,6 +459,24 @@ static void serial_dl_write(struct uart_
 	else
 		_serial_dl_write(up, value);
 }
+#elif defined (CONFIG_SERIAL_8250_RM9K)
+static int serial_dl_read(struct uart_8250_port *up)
+{
+	return	(up->port.iotype == UPIO_RM9000) ?
+		(((__raw_readl(up->port.membase + 0x10) << 8) |
+		(__raw_readl(up->port.membase + 0x08) & 0xff)) & 0xffff) :
+		_serial_dl_read(up);
+}
+
+static void serial_dl_write(struct uart_8250_port *up, int value)
+{
+	if (up->port.iotype == UPIO_RM9000) {
+		__raw_writel(value, up->port.membase + 0x08);
+		__raw_writel(value >> 8, up->port.membase + 0x10);
+	} else {
+		_serial_dl_write(up, value);
+	}
+}
 #else
 #define serial_dl_read(up) _serial_dl_read(up)
 #define serial_dl_write(up, value) _serial_dl_write(up, value)
@@ -621,7 +678,7 @@ static unsigned int autoconfig_read_divi
  * its clones.  (We treat the broken original StarTech 16650 V1 as a
  * 16550, and why not?  Startech doesn't seem to even acknowledge its
  * existence.)
- * 
+ *
  * What evil have men's minds wrought...
  */
 static void autoconfig_has_efr(struct uart_8250_port *up)
@@ -674,7 +731,7 @@ static void autoconfig_has_efr(struct ua
 			up->bugs |= UART_BUG_QUOT;
 		return;
 	}
-	
+
 	/*
 	 * We check for a XR16C850 by setting DLL and DLM to 0, and then
 	 * reading back DLL and DLM.  The chip type depends on the DLM
@@ -817,7 +874,7 @@ static void autoconfig_16550a(struct uar
 			status1 &= ~0xB0; /* Disable LOCK, mask out PRESL[01] */
 			status1 |= 0x10;  /* 1.625 divisor for baud_base --> 921600 */
 			serial_outp(up, 0x04, status1);
-			
+
 			serial_dl_write(up, quot);
 
 			serial_outp(up, UART_LCR, 0);
@@ -922,7 +979,7 @@ static void autoconfig(struct uart_8250_
 		/*
 		 * Do a simple existence test first; if we fail this,
 		 * there's no point trying anything else.
-		 * 
+		 *
 		 * 0x80 is used as a nonsense port to prevent against
 		 * false positives due to ISA bus float.  The
 		 * assumption is that 0x80 is a non-existent port;
@@ -961,7 +1018,7 @@ static void autoconfig(struct uart_8250_
 	save_mcr = serial_in(up, UART_MCR);
 	save_lcr = serial_in(up, UART_LCR);
 
-	/* 
+	/*
 	 * Check to see if a UART is really there.  Certain broken
 	 * internal modems based on the Rockwell chipset fail this
 	 * test, because they apparently don't implement the loopback
@@ -1068,7 +1125,7 @@ static void autoconfig(struct uart_8250_
 	else
 		serial_outp(up, UART_IER, 0);
 
- out:	
+ out:
 	spin_unlock_irqrestore(&up->port.lock, flags);
 //	restore_flags(flags);
 	DEBUG_AUTOCONF("type=%s\n", uart_config[up->port.type].name);
@@ -1094,7 +1151,7 @@ static void autoconfig_irq(struct uart_8
 	save_mcr = serial_inp(up, UART_MCR);
 	save_ier = serial_inp(up, UART_IER);
 	serial_outp(up, UART_MCR, UART_MCR_OUT1 | UART_MCR_OUT2);
-	
+
 	irqs = probe_irq_on();
 	serial_outp(up, UART_MCR, 0);
 	udelay (10);
@@ -1159,8 +1216,11 @@ static void serial8250_start_tx(struct u
 		if (up->bugs & UART_BUG_TXEN) {
 			unsigned char lsr, iir;
 			lsr = serial_in(up, UART_LSR);
-			iir = serial_in(up, UART_IIR);
-			if (lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT)
+			iir = serial_in(up, UART_IIR) & 0x0f;
+			if ((up->port.type == PORT_RM9000) ?
+				(lsr & UART_LSR_THRE &&
+				(iir == UART_IIR_NO_INT || iir == UART_IIR_THRI)) :
+				(lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT))
 				transmit_chars(up);
 		}
 	}
@@ -1926,7 +1986,7 @@ serial8250_set_termios(struct uart_port 
 	/*
 	 * Ask the core to calculate the divisor for us.
 	 */
-	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16); 
+	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16);
 	quot = serial8250_get_divisor(port, baud);
 
 	/*
diff -puN drivers/serial/Kconfig~rm9000-serial-driver drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~rm9000-serial-driver
+++ a/drivers/serial/Kconfig
@@ -254,6 +254,15 @@ config SERIAL_8250_AU1X00
 	  to this option.  The driver can handle 1 or 2 serial ports.
 	  If unsure, say N.
 
+config SERIAL_8250_RM9K
+	bool "Support for MIPS RM9xxx integrated serial port"
+	depends on SERIAL_8250 != n && SERIAL_RM9000
+	select SERIAL_8250_SHARE_IRQ
+	help
+	  Selecting this option will add support for the integrated serial
+	  port hardware found on MIPS RM9122 and similar processors.
+	  If unsure, say N.
+
 comment "Non-8250 serial port support"
 
 config SERIAL_AMBA_PL010
diff -puN include/linux/serial_core.h~rm9000-serial-driver include/linux/serial_core.h
--- a/include/linux/serial_core.h~rm9000-serial-driver
+++ a/include/linux/serial_core.h
@@ -39,7 +39,8 @@
 #define PORT_RSA	13
 #define PORT_NS16550A	14
 #define PORT_XSCALE	15
-#define PORT_MAX_8250	15	/* max port ID */
+#define PORT_RM9000	16	/* PMC-Sierra RM9xxx internal UART */
+#define PORT_MAX_8250	16	/* max port ID */
 
 /*
  * ARM specific type numbers.  These are not currently guaranteed
@@ -233,6 +234,7 @@ struct uart_port {
 #define UPIO_MEM32		(3)
 #define UPIO_AU			(4)			/* Au1x00 type IO */
 #define UPIO_TSI		(5)			/* Tsi108/109 type IO */
+#define UPIO_RM9000		(6)			/* RM9000 type IO */
 
 	unsigned int		read_status_mask;	/* driver specific */
 	unsigned int		ignore_status_mask;	/* driver specific */
_

Patches currently in -mm which might be from thomas.koeller@baslerweb.com are

rm9000-serial-driver.patch
