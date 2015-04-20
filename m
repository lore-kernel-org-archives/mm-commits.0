From: akpm@linux-foundation.org
Subject: [merged]
 rtc-rtc-s3c-remove-one-superfluous-rtc_valid_tm-check.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:18:24 -0700
Message-ID: <55355100.9rDmVFe/hGkvVPxX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbbDTTMD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, cw00.choi@samsung.com, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: remove one superfluous rtc_valid_tm() check
has been removed from the -mm tree.  Its filename was
     rtc-rtc-s3c-remove-one-superfluous-rtc_valid_tm-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
