From: akpm@linux-foundation.org
Subject: + rtc-rtc-s3c-remove-one-superfluous-rtc_valid_tm-check.patch
 added to -mm tree
Date: Fri, 03 Apr 2015 14:41:17 -0700
Message-ID: <551f08fd.PfEaglGLvFZGnX7Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbbDCVlS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Apr 2015 17:41:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, cw00.choi@samsung.com, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: remove one superfluous rtc_valid_tm() check
has been added to the -mm tree.  Its filename is
     rtc-rtc-s3c-remove-one-superfluous-rtc_valid_tm-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-s3c-remove-one-superfluous-rtc_valid_tm-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-s3c-remove-one-superfluous-rtc_valid_tm-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: drivers/rtc/rtc-s3c.c: remove one superfluous rtc_valid_tm() check

s3c_rtc_gettime() already returns the result of rtc_valid_tm() on the
obtained time so get rid of another call to rtc_valid_tm().

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-remove-one-superfluous-rtc_valid_tm-check drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-remove-one-superfluous-rtc_valid_tm-check
+++ a/drivers/rtc/rtc-s3c.c
@@ -497,9 +497,7 @@ static int s3c_rtc_probe(struct platform
 	device_init_wakeup(&pdev->dev, 1);
 
 	/* Check RTC Time */
-	s3c_rtc_gettime(&pdev->dev, &rtc_tm);
