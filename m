From: akpm@linux-foundation.org
Subject: + lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models.patch added to -mm tree
Date: Wed, 11 Feb 2009 14:50:47 -0800
Message-ID: <200902112250.n1BMoltU018485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756264AbZBKWu5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 17:50:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giuseppe.bilotta@gmail.com, Eric.Piel@tremplin-utc.net, palatis@gmail.com, pavel@suse.cz


The patch titled
     lis3lv02d: add axes knowledge of HP Pavilion dv5 models
has been added to the -mm tree.  Its filename is
     lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models.patch

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

lis3lv02d-support-both-one-and-two-byte-sensors.patch
lis3lv02d-support-both-one-and-two-byte-sensors-checkpatch-fixes.patch
lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models.patch

