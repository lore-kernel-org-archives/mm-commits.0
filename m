From: akpm@linux-foundation.org
Subject: + bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch added to -mm tree
Date: Thu, 23 Jul 2009 13:28:17 -0700
Message-ID: <200907232028.n6NKSHeO030385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754557AbZGWU2c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 16:28:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lamarque@gmail.com, hidave.darkstar@gmail.com, jkosina@suse.cz, marcel@holtmann.org


The patch titled
     bluetooth: fix for Acer Bluetooth Optical Rechargeable Mouse
has been added to the -mm tree.  Its filename is
     bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch

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

Signed-off-by: Lamarque V. Souza <lamarque@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/hidp/core.c |   41 +++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff -puN net/bluetooth/hidp/core.c~bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse net/bluetooth/hidp/core.c
--- a/net/bluetooth/hidp/core.c~bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse
+++ a/net/bluetooth/hidp/core.c
@@ -73,6 +73,43 @@ static unsigned char hidp_keycode[256] =
 
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
+
+	{ /* end: all zeroes */ }
+};
+
+static int quirk_test_bit(__u16 vendor, __u16 product, int quirk)
+{
+	const struct quirk_id *q = &hidp_quirks[0];
+
+	while (q->vendor != vendor && q->product != product &&
+	       q->vendor && q->product)
+		q++;
+
+	if (q->vendor == vendor && q->product == product)
+		return test_bit(quirk, &q->quirks);
+
+	return 0;
+}
+
 static struct hidp_session *__hidp_get_session(bdaddr_t *bdaddr)
 {
 	struct hidp_session *session;
@@ -833,7 +870,9 @@ int hidp_add_connection(struct hidp_conn
 	session->flags   = req->flags & (1 << HIDP_BLUETOOTH_VENDOR_ID);
 	session->idle_to = req->idle_to;
 
-	if (req->rd_size > 0) {
+	if (req->rd_size > 0 &&
+	    !quirk_test_bit(req->vendor, req->product,
+			   HIDP_QUIRK_USE_INPUT_SESSION)) {
 		err = hidp_setup_hid(session, req);
 		if (err && err != -ENODEV)
 			goto err_skb;
_

Patches currently in -mm which might be from lamarque@gmail.com are

linux-next.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse-fix.patch

