From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-max77686c-fix-wrong-register.patch added to -mm tree
Date: Wed, 14 Aug 2013 13:21:52 -0700
Message-ID: <520be6e0.hXKscTAO/uSKRWJq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760147Ab3HNUVx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 16:21:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, myungjoo.ham@samsung.com, jonghwa3.lee@samsung.com, sangjung.woo@samsung.com

Subject: + drivers-rtc-rtc-max77686c-fix-wrong-register.patch added to -mm tree
To: sangjung.woo@samsung.com,jonghwa3.lee@samsung.com,myungjoo.ham@samsung.com
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 13:21:52 -0700


The patch titled
     Subject: drivers/rtc/rtc-max77686.c: Fix wrong register
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-max77686c-fix-wrong-register.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-max77686c-fix-wrong-register.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-max77686c-fix-wrong-register.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sangjung Woo <sangjung.woo@samsung.com>
Subject: drivers/rtc/rtc-max77686.c: Fix wrong register

Fix a read of the wrong register when checking whether the RTC timer has
reached the alarm time.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
Signed-off-by: Myugnjoo Ham <myungjoo.ham@samsung.com>
Reviewed-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-max77686.c~drivers-rtc-rtc-max77686c-fix-wrong-register drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~drivers-rtc-rtc-max77686c-fix-wrong-register
+++ a/drivers/rtc/rtc-max77686.c
@@ -240,9 +240,9 @@ static int max77686_rtc_read_alarm(struc
 	}
 
 	alrm->pending = 0;
-	ret = regmap_read(info->max77686->regmap, MAX77686_REG_STATUS1, &val);
+	ret = regmap_read(info->max77686->regmap, MAX77686_REG_STATUS2, &val);
 	if (ret < 0) {
-		dev_err(info->dev, "%s:%d fail to read status1 reg(%d)\n",
+		dev_err(info->dev, "%s:%d fail to read status2 reg(%d)\n",
 				__func__, __LINE__, ret);
 		goto out;
 	}
_

Patches currently in -mm which might be from sangjung.woo@samsung.com are

drivers-rtc-rtc-max77686c-fix-wrong-register.patch

