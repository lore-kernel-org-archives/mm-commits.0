From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-omapc-use-bit-macro.patch added to -mm tree
Date: Fri, 09 May 2014 13:27:53 -0700
Message-ID: <536d3a49.6nwfwNjrrkHtIWWj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbaEIU1y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2014 16:27:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lokeshvutla@ti.com, a.zummo@towertech.it, nsekhar@ti.com

Subject: + drivers-rtc-rtc-omapc-use-bit-macro.patch added to -mm tree
To: nsekhar@ti.com,a.zummo@towertech.it,lokeshvutla@ti.com
From: akpm@linux-foundation.org
Date: Fri, 09 May 2014 13:27:53 -0700


The patch titled
     Subject: drivers/rtc/rtc-omap.c: use BIT() macro
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-omapc-use-bit-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-omapc-use-bit-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-omapc-use-bit-macro.patch

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
Subject: drivers/rtc/rtc-omap.c: use BIT() macro

Use BIT() macro for RTC_HAS_<FEATURE> defines instead of hand-writing bit
masks.

Use BIT() macros for register bit field definitions.

While at it, fix indentation done using spaces.

No functional change in this patch.

Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |   42 +++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~drivers-rtc-rtc-omapc-use-bit-macro drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~drivers-rtc-rtc-omapc-use-bit-macro
+++ a/drivers/rtc/rtc-omap.c
@@ -73,43 +73,43 @@
 #define OMAP_RTC_IRQWAKEEN		0x7c
 
 /* OMAP_RTC_CTRL_REG bit fields: */
-#define OMAP_RTC_CTRL_SPLIT		(1<<7)
-#define OMAP_RTC_CTRL_DISABLE		(1<<6)
-#define OMAP_RTC_CTRL_SET_32_COUNTER	(1<<5)
-#define OMAP_RTC_CTRL_TEST		(1<<4)
-#define OMAP_RTC_CTRL_MODE_12_24	(1<<3)
-#define OMAP_RTC_CTRL_AUTO_COMP		(1<<2)
-#define OMAP_RTC_CTRL_ROUND_30S		(1<<1)
-#define OMAP_RTC_CTRL_STOP		(1<<0)
+#define OMAP_RTC_CTRL_SPLIT		BIT(7)
+#define OMAP_RTC_CTRL_DISABLE		BIT(6)
+#define OMAP_RTC_CTRL_SET_32_COUNTER	BIT(5)
+#define OMAP_RTC_CTRL_TEST		BIT(4)
+#define OMAP_RTC_CTRL_MODE_12_24	BIT(3)
+#define OMAP_RTC_CTRL_AUTO_COMP		BIT(2)
+#define OMAP_RTC_CTRL_ROUND_30S		BIT(1)
+#define OMAP_RTC_CTRL_STOP		BIT(0)
 
 /* OMAP_RTC_STATUS_REG bit fields: */
-#define OMAP_RTC_STATUS_POWER_UP        (1<<7)
-#define OMAP_RTC_STATUS_ALARM           (1<<6)
-#define OMAP_RTC_STATUS_1D_EVENT        (1<<5)
-#define OMAP_RTC_STATUS_1H_EVENT        (1<<4)
-#define OMAP_RTC_STATUS_1M_EVENT        (1<<3)
-#define OMAP_RTC_STATUS_1S_EVENT        (1<<2)
-#define OMAP_RTC_STATUS_RUN             (1<<1)
-#define OMAP_RTC_STATUS_BUSY            (1<<0)
+#define OMAP_RTC_STATUS_POWER_UP	BIT(7)
+#define OMAP_RTC_STATUS_ALARM		BIT(6)
+#define OMAP_RTC_STATUS_1D_EVENT	BIT(5)
+#define OMAP_RTC_STATUS_1H_EVENT	BIT(4)
+#define OMAP_RTC_STATUS_1M_EVENT	BIT(3)
+#define OMAP_RTC_STATUS_1S_EVENT	BIT(2)
+#define OMAP_RTC_STATUS_RUN		BIT(1)
+#define OMAP_RTC_STATUS_BUSY		BIT(0)
 
 /* OMAP_RTC_INTERRUPTS_REG bit fields: */
-#define OMAP_RTC_INTERRUPTS_IT_ALARM    (1<<3)
-#define OMAP_RTC_INTERRUPTS_IT_TIMER    (1<<2)
+#define OMAP_RTC_INTERRUPTS_IT_ALARM	BIT(3)
+#define OMAP_RTC_INTERRUPTS_IT_TIMER	BIT(2)
 
 /* OMAP_RTC_IRQWAKEEN bit fields: */
-#define OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN    (1<<1)
+#define OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN	BIT(1)
 
 /* OMAP_RTC_KICKER values */
 #define	KICK0_VALUE			0x83e70b13
 #define	KICK1_VALUE			0x95a4f1e0
 
-#define	OMAP_RTC_HAS_KICKER		0x1
+#define	OMAP_RTC_HAS_KICKER		BIT(0)
 
 /*
  * Few RTC IP revisions has special WAKE-EN Register to enable Wakeup
  * generation for event Alarm.
  */
-#define	OMAP_RTC_HAS_IRQWAKEEN		0x2
+#define	OMAP_RTC_HAS_IRQWAKEEN		BIT(1)
 
 static void __iomem	*rtc_base;
 
_

Patches currently in -mm which might be from nsekhar@ti.com are

drivers-rtc-rtc-omapc-remove-multiple-device-id-checks.patch
drivers-rtc-rtc-omapc-use-bit-macro.patch
drivers-rtc-rtc-omapc-add-support-for-enabling-32khz-clock.patch
linux-next.patch

