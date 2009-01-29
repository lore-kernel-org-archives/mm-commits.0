From: akpm@linux-foundation.org
Subject: + lis3lv02d-add-axes-knowledge-for-hp-6530.patch added to -mm tree
Date: Wed, 28 Jan 2009 16:55:57 -0800
Message-ID: <200901290055.n0T0tvNu016517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754632AbZA2A4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jan 2009 19:56:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.piel@tremplin-utc.net, jeromepoulin@gmail.com, pavel@suse.cz


The patch titled
     lis3lv02d: add axes knowledge for HP 6530
has been added to the -mm tree.  Its filename is
     lis3lv02d-add-axes-knowledge-for-hp-6530.patch

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
Subject: lis3lv02d: add axes knowledge for HP 6530
From: Eric Piel <eric.piel@tremplin-utc.net>

Add support for the HP laptops of model 6530x for having correctly setup
axes.

Reported-by: Jerome Poulin <jeromepoulin@gmail.com>
Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/hwmon/hp_accel.c~lis3lv02d-add-axes-knowledge-for-hp-6530 drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~lis3lv02d-add-axes-knowledge-for-hp-6530
+++ a/drivers/hwmon/hp_accel.c
@@ -153,6 +153,7 @@ static struct axis_conversion lis3lv02d_
 static struct axis_conversion lis3lv02d_axis_x_inverted = {-1, 2, 3};
 static struct axis_conversion lis3lv02d_axis_z_inverted = {1, 2, -3};
 static struct axis_conversion lis3lv02d_axis_xy_rotated_left = {-2, 1, 3};
+static struct axis_conversion lis3lv02d_axis_xy_rotated_left_usd = {-2, 1, -3};
 static struct axis_conversion lis3lv02d_axis_xy_swap_inverted = {-2, -1, 3};
 static struct axis_conversion lis3lv02d_axis_xy_rotated_right = {2, -1, 3};
 
@@ -173,6 +174,7 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("NC2510", "HP Compaq 2510", y_inverted),
 	AXIS_DMI_MATCH("NC8510", "HP Compaq 8510", xy_swap_inverted),
 	AXIS_DMI_MATCH("HP2133", "HP 2133", xy_rotated_left),
+	AXIS_DMI_MATCH("NC653x", "HP Compaq 653", xy_rotated_left_usd),
 	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
 	{ NULL, }
 /* Laptop models without axis info (yet):
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net are

lis3lv02d-add-axes-knowledge-for-hp-6510b.patch
lis3lv02d-add-axes-knowledge-for-hp-6530.patch
lis3lv02d-add-axes-knowledge-for-hp-6730.patch
lis3lv02d-add-axes-knowledge-for-hp-6710.patch
hp-accelerometer-add-freefall-detection.patch

