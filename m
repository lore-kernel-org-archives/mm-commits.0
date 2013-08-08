From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-stmp3xxxc-provide-timeout-for-potentially-endless-loop-polling-a-hw-bit.patch added to -mm tree
Date: Thu, 08 Aug 2013 13:37:16 -0700
Message-ID: <5204017c.TI/rdryetSUhqkA3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966335Ab3HHUhR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Aug 2013 16:37:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wsa@the-dreams.de, LW@KARO-electronics.de

Subject: + drivers-rtc-rtc-stmp3xxxc-provide-timeout-for-potentially-endless-loop-polling-a-hw-bit.patch added to -mm tree
To: LW@KARO-electronics.de,wsa@the-dreams.de
From: akpm@linux-foundation.org
Date: Thu, 08 Aug 2013 13:37:16 -0700


The patch titled
     Subject: drivers/rtc/rtc-stmp3xxx.c: provide timeout for potentially endless loop polling a HW bit
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-stmp3xxxc-provide-timeout-for-potentially-endless-loop-polling-a-hw-bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-stmp3xxxc-provide-timeout-for-potentially-endless-loop-polling-a-hw-bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-stmp3xxxc-provide-timeout-for-potentially-endless-loop-polling-a-hw-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lothar Waﬂmann <LW@KARO-electronics.de>
Subject: drivers/rtc/rtc-stmp3xxx.c: provide timeout for potentially endless loop polling a HW bit

It's always a bad idea to poll on HW bits without a timeout.

The i.MX28 RTC can be easily brought into a state in which the RTC is not
running (until after a power-on-reset) and thus the status bits which are
polled in the driver won't ever change.

This patch prevents the kernel from getting stuck in this case.

Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
Acked-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-stmp3xxx.c |   35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-stmp3xxx.c~drivers-rtc-rtc-stmp3xxxc-provide-timeout-for-potentially-endless-loop-polling-a-hw-bit drivers/rtc/rtc-stmp3xxx.c
--- a/drivers/rtc/rtc-stmp3xxx.c~drivers-rtc-rtc-stmp3xxxc-provide-timeout-for-potentially-endless-loop-polling-a-hw-bit
+++ a/drivers/rtc/rtc-stmp3xxx.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
+#include <linux/delay.h>
 #include <linux/rtc.h>
 #include <linux/slab.h>
 #include <linux/of_device.h>
@@ -119,24 +120,39 @@ static void stmp3xxx_wdt_register(struct
 }
 #endif /* CONFIG_STMP3XXX_RTC_WATCHDOG */
 
-static void stmp3xxx_wait_time(struct stmp3xxx_rtc_data *rtc_data)
+static int stmp3xxx_wait_time(struct stmp3xxx_rtc_data *rtc_data)
 {
+	int timeout = 5000; /* 3ms according to i.MX28 Ref Manual */
 	/*
-	 * The datasheet doesn't say which way round the
-	 * NEW_REGS/STALE_REGS bitfields go. In fact it's 0x1=P0,
-	 * 0x2=P1, .., 0x20=P5, 0x40=ALARM, 0x80=SECONDS
+	 * The i.MX28 Applications Processor Reference Manual, Rev. 1, 2010
+	 * states:
+	 * | The order in which registers are updated is
+	 * | Persistent 0, 1, 2, 3, 4, 5, Alarm, Seconds.
+	 * | (This list is in bitfield order, from LSB to MSB, as they would
+	 * | appear in the STALE_REGS and NEW_REGS bitfields of the HW_RTC_STAT
+	 * | register. For example, the Seconds register corresponds to
+	 * | STALE_REGS or NEW_REGS containing 0x80.)
 	 */
-	while (readl(rtc_data->io + STMP3XXX_RTC_STAT) &
-			(0x80 << STMP3XXX_RTC_STAT_STALE_SHIFT))
-		cpu_relax();
+	do {
+		if (!(readl(rtc_data->io + STMP3XXX_RTC_STAT) &
+				(0x80 << STMP3XXX_RTC_STAT_STALE_SHIFT)))
+			return 0;
+		udelay(1);
+	} while (--timeout > 0);
+	return (readl(rtc_data->io + STMP3XXX_RTC_STAT) &
+		(0x80 << STMP3XXX_RTC_STAT_STALE_SHIFT)) ? -ETIME : 0;
 }
 
 /* Time read/write */
 static int stmp3xxx_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 {
+	int ret;
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
-	stmp3xxx_wait_time(rtc_data);
+	ret = stmp3xxx_wait_time(rtc_data);
+	if (ret)
+		return ret;
+
 	rtc_time_to_tm(readl(rtc_data->io + STMP3XXX_RTC_SECONDS), rtc_tm);
 	return 0;
 }
@@ -146,8 +162,7 @@ static int stmp3xxx_rtc_set_mmss(struct
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
 	writel(t, rtc_data->io + STMP3XXX_RTC_SECONDS);
-	stmp3xxx_wait_time(rtc_data);
-	return 0;
+	return stmp3xxx_wait_time(rtc_data);
 }
 
 /* interrupt(s) handler */
_

Patches currently in -mm which might be from LW@KARO-electronics.de are

drivers-rtc-rtc-stmp3xxxc-provide-timeout-for-potentially-endless-loop-polling-a-hw-bit.patch
linux-next.patch

