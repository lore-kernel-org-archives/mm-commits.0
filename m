From: akpm@linux-foundation.org
Subject: +
 rtc-rtc-isl12057-add-proper-handling-of-oscillator-failure-bit.patch added
 to -mm tree
Date: Tue, 25 Nov 2014 13:30:29 -0800
Message-ID: <5474f4f5.pbsBcwgoZPigZFdv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaKYVaa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Nov 2014 16:30:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arno@natisbad.org, a.zummo@towertech.it, broonie@kernel.org, grant.likely@linaro.org, linus.walleij@linaro.org, mark.rutland@arm.com, peter.huewe@infineon.com, treding@nvidia.com, uwe@kleine-koenig.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-isl12057.c: add proper handling of oscill=
ator failure bit
has been added to the -mm tree.  Its filename is
     rtc-rtc-isl12057-add-proper-handling-of-oscillator-failure-bit.pat=
ch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-isl12057-add-prope=
r-handling-of-oscillator-failure-bit.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-isl12057-add-p=
roper-handling-of-oscillator-failure-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Arnaud Ebalard <arno@natisbad.org>
Subject: drivers/rtc/rtc-isl12057.c: add proper handling of oscillator =
failure bit

As suggested by Uwe, instead of clearing oscillator failure bit
unconditionally at driver load, this patch adds proper handling of the
flag.  The driver now returns -ENODATA when reading time from the devic=
e
and oscillator failure bit is set.  The flag is now cleared only when t=
he
a new time value is pushed to the device.

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Reported-by: Uwe Kleine-K=F6nig <uwe@kleine-koenig.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Peter Huewe <peter.huewe@infineon.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl12057.c |   47 ++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff -puN drivers/rtc/rtc-isl12057.c~rtc-rtc-isl12057-add-proper-handli=
ng-of-oscillator-failure-bit drivers/rtc/rtc-isl12057.c
--- a/drivers/rtc/rtc-isl12057.c~rtc-rtc-isl12057-add-proper-handling-o=
f-oscillator-failure-bit
+++ a/drivers/rtc/rtc-isl12057.c
@@ -164,17 +164,32 @@ static int isl12057_rtc_read_time(struct
 {
 	struct isl12057_rtc_data *data =3D dev_get_drvdata(dev);
 	u8 regs[ISL12057_RTC_SEC_LEN];
+	unsigned int sr;
 	int ret;
=20
 	mutex_lock(&data->lock);
+	ret =3D regmap_read(data->regmap, ISL12057_REG_SR, &sr);
+	if (ret) {
+		dev_err(dev, "%s: unable to read oscillator status flag\n",
+			__func__);
+		goto out;
+	} else {
+		if (sr & ISL12057_REG_SR_OSF) {
+			ret =3D -ENODATA;
+			goto out;
+		}
+	}
+
 	ret =3D regmap_bulk_read(data->regmap, ISL12057_REG_RTC_SC, regs,
 			       ISL12057_RTC_SEC_LEN);
+	if (ret)
+		dev_err(dev, "%s: unable to read RTC time\n", __func__);
+
+out:
 	mutex_unlock(&data->lock);
=20
-	if (ret) {
-		dev_err(dev, "%s: RTC read failed\n", __func__);
+	if (ret)
 		return ret;
-	}
=20
 	isl12057_rtc_regs_to_tm(tm, regs);
=20
@@ -194,10 +209,22 @@ static int isl12057_rtc_set_time(struct
 	mutex_lock(&data->lock);
 	ret =3D regmap_bulk_write(data->regmap, ISL12057_REG_RTC_SC, regs,
 				ISL12057_RTC_SEC_LEN);
-	mutex_unlock(&data->lock);
+	if (ret) {
+		dev_err(dev, "%s: writing RTC time failed\n", __func__);
+		goto out;
+	}
=20
-	if (ret)
-		dev_err(dev, "%s: RTC write failed\n", __func__);
+	/*
+	 * Now that RTC time has been updated, let's clear oscillator
+	 * failure flag, if needed.
+	 */
+	ret =3D regmap_update_bits(data->regmap, ISL12057_REG_SR,
+				 ISL12057_REG_SR_OSF, 0);
+	if (ret < 0)
+		dev_err(dev, "Unable to clear oscillator failure bit\n");
+
+out:
+	mutex_unlock(&data->lock);
=20
 	return ret;
 }
@@ -219,14 +246,6 @@ static int isl12057_check_rtc_status(str
 		return ret;
 	}
=20
-	/* Clear oscillator failure bit if needed */
-	ret =3D regmap_update_bits(regmap, ISL12057_REG_SR,
-				 ISL12057_REG_SR_OSF, 0);
-	if (ret < 0) {
-		dev_err(dev, "Unable to clear oscillator failure bit\n");
-		return ret;
-	}
