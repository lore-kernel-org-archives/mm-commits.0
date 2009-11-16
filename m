From: akpm@linux-foundation.org
Subject: + lis3-fix-show-rate-for-8-bits-chips.patch added to -mm tree
Date: Mon, 16 Nov 2009 12:04:16 -0800
Message-ID: <200911162004.nAGK4G2V027821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753622AbZKPUES (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 15:04:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.piel@tremplin-utc.net, pavel@ucw.cz, samu.p.onkalo@nokia.com


The patch titled
     lis3: fix show rate for 8 bits chips
has been added to the -mm tree.  Its filename is
     lis3-fix-show-rate-for-8-bits-chips.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: lis3: fix show rate for 8 bits chips
=46rom: =C9ric Piel <eric.piel@tremplin-utc.net>

lis3: fix with 8 bits sensors

Signed-off-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c |   24 ++++++++++++++++--------
 drivers/hwmon/lis3lv02d.h |    1 +
 2 files changed, 17 insertions(+), 8 deletions(-)

diff -puN drivers/hwmon/lis3lv02d.c~lis3-fix-show-rate-for-8-bits-chips=
 drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-fix-show-rate-for-8-bits-chips
+++ a/drivers/hwmon/lis3lv02d.c
@@ -127,12 +127,14 @@ void lis3lv02d_poweron(struct lis3lv02d=20
=20
 	/*
 	 * Common configuration
-	 * BDU: LSB and MSB values are not updated until both have been read.
-	 *      So the value read will always be correct.
+	 * BDU: (12 bits sensors only) LSB and MSB values are not updated unt=
il
+	 *      both have been read. So the value read will always be correct=
=2E
 	 */
-	lis3->read(lis3, CTRL_REG2, &reg);
-	reg |=3D CTRL2_BDU;
-	lis3->write(lis3, CTRL_REG2, reg);
+	if (lis3->whoami =3D=3D  WAI_12B) {
+		lis3->read(lis3, CTRL_REG2, &reg);
+		reg |=3D CTRL2_BDU;
+		lis3->write(lis3, CTRL_REG2, reg);
+	}
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
=20
@@ -363,7 +365,8 @@ static ssize_t lis3lv02d_calibrate_store
 }
=20
 /* conversion btw sampling rate and the register values */
-static int lis3lv02dl_df_val[4] =3D {40, 160, 640, 2560};
+static int lis3_12_rates[4] =3D {40, 160, 640, 2560};
+static int lis3_8_rates[2] =3D {100, 400};
 static ssize_t lis3lv02d_rate_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
@@ -371,8 +374,13 @@ static ssize_t lis3lv02d_rate_show(struc
 	int val;
=20
 	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
-	val =3D (ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4;
-	return sprintf(buf, "%d\n", lis3lv02dl_df_val[val]);
+
+	if (lis3_dev.whoami =3D=3D WAI_12B)
+		val =3D lis3_12_rates[(ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4];
+	else
+		val =3D lis3_8_rates[(ctrl & CTRL1_DR) >> 7];
+
+	return sprintf(buf, "%d\n", val);
 }
=20
 static DEVICE_ATTR(position, S_IRUGO, lis3lv02d_position_show, NULL);
diff -puN drivers/hwmon/lis3lv02d.h~lis3-fix-show-rate-for-8-bits-chips=
 drivers/hwmon/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3-fix-show-rate-for-8-bits-chips
+++ a/drivers/hwmon/lis3lv02d.h
@@ -107,6 +107,7 @@ enum lis3lv02d_ctrl1 {
 	CTRL1_DF1	=3D 0x20,
 	CTRL1_PD0	=3D 0x40,
 	CTRL1_PD1	=3D 0x80,
+	CTRL1_DR	=3D 0x80, /* Data rate on 8 bits */
 };
 enum lis3lv02d_ctrl2 {
 	CTRL2_DAS	=3D 0x01,
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net=
 are

linux-next.patch
lis3lv02d-axis-remap-and-resource-setup-release.patch
lis3lv02d-i2c-support.patch
lis3lv02d-send-sync-event.patch
lis3lv02d-correct-memory-leak-in-module-unload.patch
lis3-update-documentation-and-comments.patch
lis3-fix-show-rate-for-8-bits-chips.patch
lis3lv02d-proper-power-on-sequence.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
