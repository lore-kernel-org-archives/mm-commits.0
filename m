From: akpm@linux-foundation.org
Subject: - usb-mos7840c-add-support-for-the-mos7820-7840-based-bb-usb-rs485-converter.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:09:49 -0800
Message-ID: <200803042009.m24K9nPg026790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932536AbYCDUKX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:10:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.ludlow@bay.ws, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: mos7840.c: add support for the mos7820/7840-based B&B USB/RS485 converter
has been removed from the -mm tree.  Its filename was
     usb-mos7840c-add-support-for-the-mos7820-7840-based-bb-usb-rs485-converter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: mos7840.c: add support for the mos7820/7840-based B&B USB/RS485 converter
From: David Ludlow <dave.ludlow@bay.ws>

Add support for the mos7820/7840-based B&B USOPTL4_2/USOPTL4_4 USB/RS485
converter to mos7840.c.

DTR needs to be set/raised to receive and clear/lowered to send, as per the
mos7840 datasheet.

Signed-off-by: Dave Ludlow <dave.ludlow@bay.ws>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/mos7840.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN drivers/usb/serial/mos7840.c~usb-mos7840c-add-support-for-the-mos7820-7840-based-bb-usb-rs485-converter drivers/usb/serial/mos7840.c
--- a/drivers/usb/serial/mos7840.c~usb-mos7840c-add-support-for-the-mos7820-7840-based-bb-usb-rs485-converter
+++ a/drivers/usb/serial/mos7840.c
@@ -110,11 +110,20 @@
 
 /* vendor id and device id defines */
 
+/* The native mos7840/7820 component */
 #define USB_VENDOR_ID_MOSCHIP           0x9710
 #define MOSCHIP_DEVICE_ID_7840          0x7840
 #define MOSCHIP_DEVICE_ID_7820          0x7820
+/* The native component can have its vendor/device id's overridden
+ * in vendor-specific implementations.  Such devices can be handled
+ * by making a change here, in moschip_port_id_table, and in
+ * moschip_id_table_combined
+ */
+#define USB_VENDOR_ID_BANDB             0x0856
+#define BANDB_DEVICE_ID_USOPTL4_4       0xAC44
+#define BANDB_DEVICE_ID_USOPTL4_2       0xAC42
 
-/* Interrupt Rotinue Defines    */
+/* Interrupt Routine Defines    */
 
 #define SERIAL_IIR_RLS      0x06
 #define SERIAL_IIR_MS       0x00
@@ -159,12 +168,16 @@
 static struct usb_device_id moschip_port_id_table[] = {
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7840)},
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7820)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2)},
 	{}			/* terminating entry */
 };
 
 static __devinitdata struct usb_device_id moschip_id_table_combined[] = {
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7840)},
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7820)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2)},
 	{}			/* terminating entry */
 };
 
_

Patches currently in -mm which might be from dave.ludlow@bay.ws are


