From: akpm@linux-foundation.org
Subject: + usb-serial-console-add-device-function.patch added to -mm tree
Date: Fri, 14 Nov 2008 14:36:52 -0800
Message-ID: <200811142236.mAEMaq3l029875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751466AbYKNWhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 17:37:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kexin.hao@windriver.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, stable@kernel.org


The patch titled
     usb serial console: add device function 
has been added to the -mm tree.  Its filename is
     usb-serial-console-add-device-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb serial console: add device function 
From: Kevin Hao <kexin.hao@windriver.com>

Add device funtion for usb serial console, so we can open /dev/console
when we use a usb serial device as console.

Signed-off-by: Kevin Hao <kexin.hao@windriver.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/console.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN drivers/usb/serial/console.c~usb-serial-console-add-device-function drivers/usb/serial/console.c
--- a/drivers/usb/serial/console.c~usb-serial-console-add-device-function
+++ a/drivers/usb/serial/console.c
@@ -241,12 +241,25 @@ static void usb_console_write(struct con
 	}
 }
 
+static struct tty_driver *usb_console_device(struct console *co, int *index)
+{
+	struct tty_driver **p = (struct tty_driver **)co->data;
+
+	if (!*p)
+		return NULL;
+
+	*index = co->index;
+	return (struct tty_driver *)(*p);
+}
+
 static struct console usbcons = {
 	.name =		"ttyUSB",
 	.write =	usb_console_write,
+	.device =	usb_console_device,
 	.setup =	usb_console_setup,
 	.flags =	CON_PRINTBUFFER,
 	.index =	-1,
+	.data = 	&usb_serial_tty_driver,
 };
 
 void usb_serial_console_disconnect(struct usb_serial *serial)
_

Patches currently in -mm which might be from kexin.hao@windriver.com are

usb-serial-console-setup-initialise-tty-kref.patch
usb-serial-console-add-device-function.patch
usb-serial-console-add-device-function-fix.patch

