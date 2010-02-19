From: akpm@linux-foundation.org
Subject: + serial-amba-pl010-enable-pps-support.patch added to -mm tree
Date: Fri, 19 Feb 2010 13:54:18 -0800
Message-ID: <201002192154.o1JLsI1D006551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755518Ab0BSVyk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Feb 2010 16:54:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@linux.it, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, greg@kroah.com, lasaine@lvk.cs.msu.su


The patch titled
     serial amba-pl010: enable PPS support
has been added to the -mm tree.  Its filename is
     serial-amba-pl010-enable-pps-support.patch

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

linux-next.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-add-new-method-n_tty_inherit_ops.patch
pps-serial-clients-support.patch
pps-serial-clients-support-fix.patch
serial-8250-enable-pps-support.patch
serial-amba-pl010-enable-pps-support.patch

