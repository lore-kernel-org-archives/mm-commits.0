From: akpm@linux-foundation.org
Subject: + drivers-usb-gadget-amd5536udcc-fix-error-path.patch added to -mm tree
Date: Mon, 04 Oct 2010 15:16:06 -0700
Message-ID: <201010042216.o94MG6j8018802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642Ab0JDWQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 18:16:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rahul.ruikar@gmail.com, dahlmann.thomas@arcor.de, david-b@pacbell.net, greg@kroah.com


The patch titled
     drivers/usb/gadget/amd5536udc.c: fix error path
has been added to the -mm tree.  Its filename is
     drivers-usb-gadget-amd5536udcc-fix-error-path.patch

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
Subject: drivers/usb/gadget/amd5536udc.c: fix error path
From: Rahul Ruikar <rahul.ruikar@gmail.com>

In function udc_probe() call put_device() when device_register() fails.

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
Acked-by: Thomas Dahlmann <dahlmann.thomas@arcor.de>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/amd5536udc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/usb/gadget/amd5536udc.c~drivers-usb-gadget-amd5536udcc-fix-error-path drivers/usb/gadget/amd5536udc.c
--- a/drivers/usb/gadget/amd5536udc.c~drivers-usb-gadget-amd5536udcc-fix-error-path
+++ a/drivers/usb/gadget/amd5536udc.c
@@ -3383,8 +3383,10 @@ static int udc_probe(struct udc *dev)
 	udc = dev;
 
 	retval = device_register(&dev->gadget.dev);
-	if (retval)
+	if (retval) {
+		put_device(&dev->gadget.dev);
 		goto finished;
+	}
 
 	/* timer init */
 	init_timer(&udc_timer);
_

Patches currently in -mm which might be from rahul.ruikar@gmail.com are

linux-next.patch
drivers-usb-gadget-amd5536udcc-fix-error-path.patch
drivers-misc-phantomc-add-missing-warning-messages-in-phantom_probe.patch

