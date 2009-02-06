From: akpm@linux-foundation.org
Subject: [merged] lis3lv02d-add-axes-knowledge-for-hp-6710.patch removed from -mm tree
Date: Fri, 06 Feb 2009 11:38:02 -0800
Message-ID: <200902061938.n16Jc2nn011743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753885AbZBFTiJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:38:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gkmarty@gmail.com, eric.piel@tremplin-utc.net, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     lis3lv02d: add axes knowledge for HP 6710
has been removed from the -mm tree.  Its filename was
     lis3lv02d-add-axes-knowledge-for-hp-6710.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lis3lv02d: add axes knowledge for HP 6710
From: Martin Kebert <gkmarty@gmail.com>

Add support for the HP laptops of model 6710x for having correctly setup
axes.

Signed-off-by: Martin Kebert <gkmarty@gmail.com>
Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/hp_accel.c~lis3lv02d-add-axes-knowledge-for-hp-6710 drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~lis3lv02d-add-axes-knowledge-for-hp-6710
+++ a/drivers/hwmon/hp_accel.c
@@ -156,6 +156,7 @@ static struct axis_conversion lis3lv02d_
 static struct axis_conversion lis3lv02d_axis_xy_rotated_left_usd = {-2, 1, -3};
 static struct axis_conversion lis3lv02d_axis_xy_swap_inverted = {-2, -1, 3};
 static struct axis_conversion lis3lv02d_axis_xy_rotated_right = {2, -1, 3};
+static struct axis_conversion lis3lv02d_axis_xy_swap_yz_inverted = {2, -1, -3};
 
 #define AXIS_DMI_MATCH(_ident, _name, _axis) {		\
 	.ident = _ident,				\
@@ -177,9 +178,9 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("NC653x", "HP Compaq 653", xy_rotated_left_usd),
 	AXIS_DMI_MATCH("NC673x", "HP Compaq 673", xy_rotated_left_usd),
 	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
+	AXIS_DMI_MATCH("NC671xx", "HP Compaq 671", xy_swap_yz_inverted),
 	{ NULL, }
 /* Laptop models without axis info (yet):
- * "NC671xx" "HP Compaq 671"
  * "NC6910" "HP Compaq 6910"
  * HP Compaq 8710x Notebook PC / Mobile Workstation
  * "NC2400" "HP Compaq nc2400"
_

Patches currently in -mm which might be from gkmarty@gmail.com are

origin.patch

