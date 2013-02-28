From: akpm@linux-foundation.org
Subject: + rtc-add-devm_rtc_device_registerunregister.patch added to -mm tree
Date: Thu, 28 Feb 2013 15:50:47 -0800
Message-ID: <20130228235047.9C7F831C211@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:57518 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3B1Xus (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 18:50:48 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so273032ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 15:50:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, tj@kernel.org


The patch titled
     Subject: rtc: add devm_rtc_device_{register,unregister}()
has been added to the -mm tree.  Its filename is
     rtc-add-devm_rtc_device_registerunregister.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops-fix.patch
backlight-platform_lcd-remove-unnecessary-ifdefs.patch
rtc-rtc-mv-add-__init-annotation.patch
rtc-rtc-davinci-add-__exit-annotation.patch
rtc-rtc-ds1302-add-__exit-annotation.patch
rtc-rtc-imxdi-add-__init-__exit-annotation.patch
rtc-rtc-nuc900-add-__init-__exit-annotation.patch
rtc-rtc-pcap-add-__init-__exit-annotation.patch
rtc-rtc-tegra-add-__init-__exit-annotation.patch
rtc-add-devm_rtc_device_registerunregister.patch
rtc-max77686-use-module_platform_driver.patch
rtc-max77686-add-missing-module-author-name.patch
rtc-max77686-use-devm_kzalloc.patch
rtc-max77686-fix-indentation-of-bit-definitions.patch
rtc-max77686-use-dev_info-dev_emerg-instead-of-pr_info-pr_emerg.patch
rtc-rtc-v3020-use-gpio_request_array.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

