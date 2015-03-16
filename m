From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-s3cc-add-needs_src_clk-to-s3c6410-rtc-data.patch removed
 from -mm tree
Date: Mon, 16 Mar 2015 11:02:33 -0700
Message-ID: <55071ab9.9e0yJcDMp7hSbpCb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944AbbCPSCe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 14:02:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javier.martinez@collabora.co.uk, a.zummo@towertech.it, cw00.choi@samsung.com, dianders@chromium.org, khilman@linaro.org, m.szyprowski@samsung.com, olof@lixom.net, stable@vger.kernel.org, tyler.baker@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: add .needs_src_clk to s3c6410 RTC data
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-s3cc-add-needs_src_clk-to-s3c6410-rtc-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: drivers/rtc/rtc-s3c.c: add .needs_src_clk to s3c6410 RTC data

Commit df9e26d093d3 ("rtc: s3c: add support for RTC of Exynos3250 SoC")
added an "rtc_src" DT property to specify the clock used as a source to
the S3C real-time clock.

Not all SoCs needs this so commit eaf3a659086e ("drivers/rtc/rtc-s3c.c:
fix initialization failure without rtc source clock") changed to check
the struct s3c_rtc_data .needs_src_clk to conditionally grab the clock.

But that commit didn't update the data for each IP version so the RTC
broke on the boards that needs a source clock. This is the case of at
least Exynos5250 and Exynos5440 which uses the s3c6410 RTC IP block.

This commit fixes the S3C rtc on the Exynos5250 Snow and Exynos5420
Peach Pit and Pi Chromebooks.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Tyler Baker <tyler.baker@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-add-needs_src_clk-to-s3c6410-rtc-data drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-add-needs_src_clk-to-s3c6410-rtc-data
+++ a/drivers/rtc/rtc-s3c.c
@@ -849,6 +849,7 @@ static struct s3c_rtc_data const s3c2443
 
 static struct s3c_rtc_data const s3c6410_rtc_data = {
 	.max_user_freq		= 32768,
+	.needs_src_clk		= true,
 	.irq_handler		= s3c6410_rtc_irq,
 	.set_freq		= s3c6410_rtc_setfreq,
 	.enable_tick		= s3c6410_rtc_enable_tick,
_

Patches currently in -mm which might be from javier.martinez@collabora.co.uk are

linux-next.patch

