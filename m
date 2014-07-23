From: akpm@linux-foundation.org
Subject: + driver-rtc-classc-check-the-error-after-rtc_read_time.patch
 added to -mm tree
Date: Wed, 23 Jul 2014 14:57:19 -0700
Message-ID: <53d02fbf.wMaCd6xP8+69uONr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:47645 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933543AbaGWV5U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jul 2014 17:57:20 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so542181oah.2
        for <mm-commits@vger.kernel.org>; Wed, 23 Jul 2014 14:57:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hyogi.gim@lge.com, a.zummo@towertech.it, rjw@rjwysocki.net, mm-commits@vger.kernel.org


The patch titled
     Subject: driver/rtc/class.c: check the error after rtc_read_time()
has been added to the -mm tree.  Its filename is
     driver-rtc-classc-check-the-error-after-rtc_read_time.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/driver-rtc-classc-check-the-error-after-rtc_read_time.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/driver-rtc-classc-check-the-error-after-rtc_read_time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hyogi Gim <hyogi.gim@lge.com>
Subject: driver/rtc/class.c: check the error after rtc_read_time()

In rtc_suspend() and rtc_resume(), the error after rtc_read_time() is not
checked.  If rtc device fail to read time, we cannot guarantee the
following process.

Add the verification code for returned rtc_read_time() error.

Signed-off-by: Hyogi Gim <hyogi.gim@lge.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/class.c~driver-rtc-classc-check-the-error-after-rtc_read_time drivers/rtc/class.c
--- a/drivers/rtc/class.c~driver-rtc-classc-check-the-error-after-rtc_read_time
+++ a/drivers/rtc/class.c
@@ -53,6 +53,7 @@ static int rtc_suspend(struct device *de
 	struct rtc_device	*rtc = to_rtc_device(dev);
 	struct rtc_time		tm;
 	struct timespec		delta, delta_delta;
+	int err;
 
 	if (has_persistent_clock())
 		return 0;
@@ -61,7 +62,12 @@ static int rtc_suspend(struct device *de
 		return 0;
 
 	/* snapshot the current RTC and system time at suspend*/
-	rtc_read_time(rtc, &tm);
+	err = rtc_read_time(rtc, &tm);
+	if (err < 0) {
+		pr_debug("%s:  fail to read rtc time\n", dev_name(&rtc->dev));
+		return 0;
+	}
+
 	getnstimeofday(&old_system);
 	rtc_tm_to_time(&tm, &old_rtc.tv_sec);
 
@@ -94,6 +100,7 @@ static int rtc_resume(struct device *dev
 	struct rtc_time		tm;
 	struct timespec		new_system, new_rtc;
 	struct timespec		sleep_time;
+	int err;
 
 	if (has_persistent_clock())
 		return 0;
@@ -104,7 +111,12 @@ static int rtc_resume(struct device *dev
 
 	/* snapshot the current rtc and system time at resume */
 	getnstimeofday(&new_system);
-	rtc_read_time(rtc, &tm);
+	err = rtc_read_time(rtc, &tm);
+	if (err < 0) {
+		pr_debug("%s:  fail to read rtc time\n", dev_name(&rtc->dev));
+		return 0;
+	}
+
 	if (rtc_valid_tm(&tm) != 0) {
 		pr_debug("%s:  bogus resume time\n", dev_name(&rtc->dev));
 		return 0;
_

Patches currently in -mm which might be from hyogi.gim@lge.com are

drivers-rtc-interfacec-check-the-error-after-__rtc_read_time.patch
driver-rtc-classc-check-the-error-after-rtc_read_time.patch

