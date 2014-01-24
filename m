From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-mxcc-check-the-return-value-from-clk_prepare_enable.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:02:32 -0800
Message-ID: <52e2b8c8.IU0QQpH/pnK3VqJ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaAXTCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabio.estevam@freescale.com

Subject: [merged] drivers-rtc-rtc-mxcc-check-the-return-value-from-clk_prepare_enable.patch removed from -mm tree
To: fabio.estevam@freescale.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:32 -0800


The patch titled
     Subject: drivers/rtc/rtc-mxc.c: check the return value from clk_prepare_enable()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-mxcc-check-the-return-value-from-clk_prepare_enable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabio Estevam <fabio.estevam@freescale.com>
Subject: drivers/rtc/rtc-mxc.c: check the return value from clk_prepare_enable()

clk_prepare_enable() may fail, so let's check its return value and
propagate it in the case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-check-the-return-value-from-clk_prepare_enable drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-check-the-return-value-from-clk_prepare_enable
+++ a/drivers/rtc/rtc-mxc.c
@@ -394,7 +394,10 @@ static int mxc_rtc_probe(struct platform
 		return PTR_ERR(pdata->clk);
 	}
 
-	clk_prepare_enable(pdata->clk);
+	ret = clk_prepare_enable(pdata->clk);
+	if (ret)
+		return ret;
+
 	rate = clk_get_rate(pdata->clk);
 
 	if (rate == 32768)
_

Patches currently in -mm which might be from fabio.estevam@freescale.com are

origin.patch
linux-next.patch

