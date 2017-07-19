From: akpm@linux-foundation.org
Subject: + zram-read-page-from-backing-device.patch added to -mm tree
Date: Wed, 19 Jul 2017 16:08:23 -0700
Message-ID: <596fe667.Pk3UpREb8VCqZfVD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39014 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933487AbdGSXIY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 19:08:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, juno.choi@lge.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: read page from backing device
has been added to the -mm tree.  Its filename is
     zram-read-page-from-backing-device.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-read-page-from-backing-device.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-read-page-from-backing-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: read page from backing device

This patch enables read IO from backing device.  For the feature, it
implements two IO read functions to transfer data from backing storage.

One is asynchronous IO function and other is synchronous one.

A reason I need synchrnous IO is due to partial write which need to
complete read IO before the overwriting partial data.

We can make the partial IO's case asynchronous, too but at the moment, I
don't feel adding more complexity to support such rare use cases so want
to go with simple.

Link: http://lkml.kernel.org/r/1498459987-24562-9-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Juneho Choi <juno.choi@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |  123 ++++++++++++++++++++++++++++++--
 1 file changed, 118 insertions(+), 5 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-read-page-from-backing-device drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-read-page-from-backing-device
+++ a/drivers/block/zram/zram_drv.c
@@ -454,6 +454,95 @@ void zram_page_end_io(struct bio *bio)
 	bio_put(bio);
 }
 
+/*
+ * Returns 0 if the submission is successful.
+ */
+static int read_from_bdev_async(struct zram *zram, struct bio_vec *bvec,
+			unsigned long entry, struct bio *parent)
+{
+	struct bio *bio;
+
+	bio = bio_alloc(GFP_ATOMIC, 1);
+	if (!bio)
+		return -ENOMEM;
+
+	bio->bi_iter.bi_sector = entry * (PAGE_SIZE >> 9);
+	bio->bi_bdev = zram->bdev;
+	if (!bio_add_page(bio, bvec->bv_page, bvec->bv_len, bvec->bv_offset)) {
+		bio_put(bio);
+		return -EIO;
+	}
+
+	if (!parent) {
+		bio->bi_opf = REQ_OP_READ;
+		bio->bi_end_io = zram_page_end_io;
+	} else {
+		bio->bi_opf = parent->bi_opf;
+		bio_chain(bio, parent);
+	}
+
+	submit_bio(bio);
+	return 1;
+}
+
+struct zram_work {
+	struct work_struct work;
+	struct zram *zram;
+	unsigned long entry;
+	struct bio *bio;
+};
+
+#if PAGE_SIZE != 4096
+static void zram_sync_read(struct work_struct *work)
+{
+	struct bio_vec bvec;
+	struct zram_work *zw = container_of(work, struct zram_work, work);
+	struct zram *zram = zw->zram;
+	unsigned long entry = zw->entry;
+	struct bio *bio = zw->bio;
+
+	read_from_bdev_async(zram, &bvec, entry, bio);
+}
+
+/*
+ * Block layer want one ->make_request_fn to be active at a time
+ * so if we use chained IO with parent IO in same context,
+ * it's a deadlock. To avoid, it, it uses worker thread context.
+ */
+static int read_from_bdev_sync(struct zram *zram, struct bio_vec *bvec,
+				unsigned long entry, struct bio *bio)
+{
+	struct zram_work work;
+
+	work.zram = zram;
+	work.entry = entry;
+	work.bio = bio;
+
+	INIT_WORK_ONSTACK(&work.work, zram_sync_read);
+	queue_work(system_unbound_wq, &work.work);
+	flush_work(&work.work);
+	destroy_work_on_stack(&work.work);
+
+	return 1;
+}
+#else
+static int read_from_bdev_sync(struct zram *zram, struct bio_vec *bvec,
+				unsigned long entry, struct bio *bio)
+{
+	WARN_ON(1);
+	return -EIO;
+}
+#endif
+
+static int read_from_bdev(struct zram *zram, struct bio_vec *bvec,
+			unsigned long entry, struct bio *parent, bool sync)
+{
+	if (sync)
+		return read_from_bdev_sync(zram, bvec, entry, parent);
+	else
+		return read_from_bdev_async(zram, bvec, entry, parent);
+}
+
 static int write_to_bdev(struct zram *zram, struct bio_vec *bvec,
 					u32 index, struct bio *parent,
 					unsigned long *pentry)
