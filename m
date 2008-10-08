From: akpm@linux-foundation.org
Subject: + tpm-addition-of-pnp_remove.patch added to -mm tree
Date: Wed, 08 Oct 2008 15:44:50 -0700
Message-ID: <200810082244.m98MioxP014699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755555AbYJHWph (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Oct 2008 18:45:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srajiv@linux.vnet.ibm.com, bjorn.helgaas@hp.com, serue@us.ibm.com, zohar@linux.vnet.ibm.com


The patch titled
     tpm: addition of pnp_remove()
has been added to the -mm tree.  Its filename is
     tpm-addition-of-pnp_remove.patch

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
Subject: tpm: addition of pnp_remove()
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

The tpm_dev_release function is only called for platform devices, not pnp
devices, so we implemented the .remove function for pnp ones.  Since it's
code is very similar to the one inside tpm_dev_release, we've created a
helper function tpm_dev_vendor_release, which is called by both.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c     |   22 ++++++++++++++++------
 drivers/char/tpm/tpm.h     |    1 +
 drivers/char/tpm/tpm_tis.c |   14 +++++++++++++-
 3 files changed, 30 insertions(+), 7 deletions(-)

diff -puN drivers/char/tpm/tpm.c~tpm-addition-of-pnp_remove drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-addition-of-pnp_remove
+++ a/drivers/char/tpm/tpm.c
@@ -1140,23 +1140,33 @@ int tpm_pm_resume(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(tpm_pm_resume);
 
+/* In case vendor provided release function, call it too.*/
+
+void tpm_dev_vendor_release(struct tpm_chip *chip)
+{
+	if (chip->vendor.release)
+	 	chip->vendor.release(chip->dev);
+
+	clear_bit(chip->dev_num, dev_mask);
+	kfree(chip->vendor.miscdev.name);
+}
+EXPORT_SYMBOL_GPL(tpm_dev_vendor_release);
+
+
 /*
  * Once all references to platform device are down to 0,
  * release all allocated structures.
- * In case vendor provided release function, call it too.
  */
 static void tpm_dev_release(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 
-	if (chip->vendor.release)
-		chip->vendor.release(dev);
-	chip->release(dev);
+	tpm_dev_vendor_release(chip);
 
-	clear_bit(chip->dev_num, dev_mask);
-	kfree(chip->vendor.miscdev.name);
+	chip->release(dev);
 	kfree(chip);
 }
+EXPORT_SYMBOL_GPL(tpm_dev_release);
 
 /*
  * Called from tpm_<specific>.c probe function only for devices 
diff -puN drivers/char/tpm/tpm.h~tpm-addition-of-pnp_remove drivers/char/tpm/tpm.h
--- a/drivers/char/tpm/tpm.h~tpm-addition-of-pnp_remove
+++ a/drivers/char/tpm/tpm.h
@@ -132,6 +132,7 @@ extern struct tpm_chip* tpm_register_har
 				 const struct tpm_vendor_specific *);
 extern int tpm_open(struct inode *, struct file *);
 extern int tpm_release(struct inode *, struct file *);
+extern void tpm_dev_vendor_release(struct tpm_chip *);
 extern ssize_t tpm_write(struct file *, const char __user *, size_t,
 			 loff_t *);
 extern ssize_t tpm_read(struct file *, char __user *, size_t, loff_t *);
diff -puN drivers/char/tpm/tpm_tis.c~tpm-addition-of-pnp_remove drivers/char/tpm/tpm_tis.c
--- a/drivers/char/tpm/tpm_tis.c~tpm-addition-of-pnp_remove
+++ a/drivers/char/tpm/tpm_tis.c
@@ -630,12 +630,23 @@ static struct pnp_device_id tpm_pnp_tbl[
 	{"", 0}			/* Terminator */
 };
 
+static __devexit void tpm_tis_pnp_remove(struct pnp_dev *dev)
+{
+	struct tpm_chip *chip = pnp_get_drvdata(dev);
+
+	tpm_dev_vendor_release(chip);
+
+	kfree(chip);
+}
+
+
 static struct pnp_driver tis_pnp_driver = {
 	.name = "tpm_tis",
 	.id_table = tpm_pnp_tbl,
 	.probe = tpm_tis_pnp_init,
 	.suspend = tpm_tis_pnp_suspend,
 	.resume = tpm_tis_pnp_resume,
+	.remove = tpm_tis_pnp_remove,
 };
 
 #define TIS_HID_USR_IDX sizeof(tpm_pnp_tbl)/sizeof(struct pnp_device_id) -2
@@ -683,6 +694,7 @@ static void __exit cleanup_tis(void)
 	spin_lock(&tis_lock);
 	list_for_each_entry_safe(i, j, &tis_chips, list) {
 		chip = to_tpm_chip(i);
+		tpm_remove_hardware(chip->dev);
 		iowrite32(~TPM_GLOBAL_INT_ENABLE &
 			  ioread32(chip->vendor.iobase +
 				   TPM_INT_ENABLE(chip->vendor.
@@ -694,9 +706,9 @@ static void __exit cleanup_tis(void)
 			free_irq(chip->vendor.irq, chip);
 		iounmap(i->iobase);
 		list_del(&i->list);
-		tpm_remove_hardware(chip->dev);
 	}
 	spin_unlock(&tis_lock);
+
 	if (force) {
 		platform_device_unregister(pdev);
 		driver_unregister(&tis_drv);
_

Patches currently in -mm which might be from srajiv@linux.vnet.ibm.com are

tpm-include-moderated-for-non-subscribers-notation-in-maintainers.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
tpm-update-char-dev-bkl-pushdown.patch
tpm-num_opens-to-is_open-variable-change.patch
tpm-rcu-locking.patch
tpm-addition-of-pnp_remove.patch
tpm-fixed-tpm_release-timing.patch

