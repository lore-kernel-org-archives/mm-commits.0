From: akpm@linux-foundation.org
Subject: + zram-drop-init_done-struct-zram-member.patch added to -mm tree
Date: Tue, 04 Feb 2014 14:19:10 -0800
Message-ID: <52f1675e.nK798tUKXY4ak3fR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933705AbaBDWTL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 17:19:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: + zram-drop-init_done-struct-zram-member.patch added to -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 14:19:10 -0800


The patch titled
     Subject: zram: drop `init_done' struct zram member
has been added to the -mm tree.  Its filename is
     zram-drop-init_done-struct-zram-member.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-drop-init_done-struct-zram-member.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-drop-init_done-struct-zram-member.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: drop `init_done' struct zram member

Introduce init_done() helper function which allows us to drop `init_done'
struct zram member.  init_done() uses the fact that ->init_done == 1
equals to ->meta != NULL.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   21 +++++++++++----------
 drivers/block/zram/zram_drv.h |    1 -
 2 files changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-drop-init_done-struct-zram-member drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-drop-init_done-struct-zram-member
+++ a/drivers/block/zram/zram_drv.c
@@ -42,6 +42,11 @@ static struct zram *zram_devices;
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
 
+static inline int init_done(struct zram *zram)
+{
+	return zram->meta != NULL;
+}
+
 static inline struct zram *dev_to_zram(struct device *dev)
 {
 	return (struct zram *)dev_to_disk(dev)->private_data;
@@ -60,7 +65,7 @@ static ssize_t initstate_show(struct dev
 {
 	struct zram *zram = dev_to_zram(dev);
 
-	return sprintf(buf, "%u\n", zram->init_done);
+	return sprintf(buf, "%u\n", init_done(zram));
 }
 
 static ssize_t num_reads_show(struct device *dev,
@@ -133,7 +138,7 @@ static ssize_t mem_used_total_show(struc
 	struct zram_meta *meta = zram->meta;
 
 	down_read(&zram->init_lock);
-	if (zram->init_done)
+	if (init_done(zram))
 		val = zs_get_total_size_bytes(meta->mem_pool);
 	up_read(&zram->init_lock);
 
@@ -546,14 +551,12 @@ static void zram_reset_device(struct zra
 	struct zram_meta *meta;
 
 	down_write(&zram->init_lock);
-	if (!zram->init_done) {
+	if (!init_done(zram)) {
 		up_write(&zram->init_lock);
 		return;
 	}
 
 	meta = zram->meta;
-	zram->init_done = 0;
-
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
 		unsigned long handle = meta->table[index].handle;
@@ -594,8 +597,6 @@ static void zram_init_device(struct zram
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
 
 	zram->meta = meta;
-	zram->init_done = 1;
-
 	pr_debug("Initialization done!\n");
 }
 
@@ -613,7 +614,7 @@ static ssize_t disksize_store(struct dev
 	disksize = PAGE_ALIGN(disksize);
 	meta = zram_meta_alloc(disksize);
 	down_write(&zram->init_lock);
-	if (zram->init_done) {
+	if (init_done(zram)) {
 		up_write(&zram->init_lock);
 		zram_meta_free(meta);
 		pr_info("Cannot change disksize for initialized device\n");
@@ -734,7 +735,7 @@ static void zram_make_request(struct req
 	struct zram *zram = queue->queuedata;
 
 	down_read(&zram->init_lock);
-	if (unlikely(!zram->init_done))
+	if (unlikely(!init_done(zram)))
 		goto error;
 
 	if (!valid_io_request(zram, bio)) {
@@ -857,7 +858,7 @@ static int create_device(struct zram *zr
 		goto out_free_disk;
 	}
 
-	zram->init_done = 0;
+	zram->meta = NULL;
 	return 0;
 
 out_free_disk:
diff -puN drivers/block/zram/zram_drv.h~zram-drop-init_done-struct-zram-member drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-drop-init_done-struct-zram-member
+++ a/drivers/block/zram/zram_drv.h
@@ -95,7 +95,6 @@ struct zram {
 	struct zram_meta *meta;
 	struct request_queue *queue;
 	struct gendisk *disk;
-	int init_done;
 	/* Prevent concurrent execution of device init, reset and R/W request */
 	struct rw_semaphore init_lock;
 	/*
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-drop-init_done-struct-zram-member.patch
zram-do-not-pass-rw-argument-to-__zram_make_request.patch
zram-remove-good-and-bad-compress-stats.patch
zram-use-atomic64_t-for-all-zram-stats.patch
zram-remove-zram-stats-code-duplication.patch
zram-report-failed-read-and-write-stats.patch
zram-drop-not-used-table-count-member.patch
zram-move-zram-size-warning-to-documentation.patch