@@ -514,6 +603,12 @@ static int write_to_bdev(struct zram *zr
 {
 	return -EIO;
 }
+
+static int read_from_bdev(struct zram *zram, struct bio_vec *bvec,
+			unsigned long entry, struct bio *parent, bool sync)
+{
+	return -EIO;
+}
 static void zram_wb_clear(struct zram *zram, u32 index) {}
 #endif
 
@@ -773,13 +868,31 @@ static void zram_free_page(struct zram *
 	zram_set_obj_size(zram, index, 0);
 }
 
-static int __zram_bvec_read(struct zram *zram, struct page *page, u32 index)
+static int __zram_bvec_read(struct zram *zram, struct page *page, u32 index,
+				struct bio *bio, bool partial_io)
 {
 	int ret;
 	unsigned long handle;
 	unsigned int size;
 	void *src, *dst;
 
+	if (zram_wb_enabled(zram)) {
+		zram_slot_lock(zram, index);
+		if (zram_test_flag(zram, index, ZRAM_WB)) {
+			struct bio_vec bvec;
+
+			zram_slot_unlock(zram, index);
+
+			bvec.bv_page = page;
+			bvec.bv_len = PAGE_SIZE;
+			bvec.bv_offset = 0;
+			return read_from_bdev(zram, &bvec,
+					zram_get_element(zram, index),
+					bio, partial_io);
+		}
+		zram_slot_unlock(zram, index);
+	}
+
 	if (zram_same_page_read(zram, index, page, 0, PAGE_SIZE))
 		return 0;
 
@@ -812,7 +925,7 @@ static int __zram_bvec_read(struct zram
 }
 
 static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
-				u32 index, int offset)
+				u32 index, int offset, struct bio *bio)
 {
 	int ret;
 	struct page *page;
@@ -825,7 +938,7 @@ static int zram_bvec_read(struct zram *z
 			return -ENOMEM;
 	}
 
-	ret = __zram_bvec_read(zram, page, index);
+	ret = __zram_bvec_read(zram, page, index, bio, is_partial_io(bvec));
 	if (unlikely(ret))
 		goto out;
 
@@ -987,7 +1100,7 @@ static int zram_bvec_write(struct zram *
 		if (!page)
 			return -ENOMEM;
 
-		ret = __zram_bvec_read(zram, page, index);
+		ret = __zram_bvec_read(zram, page, index, bio, true);
 		if (ret)
 			goto out;
 
@@ -1064,7 +1177,7 @@ static int zram_bvec_rw(struct zram *zra
 
 	if (!is_write) {
 		atomic64_inc(&zram->stats.num_reads);
-		ret = zram_bvec_read(zram, bvec, index, offset);
+		ret = zram_bvec_read(zram, bvec, index, offset, bio);
 		flush_dcache_page(bvec->bv_page);
 	} else {
 		atomic64_inc(&zram->stats.num_writes);
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-clean-up-duplicated-codes-in-__zram_bvec_write.patch
zram-inlining-zram_compress.patch
zram-rename-zram_decompress_page-with-__zram_bvec_read.patch
zram-add-interface-to-specify-backing-device.patch
zram-add-free-space-management-in-backing-device.patch
zram-identify-asynchronous-ios-return-value.patch
zram-write-incompressible-pages-to-backing-device.patch
zram-read-page-from-backing-device.patch
zram-add-config-and-doc-file-for-writeback-feature.patch

