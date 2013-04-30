From: akpm@linux-foundation.org
Subject: [merged] rtc-add-devm_rtc_device_registerunregister.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:09 -0700
Message-ID: <20130430185409.6D33F31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:33194 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163Ab3D3SyK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:10 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so87916qab.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: add devm_rtc_device_{register,unregister}()
has been removed from the -mm tree.  Its filename was
     rtc-add-devm_rtc_device_registerunregister.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: add devm_rtc_device_{register,unregister}()

These functions allow the driver core to automatically clean up any
allocation made by rtc drivers.  Thus it simplifies the error paths.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |   70 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/rtc.h |    6 +++
 2 files changed, 76 insertions(+)

diff -puN drivers/rtc/class.c~rtc-add-devm_rtc_device_registerunregister drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-add-devm_rtc_device_registerunregister
+++ a/drivers/rtc/class.c
@@ -259,6 +259,76 @@ void rtc_device_unregister(struct rtc_de
 }
 EXPORT_SYMBOL_GPL(rtc_device_unregister);
 
+static void devm_rtc_device_release(struct device *dev, void *res)
+{
+	struct rtc_device *rtc = *(struct rtc_device **)res;
+
+	rtc_device_unregister(rtc);
+}
+
+static int devm_rtc_device_match(struct device *dev, void *res, void *data)
+{
+	struct rtc **r = res;
+
+	return *r == data;
+}
+
+/**
+ * devm_rtc_device_register - resource managed rtc_device_register()
+ * @name: the name of the device
+ * @dev: the device to register
+ * @ops: the rtc operations structure
+ * @owner: the module owner
+ *
+ * @return a struct rtc on success, or an ERR_PTR on error
+ *
+ * Managed rtc_device_register(). The rtc_device returned from this function
+ * are automatically freed on driver detach. See rtc_device_register()
+ * for more information.
+ */
+
+struct rtc_device *devm_rtc_device_register(const char *name,
+					struct device *dev,
+					const struct rtc_class_ops *ops,
+					struct module *owner)
+{
+	struct rtc_device **ptr, *rtc;
+
+	ptr = devres_alloc(devm_rtc_device_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	rtc = rtc_device_register(name, dev, ops, owner);
+	if (!IS_ERR(rtc)) {
+		*ptr = rtc;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return rtc;
+}
+EXPORT_SYMBOL_GPL(devm_rtc_device_register);
+
+/**
+ * devm_rtc_device_unregister - resource managed devm_rtc_device_unregister()
+ * @dev: the device to unregister
+ * @rtc: the RTC class device to unregister
+ *
+ * Deallocated a rtc allocated with devm_rtc_device_register(). Normally this
+ * function will not need to be called and the resource management code will
+ * ensure that the resource is freed.
+ */
+void devm_rtc_device_unregister(struct device *dev, struct rtc_device *rtc)
+{
+	int rc;
+
+	rc = devres_release(dev, devm_rtc_device_release,
+				devm_rtc_device_match, rtc);
+	WARN_ON(rc);
+}
+EXPORT_SYMBOL_GPL(devm_rtc_device_unregister);
+
 static int __init rtc_init(void)
 {
 	rtc_class = class_create(THIS_MODULE, "rtc");
diff -puN include/linux/rtc.h~rtc-add-devm_rtc_device_registerunregister include/linux/rtc.h
--- a/include/linux/rtc.h~rtc-add-devm_rtc_device_registerunregister
+++ a/include/linux/rtc.h
@@ -133,7 +133,13 @@ extern struct rtc_device *rtc_device_reg
 					struct device *dev,
 					const struct rtc_class_ops *ops,
 					struct module *owner);
+extern struct rtc_device *devm_rtc_device_register(const char *name,
+					struct device *dev,
+					const struct rtc_class_ops *ops,
+					struct module *owner);
 extern void rtc_device_unregister(struct rtc_device *rtc);
+extern void devm_rtc_device_unregister(struct device *dev,
+					struct rtc_device *rtc);
 
 extern int rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm);
 extern int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

