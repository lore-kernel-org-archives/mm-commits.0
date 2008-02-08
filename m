From: akpm@linux-foundation.org
Subject: - serial8250-coding-style.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:02 -0800
Message-ID: <200802082012.m18KChjb010230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33146 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756490AbYBHUvj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:51:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     serial8250: coding style
has been removed from the -mm tree.  Its filename was
     serial8250-coding-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial8250: coding style
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN drivers/serial/8250.c~serial8250-coding-style drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial8250-coding-style
+++ a/drivers/serial/8250.c
@@ -305,7 +305,7 @@ static inline int map_8250_out_reg(struc
 	return au_io_out_map[offset];
 }
 
-#elif defined (CONFIG_SERIAL_8250_RM9K)
+#elif defined(CONFIG_SERIAL_8250_RM9K)
 
 static const u8
 	regmap_in[8] = {
@@ -475,7 +475,7 @@ static inline void _serial_dl_write(stru
 	serial_outp(up, UART_DLM, value >> 8 & 0xff);
 }
 
-#if defined (CONFIG_SERIAL_8250_AU1X00)
+#if defined(CONFIG_SERIAL_8250_AU1X00)
 /* Au1x00 haven't got a standard divisor latch */
 static int serial_dl_read(struct uart_8250_port *up)
 {
@@ -492,7 +492,7 @@ static void serial_dl_write(struct uart_
 	else
 		_serial_dl_write(up, value);
 }
-#elif defined (CONFIG_SERIAL_8250_RM9K)
+#elif defined(CONFIG_SERIAL_8250_RM9K)
 static int serial_dl_read(struct uart_8250_port *up)
 {
 	return	(up->port.iotype == UPIO_RM9000) ?
@@ -1185,8 +1185,8 @@ static void autoconfig_irq(struct uart_8
 
 	irqs = probe_irq_on();
 	serial_outp(up, UART_MCR, 0);
-	udelay (10);
-	if (up->port.flags & UPF_FOURPORT)  {
+	udelay(10);
+	if (up->port.flags & UPF_FOURPORT) {
 		serial_outp(up, UART_MCR,
 			    UART_MCR_DTR | UART_MCR_RTS);
 	} else {
@@ -1199,7 +1199,7 @@ static void autoconfig_irq(struct uart_8
 	(void)serial_inp(up, UART_IIR);
 	(void)serial_inp(up, UART_MSR);
 	serial_outp(up, UART_TX, 0xFF);
-	udelay (20);
+	udelay(20);
 	irq = probe_irq_off(irqs);
 
 	serial_outp(up, UART_MCR, save_mcr);
@@ -1343,7 +1343,7 @@ receive_chars(struct uart_8250_port *up,
 
 		uart_insert_char(&up->port, lsr, UART_LSR_OE, ch, flag);
 
-	ignore_char:
+ignore_char:
 		lsr = serial_inp(up, UART_LSR);
 	} while ((lsr & UART_LSR_DR) && (max_count-- > 0));
 	spin_unlock(&up->port.lock);
@@ -1633,7 +1633,8 @@ static void serial8250_backup_timeout(un
 		serial_out(up, UART_IER, ier);
 
 	/* Standard timer interval plus 0.2s to keep the port running */
-	mod_timer(&up->timer, jiffies + poll_timeout(up->port.timeout) + HZ/5);
+	mod_timer(&up->timer,
+		jiffies + poll_timeout(up->port.timeout) + HZ / 5);
 }
 
 static unsigned int serial8250_tx_empty(struct uart_port *port)
@@ -1844,7 +1845,7 @@ static int serial8250_startup(struct uar
 			up->timer.function = serial8250_backup_timeout;
 			up->timer.data = (unsigned long)up;
 			mod_timer(&up->timer, jiffies +
-			          poll_timeout(up->port.timeout) + HZ/5);
+				poll_timeout(up->port.timeout) + HZ / 5);
 		}
 	}
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
git-watchdog.patch
