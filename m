From: akpm@linux-foundation.org
Subject: + rtc-da9052-add-constraints-to-set-valid-year.patch added to -mm tree
Date: Wed, 11 Mar 2015 13:54:58 -0700
Message-ID: <5500aba2.EWlSrY+q/pxZqELr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49754 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbbCKUy7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 16:54:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adam.ward.opensource@diasemi.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-da9052.c: add constraints to set valid year
has been added to the -mm tree.  Its filename is
     rtc-da9052-add-constraints-to-set-valid-year.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-da9052-add-constraints-to-set-valid-year.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-da9052-add-constraints-to-set-valid-year.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Adam Ward <adam.ward.opensource@diasemi.com>
Subject: drivers/rtc/rtc-da9052.c: add constraints to set valid year

Signed-off-by: Adam Ward <adam.ward.opensource@diasemi.com>
Tested-by: Adam Ward <adam.ward.opensource@diasemi.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-da9052.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/rtc/rtc-da9052.c~rtc-da9052-add-constraints-to-set-valid-year drivers/rtc/rtc-da9052.c
--- a/drivers/rtc/rtc-da9052.c~rtc-da9052-add-constraints-to-set-valid-year
+++ a/drivers/rtc/rtc-da9052.c
@@ -206,6 +206,10 @@ static int da9052_rtc_set_time(struct de
 	uint8_t v[6];
 	int ret;
 
+	/* DA9052 only has 6 bits for year - to represent 2000-2063 */
+	if ((tm->tm_year < 100) || (tm->tm_year > 163))
+		return -EINVAL;
+
 	rtc = dev_get_drvdata(dev);
 
 	v[0] = tm->tm_sec;
@@ -243,6 +247,10 @@ static int da9052_rtc_set_alarm(struct d
 	struct rtc_time *tm = &alrm->time;
 	struct da9052_rtc *rtc = dev_get_drvdata(dev);
 
+	/* DA9052 only has 6 bits for year - to represent 2000-2063 */
+	if ((tm->tm_year < 100) || (tm->tm_year > 163))
+		return -EINVAL;
+
 	ret = da9052_rtc_enable_alarm(rtc, 0);
 	if (ret < 0)
 		return ret;
_

Patches currently in -mm which might be from adam.ward.opensource@diasemi.com are

rtc-da9052-add-extra-reads-with-timeouts-to-avoid-returning-partially-updated-values.patch
rtc-da9052-add-constraints-to-set-valid-year.patch
rtc-da9052-register-ability-of-alarm-to-wake-device-from-suspend.patch

