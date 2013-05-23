From: akpm@linux-foundation.org
Subject: + rtc-rtc-vr41xx-fix-error-return-code-in-rtc_probe.patch added
 to -mm tree
Date: Thu, 23 May 2013 13:29:39 -0700
Message-ID: <519e7c33.GA2z/e+p6c9TSlpt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759320Ab3EWU3j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 16:29:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yongjun_wei@trendmicro.com.cn

Subject: + rtc-rtc-vr41xx-fix-error-return-code-in-rtc_probe.patch added to -mm tree
To: yongjun_wei@trendmicro.com.cn
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 13:29:39 -0700


The patch titled
     Subject: drivers/rtc/rtc-vr41xx.c: fix error return code in rtc_probe()
has been added to the -mm tree.  Its filename is
     rtc-rtc-vr41xx-fix-error-return-code-in-rtc_probe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: drivers/rtc/rtc-vr41xx.c: fix error return code in rtc_probe()

Fix to return -EBUSY in the platform irq get error handling case instead
of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vr41xx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-vr41xx.c~rtc-rtc-vr41xx-fix-error-return-code-in-rtc_probe drivers/rtc/rtc-vr41xx.c
--- a/drivers/rtc/rtc-vr41xx.c~rtc-rtc-vr41xx-fix-error-return-code-in-rtc_probe
+++ a/drivers/rtc/rtc-vr41xx.c
@@ -339,8 +339,10 @@ static int rtc_probe(struct platform_dev
 		goto err_device_unregister;
 
 	pie_irq = platform_get_irq(pdev, 1);
-	if (pie_irq <= 0)
+	if (pie_irq <= 0) {
+		retval = -EBUSY;
 		goto err_free_irq;
+	}
 
 	retval = request_irq(pie_irq, rtclong1_interrupt, 0,
 			     "rtclong1", pdev);
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
linux-next.patch
rtc-rtc-vr41xx-fix-error-return-code-in-rtc_probe.patch

