From: akpm@linux-foundation.org
Subject: [folded-merged] backlight-add-of_find_backlight_by_node-function-fix-2.patch removed from -mm tree
Date: Mon, 17 Dec 2012 15:43:19 -0800
Message-ID: <20121217234320.5E3D4200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:61355 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2LQXnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:43:23 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so214699wib.3
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:43:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thierry.reding@avionic-design.de, grant.likely@secretlab.ca, jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight-add-of_find_backlight_by_node-function-fix-2
has been removed from the -mm tree.  Its filename was
     backlight-add-of_find_backlight_by_node-function-fix-2.patch

This patch was dropped because it was folded into backlight-add-of_find_backlight_by_node-function.patch

------------------------------------------------------
From: Thierry Reding <thierry.reding@avionic-design.de>
Subject: backlight-add-of_find_backlight_by_node-function-fix-2

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Reviewed-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN drivers/video/backlight/backlight.c~backlight-add-of_find_backlight_by_node-function-fix-2 drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-add-of_find_backlight_by_node-function-fix-2
+++ a/drivers/video/backlight/backlight.c
@@ -376,6 +376,18 @@ static int of_parent_match(struct device
 	return dev->parent && dev->parent->of_node == data;
 }
 
+/**
+ * of_find_backlight_by_node() - find backlight device by device-tree node
+ * @node: device-tree node of the backlight device
+ *
+ * Returns a pointer to the backlight device corresponding to the given DT
+ * node or NULL if no such backlight device exists or if the device hasn't
+ * been probed yet.
+ *
+ * This function obtains a reference on the backlight device and it is the
+ * caller's responsibility to drop the reference by calling put_device() on
+ * the backlight device's .dev field.
+ */
 struct backlight_device *of_find_backlight_by_node(struct device_node *node)
 {
 	struct device *dev;
_

Patches currently in -mm which might be from thierry.reding@avionic-design.de are

origin.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions.patch
drivers-video-backlight-lp855x_blc-remove-unnecessary-mutex-code.patch
backlight-add-of_find_backlight_by_node-function.patch
rtc-add-nxp-pcf8523-support.patch
rtc-add-nxp-pcf8523-support-v2.patch

