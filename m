From: akpm@linux-foundation.org
Subject: + input-mouse-alpsc-handle-touchpoints-buttons-correctly.patch added to -mm tree
Date: Tue, 18 Nov 2008 16:28:50 -0800
Message-ID: <200811190028.mAJ0SoS0023471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092AbYKSA3d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 19:29:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: uli-kernel@spamt.net, dtor@mail.ru, uli@spamt.net


The patch titled
     input/mouse/alps.c: handle touchpoints buttons correctly
has been added to the -mm tree.  Its filename is
     input-mouse-alpsc-handle-touchpoints-buttons-correctly.patch

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
Subject: input/mouse/alps.c: handle touchpoints buttons correctly
From: Ulrich Dangel <uli-kernel@spamt.net>

When pressing any button belonging to the touchpoint, the generated click
events dont belong to the touchpoint but to the touchpad.

This patch fixes this behaviour, the events will be sent via the correct
device, so scrolling with touchpoint is possible.

The patch compiles cleanly and has been tested successfully on my machine.

Signed-off-by: Ulrich Dangel <uli@spamt.net>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/alps.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN drivers/input/mouse/alps.c~input-mouse-alpsc-handle-touchpoints-buttons-correctly drivers/input/mouse/alps.c
--- a/drivers/input/mouse/alps.c~input-mouse-alpsc-handle-touchpoints-buttons-correctly
+++ a/drivers/input/mouse/alps.c
@@ -131,18 +131,23 @@ static void alps_process_packet(struct p
 	ges = packet[2] & 1;
 	fin = packet[2] & 2;
 
-	input_report_key(dev, BTN_LEFT, left);
-	input_report_key(dev, BTN_RIGHT, right);
-	input_report_key(dev, BTN_MIDDLE, middle);
-
 	if ((priv->i->flags & ALPS_DUALPOINT) && z == 127) {
 		input_report_rel(dev2, REL_X,  (x > 383 ? (x - 768) : x));
 		input_report_rel(dev2, REL_Y, -(y > 255 ? (y - 512) : y));
+
+		input_report_key(dev2, BTN_LEFT, left);
+		input_report_key(dev2, BTN_RIGHT, right);
+		input_report_key(dev2, BTN_MIDDLE, middle);
+
 		input_sync(dev);
 		input_sync(dev2);
 		return;
 	}
 
+	input_report_key(dev, BTN_LEFT, left);
+	input_report_key(dev, BTN_RIGHT, right);
+	input_report_key(dev, BTN_MIDDLE, middle);
+
 	/* Convert hardware tap to a reasonable Z value */
 	if (ges && !fin) z = 40;
 
_

Patches currently in -mm which might be from uli-kernel@spamt.net are

input-mouse-alpsc-handle-touchpoints-buttons-correctly.patch

