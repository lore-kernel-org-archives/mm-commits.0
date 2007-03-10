From: akpm@linux-foundation.org
Subject: - resurrect-sdev.patch removed from -mm tree
Date: Sat, 10 Mar 2007 15:57:08 -0800
Message-ID: <200703102357.l2ANv8u4000554@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59621 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbXCJX5P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Mar 2007 18:57:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hare@suse.de, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     Resurrect sdev
has been removed from the -mm tree.  Its filename was
     resurrect-sdev.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: Resurrect sdev
From: Hannes Reinecke <hare@suse.de>

as discussed in San Jose here is a patch to resurrect sdevs which are
in state SDEV_CANCEL / SDEV_DEL.

I've updated sdev handling functions to be better aligned with the state
machine; we now have:

scsi_remove_device(): Same as before; transitioning into SDEV_CANCEL.
    Initiate the device removal.
scsi_destroy_device(): Transition into SDEV_DEL; just initiate
    the final device_put(). Device will be deleted properly once
    the refcount drops to zero.
scsi_configure_device(): Transistion into SDEV_RUNNING.
    If scsi_configure_device() succeeds it has to be added to
    sysfs with scsi_sysfs_add_sdev(). If it fails the sdev
    should be deleted with scsi_destroy_device().
scsi_resurrect_device(): Wrapper around scsi_configure_device.
    Transition a deleted device into SDEV_RUNNING.
    If it fails the device is in SDEV_DEL.

I've gone through the scanning mechanism and hopefully got it done properly.
I tried to ensure that after the scanning the sdevs are either in
SDEV_RUNNING or SDEV_DEL.

Patch apprears to work properly, but I haven't been running any stress tests
on it. Ie those cases which the patch is trying to solve :-)

Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_scan.c   |   65 ++++++++++++--------------
 drivers/scsi/scsi_sysfs.c  |   86 ++++++++++++++++++++++++++++-------
 include/scsi/scsi_device.h |    8 +++
 3 files changed, 109 insertions(+), 50 deletions(-)

diff -puN drivers/scsi/scsi_scan.c~resurrect-sdev drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c~resurrect-sdev
+++ a/drivers/scsi/scsi_scan.c
@@ -300,8 +300,7 @@ static struct scsi_device *scsi_alloc_sd
 	return sdev;
 
 out_device_destroy:
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_gendev);
+	scsi_destroy_device(sdev);
 out:
 	if (display_failure_msg)
 		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
