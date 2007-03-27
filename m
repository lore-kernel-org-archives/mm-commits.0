From: akpm@linux-foundation.org
Subject: + bluetooth-hid-quirks-mightymouse-quirk-2.patch added to -mm tree
Date: Tue, 27 Mar 2007 13:23:36 -0700
Message-ID: <200703272023.l2RKNaSB026926@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41720 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965352AbXC0UXp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 16:23:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, marcel@holtmann.org


The patch titled
     bluetooth hid quirks: mightymouse quirk
has been added to the -mm tree.  Its filename is
     bluetooth-hid-quirks-mightymouse-quirk-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bluetooth hid quirks: mightymouse quirk
From: Jiri Kosina <jkosina@suse.cz>

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
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/hidp/core.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+)

diff -puN net/bluetooth/hidp/core.c~bluetooth-hid-quirks-mightymouse-quirk-2 net/bluetooth/hidp/core.c
--- a/net/bluetooth/hidp/core.c~bluetooth-hid-quirks-mightymouse-quirk-2
+++ a/net/bluetooth/hidp/core.c
@@ -679,6 +679,27 @@ static void hidp_close(struct hid_device
 {
 }
 
+static const struct {
+	__u16 idVendor;
+	__u16 idProduct;
+	unsigned quirks;
+} hidp_blacklist[] = {
+	/* Apple wireless Mighty Mouse */
+	{ 0x05ac, 0x030c, HID_QUIRK_MIGHTYMOUSE | HID_QUIRK_INVERT_HWHEEL },
+
+	{ }	/* Terminating entry */
+};
+
+static void hidp_setup_quirks(struct hid_device *hid)
+{
+	unsigned int n;
+
+	for (n = 0; hidp_blacklist[n].idVendor; n++)
+		if (hidp_blacklist[n].idVendor == le16_to_cpu(hid->vendor) &&
+				hidp_blacklist[n].idProduct == le16_to_cpu(hid->product))
+			hid->quirks = hidp_blacklist[n].quirks;
+}
+
 static inline void hidp_setup_hid(struct hidp_session *session, struct hidp_connadd_req *req)
 {
 	struct hid_device *hid = session->hid;
@@ -708,6 +729,8 @@ static inline void hidp_setup_hid(struct
 
 	hid->hidinput_input_event = hidp_hidinput_event;
 
+	hidp_setup_quirks(hid);
+
 	list_for_each_entry(report, &hid->report_enum[HID_INPUT_REPORT].report_list, list)
 		hidp_send_report(session, report);
 
_

Patches currently in -mm which might be from jkosina@suse.cz are

isdn-fix-bchannel_bh-call-from-isar_bh.patch
git-hid.patch
bluetooth-hid-quirks-mightymouse-quirk-2.patch
git-ipwireless_cs.patch
