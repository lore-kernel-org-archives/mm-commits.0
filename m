From: akpm@linux-foundation.org
Subject: + bluetooth-hid-quirks-mightymouse-quirk.patch added to -mm tree
Date: Tue, 27 Feb 2007 22:29:43 -0800
Message-ID: <200702280629.l1S6TlGD008806@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41983 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbXB1G36 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 01:29:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jikos@jikos.cz, jkosina@suse.cz


The patch titled
     bluetooth hid quirks: mightymouse quirk
has been added to the -mm tree.  Its filename is
     bluetooth-hid-quirks-mightymouse-quirk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bluetooth hid quirks: mightymouse quirk
From: Jiri Kosina <jikos@jikos.cz>

I have a bugreport that scrollwheel of bluetooth version of apple
mightymouse doesn't work.  The USB version of mightymouse works, as there
is a quirk for handling scrollwheel in hid/usbhid for it.

Now that bluetooth git tree is hooked to generic hid layer, it could easily
use the quirks which are already present in generic hid parser, hid-input,
etc.

Below is a simple patch against bluetooth git tree, which adds quirk
handling to current bluetooth hidp code, and sets quirk flags for device
0x05ac/0x030c, which is the bluetooth version of the apple mightymouse.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/hidp/core.c |   13 +++++++++++++
 net/bluetooth/hidp/hidp.h |   17 +++++++++++++++++
 2 files changed, 30 insertions(+)

diff -puN net/bluetooth/hidp/core.c~bluetooth-hid-quirks-mightymouse-quirk net/bluetooth/hidp/core.c
--- a/net/bluetooth/hidp/core.c~bluetooth-hid-quirks-mightymouse-quirk
+++ a/net/bluetooth/hidp/core.c
@@ -679,6 +679,17 @@ static void hidp_close(struct hid_device
 {
 }
 
+static void hidp_setup_quirks(struct hid_device *hid)
+{
+	unsigned int n;
+
+	for (n = 0; hid_blacklist[n].idVendor; n++)
+		if ((hid_blacklist[n].idVendor == le16_to_cpu(hid->vendor)) &&
+				(hid_blacklist[n].idProduct == le16_to_cpu(hid->product)))
+			hid->quirks = hid_blacklist[n].quirks;
+
+}
+
 static inline void hidp_setup_hid(struct hidp_session *session, struct hidp_connadd_req *req)
 {
 	struct hid_device *hid = session->hid;
@@ -708,6 +719,8 @@ static inline void hidp_setup_hid(struct
 
 	hid->hidinput_input_event = hidp_hidinput_event;
 
+	hidp_setup_quirks(hid);
+
 	list_for_each_entry(report, &hid->report_enum[HID_INPUT_REPORT].report_list, list)
 		hidp_send_report(session, report);
 
diff -puN net/bluetooth/hidp/hidp.h~bluetooth-hid-quirks-mightymouse-quirk net/bluetooth/hidp/hidp.h
--- a/net/bluetooth/hidp/hidp.h~bluetooth-hid-quirks-mightymouse-quirk
+++ a/net/bluetooth/hidp/hidp.h
@@ -23,6 +23,7 @@
 #ifndef __HIDP_H
 #define __HIDP_H
 
+#include <linux/hid.h>
 #include <linux/types.h>
 #include <net/bluetooth/bluetooth.h>
 
@@ -166,4 +167,20 @@ static inline void hidp_schedule(struct 
 extern int __init hidp_init_sockets(void);
 extern void __exit hidp_cleanup_sockets(void);
 
+/* HID blacklist and quirk entries */
+
+#define BT_VENDOR_ID_APPLE		0x05ac
+#define BT_DEVICE_ID_APPLE_MIGHTYMOUSE	0x030c
+
+static const struct hid_blacklist {
+	__u16 idVendor;
+	__u16 idProduct;
+	unsigned quirks;
+} hid_blacklist[] = {
+
+	{ BT_VENDOR_ID_APPLE, BT_DEVICE_ID_APPLE_MIGHTYMOUSE, HID_QUIRK_MIGHTYMOUSE | HID_QUIRK_INVERT_HWHEEL },
+
+	{ 0, 0 }
+};
+
 #endif /* __HIDP_H */
_

Patches currently in -mm which might be from jikos@jikos.cz are

bluetooth-hid-quirks-mightymouse-quirk.patch
statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution-ia64-fix.patch
