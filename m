From: akpm@linux-foundation.org
Subject: + serial-set-dtr-in-uart-for-kernel-serial-console.patch added to -mm tree
Date: Wed, 30 May 2007 12:00:15 -0700
Message-ID: <200705301900.l4UJ0FIQ002275@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754998AbXE3TA1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 15:00:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, bjorn.helgaas@hp.com, rmk@arm.linux.org.uk, yinghai.lu@Sun.COM


The patch titled
     serial: set DTR in uart for kernel serial console
has been added to the -mm tree.  Its filename is
     serial-set-dtr-in-uart-for-kernel-serial-console.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: set DTR in uart for kernel serial console
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Some UARTs on other side need host uart DTR is set, otherwise will not
receive char from the host that kernel is runing during kernel boot stage.

BTW:
earlyprintk and early_uart are hard coded to set DTR/RTS.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/serial/serial_core.c~serial-set-dtr-in-uart-for-kernel-serial-console drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-set-dtr-in-uart-for-kernel-serial-console
+++ a/drivers/serial/serial_core.c
@@ -2303,8 +2303,14 @@ int uart_add_one_port(struct uart_driver
 	 * It may be that the port was not available.
 	 */
 	if (port->type != PORT_UNKNOWN &&
-	    port->cons && !(port->cons->flags & CON_ENABLED))
+	    port->cons && !(port->cons->flags & CON_ENABLED)) {
+		/*
+		 * some uarts on other side don't support no flow control.
+		 * So we set DTR in host uart to make them happy  --- YHLU
+		 */
+		port->mctrl |= TIOCM_DTR;
 		register_console(port->cons);
+	}
 
 	/*
 	 * Ensure UPF_DEAD is not set.
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

console-more-buf-for-index-parsing.patch
console-console-handover-to-preferred-console.patch
serial-convert-early_uart-to-earlycon-for-8250.patch
serial-set-dtr-in-uart-for-kernel-serial-console.patch
