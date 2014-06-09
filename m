From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-omapc-use-bit-macro.patch removed from
 -mm tree
Date: Mon, 09 Jun 2014 12:30:17 -0700
Message-ID: <53960b49.FoZ2RtCgHDslfqb9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbaFITaS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:30:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lokeshvutla@ti.com, a.zummo@towertech.it, nsekhar@ti.com

Subject: [merged] drivers-rtc-rtc-omapc-use-bit-macro.patch removed from -mm tree
To: nsekhar@ti.com,a.zummo@towertech.it,lokeshvutla@ti.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:30:17 -0700


The patch titled
     Subject: drivers/rtc/rtc-omap.c: use BIT() macro
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-omapc-use-bit-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

