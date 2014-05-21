From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-puv3c-remove-dev-for-typo-issue.patch
 removed from -mm tree
Date: Wed, 21 May 2014 11:55:14 -0700
Message-ID: <537cf692.bM1Eebo8EqYb1XYh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbaEUSzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 May 2014 14:55:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gang.chen.5i5j@gmail.com

Subject: [merged] drivers-rtc-rtc-puv3c-remove-dev-for-typo-issue.patch removed from -mm tree
To: gang.chen.5i5j@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 21 May 2014 11:55:14 -0700


The patch titled
     Subject: drivers/rtc/rtc-puv3.c: remove "&dev->" for typo issue
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-puv3c-remove-dev-for-typo-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: drivers/rtc/rtc-puv3.c: remove "&dev->" for typo issue

It is only a typo issue, the related commit:

  "1fbc4c4 drivers/rtc/rtc-puv3.c: use dev_dbg() instead of pr_debug()"

The related error (for unicore32 with allmodconfig):

    CC [M]  drivers/rtc/rtc-puv3.o
  drivers/rtc/rtc-puv3.c: In function 'puv3_rtc_setalarm':
  drivers/rtc/rtc-puv3.c:143: error: 'struct device' has no member named 'dev'

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-puv3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-puv3.c~drivers-rtc-rtc-puv3c-remove-dev-for-typo-issue drivers/rtc/rtc-puv3.c
--- a/drivers/rtc/rtc-puv3.c~drivers-rtc-rtc-puv3c-remove-dev-for-typo-issue
+++ a/drivers/rtc/rtc-puv3.c
@@ -140,7 +140,7 @@ static int puv3_rtc_setalarm(struct devi
 	rtc_tm_to_time(tm, &rtcalarm_count);
 	writel(rtcalarm_count, RTC_RTAR);
 
-	puv3_rtc_setaie(&dev->dev, alrm->enabled);
+	puv3_rtc_setaie(dev, alrm->enabled);
 
 	if (alrm->enabled)
 		enable_irq_wake(puv3_rtc_alarmno);
_

Patches currently in -mm which might be from gang.chen.5i5j@gmail.com are

linux-next.patch

