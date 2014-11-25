From: akpm@linux-foundation.org
Subject: + rtc-rtc-isl12057-add-support-for-century-bit.patch added to -mm tree
Date: Tue, 25 Nov 2014 13:30:27 -0800
Message-ID: <5474f4f3.mMGx6Rx38ubX0iMh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaKYVa3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Nov 2014 16:30:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arno@natisbad.org, a.zummo@towertech.it, broonie@kernel.org, grant.likely@linaro.org, linus.walleij@linaro.org, mark.rutland@arm.com, peter.huewe@infineon.com, treding@nvidia.com, uwe@kleine-koenig.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-isl12057.c: add support for century bit
has been added to the -mm tree.  Its filename is
     rtc-rtc-isl12057-add-support-for-century-bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-isl12057-add-suppo=
rt-for-century-bit.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-isl12057-add-s=
upport-for-century-bit.patch

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
Subject: drivers/rtc/rtc-isl12057.c: add support for century bit

The month register of ISL12057 RTC chip includes a century bit which
reports overflow of year register from 99 to 0.  This bit can also be
written, which allows using it to extend the time interval the chip can
support from 99 to 199 years.

This patch adds support for century overflow bit in tm to regs and regs=
 to
tm helpers in ISL12057 driver.

This was tested by putting a device 100 years in the future (using a
specific kernel due to the inability of userland tools such as date or
hwclock to pass year 2038), rebooting on a kernel w/ this patch applied
and verifying the device was still 100 years in the future.

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Suggested-by: Uwe Kleine-K=F6nig <uwe@kleine-koenig.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Peter Huewe <peter.huewe@infineon.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl12057.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-isl12057.c~rtc-rtc-isl12057-add-support-for-c=
entury-bit drivers/rtc/rtc-isl12057.c
--- a/drivers/rtc/rtc-isl12057.c~rtc-rtc-isl12057-add-support-for-centu=
ry-bit
+++ a/drivers/rtc/rtc-isl12057.c
@@ -41,6 +41,7 @@
 #define ISL12057_REG_RTC_DW	0x03	/* Day of the Week */
 #define ISL12057_REG_RTC_DT	0x04	/* Date */
 #define ISL12057_REG_RTC_MO	0x05	/* Month */
+#define ISL12057_REG_RTC_MO_CEN	BIT(7)	/* Century bit */
 #define ISL12057_REG_RTC_YR	0x06	/* Year */
 #define ISL12057_RTC_SEC_LEN	7
=20
@@ -99,24 +100,35 @@ static void isl12057_rtc_regs_to_tm(stru
 	tm->tm_wday =3D bcd2bin(regs[ISL12057_REG_RTC_DW]) - 1; /* starts at =
1 */
 	tm->tm_mon  =3D bcd2bin(regs[ISL12057_REG_RTC_MO] & 0x1f) - 1; /* dit=
to */
 	tm->tm_year =3D bcd2bin(regs[ISL12057_REG_RTC_YR]) + 100;
+
+	/* Check if years register has overflown from 99 to 00 */
+	if (regs[ISL12057_REG_RTC_MO] & ISL12057_REG_RTC_MO_CEN)
+		tm->tm_year +=3D 100;
 }
=20
 static int isl12057_rtc_tm_to_regs(u8 *regs, struct rtc_time *tm)
 {
+	u8 century_bit;
+
 	/*
 	 * The clock has an 8 bit wide bcd-coded register for the year.
+	 * It also has a century bit encoded in MO flag which provides
+	 * information about overflow of year register from 99 to 00.
 	 * tm_year is an offset from 1900 and we are interested in the
-	 * 2000-2099 range, so any value less than 100 is invalid.
+	 * 2000-2199 range, so any value less than 100 or larger than
+	 * 299 is invalid.
 	 */
-	if (tm->tm_year < 100)
+	if (tm->tm_year < 100 || tm->tm_year > 299)
 		return -EINVAL;
=20
+	century_bit =3D (tm->tm_year > 199) ? ISL12057_REG_RTC_MO_CEN : 0;
+
 	regs[ISL12057_REG_RTC_SC] =3D bin2bcd(tm->tm_sec);
 	regs[ISL12057_REG_RTC_MN] =3D bin2bcd(tm->tm_min);
 	regs[ISL12057_REG_RTC_HR] =3D bin2bcd(tm->tm_hour); /* 24-hour format=
 */
 	regs[ISL12057_REG_RTC_DT] =3D bin2bcd(tm->tm_mday);
-	regs[ISL12057_REG_RTC_MO] =3D bin2bcd(tm->tm_mon + 1);
-	regs[ISL12057_REG_RTC_YR] =3D bin2bcd(tm->tm_year - 100);
+	regs[ISL12057_REG_RTC_MO] =3D bin2bcd(tm->tm_mon + 1) | century_bit;
+	regs[ISL12057_REG_RTC_YR] =3D bin2bcd(tm->tm_year % 100);
 	regs[ISL12057_REG_RTC_DW] =3D bin2bcd(tm->tm_wday + 1);
=20
 	return 0;
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
