From: akpm@linux-foundation.org
Subject: + fix-sudden-warps-in-mousedev.patch added to -mm tree
Date: Sun, 25 Mar 2007 01:13:15 -0800
Message-ID: <200703250913.l2P9DF4V024473@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37106 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933276AbXCYJNd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 05:13:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zaitcev@redhat.com, dtor@mail.ru


The patch titled
     Fix sudden warps in mousedev
has been added to the -mm tree.  Its filename is
     fix-sudden-warps-in-mousedev.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix sudden warps in mousedev
From: Pete Zaitcev <zaitcev@redhat.com>

On my laptop with Synaptics, if I lift the finger and place it elsewhere,
the pointer sometimes warps dramatically. Here's the evtest trace
which illustrates what happens:

Event: time 1174703240.830555, type 3 (Absolute), code 0 (X), value 3907
Event: time 1174703240.830557, type 3 (Absolute), code 1 (Y), value 3684
Event: time 1174703240.830561, -------------- Report Sync ------------
Event: time 1174703240.842205, type 3 (Absolute), code 0 (X), value 3909
Event: time 1174703240.842208, type 3 (Absolute), code 1 (Y), value 3687
         <---- value used by fy(2) later
Event: time 1174703240.842211, -------------- Report Sync ------------
Event: time 1174703240.854912, type 3 (Absolute), code 24 (Pressure), value 30
Event: time 1174703240.854917, -------------- Report Sync ------------
Event: time 1174703240.867130, type 1 (Key), code 330 (Touch), value 0
         <---- touch=0 now, we drop pkt_count here
Event: time 1174703240.867133, type 3 (Absolute), code 0 (X), value 3913
Event: time 1174703240.867135, type 3 (Absolute), code 1 (Y), value 3699
Event: time 1174703240.867137, type 3 (Absolute), code 24 (Pressure), value 17
Event: time 1174703240.867139, -------------- Report Sync ------------
Event: time 1174703240.877716, type 3 (Absolute), code 0 (X), value 3899
Event: time 1174703240.877718, type 3 (Absolute), code 1 (Y), value 3720
Event: time 1174703240.877721, type 3 (Absolute), code 24 (Pressure), value 8
Event: time 1174703240.877723, type 3 (Absolute), code 28 (Tool Width), value 5
Event: time 1174703240.877725, -------------- Report Sync ------------
Event: time 1174703240.891954, type 3 (Absolute), code 0 (X), value 3898
Event: time 1174703240.891957, type 3 (Absolute), code 1 (Y), value 3746
Event: time 1174703240.891959, type 3 (Absolute), code 24 (Pressure), value 5
Event: time 1174703240.891960, type 3 (Absolute), code 28 (Tool Width), value 6
Event: time 1174703240.891965, -------------- Report Sync ------------
Event: time 1174703240.918746, type 3 (Absolute), code 0 (X), value 1
Event: time 1174703240.918749, type 3 (Absolute), code 1 (Y), value 5855
Event: time 1174703240.918751, type 3 (Absolute), code 24 (Pressure), value 3
Event: time 1174703240.918753, type 3 (Absolute), code 28 (Tool Width), value 5
Event: time 1174703240.918756, type 1 (Key), code 325 (ToolFinger), value 0
Event: time 1174703240.918758, type 1 (Key), code 333 (Tool Doubletap), value 1
Event: time 1174703240.918760, -------------- Report Sync ------------
Event: time 1174703240.929545, type 3 (Absolute), code 24 (Pressure), value 2
Event: time 1174703240.929549, -------------- Report Sync ------------
Event: time 1174703241.137650, type 3 (Absolute), code 24 (Pressure), value 1
Event: time 1174703241.137655, -------------- Report Sync ------------
Event: time 1174703241.386150, type 3 (Absolute), code 24 (Pressure), value 0
Event: time 1174703241.386153, type 3 (Absolute), code 28 (Tool Width), value 0
Event: time 1174703241.386155, type 1 (Key), code 333 (Tool Doubletap), value 0
Event: time 1174703241.386158, -------------- Report Sync ------------
Event: time 1174703243.119979, type 3 (Absolute), code 0 (X), value 4763
Event: time 1174703243.119982, type 3 (Absolute), code 1 (Y), value 1964
Event: time 1174703243.119984, type 3 (Absolute), code 24 (Pressure), value 8
Event: time 1174703243.119985, type 3 (Absolute), code 28 (Tool Width), value 5
Event: time 1174703243.119987, type 1 (Key), code 325 (ToolFinger), value 1
Event: time 1174703243.119990, -------------- Report Sync ------------
Event: time 1174703243.131696, type 3 (Absolute), code 0 (X), value 4760
Event: time 1174703243.131699, type 3 (Absolute), code 1 (Y), value 1961
Event: time 1174703243.131701, type 3 (Absolute), code 24 (Pressure), value 9
Event: time 1174703243.131703, -------------- Report Sync ------------
Event: time 1174703243.143436, type 3 (Absolute), code 24 (Pressure), value 12
Event: time 1174703243.143440, type 3 (Absolute), code 28 (Tool Width), value 4
Event: time 1174703243.143442, -------------- Report Sync ------------
Event: time 1174703243.157148, type 3 (Absolute), code 24 (Pressure), value 15
Event: time 1174703243.157153, -------------- Report Sync ------------
Event: time 1174703243.169804, type 3 (Absolute), code 0 (X), value 4757
Event: time 1174703243.169806, type 3 (Absolute), code 1 (Y), value 1999
Event: time 1174703243.169808, type 3 (Absolute), code 24 (Pressure), value 18
Event: time 1174703243.169811, -------------- Report Sync ------------
Event: time 1174703243.181728, type 3 (Absolute), code 0 (X), value 4753
Event: time 1174703243.181731, type 3 (Absolute), code 24 (Pressure), value 20
Event: time 1174703243.181735, -------------- Report Sync ------------
Event: time 1174703243.193445, type 3 (Absolute), code 24 (Pressure), value 21
Event: time 1174703243.193448, -------------- Report Sync ------------
Event: time 1174703243.206640, type 3 (Absolute), code 0 (X), value 4748
Event: time 1174703243.206643, type 3 (Absolute), code 1 (Y), value 1997
Event: time 1174703243.206645, type 3 (Absolute), code 24 (Pressure), value 23
Event: time 1174703243.206647, -------------- Report Sync ------------
Event: time 1174703243.219358, type 3 (Absolute), code 24 (Pressure), value 24
Event: time 1174703243.219362, -------------- Report Sync ------------
Event: time 1174703243.231448, type 3 (Absolute), code 0 (X), value 4752
Event: time 1174703243.231450, type 3 (Absolute), code 1 (Y), value 1993
Event: time 1174703243.231452, type 3 (Absolute), code 24 (Pressure), value 25
Event: time 1174703243.231455, -------------- Report Sync ------------
Event: time 1174703243.243435, type 3 (Absolute), code 1 (Y), value 1989
Event: time 1174703243.243438, type 3 (Absolute), code 24 (Pressure), value 27
Event: time 1174703243.243440, -------------- Report Sync ------------
Event: time 1174703243.255193, type 3 (Absolute), code 0 (X), value 4748
Event: time 1174703243.255197, type 3 (Absolute), code 24 (Pressure), value 28
Event: time 1174703243.255201, -------------- Report Sync ------------
Event: time 1174703243.268904, type 3 (Absolute), code 0 (X), value 4746
Event: time 1174703243.268907, type 3 (Absolute), code 1 (Y), value 1990
Event: time 1174703243.268909, type 3 (Absolute), code 24 (Pressure), value 29
Event: time 1174703243.268911, -------------- Report Sync ------------
Event: time 1174703243.293295, type 3 (Absolute), code 1 (Y), value 1986
Event: time 1174703243.293298, type 3 (Absolute), code 24 (Pressure), value 30
Event: time 1174703243.293301, -------------- Report Sync ------------
Event: time 1174703243.305535, type 1 (Key), code 330 (Touch), value 1
          <---- touch!=0 now, we're on
