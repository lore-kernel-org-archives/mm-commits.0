From: akpm@linux-foundation.org
Subject: + usbserial-fix-inconsistent-lock-state.patch added to -mm tree
Date: Thu, 01 Nov 2007 15:54:28 -0700
Message-ID: <200711012254.lA1MsS0p019667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52751 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753500AbXKAWyd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 18:54:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bbpetkov@yahoo.de, greg@kroah.com, jkosina@suse.cz


The patch titled
     usbserial: fix inconsistent lock state
has been added to the -mm tree.  Its filename is
     usbserial-fix-inconsistent-lock-state.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fs-partitions-checkc-add-error-handling-for.patch
usbserial-fix-inconsistent-lock-state.patch
