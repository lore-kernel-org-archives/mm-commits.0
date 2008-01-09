From: akpm@linux-foundation.org
Subject: + serial-avoid-stalling-suspend-if-serial-port-wont-drain.patch added to -mm tree
Date: Tue, 08 Jan 2008 16:06:27 -0800
Message-ID: <200801090006.m0906RuM006832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53712 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835AbYAIAGp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2008 19:06:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rmk+lkml@arm.linux.org.uk, alan@lxorguk.ukuu.org.uk, rmk+kernel@arm.linux.org.uk


The patch titled
     serial: avoid stalling suspend if serial port won't drain
has been added to the -mm tree.  Its filename is
     serial-avoid-stalling-suspend-if-serial-port-wont-drain.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: avoid stalling suspend if serial port won't drain
From: Russell King <rmk+lkml@arm.linux.org.uk>

Some ports seem to be unable to drain their transmitters on shut down.  Such a
problem can occur if the port is programmed for hardware imposed flow control,
characters are in the FIFO but the CTS signal is inactive.

Normally, this isn't a problem because most places where we wait for the
transmitter to drain have a time-out.  However, there is no timeout in the
suspend path.

Give a port 30ms to drain; this is an arbitary value chosen to avoid long
delays if there are many such ports in the system, while giving a reasonable
chance for a single port to drain.  Should a port not drain within this
timeout, issue a warning.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/serial/serial_core.c~serial-avoid-stalling-suspend-if-serial-port-wont-drain drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-avoid-stalling-suspend-if-serial-port-wont-drain
+++ a/drivers/serial/serial_core.c
@@ -1977,6 +1977,7 @@ int uart_suspend_port(struct uart_driver
 
 	if (state->info && state->info->flags & UIF_INITIALIZED) {
 		const struct uart_ops *ops = port->ops;
+		int tries;
 
 		state->info->flags = (state->info->flags & ~UIF_INITIALIZED)
 				     | UIF_SUSPENDED;
@@ -1990,9 +1991,14 @@ int uart_suspend_port(struct uart_driver
 		/*
 		 * Wait for the transmitter to empty.
 		 */
-		while (!ops->tx_empty(port)) {
+		for (tries = 3; !ops->tx_empty(port) && tries; tries--) {
 			msleep(10);
 		}
+		if (!tries)
+			printk(KERN_ERR "%s%s%s%d: Unable to drain transmitter\n",
+			       port->dev ? port->dev->bus_id : "",
+			       port->dev ? ": " : "",
+			       drv->dev_name, port->line);
 
 		ops->shutdown(port);
 	}
_

Patches currently in -mm which might be from rmk+lkml@arm.linux.org.uk are

avoid-waking-up-closed-serial-ports-on-resume.patch
serial-avoid-stalling-suspend-if-serial-port-wont-drain.patch
