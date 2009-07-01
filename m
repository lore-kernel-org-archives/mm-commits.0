From: akpm@linux-foundation.org
Subject: + ti_usb_3410_5052c-fix-uninitialised-variable-in-ti_do_download.patch added to -mm tree
Date: Wed, 01 Jul 2009 15:23:26 -0700
Message-ID: <200907012223.n61MNQZd004768@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695AbZGAWX6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 18:23:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oliver@neukum.org, greg@kroah.com, stern@rowland.harvard.edu


The patch titled
     ti_usb_3410_5052.c: fix uninitialised variable in ti_do_download
has been added to the -mm tree.  Its filename is
     ti_usb_3410_5052c-fix-uninitialised-variable-in-ti_do_download.patch

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
Subject: ti_usb_3410_5052.c: fix uninitialised variable in ti_do_download
From: Oliver Neukum <oliver@neukum.org>

drivers/usb/serial/ti_usb_3410_5052.c: In function 'ti_startup':
drivers/usb/serial/ti_usb_3410_5052.c:1661: warning: 'status' may be used uninitialized in this function

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ti_usb_3410_5052.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/ti_usb_3410_5052.c~ti_usb_3410_5052c-fix-uninitialised-variable-in-ti_do_download drivers/usb/serial/ti_usb_3410_5052.c
--- a/drivers/usb/serial/ti_usb_3410_5052.c~ti_usb_3410_5052c-fix-uninitialised-variable-in-ti_do_download
+++ a/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1657,7 +1657,7 @@ static int ti_do_download(struct usb_dev
 	u8 cs = 0;
 	int done;
 	struct ti_firmware_header *header;
-	int status;
+	int status = 0;
 	int len;
 
 	for (pos = sizeof(struct ti_firmware_header); pos < size; pos++)
_

Patches currently in -mm which might be from oliver@neukum.org are

ti_usb_3410_5052c-fix-uninitialised-variable-in-ti_do_download.patch
drivers-usb-serial-ti_usb_3410_5052c-fix-uninitialied-var-warning.patch

