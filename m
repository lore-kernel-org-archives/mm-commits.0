From: akpm@linux-foundation.org
Subject: [wrecked] drivers-scsi-sdc-use-ida_simple_get-and-ida_simple_remove-in-place-of-boilerplate-code.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:38:36 -0700
Message-ID: <201111012219.pA1MJCDS006846@hpaq12.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:39537 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab1KAWTi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 18:19:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jic23@cam.ac.uk, James.Bottomley@HansenPartnership.com, guenter.roeck@ericsson.com, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/sd.c: use ida_simple_get() and ida_simple_remove() in place of boilerplate code
has been removed from the -mm tree.  Its filename was
     drivers-scsi-sdc-use-ida_simple_get-and-ida_simple_remove-in-place-of-boilerplate-code.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jonathan Cameron <jic23@cam.ac.uk>
Subject: drivers/scsi/sd.c: use ida_simple_get() and ida_simple_remove() in place of boilerplate code

Some mangling of errors was necessary to maintain current interface.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c |   28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff -puN drivers/scsi/sd.c~drivers-scsi-sdc-use-ida_simple_get-and-ida_simple_remove-in-place-of-boilerplate-code drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~drivers-scsi-sdc-use-ida_simple_get-and-ida_simple_remove-in-place-of-boilerplate-code
+++ a/drivers/scsi/sd.c
@@ -111,7 +111,6 @@ static void scsi_disk_release(struct dev
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
 static void sd_print_result(struct scsi_disk *, int);
 
-static DEFINE_SPINLOCK(sd_index_lock);
 static DEFINE_IDA(sd_index_ida);
 
 /* This semaphore is used to mediate the 0->1 reference get in the
@@ -2581,17 +2580,14 @@ static int sd_probe(struct device *dev)
 	if (!gd)
 		goto out_free;
 
-	do {
-		if (!ida_pre_get(&sd_index_ida, GFP_KERNEL))
-			goto out_put;
-
-		spin_lock(&sd_index_lock);
-		error = ida_get_new(&sd_index_ida, &index);
-		spin_unlock(&sd_index_lock);
-	} while (error == -EAGAIN);
-
-	if (error) {
-		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
+	index = ida_simple_get(&sd_index_ida, 0, SD_MAX_DISKS, GFP_KERNEL);
+	if (index < 0) {
+		error = index;
+		if (error == -ENOSPC) {
+			sdev_printk(KERN_WARNING, sdp,
+				    "SCSI disk (sd) name space exhausted.\n");
+			error = -ENODEV;
+		}
 		goto out_put;
 	}
 
@@ -2632,9 +2628,7 @@ static int sd_probe(struct device *dev)
 	return 0;
 
  out_free_index:
-	spin_lock(&sd_index_lock);
-	ida_remove(&sd_index_ida, index);
-	spin_unlock(&sd_index_lock);
+	ida_simple_remove(&sd_index_ida, index);
  out_put:
 	put_disk(gd);
  out_free:
@@ -2690,9 +2684,7 @@ static void scsi_disk_release(struct dev
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct gendisk *disk = sdkp->disk;
 	
-	spin_lock(&sd_index_lock);
-	ida_remove(&sd_index_ida, sdkp->index);
-	spin_unlock(&sd_index_lock);
+	ida_simple_remove(&sd_index_ida, sdkp->index);
 
 	disk->private_data = NULL;
 	put_disk(disk);
_

Patches currently in -mm which might be from jic23@cam.ac.uk are

origin.patch
linux-next.patch
drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id.patch
drivers-rtc-classc-convert-idr-to-ida-and-use-ida_simple_get.patch
w1-ds2760-and-ds2780-use-ida-for-id-and-ida_simple_get-to-get-it.patch

