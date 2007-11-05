From: akpm@linux-foundation.org
Subject: - fix-appletouch-geyser-1-breakage.patch removed from -mm tree
Date: Mon, 05 Nov 2007 14:00:25 -0800
Message-ID: <200711052200.lA5M0PMs021744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36200 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbXKEWBK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 17:01:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, benh@kernel.crashing.org, dtor@mail.ru, valderman@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fix appletouch geyser 1 breakage
has been removed from the -mm tree.  Its filename was
     fix-appletouch-geyser-1-breakage.patch

This patch was dropped because change in mainline broke it

------------------------------------------------------
Subject: fix appletouch geyser 1 breakage
From: Johannes Berg <johannes@sipsolutions.net>

The patch 46249ea60fbb61a72ee6929b831b1f3e6865f024 was obviously done
without testing on a Geyser 1, and I'm a very annoyed that it was applied. 
It causes appletouch to continuously printk:

drivers/input/mouse/appletouch.c: Could not do mode read request from device (Geyser 3 mode)

because the Geyser 1 doesn't respond to that. The patch description also
states:

> if we see 10 empty packets the touchpad needs to be reset; good
> touchpads should not send empty packets anyway.

which is *TOTALLY* bogus since Geyser 1 touchpads have no notion of empty
packets, the simply continuously send measurements.  One look at the
specification would have confirmed that.

This reverts the clueless commit.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Anton Ekblad <valderman@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/appletouch.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff -puN drivers/input/mouse/appletouch.c~fix-appletouch-geyser-1-breakage drivers/input/mouse/appletouch.c
--- a/drivers/input/mouse/appletouch.c~fix-appletouch-geyser-1-breakage
+++ a/drivers/input/mouse/appletouch.c
@@ -504,22 +504,25 @@ static void atp_complete(struct urb* urb
 		memset(dev->xy_acc, 0, sizeof(dev->xy_acc));
 	}
 
-	input_report_key(dev->input, BTN_LEFT, key);
-	input_sync(dev->input);
-
-	/* Many Geysers will continue to send packets continually after
+	/* Geyser 3 will continue to send packets continually after
 	   the first touch unless reinitialised. Do so if it's been
 	   idle for a while in order to avoid waking the kernel up
 	   several hundred times a second */
 
-	if (!x && !y && !key) {
-		dev->idlecount++;
-		if (dev->idlecount == 10) {
-			dev->valid = 0;
-			schedule_work(&dev->work);
+	if (atp_is_geyser_3(dev)) {
+		if (!x && !y && !key) {
+			dev->idlecount++;
+			if (dev->idlecount == 10) {
+				dev->valid = 0;
+				schedule_work(&dev->work);
+			}
 		}
-	} else
-		dev->idlecount = 0;
+		else
+			dev->idlecount = 0;
+	}
+
+	input_report_key(dev->input, BTN_LEFT, key);
+	input_sync(dev->input);
 
 exit:
 	retval = usb_submit_urb(dev->urb, GFP_ATOMIC);
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
fix-appletouch-geyser-1-breakage.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
git-kbuild.patch
git-wireless.patch
hibernate-fix-lockdep-report-2.patch
