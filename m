From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-ds1742c-report-to-rtc-core-if-retrieved-time-is-invalid.patch added to -mm tree
Date: Thu, 29 Aug 2013 15:03:33 -0700
Message-ID: <521fc535.IWYeZ+qjbWw7uNro%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab3H2WDe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Aug 2013 18:03:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, shc_work@mail.ru

Subject: + drivers-rtc-rtc-ds1742c-report-to-rtc-core-if-retrieved-time-is-invalid.patch added to -mm tree
To: shc_work@mail.ru,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 29 Aug 2013 15:03:33 -0700


The patch titled
     Subject: drivers/rtc/rtc-ds1742.c: report to RTC core if retrieved time is invalid
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1742c-report-to-rtc-core-if-retrieved-time-is-invalid.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-ds1742c-report-to-rtc-core-if-retrieved-time-is-invalid.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-ds1742c-report-to-rtc-core-if-retrieved-time-is-invalid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Shiyan <shc_work@mail.ru>
Subject: drivers/rtc/rtc-ds1742.c: report to RTC core if retrieved time is invalid

Let RTC core decide if the retrieved time is invalid, instead of
processing errors in the driver.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1742.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-ds1742.c~drivers-rtc-rtc-ds1742c-report-to-rtc-core-if-retrieved-time-is-invalid drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~drivers-rtc-rtc-ds1742c-report-to-rtc-core-if-retrieved-time-is-invalid
+++ a/drivers/rtc/rtc-ds1742.c
@@ -115,11 +115,7 @@ static int ds1742_rtc_read_time(struct d
 	/* year is 1900 + tm->tm_year */
 	tm->tm_year = bcd2bin(year) + bcd2bin(century) * 100 - 1900;
 
-	if (rtc_valid_tm(tm) < 0) {
-		dev_err(dev, "retrieved date/time is not valid.\n");
-		rtc_time_to_tm(0, tm);
-	}
-	return 0;
+	return rtc_valid_tm(tm);
 }
 
 static const struct rtc_class_ops ds1742_rtc_ops = {
_

Patches currently in -mm which might be from shc_work@mail.ru are

drivers-rtc-rtc-ds1742c-use-devm_ioremap_resource.patch
drivers-rtc-rtc-ds1742c-remove-unused-field-rtc-from-private-structure.patch
drivers-rtc-rtc-ds1742c-report-to-rtc-core-if-retrieved-time-is-invalid.patch
linux-next.patch

