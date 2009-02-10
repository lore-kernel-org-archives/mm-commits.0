From: akpm@linux-foundation.org
Subject: [to-be-updated] lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models.patch removed from -mm tree
Date: Tue, 10 Feb 2009 15:47:33 -0800
Message-ID: <200902102347.n1ANlYkI011003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755388AbZBJXrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 18:47:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giuseppe.bilotta@gmail.com, Eric.Piel@tremplin-utc.net, palatis@gmail.com, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     lis3lv02d: add axes knowledge of HP Pavilion dv5 models
has been removed from the -mm tree.  Its filename was
     lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lis3lv02d: add axes knowledge of HP Pavilion dv5 models
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>

Add support for HP Pavlion dv5 models, whose sensor has an inverted x
axis.

My HP Pavilion dv5 has an inverted x axis of the accelerometer, so this
patch marks the inversion for all the dv5.

Signed-off-by: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Acked-by: Eric Piel <Eric.Piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Palatis Tseng <palatis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/hwmon/hp_accel.c~lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models
+++ a/drivers/hwmon/hp_accel.c
@@ -179,6 +179,7 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("NC673x", "HP Compaq 673", xy_rotated_left_usd),
 	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
 	AXIS_DMI_MATCH("NC671xx", "HP Compaq 671", xy_swap_yz_inverted),
+	AXIS_DMI_MATCH("HPDV5", "HP Pavilion dv5", x_inverted),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"
_

Patches currently in -mm which might be from giuseppe.bilotta@gmail.com are

lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models.patch

