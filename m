From: akpm@linux-foundation.org
Subject: +
 rtc-max77686-fail-to-probe-if-no-rtc-regmap-irqchip-is-set.patch added to
 -mm tree
Date: Fri, 12 Sep 2014 15:13:48 -0700
Message-ID: <5413701c.tpbPhu2bgn4xfCkx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbaILWNt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Sep 2014 18:13:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javier.martinez@collabora.co.uk, a.zummo@towertech.it, dianders@chromium.org, k.kozlowski@samsung.com, olof@lixom.net, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: max77686: fail to probe if no RTC regmap irqchip is set
has been added to the -mm tree.  Its filename is
     rtc-max77686-fail-to-probe-if-no-rtc-regmap-irqchip-is-set.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-max77686-fail-to-probe-if-no-rtc-regmap-irqchip-is-set.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-max77686-fail-to-probe-if-no-rtc-regmap-irqchip-is-set.patch

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

rtc-rk808-add-rtc-driver-for-rk808.patch
clk-rk808-add-clkout-driver-for-rk808.patch
rtc-max77686-allow-the-max77686-rtc-to-wakeup-the-system.patch
rtc-max77686-remove-dead-code-for-smpl-and-wtsr.patch
rtc-max77686-fail-to-probe-if-no-rtc-regmap-irqchip-is-set.patch
rtc-max77686-remove-unneded-info-log.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock.patch
linux-next.patch

