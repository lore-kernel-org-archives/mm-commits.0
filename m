From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-fix-s3c-rtc-initialization-failure-without-rtc-source-clock.patch removed from -mm tree
Date: Thu, 30 Oct 2014 13:27:34 -0700
Message-ID: <54529f36.PPNcQIcjDydb6zFd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161109AbaJ3U1d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 16:27:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.szyprowski@samsung.com, cw00.choi@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: fix initialization failure without rtc source clock
has been removed from the -mm tree.  Its filename was
     drivers-rtc-fix-s3c-rtc-initialization-failure-without-rtc-source-clock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: drivers/rtc/rtc-s3c.c: fix initialization failure without rtc source clock

Fix unconditional initialization failure on non-exynos3250 SoCs.  Commit
df9e26d093d33a097 ("rtc: s3c: add support for RTC of Exynos3250 SoC")
introduced rtc source clock support, but also added initialization failure
on SoCs, which doesn't need such clock.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-fix-s3c-rtc-initialization-failure-without-rtc-source-clock drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-fix-s3c-rtc-initialization-failure-without-rtc-source-clock
+++ a/drivers/rtc/rtc-s3c.c
@@ -535,13 +535,15 @@ static int s3c_rtc_probe(struct platform
 	}
 	clk_prepare_enable(info->rtc_clk);
 
-	info->rtc_src_clk = devm_clk_get(&pdev->dev, "rtc_src");
-	if (IS_ERR(info->rtc_src_clk)) {
-		dev_err(&pdev->dev, "failed to find rtc source clock\n");
-		return PTR_ERR(info->rtc_src_clk);
+	if (info->data->needs_src_clk) {
+		info->rtc_src_clk = devm_clk_get(&pdev->dev, "rtc_src");
+		if (IS_ERR(info->rtc_src_clk)) {
+			dev_err(&pdev->dev,
+				"failed to find rtc source clock\n");
+			return PTR_ERR(info->rtc_src_clk);
+		}
+		clk_prepare_enable(info->rtc_src_clk);
 	}
-	clk_prepare_enable(info->rtc_src_clk);
