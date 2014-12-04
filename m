From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-sirfsocc-move-hardware-initilization-earlier-in-probe.patch added to -mm tree
Date: Thu, 04 Dec 2014 15:24:58 -0800
Message-ID: <5480ed4a.n1f4EQeFAsU2s7TS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbaLDXY7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Dec 2014 18:24:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guo.zeng@csr.com, Baohua.Song@csr.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-sirfsoc.c: move hardware initilization earlier in probe
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-sirfsocc-move-hardware-initilization-earlier-in-probe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-sirfsocc-move-hardware-initilization-earlier-in-probe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-sirfsocc-move-hardware-initilization-earlier-in-probe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guo Zeng <guo.zeng@csr.com>
Subject: drivers/rtc/rtc-sirfsoc.c: move hardware initilization earlier in probe

Move rtc register to be later than hardware initilization.  the reason is
that devm_rtc_device_register() will do read_time() which is a callback
accessing hardware.  this sometimes causes hang in the hardware related
callback.

Signed-off-by: Guo Zeng <guo.zeng@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sirfsoc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-sirfsoc.c~drivers-rtc-rtc-sirfsocc-move-hardware-initilization-earlier-in-probe drivers/rtc/rtc-sirfsoc.c
--- a/drivers/rtc/rtc-sirfsoc.c~drivers-rtc-rtc-sirfsocc-move-hardware-initilization-earlier-in-probe
+++ a/drivers/rtc/rtc-sirfsoc.c
@@ -286,14 +286,6 @@ static int sirfsoc_rtc_probe(struct plat
 	rtc_div = ((32768 / RTC_HZ) / 2) - 1;
 	sirfsoc_rtc_iobrg_writel(rtc_div, rtcdrv->rtc_base + RTC_DIV);
 
-	rtcdrv->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
-			&sirfsoc_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtcdrv->rtc)) {
-		err = PTR_ERR(rtcdrv->rtc);
-		dev_err(&pdev->dev, "can't register RTC device\n");
-		return err;
-	}
