From: akpm@linux-foundation.org
Subject: [merged] ati_remote-add-some-missing-devices-from-lirc_atiusb.patch removed from -mm tree
Date: Thu, 06 May 2010 12:09:12 -0400
Message-ID: <201005061910.o46JAgPO008545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755612Ab0EFTLB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 15:11:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarod@redhat.com, nm127@freemail.hu, mm-commits@vger.kernel.org


The patch titled
     ati_remote: add some missing devices from lirc_atiusb
has been removed from the -mm tree.  Its filename was
     ati_remote-add-some-missing-devices-from-lirc_atiusb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ati_remote: add some missing devices from lirc_atiusb
From: Jarod Wilson <jarod@redhat.com>

The (out-of-tree) lirc_atiusb driver has a much longer list of devices it
supports.  Some of them look like they may just be guesses at possible
device IDs, but a few are definitely confirmed devices.  This adds the
nVidia-branded RF receiver and the X10 Lola Wireless Video Sender device
(which contains an RF receiver) to the list of devices in ati_remote.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Cc: <nm127@freemail.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/ati_remote.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN drivers/input/misc/ati_remote.c~ati_remote-add-some-missing-devices-from-lirc_atiusb drivers/input/misc/ati_remote.c
--- a/drivers/input/misc/ati_remote.c~ati_remote-add-some-missing-devices-from-lirc_atiusb
+++ a/drivers/input/misc/ati_remote.c
@@ -98,10 +98,12 @@
  * Module and Version Information, Module Parameters
  */
 
-#define ATI_REMOTE_VENDOR_ID	0x0bc7
-#define ATI_REMOTE_PRODUCT_ID	0x004
-#define LOLA_REMOTE_PRODUCT_ID	0x002
-#define MEDION_REMOTE_PRODUCT_ID 0x006
+#define ATI_REMOTE_VENDOR_ID		0x0bc7
+#define LOLA_REMOTE_PRODUCT_ID		0x0002
+#define LOLA2_REMOTE_PRODUCT_ID		0x0003
+#define ATI_REMOTE_PRODUCT_ID		0x0004
+#define NVIDIA_REMOTE_PRODUCT_ID	0x0005
+#define MEDION_REMOTE_PRODUCT_ID	0x0006
 
 #define DRIVER_VERSION	        "2.2.1"
 #define DRIVER_AUTHOR           "Torrey Hoffman <thoffman@arnor.net>"
@@ -142,8 +144,10 @@ MODULE_PARM_DESC(repeat_delay, "Delay be
 #define err(format, arg...) printk(KERN_ERR format , ## arg)
 
 static struct usb_device_id ati_remote_table[] = {
-	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, ATI_REMOTE_PRODUCT_ID) },
 	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, LOLA_REMOTE_PRODUCT_ID) },
+	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, LOLA2_REMOTE_PRODUCT_ID) },
+	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, ATI_REMOTE_PRODUCT_ID) },
+	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, NVIDIA_REMOTE_PRODUCT_ID) },
 	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, MEDION_REMOTE_PRODUCT_ID) },
 	{}	/* Terminating entry */
 };
_

Patches currently in -mm which might be from jarod@redhat.com are

origin.patch
linux-next.patch

