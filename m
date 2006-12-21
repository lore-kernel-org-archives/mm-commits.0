From: akpm@osdl.org
Subject: + pnx8550-uart-driver-fixes.patch added to -mm tree
Date: Thu, 21 Dec 2006 13:26:32 -0800
Message-ID: <200612212126.kBLLQWtd005461@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42496 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423114AbWLUV1A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 16:27:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vitalywool@gmail.com, alan@lxorguk.ukuu.org.uk, ralf@linux-mips.org, rmk@arm.linux.org.uk


The patch titled
     pnx8xxx-uart: irq and ktermios fixes
has been added to the -mm tree.  Its filename is
     pnx8550-uart-driver-fixes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pnx8xxx-uart: irq and ktermios fixes
From: Vitaly Wool <vitalywool@gmail.com>

Add irq 2.6.19 changes and 2.6.20 ktermios changes to pnx8xxx-uart.c (which
was added to -mm tree with pnx8550-uart-driver.patch).

Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/serial/pnx8xxx_uart.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/serial/pnx8xxx_uart.c~pnx8550-uart-driver-fixes drivers/serial/pnx8xxx_uart.c
--- a/drivers/serial/pnx8xxx_uart.c~pnx8550-uart-driver-fixes
+++ a/drivers/serial/pnx8xxx_uart.c
@@ -179,8 +179,7 @@ static void pnx8xxx_enable_ms(struct uar
 	mod_timer(&sport->timer, jiffies);
 }
 
-static void
-pnx8xxx_rx_chars(struct pnx8xxx_port *sport, struct pt_regs *regs)
+static void pnx8xxx_rx_chars(struct pnx8xxx_port *sport)
 {
 	struct tty_struct *tty = sport->port.info->tty;
 	unsigned int status, ch, flg;
@@ -220,7 +219,7 @@ pnx8xxx_rx_chars(struct pnx8xxx_port *sp
 #endif
 		}
 
-		if (uart_handle_sysrq_char(&sport->port, ch, regs))
+		if (uart_handle_sysrq_char(&sport->port, ch))
 			goto ignore_char;
 
 		uart_insert_char(&sport->port, status,
@@ -293,7 +292,7 @@ static irqreturn_t pnx8xxx_int(int irq, 
 
 	/* Byte received */
 	if (status & PNX8XXX_UART_INT_RX)
-		pnx8xxx_rx_chars(sport, regs);
+		pnx8xxx_rx_chars(sport);
 
 	/* TX holding register empty - transmit a byte */
 	if (status & PNX8XXX_UART_INT_TX)
@@ -429,8 +428,8 @@ static void pnx8xxx_shutdown(struct uart
 }
 
 static void
-pnx8xxx_set_termios(struct uart_port *port, struct termios *termios,
-		   struct termios *old)
+pnx8xxx_set_termios(struct uart_port *port, struct ktermios *termios,
+		   struct ktermios *old)
 {
 	struct pnx8xxx_port *sport = (struct pnx8xxx_port *)port;
 	unsigned long flags;
@@ -727,7 +726,7 @@ pnx8xxx_console_setup(struct console *co
 	return uart_set_options(&sport->port, co, baud, parity, bits, flow);
 }
 
-extern struct uart_driver pnx8xxx_reg;
+static struct uart_driver pnx8xxx_reg;
 static struct console pnx8xxx_console = {
 	.name		= "ttyS",
 	.write		= pnx8xxx_console_write,
_

Patches currently in -mm which might be from vitalywool@gmail.com are

origin.patch
smc911x-fix-netpoll-compilation-faliure.patch
smc911-workqueue-fixes.patch
fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch

