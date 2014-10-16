From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-fix-s3c-rtc-initialization-failure-without-rtc-source-clock.patch added to -mm tree
Date: Thu, 16 Oct 2014 14:06:08 -0700
Message-ID: <54403340.VWnvclJu7bXEfnm3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaJPVGI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Oct 2014 17:06:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.szyprowski@samsung.com, cw00.choi@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: fix initialization failure without rtc source clock
has been added to the -mm tree.  Its filename is
     drivers-rtc-fix-s3c-rtc-initialization-failure-without-rtc-source-clock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-fix-s3c-rtc-initialization-failure-without-rtc-source-clock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-fix-s3c-rtc-initialization-failure-without-rtc-source-clock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
