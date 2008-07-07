From: akpm@linux-foundation.org
Subject: - serial-fix-serial_match_port-for-dynamic-major-tty-device-numbers.patch removed from -mm tree
Date: Sun, 06 Jul 2008 19:58:06 -0700
Message-ID: <200807070258.m672w6YU004420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886AbYGGC60 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 22:58:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.liakhovetski@gmx.de, alan@lxorguk.ukuu.org.uk, stable@kernel.org, vcgandhi1@aol.com, mm-commits@vger.kernel.org


The patch titled
     serial: fix serial_match_port() for dynamic major tty-device numbers
has been removed from the -mm tree.  Its filename was
     serial-fix-serial_match_port-for-dynamic-major-tty-device-numbers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: fix serial_match_port() for dynamic major tty-device numbers
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

As reported by Vipul Gandhi, the current serial_match_port() doesn't work
for tty-devices using dynamic major number allocation.  Fix it.

It oopses if you suspend a serial port with _dynamic_ major number.  ATM,
I think, there's only the drivers/serial/jsm/jsm_driver.c driver, that
does it in-tree.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Tested-by: Vipul Gandhi <vcgandhi1@aol.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/serial/serial_core.c~serial-fix-serial_match_port-for-dynamic-major-tty-device-numbers drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-fix-serial_match_port-for-dynamic-major-tty-device-numbers
+++ a/drivers/serial/serial_core.c
@@ -1991,7 +1991,9 @@ struct uart_match {
 static int serial_match_port(struct device *dev, void *data)
 {
 	struct uart_match *match = data;
-	dev_t devt = MKDEV(match->driver->major, match->driver->minor) + match->port->line;
+	struct tty_driver *tty_drv = match->driver->tty_driver;
+	dev_t devt = MKDEV(tty_drv->major, tty_drv->minor_start) +
+		match->port->line;
 
 	return dev->devt == devt; /* Actually, only one tty per port */
 }
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

linux-next.patch

