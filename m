From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-pxac-avoid-cpuid-checking.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:43:26 -0800
Message-ID: <20130222204326.9EA2E31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:47102 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470Ab3BVUn1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:43:27 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so104326qen.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:43:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haojian.zhuang@marvell.com, a.zummo@towertech.it, grant.likely@secretlab.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pxa.c: avoid cpuid checking
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pxac-avoid-cpuid-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: drivers/rtc/rtc-pxa.c: avoid cpuid checking

pxa-rtc is widely used in pxa27x/pxa3xx/pxa93x/pxa95x. Checking cpuid in
pxa-rtc driver is unnecessary since we assign on-chip device in soc files.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pxa.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-pxa.c~drivers-rtc-rtc-pxac-avoid-cpuid-checking drivers/rtc/rtc-pxa.c
--- a/drivers/rtc/rtc-pxa.c~drivers-rtc-rtc-pxac-avoid-cpuid-checking
+++ a/drivers/rtc/rtc-pxa.c
@@ -454,10 +454,7 @@ static struct platform_driver pxa_rtc_dr
 
 static int __init pxa_rtc_init(void)
 {
-	if (cpu_is_pxa27x() || cpu_is_pxa3xx())
-		return platform_driver_probe(&pxa_rtc_driver, pxa_rtc_probe);
