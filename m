From: akpm@linux-foundation.org
Subject: [to-be-updated]
 rtc-s3c-remove-warning-message-when-checking-coding-style-with-checkpatch-script.patch removed from -mm tree
Date: Thu, 28 Aug 2014 14:59:05 -0700
Message-ID: <53ffa629.JlNuW2bgNeZJ9nly%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:51384 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaH1V7G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Aug 2014 17:59:06 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so271230yha.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2014 14:59:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cw00.choi@samsung.com, a.zummo@towertech.it, kgene.kim@samsung.com, kyungmin.park@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: s3c: remove warning message when checking coding style with checkpatch script
has been removed from the -mm tree.  Its filename was
     rtc-s3c-remove-warning-message-when-checking-coding-style-with-checkpatch-script.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: rtc: s3c: remove warning message when checking coding style with checkpatch script

Remove warning messages when checking codeing style with checkpatch script
and reduce un-necessary i2c read operation on s3c_rtc_enable.

	WARNING: line over 80 characters
	#406: FILE: drivers/rtc/rtc-s3c.c:406:
	+		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_RTCEN) == 0) {

	WARNING: line over 80 characters
	#414: FILE: drivers/rtc/rtc-s3c.c:414:
	+		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_CNTSEL)) {

	WARNING: line over 80 characters
	#422: FILE: drivers/rtc/rtc-s3c.c:422:
	+		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_CLKRST)) {

	WARNING: Missing a blank line after declarations
	#451: FILE: drivers/rtc/rtc-s3c.c:451:
	+	struct s3c_rtc_drv_data *data;
	+	if (pdev->dev.of_node) {

	WARNING: Missing a blank line after declarations
	#453: FILE: drivers/rtc/rtc-s3c.c:453:
	+		const struct of_device_id *match;
	+		match = of_match_node(s3c_rtc_dt_match, pdev->dev.of_node);

	WARNING: DT compatible string "samsung,s3c2416-rtc" appears un-documented -- check ./Documentation/devicetree/bindings/
	#650: FILE: drivers/rtc/rtc-s3c.c:650:
	+		.compatible = "samsung,s3c2416-rtc",

	WARNING: DT compatible string "samsung,s3c2443-rtc" appears un-documented -- check ./Documentation/devicetree/bindings/
	#653: FILE: drivers/rtc/rtc-s3c.c:653:
	+		.compatible = "samsung,s3c2443-rtc",

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/s3c-rtc.txt |    2 
 drivers/rtc/rtc-s3c.c                             |   26 ++++++------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff -puN Documentation/devicetree/bindings/rtc/s3c-rtc.txt~rtc-s3c-remove-warning-message-when-checking-coding-style-with-checkpatch-script Documentation/devicetree/bindings/rtc/s3c-rtc.txt
--- a/Documentation/devicetree/bindings/rtc/s3c-rtc.txt~rtc-s3c-remove-warning-message-when-checking-coding-style-with-checkpatch-script
+++ a/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
@@ -3,6 +3,8 @@
 Required properties:
 - compatible: should be one of the following.
     * "samsung,s3c2410-rtc" - for controllers compatible with s3c2410 rtc.
+    * "samsung,s3c2416-rtc" - for controllers compatible with s3c2416 rtc.
+    * "samsung,s3c2443-rtc" - for controllers compatible with s3c2443 rtc.
     * "samsung,s3c6410-rtc" - for controllers compatible with s3c6410 rtc.
 - reg: physical base address of the controller and length of memory mapped
   region.
diff -puN drivers/rtc/rtc-s3c.c~rtc-s3c-remove-warning-message-when-checking-coding-style-with-checkpatch-script drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-s3c-remove-warning-message-when-checking-coding-style-with-checkpatch-script
+++ a/drivers/rtc/rtc-s3c.c
@@ -382,33 +382,33 @@ static const struct rtc_class_ops s3c_rt
 
 static void s3c_rtc_enable(struct s3c_rtc *info, int en)
 {
-	unsigned int tmp;
+	unsigned int con, tmp;
 
 	clk_enable(info->rtc_clk);
+
+	con = readw(info->base + S3C2410_RTCCON);
 	if (!en) {
-		tmp = readw(info->base + S3C2410_RTCCON);
 		if (info->cpu_type == TYPE_S3C64XX)
-			tmp &= ~S3C64XX_RTCCON_TICEN;
-		tmp &= ~S3C2410_RTCCON_RTCEN;
-		writew(tmp, info->base + S3C2410_RTCCON);
+			con &= ~S3C64XX_RTCCON_TICEN;
+		con &= ~S3C2410_RTCCON_RTCEN;
+		writew(con, info->base + S3C2410_RTCCON);
 
 		if (info->cpu_type != TYPE_S3C64XX) {
-			tmp = readb(info->base + S3C2410_TICNT);
-			tmp &= ~S3C2410_TICNT_ENABLE;
-			writeb(tmp, info->base + S3C2410_TICNT);
+			con = readb(info->base + S3C2410_TICNT);
+			con &= ~S3C2410_TICNT_ENABLE;
+			writeb(con, info->base + S3C2410_TICNT);
 		}
 	} else {
 		/* re-enable the device, and check it is ok */
 
-		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_RTCEN) == 0) {
-			dev_info(info->dev, "rtc disabled, re-enabling\n");
+		if ((con & S3C2410_RTCCON_RTCEN) == 0) {
 
 			tmp = readw(info->base + S3C2410_RTCCON);
 			writew(tmp | S3C2410_RTCCON_RTCEN,
 				info->base + S3C2410_RTCCON);
 		}
 
-		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_CNTSEL)) {
+		if (con & S3C2410_RTCCON_CNTSEL) {
 			dev_info(info->dev, "removing RTCCON_CNTSEL\n");
 
 			tmp = readw(info->base + S3C2410_RTCCON);
@@ -416,7 +416,7 @@ static void s3c_rtc_enable(struct s3c_rt
 				info->base + S3C2410_RTCCON);
 		}
 
-		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_CLKRST)) {
+		if (con & S3C2410_RTCCON_CLKRST) {
 			dev_info(info->dev, "removing RTCCON_CLKRST\n");
 
 			tmp = readw(info->base + S3C2410_RTCCON);
@@ -445,8 +445,10 @@ static inline int s3c_rtc_get_driver_dat
 {
 #ifdef CONFIG_OF
 	struct s3c_rtc_drv_data *data;
+
 	if (pdev->dev.of_node) {
 		const struct of_device_id *match;
+
 		match = of_match_node(s3c_rtc_dt_match, pdev->dev.of_node);
 		data = (struct s3c_rtc_drv_data *) match->data;
 		return data->cpu_type;
_

Patches currently in -mm which might be from cw00.choi@samsung.com are

rtc-s3c-define-s3c_rtc-structure-to-remove-global-variables.patch
rtc-s3c-add-s3c_rtc_data-structure-to-use-variant-data-instead-of-s3c_cpu_type.patch
rtc-s3c-add-support-for-rtc-of-exynos3250-soc.patch
arm-dts-fix-wrong-compatible-string-of-exynos3250-rtc-dt-node.patch
linux-next.patch

