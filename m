From: akpm@linux-foundation.org
Subject: [merged] rtc-use-struct-device-as-the-first-argument-for-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:23 -0700
Message-ID: <20130430185423.808C05A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:45071 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab3D3SyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:25 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so77177veb.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, a.zummo@towertech.it, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/class.c: use struct device as the first argument for devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-use-struct-device-as-the-first-argument-for-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/class.c: use struct device as the first argument for devm_rtc_device_register()

Other devm_* APIs use 'struct device *dev' as the first argument.  Thus,
in order to sync with other devm_* functions, struct device is used as the
first argument for devm_rtc_device_register().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |    6 +++---
 include/linux/rtc.h |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/class.c~rtc-use-struct-device-as-the-first-argument-for-devm_rtc_device_register drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-use-struct-device-as-the-first-argument-for-devm_rtc_device_register
+++ a/drivers/rtc/class.c
@@ -275,8 +275,8 @@ static int devm_rtc_device_match(struct
 
 /**
  * devm_rtc_device_register - resource managed rtc_device_register()
- * @name: the name of the device
  * @dev: the device to register
+ * @name: the name of the device
  * @ops: the rtc operations structure
  * @owner: the module owner
  *
@@ -287,8 +287,8 @@ static int devm_rtc_device_match(struct
  * for more information.
  */
 
-struct rtc_device *devm_rtc_device_register(const char *name,
-					struct device *dev,
+struct rtc_device *devm_rtc_device_register(struct device *dev,
+					const char *name,
 					const struct rtc_class_ops *ops,
 					struct module *owner)
 {
diff -puN include/linux/rtc.h~rtc-use-struct-device-as-the-first-argument-for-devm_rtc_device_register include/linux/rtc.h
--- a/include/linux/rtc.h~rtc-use-struct-device-as-the-first-argument-for-devm_rtc_device_register
+++ a/include/linux/rtc.h
@@ -133,8 +133,8 @@ extern struct rtc_device *rtc_device_reg
 					struct device *dev,
 					const struct rtc_class_ops *ops,
 					struct module *owner);
-extern struct rtc_device *devm_rtc_device_register(const char *name,
-					struct device *dev,
+extern struct rtc_device *devm_rtc_device_register(struct device *dev,
+					const char *name,
 					const struct rtc_class_ops *ops,
 					struct module *owner);
 extern void rtc_device_unregister(struct rtc_device *rtc);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

