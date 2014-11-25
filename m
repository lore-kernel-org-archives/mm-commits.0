From: akpm@linux-foundation.org
Subject: + rtc-rtc-isl12057-fix-masking-of-register-values.patch added to
 -mm tree
Date: Tue, 25 Nov 2014 13:30:25 -0800
Message-ID: <5474f4f1.VZ3Vir5kAQ/W1WNb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaKYVa1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Nov 2014 16:30:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arno@natisbad.org, a.zummo@towertech.it, broonie@kernel.org, grant.likely@linaro.org, linus.walleij@linaro.org, mark.rutland@arm.com, peter.huewe@infineon.com, treding@nvidia.com, uwe@kleine-koenig.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-isl12057.c: fix masking of register value=
s
has been added to the -mm tree.  Its filename is
     rtc-rtc-isl12057-fix-masking-of-register-values.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-isl12057-fix-maski=
ng-of-register-values.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-isl12057-fix-m=
asking-of-register-values.patch

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
Subject: drivers/rtc/rtc-isl12057.c: fix masking of register values

When Intersil ISL12057 support was added by commit 70e123373c05 ("rtc: =
Add
support for Intersil ISL12057 I2C RTC chip"), two masks for time regist=
ers
values imported from the device were either wrong or omitted, leading t=
o
additional bits from those registers to impact read values:

 - mask for hour register value when reading it in AM/PM mode. As
   AM/PM mode is not the usual mode used by the driver, this error
   would only have an impact on an externally configured RTC hour
   later read by the driver.
 - mask for month value. The lack of masking would provide an
   erroneous value if century bit is set.

This patch fixes those two masks.

=46ixes: 70e123373c05 ("rtc: Add support for Intersil ISL12057 I2C RTC =
chip")
Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Peter Huewe <peter.huewe@infineon.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Uwe Kleine-K=F6nig <uwe@kleine-koenig.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl12057.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-isl12057.c~rtc-rtc-isl12057-fix-masking-of-re=
gister-values drivers/rtc/rtc-isl12057.c
--- a/drivers/rtc/rtc-isl12057.c~rtc-rtc-isl12057-fix-masking-of-regist=
er-values
+++ a/drivers/rtc/rtc-isl12057.c
@@ -88,7 +88,7 @@ static void isl12057_rtc_regs_to_tm(stru
 	tm->tm_min =3D bcd2bin(regs[ISL12057_REG_RTC_MN]);
=20
 	if (regs[ISL12057_REG_RTC_HR] & ISL12057_REG_RTC_HR_MIL) { /* AM/PM *=
/
-		tm->tm_hour =3D bcd2bin(regs[ISL12057_REG_RTC_HR] & 0x0f);
+		tm->tm_hour =3D bcd2bin(regs[ISL12057_REG_RTC_HR] & 0x1f);
 		if (regs[ISL12057_REG_RTC_HR] & ISL12057_REG_RTC_HR_PM)
 			tm->tm_hour +=3D 12;
 	} else {					    /* 24 hour mode */
@@ -97,7 +97,7 @@ static void isl12057_rtc_regs_to_tm(stru
=20
 	tm->tm_mday =3D bcd2bin(regs[ISL12057_REG_RTC_DT]);
 	tm->tm_wday =3D bcd2bin(regs[ISL12057_REG_RTC_DW]) - 1; /* starts at =
1 */
-	tm->tm_mon  =3D bcd2bin(regs[ISL12057_REG_RTC_MO]) - 1; /* starts at =
1 */
+	tm->tm_mon  =3D bcd2bin(regs[ISL12057_REG_RTC_MO] & 0x1f) - 1; /* dit=
to */
 	tm->tm_year =3D bcd2bin(regs[ISL12057_REG_RTC_YR]) + 100;
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
