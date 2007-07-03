From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver.patch added to -mm tree
Date: Tue, 03 Jul 2007 14:24:03 -0700
Message-ID: <200707032124.l63LO3FC016461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60332 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756821AbXGCVYP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 17:24:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, Sumant.Patro@lsi.com


The patch titled
     use mutex instead of semaphore in Megaraid Mailbox driver
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use mutex instead of semaphore in Megaraid Mailbox driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The Megaraid Mailbox driver uses a semaphore as mutex.  Use the mutex API
instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: "Patro, Sumant" <Sumant.Patro@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/mega_common.h   |    1 +
 drivers/scsi/megaraid/megaraid_mbox.c |    6 +++---
 drivers/scsi/megaraid/megaraid_mbox.h |    4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/megaraid/mega_common.h~use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver drivers/scsi/megaraid/mega_common.h
--- a/drivers/scsi/megaraid/mega_common.h~use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver
+++ a/drivers/scsi/megaraid/mega_common.h
@@ -21,6 +21,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/blkdev.h>
diff -puN drivers/scsi/megaraid/megaraid_mbox.c~use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver drivers/scsi/megaraid/megaraid_mbox.c
--- a/drivers/scsi/megaraid/megaraid_mbox.c~use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver
+++ a/drivers/scsi/megaraid/megaraid_mbox.c
@@ -3880,7 +3880,7 @@ megaraid_sysfs_alloc_resources(adapter_t
 		megaraid_sysfs_free_resources(adapter);
 	}
 
-	sema_init(&raid_dev->sysfs_sem, 1);
+	mutex_init(&raid_dev->sysfs_mtx);
 
 	init_waitqueue_head(&raid_dev->sysfs_wait_q);
 
@@ -3981,7 +3981,7 @@ megaraid_sysfs_get_ldmap(adapter_t *adap
 	/*
 	 * Allow only one read at a time to go through the sysfs attributes
 	 */
-	down(&raid_dev->sysfs_sem);
+	mutex_lock(&raid_dev->sysfs_mtx);
 
 	uioc	= raid_dev->sysfs_uioc;
 	mbox64	= raid_dev->sysfs_mbox64;
@@ -4057,7 +4057,7 @@ megaraid_sysfs_get_ldmap(adapter_t *adap
 
 	del_timer_sync(timerp);
 
-	up(&raid_dev->sysfs_sem);
+	mutex_unlock(&raid_dev->sysfs_mtx);
 
 	return rval;
 }
diff -puN drivers/scsi/megaraid/megaraid_mbox.h~use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver drivers/scsi/megaraid/megaraid_mbox.h
--- a/drivers/scsi/megaraid/megaraid_mbox.h~use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver
+++ a/drivers/scsi/megaraid/megaraid_mbox.h
@@ -168,7 +168,7 @@ typedef struct {
  * @hw_error			: set if FW not responding
  * @fast_load			: If set, skip physical device scanning
  * @channel_class		: channel class, RAID or SCSI
- * @sysfs_sem			: semaphore to serialize access to sysfs res.
+ * @sysfs_mtx			: mutex to serialize access to sysfs res.
  * @sysfs_uioc			: management packet to issue FW calls from sysfs
  * @sysfs_mbox64		: mailbox packet to issue FW calls from sysfs
  * @sysfs_buffer		: data buffer for FW commands issued from sysfs
@@ -208,7 +208,7 @@ typedef struct {
 	int				hw_error;
 	int				fast_load;
 	uint8_t				channel_class;
-	struct semaphore		sysfs_sem;
+	struct mutex			sysfs_mtx;
 	uioc_t				*sysfs_uioc;
 	mbox64_t			*sysfs_mbox64;
 	caddr_t				sysfs_buffer;
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

kcopyd-use-mutex-instead-of-semaphore.patch
git-mtd.patch
git-netdev-all.patch
block-device-elevator-use-list_for_each_entry-instead-of-list_for_each.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
drivers-block-ubc-use-list_for_each_entry.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
fs-block_devc-use-list_for_each_entry.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver.patch
use-mutex-instead-of-semaphore-in-philips-webcam-driver.patch
use-mutex-instead-of-semaphore-in-virtual-video-driver.patch
use-mutex-instead-of-semaphore-in-vlsi-82c147-irda-controller-driver.patch
