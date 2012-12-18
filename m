From: akpm@linux-foundation.org
Subject: [merged] backlight-add-of_find_backlight_by_node-function.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:05:33 -0800
Message-ID: <20121218200533.CAE72820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:46181 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUFe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:05:34 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so125758yen.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:05:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thierry.reding@avionic-design.de, grant.likely@secretlab.ca, jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: add of_find_backlight_by_node()
has been removed from the -mm tree.  Its filename was
     backlight-add-of_find_backlight_by_node-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thierry Reding <thierry.reding@avionic-design.de>
Subject: backlight: add of_find_backlight_by_node()

This function finds the struct backlight_device for a given device tree
node.  A dummy function is provided so that it safely compiles out if OF
support is disabled.

[akpm@linux-foundation.org: Don't use IS_ENABLED(CONFIG_OF)]
Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Reviewed-by: Grant Likely <grant.likely@secretlab.ca>

Cc: Thierry Reding <thierry.reding@avionic-design.de>
Reviewed-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |   29 ++++++++++++++++++++++++++
 include/linux/backlight.h           |   10 ++++++++
 2 files changed, 39 insertions(+)

diff -puN drivers/video/backlight/backlight.c~backlight-add-of_find_backlight_by_node-function drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-add-of_find_backlight_by_node-function
+++ a/drivers/video/backlight/backlight.c
@@ -370,6 +370,35 @@ void backlight_device_unregister(struct 
 }
 EXPORT_SYMBOL(backlight_device_unregister);
 
+#ifdef CONFIG_OF
+static int of_parent_match(struct device *dev, void *data)
+{
+	return dev->parent && dev->parent->of_node == data;
+}
+
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
 
+#ifdef CONFIG_OF
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

