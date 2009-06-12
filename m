From: akpm@linux-foundation.org
Subject: [merged] input-mouse-alpsc-handle-touchpoints-buttons-correctly.patch removed from -mm tree
Date: Fri, 12 Jun 2009 11:22:11 -0700
Message-ID: <200906121822.n5CIMBsO030957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757416AbZFLSZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jun 2009 14:25:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uli-kernel@spamt.net, dtor@mail.ru, uli@spamt.net, mm-commits@vger.kernel.org


The patch titled
     input/mouse/alps.c: handle touchpoints buttons correctly
has been removed from the -mm tree.  Its filename was
     input-mouse-alpsc-handle-touchpoints-buttons-correctly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -132,18 +132,23 @@ static void alps_process_packet(struct p
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

linux-next.patch

