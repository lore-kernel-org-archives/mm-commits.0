From: akpm@linux-foundation.org
Subject: + rtc-m41t80-add-support-for-microcrystal-rv4162.patch added to
 -mm tree
Date: Mon, 21 Apr 2014 13:08:52 -0700
Message-ID: <53557ad4.hmwJw5YLxkGw25FI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbaDUUIx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 16:08:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, a.zummo@towertech.it, wsa@sang-engineering.com

Subject: + rtc-m41t80-add-support-for-microcrystal-rv4162.patch added to -mm tree
To: wsa@sang-engineering.com,a.zummo@towertech.it,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 13:08:52 -0700


The patch titled
     Subject: drivers/rtc/rtc-m41t80.c: add support for MicroCrystal rv4162
has been added to the -mm tree.  Its filename is
     rtc-m41t80-add-support-for-microcrystal-rv4162.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-m41t80-add-support-for-microcrystal-rv4162.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-m41t80-add-support-for-microcrystal-rv4162.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rtc-m41t80-remove-drv_version-macro.patch
rtc-m41t80-clean-up-error-paths.patch
rtc-m41t80-propagate-error-value-from-smbus-functions.patch
rtc-m41t80-add-support-for-microcrystal-rv4162.patch
linux-next.patch

