From: akpm@linux-foundation.org
Subject: [merged] cciss-make-device-attrs-static.patch removed from -mm tree
Date: Mon, 16 Nov 2009 11:04:25 -0800
Message-ID: <200911161904.nAGJ4PwH015416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753514AbZKPTEe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 14:04:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: achiang@hp.com, jens.axboe@oracle.com, mike.miller@hp.com, scameron@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: make device attrs static
has been removed from the -mm tree.  Its filename was
     cciss-make-device-attrs-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: make device attrs static
From: Alex Chiang <achiang@hp.com>

No need to export those device attributes.

In fact, without this patch, we can trip over a build error if cciss
is a built-in and another driver also declares and exports attributes
with the same name.

You'll see errors like:

	drivers/scsi/built-in.o: multiple definition of `dev_attr_lunid'
	drivers/block/built-in.o: first defined here

Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/block/cciss.c~cciss-make-device-attrs-static drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-make-device-attrs-static
+++ a/drivers/block/cciss.c
@@ -482,7 +482,7 @@ static ssize_t host_store_rescan(struct 
 
 	return count;
 }
-DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
+static DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
 
 static ssize_t dev_show_unique_id(struct device *dev,
 				 struct device_attribute *attr,
@@ -512,7 +512,7 @@ static ssize_t dev_show_unique_id(struct
 				sn[8], sn[9], sn[10], sn[11],
 				sn[12], sn[13], sn[14], sn[15]);
 }
-DEVICE_ATTR(unique_id, S_IRUGO, dev_show_unique_id, NULL);
+static DEVICE_ATTR(unique_id, S_IRUGO, dev_show_unique_id, NULL);
 
 static ssize_t dev_show_vendor(struct device *dev,
 			       struct device_attribute *attr,
@@ -536,7 +536,7 @@ static ssize_t dev_show_vendor(struct de
 	else
 		return snprintf(buf, sizeof(vendor) + 1, "%s\n", drv->vendor);
 }
-DEVICE_ATTR(vendor, S_IRUGO, dev_show_vendor, NULL);
+static DEVICE_ATTR(vendor, S_IRUGO, dev_show_vendor, NULL);
 
 static ssize_t dev_show_model(struct device *dev,
 			      struct device_attribute *attr,
@@ -560,7 +560,7 @@ static ssize_t dev_show_model(struct dev
 	else
 		return snprintf(buf, sizeof(model) + 1, "%s\n", drv->model);
 }
-DEVICE_ATTR(model, S_IRUGO, dev_show_model, NULL);
+static DEVICE_ATTR(model, S_IRUGO, dev_show_model, NULL);
 
 static ssize_t dev_show_rev(struct device *dev,
 			    struct device_attribute *attr,
@@ -584,7 +584,7 @@ static ssize_t dev_show_rev(struct devic
 	else
 		return snprintf(buf, sizeof(rev) + 1, "%s\n", drv->rev);
 }
-DEVICE_ATTR(rev, S_IRUGO, dev_show_rev, NULL);
+static DEVICE_ATTR(rev, S_IRUGO, dev_show_rev, NULL);
 
 static ssize_t cciss_show_lunid(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -609,7 +609,7 @@ static ssize_t cciss_show_lunid(struct d
 		lunid[0], lunid[1], lunid[2], lunid[3],
 		lunid[4], lunid[5], lunid[6], lunid[7]);
 }
-DEVICE_ATTR(lunid, S_IRUGO, cciss_show_lunid, NULL);
+static DEVICE_ATTR(lunid, S_IRUGO, cciss_show_lunid, NULL);
 
 static ssize_t cciss_show_raid_level(struct device *dev,
 				     struct device_attribute *attr, char *buf)
@@ -632,7 +632,7 @@ static ssize_t cciss_show_raid_level(str
 	return snprintf(buf, strlen(raid_label[raid]) + 7, "RAID %s\n",
 			raid_label[raid]);
 }
-DEVICE_ATTR(raid_level, S_IRUGO, cciss_show_raid_level, NULL);
+static DEVICE_ATTR(raid_level, S_IRUGO, cciss_show_raid_level, NULL);
 
 static ssize_t cciss_show_usage_count(struct device *dev,
 				      struct device_attribute *attr, char *buf)
@@ -651,7 +651,7 @@ static ssize_t cciss_show_usage_count(st
 	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 	return snprintf(buf, 20, "%d\n", count);
 }
-DEVICE_ATTR(usage_count, S_IRUGO, cciss_show_usage_count, NULL);
+static DEVICE_ATTR(usage_count, S_IRUGO, cciss_show_usage_count, NULL);
 
 static struct attribute *cciss_host_attrs[] = {
 	&dev_attr_rescan.attr,
_

Patches currently in -mm which might be from achiang@hp.com are

linux-next.patch
hpsa-make-device-attrs-static.patch
page-types-learn-to-describe-flags-directly-from-command-line.patch
page-types-whitespace-alignment.patch
page-types-exit-early-when-invoked-with-d-describe.patch
mm-add-numa-node-symlink-for-memory-section-in-sysfs.patch
mm-refactor-register_cpu_under_node.patch
mm-refactor-unregister_cpu_under_node.patch
mm-add-numa-node-symlink-for-cpu-devices-in-sysfs.patch
documentation-abi-sys-devices-system-cpu-cpu-node.patch

