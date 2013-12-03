From: akpm@linux-foundation.org
Subject: [merged] mfd-sec-constify-regmap-configs-and-regmap-irqs.patch
 removed from -mm tree
Date: Tue, 03 Dec 2013 12:22:05 -0800
Message-ID: <529e3d6d.ZnCsKJi/VWISpG54%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab3LCUWH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 15:22:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sbkim73@samsung.com, sameo@linux.intel.com, m.szyprowski@samsung.com, lgirdwood@gmail.com, lee.jones@linaro.org, kyungmin.park@samsung.com, geert@linux-m68k.org, broonie@linaro.org, a.zummo@towertech.it, k.kozlowski@samsung.com

Subject: [merged] mfd-sec-constify-regmap-configs-and-regmap-irqs.patch removed from -mm tree
To: k.kozlowski@samsung.com,a.zummo@towertech.it,broonie@linaro.org,geert@linux-m68k.org,kyungmin.park@samsung.com,lee.jones@linaro.org,lgirdwood@gmail.com,m.szyprowski@samsung.com,sameo@linux.intel.com,sbkim73@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 12:22:05 -0800


The patch titled
     Subject: mfd: sec: constify regmap configs and regmap irqs
has been removed from the -mm tree.  Its filename was
     mfd-sec-constify-regmap-configs-and-regmap-irqs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: mfd: sec: constify regmap configs and regmap irqs

Add "const" to "static struct regmap_irq" and "static struct
regmap_config".

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Mark Brown <broonie@linaro.org>
Acked-by: Sangbeom Kim <sbkim73@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sec-core.c |    8 ++++----
 drivers/mfd/sec-irq.c  |   12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/mfd/sec-core.c~mfd-sec-constify-regmap-configs-and-regmap-irqs drivers/mfd/sec-core.c
--- a/drivers/mfd/sec-core.c~mfd-sec-constify-regmap-configs-and-regmap-irqs
+++ a/drivers/mfd/sec-core.c
@@ -134,12 +134,12 @@ static bool s5m8763_volatile(struct devi
 	}
 }
 
-static struct regmap_config sec_regmap_config = {
+static const struct regmap_config sec_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 };
 
-static struct regmap_config s2mps11_regmap_config = {
+static const struct regmap_config s2mps11_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 
@@ -148,7 +148,7 @@ static struct regmap_config s2mps11_regm
 	.cache_type = REGCACHE_FLAT,
 };
 
-static struct regmap_config s5m8763_regmap_config = {
+static const struct regmap_config s5m8763_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 
@@ -157,7 +157,7 @@ static struct regmap_config s5m8763_regm
 	.cache_type = REGCACHE_FLAT,
 };
 
-static struct regmap_config s5m8767_regmap_config = {
+static const struct regmap_config s5m8767_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 
diff -puN drivers/mfd/sec-irq.c~mfd-sec-constify-regmap-configs-and-regmap-irqs drivers/mfd/sec-irq.c
--- a/drivers/mfd/sec-irq.c~mfd-sec-constify-regmap-configs-and-regmap-irqs
+++ a/drivers/mfd/sec-irq.c
@@ -22,7 +22,7 @@
 #include <linux/mfd/samsung/s5m8763.h>
 #include <linux/mfd/samsung/s5m8767.h>
 
-static struct regmap_irq s2mps11_irqs[] = {
+static const struct regmap_irq s2mps11_irqs[] = {
 	[S2MPS11_IRQ_PWRONF] = {
 		.reg_offset = 0,
 		.mask = S2MPS11_IRQ_PWRONF_MASK,
@@ -90,7 +90,7 @@ static struct regmap_irq s2mps11_irqs[]
 };
 
 
-static struct regmap_irq s5m8767_irqs[] = {
+static const struct regmap_irq s5m8767_irqs[] = {
 	[S5M8767_IRQ_PWRR] = {
 		.reg_offset = 0,
 		.mask = S5M8767_IRQ_PWRR_MASK,
@@ -161,7 +161,7 @@ static struct regmap_irq s5m8767_irqs[]
 	},
 };
 
-static struct regmap_irq s5m8763_irqs[] = {
+static const struct regmap_irq s5m8763_irqs[] = {
 	[S5M8763_IRQ_DCINF] = {
 		.reg_offset = 0,
 		.mask = S5M8763_IRQ_DCINF_MASK,
@@ -236,7 +236,7 @@ static struct regmap_irq s5m8763_irqs[]
 	},
 };
 
-static struct regmap_irq_chip s2mps11_irq_chip = {
+static const struct regmap_irq_chip s2mps11_irq_chip = {
 	.name = "s2mps11",
 	.irqs = s2mps11_irqs,
 	.num_irqs = ARRAY_SIZE(s2mps11_irqs),
@@ -246,7 +246,7 @@ static struct regmap_irq_chip s2mps11_ir
 	.ack_base = S2MPS11_REG_INT1,
 };
 
-static struct regmap_irq_chip s5m8767_irq_chip = {
+static const struct regmap_irq_chip s5m8767_irq_chip = {
 	.name = "s5m8767",
 	.irqs = s5m8767_irqs,
 	.num_irqs = ARRAY_SIZE(s5m8767_irqs),
@@ -256,7 +256,7 @@ static struct regmap_irq_chip s5m8767_ir
 	.ack_base = S5M8767_REG_INT1,
 };
 
-static struct regmap_irq_chip s5m8763_irq_chip = {
+static const struct regmap_irq_chip s5m8763_irq_chip = {
 	.name = "s5m8763",
 	.irqs = s5m8763_irqs,
 	.num_irqs = ARRAY_SIZE(s5m8763_irqs),
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

drivers-rtc-rtc-s5mc-fix-info-rtc-assignment.patch
rtc-s5m-fix-unsuccesful-irq-request-during-probe.patch
rtc-s5m-limit-endless-loop-waiting-for-register-update.patch
rtc-s5m-enable-irq-wake-during-suspend.patch
mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc.patch
swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch
linux-next.patch

