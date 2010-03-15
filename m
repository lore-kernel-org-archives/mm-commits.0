From: akpm@linux-foundation.org
Subject: [merged] serial-amba-pl010-enable-pps-support.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:04:31 -0400
Message-ID: <201003150705.o2F754Tf017057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759716Ab0COHF3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:05:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@linux.it, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, greg@kroah.com, lasaine@lvk.cs.msu.su, mm-commits@vger.kernel.org


The patch titled
     serial amba-pl010: enable PPS support
has been removed from the -mm tree.  Its filename was
     serial-amba-pl010-enable-pps-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial amba-pl010: enable PPS support
From: Rodolfo Giometti <giometti@linux.it>

Function pl010_enable_ms() is automagically called when PPS ldisc
is selected.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/amba-pl010.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN drivers/serial/amba-pl010.c~serial-amba-pl010-enable-pps-support drivers/serial/amba-pl010.c
--- a/drivers/serial/amba-pl010.c~serial-amba-pl010-enable-pps-support
+++ a/drivers/serial/amba-pl010.c
@@ -471,6 +471,20 @@ pl010_set_termios(struct uart_port *port
 	spin_unlock_irqrestore(&uap->port.lock, flags);
 }
 
+static void pl010_set_ldisc(struct uart_port *port)
+{
+	int line = port->line;
+
+	if (line >= port->state->port.tty->driver->num)
+		return;
+
+	if (port->state->port.tty->ldisc->ops->num == N_PPS) {
+		port->flags |= UPF_HARDPPS_CD;
+		pl010_enable_ms(port);
+	} else
+		port->flags &= ~UPF_HARDPPS_CD;
+}
+
 static const char *pl010_type(struct uart_port *port)
 {
 	return port->type == PORT_AMBA ? "AMBA" : NULL;
@@ -531,6 +545,7 @@ static struct uart_ops amba_pl010_pops =
 	.startup	= pl010_startup,
 	.shutdown	= pl010_shutdown,
 	.set_termios	= pl010_set_termios,
+	.set_ldisc	= pl010_set_ldisc,
 	.type		= pl010_type,
 	.release_port	= pl010_release_port,
 	.request_port	= pl010_request_port,
_

Patches currently in -mm which might be from giometti@linux.it are

origin.patch

