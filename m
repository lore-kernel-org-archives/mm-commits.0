From: akpm@linux-foundation.org
Subject: - use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver.patch removed from -mm tree
Date: Mon, 16 Jul 2007 14:00:28 -0700
Message-ID: <200707162100.l6GL0SvX002609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53321 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758803AbXGPVPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, Sumant.Patro@lsi.com, mm-commits@vger.kernel.org


The patch titled
     use mutex instead of semaphore in Megaraid Mailbox driver
has been removed from the -mm tree.  Its filename was
     use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
kcopyd-use-mutex-instead-of-semaphore.patch
git-dvb.patch
git-mtd.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver.patch
use-mutex-instead-of-semaphore-in-the-elan-u132-adapter-driver.patch
use-mutex-instead-of-semaphore-in-the-adutux-driver.patch
use-mutex-instead-of-semaphore-in-the-ftdi-elan-driver.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
use-mutex-instead-of-semaphore-in-spi-core-init-code.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
