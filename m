From: akpm@linux-foundation.org
Subject: + usb-option-add-support-for-a-variant-of-dlink-dwm-652-u5.patch added to -mm tree
Date: Tue, 02 Mar 2010 14:34:31 -0800
Message-ID: <201003022234.o22MYVvf001210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486Ab0CBWg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 17:36:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: huang.ying.caritas@gmail.com, gregkh@suse.de, ying.huang@intel.com


The patch titled
     drivers/usb/serial/option.c: add support for a variant of DLink DWM 652 U5
has been added to the -mm tree.  Its filename is
     usb-option-add-support-for-a-variant-of-dlink-dwm-652-u5.patch

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
Subject: drivers/usb/serial/option.c: add support for a variant of DLink DWM 652 U5
From: Huang Ying <huang.ying.caritas@gmail.com>

I found a DLink DWM 652 U5 USB 3G modem has product ID 0xce1e instead of
orignal 0xce16.  The new ID is added.

And I found there are two entries for 0xce16, one has raw number, the
other has symbol DLINK_PRODUCT_DWM_652_U5.  This is fixed too.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/option.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/usb/serial/option.c~usb-option-add-support-for-a-variant-of-dlink-dwm-652-u5 drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~usb-option-add-support-for-a-variant-of-dlink-dwm-652-u5
+++ a/drivers/usb/serial/option.c
@@ -309,6 +309,7 @@ static int  option_resume(struct usb_ser
 #define DLINK_VENDOR_ID				0x1186
 #define DLINK_PRODUCT_DWM_652			0x3e04
 #define DLINK_PRODUCT_DWM_652_U5		0xce16
+#define DLINK_PRODUCT_DWM_652_U5A		0xce1e
 
 #define QISDA_VENDOR_ID				0x1da5
 #define QISDA_PRODUCT_H21_4512			0x4512
@@ -659,6 +660,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
 	{ USB_DEVICE(DLINK_VENDOR_ID, DLINK_PRODUCT_DWM_652) },
 	{ USB_DEVICE(ALINK_VENDOR_ID, DLINK_PRODUCT_DWM_652_U5) }, /* Yes, ALINK_VENDOR_ID */
+	{ USB_DEVICE(ALINK_VENDOR_ID, DLINK_PRODUCT_DWM_652_U5A) },
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H21_4512) },
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H21_4523) },
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H20_4515) },
@@ -666,7 +668,6 @@ static const struct usb_device_id option
 	{ USB_DEVICE(TOSHIBA_VENDOR_ID, TOSHIBA_PRODUCT_G450) },
 	{ USB_DEVICE(TOSHIBA_VENDOR_ID, TOSHIBA_PRODUCT_HSDPA_MINICARD ) }, /* Toshiba 3G HSDPA == Novatel Expedite EU870D MiniCard */
 	{ USB_DEVICE(ALINK_VENDOR_ID, 0x9000) },
-	{ USB_DEVICE(ALINK_VENDOR_ID, 0xce16) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ALINK_VENDOR_ID, ALINK_PRODUCT_3GU, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S) },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
_

Patches currently in -mm which might be from huang.ying.caritas@gmail.com are

usb-option-add-support-for-a-variant-of-dlink-dwm-652-u5.patch

