From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pxac-avoid-cpuid-checking.patch added to -mm tree
Date: Thu, 20 Dec 2012 15:45:53 -0800
Message-ID: <20121220234553.B6579100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:55652 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2LTXpz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 18:45:55 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so426746vbi.1
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 15:45:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haojian.zhuang@marvell.com, a.zummo@towertech.it, grant.likely@secretlab.ca


The patch titled
     Subject: drivers/rtc/rtc-pxa.c: avoid cpuid checking
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pxac-avoid-cpuid-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -444,10 +444,7 @@ static struct platform_driver pxa_rtc_dr
 
 static int __init pxa_rtc_init(void)
 {
-	if (cpu_is_pxa27x() || cpu_is_pxa3xx())
-		return platform_driver_probe(&pxa_rtc_driver, pxa_rtc_probe);
