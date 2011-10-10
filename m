From: akpm@google.com
Subject: + usb-gadget-fix-langwell_udcc-build-error.patch added to -mm tree
Date: Mon, 10 Oct 2011 15:47:37 -0700
Message-ID: <201110102247.p9AMlbJ2013424@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:13539 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab1JJWrs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2011 18:47:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, balbi@ti.com, greg@kroah.com


The patch titled
     Subject: usb gadget: fix langwell_udc.c build error
has been added to the -mm tree.  Its filename is
     usb-gadget-fix-langwell_udcc-build-error.patch

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
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: usb gadget: fix langwell_udc.c build error

Move function to fix langwell_udc.c build error:

drivers/usb/gadget/langwell_udc.c: In function 'show_langwell_udc':
drivers/usb/gadget/langwell_udc.c:1693:3: error: implicit declaration of function 'lpm_device_speed'
drivers/usb/gadget/langwell_udc.c: At top level:
drivers/usb/gadget/langwell_udc.c:2637:37: error: conflicting types for 'lpm_device_speed'
drivers/usb/gadget/langwell_udc.c:1693:20: note: previous implicit declaration of 'lpm_device_speed' was here

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/usb/gadget/langwell_udc.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN drivers/usb/gadget/langwell_udc.c~usb-gadget-fix-langwell_udcc-build-error drivers/usb/gadget/langwell_udc.c
--- a/drivers/usb/gadget/langwell_udc.c~usb-gadget-fix-langwell_udcc-build-error
+++ a/drivers/usb/gadget/langwell_udc.c
@@ -1562,6 +1562,20 @@ static ssize_t show_function(struct devi
 static DEVICE_ATTR(function, S_IRUGO, show_function, NULL);
 
 
+static inline enum usb_device_speed lpm_device_speed(u32 reg)
+{
+	switch (LPM_PSPD(reg)) {
+	case LPM_SPEED_HIGH:
+		return USB_SPEED_HIGH;
+	case LPM_SPEED_FULL:
+		return USB_SPEED_FULL;
+	case LPM_SPEED_LOW:
+		return USB_SPEED_LOW;
+	default:
+		return USB_SPEED_UNKNOWN;
+	}
+}
+
 /* device "langwell_udc" sysfs attribute file */
 static ssize_t show_langwell_udc(struct device *_dev,
 		struct device_attribute *attr, char *buf)
@@ -2634,20 +2648,6 @@ done:
 	dev_vdbg(&dev->pdev->dev, "<--- %s()\n", __func__);
 }
 
-static inline enum usb_device_speed lpm_device_speed(u32 reg)
-{
-	switch (LPM_PSPD(reg)) {
-	case LPM_SPEED_HIGH:
-		return USB_SPEED_HIGH;
-	case LPM_SPEED_FULL:
-		return USB_SPEED_FULL;
-	case LPM_SPEED_LOW:
-		return USB_SPEED_LOW;
-	default:
-		return USB_SPEED_UNKNOWN;
-	}
-}
