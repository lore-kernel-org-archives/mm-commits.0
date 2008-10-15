From: akpm@linux-foundation.org
Subject: - tpm-update-char-dev-bkl-pushdown.patch removed from -mm tree
Date: Wed, 15 Oct 2008 14:14:18 -0700
Message-ID: <200810152114.m9FLEI79005735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753659AbYJOVZk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 17:25:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srajiv@linux.vnet.ibm.com, serue@us.ibm.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     tpm: update char dev BKL pushdown
has been removed from the -mm tree.  Its filename was
     tpm-update-char-dev-bkl-pushdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: update char dev BKL pushdown
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Remove the BKL calls from the TPM driver, which were added in the overall
misc-char-dev-BKL-pushdown.patch, as they are not needed.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/tpm/tpm.c~tpm-update-char-dev-bkl-pushdown drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-update-char-dev-bkl-pushdown
+++ a/drivers/char/tpm/tpm.c
@@ -961,13 +961,16 @@ EXPORT_SYMBOL_GPL(tpm_store_cancel);
 
 /*
  * Device file system interface to the TPM
+ *
+ * It's assured that the chip will be opened just once,
+ * by the check of is_open variable, which is protected
+ * by driver_lock.
  */
 int tpm_open(struct inode *inode, struct file *file)
 {
 	int rc = 0, minor = iminor(inode);
 	struct tpm_chip *chip = NULL, *pos;
 
-	lock_kernel();
 	spin_lock(&driver_lock);
 
 	list_for_each_entry(pos, &tpm_chip_list, list) {
@@ -997,19 +1000,16 @@ int tpm_open(struct inode *inode, struct
 	if (chip->data_buffer == NULL) {
 		chip->num_opens--;
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
_

Patches currently in -mm which might be from srajiv@linux.vnet.ibm.com are

origin.patch
tpm-include-moderated-for-non-subscribers-notation-in-maintainers.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch

