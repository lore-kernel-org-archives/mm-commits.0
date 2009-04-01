From: akpm@linux-foundation.org
Subject: [merged] hp_accel-small-documentation-updates.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:40:58 -0700
Message-ID: <200904011840.n31IewHi009177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763496AbZDATpk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:45:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, Quoc.Pham@hp.com, eric.piel@tremplin-utc.net, pavel@suse.cz, vbotka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     hp_accel: small documentation updates
has been removed from the -mm tree.  Its filename was
     hp_accel-small-documentation-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hp_accel: small documentation updates
From: Pavel Machek <pavel@ucw.cz>

Fix english in Documentation, add "how to test" description.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Vladimir Botka <vbotka@suse.cz>
Cc: <Quoc.Pham@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/lis3lv02d |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN Documentation/hwmon/lis3lv02d~hp_accel-small-documentation-updates Documentation/hwmon/lis3lv02d
--- a/Documentation/hwmon/lis3lv02d~hp_accel-small-documentation-updates
+++ a/Documentation/hwmon/lis3lv02d
@@ -1,11 +1,11 @@
 Kernel driver lis3lv02d
-==================
+=======================
 
 Supported chips:
 
   * STMicroelectronics LIS3LV02DL and LIS3LV02DQ
 
-Author:
+Authors:
         Yan Burman <burman.yan@gmail.com>
 	Eric Piel <eric.piel@tremplin-utc.net>
 
@@ -15,7 +15,7 @@ Description
 
 This driver provides support for the accelerometer found in various HP
 laptops sporting the feature officially called "HP Mobile Data
-Protection System 3D" or "HP 3D DriveGuard". It detect automatically
+Protection System 3D" or "HP 3D DriveGuard". It detects automatically
 laptops with this sensor. Known models (for now the HP 2133, nc6420,
 nc2510, nc8510, nc84x0, nw9440 and nx9420) will have their axis
 automatically oriented on standard way (eg: you can directly play
@@ -27,7 +27,7 @@ position - 3D position that the accelero
 calibrate - read: values (x, y, z) that are used as the base for input
 		  class device operation.
             write: forces the base to be recalibrated with the current
-		  position.
+		   position.
 rate - reports the sampling rate of the accelerometer device in HZ
 
 This driver also provides an absolute input class device, allowing
@@ -48,7 +48,7 @@ For better compatibility between the var
 the accelerometer are converted into a "standard" organisation of the axes
 (aka "can play neverball out of the box"):
  * When the laptop is horizontal the position reported is about 0 for X and Y
-and a positive value for Z
+	and a positive value for Z
  * If the left side is elevated, X increases (becomes positive)
  * If the front side (where the touchpad is) is elevated, Y decreases
 	(becomes negative)
@@ -59,3 +59,13 @@ email to the authors to add it to the da
 laptop, please include the output of "dmidecode" plus the value of
 /sys/devices/platform/lis3lv02d/position in these four cases.
 
+Q&A
+---
+
+Q: How do I safely simulate freefall? I have an HP "portable
+workstation" which has about 3.5kg and a plastic case, so letting it
+fall to the ground is out of question...
+
+A: The sensor is pretty sensitive, so your hands can do it. Lift it
+into free space, follow the fall with your hands for like 10
+centimeters. That should be enough to trigger the detection.
_

Patches currently in -mm which might be from pavel@ucw.cz are

origin.patch
linux-next.patch

