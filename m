From: akpm@linux-foundation.org
Subject: - pl2023-remove-usb-id-4348-5523-handled-by-ch341.patch removed from -mm tree
Date: Fri, 08 Aug 2008 15:08:26 -0700
Message-ID: <200808082208.m78M8QZt031252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765410AbYHHWNJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 18:13:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tfheen@err.no, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     pl2023: remove USB id (4348:5523) handled by ch341
has been removed from the -mm tree.  Its filename was
     pl2023-remove-usb-id-4348-5523-handled-by-ch341.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pl2023: remove USB id (4348:5523) handled by ch341
From: Tollef Fog Heen <tfheen@err.no>

USB ID 4348:5523 is handled by the ch341 driver.  Remove it from the
pl2023 driver.

Reverts 002e8f2c80c6be76bb312940bc278fc10b2b2487.

Signed-off-by: Tollef Fog Heen <tfheen@err.no>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>		[needs careful checking]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/pl2303.c |    1 -
 drivers/usb/serial/pl2303.h |    4 ----
 2 files changed, 5 deletions(-)

diff -puN drivers/usb/serial/pl2303.c~pl2023-remove-usb-id-4348-5523-handled-by-ch341 drivers/usb/serial/pl2303.c
--- a/drivers/usb/serial/pl2303.c~pl2023-remove-usb-id-4348-5523-handled-by-ch341
+++ a/drivers/usb/serial/pl2303.c
@@ -90,7 +90,6 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(ALCOR_VENDOR_ID, ALCOR_PRODUCT_ID) },
 	{ USB_DEVICE(WS002IN_VENDOR_ID, WS002IN_PRODUCT_ID) },
 	{ USB_DEVICE(COREGA_VENDOR_ID, COREGA_PRODUCT_ID) },
-	{ USB_DEVICE(HL340_VENDOR_ID, HL340_PRODUCT_ID) },
 	{ USB_DEVICE(YCCABLE_VENDOR_ID, YCCABLE_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
diff -puN drivers/usb/serial/pl2303.h~pl2023-remove-usb-id-4348-5523-handled-by-ch341 drivers/usb/serial/pl2303.h
--- a/drivers/usb/serial/pl2303.h~pl2023-remove-usb-id-4348-5523-handled-by-ch341
+++ a/drivers/usb/serial/pl2303.h
@@ -107,10 +107,6 @@
 #define COREGA_VENDOR_ID	0x07aa
 #define COREGA_PRODUCT_ID	0x002a
 
-/* HL HL-340 (ID: 4348:5523) */
-#define HL340_VENDOR_ID		0x4348
-#define HL340_PRODUCT_ID	0x5523
