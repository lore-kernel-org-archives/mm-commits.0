From: akpm@linux-foundation.org
Subject: [nacked] bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch removed from -mm tree
Date: Mon, 21 Dec 2009 15:58:33 -0800
Message-ID: <200912212358.nBLNwXe1003780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018AbZLUX6v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 18:58:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lamarque@gmail.com, hidave.darkstar@gmail.com, jkosina@suse.cz, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     bluetooth: fix for Acer Bluetooth Optical Rechargeable Mouse
has been removed from the -mm tree.  Its filename was
     bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bluetooth: fix for Acer Bluetooth Optical Rechargeable Mouse
From: Lamarque Vieira Souza <lamarque@gmail.com>

Work around one problem with my Acer Bluetooth Optical Rechargeable Mouse
where the cursor gets stuck at screen's upper-left corner.

Even my notebook's touchpad is not able to move cursor when the bluetooth
mouse is connected to my Acer Ferrari 4005 notebook.

Using input session instead of hid session solves this problem although
the cursor still moves a little sluggishly with the bluetooth mouse,
cursor moves correctly using the touchpad.

My bluetooth mouse used to work well (no sluggish) until kernel 2.6.21,
since then the problems are getting worse with each kernel release (it got
sluggish in 2.6.22 and this this upper-left corner problem appeared in
2.6.28 or 2.6.27).

The patch adds a general quirk handling framework to the HIDP core and
then uses this framework to implement a quirk for this device.

[akpm@linux-foundation.org: use ARRAY_SIZE()-based search]
Signed-off-by: Lamarque V. Souza <lamarque@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/hidp/core.c |   39 +++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff -puN net/bluetooth/hidp/core.c~bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse net/bluetooth/hidp/core.c
--- a/net/bluetooth/hidp/core.c~bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse
+++ a/net/bluetooth/hidp/core.c
@@ -74,6 +74,41 @@ static unsigned char hidp_keycode[256] =
 
 static unsigned char hidp_mkeyspat[] = { 0x01, 0x01, 0x01, 0x01, 0x01, 0x01 };
 
+/* HIDP device quirks */
+enum {
+	HIDP_QUIRK_USE_INPUT_SESSION
+};
+
+struct quirk_id {
+	__u16 vendor;
+	__u16 product;
+	unsigned long quirks;
+};
+
+static const struct quirk_id hidp_quirks[] = {
+	{
+		/* Lamarque: Acer Bluetooth Optical Rechargeable Mouse
+		 * does not work properly with hid session since 2.6.27. */
+		.vendor = 0x0458,
+		.product = 0x0058,
+		.quirks = 1 << HIDP_QUIRK_USE_INPUT_SESSION
+	},
+};
+
+static int quirk_test_bit(__u16 vendor, __u16 product, int quirk)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hidp_quirks); i++) {
+		const struct quirk_id *q = hidp_quirks + i;
+
+		if (q->vendor == vendor && q->product == product)
+			return test_bit(quirk, &q->quirks);
+	}
+
+	return 0;
+}
+
 static struct hidp_session *__hidp_get_session(bdaddr_t *bdaddr)
 {
 	struct hidp_session *session;
@@ -851,7 +886,9 @@ int hidp_add_connection(struct hidp_conn
 	session->flags   = req->flags & (1 << HIDP_BLUETOOTH_VENDOR_ID);
 	session->idle_to = req->idle_to;
 
-	if (req->rd_size > 0) {
+	if (req->rd_size > 0 &&
+	    !quirk_test_bit(req->vendor, req->product,
+			   HIDP_QUIRK_USE_INPUT_SESSION)) {
 		err = hidp_setup_hid(session, req);
 		if (err && err != -ENODEV)
 			goto purge;
_

Patches currently in -mm which might be from lamarque@gmail.com are

bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch

