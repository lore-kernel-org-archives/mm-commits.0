From: akpm@linux-foundation.org
Subject: [merged] backlight-adp8870-use-kstrtoul.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:37 -0700
Message-ID: <20120531191837.58F44A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:56583 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043Ab2EaTSi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:38 -0400
Received: by mail-ee0-f74.google.com with SMTP id t10so76371eei.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, michael.hennerich@analog.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/adp8870_bl.c: use kstrtoul()
has been removed from the -mm tree.  Its filename was
     backlight-adp8870-use-kstrtoul.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/adp8870_bl.c: use kstrtoul()

The usage of strict_strtoul() is not preferred. Thus, kstrtoul
should be used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8870_bl.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/adp8870_bl.c~backlight-adp8870-use-kstrtoul drivers/video/backlight/adp8870_bl.c
--- a/drivers/video/backlight/adp8870_bl.c~backlight-adp8870-use-kstrtoul
+++ a/drivers/video/backlight/adp8870_bl.c
@@ -572,7 +572,7 @@ static ssize_t adp8870_store(struct devi
 	unsigned long val;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtoul(buf, 10, &val);
 	if (ret)
 		return ret;
 
@@ -652,7 +652,7 @@ static ssize_t adp8870_bl_l1_daylight_ma
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct adp8870_bl *data = dev_get_drvdata(dev);
-	int ret = strict_strtoul(buf, 10, &data->cached_daylight_max);
+	int ret = kstrtoul(buf, 10, &data->cached_daylight_max);
 	if (ret)
 		return ret;
 
@@ -794,7 +794,7 @@ static ssize_t adp8870_bl_ambient_light_
 	uint8_t reg_val;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtoul(buf, 10, &val);
 	if (ret)
 		return ret;
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

