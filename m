From: akpm@linux-foundation.org
Subject: [merged] hp_accel-axis-conversion-for-hp-compaq-8710w.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:41:11 -0700
Message-ID: <200904011841.n31IfBSs009286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755743AbZDASoy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:44:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lcappa@gmail.com, eric.piel@tremplin-utc.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     hp_accel: axis conversion for hp compaq 8710w
has been removed from the -mm tree.  Its filename was
     hp_accel-axis-conversion-for-hp-compaq-8710w.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hp_accel: axis conversion for hp compaq 8710w
From: Luca Cappa <lcappa@gmail.com>

I have a laptop HP Compaq 8710W, I compiled into my kernel the LIS3LV02DL
and HP_ACCEL module drivers.  While loading it cannot recognize the laptop
model, so i am sending the necessary information to update the database of
axis orientations.

>When the laptop is horizontal the position reported is about 0 for X and Y
>and a positive value for Z
Yes, it is about 0,0,1000, the actual reading says: (-17,-26,1018);

> If the left side is elevated, X increases (becomes positive)
Yes, X goes toward to positive 1000.

>If the front side (where the touchpad is) is elevated, Y decreases (becomes negative)
No, Y goes toward to positive 1000.

>If the laptop is put upside-down, Z becomes negative
Yes, the laptop on a table Z gives 1000, and if upsidedown the Z reads
-1000.

So in few words the Y axis is inverted.

Cc: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/hwmon/hp_accel.c~hp_accel-axis-conversion-for-hp-compaq-8710w drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~hp_accel-axis-conversion-for-hp-compaq-8710w
+++ a/drivers/hwmon/hp_accel.c
@@ -203,6 +203,7 @@ static struct dmi_system_id lis3lv02d_dm
 			BOARD_NAME, "3600",
 			y_inverted),
 	AXIS_DMI_MATCH("DV7", "HP Pavilion dv7", x_inverted),
+	AXIS_DMI_MATCH("HP8710", "HP Compaq 8710", y_inverted),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"
_

Patches currently in -mm which might be from lcappa@gmail.com are

origin.patch

