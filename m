From: akpm@linux-foundation.org
Subject: - net-bluetooth-hidp-corec-make-hidp_setup_input.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:43:38 -0700
Message-ID: <200709270143.l8R1hcR5013980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57047 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650AbXI0BvW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:51:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, 12o3l@tiscali.nl, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     net/bluetooth/hidp/core.c: Make hidp_setup_input() return int
has been removed from the -mm tree.  Its filename was
     net-bluetooth-hidp-corec-make-hidp_setup_input.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: net/bluetooth/hidp/core.c: Make hidp_setup_input() return int
From: WANG Cong <xiyou.wangcong@gmail.com>

- makes hidp_setup_input() return int to indicate errors;
- checks its return value to handle errors.

Thanks to roel and Marcel Holtmann for comments.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: roel <12o3l@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/hidp/core.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff -puN net/bluetooth/hidp/core.c~net-bluetooth-hidp-corec-make-hidp_setup_input net/bluetooth/hidp/core.c
--- a/net/bluetooth/hidp/core.c~net-bluetooth-hidp-corec-make-hidp_setup_input
+++ a/net/bluetooth/hidp/core.c
@@ -625,7 +625,7 @@ static struct device *hidp_get_device(st
 	return conn ? &conn->dev : NULL;
 }
 
-static inline void hidp_setup_input(struct hidp_session *session, struct hidp_connadd_req *req)
+static inline int hidp_setup_input(struct hidp_session *session, struct hidp_connadd_req *req)
 {
 	struct input_dev *input = session->input;
 	int i;
@@ -667,7 +667,7 @@ static inline void hidp_setup_input(stru
 
 	input->event = hidp_input_event;
 
-	input_register_device(input);
+	return input_register_device(input);
 }
 
 static int hidp_open(struct hid_device *hid)
@@ -820,8 +820,11 @@ int hidp_add_connection(struct hidp_conn
 	session->flags   = req->flags & (1 << HIDP_BLUETOOTH_VENDOR_ID);
 	session->idle_to = req->idle_to;
 
-	if (session->input)
-		hidp_setup_input(session, req);
+	if (session->input) {
+		err = hidp_setup_input(session, req);
+		if (err < 0)
+			goto failed;
+	}
 
 	if (session->hid)
 		hidp_setup_hid(session, req);
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

git-net.patch
drivers-usb-misc-sisusbvga-sisusbc-kill-two-unused-variables.patch
fs-romfs-inodec-trivial-improvements.patch
fs-udf-ballocc-mark-a-variable-as-uninitialized_var.patch
