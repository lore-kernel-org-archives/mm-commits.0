From: akpm@linux-foundation.org
Subject: - 8250-uart-backup-timer.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:47:24 -0800
Message-ID: <200702150847.l1F8lOLj024977@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39940 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965364AbXBOIrv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:47:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.williamson@hp.com, aris@cathedrallabs.org, hpa@zytor.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     8250 UART backup timer
has been removed from the -mm tree.  Its filename was
     8250-uart-backup-timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: 8250 UART backup timer
From: Alex Williamson <alex.williamson@hp.com>

The patch below works around a minor bug found in the UART of the remote
management card used in many HP ia64 and parisc servers (aka the Diva
UARTs).  The problem is that the UART does not reassert the THRE interrupt
if it has been previously cleared and the IIR THRI bit is re-enabled.  This
can produce a very annoying failure mode when used as a serial console,
allowing a boot/reboot to hang indefinitely until an RX interrupt kicks it
into working again (ie.  an unattended reboot could stall).

To solve this problem, a backup timer is introduced that runs alongside the
standard interrupt driven mechanism.  This timer wakes up periodically,
checks for a hang condition and gets characters moving again.  This backup
mechanism is only enabled if the UART is detected as having this problem,
so systems without these UARTs will have no additional overhead.

This version of the patch incorporates previous comments from Pavel and
removes races in the bug detection code.  The test is now done before the
irq linking to prevent races with interrupt handler clearing the THRE
interrupt.  Short delays and syncs are also added to ensure the device is
able to update register state before the result is tested.

Aristeu says:

  this was tested on the following HP machines and solved the problem:
  rx2600, rx2620, rx1600 and rx1620s.

hpa says:

  I have seen this same bug in soft UART IP from "a major vendor."

Signed-off-by: Alex Williamson <alex.williamson@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Acked-by: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |  178 ++++++++++++++++++++++++++++++----------
 1 file changed, 134 insertions(+), 44 deletions(-)

diff -puN drivers/serial/8250.c~8250-uart-backup-timer drivers/serial/8250.c
--- a/drivers/serial/8250.c~8250-uart-backup-timer
+++ a/drivers/serial/8250.c
@@ -364,6 +364,23 @@ serial_out(struct uart_8250_port *up, in
 	}
 }
 
+static void
+serial_out_sync(struct uart_8250_port *up, int offset, int value)
+{
+	switch (up->port.iotype) {
+	case UPIO_MEM:
+	case UPIO_MEM32:
+#ifdef CONFIG_SERIAL_8250_AU1X00
+	case UPIO_AU:
+#endif
+		serial_out(up, offset, value);
+		serial_in(up, UART_LCR);	/* safe, no side-effects */
+		break;
+	default:
+		serial_out(up, offset, value);
+	}
+}
+
 /*
  * We used to support using pause I/O for certain machines.  We
  * haven't supported this for a while, but just in case it's badly
@@ -1045,7 +1062,7 @@ static void autoconfig(struct uart_8250_
 #endif
 	serial_outp(up, UART_MCR, save_mcr);
 	serial8250_clear_fifos(up);
-	(void)serial_in(up, UART_RX);
+	serial_in(up, UART_RX);
 	if (up->capabilities & UART_CAP_UUE)
 		serial_outp(up, UART_IER, UART_IER_UUE);
 	else
@@ -1451,6 +1468,12 @@ static void serial_unlink_irq_chain(stru
 	serial_do_unlink(i, up);
 }
 
+/* Base timer interval for polling */
+static inline int poll_timeout(int timeout)
+{
+	return timeout > 6 ? (timeout / 2 - 2) : 1;
+}
+
 /*
  * This function is used to handle ports that do not have an
  * interrupt.  This doesn't work very well for 16450's, but gives
@@ -1460,16 +1483,51 @@ static void serial_unlink_irq_chain(stru
 static void serial8250_timeout(unsigned long data)
 {
 	struct uart_8250_port *up = (struct uart_8250_port *)data;
-	unsigned int timeout;
 	unsigned int iir;
 
 	iir = serial_in(up, UART_IIR);
 	if (!(iir & UART_IIR_NO_INT))
 		serial8250_handle_port(up);
+	mod_timer(&up->timer, jiffies + poll_timeout(up->port.timeout));
+}
+
+static void serial8250_backup_timeout(unsigned long data)
+{
+	struct uart_8250_port *up = (struct uart_8250_port *)data;
+	unsigned int iir, ier = 0;
+
+	/*
+	 * Must disable interrupts or else we risk racing with the interrupt
+	 * based handler.
+	 */
+	if (is_real_interrupt(up->port.irq)) {
+		ier = serial_in(up, UART_IER);
+		serial_out(up, UART_IER, 0);
+	}
+
+	iir = serial_in(up, UART_IIR);
+
+	/*
+	 * This should be a safe test for anyone who doesn't trust the
+	 * IIR bits on their UART, but it's specifically designed for
+	 * the "Diva" UART used on the management processor on many HP
+	 * ia64 and parisc boxes.
+	 */
+	if ((iir & UART_IIR_NO_INT) && (up->ier & UART_IER_THRI) &&
+	    (!uart_circ_empty(&up->port.info->xmit) || up->port.x_char) &&
+	    (serial_in(up, UART_LSR) & UART_LSR_THRE)) {
+		iir &= ~(UART_IIR_ID | UART_IIR_NO_INT);
+		iir |= UART_IIR_THRI;
+	}
+
+	if (!(iir & UART_IIR_NO_INT))
+		serial8250_handle_port(up);
+
+	if (is_real_interrupt(up->port.irq))
+		serial_out(up, UART_IER, ier);
 
