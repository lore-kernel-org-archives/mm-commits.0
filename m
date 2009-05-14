From: akpm@linux-foundation.org
Subject: [nacked] input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch removed from -mm tree
Date: Wed, 13 May 2009 20:50:15 -0700
Message-ID: <200905140350.n4E3oF94002698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754552AbZENDuT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 23:50:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, mm-commits@vger.kernel.org


The patch titled
     input: mousedev: distinguish a moving finger from a tapping finger
has been removed from the -mm tree.  Its filename was
     input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: mousedev: distinguish a moving finger from a tapping finger
From: Henrik Rydberg <rydberg@euromail.se>

The tap functionality of mousedev does not distinguish between a tap
(on/off localized in time and space) and a quick move (on/off localized in
time only).  This patch improves the tap detection by testing also for
space locality.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mousedev.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/input/mousedev.c~input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger drivers/input/mousedev.c
--- a/drivers/input/mousedev.c~input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger
+++ a/drivers/input/mousedev.c
@@ -49,6 +49,10 @@ static unsigned tap_time = 200;
 module_param(tap_time, uint, 0644);
 MODULE_PARM_DESC(tap_time, "Tap time for touchpads in absolute mode (msecs)");
 
+static unsigned tap_move = 20;
+module_param(tap_move, uint, 0644);
+MODULE_PARM_DESC(tap_move, "Tap distance for touchpads in absolute mode (res)");
+
 struct mousedev_hw_data {
 	int dx, dy, dz;
 	int x, y;
@@ -75,6 +79,7 @@ struct mousedev {
 	int old_x[4], old_y[4];
 	int frac_dx, frac_dy;
 	unsigned long touch;
+	int touch_dx, touch_dy;
 };
 
 enum mousedev_emul {
@@ -142,6 +147,7 @@ static void mousedev_touchpad_event(stru
 			tmp = ((value - fx(2)) * 256 * FRACTION_DENOM) / size;
 			tmp += mousedev->frac_dx;
 			mousedev->packet.dx = tmp / FRACTION_DENOM;
+			mousedev->touch_dx += mousedev->packet.dx;
 			mousedev->frac_dx =
 				tmp - mousedev->packet.dx * FRACTION_DENOM;
 		}
@@ -157,6 +163,7 @@ static void mousedev_touchpad_event(stru
 			tmp = -((value - fy(2)) * 256 * FRACTION_DENOM) / size;
 			tmp += mousedev->frac_dy;
 			mousedev->packet.dy = tmp / FRACTION_DENOM;
+			mousedev->touch_dy += mousedev->packet.dy;
 			mousedev->frac_dy = tmp -
 				mousedev->packet.dy * FRACTION_DENOM;
 		}
@@ -319,6 +326,8 @@ static void mousedev_touchpad_touch(stru
 {
 	if (!value) {
 		if (mousedev->touch &&
+		    abs(mousedev->touch_dx) < tap_move &&
+		    abs(mousedev->touch_dy) < tap_move &&
 		    time_before(jiffies,
 				mousedev->touch + msecs_to_jiffies(tap_time))) {
 			/*
@@ -335,6 +344,7 @@ static void mousedev_touchpad_touch(stru
 			clear_bit(0, &mousedev_mix->packet.buttons);
 		}
 		mousedev->touch = mousedev->pkt_count = 0;
+		mousedev->touch_dx = mousedev->touch_dy = 0;
 		mousedev->frac_dx = 0;
 		mousedev->frac_dy = 0;
 
_

Patches currently in -mm which might be from rydberg@euromail.se are

input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch

