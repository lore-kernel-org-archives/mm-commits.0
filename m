From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-s3cc-remove-unnecessary-err_nores-label.patch added to -mm tree
Date: Tue, 27 Nov 2012 14:28:48 -0800
Message-ID: <20121127222849.122B482004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:65436 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab2K0W2u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 17:28:50 -0500
Received: by mail-qa0-f74.google.com with SMTP id g40so697819qab.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 14:28:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tushar.behera@linaro.org, a.zummo@towertech.it, grant.likely@secretlab.ca, rob.herring@calxeda.com


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: remove unnecessary err_nores label
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-s3cc-remove-unnecessary-err_nores-label.patch

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
