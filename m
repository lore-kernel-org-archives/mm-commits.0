From: akpm@linux-foundation.org
Subject: [merged] input-elantech-touchpad-driver-miss-recognising-logitech-mice.patch removed from -mm tree
Date: Wed, 04 Mar 2009 12:39:11 -0800
Message-ID: <200903042039.n24KdBr9032625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754535AbZCDUj5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 15:39:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@opmeer.net, apw@shadowen.org, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: elantech touchpad driver miss-recognising logitech mice
has been removed from the -mm tree.  Its filename was
     input-elantech-touchpad-driver-miss-recognising-logitech-mice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: elantech touchpad driver miss-recognising logitech mice
From: Arjan Opmeer <arjan@opmeer.net>

Some Logitech mice react to the magic knock like an Elantech touchpad would.
This leads to those mice being misdetected as Elantech touchpads.  Add a
version query to elantech_detect() to distinguish the two.

Signed-off-by: Arjan Opmeer <arjan@opmeer.net>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/elantech.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff -puN drivers/input/mouse/elantech.c~input-elantech-touchpad-driver-miss-recognising-logitech-mice drivers/input/mouse/elantech.c
--- a/drivers/input/mouse/elantech.c~input-elantech-touchpad-driver-miss-recognising-logitech-mice
+++ a/drivers/input/mouse/elantech.c
@@ -567,14 +567,27 @@ int elantech_detect(struct psmouse *psmo
 		return -1;
 	}
 
-	pr_debug("elantech.c: Elantech version query result 0x%02x, 0x%02x, 0x%02x.\n",
-		 param[0], param[1], param[2]);
-
 	if (param[0] == 0 || param[1] != 0) {
 		pr_debug("elantech.c: Probably not a real Elantech touchpad. Aborting.\n");
 		return -1;
 	}
 
+	/*
+	 * There are Logitech mice that react to the magic knock exactly
+	 * like an Elantech touchpad would, so do a version query here to
+	 * try to distinguish the two
+	 */
+	if (synaptics_send_cmd(psmouse, ETP_FW_VERSION_QUERY, param)) {
+		pr_err("elantech.c: failed to query firmware version.\n");
+		return -1;
+	}
+	pr_info("elantech.c: Elantech version query result 0x%02x, 0x%02x, 0x%02x.\n",
+		param[0], param[1], param[2]);
+	if (param[0] == 0 || param[1] != 0) {
+		pr_info("elantech.c: Probably not a real Elantech touchpad. Aborting.\n");
+		return -1;
+	}
+
 	if (set_properties) {
 		psmouse->vendor = "Elantech";
 		psmouse->name = "Touchpad";
_

Patches currently in -mm which might be from arjan@opmeer.net are

input-elantech-touchpad-driver-miss-recognising-logitech-mice.patch

