From: akpm@linux-foundation.org
Subject: [merged] lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:16:51 -0800
Message-ID: <200902191916.n1JJGp6W016292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281AbZBSTQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:16:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giuseppe.bilotta@gmail.com, Eric.Piel@tremplin-utc.net, palatis@gmail.com, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     lis3lv02d: add axes knowledge of HP Pavilion dv5 models
has been removed from the -mm tree.  Its filename was
     lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lis3lv02d: add axes knowledge of HP Pavilion dv5 models
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>

Add support for HP Pavilion dv5.

Since Intel-based models have an inverted x axis, while AMD-based models
have an inverted y axis, we introduce a new macro that special-cases axis
orientation based on two DMI entries: HP dv5 axis configuration is then
based on both the PRODUCT and BOARD name.

Signed-off-by: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: Eric Piel <Eric.Piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@suse.cz>
Tested-by: Palatis Tseng <palatis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN drivers/hwmon/hp_accel.c~lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models
+++ a/drivers/hwmon/hp_accel.c
@@ -166,6 +166,18 @@ static struct axis_conversion lis3lv02d_
 	},						\
 	.driver_data = &lis3lv02d_axis_##_axis		\
 }
+
+#define AXIS_DMI_MATCH2(_ident, _class1, _name1,	\
+				_class2, _name2,	\
+				_axis) {		\
+	.ident = _ident,				\
+	.callback = lis3lv02d_dmi_matched,		\
+	.matches = {					\
+		DMI_MATCH(DMI_##_class1, _name1),	\
+		DMI_MATCH(DMI_##_class2, _name2),	\
+	},						\
+	.driver_data = &lis3lv02d_axis_##_axis		\
+}
 static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 	/* product names are truncated to match all kinds of a same model */
 	AXIS_DMI_MATCH("NC64x0", "HP Compaq nc64", x_inverted),
@@ -179,6 +191,16 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("NC673x", "HP Compaq 673", xy_rotated_left_usd),
 	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
 	AXIS_DMI_MATCH("NC671xx", "HP Compaq 671", xy_swap_yz_inverted),
+	/* Intel-based HP Pavilion dv5 */
+	AXIS_DMI_MATCH2("HPDV5_I",
+			PRODUCT_NAME, "HP Pavilion dv5",
+			BOARD_NAME, "3603",
+			x_inverted),
+	/* AMD-based HP Pavilion dv5 */
+	AXIS_DMI_MATCH2("HPDV5_A",
+			PRODUCT_NAME, "HP Pavilion dv5",
+			BOARD_NAME, "3600",
+			y_inverted),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"
_

Patches currently in -mm which might be from giuseppe.bilotta@gmail.com are

origin.patch

