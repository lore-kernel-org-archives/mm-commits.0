From: akpm@linux-foundation.org
Subject: + usbconsole-fix-regression-in-usb-console-on-kernel-boot.patch added to -mm tree
Date: Mon, 29 Jun 2009 16:26:02 -0700
Message-ID: <200906292326.n5TNQ2da005139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759782AbZF2X0c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 19:26:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jason.wessel@windriver.com, alan@linux.intel.com, greg@kroah.com


The patch titled
     usb,console: fix regression in usb console on kernel boot
has been added to the -mm tree.  Its filename is
     usbconsole-fix-regression-in-usb-console-on-kernel-boot.patch

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
Subject: usb,console: fix regression in usb console on kernel boot
From: Jason Wessel <jason.wessel@windriver.com>

Commit 335f8514f200e63d689113d29cb7253a5c282967 ("tty: Bring the usb tty
port structure into more use") introduced a regression which stopped usb
consoles from working correctly as a kernel boot console as well as
interactive login device.

The addition of the serial_close() which in turn calls
tty_port_close_start() will change the reference count of port.count and
warn about it.  The usb console code had previously incremented the
port.count to indicate it was making use of the device as a console and
the forced change causes a double open on the usb device which leads to a
non obvious kernel oops later on when the tty is freed.

To fix the problem instead make use of port->console to track if the port
is in fact an active console port to avoid double initialization of the
usb serial device.  The port.count is incremented and decremented only
with in the scope of usb_console_setup() for the purpose of the low level
driver initialization.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/console.c    |   13 +++++++------
 drivers/usb/serial/usb-serial.c |    3 ++-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/usb/serial/console.c~usbconsole-fix-regression-in-usb-console-on-kernel-boot drivers/usb/serial/console.c
--- a/drivers/usb/serial/console.c~usbconsole-fix-regression-in-usb-console-on-kernel-boot
+++ a/drivers/usb/serial/console.c
@@ -169,9 +169,11 @@ static int usb_console_setup(struct cons
 			kfree(tty);
 		}
 	}
-	/* So we know not to kill the hardware on a hangup on this
-	   port. We have also bumped the use count by one so it won't go
-	   idle */
+	/* Now that any required fake tty operations are completed restore
+	 * the tty port count */
+	--port->port.count;
+	/* The console is special in terms of closing the device so
+	 * indicate this port is now acting as a system console. */
 	port->console = 1;
 	retval = 0;
 
@@ -204,7 +206,7 @@ static void usb_console_write(struct con
 
 	dbg("%s - port %d, %d byte(s)", __func__, port->number, count);
 
-	if (!port->port.count) {
+	if (!port->console) {
 		dbg("%s - port not opened", __func__);
 		return;
 	}
@@ -300,8 +302,7 @@ void usb_serial_console_exit(void)
 {
 	if (usbcons_info.port) {
 		unregister_console(&usbcons);
-		if (usbcons_info.port->port.count)
-			usbcons_info.port->port.count--;
+		usbcons_info.port->console = 0;
 		usbcons_info.port = NULL;
 	}
 }
diff -puN drivers/usb/serial/usb-serial.c~usbconsole-fix-regression-in-usb-console-on-kernel-boot drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c~usbconsole-fix-regression-in-usb-console-on-kernel-boot
+++ a/drivers/usb/serial/usb-serial.c
@@ -220,7 +220,8 @@ static int serial_open (struct tty_struc
 	tty->driver_data = port;
 	tty_port_tty_set(&port->port, tty);
 
-	if (port->port.count == 1) {
+	/* If the console is attached, the device is already open */
+	if (port->port.count == 1 && !port->console) {
 
 		/* lock this module before we call it
 		 * this may fail, which means we must bail out,
_

Patches currently in -mm which might be from jason.wessel@windriver.com are

linux-next.patch
usbconsole-fix-regression-in-usb-console-on-kernel-boot.patch
usb-serial-regression-fix-to-move-sysrq-from-hot-path.patch
frv-duplicate-output_buffer-of-e03.patch

