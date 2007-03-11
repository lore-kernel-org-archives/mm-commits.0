From: akpm@linux-foundation.org
Subject: + spi-destroy-workqueue-after-spi_unregister_master.patch added to -mm tree
Date: Sun, 11 Mar 2007 00:32:40 -0800
Message-ID: <200703110832.l2B8Weki007912@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39952 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbXCKIcr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 04:32:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chris.lesiak@licor.com, dbrownell@users.sourceforge.net


The patch titled
     spi: destroy workqueue after spi_unregister_master
has been added to the -mm tree.  Its filename is
     spi-destroy-workqueue-after-spi_unregister_master.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: destroy workqueue after spi_unregister_master
From: Chris Lesiak <chris.lesiak@licor.com>

Fix a bug in the cleanup of an spi_bitbang bus.

The workqueue associated with the bus was destroyed before the call to
spi_unregister_master.  That meant that spi devices on that bus would be
unable to do IO in their remove method.  The shutdown flag should have been
able to prevent a segfault, but was never getting set.  By waiting to
destroy the workqueue until after the master is unregistered, devices are
able to do IO in their remove methods.  An added benefit is that neither
the shutdown flag nor a wait for the queue of messages to empty is needed.

Signed-off-by: Chris Lesiak <chris.lesiak@licor.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bitbang.c       |   26 ++------------------------
 include/linux/spi/spi_bitbang.h |    1 -
 2 files changed, 2 insertions(+), 25 deletions(-)

diff -puN drivers/spi/spi_bitbang.c~spi-destroy-workqueue-after-spi_unregister_master drivers/spi/spi_bitbang.c
--- a/drivers/spi/spi_bitbang.c~spi-destroy-workqueue-after-spi_unregister_master
+++ a/drivers/spi/spi_bitbang.c
@@ -302,10 +302,6 @@ static void bitbang_work(struct work_str
 		setup_transfer = NULL;
 
 		list_for_each_entry (t, &m->transfers, transfer_list) {
-			if (bitbang->shutdown) {
-				status = -ESHUTDOWN;
-				break;
-			}
 
 			/* override or restore speed and wordsize */
 			if (t->speed_hz || t->bits_per_word) {
@@ -410,8 +406,6 @@ int spi_bitbang_transfer(struct spi_devi
 	m->status = -EINPROGRESS;
 
 	bitbang = spi_master_get_devdata(spi->master);
-	if (bitbang->shutdown)
-		return -ESHUTDOWN;
 
 	spin_lock_irqsave(&bitbang->lock, flags);
 	if (!spi->max_speed_hz)
@@ -507,28 +501,12 @@ EXPORT_SYMBOL_GPL(spi_bitbang_start);
  */
 int spi_bitbang_stop(struct spi_bitbang *bitbang)
 {
-	unsigned	limit = 500;
-
-	spin_lock_irq(&bitbang->lock);
-	bitbang->shutdown = 0;
-	while (!list_empty(&bitbang->queue) && limit--) {
-		spin_unlock_irq(&bitbang->lock);
+	spi_unregister_master(bitbang->master);
 
-		dev_dbg(bitbang->master->cdev.dev, "wait for queue\n");
-		msleep(10);
-
-		spin_lock_irq(&bitbang->lock);
-	}
-	spin_unlock_irq(&bitbang->lock);
-	if (!list_empty(&bitbang->queue)) {
-		dev_err(bitbang->master->cdev.dev, "queue didn't empty\n");
-		return -EBUSY;
-	}
+	WARN_ON(!list_empty(&bitbang->queue));
 
 	destroy_workqueue(bitbang->workqueue);
 
-	spi_unregister_master(bitbang->master);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(spi_bitbang_stop);
diff -puN include/linux/spi/spi_bitbang.h~spi-destroy-workqueue-after-spi_unregister_master include/linux/spi/spi_bitbang.h
--- a/include/linux/spi/spi_bitbang.h~spi-destroy-workqueue-after-spi_unregister_master
+++ a/include/linux/spi/spi_bitbang.h
@@ -25,7 +25,6 @@ struct spi_bitbang {
 	spinlock_t		lock;
 	struct list_head	queue;
 	u8			busy;
-	u8			shutdown;
 	u8			use_dma;
 
 	struct spi_master	*master;
_

Patches currently in -mm which might be from chris.lesiak@licor.com are

spi-destroy-workqueue-after-spi_unregister_master.patch
