From: akpm@linux-foundation.org
Subject: [merged] hwmon-convert-idr-to-ida-and-use-ida_simple-interface.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:12:49 -0700
Message-ID: <201111012112.pA1LCnlV005868@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16173 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVNZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:13:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jic23@cam.ac.uk, James.Bottomley@HansenPartnership.com, airlied@linux.ie, djwong@us.ibm.com, guenter.roeck@ericsson.com, rusty@rustcorp.com.au, thellstrom@vmware.com, tj@kernel.org, z


The patch titled
     Subject: hwmon: convert idr to ida and use ida_simple interface
has been removed from the -mm tree.  Its filename was
     hwmon-convert-idr-to-ida-and-use-ida_simple-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jonathan Cameron <jic23@cam.ac.uk>
Subject: hwmon: convert idr to ida and use ida_simple interface

hwmon was using an idr with a NULL pointer, so convert to an
ida which then allows use of Rusty's ida_simple_get.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
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
linux-next.patch
drivers-scsi-sdc-use-ida_simple_get-and-ida_simple_remove-in-place-of-boilerplate-code.patch
drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id.patch
drivers-rtc-classc-convert-idr-to-ida-and-use-ida_simple_get.patch
w1-ds2760-and-ds2780-use-ida-for-id-and-ida_simple_get-to-get-it.patch

