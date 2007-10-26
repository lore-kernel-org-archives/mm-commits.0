From: akpm@linux-foundation.org
Subject: - fallback-to-no-irq-hack-for-case-of-no-pnp_irq-allocated-for-8250_pnp.patch removed from -mm tree
Date: Fri, 26 Oct 2007 12:36:33 -0700
Message-ID: <200710261936.l9QJaXPr011030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42319 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750815AbXJZThZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 15:37:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luming.yu@gmail.com, alan@lxorguk.ukuu.org.uk, bjorn.helgaas@hp.com, luming.yu@intel.com, matthew@wil.cx, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fallback to "no irq" hack for case of no pnp_irq allocated for 8250_pnp
has been removed from the -mm tree.  Its filename was
     fallback-to-no-irq-hack-for-case-of-no-pnp_irq-allocated-for-8250_pnp.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: fallback to "no irq" hack for case of no pnp_irq allocated for 8250_pnp
From: "Luming Yu" <luming.yu@gmail.com>

There is a "ttyS1 irq is -1" problem observed on tiger4 which cause
the serial port broken.

It is because that there is __no__ ACPI IRQ resource assigned for the
serial port.  So the value of the IRQ for the port is never changed since
it got initialized to -1.  The attached patch falls back to the "no irq"
hack for this case.  It works for me.

Alan sayeth: "Should really fix pnp_irq() to use zero to mean none as the
kernel intends.  If that causes other complications then this hack will do for
now I guess."

Signed-off-by: Yu Luming <luming.yu@intel.com>
Seems-reasonable-to: Matthew Wilcox <matthew@wil.cx>
Sort-of-acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Might-be-the-fault-of: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pnp.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/serial/8250_pnp.c~fallback-to-no-irq-hack-for-case-of-no-pnp_irq-allocated-for-8250_pnp drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~fallback-to-no-irq-hack-for-case-of-no-pnp_irq-allocated-for-8250_pnp
+++ a/drivers/serial/8250_pnp.c
@@ -433,6 +433,9 @@ serial_pnp_probe(struct pnp_dev *dev, co
 
 	memset(&port, 0, sizeof(struct uart_port));
 	port.irq = pnp_irq(dev, 0);
+	/* No irq is assigned for the port, fallback to "no irq" hack */
+	if (port.irq == -1)
+		port.irq = 0;
 	if (pnp_port_valid(dev, 0)) {
 		port.iobase = pnp_port_start(dev, 0);
 		port.iotype = UPIO_PORT;
_

Patches currently in -mm which might be from luming.yu@gmail.com are

fallback-to-no-irq-hack-for-case-of-no-pnp_irq-allocated-for-8250_pnp.patch
