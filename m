From: akpm@linux-foundation.org
Subject: + rtc_cmos-oops-fix.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:32:57 -0800
Message-ID: <200702272033.l1RKX1Hr027487@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50625 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbXB0UdW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:33:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net


The patch titled
     rtc_cmos oops fix
has been added to the -mm tree.  Its filename is
     rtc_cmos-oops-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

rtc_cmos-oops-fix.patch
git-avr32.patch
git-md-accel.patch
8250-make-probing-for-txen-bug-a-config-option.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
