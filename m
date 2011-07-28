From: akpm@linux-foundation.org
Subject: + drivers-scsi-sdc-use-ida_simple_get-and-ida_simple_remove-in-place-of-boilerplate-code.patch added to -mm tree
Date: Thu, 28 Jul 2011 15:48:48 -0700
Message-ID: <201107282248.p6SMmmo9013046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755165Ab1G1WtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 18:49:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jic23@cam.ac.uk, James.Bottomley@HansenPartnership.com, guenter.roeck@ericsson.com, rusty@rustcorp.com.au, tj@kernel.org


The patch titled
     drivers/scsi/sd.c: use ida_simple_get() and ida_simple_remove() in place of boilerplate code
has been added to the -mm tree.  Its filename is
     drivers-scsi-sdc-use-ida_simple_get-and-ida_simple_remove-in-place-of-boilerplate-code.patch

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
Subject: drivers/scsi/sd.c: use ida_simple_get() and ida_simple_remove() in place of boilerplate code
From: Jonathan Cameron <jic23@cam.ac.uk>

Some mangling of errors was necessary to maintain current interface.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c |   32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff -puN drivers/scsi/sd.c~drivers-scsi-sdc-use-ida_simple_get-and-ida_simple_remove-in-place-of-boilerplate-code drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~drivers-scsi-sdc-use-ida_simple_get-and-ida_simple_remove-in-place-of-boilerplate-code
+++ a/drivers/scsi/sd.c
@@ -111,7 +111,6 @@ static void scsi_disk_release(struct dev
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
 static void sd_print_result(struct scsi_disk *, int);
 
-static DEFINE_SPINLOCK(sd_index_lock);
 static DEFINE_IDA(sd_index_ida);
 
 /* This semaphore is used to mediate the 0->1 reference get in the
@@ -2580,22 +2579,15 @@ static int sd_probe(struct device *dev)
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
-	if (error)
+	index = ida_simple_get(&sd_index_ida, 0, SD_MAX_DISKS, GFP_KERNEL);
+	if (index < 0) {
+		error = index;
+		if (error == -ENOSPC) {
+			sdev_printk(KERN_WARNING, sdp,
+				    "SCSI disk (sd) name space exhausted.\n");
+			error = -ENODEV;
+		}
 		goto out_put;
-
-	if (index >= SD_MAX_DISKS) {
-		error = -ENODEV;
-		sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name space exhausted.\n");
-		goto out_free_index;
 	}
 
 	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
@@ -2633,9 +2625,7 @@ static int sd_probe(struct device *dev)
 	return 0;
 
  out_free_index:
-	spin_lock(&sd_index_lock);
-	ida_remove(&sd_index_ida, index);
-	spin_unlock(&sd_index_lock);
+	ida_simple_remove(&sd_index_ida, index);
  out_put:
 	put_disk(gd);
  out_free:
@@ -2691,9 +2681,7 @@ static void scsi_disk_release(struct dev
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
ida-simplified-functions-for-id-allocation.patch
hwmon-convert-idr-to-ida-and-use-ida_simple-interface.patch
drivers-hwmon-hwmonc-convert-idr-to-ida-and-use-ida_simple_get.patch
drivers-scsi-sdc-use-ida_simple_get-and-ida_simple_remove-in-place-of-boilerplate-code.patch
drm-vmwgfx-use-ida_simple_get-for-id-allocation.patch
drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id.patch
w1-ds2760-and-ds2780-use-ida-for-id-and-ida_simple_get-to-get-it.patch
drivers-rtc-classc-convert-idr-to-ida-and-use-ida_simple_get.patch
linux-next.patch

