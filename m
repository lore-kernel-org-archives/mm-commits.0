From: akpm@linux-foundation.org
Subject: + usb-optionc-to-support-alcatel-x060s-x200-broadband-modems.patch added to -mm tree
Date: Mon, 27 Jul 2009 14:16:45 -0700
Message-ID: <200907272116.n6RLGjgx018705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754973AbZG0V1M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jul 2009 17:27:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmartinj@iname.com, greg@kroah.com


The patch titled
     usb: option.c to support Alcatel X060S/X200 broadband modems
has been added to the -mm tree.  Its filename is
     usb-optionc-to-support-alcatel-x060s-x200-broadband-modems.patch

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
Subject: usb: option.c to support Alcatel X060S/X200 broadband modems
From: Javier Martin <jmartinj@iname.com>

Add support for the Alcatel X060S/X200 broadband modems to the option
driver.  The device starts in cd-rom emulation mode (1bbb:f000) and
requires the use of the usb_modeswitch tool to switch it to modem mode
(1bbb:0000).

Signed-off-by: Javier Martin <jmartinj@iname.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/option.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/usb/serial/option.c~usb-optionc-to-support-alcatel-x060s-x200-broadband-modems drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~usb-optionc-to-support-alcatel-x060s-x200-broadband-modems
+++ a/drivers/usb/serial/option.c
@@ -324,6 +324,11 @@ static int  option_resume(struct usb_ser
 #define ALINK_VENDOR_ID				0x1e0e
 #define ALINK_PRODUCT_3GU			0x9200
 
+/* ALCATEL PRODUCTS */
+#define ALCATEL_VENDOR_ID			0x1bbb
+#define ALCATEL_PRODUCT_X060S			0x0000
+
+
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -580,6 +585,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(TOSHIBA_VENDOR_ID, TOSHIBA_PRODUCT_HSDPA_MINICARD ) }, /* Toshiba 3G HSDPA == Novatel Expedite EU870D MiniCard */
 	{ USB_DEVICE(ALINK_VENDOR_ID, 0x9000) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ALINK_VENDOR_ID, ALINK_PRODUCT_3GU, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
_

Patches currently in -mm which might be from jmartinj@iname.com are

usb-optionc-to-support-alcatel-x060s-x200-broadband-modems.patch

