From: akpm@linux-foundation.org
Subject: + floppy-use-atomic-type-for-usage_count.patch added to -mm tree
Date: Mon, 14 Jun 2010 12:39:22 -0700
Message-ID: <201006141939.o5EJdMwh026914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774Ab0FNTj0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 15:39:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@vyatta.com, axboe@kernel.dk


The patch titled
     floppy: use atomic type for usage_count
has been added to the -mm tree.  Its filename is
     floppy-use-atomic-type-for-usage_count.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: floppy: use atomic type for usage_count
From: Stephen Hemminger <shemminger@vyatta.com>

The usage_count was being protected by a lock which was only there to
create an atomic counter.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   42 +++++++++++----------------------------
 1 file changed, 12 insertions(+), 30 deletions(-)

diff -puN drivers/block/floppy.c~floppy-use-atomic-type-for-usage_count drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-use-atomic-type-for-usage_count
+++ a/drivers/block/floppy.c
@@ -578,7 +578,7 @@ static void reset_fdc(void);
 #define NEED_1_RECAL	-2
 #define NEED_2_RECAL	-3
 
-static int usage_count;
+static atomic_t usage_count = ATOMIC_INIT(0);
 
 /* buffer related variables */
 static int buffer_track = -1;
@@ -860,7 +860,7 @@ static void set_fdc(int drive)
 /* locks the driver */
 static int _lock_fdc(int drive, bool interruptible, int line)
 {
-	if (!usage_count) {
+	if (atomic_read(&usage_count) == 0) {
 		pr_err("Trying to lock fdc while usage count=0 at line %d\n",
 		       line);
 		return -1;
@@ -2941,7 +2941,7 @@ static void do_fd_request(struct request
 		return;
 	}
 
-	if (usage_count == 0) {
+	if (atomic_read(&usage_count) == 0) {
 		pr_info("warning: usage count=0, current_req=%p exiting\n",
 			current_req);
 		pr_info("sect=%ld type=%x flags=%x\n",
@@ -3858,7 +3858,7 @@ static int floppy_revalidate(struct gend
 	if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
 	    test_bit(FD_VERIFY_BIT, &UDRS->flags) ||
 	    test_bit(drive, &fake_change) || NO_GEOM) {
-		if (usage_count == 0) {
+		if (atomic_read(&usage_count) == 0) {
 			pr_info("VFS: revalidate called on non-open device.\n");
 			return -EFAULT;
 		}
@@ -4357,7 +4357,7 @@ out_unreg_platform_dev:
 	platform_device_unregister(&floppy_device[drive]);
 out_flush_work:
 	flush_scheduled_work();
-	if (usage_count)
+	if (atomic_read(&usage_count))
 		floppy_release_irq_and_dma();
 out_unreg_region:
 	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
@@ -4374,8 +4374,6 @@ out_put_disk:
 	return err;
 }
 
-static DEFINE_SPINLOCK(floppy_usage_lock);
-
 static const struct io_region {
 	int offset;
 	int size;
@@ -4421,14 +4419,8 @@ static void floppy_release_regions(int f
 
 static int floppy_grab_irq_and_dma(void)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&floppy_usage_lock, flags);
-	if (usage_count++) {
-		spin_unlock_irqrestore(&floppy_usage_lock, flags);
+	if (atomic_inc_return(&usage_count) > 1)
 		return 0;
-	}
-	spin_unlock_irqrestore(&floppy_usage_lock, flags);
 
 	/*
 	 * We might have scheduled a free_irq(), wait it to
@@ -4439,9 +4431,7 @@ static int floppy_grab_irq_and_dma(void)
 	if (fd_request_irq()) {
 		DPRINT("Unable to grab IRQ%d for the floppy driver\n",
 		       FLOPPY_IRQ);
-		spin_lock_irqsave(&floppy_usage_lock, flags);
-		usage_count--;
-		spin_unlock_irqrestore(&floppy_usage_lock, flags);
+		atomic_dec(&usage_count);
 		return -1;
 	}
 	if (fd_request_dma()) {
@@ -4451,9 +4441,7 @@ static int floppy_grab_irq_and_dma(void)
 			use_virtual_dma = can_use_virtual_dma = 1;
 		if (!(can_use_virtual_dma & 1)) {
 			fd_free_irq();
-			spin_lock_irqsave(&floppy_usage_lock, flags);
-			usage_count--;
-			spin_unlock_irqrestore(&floppy_usage_lock, flags);
+			atomic_dec(&usage_count);
 			return -1;
 		}
 	}
@@ -4488,9 +4476,7 @@ cleanup:
 	fd_free_dma();
 	while (--fdc >= 0)
 		floppy_release_regions(fdc);
-	spin_lock_irqsave(&floppy_usage_lock, flags);
-	usage_count--;
-	spin_unlock_irqrestore(&floppy_usage_lock, flags);
+	atomic_dec(&usage_count);
 	return -1;
 }
 
@@ -4502,14 +4488,10 @@ static void floppy_release_irq_and_dma(v
 #endif
 	long tmpsize;
 	unsigned long tmpaddr;
-	unsigned long flags;
 
-	spin_lock_irqsave(&floppy_usage_lock, flags);
-	if (--usage_count) {
-		spin_unlock_irqrestore(&floppy_usage_lock, flags);
+	if (!atomic_dec_and_test(&usage_count))
 		return;
-	}
-	spin_unlock_irqrestore(&floppy_usage_lock, flags);
+
 	if (irqdma_allocated) {
 		fd_disable_dma();
 		fd_free_dma();
@@ -4602,7 +4584,7 @@ static void __exit floppy_module_exit(vo
 	del_timer_sync(&fd_timer);
 	blk_cleanup_queue(floppy_queue);
 
-	if (usage_count)
+	if (atomic_read(&usage_count))
 		floppy_release_irq_and_dma();
 
 	/* eject disk, if any */
_

Patches currently in -mm which might be from shemminger@vyatta.com are

linux-next.patch
floppy-initialize-debug-jiffies-offset.patch
floppy-remove-unnecessary-inlines.patch
floppy-silence-warning-during-disk-test.patch
floppy-use-atomic-type-for-usage_count.patch
floppy-cmos-attribute-should-be-static.patch
floppy-fix-signed-unsigned-warnings.patch
floppy-use-wait_event_interruptible.patch
floppy-use-warning-macros.patch
floppy-make-controller-const.patch

