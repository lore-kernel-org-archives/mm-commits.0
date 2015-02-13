From: akpm@linux-foundation.org
Subject: [folded-merged]
 rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch removed from -mm tree
Date: Fri, 13 Feb 2015 14:31:29 -0800
Message-ID: <54de7b41.vbQ8Aqymot31c/GN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbbBMWba (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 17:31:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, dianders@chromium.org, heiko@sntech.de, sonnyrao@chromium.org, zyw@rock-chips.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-rk808-fix-the-rtc-time-reading-issue-fix
has been removed from the -mm tree.  Its filename was
     rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch

This patch was dropped because it was folded into rtc-rk808-fix-the-rtc=
-time-reading-issue.patch

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-rk808-fix-the-rtc-time-reading-issue-fix

tweak comment per review discussion

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Chris Zhong <zyw@rock-chips.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Heiko St=FCbner <heiko@sntech.de>
Cc: Sonny Rao <sonnyrao@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rk808.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-rk808.c~rtc-rk808-fix-the-rtc-time-reading-is=
sue-fix drivers/rtc/rtc-rk808.c
--- a/drivers/rtc/rtc-rk808.c~rtc-rk808-fix-the-rtc-time-reading-issue-=
fix
+++ a/drivers/rtc/rtc-rk808.c
@@ -73,10 +73,11 @@ static int rk808_rtc_readtime(struct dev
 		return ret;
 	}
=20
-	/* After we set the GET_TIME bit, the rtc time couldn't be read
-	 * immediately, we should wait up to 31.25 us, about one cycle of
+	/*
+	 * After we set the GET_TIME bit, the rtc time can't be read
+	 * immediately. So we should wait up to 31.25 us, about one cycle of
 	 * 32khz. If we clear the GET_TIME bit here, the time of i2c transfer
-	 * certainly more than 31.25us.
+	 * certainly more than 31.25us: 16 * 2.5us at 400kHz bus frequency.
 	 */
 	ret =3D regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
 				 BIT_RTC_CTRL_REG_RTC_GET_TIME,
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
module_device_table-fix-some-callsites.patch
rtc-rk808-fix-the-rtc-time-reading-issue.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
