From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-vr41xxc-fix-spacing-issues.patch added to -mm tree
Date: Tue, 07 May 2013 15:39:38 -0700
Message-ID: <20130507223938.BF26631C082@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:48922 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab3EGWjj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 18:39:39 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so121171vcb.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 15:39:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-vr41xx.c: fix spacing issues
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-vr41xxc-fix-spacing-issues.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-vr41xx.c: fix spacing issues

Fixes the following types of issues:
ERROR: code indent should use tabs where possible

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vr41xx.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-vr41xx.c~drivers-rtc-rtc-vr41xxc-fix-spacing-issues drivers/rtc/rtc-vr41xx.c
--- a/drivers/rtc/rtc-vr41xx.c~drivers-rtc-rtc-vr41xxc-fix-spacing-issues
+++ a/drivers/rtc/rtc-vr41xx.c
@@ -103,7 +103,7 @@ static inline unsigned long read_elapsed
 		second_mid = rtc1_read(ETIMEMREG);
 		second_high = rtc1_read(ETIMEHREG);
 	} while (first_low != second_low || first_mid != second_mid ||
-	         first_high != second_high);
+		 first_high != second_high);
 
 	return (first_high << 17) | (first_mid << 1) | (first_low >> 15);
 }
@@ -154,7 +154,7 @@ static int vr41xx_rtc_set_time(struct de
 
 	epoch_sec = mktime(epoch, 1, 1, 0, 0, 0);
 	current_sec = mktime(time->tm_year + 1900, time->tm_mon + 1, time->tm_mday,
-	                     time->tm_hour, time->tm_min, time->tm_sec);
+			     time->tm_hour, time->tm_min, time->tm_sec);
 
 	write_elapsed_second(current_sec - epoch_sec);
 
@@ -186,7 +186,7 @@ static int vr41xx_rtc_set_alarm(struct d
 	struct rtc_time *time = &wkalrm->time;
 
 	alarm_sec = mktime(time->tm_year + 1900, time->tm_mon + 1, time->tm_mday,
-	                   time->tm_hour, time->tm_min, time->tm_sec);
+			   time->tm_hour, time->tm_min, time->tm_sec);
 
 	spin_lock_irq(&rtc_lock);
 
@@ -334,7 +334,7 @@ static int rtc_probe(struct platform_dev
 	}
 
 	retval = request_irq(aie_irq, elapsedtime_interrupt, 0,
-	                     "elapsed_time", pdev);
+			     "elapsed_time", pdev);
 	if (retval < 0)
 		goto err_device_unregister;
 
@@ -343,7 +343,7 @@ static int rtc_probe(struct platform_dev
 		goto err_free_irq;
 
 	retval = request_irq(pie_irq, rtclong1_interrupt, 0,
-		             "rtclong1", pdev);
+			     "rtclong1", pdev);
 	if (retval < 0)
 		goto err_free_irq;
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
drivers-rtc-rtc-v3020c-remove-redundant-goto.patch
drivers-rtc-interfacec-fix-checkpatch-errors.patch
drivers-rtc-rtc-at32ap700xc-fix-checkpatch-error.patch
drivers-rtc-rtc-at91rm9200c-include-linux-uaccessh.patch
drivers-rtc-rtc-cmosc-fix-whitespace-related-errors.patch
drivers-rtc-rtc-davincic-fix-whitespace-warning.patch
drivers-rtc-rtc-ds1305c-add-missing-braces-around-sizeof.patch
drivers-rtc-rtc-ds1374c-fix-spacing-related-issues.patch
drivers-rtc-rtc-ds1511c-fix-issues-related-to-spaces-and-braces.patch
drivers-rtc-rtc-ds3234c-fix-whitespace-issue.patch
drivers-rtc-rtc-fm3130c-fix-whitespace-related-issue.patch
drivers-rtc-rtc-m41t80c-fix-spacing-related-issue.patch
drivers-rtc-rtc-max6902c-remove-unwanted-spaces.patch
drivers-rtc-rtc-max77686c-remove-space-before-semicolon.patch
drivers-rtc-rtc-max8997c-remove-space-before-semicolon.patch
drivers-rtc-rtc-mpc5121c-remove-space-before-tab.patch
drivers-rtc-rtc-msm6242c-use-pr_warn.patch
drivers-rtc-rtc-mxcc-fix-checkpatch-error.patch
drivers-rtc-rtc-omapc-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-pcf2123c-remove-space-before-tabs.patch
drivers-rtc-rtc-pcf8583c-move-assignment-outside-if-condition.patch
drivers-rtc-rtc-rs5c313c-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-rs5c313c-fix-spacing-related-issues.patch
drivers-rtc-rtc-v3020c-fix-spacing-issues.patch
drivers-rtc-rtc-vr41xxc-fix-spacing-issues.patch
drivers-rtc-rtc-x1205c-fix-checkpatch-issues.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch

