From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-s3cc-remove-unnecessary-err_nores-label.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:08:17 -0800
Message-ID: <20121218200818.26B7B200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f201.google.com ([209.85.215.201]:45918 "EHLO
	mail-ea0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab2LRUIU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:08:20 -0500
Received: by mail-ea0-f201.google.com with SMTP id b14so63494eaa.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:08:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tushar.behera@linaro.org, a.zummo@towertech.it, grant.likely@secretlab.ca, rob.herring@calxeda.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: remove unnecessary err_nores label
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-s3cc-remove-unnecessary-err_nores-label.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tushar Behera <tushar.behera@linaro.org>
Subject: drivers/rtc/rtc-s3c.c: remove unnecessary err_nores label

err_nores label redirects to a simple return statement.  Move the return
statement to caller location and remove the label.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-remove-unnecessary-err_nores-label drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-remove-unnecessary-err_nores-label
+++ a/drivers/rtc/rtc-s3c.c
@@ -501,8 +501,7 @@ static int __devinit s3c_rtc_probe(struc
 
 	if (s3c_rtc_mem == NULL) {
 		dev_err(&pdev->dev, "failed to reserve memory region\n");
-		ret = -ENOENT;
-		goto err_nores;
+		return -ENOENT;
 	}
 
 	s3c_rtc_base = ioremap(res->start, resource_size(res));
@@ -612,8 +611,6 @@ static int __devinit s3c_rtc_probe(struc
 
  err_nomap:
 	release_resource(s3c_rtc_mem);
