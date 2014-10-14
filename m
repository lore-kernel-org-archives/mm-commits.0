From: akpm@linux-foundation.org
Subject: [merged]
 rtc-max77686-fail-to-probe-if-no-rtc-regmap-irqchip-is-set.patch removed
 from -mm tree
Date: Tue, 14 Oct 2014 11:20:42 -0700
Message-ID: <543d697a.p2b3k9kxcbMkv8eo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaJNSUl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:20:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javier.martinez@collabora.co.uk, a.zummo@towertech.it, dianders@chromium.org, k.kozlowski@samsung.com, olof@lixom.net, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: max77686: fail to probe if no RTC regmap irqchip is set
has been removed from the -mm tree.  Its filename was
     rtc-max77686-fail-to-probe-if-no-rtc-regmap-irqchip-is-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: rtc: max77686: fail to probe if no RTC regmap irqchip is set

The max77686 mfd driver adds a regmap IRQ chip which creates an IRQ domain
that is used to map the virtual RTC alarm1 interrupt.

The RTC driver assumes that this will always be true since the PMIC IRQ is
a required property according to the max77686 DT binding doc.  If an
"interrupts" property is not defined for a max77686 PMIC, then the mfd
probe function will fail and the RTC platform driver will never be probed.
 But even when it is not possible to probe the rtc-max77686 driver without
a regmap IRQ chip, it's better to explicitly check if the IRQ chip data is
not NULL and gracefully fail instead of getting an OOPS.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reported-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Olof Johansson <olof@lixom.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/rtc/rtc-max77686.c~rtc-max77686-fail-to-probe-if-no-rtc-regmap-irqchip-is-set drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~rtc-max77686-fail-to-probe-if-no-rtc-regmap-irqchip-is-set
+++ a/drivers/rtc/rtc-max77686.c
@@ -466,6 +466,12 @@ static int max77686_rtc_probe(struct pla
 		goto err_rtc;
 	}
 
+	if (!max77686->rtc_irq_data) {
+		ret = -EINVAL;
+		dev_err(&pdev->dev, "%s: no RTC regmap IRQ chip\n", __func__);
+		goto err_rtc;
+	}
+
 	info->virq = regmap_irq_get_virq(max77686->rtc_irq_data,
 					 MAX77686_RTCIRQ_RTCA1);
 	if (!info->virq) {
_

Patches currently in -mm which might be from javier.martinez@collabora.co.uk are

origin.patch
linux-next.patch

