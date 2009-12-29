From: akpm@linux-foundation.org
Subject: [merged] usb-ftdi_sio-fix-error-message-on-close.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:33:23 -0800
Message-ID: <200912292133.nBTLXNBd008703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830AbZL2Vdd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:33:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhovold@gmail.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: ftdi_sio: fix error message on close
has been removed from the -mm tree.  Its filename was
     usb-ftdi_sio-fix-error-message-on-close.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: ftdi_sio: fix error message on close
From: Johan Hovold <jhovold@gmail.com>

Resubmitting read urb fails with -EPERM if completion handler runs while
urb is being killed on close. This should not be reported as an error.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ftdi_sio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/ftdi_sio.c~usb-ftdi_sio-fix-error-message-on-close drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c~usb-ftdi_sio-fix-error-message-on-close
+++ a/drivers/usb/serial/ftdi_sio.c
@@ -1700,7 +1700,7 @@ static int ftdi_submit_read_urb(struct u
 			   urb->transfer_buffer_length,
 			   ftdi_read_bulk_callback, port);
 	result = usb_submit_urb(urb, mem_flags);
-	if (result)
+	if (result && result != -EPERM)
 		dev_err(&port->dev,
 			"%s - failed submitting read urb, error %d\n",
 							__func__, result);
_

Patches currently in -mm which might be from jhovold@gmail.com are

linux-next.patch

