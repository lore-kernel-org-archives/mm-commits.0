From: akpm@linux-foundation.org
Subject: + rtc-m41t80-remove-drv_version-macro.patch added to -mm tree
Date: Mon, 21 Apr 2014 13:08:49 -0700
Message-ID: <53557ad1.x5KlMzN3Ufr7lUkL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaDUUIu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 16:08:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, a.zummo@towertech.it, wsa@sang-engineering.com

Subject: + rtc-m41t80-remove-drv_version-macro.patch added to -mm tree
To: wsa@sang-engineering.com,a.zummo@towertech.it,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 13:08:49 -0700


The patch titled
     Subject: drivers/rtc/rtc-m41t80.c: remove DRV_VERSION macro
has been added to the -mm tree.  Its filename is
     rtc-m41t80-remove-drv_version-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-m41t80-remove-drv_version-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-m41t80-remove-drv_version-macro.patch

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
Subject: drivers/rtc/rtc-m41t80.c: remove DRV_VERSION macro

History is in git, no need for sperate versioning.  Also remove the
success printout, RTC core does it, too.

Signed-off-by: Wolfram Sang <wsa@sang-engineering.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t80.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/rtc/rtc-m41t80.c~rtc-m41t80-remove-drv_version-macro drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-m41t80-remove-drv_version-macro
+++ a/drivers/rtc/rtc-m41t80.c
@@ -66,8 +66,6 @@
 #define M41T80_FEATURE_WD	(1 << 3)	/* Extra watchdog resolution */
 #define M41T80_FEATURE_SQ_ALT	(1 << 4)	/* RSx bits are in reg 4 */
 
-#define DRV_VERSION "0.05"
-
 static DEFINE_MUTEX(m41t80_rtc_mutex);
 static const struct i2c_device_id m41t80_id[] = {
 	{ "m41t62", M41T80_FEATURE_SQ | M41T80_FEATURE_SQ_ALT },
@@ -634,9 +632,6 @@ static int m41t80_probe(struct i2c_clien
 		goto exit;
 	}
 
-	dev_info(&client->dev,
-		 "chip found, driver version " DRV_VERSION "\n");
