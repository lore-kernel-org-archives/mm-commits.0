From: akpm@linux-foundation.org
Subject: + backlight-catch-invalid-input.patch added to -mm tree
Date: Mon, 24 Nov 2008 14:17:46 -0800
Message-ID: <200811242217.mAOMHk8f020099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752305AbYKXWR6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 17:17:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, rpurdie@rpsys.net


The patch titled
     backlight: catch invalid input
has been added to the -mm tree.  Its filename is
     backlight-catch-invalid-input.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: catch invalid input
From: Pavel Machek <pavel@suse.cz>

Check input properly in backlight, echo > brightness should not turn off
the backlight.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |   32 ++++++++++++--------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff -puN drivers/video/backlight/backlight.c~backlight-catch-invalid-input drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-catch-invalid-input
+++ a/drivers/video/backlight/backlight.c
@@ -80,19 +80,18 @@ static ssize_t backlight_show_power(stru
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
+		pr_debug("backlight: set power to %lu\n", power);
 		pr_debug("backlight: set power to %d\n", power);
 		if (bd->props.power != power) {
 			bd->props.power = power;
@@ -116,23 +115,22 @@ static ssize_t backlight_show_brightness
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
+ 	rc = strict_strtoul(buf, 0, &brightness);
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
backlight-catch-invalid-input.patch
lis3lv02d-separate-the-core-from-hp-acpi-api.patch
lis3lv02d-merge-with-leds-hp-disk.patch

