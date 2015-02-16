From: akpm@linux-foundation.org
Subject: [merged] rtc-rk808-fix-the-rtc-time-reading-issue.patch removed
 from -mm tree
Date: Mon, 16 Feb 2015 12:19:13 -0800
Message-ID: <54e250c1.Uoh93cEtCfci+jeq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbbBPUTu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:19:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zyw@rock-chips.com, a.zummo@towertech.it, dianders@chromium.org, heiko@sntech.de, sonnyrao@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-rk808.c: fix rtc time reading issue
has been removed from the -mm tree.  Its filename was
     rtc-rk808-fix-the-rtc-time-reading-issue.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Chris Zhong <zyw@rock-chips.com>
Subject: drivers/rtc/rtc-rk808.c: fix rtc time reading issue

After we set the GET_TIME bit, the rtc time can't be read immediately. =
 We
should wait up to 31.25 us, about one cycle of 32khz.  Otherwise readin=
g
RTC time will return a old time.  If we clear the GET_TIME bit after
setting, the time of i2c transfer is certainly more than 31.25us.

Doug said:

: I think we are safe.  At 400kHz (the max speed of this part) each bit=
 can
: be transferred no faster than 2.5us.  In order to do a valid i2c
: transaction we need to _at least_ write the address of the device and=
 the
: data onto the bus, which is 16 bits.  16 * 2.5us =3D 40us.  That's ab=
ove the
: 31.25us

[akpm@linux-foundation.org: tweak comment per review discussion]
Signed-off-by: Chris Zhong <zyw@rock-chips.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Cc: Sonny Rao <sonnyrao@chromium.org>
Cc: Heiko St=FCbner <heiko@sntech.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rk808.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-rk808.c~rtc-rk808-fix-the-rtc-time-reading-is=
sue drivers/rtc/rtc-rk808.c
--- a/drivers/rtc/rtc-rk808.c~rtc-rk808-fix-the-rtc-time-reading-issue
+++ a/drivers/rtc/rtc-rk808.c
@@ -67,15 +67,21 @@ static int rk808_rtc_readtime(struct dev
 	/* Force an update of the shadowed registers right now */
 	ret =3D regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
 				 BIT_RTC_CTRL_REG_RTC_GET_TIME,
-				 0);
+				 BIT_RTC_CTRL_REG_RTC_GET_TIME);
 	if (ret) {
 		dev_err(dev, "Failed to update bits rtc_ctrl: %d\n", ret);
 		return ret;
 	}
=20
+	/*
+	 * After we set the GET_TIME bit, the rtc time can't be read
+	 * immediately. So we should wait up to 31.25 us, about one cycle of
+	 * 32khz. If we clear the GET_TIME bit here, the time of i2c transfer
+	 * certainly more than 31.25us: 16 * 2.5us at 400kHz bus frequency.
+	 */
 	ret =3D regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
 				 BIT_RTC_CTRL_REG_RTC_GET_TIME,
-				 BIT_RTC_CTRL_REG_RTC_GET_TIME);
+				 0);
 	if (ret) {
 		dev_err(dev, "Failed to update bits rtc_ctrl: %d\n", ret);
 		return ret;
_

Patches currently in -mm which might be from zyw@rock-chips.com are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
