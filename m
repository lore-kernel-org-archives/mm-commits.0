From: akpm@linux-foundation.org
Subject: +
 rtc-rtc-isl12057-report-error-code-upon-failure-in-dev_err-calls.patch
 added to -mm tree
Date: Tue, 25 Nov 2014 13:30:33 -0800
Message-ID: <5474f4f9.60QHEsxuuIBjFiDQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaKYVae (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Nov 2014 16:30:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arno@natisbad.org, a.zummo@towertech.it, broonie@kernel.org, grant.likely@linaro.org, linus.walleij@linaro.org, mark.rutland@arm.com, peter.huewe@infineon.com, treding@nvidia.com, uwe@kleine-koenig.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-isl12057.c: report error code upon failur=
e in dev_err() calls
has been added to the -mm tree.  Its filename is
     rtc-rtc-isl12057-report-error-code-upon-failure-in-dev_err-calls.p=
atch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-isl12057-report-er=
ror-code-upon-failure-in-dev_err-calls.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-isl12057-repor=
t-error-code-upon-failure-in-dev_err-calls.patch

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
Subject: drivers/rtc/rtc-isl12057.c: report error code upon failure in =
dev_err() calls

As pointed out by Mark, it is generally useful to log the error code wh=
en
reporting a failure.  This patch improves existing calls to dev_err() i=
n
ISL12057 driver to also report error code.

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Suggested-by: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Peter Huewe <peter.huewe@infineon.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Uwe Kleine-K=F6nig <uwe@kleine-koenig.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl12057.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-isl12057.c~rtc-rtc-isl12057-report-error-code=
-upon-failure-in-dev_err-calls drivers/rtc/rtc-isl12057.c
--- a/drivers/rtc/rtc-isl12057.c~rtc-rtc-isl12057-report-error-code-upo=
n-failure-in-dev_err-calls
+++ a/drivers/rtc/rtc-isl12057.c
@@ -170,8 +170,8 @@ static int isl12057_rtc_read_time(struct
 	mutex_lock(&data->lock);
 	ret =3D regmap_read(data->regmap, ISL12057_REG_SR, &sr);
 	if (ret) {
-		dev_err(dev, "%s: unable to read oscillator status flag\n",
-			__func__);
+		dev_err(dev, "%s: unable to read oscillator status flag (%d)\n",
+			__func__, ret);
 		goto out;
 	} else {
 		if (sr & ISL12057_REG_SR_OSF) {
@@ -183,7 +183,8 @@ static int isl12057_rtc_read_time(struct
 	ret =3D regmap_bulk_read(data->regmap, ISL12057_REG_RTC_SC, regs,
 			       ISL12057_RTC_SEC_LEN);
 	if (ret)
-		dev_err(dev, "%s: unable to read RTC time\n", __func__);
+		dev_err(dev, "%s: unable to read RTC time section (%d)\n",
+			__func__, ret);
=20
 out:
 	mutex_unlock(&data->lock);
@@ -210,7 +211,8 @@ static int isl12057_rtc_set_time(struct
 	ret =3D regmap_bulk_write(data->regmap, ISL12057_REG_RTC_SC, regs,
 				ISL12057_RTC_SEC_LEN);
 	if (ret) {
-		dev_err(dev, "%s: writing RTC time failed\n", __func__);
+		dev_err(dev, "%s: unable to write RTC time section (%d)\n",
+			__func__, ret);
 		goto out;
 	}
=20
@@ -221,7 +223,8 @@ static int isl12057_rtc_set_time(struct
 	ret =3D regmap_update_bits(data->regmap, ISL12057_REG_SR,
 				 ISL12057_REG_SR_OSF, 0);
 	if (ret < 0)
-		dev_err(dev, "Unable to clear oscillator failure bit\n");
+		dev_err(dev, "%s: unable to clear osc. failure bit (%d)\n",
+			__func__, ret);
=20
 out:
 	mutex_unlock(&data->lock);
@@ -242,7 +245,8 @@ static int isl12057_check_rtc_status(str
 	ret =3D regmap_update_bits(regmap, ISL12057_REG_INT,
 				 ISL12057_REG_INT_EOSC, 0);
 	if (ret < 0) {
-		dev_err(dev, "Unable to enable oscillator\n");
+		dev_err(dev, "%s: unable to enable oscillator (%d)\n",
+			__func__, ret);
 		return ret;
 	}
=20
@@ -250,7 +254,8 @@ static int isl12057_check_rtc_status(str
 	ret =3D regmap_update_bits(regmap, ISL12057_REG_SR,
 				 ISL12057_REG_SR_A1F, 0);
 	if (ret < 0) {
-		dev_err(dev, "Unable to clear alarm bit\n");
+		dev_err(dev, "%s: unable to clear alarm bit (%d)\n",
+			__func__, ret);
 		return ret;
 	}
=20
@@ -284,7 +289,8 @@ static int isl12057_probe(struct i2c_cli
 	regmap =3D devm_regmap_init_i2c(client, &isl12057_rtc_regmap_config);
 	if (IS_ERR(regmap)) {
 		ret =3D PTR_ERR(regmap);
-		dev_err(dev, "regmap allocation failed: %d\n", ret);
+		dev_err(dev, "%s: regmap allocation failed (%d)\n",
+			__func__, ret);
 		return ret;
 	}
=20
_

Patches currently in -mm which might be from arno@natisbad.org are

rtc-rtc-isl12057-fix-masking-of-register-values.patch
rtc-rtc-isl12057-add-support-for-century-bit.patch
rtc-rtc-isl12057-add-proper-handling-of-oscillator-failure-bit.patch
rtc-rtc-isl12057-fix-isil-vs-isl-naming-for-intersil.patch
rtc-rtc-isl12057-report-error-code-upon-failure-in-dev_err-calls.patch
rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver.patc=
h
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
