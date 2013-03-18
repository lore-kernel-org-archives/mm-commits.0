From: akpm@linux-foundation.org
Subject: + backlight-lp855x-use-page_size-for-the-sysfs-read-operation.patch added to -mm tree
Date: Mon, 18 Mar 2013 12:58:47 -0700
Message-ID: <20130318195847.7088B31C399@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f201.google.com ([209.85.210.201]:34870 "EHLO
	mail-ia0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3CRT6s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 15:58:48 -0400
Received: by mail-ia0-f201.google.com with SMTP id t4so1321048iag.2
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 12:58:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, jg1.han@samsung.com, milo.kim@ti.com


The patch titled
     Subject: drivers/video/backlight/lp855x_bl.c: use PAGE_SIZE for the sysfs read operation
has been added to the -mm tree.  Its filename is
     backlight-lp855x-use-page_size-for-the-sysfs-read-operation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
backlight-lp855x-use-page_size-for-the-sysfs-read-operation.patch

