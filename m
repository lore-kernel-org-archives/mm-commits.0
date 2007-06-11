From: akpm@linux-foundation.org
Subject: + serial-assert-dtr-for-serial-console-devices.patch added to -mm tree
Date: Mon, 11 Jun 2007 13:17:08 -0700
Message-ID: <200706112017.l5BKH9xr028248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37618 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094AbXFKURb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 16:17:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, bjorn.helgaas@hp.com, kraxel@suse.de, rmk@arm.linux.org.uk, yinghai.lu@Sun.COM


The patch titled
     serial: assert DTR for serial console devices
has been added to the -mm tree.  Its filename is
     serial-assert-dtr-for-serial-console-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: assert DTR for serial console devices
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Some RS-232 devices require DTR to be asserted before they can be used.  DTR
is normally asserted in uart_startup() when the port is opened.  But we don't
actually open serial console ports, so assert DTR when the port is added.

BTW:
earlyprintk and early_uart are hard coded to set DTR/RTS.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Acked-by: Russell King <rmk@arm.linux.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Gerd Hoffmann <kraxel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    6 ++++++
 1 files changed, 6 insertions(+)

diff -puN drivers/serial/serial_core.c~serial-assert-dtr-for-serial-console-devices drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-assert-dtr-for-serial-console-devices
+++ a/drivers/serial/serial_core.c
@@ -1918,6 +1918,12 @@ uart_set_options(struct uart_port *port,
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

console-more-buf-for-index-parsing.patch
console-console-handover-to-preferred-console.patch
serial-convert-early_uart-to-earlycon-for-8250.patch
serial-convert-early_uart-to-earlycon-for-8250-fix.patch
serial-assert-dtr-for-serial-console-devices.patch
