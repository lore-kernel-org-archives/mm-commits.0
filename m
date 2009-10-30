From: akpm@linux-foundation.org
Subject: [merged] lis3-better-support-for-hp-6730x.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:52:50 -0700
Message-ID: <200910302052.n9UKqopG016258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932727AbZJ3Uxa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:53:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: morpheus.ibis@gmail.com, eric.piel@tremplin-utc.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     lis3: better support for hp 6730x
has been removed from the -mm tree.  Its filename was
     lis3-better-support-for-hp-6730x.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: lis3: better support for hp 6730x
=46rom: Pavel Herrmann <morpheus.ibis@gmail.com>

I have learned that the 6730b and 6730s have different accelerometer
orientation, and have modified the driver accordingly (diff attached),
while dropping the wild guess for AMD based 6735 having the same
orientation as Intel based 6730 (this is not true for any other related
series/family, thus is not probable for 673x).

Signed-off-by: Pavel Herrmann <morpheus.ibis@gmail.com>
Signed-off-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/hwmon/hp_accel.c~lis3-better-support-for-hp-6730x dri=
vers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~lis3-better-support-for-hp-6730x
+++ a/drivers/hwmon/hp_accel.c
@@ -197,7 +197,8 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("HP2133", "HP 2133", xy_rotated_left),
 	AXIS_DMI_MATCH("HP2140", "HP 2140", xy_swap_inverted),
 	AXIS_DMI_MATCH("NC653x", "HP Compaq 653", xy_rotated_left_usd),
-	AXIS_DMI_MATCH("NC673x", "HP Compaq 673", xy_rotated_left_usd),
+	AXIS_DMI_MATCH("NC6730b", "HP Compaq 6730b", xy_rotated_left_usd),
+	AXIS_DMI_MATCH("NC6730s", "HP Compaq 6730s", xy_swap),
 	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
 	AXIS_DMI_MATCH("NC6710x", "HP Compaq 6710", xy_swap_yz_inverted),
 	AXIS_DMI_MATCH("NC6715x", "HP Compaq 6715", y_inverted),
_

Patches currently in -mm which might be from morpheus.ibis@gmail.com ar=
e

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
