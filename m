From: akpm@linux-foundation.org
Subject: - usbserial-fix-inconsistent-lock-state.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:49:28 -0800
Message-ID: <200711262149.lAQLnSrR024765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47785 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756110AbXKZV6k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:58:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bbpetkov@yahoo.de, greg@kroah.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     usbserial: fix inconsistent lock state
has been removed from the -mm tree.  Its filename was
     usbserial-fix-inconsistent-lock-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usbserial: fix inconsistent lock state
From: Borislav Petkov <bbpetkov@yahoo.de>

In commit acd2a847e7fee7df11817f67dba75a2802793e5d usb_serial_generic_write()
disables interrupts when taking &port->lock which is also taken in
usb_serial_generic_read_bulk_callback() resulting in an inconsistent lock state
due to the latter not disabling interrupts on the local cpu. Fix that by
disabling interrupts in the latter call site also.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/generic.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/usb/serial/generic.c~usbserial-fix-inconsistent-lock-state drivers/usb/serial/generic.c
--- a/drivers/usb/serial/generic.c~usbserial-fix-inconsistent-lock-state
+++ a/drivers/usb/serial/generic.c
@@ -327,6 +327,7 @@ void usb_serial_generic_read_bulk_callba
 	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
 	unsigned char *data = urb->transfer_buffer;
 	int status = urb->status;
+	unsigned long flags;
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
 
@@ -339,11 +340,11 @@ void usb_serial_generic_read_bulk_callba
 	usb_serial_debug_data(debug, &port->dev, __FUNCTION__, urb->actual_length, data);
 
 	/* Throttle the device if requested by tty */
-	spin_lock(&port->lock);
+	spin_lock_irqsave(&port->lock, flags);
 	if (!(port->throttled = port->throttle_req))
 		/* Handle data and continue reading from device */
 		flush_and_resubmit_read_urb(port);
-	spin_unlock(&port->lock);
+	spin_unlock_irqrestore(&port->lock, flags);
 }
 EXPORT_SYMBOL_GPL(usb_serial_generic_read_bulk_callback);
 
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

revert-keyspan-init-termios-properly.patch
