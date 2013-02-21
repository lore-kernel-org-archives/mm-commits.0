From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-max77686-add-missing-variable-initialization-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:26:43 -0800
Message-ID: <20130221232643.E78C031C016@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:45424 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab3BUX0p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:26:45 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so11311qeb.0
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:26:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jg1.han@samsung.com, jonghwa3.lee@samsung.com, kyungmin.park@samsung.com, myungjoo.ham@samsung.com, woong.byun@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-max77686-add-missing-variable-initialization-fix
has been removed from the -mm tree.  Its filename was
     rtc-max77686-add-missing-variable-initialization-fix.patch

This patch was dropped because it was folded into rtc-max77686-add-maxim-77686-driver.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-max77686-add-missing-variable-initialization-fix

simplify code

Cc: Chiwoong Byun <woong.byun@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Myugnjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-max77686.c~rtc-max77686-add-missing-variable-initialization-fix drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~rtc-max77686-add-missing-variable-initialization-fix
+++ a/drivers/rtc/rtc-max77686.c
@@ -133,16 +133,12 @@ static int max77686_rtc_update(struct ma
 	enum MAX77686_RTC_OP op)
 {
 	int ret;
-	unsigned int data = 0;
+	unsigned int data;
 
-	switch (op) {
-	case MAX77686_RTC_WRITE:
+	if (op == MAX77686_RTC_WRITE)
 		data = 1 << RTC_UDR_SHIFT;
-		break;
-	case MAX77686_RTC_READ:
+	else
 		data = 1 << RTC_RBUDR_SHIFT;
-		break;
-	}
 
 	ret = regmap_update_bits(info->max77686->rtc_regmap,
 				 MAX77686_RTC_UPDATE0, data, data);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
goldfish-framebuffer-driver-fix.patch
ocfs2-remove-kfree-redundant-null-checks.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
sys_prctl-coding-style-cleanup.patch
backlight-add-lms501kf03-lcd-driver.patch
drivers-video-backlight-makefile-cleanup.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
rtc-max77686-add-maxim-77686-driver.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch

