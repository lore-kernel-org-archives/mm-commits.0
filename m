From: akpm@linux-foundation.org
Subject: + sleep-during-spinlock-in-tpm-driver.patch added to -mm tree
Date: Wed, 25 Apr 2007 18:33:53 -0700
Message-ID: <200704260133.l3Q1Xra9018064@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932097AbXDZBd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 21:33:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pwarudkar@aol.com, parag.warudkar@gmail.com


The patch titled
     tpm: fix sleep-in-spinlock
has been added to the -mm tree.  Its filename is
     sleep-during-spinlock-in-tpm-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tpm: fix sleep-in-spinlock
From: Parag Warudkar <pwarudkar@aol.com>

flush_scheduled_work() can sleep, and we're calling it under spinlock.

AFAICS, moving flush_scheduled_work before spin_lock() should not cause any
problems.

Reason being - The only thing that can race against tpm_release is tpm_open
(tpm_release is called when last reference to the file is closed and only
thing that can happen after that is tpm_open??) and tpm_open acquires
driver_lock and more over it bails out with EBUSY if chip->num_opens is
greater than 0.

I also moved chip->num_pending-- to after deleting timer and setting data
pending as it looks more correct for the paranoid although it probably doesn't
matter as it is guarded by driver_lock.  None the less this change should not
cause problems.

While I was at it I noticed a missing NULL check in tpm_register_hardware
which is fixed with this patch as well.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/char/tpm/tpm.c~sleep-during-spinlock-in-tpm-driver drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~sleep-during-spinlock-in-tpm-driver
+++ a/drivers/char/tpm/tpm.c
@@ -942,12 +942,12 @@ int tpm_release(struct inode *inode, str
 {
 	struct tpm_chip *chip = file->private_data;
 
+	flush_scheduled_work();
 	spin_lock(&driver_lock);
 	file->private_data = NULL;
-	chip->num_opens--;
 	del_singleshot_timer_sync(&chip->user_read_timer);
-	flush_scheduled_work();
 	atomic_set(&chip->data_pending, 0);
+	chip->num_opens--;
 	put_device(chip->dev);
 	kfree(chip->data_buffer);
 	spin_unlock(&driver_lock);
@@ -1097,8 +1097,13 @@ struct tpm_chip *tpm_register_hardware(s
 
 	/* Driver specific per-device data */
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
-	if (chip == NULL)
+	devname = kmalloc(DEVNAME_SIZE, GFP_KERNEL);
+
+	if (chip == NULL || devname == NULL) {
+		kfree(chip);
+		kfree(devname);
 		return NULL;
+	}
 
 	init_MUTEX(&chip->buffer_mutex);
 	init_MUTEX(&chip->tpm_mutex);
@@ -1124,7 +1129,6 @@ struct tpm_chip *tpm_register_hardware(s
 
 	set_bit(chip->dev_num, dev_mask);
 
-	devname = kmalloc(DEVNAME_SIZE, GFP_KERNEL);
 	scnprintf(devname, DEVNAME_SIZE, "%s%d", "tpm", chip->dev_num);
 	chip->vendor.miscdev.name = devname;
 
_

Patches currently in -mm which might be from pwarudkar@aol.com are

sleep-during-spinlock-in-tpm-driver.patch
