From: akpm@linux-foundation.org
Subject: + rtc-ds1307-remove-legacy-probe-checks.patch added to -mm tree
Date: Mon, 27 Oct 2008 23:33:17 -0700
Message-ID: <200810280633.m9S6XHJ6025942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532AbYJ1Ge5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 02:34:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: juri.reitel@liewenthal.ee, a.zummo@towertech.it, dbrownell@users.sourceforge.net, giometti@enneenne.com, khali@linux-fr.org, sbarre@sdelcc.com


The patch titled
     rtc-ds1307: remove legacy probe() checks
has been added to the -mm tree.  Its filename is
     rtc-ds1307-remove-legacy-probe-checks.patch

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
Subject: rtc-ds1307: remove legacy probe() checks
=46rom: J=FCri Reitel <juri.reitel@liewenthal.ee>

Remove RTC register value checks from the rtc-ds1307 probe() function.=20
They were left over from the legacy style I2C driver, which had to defe=
nd
against finding a non-RTC chip when the driver was probed.

Also fix a minor glitch in the alarm support: DS1307 chips don't have
alarms, so name those methods after one of the chips which actually *do=
*
have alarms (DS1337).

Signed-off-by: J=FCri Reitel <juri.reitel@liewenthal.ee>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Sebastien Barre <sbarre@sdelcc.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   31 ++++---------------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-remove-legacy-probe-check=
s drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-remove-legacy-probe-checks
+++ a/drivers/rtc/rtc-ds1307.c
@@ -287,7 +287,7 @@ static int ds1307_set_time(struct device
 	return 0;
 }
=20
-static int ds1307_read_alarm(struct device *dev, struct rtc_wkalrm *t)
+static int ds1337_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct i2c_client       *client =3D to_i2c_client(dev);
 	struct ds1307		*ds1307 =3D i2c_get_clientdata(client);
@@ -338,7 +338,7 @@ static int ds1307_read_alarm(struct devi
 	return 0;
 }
=20
-static int ds1307_set_alarm(struct device *dev, struct rtc_wkalrm *t)
+static int ds1337_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct i2c_client       *client =3D to_i2c_client(dev);
 	struct ds1307		*ds1307 =3D i2c_get_clientdata(client);
@@ -452,8 +452,8 @@ static int ds1307_ioctl(struct device *d
 static const struct rtc_class_ops ds13xx_rtc_ops =3D {
 	.read_time	=3D ds1307_get_time,
 	.set_time	=3D ds1307_set_time,
-	.read_alarm	=3D ds1307_read_alarm,
-	.set_alarm	=3D ds1307_set_alarm,
+	.read_alarm	=3D ds1337_read_alarm,
+	.set_alarm	=3D ds1337_set_alarm,
 	.ioctl		=3D ds1307_ioctl,
 };
=20
@@ -654,22 +654,6 @@ read_rtc:
 		break;
 	}
=20
-	tmp =3D ds1307->regs[DS1307_REG_SECS];
-	tmp =3D bcd2bin(tmp & 0x7f);
-	if (tmp > 60)
-		goto exit_bad;
-	tmp =3D bcd2bin(ds1307->regs[DS1307_REG_MIN] & 0x7f);
-	if (tmp > 60)
-		goto exit_bad;
-
-	tmp =3D bcd2bin(ds1307->regs[DS1307_REG_MDAY] & 0x3f);
-	if (tmp =3D=3D 0 || tmp > 31)
-		goto exit_bad;
-
-	tmp =3D bcd2bin(ds1307->regs[DS1307_REG_MONTH] & 0x1f);
-	if (tmp =3D=3D 0 || tmp > 12)
-		goto exit_bad;
-
 	tmp =3D ds1307->regs[DS1307_REG_HOUR];
 	switch (ds1307->type) {
 	case ds_1340:
@@ -726,13 +710,6 @@ read_rtc:
=20
 	return 0;
=20
-exit_bad:
-	dev_dbg(&client->dev, "%s: %02x %02x %02x %02x %02x %02x %02x\n",
-			"bogus register",
-			ds1307->regs[0], ds1307->regs[1],
-			ds1307->regs[2], ds1307->regs[3],
-			ds1307->regs[4], ds1307->regs[5],
-			ds1307->regs[6]);
 exit_irq:
 	if (ds1307->rtc)
 		rtc_device_unregister(ds1307->rtc);
_

Patches currently in -mm which might be from juri.reitel@liewenthal.ee =
are

rtc-ds1307-remove-legacy-probe-checks.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
