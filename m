From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-omapc-add-support-for-enabling-32khz-clock.patch added to
 -mm tree
Date: Fri, 09 May 2014 13:27:54 -0700
Message-ID: <536d3a4a.ohwNxoNQ1pev7YEL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbaEIU1z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2014 16:27:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lokeshvutla@ti.com, a.zummo@towertech.it, nsekhar@ti.com

Subject: + drivers-rtc-rtc-omapc-add-support-for-enabling-32khz-clock.patch added to -mm tree
To: nsekhar@ti.com,a.zummo@towertech.it,lokeshvutla@ti.com
From: akpm@linux-foundation.org
Date: Fri, 09 May 2014 13:27:54 -0700


The patch titled
     Subject: drivers/rtc/rtc-omap.c: add support for enabling 32khz clock
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-omapc-add-support-for-enabling-32khz-clock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-omapc-add-support-for-enabling-32khz-clock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-omapc-add-support-for-enabling-32khz-clock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sekhar Nori <nsekhar@ti.com>
Subject: drivers/rtc/rtc-omap.c: add support for enabling 32khz clock

Newer versions of OMAP RTC IP such as those found in AM335x and DRA7x need
an explicit enable of 32khz functional clock which ticks the RTC.

AM335x support was working so far because of settings done in U-Boot. 
However, the DRA7x U-Boot does no such enable of 32khz clock and this
patch is need to get the RTC to work on DRA7x at least.  In general, it is
better to not depend on settings done in U-Boot.

Thanks to Lokesh Vutla for noticing this.

Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-omap.c~drivers-rtc-rtc-omapc-add-support-for-enabling-32khz-clock drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~drivers-rtc-rtc-omapc-add-support-for-enabling-32khz-clock
+++ a/drivers/rtc/rtc-omap.c
@@ -96,6 +96,9 @@
 #define OMAP_RTC_INTERRUPTS_IT_ALARM	BIT(3)
 #define OMAP_RTC_INTERRUPTS_IT_TIMER	BIT(2)
 
+/* OMAP_RTC_OSC_REG bit fields: */
+#define OMAP_RTC_OSC_32KCLK_EN		BIT(6)
+
 /* OMAP_RTC_IRQWAKEEN bit fields: */
 #define OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN	BIT(1)
 
@@ -111,6 +114,12 @@
  */
 #define	OMAP_RTC_HAS_IRQWAKEEN		BIT(1)
 
+/*
+ * Some RTC IP revisions (like those in AM335x and DRA7x) need
+ * the 32KHz clock to be explicitly enabled.
+ */
+#define OMAP_RTC_HAS_32KCLK_EN		BIT(2)
+
 static void __iomem	*rtc_base;
 
 #define rtc_read(addr)		readb(rtc_base + (addr))
@@ -319,7 +328,8 @@ static struct platform_device_id omap_rt
 	},
 	[OMAP_RTC_DATA_AM3352_IDX] = {
 		.name	= "am3352-rtc",
-		.driver_data = OMAP_RTC_HAS_KICKER | OMAP_RTC_HAS_IRQWAKEEN,
+		.driver_data = OMAP_RTC_HAS_KICKER | OMAP_RTC_HAS_IRQWAKEEN |
+			       OMAP_RTC_HAS_32KCLK_EN,
 	},
 	[OMAP_RTC_DATA_DA830_IDX] = {
 		.name	= "da830-rtc",
@@ -398,6 +408,10 @@ static int __init omap_rtc_probe(struct
 	 */
 	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
 
+	/* enable RTC functional clock */
+	if (id_entry->driver_data & OMAP_RTC_HAS_32KCLK_EN)
+		rtc_writel(OMAP_RTC_OSC_32KCLK_EN, OMAP_RTC_OSC_REG);
+
 	/* clear old status */
 	reg = rtc_read(OMAP_RTC_STATUS_REG);
 	if (reg & (u8) OMAP_RTC_STATUS_POWER_UP) {
_

Patches currently in -mm which might be from nsekhar@ti.com are

drivers-rtc-rtc-omapc-remove-multiple-device-id-checks.patch
drivers-rtc-rtc-omapc-use-bit-macro.patch
drivers-rtc-rtc-omapc-add-support-for-enabling-32khz-clock.patch
linux-next.patch

