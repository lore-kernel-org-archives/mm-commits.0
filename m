From: akpm@linux-foundation.org
Subject: +
 rtc-hym8563-fix-swapped-enable-disable-of-clockout-control-bit.patch added
 to -mm tree
Date: Mon, 06 Apr 2015 12:44:37 -0700
Message-ID: <5522e225.f9rMooYwQ0fIrl2u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbbDFToi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2015 15:44:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko@sntech.de, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-hym8563.c: fix swapped enable/disable of =
clockout control bit
has been added to the -mm tree.  Its filename is
     rtc-hym8563-fix-swapped-enable-disable-of-clockout-control-bit.pat=
ch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-hym8563-fix-swapped-en=
able-disable-of-clockout-control-bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-hym8563-fix-swapped-en=
able-disable-of-clockout-control-bit.patch

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
=46rom: Heiko St=FCbner <heiko@sntech.de>
Subject: drivers/rtc/rtc-hym8563.c: fix swapped enable/disable of clock=
out control bit

The hym8563 datasheet describes the clock output control-bit as "when s=
et
to logic 0, the square wave output is enable, when set to logic 1, the
CLKOUT output is inhibited".  But in reality the setting is exactly
opposite.

Before now, the clock output was not really used, but on the rk3288 soc
this generated clock is used to supply the temperature sensor block and
the swapped bit value prevented it from working.  With the corrected
value, the tsadc now reports correct values.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-hym8563.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-hym8563.c~rtc-hym8563-fix-swapped-enable-disa=
ble-of-clockout-control-bit drivers/rtc/rtc-hym8563.c
--- a/drivers/rtc/rtc-hym8563.c~rtc-hym8563-fix-swapped-enable-disable-=
of-clockout-control-bit
+++ a/drivers/rtc/rtc-hym8563.c
@@ -66,7 +66,7 @@
 #define HYM8563_ALM_BIT_DISABLE	BIT(7)
=20
 #define HYM8563_CLKOUT		0x0d
-#define HYM8563_CLKOUT_DISABLE	BIT(7)
+#define HYM8563_CLKOUT_ENABLE	BIT(7)
 #define HYM8563_CLKOUT_32768	0
 #define HYM8563_CLKOUT_1024	1
 #define HYM8563_CLKOUT_32	2
@@ -360,9 +360,9 @@ static int hym8563_clkout_control(struct
 		return ret;
=20
 	if (enable)
-		ret &=3D ~HYM8563_CLKOUT_DISABLE;
+		ret |=3D HYM8563_CLKOUT_ENABLE;
 	else
-		ret |=3D HYM8563_CLKOUT_DISABLE;
+		ret &=3D ~HYM8563_CLKOUT_ENABLE;
=20
 	return i2c_smbus_write_byte_data(client, HYM8563_CLKOUT, ret);
 }
@@ -386,7 +386,7 @@ static int hym8563_clkout_is_prepared(st
 	if (ret < 0)
 		return ret;
=20
-	return !(ret & HYM8563_CLKOUT_DISABLE);
+	return !!(ret & HYM8563_CLKOUT_ENABLE);
 }
=20
 static const struct clk_ops hym8563_clkout_ops =3D {
@@ -407,7 +407,7 @@ static struct clk *hym8563_clkout_regist
 	int ret;
=20
 	ret =3D i2c_smbus_write_byte_data(client, HYM8563_CLKOUT,
-						HYM8563_CLKOUT_DISABLE);
+						0);
 	if (ret < 0)
 		return ERR_PTR(ret);
=20
_

Patches currently in -mm which might be from heiko@sntech.de are

rtc-hym8563-return-clock-rate-even-when-clock-is-disabled.patch
rtc-hym8563-fix-swapped-enable-disable-of-clockout-control-bit.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
