From: akpm@linux-foundation.org
Subject: [merged] mfd-support-active-high-irqs-on-wm835x.patch removed from -mm tree
Date: Mon, 09 Feb 2009 12:05:40 -0800
Message-ID: <200902092005.n19K5e94024833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbZBIUJI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 15:09:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     mfd: support active high IRQs on WM835x
has been removed from the -mm tree.  Its filename was
     mfd-support-active-high-irqs-on-wm835x.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: support active high IRQs on WM835x
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/wm8350-core.c       |   16 +++++++++++++++-
 include/linux/mfd/wm8350/core.h |    2 ++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff -puN drivers/mfd/wm8350-core.c~mfd-support-active-high-irqs-on-wm835x drivers/mfd/wm8350-core.c
--- a/drivers/mfd/wm8350-core.c~mfd-support-active-high-irqs-on-wm835x
+++ a/drivers/mfd/wm8350-core.c
@@ -1432,7 +1432,21 @@ int wm8350_device_init(struct wm8350 *wm
 	mutex_init(&wm8350->irq_mutex);
 	INIT_WORK(&wm8350->irq_work, wm8350_irq_worker);
 	if (irq) {
-		ret = request_irq(irq, wm8350_irq, 0,
+		int flags = 0;
+
+		if (pdata && pdata->irq_high) {
+			flags |= IRQF_TRIGGER_HIGH;
+
+			wm8350_set_bits(wm8350, WM8350_SYSTEM_CONTROL_1,
+					WM8350_IRQ_POL);
+		} else {
+			flags |= IRQF_TRIGGER_LOW;
+
+			wm8350_clear_bits(wm8350, WM8350_SYSTEM_CONTROL_1,
+					  WM8350_IRQ_POL);
+		}
+
+		ret = request_irq(irq, wm8350_irq, flags,
 				  "wm8350", wm8350);
 		if (ret != 0) {
 			dev_err(wm8350->dev, "Failed to request IRQ: %d\n",
diff -puN include/linux/mfd/wm8350/core.h~mfd-support-active-high-irqs-on-wm835x include/linux/mfd/wm8350/core.h
--- a/include/linux/mfd/wm8350/core.h~mfd-support-active-high-irqs-on-wm835x
+++ a/include/linux/mfd/wm8350/core.h
@@ -640,9 +640,11 @@ struct wm8350 {
  *
  * @init: Function called during driver initialisation.  Should be
  *        used by the platform to configure GPIO functions and similar.
+ * @irq_high: Set if WM8350 IRQ is active high.
  */
 struct wm8350_platform_data {
 	int (*init)(struct wm8350 *wm8350);
+	int irq_high;
 };
 
 
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch
rtc-wm8350-retries-will-reach-1.patch

