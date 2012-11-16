From: akpm@linux-foundation.org
Subject: + backlight-add-of_find_backlight_by_node-function.patch added to -mm tree
Date: Fri, 16 Nov 2012 13:16:55 -0800
Message-ID: <20121116211656.C43A220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:63089 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab2KPVQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Nov 2012 16:16:59 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so205327eei.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Nov 2012 13:16:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thierry.reding@avionic-design.de, jg1.han@samsung.com


The patch titled
     Subject: backlight: add of_find_backlight_by_node()
has been added to the -mm tree.  Its filename is
     backlight-add-of_find_backlight_by_node-function.patch

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
Subject: backlight: add of_find_backlight_by_node()

This function finds the struct backlight_device for a given device tree
node.  A dummy function is provided so that it safely compiles out if OF
support is disabled.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |   17 +++++++++++++++++
 include/linux/backlight.h           |   10 ++++++++++
 2 files changed, 27 insertions(+)

diff -puN drivers/video/backlight/backlight.c~backlight-add-of_find_backlight_by_node-function drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-add-of_find_backlight_by_node-function
+++ a/drivers/video/backlight/backlight.c
@@ -370,6 +370,23 @@ void backlight_device_unregister(struct 
 }
 EXPORT_SYMBOL(backlight_device_unregister);
 
+#if IS_ENABLED(CONFIG_OF)
+static int of_parent_match(struct device *dev, void *data)
+{
+	return dev->parent && dev->parent->of_node == data;
+}
+
+struct backlight_device *of_find_backlight_by_node(struct device_node *node)
+{
+	struct device *dev;
+
+	dev = class_find_device(backlight_class, NULL, node, of_parent_match);
+
+	return dev ? to_backlight_device(dev) : NULL;
+}
+EXPORT_SYMBOL(of_find_backlight_by_node);
+#endif
+
 static void __exit backlight_class_exit(void)
 {
 	class_destroy(backlight_class);
diff -puN include/linux/backlight.h~backlight-add-of_find_backlight_by_node-function include/linux/backlight.h
--- a/include/linux/backlight.h~backlight-add-of_find_backlight_by_node-function
+++ a/include/linux/backlight.h
@@ -134,4 +134,14 @@ struct generic_bl_info {
 	void (*kick_battery)(void);
 };
 
+#if IS_ENABLED(CONFIG_OF)
+struct backlight_device *of_find_backlight_by_node(struct device_node *node);
+#else
+static inline struct backlight_device *
+of_find_backlight_by_node(struct device_node *node)
+{
+	return NULL;
+}
+#endif
+
 #endif
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

