From: akpm@linux-foundation.org
Subject: [merged] kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch removed from -mm tree
Date: Wed, 24 Jun 2009 12:11:06 -0700
Message-ID: <200906241911.n5OJB6c0011332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757356AbZFXTL0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 15:11:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, alan@lxorguk.ukuu.org.uk, jason.wessel@windriver.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     kgdb: kgdboc console poll hooks for serial_txx9 uart
has been removed from the -mm tree.  Its filename was
     kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kgdb: kgdboc console poll hooks for serial_txx9 uart
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Implement the serial polling hooks for the serial_txx9 uart for use with
kgdboc.

This patch once got SOB from Jason on Jul 2008 and (perhaps) merged
into kgdb-next branch, but lost somewhere then.
I resend it now with Jason's Acked-by.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Acked-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_txx9.c |  113 ++++++++++++++++++++++++++-------
 1 file changed, 92 insertions(+), 21 deletions(-)

diff -puN drivers/serial/serial_txx9.c~kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart drivers/serial/serial_txx9.c
--- a/drivers/serial/serial_txx9.c~kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart
+++ a/drivers/serial/serial_txx9.c
@@ -461,6 +461,94 @@ static void serial_txx9_break_ctl(struct
 	spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
+#if defined(CONFIG_SERIAL_TXX9_CONSOLE) || (CONFIG_CONSOLE_POLL)
+/*
+ *	Wait for transmitter & holding register to empty
+ */
+static void wait_for_xmitr(struct uart_txx9_port *up)
+{
+	unsigned int tmout = 10000;
+
+	/* Wait up to 10ms for the character(s) to be sent. */
+	while (--tmout &&
+	       !(sio_in(up, TXX9_SICISR) & TXX9_SICISR_TXALS))
+		udelay(1);
+
+	/* Wait up to 1s for flow control if necessary */
+	if (up->port.flags & UPF_CONS_FLOW) {
+		tmout = 1000000;
+		while (--tmout &&
+		       (sio_in(up, TXX9_SICISR) & TXX9_SICISR_CTSS))
+			udelay(1);
+	}
+}
+#endif
+
+#ifdef CONFIG_CONSOLE_POLL
+/*
+ * Console polling routines for writing and reading from the uart while
+ * in an interrupt or debug context.
+ */
+
+static int serial_txx9_get_poll_char(struct uart_port *port)
+{
+	unsigned int ier;
+	unsigned char c;
+	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+
+	/*
+	 *	First save the IER then disable the interrupts
+	 */
+	ier = sio_in(up, TXX9_SIDICR);
+	sio_out(up, TXX9_SIDICR, 0);
+
+	while (sio_in(up, TXX9_SIDISR) & TXX9_SIDISR_UVALID)
+		;
+
+	c = sio_in(up, TXX9_SIRFIFO);
+
+	/*
+	 *	Finally, clear RX interrupt status
+	 *	and restore the IER
+	 */
+	sio_mask(up, TXX9_SIDISR, TXX9_SIDISR_RDIS);
+	sio_out(up, TXX9_SIDICR, ier);
+	return c;
+}
+
+
+static void serial_txx9_put_poll_char(struct uart_port *port, unsigned char c)
+{
+	unsigned int ier;
+	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+
+	/*
+	 *	First save the IER then disable the interrupts
+	 */
+	ier = sio_in(up, TXX9_SIDICR);
+	sio_out(up, TXX9_SIDICR, 0);
+
+	wait_for_xmitr(up);
+	/*
+	 *	Send the character out.
+	 *	If a LF, also do CR...
+	 */
+	sio_out(up, TXX9_SITFIFO, c);
+	if (c == 10) {
+		wait_for_xmitr(up);
+		sio_out(up, TXX9_SITFIFO, 13);
+	}
+
+	/*
+	 *	Finally, wait for transmitter to become empty
+	 *	and restore the IER
+	 */
+	wait_for_xmitr(up);
+	sio_out(up, TXX9_SIDICR, ier);
+}
+
+#endif /* CONFIG_CONSOLE_POLL */
+
 static int serial_txx9_startup(struct uart_port *port)
 {
 	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
@@ -781,6 +869,10 @@ static struct uart_ops serial_txx9_pops 
 	.release_port	= serial_txx9_release_port,
 	.request_port	= serial_txx9_request_port,
 	.config_port	= serial_txx9_config_port,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char	= serial_txx9_get_poll_char,
+	.poll_put_char	= serial_txx9_put_poll_char,
+#endif
 };
 
 static struct uart_txx9_port serial_txx9_ports[UART_NR];
@@ -803,27 +895,6 @@ static void __init serial_txx9_register_
 
 #ifdef CONFIG_SERIAL_TXX9_CONSOLE
 
-/*
- *	Wait for transmitter & holding register to empty
- */
-static inline void wait_for_xmitr(struct uart_txx9_port *up)
-{
-	unsigned int tmout = 10000;
-
-	/* Wait up to 10ms for the character(s) to be sent. */
-	while (--tmout &&
-	       !(sio_in(up, TXX9_SICISR) & TXX9_SICISR_TXALS))
-		udelay(1);
-
-	/* Wait up to 1s for flow control if necessary */
-	if (up->port.flags & UPF_CONS_FLOW) {
-		tmout = 1000000;
-		while (--tmout &&
-		       (sio_in(up, TXX9_SICISR) & TXX9_SICISR_CTSS))
-			udelay(1);
-	}
-}
