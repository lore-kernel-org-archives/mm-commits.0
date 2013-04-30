From: akpm@linux-foundation.org
Subject: [merged] backlight-lp855x-use-page_size-for-the-sysfs-read-operation.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:52:26 -0700
Message-ID: <20130430185226.7584D5A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:35630 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab3D3Sw1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:52:27 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so86361ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:52:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, jg1.han@samsung.com, milo.kim@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/lp855x_bl.c: use PAGE_SIZE for the sysfs read operation
has been removed from the -mm tree.  Its filename was
     backlight-lp855x-use-page_size-for-the-sysfs-read-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: drivers/video/backlight/lp855x_bl.c: use PAGE_SIZE for the sysfs read operation

sysfs allocates PAGE_SIZE.  It is used by each R/W operation method.  Use
it instead of another buffer size.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/lp855x_bl.c~backlight-lp855x-use-page_size-for-the-sysfs-read-operation drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-lp855x-use-page_size-for-the-sysfs-read-operation
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -35,7 +35,6 @@
 #define LP8557_EPROM_START		0x10
 #define LP8557_EPROM_END		0x1E
 
-#define BUF_SIZE		20
 #define DEFAULT_BL_NAME		"lcd-backlight"
 #define MAX_BRIGHTNESS		255
 
@@ -304,7 +303,7 @@ static ssize_t lp855x_get_chip_id(struct
 				struct device_attribute *attr, char *buf)
 {
 	struct lp855x *lp = dev_get_drvdata(dev);
-	return scnprintf(buf, BUF_SIZE, "%s\n", lp->chipname);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", lp->chipname);
 }
 
 static ssize_t lp855x_get_bl_ctl_mode(struct device *dev,
@@ -319,7 +318,7 @@ static ssize_t lp855x_get_bl_ctl_mode(st
 	else if (mode == REGISTER_BASED)
 		strmode = "register based";
 
-	return scnprintf(buf, BUF_SIZE, "%s\n", strmode);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", strmode);
 }
 
 static DEVICE_ATTR(chip_id, S_IRUGO, lp855x_get_chip_id, NULL);
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

origin.patch
linux-next.patch

