From: akpm@linux-foundation.org
Subject: - drivers-block-ubc-use-list_for_each_entry.patch removed from -mm tree
Date: Fri, 13 Jul 2007 15:33:24 -0700
Message-ID: <200707132233.l6DMXOuT025077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44068 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758965AbXGMWpe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 18:45:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, greg@kroah.com, jens.axboe@oracle.com, zaitcev@redhat.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/ub.c: use list_for_each_entry()
has been removed from the -mm tree.  Its filename was
     drivers-block-ubc-use-list_for_each_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/block/ub.c: use list_for_each_entry()
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Low performance USB storage driver: Use list_for_each_entry() instead
of list_for_each()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/ub.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff -puN drivers/block/ub.c~drivers-block-ubc-use-list_for_each_entry drivers/block/ub.c
--- a/drivers/block/ub.c~drivers-block-ubc-use-list_for_each_entry
+++ a/drivers/block/ub.c
@@ -1547,10 +1547,8 @@ static void ub_reset_enter(struct ub_dev
 #endif
 
 #if 0 /* We let them stop themselves. */
-	struct list_head *p;
 	struct ub_lun *lun;
-	list_for_each(p, &sc->luns) {
-		lun = list_entry(p, struct ub_lun, link);
+	list_for_each_entry(lun, &sc->luns, link) {
 		blk_stop_queue(lun->disk->queue);
 	}
 #endif
@@ -1562,7 +1560,6 @@ static void ub_reset_task(struct work_st
 {
 	struct ub_dev *sc = container_of(work, struct ub_dev, reset_work);
 	unsigned long flags;
-	struct list_head *p;
 	struct ub_lun *lun;
 	int lkr, rc;
 
@@ -1608,8 +1605,7 @@ static void ub_reset_task(struct work_st
 	spin_lock_irqsave(sc->lock, flags);
 	sc->reset = 0;
 	tasklet_schedule(&sc->tasklet);
-	list_for_each(p, &sc->luns) {
-		lun = list_entry(p, struct ub_lun, link);
+	list_for_each_entry(lun, &sc->luns, link) {
 		blk_start_queue(lun->disk->queue);
 	}
 	wake_up(&sc->reset_wait);
@@ -2348,7 +2344,6 @@ err_alloc:
 static void ub_disconnect(struct usb_interface *intf)
 {
 	struct ub_dev *sc = usb_get_intfdata(intf);
-	struct list_head *p;
 	struct ub_lun *lun;
 	unsigned long flags;
 
@@ -2403,8 +2398,7 @@ static void ub_disconnect(struct usb_int
 	/*
 	 * Unregister the upper layer.
 	 */
-	list_for_each (p, &sc->luns) {
-		lun = list_entry(p, struct ub_lun, link);
+	list_for_each_entry(lun, &sc->luns, link) {
 		del_gendisk(lun->disk);
 		/*
 		 * I wish I could do:
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
kcopyd-use-mutex-instead-of-semaphore.patch
git-dvb.patch
git-mtd.patch
use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver.patch
use-mutex-instead-of-semaphore-in-the-elan-u132-adapter-driver.patch
use-mutex-instead-of-semaphore-in-the-adutux-driver.patch
use-mutex-instead-of-semaphore-in-the-ftdi-elan-driver.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
fs-block_devc-use-list_for_each_entry.patch
use-mutex-instead-of-semaphore-in-spi-core-init-code.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
