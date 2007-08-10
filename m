From: akpm@linux-foundation.org
Subject: - usb-serial-fix-oti6858c-segfault-in-termios-handling.patch removed from -mm tree
Date: Fri, 10 Aug 2007 15:13:13 -0700
Message-ID: <200708102213.l7AMDD6H012638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40587 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933331AbXHJWNq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Aug 2007 18:13:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tv@beamnet.de, alan@lxorguk.ukuu.org.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb-serial: fix oti6858.c segfault in termios handling
has been removed from the -mm tree.  Its filename was
     usb-serial-fix-oti6858c-segfault-in-termios-handling.patch

This patch was dropped because it was nacked

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
 1 files changed, 5 insertions(+), 6 deletions(-)

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
