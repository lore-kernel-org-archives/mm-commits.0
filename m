From: akpm@linux-foundation.org
Subject: + tpm-use-correct-data-types-for-sizes-in-tpm_write-and-tpm_read.patch added to -mm tree
Date: Tue, 01 Jul 2008 12:56:37 -0700
Message-ID: <200807011956.m61JubRR011786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979AbYGAT5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 15:57:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, tpm@selhorst.net


The patch titled
     tpm: Use correct data types for sizes in tpm_write() and tpm_read()
has been added to the -mm tree.  Its filename is
     tpm-use-correct-data-types-for-sizes-in-tpm_write-and-tpm_read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: Use correct data types for sizes in tpm_write() and tpm_read()
From: Michael Halcrow <mhalcrow@us.ibm.com>

Use the correct data types for the size parameters in tpm_write() and
tpm_read(). Note that rw_verify_area() makes sure that this bug cannot
be exploited to produce a buffer overrun.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Marcel Selhorst <tpm@selhorst.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/tpm/tpm.c~tpm-use-correct-data-types-for-sizes-in-tpm_write-and-tpm_read drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-use-correct-data-types-for-sizes-in-tpm_write-and-tpm_read
+++ a/drivers/char/tpm/tpm.c
@@ -1028,7 +1028,7 @@ ssize_t tpm_write(struct file *file, con
 		  size_t size, loff_t *off)
 {
 	struct tpm_chip *chip = file->private_data;
-	int in_size = size, out_size;
+	size_t in_size = size, out_size;
 
 	/* cannot perform a write until the read has cleared
 	   either via tpm_read or a user_read_timer timeout */
@@ -1063,7 +1063,7 @@ ssize_t tpm_read(struct file *file, char
 		 size_t size, loff_t *off)
 {
 	struct tpm_chip *chip = file->private_data;
-	int ret_size;
+	ssize_t ret_size;
 
 	del_singleshot_timer_sync(&chip->user_read_timer);
 	flush_scheduled_work();
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

ecryptfs-remove-unnecessary-mux-from-ecryptfs_init_ecryptfs_miscdev.patch
git-unionfs.patch
ecryptfs-privileged-kthread-for-lower-file-opens.patch
ecryptfs-discard-ecryptfsd-registration-messages-in-miscdev.patch
ecryptfs-propagate-key-errors-up-at-mount-time.patch
ecryptfs-string-copy-cleanup.patch
tpm-use-correct-data-types-for-sizes-in-tpm_write-and-tpm_read.patch
notify_change-callers-must-hold-i_mutex.patch

