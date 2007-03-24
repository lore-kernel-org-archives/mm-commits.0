From: akpm@linux-foundation.org
Subject: + generic_serial-fix-decoding-of-baud-rate.patch added to -mm tree
Date: Sat, 24 Mar 2007 10:19:33 -0800
Message-ID: <200703241819.l2OIJXos011106@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46227 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932403AbXCXSVp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 24 Mar 2007 14:21:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsd@gentoo.org, alan@lxorguk.ukuu.org.uk, rmk@arm.linux.org.uk, stable@kernel.org


The patch titled
     generic_serial: fix decoding of baud rate
has been added to the -mm tree.  Its filename is
     generic_serial-fix-decoding-of-baud-rate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: generic_serial: fix decoding of baud rate
From: Daniel Drake <dsd@gentoo.org>

Commit d720bc4b8fc5d6d179ef094908d4fbb5e436ffad partially removed a private
implementation of baud speed decoding.  However it doesn't seem to be
complete: after the speed is decoded, it is still being used as an index to
a local speed table (array overrun, no doubt).

This was found by Graham Murray who noticed it caused a 2.6.19 regression
with the SX driver: https://bugs.gentoo.org/170554

Signed-off-by: Daniel Drake <dsd@gentoo.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/generic_serial.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN drivers/char/generic_serial.c~generic_serial-fix-decoding-of-baud-rate drivers/char/generic_serial.c
--- a/drivers/char/generic_serial.c~generic_serial-fix-decoding-of-baud-rate
+++ a/drivers/char/generic_serial.c
@@ -710,12 +710,6 @@ void gs_close(struct tty_struct * tty, s
 }
 
 
-static unsigned int     gs_baudrates[] = {
-  0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400, 4800,
-  9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600
-};
-
-
 void gs_set_termios (struct tty_struct * tty, 
                      struct ktermios * old_termios)
 {
@@ -771,7 +765,6 @@ void gs_set_termios (struct tty_struct *
 
 	baudrate = tty_get_baud_rate(tty);
 
-	baudrate = gs_baudrates[baudrate];
 	if ((tiosp->c_cflag & CBAUD) == B38400) {
 		if (     (port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
 			baudrate = 57600;
_

Patches currently in -mm which might be from dsd@gentoo.org are

generic_serial-fix-decoding-of-baud-rate.patch
git-netdev-all.patch
git-wireless.patch
