From: akpm@linux-foundation.org
Subject: - serial-assert-dtr-for-serial-console-devices.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:48:24 -0700
Message-ID: <200707162048.l6GKmOMa001037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49452 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758599AbXGPUst (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 16:48:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, bjorn.helgaas@hp.com, kraxel@suse.de, rmk@arm.linux.org.uk, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     serial: assert DTR for serial console devices
has been removed from the -mm tree.  Its filename was
     serial-assert-dtr-for-serial-console-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: serial: assert DTR for serial console devices
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Some RS-232 devices require DTR to be asserted before they can be used.  DTR
is normally asserted in uart_startup() when the port is opened.  But we don't
actually open serial console ports, so assert DTR when the port is added.

BTW:
earlyprintk and early_uart are hard coded to set DTR/RTS.

rmk says

  The only issue I can think of is the possibility for an attached modem to
  auto-answer or maybe even auto-dial before the system is ready for it to do
  so.  Might have an undesirable cost implication for some running with such a
  setup.

  Apart from that, I can't think of any other side effect of this specific
  patch.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Acked-by: Russell King <rmk@arm.linux.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Gerd Hoffmann <kraxel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/serial/serial_core.c~serial-assert-dtr-for-serial-console-devices drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-assert-dtr-for-serial-console-devices
+++ a/drivers/serial/serial_core.c
@@ -1910,6 +1910,12 @@ uart_set_options(struct uart_port *port,
 	if (flow == 'r')
 		termios.c_cflag |= CRTSCTS;
 
+	/*
+	 * some uarts on other side don't support no flow control.
+	 * So we set * DTR in host uart to make them happy
+	 */
+	port->mctrl |= TIOCM_DTR;
+
 	port->ops->set_termios(port, &termios, NULL);
 	co->cflag = termios.c_cflag;
 
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
x86_64-change-_map_single-to-static-in-pci_gartc-etc.patch
x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch
x86_64-get-mp_bus_to_node-as-early.patch
