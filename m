From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ds1374c-fix-spacing-related-issues.patch added to -mm tree
Date: Tue, 07 May 2013 15:39:04 -0700
Message-ID: <20130507223904.D54465A4016@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:39713 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab3EGWjG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 18:39:06 -0400
Received: by mail-qa0-f73.google.com with SMTP id bs12so145612qab.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 15:39:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-ds1374.c: fix spacing related issues
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1374c-fix-spacing-related-issues.patch

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
Subject: drivers/rtc/rtc-ds1374.c: fix spacing related issues

Fixes the following types of issues:
ERROR: code indent should use tabs where possible
WARNING: please, no spaces at the start of a line

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1374.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-ds1374.c~drivers-rtc-rtc-ds1374c-fix-spacing-related-issues drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~drivers-rtc-rtc-ds1374c-fix-spacing-related-issues
+++ a/drivers/rtc/rtc-ds1374.c
@@ -65,7 +65,7 @@ struct ds1374 {
 static struct i2c_driver ds1374_driver;
 
 static int ds1374_read_rtc(struct i2c_client *client, u32 *time,
-                           int reg, int nbytes)
+			   int reg, int nbytes)
 {
 	u8 buf[4];
 	int ret;
@@ -90,7 +90,7 @@ static int ds1374_read_rtc(struct i2c_cl
 }
 
 static int ds1374_write_rtc(struct i2c_client *client, u32 time,
-                            int reg, int nbytes)
+			    int reg, int nbytes)
 {
 	u8 buf[4];
 	int i;
@@ -119,8 +119,7 @@ static int ds1374_check_rtc_status(struc
 
 	if (stat & DS1374_REG_SR_OSF)
 		dev_warn(&client->dev,
-		         "oscillator discontinuity flagged, "
-		         "time unreliable\n");
+			 "oscillator discontinuity flagged, time unreliable\n");
 
 	stat &= ~(DS1374_REG_SR_OSF | DS1374_REG_SR_AF);
 
@@ -363,7 +362,7 @@ static int ds1374_probe(struct i2c_clien
 
 	if (client->irq > 0) {
 		ret = devm_request_irq(&client->dev, client->irq, ds1374_irq, 0,
-		                  "ds1374", client);
+					"ds1374", client);
 		if (ret) {
 			dev_err(&client->dev, "unable to request IRQ\n");
 			return ret;
@@ -373,7 +372,7 @@ static int ds1374_probe(struct i2c_clien
 	}
 
 	ds1374->rtc = devm_rtc_device_register(&client->dev, client->name,
-	                                  &ds1374_rtc_ops, THIS_MODULE);
+						&ds1374_rtc_ops, THIS_MODULE);
 	if (IS_ERR(ds1374->rtc)) {
 		dev_err(&client->dev, "unable to register the class device\n");
 		return PTR_ERR(ds1374->rtc);
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

