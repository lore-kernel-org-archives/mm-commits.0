From: akpm@linux-foundation.org
Subject: - serial-set-dtr-in-uart-for-kernel-serial-console.patch removed from -mm tree
Date: Wed, 30 May 2007 20:16:14 -0700
Message-ID: <200705310316.l4V3GDDO011286@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756053AbXEaDQ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 23:16:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, bjorn.helgaas@hp.com, rmk@arm.linux.org.uk, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     serial: set DTR in uart for kernel serial console
has been removed from the -mm tree.  Its filename was
     serial-set-dtr-in-uart-for-kernel-serial-console.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: serial: set DTR in uart for kernel serial console
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

serial-set-dtr-in-uart-for-kernel-serial-console.patch
