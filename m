From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-s3cc-add-needs_src_clk-to-s3c6410-rtc-data.patch added to
 -mm tree
Date: Thu, 26 Feb 2015 15:15:28 -0800
Message-ID: <54efa910.+1DU1czyR6OSyr4z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbbBZXP3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Feb 2015 18:15:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javier.martinez@collabora.co.uk, a.zummo@towertech.it, cw00.choi@samsung.com, dianders@chromium.org, khilman@linaro.org, m.szyprowski@samsung.com, olof@lixom.net, stable@vger.kernel.org, tyler.baker@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: Add .needs_src_clk to s3c6410 RTC data
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-s3cc-add-needs_src_clk-to-s3c6410-rtc-data.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-s3cc-add-needs_src_clk-to-s3c6410-rtc-data.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-s3cc-add-needs_src_clk-to-s3c6410-rtc-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: drivers/rtc/rtc-s3c.c: Add .needs_src_clk to s3c6410 RTC data

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

drivers-rtc-rtc-s3cc-add-needs_src_clk-to-s3c6410-rtc-data.patch
linux-next.patch

