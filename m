From: akpm@linux-foundation.org
Subject: [merged] usb-serial-fix-memory-leak-in-generic-driver.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:28:34 -0800
Message-ID: <201001212128.o0LLSYlm030723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755359Ab0AUV3R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:29:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhovold@gmail.com, greg@kroah.com, jason.wessel@windriver.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     usb: serial: fix memory leak in generic driver
has been removed from the -mm tree.  Its filename was
     usb-serial-fix-memory-leak-in-generic-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: serial: fix memory leak in generic driver
From: Johan Hovold <jhovold@gmail.com>

Fix a regression introduced by commit
715b1dc01fe44537e8fce9566e4bb48d6821d84b ("USB: usb_debug,
usb_generic_serial: implement multi urb write").

URB transfer buffer was never freed when using multi-urb writes. 
Currently the only driver enabling multi-urb writes is usb_debug.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/generic.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/usb/serial/generic.c~usb-serial-fix-memory-leak-in-generic-driver drivers/usb/serial/generic.c
--- a/drivers/usb/serial/generic.c~usb-serial-fix-memory-leak-in-generic-driver
+++ a/drivers/usb/serial/generic.c
@@ -492,6 +492,8 @@ void usb_serial_generic_write_bulk_callb
 	dbg("%s - port %d", __func__, port->number);
 
 	if (port->serial->type->max_in_flight_urbs) {
+		kfree(urb->transfer_buffer);
+
 		spin_lock_irqsave(&port->lock, flags);
 		--port->urbs_in_flight;
 		port->tx_bytes_flight -= urb->transfer_buffer_length;
_

Patches currently in -mm which might be from jhovold@gmail.com are

origin.patch
linux-next.patch

