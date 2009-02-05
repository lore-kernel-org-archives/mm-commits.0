From: akpm@linux-foundation.org
Subject: [merged] mfd-improve-diagnostics-for-wm8350-id-register-probe.patch removed from -mm tree
Date: Thu, 05 Feb 2009 11:14:25 -0800
Message-ID: <200902051914.n15JEP3c011675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751610AbZBETPV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 14:15:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     mfd: improve diagnostics for WM8350 ID register probe
has been removed from the -mm tree.  Its filename was
     mfd-improve-diagnostics-for-wm8350-id-register-probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: improve diagnostics for WM8350 ID register probe
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Check the return value of the device I/O functions when reading the ID
registers so we can provide a more useful diagnostic when we're having
trouble talking to the device.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/wm8350-core.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff -puN drivers/mfd/wm8350-core.c~mfd-improve-diagnostics-for-wm8350-id-register-probe drivers/mfd/wm8350-core.c
--- a/drivers/mfd/wm8350-core.c~mfd-improve-diagnostics-for-wm8350-id-register-probe
+++ a/drivers/mfd/wm8350-core.c
@@ -1297,14 +1297,29 @@ static void wm8350_client_dev_register(s
 int wm8350_device_init(struct wm8350 *wm8350, int irq,
 		       struct wm8350_platform_data *pdata)
 {
-	int ret = -EINVAL;
+	int ret;
 	u16 id1, id2, mask_rev;
 	u16 cust_id, mode, chip_rev;
 
 	/* get WM8350 revision and config mode */
-	wm8350->read_dev(wm8350, WM8350_RESET_ID, sizeof(id1), &id1);
-	wm8350->read_dev(wm8350, WM8350_ID, sizeof(id2), &id2);
-	wm8350->read_dev(wm8350, WM8350_REVISION, sizeof(mask_rev), &mask_rev);
+	ret = wm8350->read_dev(wm8350, WM8350_RESET_ID, sizeof(id1), &id1);
+	if (ret != 0) {
+		dev_err(wm8350->dev, "Failed to read ID: %d\n", ret);
+		goto err;
+	}
+
+	ret = wm8350->read_dev(wm8350, WM8350_ID, sizeof(id2), &id2);
+	if (ret != 0) {
+		dev_err(wm8350->dev, "Failed to read ID: %d\n", ret);
+		goto err;
+	}
+
+	ret = wm8350->read_dev(wm8350, WM8350_REVISION, sizeof(mask_rev),
+			       &mask_rev);
+	if (ret != 0) {
+		dev_err(wm8350->dev, "Failed to read revision: %d\n", ret);
+		goto err;
+	}
 
 	id1 = be16_to_cpu(id1);
 	id2 = be16_to_cpu(id2);
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch
mfd-support-active-high-irqs-on-wm835x.patch
mfd-ensure-all-wm8350-irqs-are-masked-at-startup.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch
rtc-wm8350-retries-will-reach-1.patch

