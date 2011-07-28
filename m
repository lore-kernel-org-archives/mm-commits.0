From: akpm@linux-foundation.org
Subject: + drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id.patch added to -mm tree
Date: Thu, 28 Jul 2011 15:48:52 -0700
Message-ID: <201107282248.p6SMmqjn013054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755074Ab1G1WtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 18:49:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jic23@cam.ac.uk, James.Bottomley@HansenPartnership.com, bhalevy@panasas.com, bharrosh@panasas.com, rusty@rustcorp.com.au, tj@kernel.org


The patch titled
     drivers/scsi/osd/osd_uld.c: use ida_simple_get() to handle id
has been added to the -mm tree.  Its filename is
     drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id.patch

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
Subject: drivers/scsi/osd/osd_uld.c: use ida_simple_get() to handle id
From: Jonathan Cameron <jic23@cam.ac.uk>

This does involve additional use of the spin lock in idr.c.  Is this an
issue?

Also, some error mangling was needed to keep the interface the same.  Does
this matter or can we return -ENOSPC instead of -EBUSY?

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: Benny Halevy <bhalevy@panasas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/osd/osd_uld.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff -puN drivers/scsi/osd/osd_uld.c~drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id drivers/scsi/osd/osd_uld.c
--- a/drivers/scsi/osd/osd_uld.c~drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id
+++ a/drivers/scsi/osd/osd_uld.c
@@ -387,7 +387,7 @@ static void __remove(struct device *dev)
 
 	if (oud->disk)
 		put_disk(oud->disk);
-	ida_remove(&osd_minor_ida, oud->minor);
+	ida_simple_remove(&osd_minor_ida, oud->minor);
 
 	kfree(oud);
 }
@@ -403,18 +403,12 @@ static int osd_probe(struct device *dev)
 	if (scsi_device->type != TYPE_OSD)
 		return -ENODEV;
 
-	do {
-		if (!ida_pre_get(&osd_minor_ida, GFP_KERNEL))
-			return -ENODEV;
-
-		error = ida_get_new(&osd_minor_ida, &minor);
-	} while (error == -EAGAIN);
-
-	if (error)
-		return error;
-	if (minor >= SCSI_OSD_MAX_MINOR) {
-		error = -EBUSY;
-		goto err_retract_minor;
+	minor = ida_simple_get(&osd_minor_ida, 0,
+			       SCSI_OSD_MAX_MINOR, GFP_KERNEL);
+	if (minor < 0) {
+		if (minor == -ENOSPC)
+			return -EBUSY;
+		return minor;
 	}
 
 	error = -ENOMEM;
@@ -491,7 +485,7 @@ err_free_osd:
 	dev_set_drvdata(dev, NULL);
 	kfree(oud);
 err_retract_minor:
-	ida_remove(&osd_minor_ida, minor);
+	ida_simple_remove(&osd_minor_ida, minor);
 	return error;
 }
 
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

