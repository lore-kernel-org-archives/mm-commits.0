From: akpm@linux-foundation.org
Subject: + fix-appletouch-geyser-1-breakage.patch added to -mm tree
Date: Wed, 24 Oct 2007 20:24:28 -0700
Message-ID: <200710250324.l9P3OSPu029418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55020 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755090AbXJYDZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 23:25:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, benh@kernel.crashing.org, dtor@mail.ru, valderman@gmail.com


The patch titled
     fix appletouch geyser 1 breakage
has been added to the -mm tree.  Its filename is
     fix-appletouch-geyser-1-breakage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fix-appletouch-geyser-1-breakage.patch
git-wireless.patch
