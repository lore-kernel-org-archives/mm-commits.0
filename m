From: akpm@linux-foundation.org
Subject: [merged] serial-8250-enable-pps-support.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:04:26 -0400
Message-ID: <201003150705.o2F74x12017053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759737Ab0COHFk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:05:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@linux.it, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, greg@kroah.com, lasaine@lvk.cs.msu.su, mm-commits@vger.kernel.org


The patch titled
     serial 8250: enable PPS support
has been removed from the -mm tree.  Its filename was
     serial-8250-enable-pps-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial 8250: enable PPS support
From: Rodolfo Giometti <giometti@linux.it>

Automagically function serial8250_enable_ms() is called when PPS ldisc
is selected.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN drivers/serial/8250.c~serial-8250-enable-pps-support drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-8250-enable-pps-support
+++ a/drivers/serial/8250.c
@@ -2408,6 +2408,21 @@ serial8250_set_termios(struct uart_port 
 }
 
 static void
+serial8250_set_ldisc(struct uart_port *port)
+{
+	int line = port->line;
+
+	if (line >= port->state->port.tty->driver->num)
+		return;
+
+	if (port->state->port.tty->ldisc->ops->num == N_PPS) {
+		port->flags |= UPF_HARDPPS_CD;
+		serial8250_enable_ms(port);
+	} else
+		port->flags &= ~UPF_HARDPPS_CD;
+}
+
+static void
 serial8250_pm(struct uart_port *port, unsigned int state,
 	      unsigned int oldstate)
 {
@@ -2628,6 +2643,7 @@ static struct uart_ops serial8250_pops =
 	.startup	= serial8250_startup,
 	.shutdown	= serial8250_shutdown,
 	.set_termios	= serial8250_set_termios,
+	.set_ldisc	= serial8250_set_ldisc,
 	.pm		= serial8250_pm,
 	.type		= serial8250_type,
 	.release_port	= serial8250_release_port,
_

Patches currently in -mm which might be from giometti@linux.it are

origin.patch

