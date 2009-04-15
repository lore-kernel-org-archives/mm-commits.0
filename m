From: akpm@linux-foundation.org
Subject: + drivers-usb-serial-ti_usb_3410_5052c-ti_usb-returns-eio-when-reopening-the-device.patch added to -mm tree
Date: Wed, 15 Apr 2009 16:41:32 -0700
Message-ID: <200904152341.n3FNfWj2010587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752614AbZDOXqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Apr 2009 19:46:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: christoph.mair@gmail.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, stable@kernel.org


The patch titled
     drivers/usb/serial/ti_usb_3410_5052.c: ti_usb returns EIO when reopening the device
has been added to the -mm tree.  Its filename is
     drivers-usb-serial-ti_usb_3410_5052c-ti_usb-returns-eio-when-reopening-the-device.patch

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
Subject: drivers/usb/serial/ti_usb_3410_5052.c: ti_usb returns EIO when reopening the device
From: Christoph Mair <christoph.mair@gmail.com>

Fix regression introduced by 4a90f09b20f4622dcbff1f0e1e6bae1704f8ad8c
("tty: usb-serial krefs").

The driver works as expected until you close the device and try to reopen
it.  All you get from now on, is an I/O error.  It seems that something
isn't released correctly, because the refcount of the usbserial module
does not drop to zero, even when unloading all dependent drivers.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ti_usb_3410_5052.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/ti_usb_3410_5052.c~drivers-usb-serial-ti_usb_3410_5052c-ti_usb-returns-eio-when-reopening-the-device drivers/usb/serial/ti_usb_3410_5052.c
--- a/drivers/usb/serial/ti_usb_3410_5052.c~drivers-usb-serial-ti_usb_3410_5052c-ti_usb-returns-eio-when-reopening-the-device
+++ a/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1231,8 +1231,8 @@ static void ti_bulk_in_callback(struct u
 			tport->tp_icount.rx += urb->actual_length;
 			spin_unlock(&tport->tp_lock);
 		}
-		tty_kref_put(tty);
 	}
+	tty_kref_put(tty);
 
 exit:
 	/* continue to read unless stopping */
_

Patches currently in -mm which might be from christoph.mair@gmail.com are

drivers-usb-serial-ti_usb_3410_5052c-ti_usb-returns-eio-when-reopening-the-device.patch

