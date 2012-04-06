From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-s3cc-add-placeholder-for-driver-private-data.patch added to -mm tree
Date: Fri, 06 Apr 2012 12:15:18 -0700
Message-ID: <20120406191518.20629A03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:55325 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab2DFTPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 15:15:19 -0400
Received: by qcsp5 with SMTP id p5so302838qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 12:15:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tushar.behera@linaro.org, a.zummo@towertech.it, heiko@sntech.de


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: add placeholder for driver private data
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-s3cc-add-placeholder-for-driver-private-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tushar Behera <tushar.behera@linaro.org>
Subject: drivers/rtc/rtc-s3c.c: add placeholder for driver private data

Driver data field is a pointer, hence assigning that to an integer results
in compilation warnings.

Fixes following compilation warnigs.

drivers/rtc/rtc-s3c.c: In function `s3c_rtc_get_driver_data':
drivers/rtc/rtc-s3c.c:452:3: warning: return makes integer from pointer without a cast [enabled by default]
drivers/rtc/rtc-s3c.c: At top level:
drivers/rtc/rtc-s3c.c:674:3: warning: initialization makes pointer from integer without a cast [enabled by default]
drivers/rtc/rtc-s3c.c:674:3: warning: (near initialization for `s3c_rtc_dt_match[1].data') [enabled by default]
drivers/rtc/rtc-s3c.c:677:3: warning: initialization makes pointer from integer without a cast [enabled by default]
drivers/rtc/rtc-s3c.c:677:3: warning: (near initialization for `s3c_rtc_dt_match[2].data') [enabled by default]
drivers/rtc/rtc-s3c.c:680:3: warning: initialization makes pointer from integer without a cast [enabled by default]
drivers/rtc/rtc-s3c.c:680:3: warning: (near initialization for `s3c_rtc_dt_match[3].data') [enabled by default]

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-add-placeholder-for-driver-private-data drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-add-placeholder-for-driver-private-data
+++ a/drivers/rtc/rtc-s3c.c
@@ -40,6 +40,10 @@ enum s3c_cpu_type {
 	TYPE_S3C64XX,
 };
 
+struct s3c_rtc_drv_data {
+	int cpu_type;
+};
+
 /* I have yet to find an S3C implementation with more than one
  * of these rtc blocks in */
 
@@ -446,10 +450,12 @@ static const struct of_device_id s3c_rtc
 static inline int s3c_rtc_get_driver_data(struct platform_device *pdev)
 {
 #ifdef CONFIG_OF
+	struct s3c_rtc_drv_data *data;
 	if (pdev->dev.of_node) {
 		const struct of_device_id *match;
 		match = of_match_node(s3c_rtc_dt_match, pdev->dev.of_node);
-		return match->data;
+		data = (struct s3c_rtc_drv_data *) match->data;
+		return data->cpu_type;
 	}
 #endif
 	return platform_get_device_id(pdev)->driver_data;
@@ -664,20 +670,27 @@ static int s3c_rtc_resume(struct platfor
 #define s3c_rtc_resume  NULL
 #endif
 
+static struct s3c_rtc_drv_data s3c_rtc_drv_data_array[] = {
+	[TYPE_S3C2410] = { TYPE_S3C2410 },
+	[TYPE_S3C2416] = { TYPE_S3C2416 },
+	[TYPE_S3C2443] = { TYPE_S3C2443 },
+	[TYPE_S3C64XX] = { TYPE_S3C64XX },
+};
+
 #ifdef CONFIG_OF
 static const struct of_device_id s3c_rtc_dt_match[] = {
 	{
 		.compatible = "samsung,s3c2410-rtc",
-		.data = TYPE_S3C2410,
+		.data = &s3c_rtc_drv_data_array[TYPE_S3C2410],
 	}, {
 		.compatible = "samsung,s3c2416-rtc",
-		.data = TYPE_S3C2416,
+		.data = &s3c_rtc_drv_data_array[TYPE_S3C2416],
 	}, {
 		.compatible = "samsung,s3c2443-rtc",
-		.data = TYPE_S3C2443,
+		.data = &s3c_rtc_drv_data_array[TYPE_S3C2443],
 	}, {
 		.compatible = "samsung,s3c6410-rtc",
-		.data = TYPE_S3C64XX,
+		.data = &s3c_rtc_drv_data_array[TYPE_S3C64XX],
 	},
 	{},
 };
_
Subject: Subject: drivers/rtc/rtc-s3c.c: add placeholder for driver private data

Patches currently in -mm which might be from tushar.behera@linaro.org are

drivers-rtc-rtc-s3cc-fix-compilation-error.patch
drivers-rtc-rtc-s3cc-add-placeholder-for-driver-private-data.patch

