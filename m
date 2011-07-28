From: akpm@linux-foundation.org
Subject: + drivers-rtc-classc-convert-idr-to-ida-and-use-ida_simple_get.patch added to -mm tree
Date: Thu, 28 Jul 2011 15:48:56 -0700
Message-ID: <201107282248.p6SMmuqn013060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755102Ab1G1WtO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 18:49:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jic23@cam.ac.uk, a.zummo@towertech.it


The patch titled
     drivers/rtc/class.c: convert idr to ida and use ida_simple_get()
has been added to the -mm tree.  Its filename is
     drivers-rtc-classc-convert-idr-to-ida-and-use-ida_simple_get.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/class.c: convert idr to ida and use ida_simple_get()
From: Jonathan Cameron <jic23@cam.ac.uk>

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
ida-simplified-functions-for-id-allocation.patch
hwmon-convert-idr-to-ida-and-use-ida_simple-interface.patch
drivers-hwmon-hwmonc-convert-idr-to-ida-and-use-ida_simple_get.patch
drivers-scsi-sdc-use-ida_simple_get-and-ida_simple_remove-in-place-of-boilerplate-code.patch
drm-vmwgfx-use-ida_simple_get-for-id-allocation.patch
drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id.patch
w1-ds2760-and-ds2780-use-ida-for-id-and-ida_simple_get-to-get-it.patch
drivers-rtc-classc-convert-idr-to-ida-and-use-ida_simple_get.patch
linux-next.patch

