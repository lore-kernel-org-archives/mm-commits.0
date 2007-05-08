From: akpm@linux-foundation.org
Subject: - rm9000-serial-driver.patch removed from -mm tree
Date: Mon, 07 May 2007 17:01:33 -0700
Message-ID: <200705080001.l4801XTm008778@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967301AbXEHACI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:02:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas.koeller@baslerweb.com, ralf@linux-mips.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     RM9000 serial driver
has been removed from the -mm tree.  Its filename was
     rm9000-serial-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: RM9000 serial driver
From: Thomas Koeller <thomas.koeller@baslerweb.com>

Add support for the integrated serial ports of the MIPS RM9122 processor
and its relatives.

The patch also does some whitespace cleanup.

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Thomas Koeller <thomas.koeller@baslerweb.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig           |    3 +
 drivers/serial/8250.c       |   92 +++++++++++++++++++++++++++++-----
 drivers/serial/Kconfig      |    9 +++
 include/linux/serial_core.h |    4 +
 4 files changed, 95 insertions(+), 13 deletions(-)

diff -puN arch/mips/Kconfig~rm9000-serial-driver arch/mips/Kconfig
--- a/arch/mips/Kconfig~rm9000-serial-driver
+++ a/arch/mips/Kconfig
@@ -1042,6 +1042,9 @@ config SOC_AU1X00
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
@@ -289,6 +296,44 @@ static inline int map_8250_out_reg(struc
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
+static inline int map_8250_in_reg(struct uart_8250_port *up, int offset)
+{
+	if (up->port.iotype != UPIO_RM9000)
+		return offset;
+	return regmap_in[offset];
+}
+
+static inline int map_8250_out_reg(struct uart_8250_port *up, int offset)
+{
+	if (up->port.iotype != UPIO_RM9000)
+		return offset;
+	return regmap_out[offset];
+}
+
 #else
 
 /* sane hardware needs no mapping */
@@ -311,6 +356,7 @@ static unsigned int serial_in(struct uar
 	case UPIO_DWAPB:
 		return readb(up->port.membase + offset);
 
+	case UPIO_RM9000:
 	case UPIO_MEM32:
 		return readl(up->port.membase + offset);
 
@@ -348,6 +394,7 @@ serial_out(struct uart_8250_port *up, in
 		writeb(value, up->port.membase + offset);
 		break;
 
+	case UPIO_RM9000:
 	case UPIO_MEM32:
 		writel(value, up->port.membase + offset);
 		break;
@@ -419,7 +466,7 @@ static inline void _serial_dl_write(stru
 	serial_outp(up, UART_DLM, value >> 8 & 0xff);
 }
 
-#ifdef CONFIG_SERIAL_8250_AU1X00
+#if defined (CONFIG_SERIAL_8250_AU1X00)
 /* Au1x00 haven't got a standard divisor latch */
 static int serial_dl_read(struct uart_8250_port *up)
 {
@@ -436,6 +483,24 @@ static void serial_dl_write(struct uart_
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
@@ -637,7 +702,7 @@ static unsigned int autoconfig_read_divi
  * its clones.  (We treat the broken original StarTech 16650 V1 as a
  * 16550, and why not?  Startech doesn't seem to even acknowledge its
  * existence.)
- * 
+ *
  * What evil have men's minds wrought...
  */
 static void autoconfig_has_efr(struct uart_8250_port *up)
@@ -690,7 +755,7 @@ static void autoconfig_has_efr(struct ua
 			up->bugs |= UART_BUG_QUOT;
 		return;
 	}
-	
+
 	/*
 	 * We check for a XR16C850 by setting DLL and DLM to 0, and then
 	 * reading back DLL and DLM.  The chip type depends on the DLM
@@ -833,7 +898,7 @@ static void autoconfig_16550a(struct uar
 			status1 &= ~0xB0; /* Disable LOCK, mask out PRESL[01] */
 			status1 |= 0x10;  /* 1.625 divisor for baud_base --> 921600 */
 			serial_outp(up, 0x04, status1);
-			
+
 			serial_dl_write(up, quot);
 
 			serial_outp(up, UART_LCR, 0);
@@ -938,7 +1003,7 @@ static void autoconfig(struct uart_8250_
 		/*
 		 * Do a simple existence test first; if we fail this,
 		 * there's no point trying anything else.
-		 * 
+		 *
 		 * 0x80 is used as a nonsense port to prevent against
 		 * false positives due to ISA bus float.  The
 		 * assumption is that 0x80 is a non-existent port;
@@ -977,7 +1042,7 @@ static void autoconfig(struct uart_8250_
 	save_mcr = serial_in(up, UART_MCR);
 	save_lcr = serial_in(up, UART_LCR);
 
-	/* 
+	/*
 	 * Check to see if a UART is really there.  Certain broken
 	 * internal modems based on the Rockwell chipset fail this
 	 * test, because they apparently don't implement the loopback
@@ -1084,7 +1149,7 @@ static void autoconfig(struct uart_8250_
 	else
 		serial_outp(up, UART_IER, 0);
 
- out:	
+ out:
 	spin_unlock_irqrestore(&up->port.lock, flags);
 //	restore_flags(flags);
 	DEBUG_AUTOCONF("type=%s\n", uart_config[up->port.type].name);
@@ -1110,7 +1175,7 @@ static void autoconfig_irq(struct uart_8
 	save_mcr = serial_inp(up, UART_MCR);
 	save_ier = serial_inp(up, UART_IER);
 	serial_outp(up, UART_MCR, UART_MCR_OUT1 | UART_MCR_OUT2);
-	
+
 	irqs = probe_irq_on();
 	serial_outp(up, UART_MCR, 0);
 	udelay (10);
@@ -1175,8 +1240,11 @@ static void serial8250_start_tx(struct u
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
@@ -1957,7 +2025,7 @@ serial8250_set_termios(struct uart_port 
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
@@ -231,6 +232,7 @@ struct uart_port {
 #define UPIO_AU			(4)			/* Au1x00 type IO */
 #define UPIO_TSI		(5)			/* Tsi108/109 type IO */
 #define UPIO_DWAPB		(6)			/* DesignWare APB UART */
+#define UPIO_RM9000		(7)			/* RM9000 type IO */
 
 	unsigned int		read_status_mask;	/* driver specific */
 	unsigned int		ignore_status_mask;	/* driver specific */
_

Patches currently in -mm which might be from thomas.koeller@baslerweb.com are

origin.patch
mips-excite-use-__maybe_unused.patch
