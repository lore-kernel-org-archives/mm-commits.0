From: akpm@linux-foundation.org
Subject: + serial_txx9-use-container_of-instead-of-direct-cast.patch added to -mm tree
Date: Fri, 20 Feb 2009 14:37:56 -0800
Message-ID: <200902202237.n1KMbuM4004681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346AbZBTWip (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Feb 2009 17:38:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, alan@lxorguk.ukuu.org.uk, ralf@linux-mips.org


The patch titled
     serial_txx9: use container_of() instead of direct cast
has been added to the -mm tree.  Its filename is
     serial_txx9-use-container_of-instead-of-direct-cast.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial_txx9: use container_of() instead of direct cast
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_txx9.c |   39 ++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff -puN drivers/serial/serial_txx9.c~serial_txx9-use-container_of-instead-of-direct-cast drivers/serial/serial_txx9.c
--- a/drivers/serial/serial_txx9.c~serial_txx9-use-container_of-instead-of-direct-cast
+++ a/drivers/serial/serial_txx9.c
@@ -221,21 +221,26 @@ sio_quot_set(struct uart_txx9_port *up, 
 		sio_out(up, TXX9_SIBGR, 0xff | TXX9_SIBGR_BCLK_T6);
 }
 
+static struct uart_txx9_port *to_uart_txx9_port(struct uart_port *port)
+{
+	return container_of(port, struct uart_txx9_port, port);
+}
+
 static void serial_txx9_stop_tx(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	sio_mask(up, TXX9_SIDICR, TXX9_SIDICR_TIE);
 }
 
 static void serial_txx9_start_tx(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	sio_set(up, TXX9_SIDICR, TXX9_SIDICR_TIE);
 }
 
 static void serial_txx9_stop_rx(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	up->port.read_status_mask &= ~TXX9_SIDISR_RDIS;
 }
 
@@ -246,7 +251,7 @@ static void serial_txx9_enable_ms(struct
 
 static void serial_txx9_initialize(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	unsigned int tmout = 10000;
 
 	sio_out(up, TXX9_SIFCR, TXX9_SIFCR_SWRST);
@@ -414,7 +419,7 @@ static irqreturn_t serial_txx9_interrupt
 
 static unsigned int serial_txx9_tx_empty(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	unsigned long flags;
 	unsigned int ret;
 
@@ -427,7 +432,7 @@ static unsigned int serial_txx9_tx_empty
 
 static unsigned int serial_txx9_get_mctrl(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	unsigned int ret;
 
 	/* no modem control lines */
@@ -440,7 +445,7 @@ static unsigned int serial_txx9_get_mctr
 
 static void serial_txx9_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 
 	if (mctrl & TIOCM_RTS)
 		sio_mask(up, TXX9_SIFLCR, TXX9_SIFLCR_RTSSC);
@@ -450,7 +455,7 @@ static void serial_txx9_set_mctrl(struct
 
 static void serial_txx9_break_ctl(struct uart_port *port, int break_state)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	unsigned long flags;
 
 	spin_lock_irqsave(&up->port.lock, flags);
@@ -494,7 +499,7 @@ static int serial_txx9_get_poll_char(str
 {
 	unsigned int ier;
 	unsigned char c;
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 
 	/*
 	 *	First save the IER then disable the interrupts
@@ -520,7 +525,7 @@ static int serial_txx9_get_poll_char(str
 static void serial_txx9_put_poll_char(struct uart_port *port, unsigned char c)
 {
 	unsigned int ier;
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 
 	/*
 	 *	First save the IER then disable the interrupts
@@ -551,7 +556,7 @@ static void serial_txx9_put_poll_char(st
 
 static int serial_txx9_startup(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	unsigned long flags;
 	int retval;
 
@@ -596,7 +601,7 @@ static int serial_txx9_startup(struct ua
 
 static void serial_txx9_shutdown(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	unsigned long flags;
 
 	/*
@@ -636,7 +641,7 @@ static void
 serial_txx9_set_termios(struct uart_port *port, struct ktermios *termios,
 		       struct ktermios *old)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	unsigned int cval, fcr = 0;
 	unsigned long flags;
 	unsigned int baud, quot;
@@ -814,19 +819,19 @@ static void serial_txx9_release_resource
 
 static void serial_txx9_release_port(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	serial_txx9_release_resource(up);
 }
 
 static int serial_txx9_request_port(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	return serial_txx9_request_resource(up);
 }
 
 static void serial_txx9_config_port(struct uart_port *port, int uflags)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	int ret;
 
 	/*
@@ -897,7 +902,7 @@ static void __init serial_txx9_register_
 
 static void serial_txx9_console_putchar(struct uart_port *port, int ch)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 
 	wait_for_xmitr(up);
 	sio_out(up, TXX9_SITFIFO, ch);
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
linux-next.patch
mtd-txx9-add-ndfmc-support.patch
mtd-rbtx4939-add-mtd-support.patch
mtd-txx9-soc-nand-flash-memory-controller-driver.patch
mtd-rbtx4939-map-driver-v2.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch

