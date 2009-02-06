From: akpm@linux-foundation.org
Subject: [merged] lis3lv02d-add-axes-knowledge-for-hp-6510b.patch removed from -mm tree
Date: Fri, 06 Feb 2009 11:37:54 -0800
Message-ID: <200902061937.n16Jbs0w011503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753824AbZBFTiH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:38:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tersel@mail.muni.cz, eric.piel@tremplin-utc.net, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     lis3lv02d: add axes knowledge for HP 6510b
has been removed from the -mm tree.  Its filename was
     lis3lv02d-add-axes-knowledge-for-hp-6510b.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lis3lv02d: add axes knowledge for HP 6510b
From: Jiri Tersel <tersel@mail.muni.cz>

According to dmesg my laptop model HP 6510b is not being recognized by this
driver. After I have modified "lis3lv02d.c" axes in Neverball are OK.

Signed-off-by: Jiri Tersel <tersel@mail.muni.cz>
Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/hp_accel.c~lis3lv02d-add-axes-knowledge-for-hp-6510b drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~lis3lv02d-add-axes-knowledge-for-hp-6510b
+++ a/drivers/hwmon/hp_accel.c
@@ -154,6 +154,7 @@ static struct axis_conversion lis3lv02d_
 static struct axis_conversion lis3lv02d_axis_z_inverted = {1, 2, -3};
 static struct axis_conversion lis3lv02d_axis_xy_rotated_left = {-2, 1, 3};
 static struct axis_conversion lis3lv02d_axis_xy_swap_inverted = {-2, -1, 3};
+static struct axis_conversion lis3lv02d_axis_xy_rotated_right = {2, -1, 3};
 
 #define AXIS_DMI_MATCH(_ident, _name, _axis) {		\
 	.ident = _ident,				\
@@ -172,9 +173,9 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("NC2510", "HP Compaq 2510", y_inverted),
 	AXIS_DMI_MATCH("NC8510", "HP Compaq 8510", xy_swap_inverted),
 	AXIS_DMI_MATCH("HP2133", "HP 2133", xy_rotated_left),
+	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
 	{ NULL, }
 /* Laptop models without axis info (yet):
- * "NC651xx" "HP Compaq 651"
  * "NC671xx" "HP Compaq 671"
  * "NC6910" "HP Compaq 6910"
  * HP Compaq 8710x Notebook PC / Mobile Workstation
_

Patches currently in -mm which might be from tersel@mail.muni.cz are

origin.patch

