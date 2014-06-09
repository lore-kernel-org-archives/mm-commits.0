From: akpm@linux-foundation.org
Subject: [merged] rtc-m41t80-add-support-for-microcrystal-rv4162.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:28:47 -0700
Message-ID: <53960aef.F3ndPGN1RU1Grugk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbaFIT2s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:28:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, a.zummo@towertech.it, wsa@sang-engineering.com

Subject: [merged] rtc-m41t80-add-support-for-microcrystal-rv4162.patch removed from -mm tree
To: wsa@sang-engineering.com,a.zummo@towertech.it,jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:28:47 -0700


The patch titled
     Subject: drivers/rtc/rtc-m41t80.c: add support for MicroCrystal rv4162
has been removed from the -mm tree.  Its filename was
     rtc-m41t80-add-support-for-microcrystal-rv4162.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wolfram Sang <wsa@sang-engineering.com>
Subject: drivers/rtc/rtc-m41t80.c: add support for MicroCrystal rv4162

Signed-off-by: Wolfram Sang <wsa@sang-engineering.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    4 ++--
 drivers/rtc/rtc-m41t80.c |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-m41t80-add-support-for-microcrystal-rv4162 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-m41t80-add-support-for-microcrystal-rv4162
+++ a/drivers/rtc/Kconfig
@@ -386,12 +386,12 @@ config RTC_DRV_PCF8583
 	  will be called rtc-pcf8583.
 
 config RTC_DRV_M41T80
-	tristate "ST M41T62/65/M41T80/81/82/83/84/85/87"
+	tristate "ST M41T62/65/M41T80/81/82/83/84/85/87 and compatible"
 	help
 	  If you say Y here you will get support for the ST M41T60
 	  and M41T80 RTC chips series. Currently, the following chips are
 	  supported: M41T62, M41T65, M41T80, M41T81, M41T82, M41T83, M41ST84,
-	  M41ST85, and M41ST87.
+	  M41ST85, M41ST87, and MicroCrystal RV4162.
 
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-m41t80.
diff -puN drivers/rtc/rtc-m41t80.c~rtc-m41t80-add-support-for-microcrystal-rv4162 drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-m41t80-add-support-for-microcrystal-rv4162
+++ a/drivers/rtc/rtc-m41t80.c
@@ -78,6 +78,7 @@ static const struct i2c_device_id m41t80
 	{ "m41st84", M41T80_FEATURE_HT | M41T80_FEATURE_BL | M41T80_FEATURE_SQ },
 	{ "m41st85", M41T80_FEATURE_HT | M41T80_FEATURE_BL | M41T80_FEATURE_SQ },
 	{ "m41st87", M41T80_FEATURE_HT | M41T80_FEATURE_BL | M41T80_FEATURE_SQ },
+	{ "rv4162", M41T80_FEATURE_SQ | M41T80_FEATURE_WD | M41T80_FEATURE_SQ_ALT },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, m41t80_id);
_

Patches currently in -mm which might be from wsa@sang-engineering.com are

origin.patch
linux-next.patch