@@ -714,6 +713,8 @@ static int scsi_probe_lun(struct scsi_de
 static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		int *bflags, int async)
 {
+	int ret;
+
 	/*
 	 * XXX do not save the inquiry, since it can change underneath us,
 	 * save just vendor/model/rev.
@@ -877,10 +878,6 @@ static int scsi_add_lun(struct scsi_devi
 	if (*bflags & BLIST_USE_10_BYTE_MS)
 		sdev->use_10_for_ms = 1;
 
-	/* set the device running here so that slave configure
-	 * may do I/O */
-	scsi_device_set_state(sdev, SDEV_RUNNING);
-
 	if (*bflags & BLIST_MS_192_BYTES_FOR_3F)
 		sdev->use_192_bytes_for_3f = 1;
 
@@ -890,21 +887,18 @@ static int scsi_add_lun(struct scsi_devi
 	if (*bflags & BLIST_RETRY_HWERROR)
 		sdev->retry_hwerror = 1;
 
-	transport_configure_device(&sdev->sdev_gendev);
-
-	if (sdev->host->hostt->slave_configure) {
-		int ret = sdev->host->hostt->slave_configure(sdev);
-		if (ret) {
-			/*
-			 * if LLDD reports slave not present, don't clutter
-			 * console with alloc failure messages
-			 */
-			if (ret != -ENXIO) {
-				sdev_printk(KERN_ERR, sdev,
-					"failed to configure device\n");
-			}
-			return SCSI_SCAN_NO_RESPONSE;
+	ret = scsi_configure_device(sdev);
+	if (ret) {
+		/*
+		 * if LLDD reports slave not present, don't clutter
+		 * console with alloc failure messages
+		 */
+		if (ret != -ENXIO) {
+			sdev_printk(KERN_ERR, sdev,
+				    "failed to configure device\n");
 		}
+		scsi_destroy_device(sdev);
+		return SCSI_SCAN_NO_RESPONSE;
 	}
 
 	/*
@@ -918,15 +912,6 @@ static int scsi_add_lun(struct scsi_devi
 	return SCSI_SCAN_LUN_PRESENT;
 }
 
-static inline void scsi_destroy_sdev(struct scsi_device *sdev)
-{
-	scsi_device_set_state(sdev, SDEV_DEL);
-	if (sdev->host->hostt->slave_destroy)
-		sdev->host->hostt->slave_destroy(sdev);
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_gendev);
-}
-
 #ifdef CONFIG_SCSI_LOGGING
 /** 
  * scsi_inq_str - print INQUIRY data from min to max index,
@@ -988,6 +973,10 @@ static int scsi_probe_and_add_lun(struct
 	 */
 	sdev = scsi_device_lookup_by_target(starget, lun);
 	if (sdev) {
+		if (scsi_resurrect_device(sdev)) {
+			scsi_device_put(sdev);
+			return SCSI_SCAN_NO_RESPONSE;
+		}
 		if (rescan || sdev->sdev_state != SDEV_CREATED) {
 			SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
 				"scsi scan: device exists on %s\n",
@@ -1098,11 +1087,12 @@ static int scsi_probe_and_add_lun(struct
 				*sdevp = sdev;
 			} else {
 				__scsi_remove_device(sdev);
+				scsi_destroy_device(sdev);
 				res = SCSI_SCAN_NO_RESPONSE;
 			}
 		}
 	} else
-		scsi_destroy_sdev(sdev);
+		scsi_destroy_device(sdev);
  out:
 	return res;
 }
@@ -1304,6 +1294,9 @@ static int scsi_report_lun_scan(struct s
 			return 0;
 		if (scsi_device_get(sdev))
 			return 0;
+	} else if (scsi_resurrect_device(sdev)) {
+		scsi_device_put(sdev);
+		return 0;
 	}
 
 	sprintf(devname, "host %d channel %d id %d",
@@ -1456,7 +1449,7 @@ static int scsi_report_lun_scan(struct s
 		/*
 		 * the sdev we used didn't appear in the report luns scan
 		 */
-		scsi_destroy_sdev(sdev);
+		scsi_destroy_device(sdev);
 	return ret;
 }
 
@@ -1665,8 +1658,11 @@ static void scsi_sysfs_add_devices(struc
 {
 	struct scsi_device *sdev;
 	shost_for_each_device(sdev, shost) {
-		if (scsi_sysfs_add_sdev(sdev) != 0)
-			scsi_destroy_sdev(sdev);
+		/*
+		 * scsi_sysfs_add_sdev will clean up on failure,
+		 * no need to do it here.
+		 */
+		scsi_sysfs_add_sdev(sdev);
 	}
 }
 
@@ -1813,6 +1809,7 @@ void scsi_forget_host(struct Scsi_Host *
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		__scsi_remove_device(sdev);
+		scsi_destroy_device(sdev);
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -1880,7 +1877,7 @@ void scsi_free_host_dev(struct scsi_devi
 {
 	BUG_ON(sdev->id != sdev->host->this_id);
 
-	scsi_destroy_sdev(sdev);
+	scsi_destroy_device(sdev);
 }
 EXPORT_SYMBOL(scsi_free_host_dev);
 
diff -puN drivers/scsi/scsi_sysfs.c~resurrect-sdev drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c~resurrect-sdev
+++ a/drivers/scsi/scsi_sysfs.c
@@ -230,6 +230,10 @@ static void scsi_device_dev_release_user
 	parent = sdev->sdev_gendev.parent;
 	starget = to_scsi_target(parent);
 
+	if (sdev->host->hostt->slave_destroy)
+		sdev->host->hostt->slave_destroy(sdev);
+	transport_destroy_device(&sdev->sdev_gendev);
+
 	spin_lock_irqsave(sdev->host->host_lock, flags);
 	starget->reap_ref++;
 	list_del(&sdev->siblings);
@@ -681,14 +685,17 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
-		put_device(sdev->sdev_gendev.parent);
 		printk(KERN_INFO "error 1\n");
+		scsi_device_set_state(sdev, SDEV_CANCEL);
+		put_device(sdev->sdev_gendev.parent);
 		return error;
 	}
 	error = class_device_add(&sdev->sdev_classdev);
 	if (error) {
 		printk(KERN_INFO "error 2\n");
-		goto clean_device;
+		scsi_device_set_state(sdev, SDEV_CANCEL);
+		device_del(&sdev->sdev_gendev);
+		goto out_error;
 	}
 
 	/* take a reference for the sdev_classdev; this is
@@ -700,7 +707,7 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 					sdev->host->hostt->sdev_attrs[i]);
 			if (error) {
 				__scsi_remove_device(sdev);
-				goto out;
+				goto out_error;
 			}
 		}
 	}
@@ -714,25 +721,76 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 			error = device_create_file(&sdev->sdev_gendev, attr);
 			if (error) {
 				__scsi_remove_device(sdev);
-				goto out;
+				goto out_error;
 			}
 		}
 	}
 
 	transport_add_device(&sdev->sdev_gendev);
- out:
-	return error;
 
- clean_device:
-	scsi_device_set_state(sdev, SDEV_CANCEL);
+	return error;
 
-	device_del(&sdev->sdev_gendev);
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_gendev);
+ out_error:
+	scsi_destroy_device(sdev);
 
 	return error;
 }
 
+int scsi_resurrect_device(struct scsi_device *sdev)
+{
+	int ret = 0;
+
+	/* Device is active, return */
+	if (sdev->sdev_state == SDEV_RUNNING || sdev->sdev_state == SDEV_CREATED)
+		return 0;
+
+	/*
+	 * Set the device to SDEV_CANCEL to start resurrection
+	 */
+	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
+		return -ENXIO;
+
+	ret = scsi_configure_device(sdev);
+	if (ret) {
+		scsi_destroy_device(sdev);
+		return ret;
+	}
+
+	/*
+	 * Ok, the device is now all set up, we can
+	 * register it and tell the rest of the kernel
+	 * about it.
+	 */
+	return scsi_sysfs_add_sdev(sdev);
+}
+
+int scsi_configure_device(struct scsi_device *sdev)
+{
+	/* set the device running here so that slave configure
+	 * may do I/O */
+	if (scsi_device_set_state(sdev, SDEV_RUNNING) != 0)
+		return -ENXIO;
+
+	transport_configure_device(&sdev->sdev_gendev);
+
+	if (sdev->host->hostt->slave_configure) {
+		int ret = sdev->host->hostt->slave_configure(sdev);
+		if (ret) {
+			/*
+			 * if LLDD reports slave not present, don't clutter
+			 * console with alloc failure messages
+			 */
+			if (ret != -ENXIO) {
+				sdev_printk(KERN_ERR, sdev,
+					"failed to configure device\n");
+			}
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 void __scsi_remove_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
@@ -743,11 +801,6 @@ void __scsi_remove_device(struct scsi_de
 	class_device_unregister(&sdev->sdev_classdev);
 	transport_remove_device(dev);
 	device_del(dev);
-	scsi_device_set_state(sdev, SDEV_DEL);
-	if (sdev->host->hostt->slave_destroy)
-		sdev->host->hostt->slave_destroy(sdev);
-	transport_destroy_device(dev);
-	put_device(dev);
 }
 
 /**
@@ -760,6 +813,7 @@ void scsi_remove_device(struct scsi_devi
 
 	mutex_lock(&shost->scan_mutex);
 	__scsi_remove_device(sdev);
+	scsi_destroy_device(sdev);
 	mutex_unlock(&shost->scan_mutex);
 }
 EXPORT_SYMBOL(scsi_remove_device);
diff -puN include/scsi/scsi_device.h~resurrect-sdev include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h~resurrect-sdev
+++ a/include/scsi/scsi_device.h
@@ -203,6 +203,8 @@ extern struct scsi_device *__scsi_add_de
 		uint, uint, uint, void *hostdata);
 extern int scsi_add_device(struct Scsi_Host *host, uint channel,
 			   uint target, uint lun);
+extern int scsi_configure_device(struct scsi_device *);
+extern int scsi_resurrect_device(struct scsi_device *);
 extern void scsi_remove_device(struct scsi_device *);
 extern int scsi_device_cancel(struct scsi_device *, int);
 
@@ -317,6 +319,12 @@ static inline unsigned int sdev_id(struc
 #define scmd_id(scmd) sdev_id((scmd)->device)
 #define scmd_channel(scmd) sdev_channel((scmd)->device)
 
+static inline void scsi_destroy_device(struct scsi_device *sdev)
+{
+	scsi_device_set_state(sdev, SDEV_DEL);
+	put_device(&sdev->sdev_gendev);
+}
+
 static inline int scsi_device_online(struct scsi_device *sdev)
 {
 	return sdev->sdev_state != SDEV_OFFLINE;
_

Patches currently in -mm which might be from hare@suse.de are

resurrect-sdev.patch
drivers-scsi-aic7xxx-make-functions-static.patch
