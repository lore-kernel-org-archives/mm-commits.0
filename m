From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-s3cc-fix-compilation-error.patch removed from -mm tree
Date: Mon, 16 Apr 2012 13:15:32 -0700
Message-ID: <20120416201532.67202A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:58458 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab2DPUPd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 16:15:33 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so646133qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 13:15:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tushar.behera@linaro.org, a.zummo@towertech.it, heiko@sntech.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: fix compilation error
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-s3cc-fix-compilation-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Tushar Behera <tushar.behera@linaro.org>
Subject: drivers/rtc/rtc-s3c.c: fix compilation error

drivers/rtc/rtc-s3c.c: At top level:
drivers/rtc/rtc-s3c.c:671:3: error: request for member `data' in something not a structure or union
drivers/rtc/rtc-s3c.c:674:3: error: request for member `data' in something not a structure or union
drivers/rtc/rtc-s3c.c:677:3: error: request for member `data' in something not a structure or union
drivers/rtc/rtc-s3c.c:680:3: error: request for member `data' in something not a structure or union

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-fix-compilation-error drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-fix-compilation-error
+++ a/drivers/rtc/rtc-s3c.c
@@ -667,16 +667,16 @@ static int s3c_rtc_resume(struct platfor
 #ifdef CONFIG_OF
 static const struct of_device_id s3c_rtc_dt_match[] = {
 	{
-		.compatible = "samsung,s3c2410-rtc"
+		.compatible = "samsung,s3c2410-rtc",
 		.data = TYPE_S3C2410,
 	}, {
-		.compatible = "samsung,s3c2416-rtc"
+		.compatible = "samsung,s3c2416-rtc",
 		.data = TYPE_S3C2416,
 	}, {
-		.compatible = "samsung,s3c2443-rtc"
+		.compatible = "samsung,s3c2443-rtc",
 		.data = TYPE_S3C2443,
 	}, {
-		.compatible = "samsung,s3c6410-rtc"
+		.compatible = "samsung,s3c6410-rtc",
 		.data = TYPE_S3C64XX,
 	},
 	{},
_

Patches currently in -mm which might be from tushar.behera@linaro.org are


