From: akpm@linux-foundation.org
Subject: - rtc_cmos-oops-fix.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:06:34 -0800
Message-ID: <200703020506.l2256Yir000808@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42322 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422749AbXCBFGp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:06:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     rtc_cmos oops fix
has been removed from the -mm tree.  Its filename was
     rtc_cmos-oops-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc_cmos oops fix
From: David Brownell <david-b@pacbell.net>

Fix an oops on the rtc_device_unregister() path by waiting until the last
moment before nulling the rtc->ops vector.  Fix some potential oopses by
having the rtc_class_open()/rtc_class_close() interface increase the RTC's
reference count while an RTC handle is available outside the RTC framework.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c     |   14 ++++++++++----
 drivers/rtc/interface.c |    3 ++-
 2 files changed, 12 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/class.c~rtc_cmos-oops-fix drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc_cmos-oops-fix
+++ a/drivers/rtc/class.c
@@ -113,10 +113,16 @@ EXPORT_SYMBOL_GPL(rtc_device_register);
  */
 void rtc_device_unregister(struct rtc_device *rtc)
 {
-	mutex_lock(&rtc->ops_lock);
-	rtc->ops = NULL;
-	mutex_unlock(&rtc->ops_lock);
-	class_device_unregister(&rtc->class_dev);
+	if (class_device_get(&rtc->class_dev) != NULL) {
+		mutex_lock(&rtc->ops_lock);
+		/* remove innards of this RTC, then disable it, before
+		 * letting any rtc_class_open() users access it again
+		 */
+		class_device_unregister(&rtc->class_dev);
+		rtc->ops = NULL;
+		mutex_unlock(&rtc->ops_lock);
+		class_device_put(&rtc->class_dev);
+	}
 }
 EXPORT_SYMBOL_GPL(rtc_device_unregister);
 
diff -puN drivers/rtc/interface.c~rtc_cmos-oops-fix drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc_cmos-oops-fix
+++ a/drivers/rtc/interface.c
@@ -179,7 +179,7 @@ struct class_device *rtc_class_open(char
 	down(&rtc_class->sem);
 	list_for_each_entry(class_dev_tmp, &rtc_class->children, node) {
 		if (strncmp(class_dev_tmp->class_id, name, BUS_ID_SIZE) == 0) {
-			class_dev = class_dev_tmp;
+			class_dev = class_device_get(class_dev_tmp);
 			break;
 		}
 	}
@@ -197,6 +197,7 @@ EXPORT_SYMBOL_GPL(rtc_class_open);
 void rtc_class_close(struct class_device *class_dev)
 {
 	module_put(to_rtc_device(class_dev)->owner);
+	class_device_put(class_dev);
 }
 EXPORT_SYMBOL_GPL(rtc_class_close);
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
parport-is-an-orphan.patch
add-config_generic_gpio.patch
gpio_keys-driver-shouldnt-be-arm-specific.patch
git-avr32.patch
git-md-accel.patch
8250-make-probing-for-txen-bug-a-config-option.patch
blackfin-on-chip-rtc-controller-driver.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
