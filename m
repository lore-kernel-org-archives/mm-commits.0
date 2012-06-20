From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ab8500c-remove-fix-for-ab8500-ed-version.patch added to -mm tree
Date: Wed, 20 Jun 2012 15:52:37 -0700
Message-ID: <20120620225237.E9188A01BD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:34410 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758315Ab2FTWwk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 18:52:40 -0400
Received: by eeit10 with SMTP id t10so277eei.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 15:52:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bengt.g.jonsson@stericsson.com, a.zummo@towertech.it, linus.walleij@linaro.org


The patch titled
     Subject: drivers/rtc/rtc-ab8500.c: remove fix for AB8500 ED version
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ab8500c-remove-fix-for-ab8500-ed-version.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: drivers/rtc/rtc-ab8500.c: remove fix for AB8500 ED version

AB8500 ED (Early Drop) is no longer supported by the kernel.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab8500.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff -puN drivers/rtc/rtc-ab8500.c~drivers-rtc-rtc-ab8500c-remove-fix-for-ab8500-ed-version drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~drivers-rtc-rtc-ab8500c-remove-fix-for-ab8500-ed-version
+++ a/drivers/rtc/rtc-ab8500.c
@@ -88,22 +88,17 @@ static int ab8500_rtc_read_time(struct d
 	if (retval < 0)
 		return retval;
 
-	/* Early AB8500 chips will not clear the rtc read request bit */
-	if (abx500_get_chip_id(dev) == 0) {
-		usleep_range(1000, 1000);
-	} else {
-		/* Wait for some cycles after enabling the rtc read in ab8500 */
-		while (time_before(jiffies, timeout)) {
-			retval = abx500_get_register_interruptible(dev,
-				AB8500_RTC, AB8500_RTC_READ_REQ_REG, &value);
-			if (retval < 0)
-				return retval;
+	/* Wait for some cycles after enabling the rtc read in ab8500 */
+	while (time_before(jiffies, timeout)) {
+		retval = abx500_get_register_interruptible(dev,
+			AB8500_RTC, AB8500_RTC_READ_REQ_REG, &value);
+		if (retval < 0)
+			return retval;
 
-			if (!(value & RTC_READ_REQUEST))
-				break;
+		if (!(value & RTC_READ_REQUEST))
+			break;
 
-			usleep_range(1000, 5000);
-		}
+		usleep_range(1000, 5000);
 	}
 
 	/* Read the Watchtime registers */
_
Subject: Subject: drivers/rtc/rtc-ab8500.c: remove fix for AB8500 ED version

Patches currently in -mm which might be from bengt.g.jonsson@stericsson.com are

drivers-rtc-rtc-ab8500c-remove-fix-for-ab8500-ed-version.patch

