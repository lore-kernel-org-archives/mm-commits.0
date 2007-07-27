From: akpm@linux-foundation.org
Subject: + usb-serial-fix-oti6858c-segfault-in-termios-handling.patch added to -mm tree
Date: Thu, 26 Jul 2007 21:47:56 -0700
Message-ID: <200707270447.l6R4luaC005951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60678 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270AbXG0EsK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 00:48:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tv@beamnet.de, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     usb-serial: fix oti6858.c segfault in termios handling
has been added to the -mm tree.  Its filename is
     usb-serial-fix-oti6858c-segfault-in-termios-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb-serial: fix oti6858.c segfault in termios handling
From: Thomas Viehmann <tv@beamnet.de>

The oti6858 usb serial driver should use kernel_termios_to_user_termios/
user_termios_to_kernel_termios to avoid segfaults because the kernel uses a
structure differing from that of user space with a different size.

Signed-off-by: Thomas Viehmann <tv@beamnet.de>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/oti6858.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/usb/serial/oti6858.c~usb-serial-fix-oti6858c-segfault-in-termios-handling drivers/usb/serial/oti6858.c
--- a/drivers/usb/serial/oti6858.c~usb-serial-fix-oti6858c-segfault-in-termios-handling
+++ a/drivers/usb/serial/oti6858.c
@@ -818,19 +818,18 @@ static int oti6858_ioctl(struct usb_seri
 
 	switch (cmd) {
 		case TCGETS:
-			if (copy_to_user(user_arg, port->tty->termios,
-						sizeof(struct ktermios))) {
+			if (kernel_termios_to_user_termios(
+					(struct ktermios __user *)arg,
+					port->tty->termios))
 				return -EFAULT;
-			}
 			return 0;
 
 		case TCSETS:
 		case TCSETSW:	/* FIXME: this is not the same! */
 		case TCSETSF:	/* FIXME: this is not the same! */
-			if (copy_from_user(port->tty->termios, user_arg,
-						sizeof(struct ktermios))) {
+			if (user_termios_to_kernel_termios(port->tty->termios,
+					(struct ktermios __user *)arg))
 				return -EFAULT;
-			}
 			oti6858_set_termios(port, NULL);
 			return 0;
 
_

Patches currently in -mm which might be from tv@beamnet.de are

usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
