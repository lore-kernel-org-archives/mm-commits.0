From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-sirfsocc-move-hardware-initilization-earlier-in-probe.patch removed from -mm tree
Date: Thu, 11 Dec 2014 11:06:02 -0800
Message-ID: <5489eb1a.MVdjMpaj9I5i54at%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758231AbaLKTGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:06:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guo.zeng@csr.com, Baohua.Song@csr.com, a.zummo@towertech.it, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-sirfsoc.c: move hardware initilization earlier in probe
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-sirfsocc-move-hardware-initilization-earlier-in-probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guo Zeng <guo.zeng@csr.com>
Subject: drivers/rtc/rtc-sirfsoc.c: move hardware initilization earlier in probe

Move rtc register to be later than hardware initialization.  The reason is
that devm_rtc_device_register() will do read_time() which is a callback
accessing hardware.  This sometimes causes a hang in the hardware related
callback.

Signed-off-by: Guo Zeng <guo.zeng@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@vger.kernel.org>
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
