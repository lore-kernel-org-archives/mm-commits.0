From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-twlc-use-static-register-while-reading-time.patch added to -mm tree
Date: Fri, 06 Apr 2012 12:19:39 -0700
Message-ID: <20120406191939.DCFD0A03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:52867 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705Ab2DFTTl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 15:19:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: x0155534@ti.com, a.zummo@towertech.it, b-cousson@ti.com, gg@slimlogic.co.uk, linux-omap@vger.kernel.org, nm@ti.com, oleksandr.dmytryshyn@ti.com, x0174904@ti.com


The patch titled
     Subject: drivers/rtc/rtc-twl.c: use static register while reading time
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-twlc-use-static-register-while-reading-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Shlyakhovoy <x0155534@ti.com>
Subject: drivers/rtc/rtc-twl.c: use static register while reading time

RTC stores time and date in several registers.  Due to the fact that these
registers can't be read instantaneously, there is a chance that reading
from counting registers gives an error of one minute, one hour, one day,
etc.

To address this issue, the RTC has hardware support to copy the RTC
counting registers to static shadowed registers.  The current
implementation does not use this feature, and in a stress test, we can
reproduce this error at a rate of around two times per 300000 readings.

Fix the implementation to ensure that the right snapshot of time is
captured.

Signed-off-by: Konstantin Shlyakhovoy <x0155534@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Benoit Cousson <b-cousson@ti.com>
Cc: linux-omap <linux-omap@vger.kernel.org>
Acked-by: Mykola Oleksiienko <x0174904@ti.com>
Acked-by: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
Acked-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |   43 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-use-static-register-while-reading-time drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-use-static-register-while-reading-time
+++ a/drivers/rtc/rtc-twl.c
@@ -112,6 +112,7 @@ static const u8 twl6030_rtc_reg_map[] = 
 #define BIT_RTC_CTRL_REG_TEST_MODE_M             0x10
 #define BIT_RTC_CTRL_REG_SET_32_COUNTER_M        0x20
 #define BIT_RTC_CTRL_REG_GET_TIME_M              0x40
+#define BIT_RTC_CTRL_REG_RTC_V_OPT               0x80
 
 /* RTC_STATUS_REG bitfields */
 #define BIT_RTC_STATUS_REG_RUN_M                 0x02
@@ -235,25 +236,57 @@ static int twl_rtc_read_time(struct devi
 	unsigned char rtc_data[ALL_TIME_REGS + 1];
 	int ret;
 	u8 save_control;
+	u8 rtc_control;
 
 	ret = twl_rtc_read_u8(&save_control, REG_RTC_CTRL_REG);
-	if (ret < 0)
+	if (ret < 0) {
+		dev_err(dev, "%s: reading CTRL_REG, error %d\n", __func__, ret);
 		return ret;
+	}
+	/* for twl6030/32 make sure BIT_RTC_CTRL_REG_GET_TIME_M is clear */
+	if (twl_class_is_6030()) {
+		if (save_control & BIT_RTC_CTRL_REG_GET_TIME_M) {
+			save_control &= ~BIT_RTC_CTRL_REG_GET_TIME_M;
+			ret = twl_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
+			if (ret < 0) {
+				dev_err(dev, "%s clr GET_TIME, error %d\n",
+					__func__, ret);
+				return ret;
+			}
+		}
+	}
 
-	save_control |= BIT_RTC_CTRL_REG_GET_TIME_M;
+	/* Copy RTC counting registers to static registers or latches */
+	rtc_control = save_control | BIT_RTC_CTRL_REG_GET_TIME_M;
 
-	ret = twl_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
-	if (ret < 0)
+	/* for twl6030/32 enable read access to static shadowed registers */
+	if (twl_class_is_6030())
+		rtc_control |= BIT_RTC_CTRL_REG_RTC_V_OPT;
+
+	ret = twl_rtc_write_u8(rtc_control, REG_RTC_CTRL_REG);
+	if (ret < 0) {
+		dev_err(dev, "%s: writing CTRL_REG, error %d\n", __func__, ret);
 		return ret;
+	}
 
 	ret = twl_i2c_read(TWL_MODULE_RTC, rtc_data,
 			(rtc_reg_map[REG_SECONDS_REG]), ALL_TIME_REGS);
 
 	if (ret < 0) {
-		dev_err(dev, "rtc_read_time error %d\n", ret);
+		dev_err(dev, "%s: reading data, error %d\n", __func__, ret);
 		return ret;
 	}
 
+	/* for twl6030 restore original state of rtc control register */
+	if (twl_class_is_6030()) {
+		ret = twl_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
+		if (ret < 0) {
+			dev_err(dev, "%s: restore CTRL_REG, error %d\n",
+				__func__, ret);
+			return ret;
+		}
+	}
+
 	tm->tm_sec = bcd2bin(rtc_data[0]);
 	tm->tm_min = bcd2bin(rtc_data[1]);
 	tm->tm_hour = bcd2bin(rtc_data[2]);
_
Subject: Subject: drivers/rtc/rtc-twl.c: use static register while reading time

Patches currently in -mm which might be from x0155534@ti.com are

drivers-rtc-rtc-twlc-use-static-register-while-reading-time.patch

