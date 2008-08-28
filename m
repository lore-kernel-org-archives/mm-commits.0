From: akpm@linux-foundation.org
Subject: - tpm-update-char-dev-bkl-pushdown.patch removed from -mm tree
Date: Wed, 27 Aug 2008 20:36:31 -0700
Message-ID: <200808280336.m7S3aVar005344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753830AbYH1Dmb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 23:42:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srajiv@linux.vnet.ibm.com, serue@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     tpm: update char dev BKL pushdown
has been removed from the -mm tree.  Its filename was
     tpm-update-char-dev-bkl-pushdown.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: update char dev BKL pushdown
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Remove the BKL calls from the TPM driver, which were added in the overall
misc-char-dev-BKL-pushdown.patch, as they are not needed.  Changed
num_opens from an int to atomic_t.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |   22 +++++++---------------
 drivers/char/tpm/tpm.h |    2 +-
 2 files changed, 8 insertions(+), 16 deletions(-)

diff -puN drivers/char/tpm/tpm.c~tpm-update-char-dev-bkl-pushdown drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-update-char-dev-bkl-pushdown
+++ a/drivers/char/tpm/tpm.c
@@ -967,7 +967,6 @@ int tpm_open(struct inode *inode, struct
 	int rc = 0, minor = iminor(inode);
 	struct tpm_chip *chip = NULL, *pos;
 
-	lock_kernel();
 	spin_lock(&driver_lock);
 
 	list_for_each_entry(pos, &tpm_chip_list, list) {
@@ -982,34 +981,31 @@ int tpm_open(struct inode *inode, struct
 		goto err_out;
 	}
 
-	if (chip->num_opens) {
+	if (atomic_read(&chip->num_opens)) {
 		dev_dbg(chip->dev, "Another process owns this TPM\n");
 		rc = -EBUSY;
 		goto err_out;
 	}
 
-	chip->num_opens++;
+	atomic_inc(&chip->num_opens);
 	get_device(chip->dev);
 
 	spin_unlock(&driver_lock);
 
 	chip->data_buffer = kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
 	if (chip->data_buffer == NULL) {
-		chip->num_opens--;
+		atomic_dec(&chip->num_opens);
 		put_device(chip->dev);
-		unlock_kernel();
 		return -ENOMEM;
 	}
 
 	atomic_set(&chip->data_pending, 0);
 
 	file->private_data = chip;
-	unlock_kernel();
 	return 0;
 
 err_out:
 	spin_unlock(&driver_lock);
-	unlock_kernel();
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_open);
@@ -1023,7 +1019,7 @@ int tpm_release(struct inode *inode, str
 	file->private_data = NULL;
 	del_singleshot_timer_sync(&chip->user_read_timer);
 	atomic_set(&chip->data_pending, 0);
-	chip->num_opens--;
+	atomic_dec(chip->num_opens);
 	put_device(chip->dev);
 	kfree(chip->data_buffer);
 	spin_unlock(&driver_lock);
@@ -1238,20 +1234,16 @@ struct tpm_chip *tpm_register_hardware(s
 		return NULL;
 	}
 
-	spin_lock(&driver_lock);
-
-	list_add(&chip->list, &tpm_chip_list);
-
-	spin_unlock(&driver_lock);
-
 	if (sysfs_create_group(&dev->kobj, chip->vendor.attr_group)) {
-		list_del(&chip->list);
 		misc_deregister(&chip->vendor.miscdev);
 		put_device(chip->dev);
 		return NULL;
 	}
 
 	chip->bios_dir = tpm_bios_log_setup(devname);
+	spin_lock(&driver_lock);
+	list_add(&chip->list, &tpm_chip_list);
+	spin_unlock(&driver_lock);
 
 	return chip;
 }
diff -puN drivers/char/tpm/tpm.h~tpm-update-char-dev-bkl-pushdown drivers/char/tpm/tpm.h
--- a/drivers/char/tpm/tpm.h~tpm-update-char-dev-bkl-pushdown
+++ a/drivers/char/tpm/tpm.h
@@ -90,7 +90,7 @@ struct tpm_chip {
 	struct device *dev;	/* Device stuff */
 
 	int dev_num;		/* /dev/tpm# */
-	int num_opens;		/* only one allowed */
+	atomic_t num_opens;		/* only one allowed */
 	int time_expired;
 
 	/* Data passed to and from the tpm via the read/write calls */
_

Patches currently in -mm which might be from srajiv@linux.vnet.ibm.com are

securityfs-do-not-depend-on-config_security.patch
tpm-include-moderated-for-non-subscribers-notation-in-maintainers.patch
tpm-update-char-dev-bkl-pushdown.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch

