From: akpm@linux-foundation.org
Subject: + serial-assert-dtr-for-serial-console-devices.patch added to -mm tree
Date: Thu, 31 May 2007 17:02:22 -0700
Message-ID: <200706010002.l5102Mtp031212@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757530AbXFAACg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 20:02:36 -0400
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
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Gerd Hoffmann <kraxel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/serial/serial_core.c~serial-assert-dtr-for-serial-console-devices drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-assert-dtr-for-serial-console-devices
+++ a/drivers/serial/serial_core.c
@@ -2303,8 +2303,14 @@ int uart_add_one_port(struct uart_driver
 	 * It may be that the port was not available.
 	 */
 	if (port->type != PORT_UNKNOWN &&
-	    port->cons && !(port->cons->flags & CON_ENABLED))
+	    port->cons && !(port->cons->flags & CON_ENABLED)) {
+		/*
+		 * We normally assert DTR when a port is opened, but serial
+		 * console devices aren't actually opened, so do it here.
+		 */
+		uart_set_mctrl(port, TIOCM_DTR);
 		register_console(port->cons);
+	}
 
 	/*
 	 * Ensure UPF_DEAD is not set.
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

x86_64-change-early_ioremap-to-static.patch
console-more-buf-for-index-parsing.patch
console-console-handover-to-preferred-console.patch
serial-convert-early_uart-to-earlycon-for-8250.patch
serial-assert-dtr-for-serial-console-devices.patch
