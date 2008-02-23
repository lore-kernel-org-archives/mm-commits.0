From: akpm@linux-foundation.org
Subject: - usb-serial-move-zte-mf330-from-sierra-to-option.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:14 -0800
Message-ID: <200802232023.m1NKNETV013498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762322AbYBWU2y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@sierrawireless.com, greg@kroah.com, klloyd@sierrawireless.com, mm-commits@vger.kernel.org


The patch titled
     usb: serial: move zte MF330 from sierra to option
has been removed from the -mm tree.  Its filename was
     usb-serial-move-zte-mf330-from-sierra-to-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: serial: move zte MF330 from sierra to option
From: Kevin Lloyd <linux@sierrawireless.com>

Move the Onda H600/ZTE MF33 device from the sierra driver to the option
driver.

The reason it was moved is because the sierra driver is starting to support
more and more sierra proprietary features, so it makes more sense to keep
sierra only devices in there.

Signed-off-by: Kevin Lloyd <klloyd@sierrawireless.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/option.c |    3 +++
 drivers/usb/serial/sierra.c |    1 -
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/usb/serial/option.c~usb-serial-move-zte-mf330-from-sierra-to-option drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~usb-serial-move-zte-mf330-from-sierra-to-option
+++ a/drivers/usb/serial/option.c
@@ -121,6 +121,8 @@ static int  option_send_setup(struct usb
 #define BANDRICH_PRODUCT_C100_1			0x1002
 #define BANDRICH_PRODUCT_C100_2			0x1003
 
+#define QUALCOMM_VENDOR_ID			0x05C6
+
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -187,6 +189,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
 	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_1) },
 	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_2) },
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
diff -puN drivers/usb/serial/sierra.c~usb-serial-move-zte-mf330-from-sierra-to-option drivers/usb/serial/sierra.c
--- a/drivers/usb/serial/sierra.c~usb-serial-move-zte-mf330-from-sierra-to-option
+++ a/drivers/usb/serial/sierra.c
@@ -178,7 +178,6 @@ static struct usb_device_id id_table [] 
 
 	{ USB_DEVICE(0x1199, 0x0112), .driver_info = DEVICE_1_PORT }, /* Sierra Wireless AirCard 580 */
 	{ USB_DEVICE(0x0F3D, 0x0112), .driver_info = DEVICE_1_PORT }, /* Airprime/Sierra PC 5220 */
-	{ USB_DEVICE(0x05C6, 0x6613), .driver_info = DEVICE_1_PORT }, /* Onda H600/ZTE MF330 */
 
 	{ USB_DEVICE(0x1199, 0x0FFF), .driver_info = DEVICE_INSTALLER},
 	{ }
_

Patches currently in -mm which might be from linux@sierrawireless.com are

origin.patch
