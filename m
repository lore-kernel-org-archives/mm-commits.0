From: akpm@linux-foundation.org
Subject: + serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:12:15 -0700
Message-ID: <201003192312.o2JNCF8c017747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153Ab0CSXMv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:12:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard.rojfors@pelagicore.com, greg@kroah.com


The patch titled
     serial: timbuart: make sure last byte is sent when port is closed
has been added to the -mm tree.  Its filename is
     serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed.pa=
tch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: serial: timbuart: make sure last byte is sent when port is clo=
sed
=46rom: Richard R=F6jfors <richard.rojfors@pelagicore.com>

=46ix a problem in early versions of the FPGA IP.

In certain situations the IP reports that the FIFO is empty, but a byte=
 is
still clocked out.  If a flush is done at that point the currently cloc=
ked
byte is canceled.

This causes incompatibilities with the upper layers when a port is clos=
ed,
it waits until the FIFO is empty and then closes the port.  During clos=
e
the FIFO is flushed -> the last byte is not sent properly.

Now the FIFO is only flushed if it is reported to be non-empty.  Which
makes the currently clocked out byte to finish.

Signed-off-by: Richard R=F6jfors <richard.rojfors@pelagicore.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/timbuart.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/serial/timbuart.c~serial-timbuart-make-sure-last-byte=
-is-sent-when-port-is-closed drivers/serial/timbuart.c
--- a/drivers/serial/timbuart.c~serial-timbuart-make-sure-last-byte-is-=
sent-when-port-is-closed
+++ a/drivers/serial/timbuart.c
@@ -69,10 +69,13 @@ static void timbuart_start_tx(struct uar
=20
 static void timbuart_flush_buffer(struct uart_port *port)
 {
-	u8 ctl =3D ioread8(port->membase + TIMBUART_CTRL) | TIMBUART_CTRL_FLS=
HTX;
+	if (!timbuart_tx_empty(port)) {
+		u8 ctl =3D ioread8(port->membase + TIMBUART_CTRL) |
+			TIMBUART_CTRL_FLSHTX;
=20
-	iowrite8(ctl, port->membase + TIMBUART_CTRL);
-	iowrite32(TXBF, port->membase + TIMBUART_ISR);
+		iowrite8(ctl, port->membase + TIMBUART_CTRL);
+		iowrite32(TXBF, port->membase + TIMBUART_ISR);
+	}
 }
=20
 static void timbuart_rx_chars(struct uart_port *port)
_

Patches currently in -mm which might be from richard.rojfors@pelagicore=
=2Ecom are

origin.patch
drivers-gpio-max730xc-add-license-macro.patch
drivers-gpio-max730xc-add-license-macro-fix.patch
linux-next.patch
serial-two-branches-the-same-in-timbuart_set_mctrl.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
