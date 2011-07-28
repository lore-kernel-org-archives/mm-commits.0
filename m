From: akpm@linux-foundation.org
Subject: + hwmon-convert-idr-to-ida-and-use-ida_simple-interface.patch added to -mm tree
Date: Thu, 28 Jul 2011 15:48:43 -0700
Message-ID: <201107282248.p6SMmhI0013036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755074Ab1G1WtF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 18:49:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jic23@cam.ac.uk, James.Bottomley@HansenPartnership.com, airlied@linux.ie, djwong@us.ibm.com, guenter.roeck@ericsson.com, rusty@rustcorp.com.au, thellstrom@vmware.com, tj@kernel.org, zbr@ioremap.net


The patch titled
     hwmon: convert idr to ida and use ida_simple interface
has been added to the -mm tree.  Its filename is
     hwmon-convert-idr-to-ida-and-use-ida_simple-interface.patch

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
Subject: hwmon: convert idr to ida and use ida_simple interface
From: Jonathan Cameron <jic23@cam.ac.uk>

hwmon was using an idr with a NULL pointer, so convert to an
ida which then allows use of Rusty's ida_simple_get.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hwmon.c |   32 ++++++++------------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

diff -puN drivers/hwmon/hwmon.c~hwmon-convert-idr-to-ida-and-use-ida_simple-interface drivers/hwmon/hwmon.c
--- a/drivers/hwmon/hwmon.c~hwmon-convert-idr-to-ida-and-use-ida_simple-interface
+++ a/drivers/hwmon/hwmon.c
@@ -27,8 +27,7 @@
 
 static struct class *hwmon_class;
 
-static DEFINE_IDR(hwmon_idr);
-static DEFINE_SPINLOCK(idr_lock);
+static DEFINE_IDA(hwmon_ida);
 
 /**
  * hwmon_device_register - register w/ hwmon
@@ -42,30 +41,17 @@ static DEFINE_SPINLOCK(idr_lock);
 struct device *hwmon_device_register(struct device *dev)
 {
 	struct device *hwdev;
-	int id, err;
+	int id;
 
-again:
-	if (unlikely(idr_pre_get(&hwmon_idr, GFP_KERNEL) == 0))
-		return ERR_PTR(-ENOMEM);
-
-	spin_lock(&idr_lock);
-	err = idr_get_new(&hwmon_idr, NULL, &id);
-	spin_unlock(&idr_lock);
-
-	if (unlikely(err == -EAGAIN))
-		goto again;
-	else if (unlikely(err))
-		return ERR_PTR(err);
+	id = ida_simple_get(&hwmon_ida, 0, 0, GFP_KERNEL);
+	if (id < 0)
+		return ERR_PTR(id);
 
-	id = id & MAX_ID_MASK;
 	hwdev = device_create(hwmon_class, dev, MKDEV(0, 0), NULL,
 			      HWMON_ID_FORMAT, id);
 
-	if (IS_ERR(hwdev)) {
-		spin_lock(&idr_lock);
-		idr_remove(&hwmon_idr, id);
-		spin_unlock(&idr_lock);
-	}
+	if (IS_ERR(hwdev))
+		ida_simple_remove(&hwmon_ida, id);
 
 	return hwdev;
 }
@@ -81,9 +67,7 @@ void hwmon_device_unregister(struct devi
 
 	if (likely(sscanf(dev_name(dev), HWMON_ID_FORMAT, &id) == 1)) {
 		device_unregister(dev);
-		spin_lock(&idr_lock);
-		idr_remove(&hwmon_idr, id);
-		spin_unlock(&idr_lock);
+		ida_simple_remove(&hwmon_ida, id);
 	} else
 		dev_dbg(dev->parent,
 			"hwmon_device_unregister() failed: bad class ID!\n");
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

