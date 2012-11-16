From: akpm@linux-foundation.org
Subject: + backlight-add-of_find_backlight_by_node-function-fix-2.patch added to -mm tree
Date: Fri, 16 Nov 2012 14:39:12 -0800
Message-ID: <20121116223913.4A83F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:62404 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab2KPWjP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Nov 2012 17:39:15 -0500
Received: by mail-fa0-f74.google.com with SMTP id w1so206747fad.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Nov 2012 14:39:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thierry.reding@avionic-design.de, grant.likely@secretlab.ca, jg1.han@samsung.com


The patch titled
     Subject: backlight-add-of_find_backlight_by_node-function-fix-2
has been added to the -mm tree.  Its filename is
     backlight-add-of_find_backlight_by_node-function-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
linux-next.patch
mm-compaction-fix-compiler-warning.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-video-backlight-lp855x_blc-remove-unnecessary-mutex-code.patch
backlight-add-of_find_backlight_by_node-function.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-add-of_find_backlight_by_node-function-fix-2.patch