Event: time 1174703243.305538, type 3 (Absolute), code 24 (Pressure), value 31
Event: time 1174703243.305541, -------------- Report Sync ------------
          <---- We increment the pkt_count, leaving value of 3687 in old_y
Event: time 1174703243.342452, type 3 (Absolute), code 0 (X), value 4747
Event: time 1174703243.342455, type 3 (Absolute), code 1 (Y), value 1988
          <----- Later to be fy(1), not used for warping purposes :-)
Event: time 1174703243.342459, -------------- Report Sync ------------
Event: time 1174703243.356225, type 3 (Absolute), code 0 (X), value 4749
Event: time 1174703243.356237, type 3 (Absolute), code 1 (Y), value 1987
          <----- warp here, by the difference of 3687 and 1987, plus
                 some small frac_dy value. Easily jumps half the screen.
Event: time 1174703243.356246, -------------- Report Sync ------------

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mousedev.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff -puN drivers/input/mousedev.c~fix-sudden-warps-in-mousedev drivers/input/mousedev.c
--- a/drivers/input/mousedev.c~fix-sudden-warps-in-mousedev
+++ a/drivers/input/mousedev.c
@@ -278,6 +278,8 @@ static void mousedev_notify_readers(stru
 
 static void mousedev_touchpad_touch(struct mousedev *mousedev, int value)
 {
+	struct input_dev *dev;
+
 	if (!value) {
 		if (mousedev->touch &&
 		    time_before(jiffies, mousedev->touch + msecs_to_jiffies(tap_time))) {
@@ -297,8 +299,22 @@ static void mousedev_touchpad_touch(stru
 		mousedev->frac_dx = 0;
 		mousedev->frac_dy = 0;
 
-	} else if (!mousedev->touch)
+	} else if (!mousedev->touch) {
 		mousedev->touch = jiffies;
+		/*
+		 * Seed the ring with new position where finger has just landed.
+		 *
+		 * Without this, a touchpad may report an unchanged position,
+		 * then a sync. The input_event() eats the position report, but
+		 * lets the sync through. We increment pkt_count and leave
+		 * a stale position in the ring. If a future reference to fx(2)
+		 * hits the stale position, a large dx is reported, and the
+		 * pointer warps across the screen.
+		 */
+		dev = mousedev->handle.dev;
+		fx(0) = dev->abs[ABS_X];
+		fy(0) = dev->abs[ABS_Y];
+	}
 }
 
 static void mousedev_event(struct input_handle *handle, unsigned int type, unsigned int code, int value)
_

Patches currently in -mm which might be from zaitcev@redhat.com are

origin.patch
fix-sudden-warps-in-mousedev.patch
