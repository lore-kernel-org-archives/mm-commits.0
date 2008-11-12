From: akpm@linux-foundation.org
Subject: + wusb-annotate-association-types-withe-proper-endianness.patch added to -mm tree
Date: Tue, 11 Nov 2008 16:37:31 -0800
Message-ID: <200811120037.mAC0bVY6017025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756389AbYKLAh4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Nov 2008 19:37:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, david.vrabel@csr.com, greg@kroah.com, inaky.perez-gonzalez@intel.com


The patch titled
     wusb: annotate association types withe proper endianness
has been added to the -mm tree.  Its filename is
     wusb-annotate-association-types-withe-proper-endianness.patch

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
Subject: wusb: annotate association types withe proper endianness
From: Harvey Harrison <harvey.harrison@gmail.com>

Also a trivial annotation in rh.c for:
drivers/usb/wusbcore/rh.c:366:9: warning: incorrect type in assignment (different base types)
drivers/usb/wusbcore/rh.c:366:9:    expected unsigned short [unsigned] [short] [usertype] <noident>
drivers/usb/wusbcore/rh.c:366:9:    got restricted __le16 [usertype] <noident>
drivers/usb/wusbcore/rh.c:367:9: warning: incorrect type in assignment (different base types)
drivers/usb/wusbcore/rh.c:367:9:    expected unsigned short [unsigned] [short] [usertype] <noident>
drivers/usb/wusbcore/rh.c:367:9:    got restricted __le16 [usertype] <noident>

Association types annotation fixes piles of warnings similar to:
drivers/usb/wusbcore/cbaf.c:238:30: warning: incorrect type in initializer (different base types)
drivers/usb/wusbcore/cbaf.c:238:30:    expected restricted __le16 [usertype] id
drivers/usb/wusbcore/cbaf.c:238:30:    got int
drivers/usb/wusbcore/cbaf.c:238:30: warning: incorrect type in initializer (different base types)
drivers/usb/wusbcore/cbaf.c:238:30:    expected restricted __le16 [usertype] len
drivers/usb/wusbcore/cbaf.c:238:30:    got int

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: David Vrabel <david.vrabel@csr.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/wusbcore/rh.c       |    2 +-
 include/linux/usb/association.h |   22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/usb/wusbcore/rh.c~wusb-annotate-association-types-withe-proper-endianness drivers/usb/wusbcore/rh.c
--- a/drivers/usb/wusbcore/rh.c~wusb-annotate-association-types-withe-proper-endianness
+++ a/drivers/usb/wusbcore/rh.c
@@ -356,7 +356,7 @@ static int wusbhc_rh_get_port_status(str
 				     u32 *_buf, u16 wLength)
 {
 	int result = -EINVAL;
-	u16 *buf = (u16 *) _buf;
+	__le16 *buf = (__le16 *)_buf;
 
 	d_fnstart(1, wusbhc->dev, "(wusbhc %p port_idx %u wLength %u)\n",
 		  wusbhc, port_idx, wLength);
diff -puN include/linux/usb/association.h~wusb-annotate-association-types-withe-proper-endianness include/linux/usb/association.h
--- a/include/linux/usb/association.h~wusb-annotate-association-types-withe-proper-endianness
+++ a/include/linux/usb/association.h
@@ -28,17 +28,17 @@ struct wusb_am_attr {
 };
 
 /* Different fields defined by the spec */
-#define WUSB_AR_AssociationTypeId	{ .id = 0x0000, .len =  2 }
-#define WUSB_AR_AssociationSubTypeId	{ .id = 0x0001, .len =  2 }
-#define WUSB_AR_Length			{ .id = 0x0002, .len =  4 }
-#define WUSB_AR_AssociationStatus	{ .id = 0x0004, .len =  4 }
-#define WUSB_AR_LangID			{ .id = 0x0008, .len =  2 }
-#define WUSB_AR_DeviceFriendlyName	{ .id = 0x000b, .len = 64 } /* max */
-#define WUSB_AR_HostFriendlyName	{ .id = 0x000c, .len = 64 } /* max */
-#define WUSB_AR_CHID			{ .id = 0x1000, .len = 16 }
-#define WUSB_AR_CDID			{ .id = 0x1001, .len = 16 }
-#define WUSB_AR_ConnectionContext	{ .id = 0x1002, .len = 48 }
-#define WUSB_AR_BandGroups		{ .id = 0x1004, .len =  2 }
+#define WUSB_AR_AssociationTypeId	{ .id = cpu_to_le16(0x0000), .len = cpu_to_le16(2) }
+#define WUSB_AR_AssociationSubTypeId	{ .id = cpu_to_le16(0x0001), .len = cpu_to_le16(2) }
+#define WUSB_AR_Length			{ .id = cpu_to_le16(0x0002), .len = cpu_to_le16(4) }
+#define WUSB_AR_AssociationStatus	{ .id = cpu_to_le16(0x0004), .len = cpu_to_le16(4) }
+#define WUSB_AR_LangID			{ .id = cpu_to_le16(0x0008), .len = cpu_to_le16(2) }
+#define WUSB_AR_DeviceFriendlyName	{ .id = cpu_to_le16(0x000b), .len = cpu_to_le16(64) } /* max */
+#define WUSB_AR_HostFriendlyName	{ .id = cpu_to_le16(0x000c), .len = cpu_to_le16(64) } /* max */
+#define WUSB_AR_CHID			{ .id = cpu_to_le16(0x1000), .len = cpu_to_le16(16) }
+#define WUSB_AR_CDID			{ .id = cpu_to_le16(0x1001), .len = cpu_to_le16(16) }
+#define WUSB_AR_ConnectionContext	{ .id = cpu_to_le16(0x1002), .len = cpu_to_le16(48) }
+#define WUSB_AR_BandGroups		{ .id = cpu_to_le16(0x1004), .len = cpu_to_le16(2) }
 
 /* CBAF Control Requests (AMS1.0[T4-1] */
 enum {
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
arm-use-the-new-byteorder-headers.patch
cifs-remove-global_extern-macro.patch
ia64-use-the-new-byteorder-headers.patch
input-ads7846c-sparse-lock-annotation.patch
m32r-use-the-new-byteorder-headers.patch
blackfin-remove-__function__-in-new-serial-driver.patch
blackfin-use-the-new-byteorder-headers.patch
parisc-use-the-new-byteorder-headers.patch
s390-use-the-new-byteorder-headers.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
wusb-annotate-association-types-withe-proper-endianness.patch
frv-use-the-new-byteorder-headers.patch
m68knommu-use-the-new-byteorder-headers.patch
h8300-use-the-new-byteorder-headers.patch
alpha-use-the-new-byteorder-headers.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
blackfin-remove-__function__-in-video-driver.patch
fb-carminefb-trivial-annotation-packing-color-register.patch
memstick-annotate-endianness-of-attribute-structs.patch

