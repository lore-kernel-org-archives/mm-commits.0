From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-classc-convert-idr-to-ida-and-use-ida_simple_get.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:26:02 -0800
Message-ID: <201111072026.pA7KQ2Qa027588@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5201 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab1KGU0d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:26:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jic23@cam.ac.uk, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/class.c: convert idr to ida and use ida_simple_get()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-classc-convert-idr-to-ida-and-use-ida_simple_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jonathan Cameron <jic23@cam.ac.uk>
Subject: drivers/rtc/class.c: convert idr to ida and use ida_simple_get()

This is the one use of an ida that doesn't retry on receiving -EAGAIN.
I'm assuming do so will cause no harm and may help on a rare occasion.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |   32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff -puN drivers/rtc/class.c~drivers-rtc-classc-convert-idr-to-ida-and-use-ida_simple_get drivers/rtc/class.c
--- a/drivers/rtc/class.c~drivers-rtc-classc-convert-idr-to-ida-and-use-ida_simple_get
+++ a/drivers/rtc/class.c
@@ -21,16 +21,13 @@
 #include "rtc-core.h"
 
 
-static DEFINE_IDR(rtc_idr);
-static DEFINE_MUTEX(idr_lock);
+static DEFINE_IDA(rtc_ida);
 struct class *rtc_class;
 
 static void rtc_device_release(struct device *dev)
 {
 	struct rtc_device *rtc = to_rtc_device(dev);
-	mutex_lock(&idr_lock);
-	idr_remove(&rtc_idr, rtc->id);
-	mutex_unlock(&idr_lock);
+	ida_simple_remove(&rtc_ida, rtc->id);
 	kfree(rtc);
 }
 
@@ -146,25 +143,16 @@ struct rtc_device *rtc_device_register(c
 	struct rtc_wkalrm alrm;
 	int id, err;
 
-	if (idr_pre_get(&rtc_idr, GFP_KERNEL) == 0) {
-		err = -ENOMEM;
+	id = ida_simple_get(&rtc_ida, 0, 0, GFP_KERNEL);
+	if (id < 0) {
+		err = id;
 		goto exit;
 	}
 
-
-	mutex_lock(&idr_lock);
-	err = idr_get_new(&rtc_idr, NULL, &id);
-	mutex_unlock(&idr_lock);
-
-	if (err < 0)
-		goto exit;
-
-	id = id & MAX_ID_MASK;
-
 	rtc = kzalloc(sizeof(struct rtc_device), GFP_KERNEL);
 	if (rtc == NULL) {
 		err = -ENOMEM;
-		goto exit_idr;
+		goto exit_ida;
 	}
 
 	rtc->id = id;
@@ -222,10 +210,8 @@ struct rtc_device *rtc_device_register(c
 exit_kfree:
 	kfree(rtc);
 
-exit_idr:
-	mutex_lock(&idr_lock);
-	idr_remove(&rtc_idr, id);
-	mutex_unlock(&idr_lock);
+exit_ida:
+	ida_simple_remove(&rtc_ida, id);
 
 exit:
 	dev_err(dev, "rtc core: unable to register %s, err = %d\n",
@@ -276,7 +262,7 @@ static void __exit rtc_exit(void)
 {
 	rtc_dev_exit();
 	class_destroy(rtc_class);
-	idr_destroy(&rtc_idr);
+	ida_destroy(&rtc_ida);
 }
 
 subsys_initcall(rtc_init);
_

Patches currently in -mm which might be from jic23@cam.ac.uk are

origin.patch
drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id.patch

