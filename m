From: akpm@linux-foundation.org
Subject: - backlight-catch-invalid-input.patch removed from -mm tree
Date: Mon, 08 Dec 2008 15:24:27 -0800
Message-ID: <200812082324.mB8NOR9p006978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753593AbYLHXZR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 18:25:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@suse.cz, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     backlight: catch invalid input
has been removed from the -mm tree.  Its filename was
     backlight-catch-invalid-input.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: catch invalid input
From: Pavel Machek <pavel@suse.cz>

Check input properly in backlight, echo > brightness should not turn off
the backlight.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: fix printk warning]
Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |   33 +++++++++++---------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff -puN drivers/video/backlight/backlight.c~backlight-catch-invalid-input drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-catch-invalid-input
+++ a/drivers/video/backlight/backlight.c
@@ -80,20 +80,18 @@ static ssize_t backlight_show_power(stru
 static ssize_t backlight_store_power(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	int rc = -ENXIO;
-	char *endp;
+	int rc;
 	struct backlight_device *bd = to_backlight_device(dev);
-	int power = simple_strtoul(buf, &endp, 0);
-	size_t size = endp - buf;
+	unsigned long power;
 
-	if (*endp && isspace(*endp))
-		size++;
-	if (size != count)
-		return -EINVAL;
+	rc = strict_strtoul(buf, 0, &power);
+	if (rc)
+		return rc;
 
+	rc = -ENXIO;
 	mutex_lock(&bd->ops_lock);
 	if (bd->ops) {
-		pr_debug("backlight: set power to %d\n", power);
+		pr_debug("backlight: set power to %lu\n", power);
 		if (bd->props.power != power) {
 			bd->props.power = power;
 			backlight_update_status(bd);
@@ -116,23 +114,22 @@ static ssize_t backlight_show_brightness
 static ssize_t backlight_store_brightness(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	int rc = -ENXIO;
-	char *endp;
+	int rc;
 	struct backlight_device *bd = to_backlight_device(dev);
-	int brightness = simple_strtoul(buf, &endp, 0);
-	size_t size = endp - buf;
+	unsigned long brightness;
+
+	rc = strict_strtoul(buf, 0, &brightness);
+	if (rc)
+		return rc;
 
-	if (*endp && isspace(*endp))
-		size++;
-	if (size != count)
-		return -EINVAL;
+	rc = -ENXIO;
 
 	mutex_lock(&bd->ops_lock);
 	if (bd->ops) {
 		if (brightness > bd->props.max_brightness)
 			rc = -EINVAL;
 		else {
-			pr_debug("backlight: set brightness to %d\n",
+			pr_debug("backlight: set brightness to %lu\n",
 				 brightness);
 			if (bd->props.brightness != brightness) {
 				bd->props.brightness = brightness;
_

Patches currently in -mm which might be from pavel@suse.cz are

linux-next.patch
strict_strto-is-not-strict-enough.patch
lis3lv02d-separate-the-core-from-hp-acpi-api.patch
lis3lv02d-merge-with-leds-hp-disk.patch