-	timeout = up->port.timeout;
-	timeout = timeout > 6 ? (timeout / 2 - 2) : 1;
-	mod_timer(&up->timer, jiffies + timeout);
+	/* Standard timer interval plus 0.2s to keep the port running */
+	mod_timer(&up->timer, jiffies + poll_timeout(up->port.timeout) + HZ/5);
 }
 
 static unsigned int serial8250_tx_empty(struct uart_port *port)
@@ -1540,6 +1598,37 @@ static void serial8250_break_ctl(struct 
 	spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
+#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
+
+/*
+ *	Wait for transmitter & holding register to empty
+ */
+static inline void wait_for_xmitr(struct uart_8250_port *up, int bits)
+{
+	unsigned int status, tmout = 10000;
+
+	/* Wait up to 10ms for the character(s) to be sent. */
+	do {
+		status = serial_in(up, UART_LSR);
+
+		if (status & UART_LSR_BI)
+			up->lsr_break_flag = UART_LSR_BI;
+
+		if (--tmout == 0)
+			break;
+		udelay(1);
+	} while ((status & bits) != bits);
+
+	/* Wait up to 1s for flow control if necessary */
+	if (up->port.flags & UPF_CONS_FLOW) {
+		tmout = 1000000;
+		while (!(serial_in(up, UART_MSR) & UART_MSR_CTS) && --tmout) {
+			udelay(1);
+			touch_nmi_watchdog();
+		}
+	}
+}
+
 static int serial8250_startup(struct uart_port *port)
 {
 	struct uart_8250_port *up = (struct uart_8250_port *)port;
@@ -1613,18 +1702,50 @@ static int serial8250_startup(struct uar
 		serial_outp(up, UART_LCR, 0);
 	}
 
+	if (is_real_interrupt(up->port.irq)) {
+		/*
+		 * Test for UARTs that do not reassert THRE when the
+		 * transmitter is idle and the interrupt has already
+		 * been cleared.  Real 16550s should always reassert
+		 * this interrupt whenever the transmitter is idle and
+		 * the interrupt is enabled.  Delays are necessary to
+		 * allow register changes to become visible.
+		 */
+		spin_lock_irqsave(&up->port.lock, flags);
+
+		wait_for_xmitr(up, UART_LSR_THRE);
+		serial_out_sync(up, UART_IER, UART_IER_THRI);
+		udelay(1); /* allow THRE to set */
+		serial_in(up, UART_IIR);
+		serial_out(up, UART_IER, 0);
+		serial_out_sync(up, UART_IER, UART_IER_THRI);
+		udelay(1); /* allow a working UART time to re-assert THRE */
+		iir = serial_in(up, UART_IIR);
+		serial_out(up, UART_IER, 0);
+
+		spin_unlock_irqrestore(&up->port.lock, flags);
+
+		/*
+		 * If the interrupt is not reasserted, setup a timer to
+		 * kick the UART on a regular basis.
+		 */
+		if (iir & UART_IIR_NO_INT) {
+			pr_debug("ttyS%d - using backup timer\n", port->line);
+			up->timer.function = serial8250_backup_timeout;
+			up->timer.data = (unsigned long)up;
+			mod_timer(&up->timer, jiffies +
+			          poll_timeout(up->port.timeout) + HZ/5);
+		}
+	}
+
 	/*
 	 * If the "interrupt" for this port doesn't correspond with any
 	 * hardware interrupt, we use a timer-based system.  The original
 	 * driver used to do this with IRQ0.
 	 */
 	if (!is_real_interrupt(up->port.irq)) {
-		unsigned int timeout = up->port.timeout;
-
-		timeout = timeout > 6 ? (timeout / 2 - 2) : 1;
-
 		up->timer.data = (unsigned long)up;
-		mod_timer(&up->timer, jiffies + timeout);
+		mod_timer(&up->timer, jiffies + poll_timeout(up->port.timeout));
 	} else {
 		retval = serial_link_irq_chain(up);
 		if (retval)
@@ -1740,9 +1861,9 @@ static void serial8250_shutdown(struct u
 	 */
 	(void) serial_in(up, UART_RX);
 
-	if (!is_real_interrupt(up->port.irq))
-		del_timer_sync(&up->timer);
-	else
+	del_timer_sync(&up->timer);
+	up->timer.function = serial8250_timeout;
+	if (is_real_interrupt(up->port.irq))
 		serial_unlink_irq_chain(up);
 }
 
@@ -2212,37 +2333,6 @@ serial8250_register_ports(struct uart_dr
 
 #ifdef CONFIG_SERIAL_8250_CONSOLE
 
-#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
-
-/*
- *	Wait for transmitter & holding register to empty
- */
-static inline void wait_for_xmitr(struct uart_8250_port *up, int bits)
-{
-	unsigned int status, tmout = 10000;
-
-	/* Wait up to 10ms for the character(s) to be sent. */
-	do {
-		status = serial_in(up, UART_LSR);
-
-		if (status & UART_LSR_BI)
-			up->lsr_break_flag = UART_LSR_BI;
-
-		if (--tmout == 0)
-			break;
-		udelay(1);
-	} while ((status & bits) != bits);
-
-	/* Wait up to 1s for flow control if necessary */
-	if (up->port.flags & UPF_CONS_FLOW) {
-		tmout = 1000000;
-		while (!(serial_in(up, UART_MSR) & UART_MSR_CTS) && --tmout) {
-			udelay(1);
-			touch_nmi_watchdog();
-		}
-	}
-}
-
 static void serial8250_console_putchar(struct uart_port *port, int ch)
 {
 	struct uart_8250_port *up = (struct uart_8250_port *)port;
_

Patches currently in -mm which might be from alex.williamson@hp.com are

origin.patch
