From: akpm@linux-foundation.org
Subject: + tpm-rcu-locking.patch added to -mm tree
Date: Wed, 08 Oct 2008 15:44:47 -0700
Message-ID: <200810082244.m98Mil9s014696@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580AbYJHWpt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Oct 2008 18:45:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srajiv@linux.vnet.ibm.com, paulmck@us.ibm.com, serue@us.ibm.com, zohar@linux.vnet.ibm.com


The patch titled
     tpm: rcu locking
has been added to the -mm tree.  Its filename is
     tpm-rcu-locking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: rcu locking
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Protect tpm_chip_list when transversing it.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |   61 +++++++++++++++------------------------
 1 file changed, 24 insertions(+), 37 deletions(-)

diff -puN drivers/char/tpm/tpm.c~tpm-rcu-locking drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-rcu-locking
+++ a/drivers/char/tpm/tpm.c
@@ -968,33 +968,28 @@ EXPORT_SYMBOL_GPL(tpm_store_cancel);
  */
 int tpm_open(struct inode *inode, struct file *file)
 {
-	int rc = 0, minor = iminor(inode);
+	int minor = iminor(inode);
 	struct tpm_chip *chip = NULL, *pos;
 
-	spin_lock(&driver_lock);
-
-	list_for_each_entry(pos, &tpm_chip_list, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(pos, &tpm_chip_list, list) {
 		if (pos->vendor.miscdev.minor == minor) {
 			chip = pos;
+			get_device(chip->dev);
 			break;
 		}
 	}
+	rcu_read_unlock();
 
-	if (chip == NULL) {
-		rc = -ENODEV;
-		goto err_out;
-	}
+	if (!chip)
+		return -ENODEV;
 
 	if (test_and_set_bit(0, &chip->is_open)) {
 		dev_dbg(chip->dev, "Another process owns this TPM\n");
-		rc = -EBUSY;
-		goto err_out;
+		put_device(chip->dev);
+		return -EBUSY;
 	}
 
-	get_device(chip->dev);
-
-	spin_unlock(&driver_lock);
-
 	chip->data_buffer = kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
 	if (chip->data_buffer == NULL) {
 		clear_bit(0, &chip->is_open);
@@ -1006,26 +1001,23 @@ int tpm_open(struct inode *inode, struct
 
 	file->private_data = chip;
 	return 0;
-
-err_out:
-	spin_unlock(&driver_lock);
-	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_open);
 
+/*
+ * Called on file close
+ */
 int tpm_release(struct inode *inode, struct file *file)
 {
 	struct tpm_chip *chip = file->private_data;
 
 	flush_scheduled_work();
-	spin_lock(&driver_lock);
 	file->private_data = NULL;
 	del_singleshot_timer_sync(&chip->user_read_timer);
 	atomic_set(&chip->data_pending, 0);
+	kfree(chip->data_buffer);
 	clear_bit(0, &chip->is_open);
 	put_device(chip->dev);
-	kfree(chip->data_buffer);
-	spin_unlock(&driver_lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_release);
@@ -1099,13 +1091,11 @@ void tpm_remove_hardware(struct device *
 	}
 
 	spin_lock(&driver_lock);
-
-	list_del(&chip->list);
-
+	list_del_rcu(&chip->list);
 	spin_unlock(&driver_lock);
+	synchronize_rcu();
 
 	misc_deregister(&chip->vendor.miscdev);
-
 	sysfs_remove_group(&dev->kobj, chip->vendor.attr_group);
 	tpm_bios_log_teardown(chip->bios_dir);
 
@@ -1153,8 +1143,7 @@ EXPORT_SYMBOL_GPL(tpm_pm_resume);
 /*
  * Once all references to platform device are down to 0,
  * release all allocated structures.
- * In case vendor provided release function,
- * call it too.
+ * In case vendor provided release function, call it too.
  */
 static void tpm_dev_release(struct device *dev)
 {
@@ -1162,7 +1151,6 @@ static void tpm_dev_release(struct devic
 
 	if (chip->vendor.release)
 		chip->vendor.release(dev);
-
 	chip->release(dev);
 
 	clear_bit(chip->dev_num, dev_mask);
@@ -1177,8 +1165,8 @@ static void tpm_dev_release(struct devic
  * upon errant exit from this function specific probe function should call
  * pci_disable_device
  */
-struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vendor_specific
-				       *entry)
+struct tpm_chip *tpm_register_hardware(struct device *dev,
+					const struct tpm_vendor_specific *entry)
 {
 #define DEVNAME_SIZE 7
 
@@ -1233,21 +1221,20 @@ struct tpm_chip *tpm_register_hardware(s
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
+
 		return NULL;
 	}
 
 	chip->bios_dir = tpm_bios_log_setup(devname);
 
+	/* Make chip available */
+	spin_lock(&driver_lock);
+	list_add_rcu(&chip->list, &tpm_chip_list);
+	spin_unlock(&driver_lock);
+
 	return chip;
 
 out_free:
_

Patches currently in -mm which might be from srajiv@linux.vnet.ibm.com are

tpm-include-moderated-for-non-subscribers-notation-in-maintainers.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
tpm-update-char-dev-bkl-pushdown.patch
tpm-num_opens-to-is_open-variable-change.patch
tpm-rcu-locking.patch
tpm-addition-of-pnp_remove.patch
tpm-fixed-tpm_release-timing.patch

