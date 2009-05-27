From: akpm@linux-foundation.org
Subject: + lis3-add-three-new-laptop-models.patch added to -mm tree
Date: Tue, 26 May 2009 19:22:30 -0700
Message-ID: <200905270222.n4R2MULN030850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756467AbZE0CWf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 22:22:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.piel@tremplin-utc.net, isaac702@gmail.com, morpheus.ibis@gmail.com, pavel@ucw.cz, slateroni@gmail.com


The patch titled
     lis3: add three new laptop models
has been added to the -mm tree.  Its filename is
     lis3-add-three-new-laptop-models.patch

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
Subject: lis3: add three new laptop models
From: Eric Piel <eric.piel@tremplin-utc.net>

Separate the 6710 and 6715, and set the right axis information for the
6715.
Reported-by: Isaac702 <isaac702@gmail.com>

Add the 6930.
Reported-by: Christian Weidle <slateroni@gmail.com>

Add the 2710.
Reported-by: Pavel Herrmann <morpheus.ibis@gmail.com>

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/hwmon/hp_accel.c~lis3-add-three-new-laptop-models drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~lis3-add-three-new-laptop-models
+++ a/drivers/hwmon/hp_accel.c
@@ -158,6 +158,7 @@ static struct axis_conversion lis3lv02d_
 static struct axis_conversion lis3lv02d_axis_y_inverted = {1, -2, 3};
 static struct axis_conversion lis3lv02d_axis_x_inverted = {-1, 2, 3};
 static struct axis_conversion lis3lv02d_axis_z_inverted = {1, 2, -3};
+static struct axis_conversion lis3lv02d_axis_xy_swap = {2, 1, 3};
 static struct axis_conversion lis3lv02d_axis_xy_rotated_left = {-2, 1, 3};
 static struct axis_conversion lis3lv02d_axis_xy_rotated_left_usd = {-2, 1, -3};
 static struct axis_conversion lis3lv02d_axis_xy_swap_inverted = {-2, -1, 3};
@@ -191,13 +192,16 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("NX9420", "HP Compaq nx9420", x_inverted),
 	AXIS_DMI_MATCH("NW9440", "HP Compaq nw9440", x_inverted),
 	AXIS_DMI_MATCH("NC2510", "HP Compaq 2510", y_inverted),
+	AXIS_DMI_MATCH("NC2710", "HP Compaq 2710", xy_swap),
 	AXIS_DMI_MATCH("NC8510", "HP Compaq 8510", xy_swap_inverted),
 	AXIS_DMI_MATCH("HP2133", "HP 2133", xy_rotated_left),
 	AXIS_DMI_MATCH("HP2140", "HP 2140", xy_swap_inverted),
 	AXIS_DMI_MATCH("NC653x", "HP Compaq 653", xy_rotated_left_usd),
 	AXIS_DMI_MATCH("NC673x", "HP Compaq 673", xy_rotated_left_usd),
 	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
-	AXIS_DMI_MATCH("NC671xx", "HP Compaq 671", xy_swap_yz_inverted),
+	AXIS_DMI_MATCH("NC6710x", "HP Compaq 6710", xy_swap_yz_inverted),
+	AXIS_DMI_MATCH("NC6715x", "HP Compaq 6715", y_inverted),
+	AXIS_DMI_MATCH("NC693xx", "HP EliteBook 693", xy_rotated_right),
 	/* Intel-based HP Pavilion dv5 */
 	AXIS_DMI_MATCH2("HPDV5_I",
 			PRODUCT_NAME, "HP Pavilion dv5",
@@ -213,7 +217,6 @@ static struct dmi_system_id lis3lv02d_dm
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"
- * HP Compaq 8710x Notebook PC / Mobile Workstation
  * "NC2400" "HP Compaq nc2400"
  * "NX74x0" "HP Compaq nx74"
  * "NX6325" "HP Compaq nx6325"
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net are

linux-next.patch
lis3-fix-misc-device-unregistering-and-printk.patch
lis3-remove-automatic-shutdown-of-the-device.patch
lis3-use-input_polled_device.patch
lis3-add-three-new-laptop-models.patch

