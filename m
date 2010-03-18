From: akpm@linux-foundation.org
Subject: [merged] usb-option-add-support-for-a-variant-of-dlink-dwm-652-u5.patch removed from -mm tree
Date: Thu, 18 Mar 2010 11:09:11 -0400
Message-ID: <201003181809.o2II9qUP007600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554Ab0CRSKQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 14:10:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: huang.ying.caritas@gmail.com, gregkh@suse.de, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/serial/option.c: add support for a variant of DLink DWM 652 U5
has been removed from the -mm tree.  Its filename was
     usb-option-add-support-for-a-variant-of-dlink-dwm-652-u5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

