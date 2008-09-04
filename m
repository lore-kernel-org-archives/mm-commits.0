From: akpm@linux-foundation.org
Subject: + bcm5974-063-btn_touch-event-added-for-mousedev.patch added to -mm tree
Date: Thu, 04 Sep 2008 13:52:51 -0700
Message-ID: <200809042052.m84KqpuN030435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753546AbYIDUyM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 16:54:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@euromail.se


The patch titled
     bcm5974-0.63: BTN_TOUCH event added for mousedev
has been added to the -mm tree.  Its filename is
     bcm5974-063-btn_touch-event-added-for-mousedev.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bcm5974-0.63: BTN_TOUCH event added for mousedev
From: Henrik Rydberg <rydberg@euromail.se>

The mousedev driver requires the use of BTN_TOUCH events to process ABS_X
and ABS_Y events properly, which is what is needed for the bcm5974-based
apple computers to have a functional pointer out-of-the-box.  This patch
adds the BTN_TOUCH events to bcm5974.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/bcm5974.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/input/mouse/bcm5974.c~bcm5974-063-btn_touch-event-added-for-mousedev drivers/input/mouse/bcm5974.c
--- a/drivers/input/mouse/bcm5974.c~bcm5974-063-btn_touch-event-added-for-mousedev
+++ a/drivers/input/mouse/bcm5974.c
@@ -253,6 +253,7 @@ static void setup_events_to_report(struc
 				0, cfg->y.dim, cfg->y.fuzz, 0);
 
 	__set_bit(EV_KEY, input_dev->evbit);
+	__set_bit(BTN_TOUCH, input_dev->keybit);
 	__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
 	__set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
 	__set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
@@ -303,6 +304,7 @@ static int report_tp_state(struct bcm597
 	if (dev->fingers > nmax)
 		dev->fingers = nmax;
 
+	input_report_key(input, BTN_TOUCH, dev->fingers > 0);
 	input_report_key(input, BTN_TOOL_FINGER, dev->fingers == 1);
 	input_report_key(input, BTN_TOOL_DOUBLETAP, dev->fingers == 2);
 	input_report_key(input, BTN_TOOL_TRIPLETAP, dev->fingers > 2);
_

Patches currently in -mm which might be from rydberg@euromail.se are

origin.patch
linux-next.patch
bcm5974-063-finger-counting-improved.patch
bcm5974-063-btn_touch-event-added-for-mousedev.patch

