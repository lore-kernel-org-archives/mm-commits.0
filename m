From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-dev_debug-for-typo-issue.patch added to -mm tree
Date: Fri, 09 May 2014 14:21:50 -0700
Message-ID: <536d46ee.pzDYj5SuEK72cokT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092AbaEIVVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2014 17:21:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gang.chen.5i5j@gmail.com

Subject: + drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-dev_debug-for-typo-issue.patch added to -mm tree
To: gang.chen.5i5j@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 09 May 2014 14:21:50 -0700


The patch titled
     Subject: drivers/rtc/rtc-puv3.c: use dev_dbg() instead of dev_debug() for typo issue
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-dev_debug-for-typo-issue.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-dev_debug-for-typo-issue.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-dev_debug-for-typo-issue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: drivers/rtc/rtc-puv3.c: use dev_dbg() instead of dev_debug() for typo issue

It is only a typo issue, the related commit:

  "1fbc4c4 drivers/rtc/rtc-puv3.c: use dev_dbg() instead of pr_debug()"

The related error (unicore32 with allmodconfig):

    CC [M]  drivers/rtc/rtc-puv3.o
  drivers/rtc/rtc-puv3.c: In function 'puv3_rtc_setpie':
  drivers/rtc/rtc-puv3.c:74: error: implicit declaration of function 'dev_debug'

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-puv3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-puv3.c~drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-dev_debug-for-typo-issue drivers/rtc/rtc-puv3.c
--- a/drivers/rtc/rtc-puv3.c~drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-dev_debug-for-typo-issue
+++ a/drivers/rtc/rtc-puv3.c
@@ -71,7 +71,7 @@ static int puv3_rtc_setpie(struct device
 {
 	unsigned int tmp;
 
-	dev_debug(dev, "%s: pie=%d\n", __func__, enabled);
+	dev_dbg(dev, "%s: pie=%d\n", __func__, enabled);
 
 	spin_lock_irq(&puv3_rtc_pie_lock);
 	tmp = readl(RTC_RTSR) & ~RTC_RTSR_HZE;
_

Patches currently in -mm which might be from gang.chen.5i5j@gmail.com are

drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-dev_debug-for-typo-issue.patch
drivers-rtc-rtc-puv3c-remove-dev-for-typo-issue.patch
linux-next.patch

