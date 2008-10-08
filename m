From: akpm@linux-foundation.org
Subject: + tpm-update-char-dev-bkl-pushdown.patch added to -mm tree
Date: Wed, 08 Oct 2008 15:44:41 -0700
Message-ID: <200810082244.m98MifwL014688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754746AbYJHWov (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Oct 2008 18:44:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srajiv@linux.vnet.ibm.com, serue@us.ibm.com, zohar@linux.vnet.ibm.com


The patch titled
     tpm: update char dev BKL pushdown
has been added to the -mm tree.  Its filename is
     tpm-update-char-dev-bkl-pushdown.patch

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

tpm-include-moderated-for-non-subscribers-notation-in-maintainers.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
tpm-update-char-dev-bkl-pushdown.patch
tpm-num_opens-to-is_open-variable-change.patch
tpm-rcu-locking.patch
tpm-addition-of-pnp_remove.patch
tpm-fixed-tpm_release-timing.patch

