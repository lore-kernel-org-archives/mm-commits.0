From: akpm@linux-foundation.org
Subject: [merged] rtc-s5m-fix-unsuccesful-irq-request-during-probe.patch
 removed from -mm tree
Date: Mon, 16 Dec 2013 12:39:32 -0800
Message-ID: <52af6504.SfOfc7sDidLK879v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45827 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab3LPUjd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 15:39:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, sbkim73@samsung.com, sameo@linux.intel.com, m.szyprowski@samsung.com, lgirdwood@gmail.com, lee.jones@linaro.org, kyungmin.park@samsung.com, geert@linux-m68k.org, broonie@linaro.org, a.zummo@towertech.it, k.kozlowski@samsung.com

Subject: [merged] rtc-s5m-fix-unsuccesful-irq-request-during-probe.patch removed from -mm tree
To: k.kozlowski@samsung.com,a.zummo@towertech.it,broonie@linaro.org,geert@linux-m68k.org,kyungmin.park@samsung.com,lee.jones@linaro.org,lgirdwood@gmail.com,m.szyprowski@samsung.com,sameo@linux.intel.com,sbkim73@samsung.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 12:39:32 -0800


The patch titled
     Subject: rtc: s5m: fix unsuccesful IRQ request during probe
has been removed from the -mm tree.  Its filename was
     rtc-s5m-fix-unsuccesful-irq-request-during-probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: rtc: s5m: fix unsuccesful IRQ request during probe

Probe failed for rtc-s5m:
	s5m-rtc s5m-rtc: Failed to request alarm IRQ: 12: -22
	s5m-rtc: probe of s5m-rtc failed with error -22

Fix rtc-s5m interrupt request by using regmap_irq_get_virq() for mapping
the IRQ.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Mark Brown <broonie@linaro.org>
Acked-by: Sangbeom Kim <sbkim73@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s5m.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-s5m.c~rtc-s5m-fix-unsuccesful-irq-request-during-probe drivers/rtc/rtc-s5m.c
--- a/drivers/rtc/rtc-s5m.c~rtc-s5m-fix-unsuccesful-irq-request-during-probe
+++ a/drivers/rtc/rtc-s5m.c
@@ -548,11 +548,13 @@ static int s5m_rtc_probe(struct platform
 
 	switch (pdata->device_type) {
 	case S5M8763X:
-		info->irq = s5m87xx->irq_base + S5M8763_IRQ_ALARM0;
+		info->irq = regmap_irq_get_virq(s5m87xx->irq_data,
+				S5M8763_IRQ_ALARM0);
 		break;
 
 	case S5M8767X:
-		info->irq = s5m87xx->irq_base + S5M8767_IRQ_RTCA1;
+		info->irq = regmap_irq_get_virq(s5m87xx->irq_data,
+				S5M8767_IRQ_RTCA1);
 		break;
 
 	default:
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch
linux-next.patch

