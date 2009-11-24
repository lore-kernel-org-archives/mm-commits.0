From: akpm@linux-foundation.org
Subject: + usb-ftdi_sio-fix-error-message-on-close.patch added to -mm tree
Date: Tue, 24 Nov 2009 12:38:28 -0800
Message-ID: <200911242038.nAOKcS8u018494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932646AbZKXUjC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 15:39:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jhovold@gmail.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     usb: ftdi_sio: fix error message on close
has been added to the -mm tree.  Its filename is
     usb-ftdi_sio-fix-error-message-on-close.patch

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
@@ -1686,7 +1686,7 @@ static int ftdi_submit_read_urb(struct u
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

usb-ftdi_sio-fix-error-message-on-close.patch
usb-ftdi_sio-remove-obsolete-comment.patch

