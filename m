From: akpm@linux-foundation.org
Subject: + rtc-spear-fix-several-error-checks.patch added to -mm tree
Date: Wed, 22 Aug 2012 14:34:51 -0700
Message-ID: <20120822213451.A5E7B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:53348 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab2HVVex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Aug 2012 17:34:53 -0400
Received: by yhl10 with SMTP id 10so11456yhl.1
        for <mm-commits@vger.kernel.org>; Wed, 22 Aug 2012 14:34:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lars@metafoo.de, viresh.kumar@st.com


The patch titled
     Subject: RTC: spear: Fix several error checks
has been added to the -mm tree.  Its filename is
     rtc-spear-fix-several-error-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lars-Peter Clausen <lars@metafoo.de>
Subject: RTC: spear: Fix several error checks

There are several comparisons of a unsigned int to less than zero int spear RTC
driver. Such a check will always be true. In all these cases a signed int is
assigned to the unsigned variable, which is checked, before. So the right fix is
to make the checked variable signed as well. In one case the check can be
dropped completely, because all it does it returns 'err' if 'err' is less than
zero, otherwise it returns 0. Since in this particular case 'err' is always
either 0 or less this is the same as just returning 'err'.

The issue has been found using the following coccinelle semantic patch:

//<smpl>
@@
type T;
unsigned T i;
@@
(
*i < 0
|
*i >= 0
)
//</smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Viresh Kumar <viresh.kumar@st.com>
---
 1 file changed, 5 insertions(+), 7 deletions(-)

index e278547..bb507d2 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-spear.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-spear.c~rtc-spear-fix-several-error-checks drivers/rtc/rtc-spear.c
--- a/drivers/rtc/rtc-spear.c~rtc-spear-fix-several-error-checks
+++ a/drivers/rtc/rtc-spear.c
@@ -235,7 +235,7 @@ static int spear_rtc_read_time(struct de
 static int spear_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct spear_rtc_config *config = dev_get_drvdata(dev);
-	unsigned int time, date, err = 0;
+	unsigned int time, date;
 
 	if (tm2bcd(tm) < 0)
 		return -EINVAL;
@@ -247,11 +247,8 @@ static int spear_rtc_set_time(struct dev
 		(tm->tm_year << YEAR_SHIFT);
 	writel(time, config->ioaddr + TIME_REG);
 	writel(date, config->ioaddr + DATE_REG);
-	err = is_write_complete(config);
-	if (err < 0)
-		return err;
 
-	return 0;
+	return is_write_complete(config);
 }
 
 /*
@@ -295,7 +292,8 @@ static int spear_rtc_read_alarm(struct d
 static int spear_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	struct spear_rtc_config *config = dev_get_drvdata(dev);
-	unsigned int time, date, err = 0;
+	unsigned int time, date;
+	int err;
 
 	if (tm2bcd(&alm->time) < 0)
 		return -EINVAL;
@@ -357,7 +355,7 @@ static int __devinit spear_rtc_probe(str
 {
 	struct resource *res;
 	struct spear_rtc_config *config;
-	unsigned int status = 0;
+	int status = 0;
 	int irq;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
_

Patches currently in -mm which might be from lars@metafoo.de are

origin.patch
linux-next.patch
rtc-jz4740-fix-irq-error-check.patch
rtc-spear-fix-several-error-checks.patch

