From: akpm@linux-foundation.org
Subject: + sis-fb-driver-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels.patch added to -mm tree
Date: Mon, 05 Nov 2007 18:24:00 -0800
Message-ID: <200711060224.lA62O0pB031666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56292 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751938AbXKFCYE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 21:24:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, adaplas@pol.net, greg@kroah.com, thomas@winischhofer.net


The patch titled
     sis FB driver: *_ioctl32_conversion functions do not exist in recent kernels
has been added to the -mm tree.  Its filename is
     sis-fb-driver-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sis FB driver: *_ioctl32_conversion functions do not exist in recent kernels
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Remove dead code while at it.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Cc: Greg KH <greg@kroah.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/sisusbvga/sisusb.c |   27 --------------------------
 drivers/usb/misc/sisusbvga/sisusb.h |    3 --
 2 files changed, 30 deletions(-)

diff -puN drivers/usb/misc/sisusbvga/sisusb.c~sis-fb-driver-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels drivers/usb/misc/sisusbvga/sisusb.c
--- a/drivers/usb/misc/sisusbvga/sisusb.c~sis-fb-driver-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels
+++ a/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3195,20 +3195,6 @@ static int sisusb_probe(struct usb_inter
 
 	sisusb->present = 1;
 
-#ifdef SISUSB_OLD_CONFIG_COMPAT
-	{
-	int ret;
-	/* Our ioctls are all "32/64bit compatible" */
-	ret =  register_ioctl32_conversion(SISUSB_GET_CONFIG_SIZE, NULL);
-	ret |= register_ioctl32_conversion(SISUSB_GET_CONFIG,      NULL);
-	ret |= register_ioctl32_conversion(SISUSB_COMMAND,         NULL);
-	if (ret)
-		dev_err(&sisusb->sisusb_dev->dev, "Error registering ioctl32 translations\n");
-	else
-		sisusb->ioctl32registered = 1;
-	}
-#endif
-
 	if (dev->speed == USB_SPEED_HIGH) {
 		int initscreen = 1;
 #ifdef INCL_SISUSB_CON
@@ -3271,19 +3257,6 @@ static void sisusb_disconnect(struct usb
 
 	usb_set_intfdata(intf, NULL);
 
-#ifdef SISUSB_OLD_CONFIG_COMPAT
-	if (sisusb->ioctl32registered) {
-		int ret;
-		sisusb->ioctl32registered = 0;
-		ret =  unregister_ioctl32_conversion(SISUSB_GET_CONFIG_SIZE);
-		ret |= unregister_ioctl32_conversion(SISUSB_GET_CONFIG);
-		ret |= unregister_ioctl32_conversion(SISUSB_COMMAND);
-		if (ret) {
-			dev_err(&sisusb->sisusb_dev->dev, "Error unregistering ioctl32 translations\n");
-		}
-	}
-#endif
-
 	sisusb->present = 0;
 	sisusb->ready = 0;
 
diff -puN drivers/usb/misc/sisusbvga/sisusb.h~sis-fb-driver-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels drivers/usb/misc/sisusbvga/sisusb.h
--- a/drivers/usb/misc/sisusbvga/sisusb.h~sis-fb-driver-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels
+++ a/drivers/usb/misc/sisusbvga/sisusb.h
@@ -120,9 +120,6 @@ struct sisusb_usb_data {
 	int isopen;		/* !=0 if open */
 	int present;		/* !=0 if device is present on the bus */
 	int ready;		/* !=0 if device is ready for userland */
-#ifdef SISUSB_OLD_CONFIG_COMPAT
-	int ioctl32registered;
-#endif
 	int numobufs;		/* number of obufs = number of out urbs */
 	char *obuf[NUMOBUFS], *ibuf;	/* transfer buffers */
 	int obufsize, ibufsize;
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

sis-fb-driver-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels.patch
sisusb-_ioctl32_conversion-functions-do-not.patch
