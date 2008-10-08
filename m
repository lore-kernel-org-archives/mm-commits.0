From: akpm@linux-foundation.org
Subject: + tpm-num_opens-to-is_open-variable-change.patch added to -mm tree
Date: Wed, 08 Oct 2008 15:44:44 -0700
Message-ID: <200810082244.m98MiikY014693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755339AbYJHWoz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Oct 2008 18:44:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srajiv@linux.vnet.ibm.com, serue@us.ibm.com, zohar@linux.vnet.ibm.com


The patch titled
     tpm: num_opens to is_open variable change
has been added to the -mm tree.  Its filename is
     tpm-num_opens-to-is_open-variable-change.patch

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
Subject: tpm: num_opens to is_open variable change
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Renames num_open to is_open, as only one process can open the file at a time.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |    7 +++----
 drivers/char/tpm/tpm.h |    2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/char/tpm/tpm.c~tpm-num_opens-to-is_open-variable-change drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-num_opens-to-is_open-variable-change
+++ a/drivers/char/tpm/tpm.c
@@ -985,20 +985,19 @@ int tpm_open(struct inode *inode, struct
 		goto err_out;
 	}
 
-	if (chip->num_opens) {
+	if (test_and_set_bit(0, &chip->is_open)) {
 		dev_dbg(chip->dev, "Another process owns this TPM\n");
 		rc = -EBUSY;
 		goto err_out;
 	}
 
-	chip->num_opens++;
 	get_device(chip->dev);
 
 	spin_unlock(&driver_lock);
 
 	chip->data_buffer = kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
 	if (chip->data_buffer == NULL) {
-		chip->num_opens--;
+		clear_bit(0, &chip->is_open);
 		put_device(chip->dev);
 		return -ENOMEM;
 	}
@@ -1023,7 +1022,7 @@ int tpm_release(struct inode *inode, str
 	file->private_data = NULL;
 	del_singleshot_timer_sync(&chip->user_read_timer);
 	atomic_set(&chip->data_pending, 0);
-	chip->num_opens--;
+	clear_bit(0, &chip->is_open);
 	put_device(chip->dev);
 	kfree(chip->data_buffer);
 	spin_unlock(&driver_lock);
diff -puN drivers/char/tpm/tpm.h~tpm-num_opens-to-is_open-variable-change drivers/char/tpm/tpm.h
--- a/drivers/char/tpm/tpm.h~tpm-num_opens-to-is_open-variable-change
+++ a/drivers/char/tpm/tpm.h
@@ -90,7 +90,7 @@ struct tpm_chip {
 	struct device *dev;	/* Device stuff */
 
 	int dev_num;		/* /dev/tpm# */
-	int num_opens;		/* only one allowed */
+	unsigned long is_open;	/* only one allowed */
 	int time_expired;
 
 	/* Data passed to and from the tpm via the read/write calls */
_

Patches currently in -mm which might be from srajiv@linux.vnet.ibm.com are

tpm-include-moderated-for-non-subscribers-notation-in-maintainers.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
tpm-update-char-dev-bkl-pushdown.patch
tpm-num_opens-to-is_open-variable-change.patch
tpm-rcu-locking.patch
tpm-addition-of-pnp_remove.patch
tpm-fixed-tpm_release-timing.patch

