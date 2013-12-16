From: akpm@linux-foundation.org
Subject: + mfd-rtc-fix-for-previous-rtc-fix.patch added to -mm tree
Date: Mon, 16 Dec 2013 15:10:37 -0800
Message-ID: <52af886d.TY/Gx38b1IC3NnUV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab3LPXKi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 18:10:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sbkim73@samsung.com, kyungmin.park@samsung.com, k.kozlowski@samsung.com, broonie@linaro.org, sfr@canb.auug.org.au

Subject: + mfd-rtc-fix-for-previous-rtc-fix.patch added to -mm tree
To: sfr@canb.auug.org.au,broonie@linaro.org,k.kozlowski@samsung.com,kyungmin.park@samsung.com,sbkim73@samsung.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 15:10:37 -0800


The patch titled
     Subject: mfd/rtc: fix for previous RTC fix
has been added to the -mm tree.  Its filename is
     mfd-rtc-fix-for-previous-rtc-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mfd-rtc-fix-for-previous-rtc-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mfd-rtc-fix-for-previous-rtc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mfd/rtc: fix for previous RTC fix

This updates drivers/regulator/s2mps11.c for the changes in commit
3e1e4a5f3a32 ("mfd/rtc: s5m: fix register updating by adding regmap
for RTC").

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mark Brown <broonie@linaro.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/s2mps11.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/regulator/s2mps11.c~mfd-rtc-fix-for-previous-rtc-fix drivers/regulator/s2mps11.c
--- a/drivers/regulator/s2mps11.c~mfd-rtc-fix-for-previous-rtc-fix
+++ a/drivers/regulator/s2mps11.c
@@ -438,7 +438,7 @@ common_reg:
 	platform_set_drvdata(pdev, s2mps11);
 
 	config.dev = &pdev->dev;
-	config.regmap = iodev->regmap;
+	config.regmap = iodev->regmap_pmic;
 	config.driver_data = s2mps11;
 	for (i = 0; i < S2MPS11_REGULATOR_MAX; i++) {
 		if (!reg_np) {
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mfd-rtc-fix-for-previous-rtc-fix.patch
linux-next.patch
kernel-forkc-export-kernel_thread-to-modules.patch

