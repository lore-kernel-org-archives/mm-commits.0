From: akpm@linux-foundation.org
Subject: [merged] serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed.patch removed from -mm tree
Date: Thu, 06 May 2010 12:09:18 -0400
Message-ID: <201005061910.o46JAm9a008551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755612Ab0EFTLE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 15:11:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.rojfors@pelagicore.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     serial: timbuart: make sure last byte is sent when port is closed
has been removed from the -mm tree.  Its filename was
     serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed.pa=
tch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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

[akpm@linux-foundation.org: fix build]
Signed-off-by: Richard R=F6jfors <richard.rojfors@pelagicore.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/timbuart.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN drivers/serial/timbuart.c~serial-timbuart-make-sure-last-byte=
-is-sent-when-port-is-closed drivers/serial/timbuart.c
--- a/drivers/serial/timbuart.c~serial-timbuart-make-sure-last-byte-is-=
sent-when-port-is-closed
+++ a/drivers/serial/timbuart.c
@@ -68,12 +68,22 @@ static void timbuart_start_tx(struct uar
 	tasklet_schedule(&uart->tasklet);
 }
=20
+static unsigned int timbuart_tx_empty(struct uart_port *port)
+{
+	u32 isr =3D ioread32(port->membase + TIMBUART_ISR);
+
+	return (isr & TXBE) ? TIOCSER_TEMT : 0;
+}
+
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
@@ -195,13 +205,6 @@ void timbuart_tasklet(unsigned long arg)
 	dev_dbg(uart->port.dev, "%s leaving\n", __func__);
 }
=20
-static unsigned int timbuart_tx_empty(struct uart_port *port)
-{
-	u32 isr =3D ioread32(port->membase + TIMBUART_ISR);
-
-	return (isr & TXBE) ? TIOCSER_TEMT : 0;
-}
