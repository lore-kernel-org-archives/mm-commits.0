From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-rs5c313c-fix-spacing-related-issues.patch added to -mm tree
Date: Tue, 07 May 2013 15:39:34 -0700
Message-ID: <20130507223934.DE85A31C082@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:33932 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab3EGWjf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 18:39:35 -0400
Received: by mail-ye0-f201.google.com with SMTP id m14so121139yen.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 15:39:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-rs5c313.c: fix spacing related issues
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-rs5c313c-fix-spacing-related-issues.patch

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
Subject: drivers/rtc/rtc-rs5c313.c: fix spacing related issues

Fixes the following types of checkpatch issues:
WARNING: please, no space before tabs
ERROR: space prohibited after that open parenthesis '('
ERROR: space prohibited before that close parenthesis ')'
ERROR: need consistent spacing around '>>' (ctx:VxW)

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rs5c313.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-rs5c313.c~drivers-rtc-rtc-rs5c313c-fix-spacing-related-issues drivers/rtc/rtc-rs5c313.c
--- a/drivers/rtc/rtc-rs5c313.c~drivers-rtc-rtc-rs5c313c-fix-spacing-related-issues
+++ a/drivers/rtc/rtc-rs5c313.c
@@ -50,7 +50,7 @@
 #include <linux/io.h>
 
 #define DRV_NAME	"rs5c313"
-#define DRV_VERSION 	"1.13"
+#define DRV_VERSION	"1.13"
 
 #ifdef CONFIG_SH_LANDISK
 /*****************************************************/
@@ -301,7 +301,7 @@ static int rs5c313_rtc_set_time(struct d
 	rs5c313_write_reg(RS5C313_ADDR_SEC10, (data >> 4));
 
 	data = bin2bcd(tm->tm_min);
-	rs5c313_write_reg(RS5C313_ADDR_MIN, data );
+	rs5c313_write_reg(RS5C313_ADDR_MIN, data);
 	rs5c313_write_reg(RS5C313_ADDR_MIN10, (data >> 4));
 
 	data = bin2bcd(tm->tm_hour);
@@ -310,7 +310,7 @@ static int rs5c313_rtc_set_time(struct d
 
 	data = bin2bcd(tm->tm_mday);
 	rs5c313_write_reg(RS5C313_ADDR_DAY, data);
-	rs5c313_write_reg(RS5C313_ADDR_DAY10, (data>> 4));
+	rs5c313_write_reg(RS5C313_ADDR_DAY10, (data >> 4));
 
 	data = bin2bcd(tm->tm_mon + 1);
 	rs5c313_write_reg(RS5C313_ADDR_MON, data);
@@ -349,9 +349,9 @@ static void rs5c313_check_xstp_bit(void)
 		}
 
 		memset(&tm, 0, sizeof(struct rtc_time));
-		tm.tm_mday 	= 1;
-		tm.tm_mon 	= 1 - 1;
-		tm.tm_year 	= 2000 - 1900;
+		tm.tm_mday	= 1;
+		tm.tm_mon	= 1 - 1;
+		tm.tm_year	= 2000 - 1900;
 
 		rs5c313_rtc_set_time(NULL, &tm);
 		pr_err("invalid value, resetting to 1 Jan 2000\n");
@@ -388,7 +388,7 @@ static struct platform_driver rs5c313_rt
 		.name   = DRV_NAME,
 		.owner  = THIS_MODULE,
 	},
-	.probe 	= rs5c313_rtc_probe,
+	.probe	= rs5c313_rtc_probe,
 	.remove = rs5c313_rtc_remove,
 };
 
@@ -408,7 +408,7 @@ static int __init rs5c313_rtc_init(void)
 
 static void __exit rs5c313_rtc_exit(void)
 {
-	platform_driver_unregister( &rs5c313_rtc_platform_driver );
+	platform_driver_unregister(&rs5c313_rtc_platform_driver);
 }
 
 module_init(rs5c313_rtc_init);
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

