From: akpm@linux-foundation.org
Subject: + serial-fix-serial_match_port-for-dynamic-major-tty-device-numbers.patch added to -mm tree
Date: Tue, 24 Jun 2008 15:23:22 -0700
Message-ID: <200806242223.m5OMNMcu009237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752804AbYFXWX5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 18:23:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de, alan@lxorguk.ukuu.org.uk, vcgandhi1@aol.com


The patch titled
     serial: fix serial_match_port() for dynamic major tty-device numbers
has been added to the -mm tree.  Its filename is
     serial-fix-serial_match_port-for-dynamic-major-tty-device-numbers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: fix serial_match_port() for dynamic major tty-device numbers
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

As reported by Vipul Gandhi, the current serial_match_port() doesn't work
for tty-devices using dynamic major number allocation.  Fix it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Tested-by: Vipul Gandhi <vcgandhi1@aol.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
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

serial-fix-serial_match_port-for-dynamic-major-tty-device-numbers.patch

