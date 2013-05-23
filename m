From: akpm@linux-foundation.org
Subject: [to-be-updated] block-prep-work-for-batch-completion.patch
 removed from -mm tree
Date: Thu, 23 May 2013 13:50:27 -0700
Message-ID: <519e8113.TAyGHkGRuRfU2fr2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759403Ab3EWUu3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 16:50:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zab@redhat.com, viro@zeniv.linux.org.uk, tytso@mit.edu, smani@micron.com, sbradshaw@micron.com, rusty@rustcorp.com.au, mfasheh@suse.com, jmoyer@redhat.com, jlbec@evilplan.org, gregkh@linuxfoundation.org, bcrl@kvack.org, balbi@ti.com, axboe@kernel.dk, asamymuthupa@micron.com, koverstreet@google.com

Subject: [to-be-updated] block-prep-work-for-batch-completion.patch removed from -mm tree
To: koverstreet@google.com,asamymuthupa@micron.com,axboe@kernel.dk,balbi@ti.com,bcrl@kvack.org,gregkh@linuxfoundation.org,jlbec@evilplan.org,jmoyer@redhat.com,mfasheh@suse.com,rusty@rustcorp.com.au,sbradshaw@micron.com,smani@micron.com,tytso@mit.edu,viro@zeniv.linux.org.uk,zab@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 13:50:27 -0700


The patch titled
     Subject: block: prep work for batch completion
has been removed from the -mm tree.  Its filename was
     block-prep-work-for-batch-completion.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: block: prep work for batch completion

Add a struct batch_complete * argument to bi_end_io; infrastructure to
make use of it comes in the next patch.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: fix it for mm-allow-for-outstanding-swap-writeback-accounting.patch]
[akpm@linux-foundation.org: fix 1e9 unconverted sites]
Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-flush.c                   |    3 ++-
 block/blk-lib.c                     |    3 ++-
 drivers/block/drbd/drbd_bitmap.c    |    3 ++-
 drivers/block/drbd/drbd_worker.c    |    9 ++++++---
 drivers/block/drbd/drbd_wrappers.h  |    9 ++++++---
 drivers/block/floppy.c              |    3 ++-
 drivers/block/nvme-core.c           |    3 ++-
 drivers/block/pktcdvd.c             |    9 ++++++---
 drivers/block/xen-blkback/blkback.c |    3 ++-
 drivers/md/bcache/alloc.c           |    3 ++-
 drivers/md/bcache/btree.c           |    3 ++-
 drivers/md/bcache/debug.c           |    3 ++-
 drivers/md/bcache/io.c              |    6 ++++--
 drivers/md/bcache/journal.c         |    9 ++++++---
 drivers/md/bcache/movinggc.c        |    3 ++-
 drivers/md/bcache/request.c         |    9 ++++++---
 drivers/md/bcache/request.h         |    3 +--
 drivers/md/bcache/super.c           |   11 +++++++----
 drivers/md/bcache/writeback.c       |    8 +++++---
 drivers/md/dm-bufio.c               |    9 +++++----
 drivers/md/dm-cache-target.c        |    3 ++-
 drivers/md/dm-crypt.c               |    3 ++-
 drivers/md/dm-io.c                  |    2 +-
 drivers/md/dm-snap.c                |    3 ++-
 drivers/md/dm-thin.c                |    3 ++-
 drivers/md/dm-verity.c              |    3 ++-
 drivers/md/dm.c                     |    6 ++++--
 drivers/md/faulty.c                 |    3 ++-
 drivers/md/md.c                     |    9 ++++++---
 drivers/md/multipath.c              |    3 ++-
 drivers/md/raid1.c                  |   12 ++++++++----
 drivers/md/raid10.c                 |   18 ++++++++++++------
 drivers/md/raid5.c                  |   15 ++++++++++-----
 drivers/target/target_core_iblock.c |    6 ++++--
 drivers/target/target_core_pscsi.c  |    3 ++-
 fs/bio-integrity.c                  |    3 ++-
 fs/bio.c                            |   17 +++++++++++------
 fs/btrfs/check-integrity.c          |   14 +++++++++-----
 fs/btrfs/compression.c              |    6 ++++--
 fs/btrfs/disk-io.c                  |    6 ++++--
 fs/btrfs/extent_io.c                |   12 ++++++++----
 fs/btrfs/inode.c                    |   15 +++++++++------
 fs/btrfs/raid56.c                   |    9 ++++++---
 fs/btrfs/scrub.c                    |   18 ++++++++++++------
 fs/btrfs/volumes.c                  |    5 +++--
 fs/buffer.c                         |    3 ++-
 fs/direct-io.c                      |    9 +++------
 fs/ext4/page-io.c                   |    3 ++-
 fs/f2fs/data.c                      |    2 +-
 fs/f2fs/segment.c                   |    3 ++-
 fs/gfs2/lops.c                      |    3 ++-
 fs/gfs2/ops_fstype.c                |    3 ++-
 fs/hfsplus/wrapper.c                |    3 ++-
 fs/jfs/jfs_logmgr.c                 |    4 ++--
 fs/jfs/jfs_metapage.c               |    6 ++++--
 fs/logfs/dev_bdev.c                 |    8 +++++---
 fs/mpage.c                          |    2 +-
 fs/nfs/blocklayout/blocklayout.c    |   17 ++++++++++-------
 fs/nilfs2/segbuf.c                  |    3 ++-
 fs/ocfs2/cluster/heartbeat.c        |    4 ++--
 fs/xfs/xfs_aops.c                   |    3 ++-
 fs/xfs/xfs_buf.c                    |    3 ++-
 include/linux/bio.h                 |    2 +-
 include/linux/blk_types.h           |    3 ++-
 include/linux/fs.h                  |    2 +-
 include/linux/swap.h                |    9 ++++++---
 mm/bounce.c                         |   12 ++++++++----
 mm/page_io.c                        |    8 +++++---
 68 files changed, 270 insertions(+), 154 deletions(-)

diff -puN block/blk-flush.c~block-prep-work-for-batch-completion block/blk-flush.c
--- a/block/blk-flush.c~block-prep-work-for-batch-completion
+++ a/block/blk-flush.c
@@ -384,7 +384,8 @@ void blk_abort_flushes(struct request_qu
 	}
 }
 
-static void bio_end_flush(struct bio *bio, int err)
+static void bio_end_flush(struct bio *bio, int err,
+			  struct batch_complete *batch)
 {
 	if (err)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
diff -puN block/blk-lib.c~block-prep-work-for-batch-completion block/blk-lib.c
--- a/block/blk-lib.c~block-prep-work-for-batch-completion
+++ a/block/blk-lib.c
@@ -15,7 +15,8 @@ struct bio_batch {
 	struct completion	*wait;
 };
 
-static void bio_batch_end_io(struct bio *bio, int err)
+static void bio_batch_end_io(struct bio *bio, int err,
+			     struct batch_complete *batch)
 {
 	struct bio_batch *bb = bio->bi_private;
 
diff -puN drivers/block/drbd/drbd_bitmap.c~block-prep-work-for-batch-completion drivers/block/drbd/drbd_bitmap.c
--- a/drivers/block/drbd/drbd_bitmap.c~block-prep-work-for-batch-completion
+++ a/drivers/block/drbd/drbd_bitmap.c
@@ -948,7 +948,8 @@ static void bm_aio_ctx_destroy(struct kr
 }
 
 /* bv_page may be a copy, or may be the original */
-static void bm_async_io_complete(struct bio *bio, int error)
+static void bm_async_io_complete(struct bio *bio, int error,
+				 struct batch_complete *batch)
 {
 	struct bm_aio_ctx *ctx = bio->bi_private;
 	struct drbd_conf *mdev = ctx->mdev;
diff -puN drivers/block/drbd/drbd_worker.c~block-prep-work-for-batch-completion drivers/block/drbd/drbd_worker.c
--- a/drivers/block/drbd/drbd_worker.c~block-prep-work-for-batch-completion
+++ a/drivers/block/drbd/drbd_worker.c
@@ -64,7 +64,8 @@ rwlock_t global_state_lock;
 /* used for synchronous meta data and bitmap IO
  * submitted by drbd_md_sync_page_io()
  */
-void drbd_md_io_complete(struct bio *bio, int error)
+void drbd_md_io_complete(struct bio *bio, int error,
+			 struct batch_complete *batch)
 {
 	struct drbd_md_io *md_io;
 	struct drbd_conf *mdev;
@@ -167,7 +168,8 @@ static void drbd_endio_write_sec_final(s
 /* writes on behalf of the partner, or resync writes,
  * "submitted" by the receiver.
  */
-void drbd_peer_request_endio(struct bio *bio, int error)
+void drbd_peer_request_endio(struct bio *bio, int error,
+			     struct batch_complete *batch)
 {
 	struct drbd_peer_request *peer_req = bio->bi_private;
 	struct drbd_conf *mdev = peer_req->w.mdev;
@@ -203,7 +205,8 @@ void drbd_peer_request_endio(struct bio
 
 /* read, readA or write requests on R_PRIMARY coming from drbd_make_request
  */
-void drbd_request_endio(struct bio *bio, int error)
+void drbd_request_endio(struct bio *bio, int error,
+			struct batch_complete *batch)
 {
 	unsigned long flags;
 	struct drbd_request *req = bio->bi_private;
diff -puN drivers/block/drbd/drbd_wrappers.h~block-prep-work-for-batch-completion drivers/block/drbd/drbd_wrappers.h
--- a/drivers/block/drbd/drbd_wrappers.h~block-prep-work-for-batch-completion
+++ a/drivers/block/drbd/drbd_wrappers.h
@@ -20,9 +20,12 @@ static inline void drbd_set_my_capacity(
 #define drbd_bio_uptodate(bio) bio_flagged(bio, BIO_UPTODATE)
 
 /* bi_end_io handlers */
-extern void drbd_md_io_complete(struct bio *bio, int error);
-extern void drbd_peer_request_endio(struct bio *bio, int error);
-extern void drbd_request_endio(struct bio *bio, int error);
+extern void drbd_md_io_complete(struct bio *bio, int error,
+				struct batch_complete *batch);
+extern void drbd_peer_request_endio(struct bio *bio, int error,
+				    struct batch_complete *batch);
+extern void drbd_request_endio(struct bio *bio, int error,
+			       struct batch_complete *batch);
 
 /*
  * used to submit our private bio
diff -puN drivers/block/floppy.c~block-prep-work-for-batch-completion drivers/block/floppy.c
--- a/drivers/block/floppy.c~block-prep-work-for-batch-completion
+++ a/drivers/block/floppy.c
@@ -3746,7 +3746,8 @@ static unsigned int floppy_check_events(
  * a disk in the drive, and whether that disk is writable.
  */
 
-static void floppy_rb0_complete(struct bio *bio, int err)
+static void floppy_rb0_complete(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	complete((struct completion *)bio->bi_private);
 }
diff -puN drivers/block/pktcdvd.c~block-prep-work-for-batch-completion drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~block-prep-work-for-batch-completion
+++ a/drivers/block/pktcdvd.c
@@ -980,7 +980,8 @@ static void pkt_make_local_copy(struct p
 	}
 }
 
-static void pkt_end_io_read(struct bio *bio, int err)
+static void pkt_end_io_read(struct bio *bio, int err,
+			    struct batch_complete *batch)
 {
 	struct packet_data *pkt = bio->bi_private;
 	struct pktcdvd_device *pd = pkt->pd;
@@ -998,7 +999,8 @@ static void pkt_end_io_read(struct bio *
 	pkt_bio_finished(pd);
 }
 
-static void pkt_end_io_packet_write(struct bio *bio, int err)
+static void pkt_end_io_packet_write(struct bio *bio, int err,
+				    struct batch_complete *batch)
 {
 	struct packet_data *pkt = bio->bi_private;
 	struct pktcdvd_device *pd = pkt->pd;
@@ -2337,7 +2339,8 @@ static void pkt_close(struct gendisk *di
 }
 
 
-static void pkt_end_io_read_cloned(struct bio *bio, int err)
+static void pkt_end_io_read_cloned(struct bio *bio, int err,
+				   struct batch_complete *batch)
 {
 	struct packet_stacked_data *psd = bio->bi_private;
 	struct pktcdvd_device *pd = psd->pd;
diff -puN drivers/block/xen-blkback/blkback.c~block-prep-work-for-batch-completion drivers/block/xen-blkback/blkback.c
--- a/drivers/block/xen-blkback/blkback.c~block-prep-work-for-batch-completion
+++ a/drivers/block/xen-blkback/blkback.c
@@ -741,7 +741,8 @@ static void __end_block_io_op(struct pen
 /*
  * bio callback.
  */
-static void end_block_io_op(struct bio *bio, int error)
+static void end_block_io_op(struct bio *bio, int error,
+			    struct batch_complete *batch)
 {
 	__end_block_io_op(bio->bi_private, error);
 	bio_put(bio);
diff -puN drivers/md/dm-bufio.c~block-prep-work-for-batch-completion drivers/md/dm-bufio.c
--- a/drivers/md/dm-bufio.c~block-prep-work-for-batch-completion
+++ a/drivers/md/dm-bufio.c
@@ -494,7 +494,7 @@ static void dmio_complete(unsigned long
 {
 	struct dm_buffer *b = context;
 
-	b->bio.bi_end_io(&b->bio, error ? -EIO : 0);
+	b->bio.bi_end_io(&b->bio, error ? -EIO : 0, NULL);
 }
 
 static void use_dmio(struct dm_buffer *b, int rw, sector_t block,
@@ -525,7 +525,7 @@ static void use_dmio(struct dm_buffer *b
 
 	r = dm_io(&io_req, 1, &region, NULL);
 	if (r)
-		end_io(&b->bio, r);
+		end_io(&b->bio, r, NULL);
 }
 
 static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
@@ -592,7 +592,8 @@ static void submit_io(struct dm_buffer *
  * Set the error, clear B_WRITING bit and wake anyone who was waiting on
  * it.
  */
-static void write_endio(struct bio *bio, int error)
+static void write_endio(struct bio *bio, int error,
+			struct batch_complete *batch)
 {
 	struct dm_buffer *b = container_of(bio, struct dm_buffer, bio);
 
@@ -965,7 +966,7 @@ found_buffer:
  * The endio routine for reading: set the error, clear the bit and wake up
  * anyone waiting on the buffer.
  */
-static void read_endio(struct bio *bio, int error)
+static void read_endio(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct dm_buffer *b = container_of(bio, struct dm_buffer, bio);
 
diff -puN drivers/md/dm-cache-target.c~block-prep-work-for-batch-completion drivers/md/dm-cache-target.c
--- a/drivers/md/dm-cache-target.c~block-prep-work-for-batch-completion
+++ a/drivers/md/dm-cache-target.c
@@ -653,7 +653,8 @@ static void defer_writethrough_bio(struc
 	wake_worker(cache);
 }
 
-static void writethrough_endio(struct bio *bio, int err)
+static void writethrough_endio(struct bio *bio, int err,
+			       struct batch_complete *batch)
 {
 	struct per_bio_data *pb = get_per_bio_data(bio, PB_DATA_SIZE_WT);
 	bio->bi_end_io = pb->saved_bi_end_io;
diff -puN drivers/md/dm-crypt.c~block-prep-work-for-batch-completion drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~block-prep-work-for-batch-completion
+++ a/drivers/md/dm-crypt.c
@@ -929,7 +929,8 @@ static void crypt_dec_pending(struct dm_
  * The work is done per CPU global for all dm-crypt instances.
  * They should not depend on each other and do not block.
  */
-static void crypt_endio(struct bio *clone, int error)
+static void crypt_endio(struct bio *clone, int error,
+			struct batch_complete *batch)
 {
 	struct dm_crypt_io *io = clone->bi_private;
 	struct crypt_config *cc = io->cc;
diff -puN drivers/md/dm-io.c~block-prep-work-for-batch-completion drivers/md/dm-io.c
--- a/drivers/md/dm-io.c~block-prep-work-for-batch-completion
+++ a/drivers/md/dm-io.c
@@ -136,7 +136,7 @@ static void dec_count(struct io *io, uns
 	}
 }
 
-static void endio(struct bio *bio, int error)
+static void endio(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct io *io;
 	unsigned region;
diff -puN drivers/md/dm-snap.c~block-prep-work-for-batch-completion drivers/md/dm-snap.c
--- a/drivers/md/dm-snap.c~block-prep-work-for-batch-completion
+++ a/drivers/md/dm-snap.c
@@ -1486,7 +1486,8 @@ static void start_copy(struct dm_snap_pe
 	dm_kcopyd_copy(s->kcopyd_client, &src, 1, &dest, 0, copy_callback, pe);
 }
 
-static void full_bio_end_io(struct bio *bio, int error)
+static void full_bio_end_io(struct bio *bio, int error,
+			    struct batch_complete *batch)
 {
 	void *callback_data = bio->bi_private;
 
diff -puN drivers/md/dm-thin.c~block-prep-work-for-batch-completion drivers/md/dm-thin.c
--- a/drivers/md/dm-thin.c~block-prep-work-for-batch-completion
+++ a/drivers/md/dm-thin.c
@@ -553,7 +553,8 @@ static void copy_complete(int read_err,
 	spin_unlock_irqrestore(&pool->lock, flags);
 }
 
-static void overwrite_endio(struct bio *bio, int err)
+static void overwrite_endio(struct bio *bio, int err,
+			    struct batch_complete *batch)
 {
 	unsigned long flags;
 	struct dm_thin_endio_hook *h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));
diff -puN drivers/md/dm-verity.c~block-prep-work-for-batch-completion drivers/md/dm-verity.c
--- a/drivers/md/dm-verity.c~block-prep-work-for-batch-completion
+++ a/drivers/md/dm-verity.c
@@ -413,7 +413,8 @@ static void verity_work(struct work_stru
 	verity_finish_io(io, verity_verify_io(io));
 }
 
-static void verity_end_io(struct bio *bio, int error)
+static void verity_end_io(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct dm_verity_io *io = bio->bi_private;
 
diff -puN drivers/md/dm.c~block-prep-work-for-batch-completion drivers/md/dm.c
--- a/drivers/md/dm.c~block-prep-work-for-batch-completion
+++ a/drivers/md/dm.c
@@ -615,7 +615,8 @@ static void dec_pending(struct dm_io *io
 	}
 }
 
-static void clone_endio(struct bio *bio, int error)
+static void clone_endio(struct bio *bio, int error,
+			struct batch_complete *batch)
 {
 	int r = 0;
 	struct dm_target_io *tio = bio->bi_private;
@@ -650,7 +651,8 @@ static void clone_endio(struct bio *bio,
 /*
  * Partial completion handling for request-based dm
  */
-static void end_clone_bio(struct bio *clone, int error)
+static void end_clone_bio(struct bio *clone, int error,
+			  struct batch_complete *batch)
 {
 	struct dm_rq_clone_bio_info *info = clone->bi_private;
 	struct dm_rq_target_io *tio = info->tio;
diff -puN drivers/md/faulty.c~block-prep-work-for-batch-completion drivers/md/faulty.c
--- a/drivers/md/faulty.c~block-prep-work-for-batch-completion
+++ a/drivers/md/faulty.c
@@ -70,7 +70,8 @@
 #include <linux/seq_file.h>
 
 
-static void faulty_fail(struct bio *bio, int error)
+static void faulty_fail(struct bio *bio, int error,
+			struct batch_complete *batch)
 {
 	struct bio *b = bio->bi_private;
 
diff -puN drivers/md/md.c~block-prep-work-for-batch-completion drivers/md/md.c
--- a/drivers/md/md.c~block-prep-work-for-batch-completion
+++ a/drivers/md/md.c
@@ -379,7 +379,8 @@ EXPORT_SYMBOL(mddev_congested);
  * Generic flush handling for md
  */
 
-static void md_end_flush(struct bio *bio, int err)
+static void md_end_flush(struct bio *bio, int err,
+			 struct batch_complete *batch)
 {
 	struct md_rdev *rdev = bio->bi_private;
 	struct mddev *mddev = rdev->mddev;
@@ -756,7 +757,8 @@ void md_rdev_clear(struct md_rdev *rdev)
 }
 EXPORT_SYMBOL_GPL(md_rdev_clear);
 
-static void super_written(struct bio *bio, int error)
+static void super_written(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct md_rdev *rdev = bio->bi_private;
 	struct mddev *mddev = rdev->mddev;
@@ -807,7 +809,8 @@ void md_super_wait(struct mddev *mddev)
 	finish_wait(&mddev->sb_wait, &wq);
 }
 
-static void bi_complete(struct bio *bio, int error)
+static void bi_complete(struct bio *bio, int error,
+			struct batch_complete *batch)
 {
 	complete((struct completion*)bio->bi_private);
 }
diff -puN drivers/md/multipath.c~block-prep-work-for-batch-completion drivers/md/multipath.c
--- a/drivers/md/multipath.c~block-prep-work-for-batch-completion
+++ a/drivers/md/multipath.c
@@ -83,7 +83,8 @@ static void multipath_end_bh_io (struct
 	mempool_free(mp_bh, conf->pool);
 }
 
-static void multipath_end_request(struct bio *bio, int error)
+static void multipath_end_request(struct bio *bio, int error,
+				  struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct multipath_bh *mp_bh = bio->bi_private;
diff -puN drivers/md/raid1.c~block-prep-work-for-batch-completion drivers/md/raid1.c
--- a/drivers/md/raid1.c~block-prep-work-for-batch-completion
+++ a/drivers/md/raid1.c
@@ -294,7 +294,8 @@ static int find_bio_disk(struct r1bio *r
 	return mirror;
 }
 
-static void raid1_end_read_request(struct bio *bio, int error)
+static void raid1_end_read_request(struct bio *bio, int error,
+				   struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r1bio *r1_bio = bio->bi_private;
@@ -379,7 +380,8 @@ static void r1_bio_write_done(struct r1b
 	}
 }
 
-static void raid1_end_write_request(struct bio *bio, int error)
+static void raid1_end_write_request(struct bio *bio, int error,
+				    struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r1bio *r1_bio = bio->bi_private;
@@ -1613,7 +1615,8 @@ abort:
 }
 
 
-static void end_sync_read(struct bio *bio, int error)
+static void end_sync_read(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct r1bio *r1_bio = bio->bi_private;
 
@@ -1631,7 +1634,8 @@ static void end_sync_read(struct bio *bi
 		reschedule_retry(r1_bio);
 }
 
-static void end_sync_write(struct bio *bio, int error)
+static void end_sync_write(struct bio *bio, int error,
+			   struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r1bio *r1_bio = bio->bi_private;
diff -puN drivers/md/raid10.c~block-prep-work-for-batch-completion drivers/md/raid10.c
--- a/drivers/md/raid10.c~block-prep-work-for-batch-completion
+++ a/drivers/md/raid10.c
@@ -101,7 +101,8 @@ static int enough(struct r10conf *conf,
 static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 				int *skipped);
 static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio);
-static void end_reshape_write(struct bio *bio, int error);
+static void end_reshape_write(struct bio *bio, int error,
+			      struct batch_complete *batch);
 static void end_reshape(struct r10conf *conf);
 
 static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
@@ -358,7 +359,8 @@ static int find_bio_disk(struct r10conf
 	return r10_bio->devs[slot].devnum;
 }
 
-static void raid10_end_read_request(struct bio *bio, int error)
+static void raid10_end_read_request(struct bio *bio, int error,
+				    struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r10bio *r10_bio = bio->bi_private;
@@ -441,7 +443,8 @@ static void one_write_done(struct r10bio
 	}
 }
 
-static void raid10_end_write_request(struct bio *bio, int error)
+static void raid10_end_write_request(struct bio *bio, int error,
+				     struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r10bio *r10_bio = bio->bi_private;
@@ -1914,7 +1917,8 @@ abort:
 }
 
 
-static void end_sync_read(struct bio *bio, int error)
+static void end_sync_read(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct r10bio *r10_bio = bio->bi_private;
 	struct r10conf *conf = r10_bio->mddev->private;
@@ -1975,7 +1979,8 @@ static void end_sync_request(struct r10b
 	}
 }
 
-static void end_sync_write(struct bio *bio, int error)
+static void end_sync_write(struct bio *bio, int error,
+			   struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r10bio *r10_bio = bio->bi_private;
@@ -4600,7 +4605,8 @@ static int handle_reshape_read_error(str
 	return 0;
 }
 
-static void end_reshape_write(struct bio *bio, int error)
+static void end_reshape_write(struct bio *bio, int error,
+			      struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r10bio *r10_bio = bio->bi_private;
diff -puN drivers/md/raid5.c~block-prep-work-for-batch-completion drivers/md/raid5.c
--- a/drivers/md/raid5.c~block-prep-work-for-batch-completion
+++ a/drivers/md/raid5.c
@@ -532,9 +532,11 @@ static int use_new_offset(struct r5conf
 }
 
 static void
-raid5_end_read_request(struct bio *bi, int error);
+raid5_end_read_request(struct bio *bi, int error,
+		       struct batch_complete *batch);
 static void
-raid5_end_write_request(struct bio *bi, int error);
+raid5_end_write_request(struct bio *bi, int error,
+			struct batch_complete *batch);
 
 static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 {
@@ -1713,7 +1715,8 @@ static void shrink_stripes(struct r5conf
 	conf->slab_cache = NULL;
 }
 
-static void raid5_end_read_request(struct bio * bi, int error)
+static void raid5_end_read_request(struct bio *bi, int error,
+				   struct batch_complete *batch)
 {
 	struct stripe_head *sh = bi->bi_private;
 	struct r5conf *conf = sh->raid_conf;
@@ -1833,7 +1836,8 @@ static void raid5_end_read_request(struc
 	release_stripe(sh);
 }
 
-static void raid5_end_write_request(struct bio *bi, int error)
+static void raid5_end_write_request(struct bio *bi, int error,
+				    struct batch_complete *batch)
 {
 	struct stripe_head *sh = bi->bi_private;
 	struct r5conf *conf = sh->raid_conf;
@@ -3904,7 +3908,8 @@ static struct bio *remove_bio_from_retry
  *  first).
  *  If the read failed..
  */
-static void raid5_align_endio(struct bio *bi, int error)
+static void raid5_align_endio(struct bio *bi, int error,
+			      struct batch_complete *batch)
 {
 	struct bio* raid_bi  = bi->bi_private;
 	struct mddev *mddev;
diff -puN drivers/target/target_core_iblock.c~block-prep-work-for-batch-completion drivers/target/target_core_iblock.c
--- a/drivers/target/target_core_iblock.c~block-prep-work-for-batch-completion
+++ a/drivers/target/target_core_iblock.c
@@ -271,7 +271,8 @@ static void iblock_complete_cmd(struct s
 	kfree(ibr);
 }
 
-static void iblock_bio_done(struct bio *bio, int err)
+static void iblock_bio_done(struct bio *bio, int err,
+			    struct batch_complete *batch)
 {
 	struct se_cmd *cmd = bio->bi_private;
 	struct iblock_req *ibr = cmd->priv;
@@ -335,7 +336,8 @@ static void iblock_submit_bios(struct bi
 	blk_finish_plug(&plug);
 }
 
-static void iblock_end_io_flush(struct bio *bio, int err)
+static void iblock_end_io_flush(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	struct se_cmd *cmd = bio->bi_private;
 
diff -puN drivers/target/target_core_pscsi.c~block-prep-work-for-batch-completion drivers/target/target_core_pscsi.c
--- a/drivers/target/target_core_pscsi.c~block-prep-work-for-batch-completion
+++ a/drivers/target/target_core_pscsi.c
@@ -835,7 +835,8 @@ static ssize_t pscsi_show_configfs_dev_p
 	return bl;
 }
 
-static void pscsi_bi_endio(struct bio *bio, int error)
+static void pscsi_bi_endio(struct bio *bio, int error,
+			   struct batch_complete *batch)
 {
 	bio_put(bio);
 }
diff -puN fs/bio-integrity.c~block-prep-work-for-batch-completion fs/bio-integrity.c
--- a/fs/bio-integrity.c~block-prep-work-for-batch-completion
+++ a/fs/bio-integrity.c
@@ -510,7 +510,8 @@ static void bio_integrity_verify_fn(stru
  * in process context.	This function postpones completion
  * accordingly.
  */
-void bio_integrity_endio(struct bio *bio, int error)
+void bio_integrity_endio(struct bio *bio, int error,
+			 struct batch_complete *batch)
 {
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 
diff -puN fs/bio.c~block-prep-work-for-batch-completion fs/bio.c
--- a/fs/bio.c~block-prep-work-for-batch-completion
+++ a/fs/bio.c
@@ -760,7 +760,8 @@ struct submit_bio_ret {
 	int error;
 };
 
-static void submit_bio_wait_endio(struct bio *bio, int error)
+static void submit_bio_wait_endio(struct bio *bio, int error,
+				  struct batch_complete *batch)
 {
 	struct submit_bio_ret *ret = bio->bi_private;
 
@@ -1414,7 +1415,8 @@ void bio_unmap_user(struct bio *bio)
 }
 EXPORT_SYMBOL(bio_unmap_user);
 
-static void bio_map_kern_endio(struct bio *bio, int err)
+static void bio_map_kern_endio(struct bio *bio, int err,
+			       struct batch_complete *batch)
 {
 	bio_put(bio);
 }
@@ -1486,7 +1488,8 @@ struct bio *bio_map_kern(struct request_
 }
 EXPORT_SYMBOL(bio_map_kern);
 
-static void bio_copy_kern_endio(struct bio *bio, int err)
+static void bio_copy_kern_endio(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	struct bio_vec *bvec;
 	const int read = bio_data_dir(bio) == READ;
@@ -1707,7 +1710,7 @@ void bio_endio(struct bio *bio, int erro
 		error = -EIO;
 
 	if (bio->bi_end_io)
-		bio->bi_end_io(bio, error);
+		bio->bi_end_io(bio, error, NULL);
 }
 EXPORT_SYMBOL(bio_endio);
 
@@ -1722,7 +1725,8 @@ void bio_pair_release(struct bio_pair *b
 }
 EXPORT_SYMBOL(bio_pair_release);
 
-static void bio_pair_end_1(struct bio *bi, int err)
+static void bio_pair_end_1(struct bio *bi, int err,
+			   struct batch_complete *batch)
 {
 	struct bio_pair *bp = container_of(bi, struct bio_pair, bio1);
 
@@ -1732,7 +1736,8 @@ static void bio_pair_end_1(struct bio *b
 	bio_pair_release(bp);
 }
 
-static void bio_pair_end_2(struct bio *bi, int err)
+static void bio_pair_end_2(struct bio *bi, int err,
+			   struct batch_complete *batch)
 {
 	struct bio_pair *bp = container_of(bi, struct bio_pair, bio2);
 
diff -puN fs/btrfs/check-integrity.c~block-prep-work-for-batch-completion fs/btrfs/check-integrity.c
--- a/fs/btrfs/check-integrity.c~block-prep-work-for-batch-completion
+++ a/fs/btrfs/check-integrity.c
@@ -323,7 +323,8 @@ static void btrfsic_release_block_ctx(st
 static int btrfsic_read_block(struct btrfsic_state *state,
 			      struct btrfsic_block_data_ctx *block_ctx);
 static void btrfsic_dump_database(struct btrfsic_state *state);
-static void btrfsic_complete_bio_end_io(struct bio *bio, int err);
+static void btrfsic_complete_bio_end_io(struct bio *bio, int err,
+					struct batch_complete *batch);
 static int btrfsic_test_for_metadata(struct btrfsic_state *state,
 				     char **datav, unsigned int num_pages);
 static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
@@ -336,7 +337,8 @@ static int btrfsic_process_written_super
 		struct btrfsic_state *state,
 		struct btrfsic_block *const block,
 		struct btrfs_super_block *const super_hdr);
-static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status);
+static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status,
+			       struct batch_complete *batch);
 static void btrfsic_bh_end_io(struct buffer_head *bh, int uptodate);
 static int btrfsic_is_block_ref_by_superblock(const struct btrfsic_state *state,
 					      const struct btrfsic_block *block,
@@ -1751,7 +1753,8 @@ static int btrfsic_read_block(struct btr
 	return block_ctx->len;
 }
 
-static void btrfsic_complete_bio_end_io(struct bio *bio, int err)
+static void btrfsic_complete_bio_end_io(struct bio *bio, int err,
+					struct batch_complete *batch)
 {
 	complete((struct completion *)bio->bi_private);
 }
@@ -2294,7 +2297,8 @@ continue_loop:
 	goto again;
 }
 
-static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status)
+static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status,
+			       struct batch_complete *batch)
 {
 	struct btrfsic_block *block = (struct btrfsic_block *)bp->bi_private;
 	int iodone_w_error;
@@ -2342,7 +2346,7 @@ static void btrfsic_bio_end_io(struct bi
 		block = next_block;
 	} while (NULL != block);
 
-	bp->bi_end_io(bp, bio_error_status);
+	bp->bi_end_io(bp, bio_error_status, batch);
 }
 
 static void btrfsic_bh_end_io(struct buffer_head *bh, int uptodate)
diff -puN fs/btrfs/compression.c~block-prep-work-for-batch-completion fs/btrfs/compression.c
--- a/fs/btrfs/compression.c~block-prep-work-for-batch-completion
+++ a/fs/btrfs/compression.c
@@ -156,7 +156,8 @@ fail:
  * The compressed pages are freed here, and it must be run
  * in process context
  */
-static void end_compressed_bio_read(struct bio *bio, int err)
+static void end_compressed_bio_read(struct bio *bio, int err,
+				    struct batch_complete *batch)
 {
 	struct compressed_bio *cb = bio->bi_private;
 	struct inode *inode;
@@ -266,7 +267,8 @@ static noinline void end_compressed_writ
  * This also calls the writeback end hooks for the file pages so that
  * metadata and checksums can be updated in the file.
  */
-static void end_compressed_bio_write(struct bio *bio, int err)
+static void end_compressed_bio_write(struct bio *bio, int err,
+				     struct batch_complete *batch)
 {
 	struct extent_io_tree *tree;
 	struct compressed_bio *cb = bio->bi_private;
diff -puN fs/btrfs/disk-io.c~block-prep-work-for-batch-completion fs/btrfs/disk-io.c
--- a/fs/btrfs/disk-io.c~block-prep-work-for-batch-completion
+++ a/fs/btrfs/disk-io.c
@@ -685,7 +685,8 @@ static int btree_io_failed_hook(struct p
 	return -EIO;	/* we fixed nothing */
 }
 
-static void end_workqueue_bio(struct bio *bio, int err)
+static void end_workqueue_bio(struct bio *bio, int err,
+			      struct batch_complete *batch)
 {
 	struct end_io_wq *end_io_wq = bio->bi_private;
 	struct btrfs_fs_info *fs_info;
@@ -3074,7 +3075,8 @@ static int write_dev_supers(struct btrfs
  * endio for the write_dev_flush, this will wake anyone waiting
  * for the barrier when it is done
  */
-static void btrfs_end_empty_barrier(struct bio *bio, int err)
+static void btrfs_end_empty_barrier(struct bio *bio, int err,
+				    struct batch_complete *batch)
 {
 	if (err) {
 		if (err == -EOPNOTSUPP)
diff -puN fs/btrfs/extent_io.c~block-prep-work-for-batch-completion fs/btrfs/extent_io.c
--- a/fs/btrfs/extent_io.c~block-prep-work-for-batch-completion
+++ a/fs/btrfs/extent_io.c
@@ -2003,7 +2003,8 @@ static int free_io_failure(struct inode
 	return err;
 }
 
-static void repair_io_failure_callback(struct bio *bio, int err)
+static void repair_io_failure_callback(struct bio *bio, int err,
+				       struct batch_complete *batch)
 {
 	complete(bio->bi_private);
 }
@@ -2383,7 +2384,8 @@ int end_extent_writepage(struct page *pa
  * Scheduling is not allowed, so the extent state tree is expected
  * to have one and only one object corresponding to this IO.
  */
-static void end_bio_extent_writepage(struct bio *bio, int err)
+static void end_bio_extent_writepage(struct bio *bio, int err,
+				     struct batch_complete *batch)
 {
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct extent_io_tree *tree;
@@ -2431,7 +2433,8 @@ static void end_bio_extent_writepage(str
  * Scheduling is not allowed, so the extent state tree is expected
  * to have one and only one object corresponding to this IO.
  */
-static void end_bio_extent_readpage(struct bio *bio, int err)
+static void end_bio_extent_readpage(struct bio *bio, int err,
+				    struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
@@ -3270,7 +3273,8 @@ static void end_extent_buffer_writeback(
 	wake_up_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK);
 }
 
-static void end_bio_extent_buffer_writepage(struct bio *bio, int err)
+static void end_bio_extent_buffer_writepage(struct bio *bio, int err,
+					    struct batch_complete *batch)
 {
 	int uptodate = err == 0;
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
diff -puN fs/btrfs/inode.c~block-prep-work-for-batch-completion fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~block-prep-work-for-batch-completion
+++ a/fs/btrfs/inode.c
@@ -6939,7 +6939,8 @@ struct btrfs_dio_private {
 	struct bio *dio_bio;
 };
 
-static void btrfs_endio_direct_read(struct bio *bio, int err)
+static void btrfs_endio_direct_read(struct bio *bio, int err,
+				    struct batch_complete *batch)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
 	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
@@ -6993,11 +6994,12 @@ failed:
 	/* If we had a csum failure make sure to clear the uptodate flag */
 	if (err)
 		clear_bit(BIO_UPTODATE, &dio_bio->bi_flags);
-	dio_end_io(dio_bio, err);
+	dio_end_io(dio_bio, err, batch);
 	bio_put(bio);
 }
 
-static void btrfs_endio_direct_write(struct bio *bio, int err)
+static void btrfs_endio_direct_write(struct bio *bio, int err,
+				     struct batch_complete *batch)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
 	struct inode *inode = dip->inode;
@@ -7040,7 +7042,7 @@ out_done:
 	/* If we had an error make sure to clear the uptodate flag */
 	if (err)
 		clear_bit(BIO_UPTODATE, &dio_bio->bi_flags);
-	dio_end_io(dio_bio, err);
+	dio_end_io(dio_bio, err, batch);
 	bio_put(bio);
 }
 
@@ -7055,7 +7057,8 @@ static int __btrfs_submit_bio_start_dire
 	return 0;
 }
 
-static void btrfs_end_dio_bio(struct bio *bio, int err)
+static void btrfs_end_dio_bio(struct bio *bio, int err,
+			      struct batch_complete *batch)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
 
@@ -7081,7 +7084,7 @@ static void btrfs_end_dio_bio(struct bio
 		bio_io_error(dip->orig_bio);
 	} else {
 		set_bit(BIO_UPTODATE, &dip->dio_bio->bi_flags);
-		bio_endio(dip->orig_bio, 0);
+		bio_endio_batch(dip->orig_bio, 0, batch);
 	}
 out:
 	bio_put(bio);
diff -puN fs/btrfs/raid56.c~block-prep-work-for-batch-completion fs/btrfs/raid56.c
--- a/fs/btrfs/raid56.c~block-prep-work-for-batch-completion
+++ a/fs/btrfs/raid56.c
@@ -850,7 +850,8 @@ static void rbio_orig_end_io(struct btrf
  * end io function used by finish_rmw.  When we finally
  * get here, we've written a full stripe
  */
-static void raid_write_end_io(struct bio *bio, int err)
+static void raid_write_end_io(struct bio *bio, int err,
+			      struct batch_complete *batch)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
 
@@ -1384,7 +1385,8 @@ static void set_bio_pages_uptodate(struc
  * This will usually kick off finish_rmw once all the bios are read in, but it
  * may trigger parity reconstruction if we had any errors along the way
  */
-static void raid_rmw_end_io(struct bio *bio, int err)
+static void raid_rmw_end_io(struct bio *bio, int err,
+			    struct batch_complete *batch)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
 
@@ -1905,7 +1907,8 @@ cleanup_io:
  * This is called only for stripes we've read from disk to
  * reconstruct the parity.
  */
-static void raid_recover_end_io(struct bio *bio, int err)
+static void raid_recover_end_io(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
 
diff -puN fs/btrfs/scrub.c~block-prep-work-for-batch-completion fs/btrfs/scrub.c
--- a/fs/btrfs/scrub.c~block-prep-work-for-batch-completion
+++ a/fs/btrfs/scrub.c
@@ -200,7 +200,8 @@ static void scrub_recheck_block_checksum
 					 int is_metadata, int have_csum,
 					 const u8 *csum, u64 generation,
 					 u16 csum_size);
-static void scrub_complete_bio_end_io(struct bio *bio, int err);
+static void scrub_complete_bio_end_io(struct bio *bio, int err,
+				      struct batch_complete *batch);
 static int scrub_repair_block_from_good_copy(struct scrub_block *sblock_bad,
 					     struct scrub_block *sblock_good,
 					     int force_write);
@@ -223,7 +224,8 @@ static int scrub_pages(struct scrub_ctx
 		       u64 physical, struct btrfs_device *dev, u64 flags,
 		       u64 gen, int mirror_num, u8 *csum, int force,
 		       u64 physical_for_dev_replace);
-static void scrub_bio_end_io(struct bio *bio, int err);
+static void scrub_bio_end_io(struct bio *bio, int err,
+			     struct batch_complete *batch);
 static void scrub_bio_end_io_worker(struct btrfs_work *work);
 static void scrub_block_complete(struct scrub_block *sblock);
 static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
@@ -240,7 +242,8 @@ static void scrub_free_wr_ctx(struct scr
 static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 				    struct scrub_page *spage);
 static void scrub_wr_submit(struct scrub_ctx *sctx);
-static void scrub_wr_bio_end_io(struct bio *bio, int err);
+static void scrub_wr_bio_end_io(struct bio *bio, int err,
+				struct batch_complete *batch);
 static void scrub_wr_bio_end_io_worker(struct btrfs_work *work);
 static int write_page_nocow(struct scrub_ctx *sctx,
 			    u64 physical_for_dev_replace, struct page *page);
@@ -1384,7 +1387,8 @@ static void scrub_recheck_block_checksum
 		sblock->checksum_error = 1;
 }
 
-static void scrub_complete_bio_end_io(struct bio *bio, int err)
+static void scrub_complete_bio_end_io(struct bio *bio, int err,
+				      struct batch_complete *batch)
 {
 	complete((struct completion *)bio->bi_private);
 }
@@ -1584,7 +1588,8 @@ static void scrub_wr_submit(struct scrub
 	btrfsic_submit_bio(WRITE, sbio->bio);
 }
 
-static void scrub_wr_bio_end_io(struct bio *bio, int err)
+static void scrub_wr_bio_end_io(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	struct scrub_bio *sbio = bio->bi_private;
 	struct btrfs_fs_info *fs_info = sbio->dev->dev_root->fs_info;
@@ -2053,7 +2058,8 @@ leave_nomem:
 	return 0;
 }
 
-static void scrub_bio_end_io(struct bio *bio, int err)
+static void scrub_bio_end_io(struct bio *bio, int err,
+			     struct batch_complete *batch)
 {
 	struct scrub_bio *sbio = bio->bi_private;
 	struct btrfs_fs_info *fs_info = sbio->dev->dev_root->fs_info;
diff -puN fs/btrfs/volumes.c~block-prep-work-for-batch-completion fs/btrfs/volumes.c
--- a/fs/btrfs/volumes.c~block-prep-work-for-batch-completion
+++ a/fs/btrfs/volumes.c
@@ -5018,7 +5018,8 @@ int btrfs_rmap_block(struct btrfs_mappin
 	return 0;
 }
 
-static void btrfs_end_bio(struct bio *bio, int err)
+static void btrfs_end_bio(struct bio *bio, int err,
+			  struct batch_complete *batch)
 {
 	struct btrfs_bio *bbio = bio->bi_private;
 	int is_orig_bio = 0;
@@ -5073,7 +5074,7 @@ static void btrfs_end_bio(struct bio *bi
 		}
 		kfree(bbio);
 
-		bio_endio(bio, err);
+		bio_endio_batch(bio, err, batch);
 	} else if (!is_orig_bio) {
 		bio_put(bio);
 	}
diff -puN fs/buffer.c~block-prep-work-for-batch-completion fs/buffer.c
--- a/fs/buffer.c~block-prep-work-for-batch-completion
+++ a/fs/buffer.c
@@ -2882,7 +2882,8 @@ sector_t generic_block_bmap(struct addre
 }
 EXPORT_SYMBOL(generic_block_bmap);
 
-static void end_bio_bh_io_sync(struct bio *bio, int err)
+static void end_bio_bh_io_sync(struct bio *bio, int err,
+			       struct batch_complete *batch)
 {
 	struct buffer_head *bh = bio->bi_private;
 
diff -puN fs/direct-io.c~block-prep-work-for-batch-completion fs/direct-io.c
--- a/fs/direct-io.c~block-prep-work-for-batch-completion
+++ a/fs/direct-io.c
@@ -324,12 +324,12 @@ static void dio_bio_end_io(struct bio *b
  * so that the DIO specific endio actions are dealt with after the filesystem
  * has done it's completion work.
  */
-void dio_end_io(struct bio *bio, int error)
+void dio_end_io(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct dio *dio = bio->bi_private;
 
 	if (dio->is_async)
-		dio_bio_end_aio(bio, error);
+		dio_bio_end_aio(bio, error, batch);
 	else
 		dio_bio_end_io(bio, error);
 }
@@ -350,10 +350,7 @@ dio_bio_alloc(struct dio *dio, struct di
 
 	bio->bi_bdev = bdev;
 	bio->bi_sector = first_sector;
-	if (dio->is_async)
-		bio->bi_end_io = dio_bio_end_aio;
-	else
-		bio->bi_end_io = dio_bio_end_io;
+	bio->bi_end_io = dio_end_io;
 
 	sdio->bio = bio;
 	sdio->logical_offset_in_bio = sdio->cur_page_fs_offset;
diff -puN fs/ext4/page-io.c~block-prep-work-for-batch-completion fs/ext4/page-io.c
--- a/fs/ext4/page-io.c~block-prep-work-for-batch-completion
+++ a/fs/ext4/page-io.c
@@ -219,7 +219,8 @@ static void buffer_io_error(struct buffe
 			(unsigned long long)bh->b_blocknr);
 }
 
-static void ext4_end_bio(struct bio *bio, int error)
+static void ext4_end_bio(struct bio *bio, int error,
+			 struct batch_complete *batch)
 {
 	ext4_io_end_t *io_end = bio->bi_private;
 	struct inode *inode;
diff -puN fs/f2fs/data.c~block-prep-work-for-batch-completion fs/f2fs/data.c
--- a/fs/f2fs/data.c~block-prep-work-for-batch-completion
+++ a/fs/f2fs/data.c
@@ -338,7 +338,7 @@ repeat:
 	return page;
 }
 
-static void read_end_io(struct bio *bio, int err)
+static void read_end_io(struct bio *bio, int err, struct batch_complete *batch)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
diff -puN fs/f2fs/segment.c~block-prep-work-for-batch-completion fs/f2fs/segment.c
--- a/fs/f2fs/segment.c~block-prep-work-for-batch-completion
+++ a/fs/f2fs/segment.c
@@ -631,7 +631,8 @@ static const struct segment_allocation d
 	.allocate_segment = allocate_segment_by_default,
 };
 
-static void f2fs_end_io_write(struct bio *bio, int err)
+static void f2fs_end_io_write(struct bio *bio, int err,
+			      struct batch_complete *batch)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
diff -puN fs/gfs2/lops.c~block-prep-work-for-batch-completion fs/gfs2/lops.c
--- a/fs/gfs2/lops.c~block-prep-work-for-batch-completion
+++ a/fs/gfs2/lops.c
@@ -201,7 +201,8 @@ static void gfs2_end_log_write_bh(struct
  *
  */
 
-static void gfs2_end_log_write(struct bio *bio, int error)
+static void gfs2_end_log_write(struct bio *bio, int error,
+			       struct batch_complete *batch)
 {
 	struct gfs2_sbd *sdp = bio->bi_private;
 	struct bio_vec *bvec;
diff -puN fs/gfs2/ops_fstype.c~block-prep-work-for-batch-completion fs/gfs2/ops_fstype.c
--- a/fs/gfs2/ops_fstype.c~block-prep-work-for-batch-completion
+++ a/fs/gfs2/ops_fstype.c
@@ -155,7 +155,8 @@ static int gfs2_check_sb(struct gfs2_sbd
 	return -EINVAL;
 }
 
-static void end_bio_io_page(struct bio *bio, int error)
+static void end_bio_io_page(struct bio *bio, int error,
+			    struct batch_complete *batch)
 {
 	struct page *page = bio->bi_private;
 
diff -puN fs/hfsplus/wrapper.c~block-prep-work-for-batch-completion fs/hfsplus/wrapper.c
--- a/fs/hfsplus/wrapper.c~block-prep-work-for-batch-completion
+++ a/fs/hfsplus/wrapper.c
@@ -24,7 +24,8 @@ struct hfsplus_wd {
 	u16 embed_count;
 };
 
-static void hfsplus_end_io_sync(struct bio *bio, int err)
+static void hfsplus_end_io_sync(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	if (err)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
diff -puN fs/jfs/jfs_logmgr.c~block-prep-work-for-batch-completion fs/jfs/jfs_logmgr.c
--- a/fs/jfs/jfs_logmgr.c~block-prep-work-for-batch-completion
+++ a/fs/jfs/jfs_logmgr.c
@@ -2153,7 +2153,7 @@ static void lbmStartIO(struct lbuf * bp)
 	/* check if journaling to disk has been disabled */
 	if (log->no_integrity) {
 		bio->bi_size = 0;
-		lbmIODone(bio, 0);
+		lbmIODone(bio, 0, NULL);
 	} else {
 		submit_bio(WRITE_SYNC, bio);
 		INCREMENT(lmStat.submitted);
@@ -2191,7 +2191,7 @@ static int lbmIOWait(struct lbuf * bp, i
  *
  * executed at INTIODONE level
  */
-static void lbmIODone(struct bio *bio, int error)
+static void lbmIODone(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct lbuf *bp = bio->bi_private;
 	struct lbuf *nextbp, *tail;
diff -puN fs/jfs/jfs_metapage.c~block-prep-work-for-batch-completion fs/jfs/jfs_metapage.c
--- a/fs/jfs/jfs_metapage.c~block-prep-work-for-batch-completion
+++ a/fs/jfs/jfs_metapage.c
@@ -283,7 +283,8 @@ static void last_read_complete(struct pa
 	unlock_page(page);
 }
 
-static void metapage_read_end_io(struct bio *bio, int err)
+static void metapage_read_end_io(struct bio *bio, int err,
+				 struct batch_complete *batch)
 {
 	struct page *page = bio->bi_private;
 
@@ -338,7 +339,8 @@ static void last_write_complete(struct p
 	end_page_writeback(page);
 }
 
-static void metapage_write_end_io(struct bio *bio, int err)
+static void metapage_write_end_io(struct bio *bio, int err,
+				  struct batch_complete *batch)
 {
 	struct page *page = bio->bi_private;
 
diff -puN fs/logfs/dev_bdev.c~block-prep-work-for-batch-completion fs/logfs/dev_bdev.c
--- a/fs/logfs/dev_bdev.c~block-prep-work-for-batch-completion
+++ a/fs/logfs/dev_bdev.c
@@ -14,7 +14,8 @@
 
 #define PAGE_OFS(ofs) ((ofs) & (PAGE_SIZE-1))
 
-static void request_complete(struct bio *bio, int err)
+static void request_complete(struct bio *bio, int err,
+			     struct batch_complete *batch)
 {
 	complete((struct completion *)bio->bi_private);
 }
@@ -64,7 +65,8 @@ static int bdev_readpage(void *_sb, stru
 
 static DECLARE_WAIT_QUEUE_HEAD(wq);
 
-static void writeseg_end_io(struct bio *bio, int err)
+static void writeseg_end_io(struct bio *bio, int err,
+			    struct batch_complete *batch)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
@@ -168,7 +170,7 @@ static void bdev_writeseg(struct super_b
 }
 
 
-static void erase_end_io(struct bio *bio, int err) 
+static void erase_end_io(struct bio *bio, int err, struct batch_complete *batch)
 { 
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags); 
 	struct super_block *sb = bio->bi_private; 
diff -puN fs/mpage.c~block-prep-work-for-batch-completion fs/mpage.c
--- a/fs/mpage.c~block-prep-work-for-batch-completion
+++ a/fs/mpage.c
@@ -41,7 +41,7 @@
  * status of that page is hard.  See end_buffer_async_read() for the details.
  * There is no point in duplicating all that complexity.
  */
-static void mpage_end_io(struct bio *bio, int err)
+static void mpage_end_io(struct bio *bio, int err, struct batch_complete *batch)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
diff -puN fs/nfs/blocklayout/blocklayout.c~block-prep-work-for-batch-completion fs/nfs/blocklayout/blocklayout.c
--- a/fs/nfs/blocklayout/blocklayout.c~block-prep-work-for-batch-completion
+++ a/fs/nfs/blocklayout/blocklayout.c
@@ -143,7 +143,7 @@ bl_submit_bio(int rw, struct bio *bio)
 
 static struct bio *bl_alloc_init_bio(int npg, sector_t isect,
 				     struct pnfs_block_extent *be,
-				     void (*end_io)(struct bio *, int err),
+				     bio_end_io_t *end_io,
 				     struct parallel_io *par)
 {
 	struct bio *bio;
@@ -167,7 +167,7 @@ static struct bio *bl_alloc_init_bio(int
 static struct bio *do_add_page_to_bio(struct bio *bio, int npg, int rw,
 				      sector_t isect, struct page *page,
 				      struct pnfs_block_extent *be,
-				      void (*end_io)(struct bio *, int err),
+				      bio_end_io_t *end_io,
 				      struct parallel_io *par,
 				      unsigned int offset, int len)
 {
@@ -190,7 +190,7 @@ retry:
 static struct bio *bl_add_page_to_bio(struct bio *bio, int npg, int rw,
 				      sector_t isect, struct page *page,
 				      struct pnfs_block_extent *be,
-				      void (*end_io)(struct bio *, int err),
+				      bio_end_io_t *end_io,
 				      struct parallel_io *par)
 {
 	return do_add_page_to_bio(bio, npg, rw, isect, page, be,
@@ -198,7 +198,8 @@ static struct bio *bl_add_page_to_bio(st
 }
 
 /* This is basically copied from mpage_end_io_read */
-static void bl_end_io_read(struct bio *bio, int err)
+static void bl_end_io_read(struct bio *bio, int err,
+			   struct batch_complete *batch)
 {
 	struct parallel_io *par = bio->bi_private;
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -380,7 +381,8 @@ static void mark_extents_written(struct
 	}
 }
 
-static void bl_end_io_write_zero(struct bio *bio, int err)
+static void bl_end_io_write_zero(struct bio *bio, int err,
+				 struct batch_complete *batch)
 {
 	struct parallel_io *par = bio->bi_private;
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -408,7 +410,8 @@ static void bl_end_io_write_zero(struct
 	put_parallel(par);
 }
 
-static void bl_end_io_write(struct bio *bio, int err)
+static void bl_end_io_write(struct bio *bio, int err,
+			    struct batch_complete *batch)
 {
 	struct parallel_io *par = bio->bi_private;
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -487,7 +490,7 @@ map_block(struct buffer_head *bh, sector
 }
 
 static void
-bl_read_single_end_io(struct bio *bio, int error)
+bl_read_single_end_io(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct page *page = bvec->bv_page;
diff -puN fs/nilfs2/segbuf.c~block-prep-work-for-batch-completion fs/nilfs2/segbuf.c
--- a/fs/nilfs2/segbuf.c~block-prep-work-for-batch-completion
+++ a/fs/nilfs2/segbuf.c
@@ -338,7 +338,8 @@ void nilfs_add_checksums_on_logs(struct
 /*
  * BIO operations
  */
-static void nilfs_end_bio_write(struct bio *bio, int err)
+static void nilfs_end_bio_write(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct nilfs_segment_buffer *segbuf = bio->bi_private;
diff -puN fs/ocfs2/cluster/heartbeat.c~block-prep-work-for-batch-completion fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~block-prep-work-for-batch-completion
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -372,8 +372,8 @@ static void o2hb_wait_on_io(struct o2hb_
 	wait_for_completion(&wc->wc_io_complete);
 }
 
-static void o2hb_bio_end_io(struct bio *bio,
-			   int error)
+static void o2hb_bio_end_io(struct bio *bio, int error,
+			    struct batch_complete *batch)
 {
 	struct o2hb_bio_wait_ctxt *wc = bio->bi_private;
 
diff -puN fs/xfs/xfs_aops.c~block-prep-work-for-batch-completion fs/xfs/xfs_aops.c
--- a/fs/xfs/xfs_aops.c~block-prep-work-for-batch-completion
+++ a/fs/xfs/xfs_aops.c
@@ -380,7 +380,8 @@ xfs_imap_valid(
 STATIC void
 xfs_end_bio(
 	struct bio		*bio,
-	int			error)
+	int			error,
+	struct batch_complete *batch)
 {
 	xfs_ioend_t		*ioend = bio->bi_private;
 
diff -puN fs/xfs/xfs_buf.c~block-prep-work-for-batch-completion fs/xfs/xfs_buf.c
--- a/fs/xfs/xfs_buf.c~block-prep-work-for-batch-completion
+++ a/fs/xfs/xfs_buf.c
@@ -1224,7 +1224,8 @@ _xfs_buf_ioend(
 STATIC void
 xfs_buf_bio_end_io(
 	struct bio		*bio,
-	int			error)
+	int			error,
+	struct batch_complete *batch)
 {
 	xfs_buf_t		*bp = (xfs_buf_t *)bio->bi_private;
 
diff -puN include/linux/bio.h~block-prep-work-for-batch-completion include/linux/bio.h
--- a/include/linux/bio.h~block-prep-work-for-batch-completion
+++ a/include/linux/bio.h
@@ -580,7 +580,7 @@ extern int bio_integrity_enabled(struct
 extern int bio_integrity_set_tag(struct bio *, void *, unsigned int);
 extern int bio_integrity_get_tag(struct bio *, void *, unsigned int);
 extern int bio_integrity_prep(struct bio *);
-extern void bio_integrity_endio(struct bio *, int);
+extern void bio_integrity_endio(struct bio *, int, struct batch_complete *);
 extern void bio_integrity_advance(struct bio *, unsigned int);
 extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
 extern void bio_integrity_split(struct bio *, struct bio_pair *, int);
diff -puN include/linux/blk_types.h~block-prep-work-for-batch-completion include/linux/blk_types.h
--- a/include/linux/blk_types.h~block-prep-work-for-batch-completion
+++ a/include/linux/blk_types.h
@@ -16,7 +16,8 @@ struct page;
 struct block_device;
 struct io_context;
 struct cgroup_subsys_state;
-typedef void (bio_end_io_t) (struct bio *, int);
+struct batch_complete;
+typedef void (bio_end_io_t) (struct bio *, int, struct batch_complete *);
 typedef void (bio_destructor_t) (struct bio *);
 
 /*
diff -puN include/linux/fs.h~block-prep-work-for-batch-completion include/linux/fs.h
--- a/include/linux/fs.h~block-prep-work-for-batch-completion
+++ a/include/linux/fs.h
@@ -2453,7 +2453,7 @@ enum {
 	DIO_SKIP_HOLES	= 0x02,
 };
 
-void dio_end_io(struct bio *bio, int error);
+void dio_end_io(struct bio *bio, int error, struct batch_complete *batch);
 
 ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, const struct iovec *iov, loff_t offset,
diff -puN include/linux/swap.h~block-prep-work-for-batch-completion include/linux/swap.h
--- a/include/linux/swap.h~block-prep-work-for-batch-completion
+++ a/include/linux/swap.h
@@ -330,11 +330,14 @@ static inline void mem_cgroup_uncharge_s
 /* linux/mm/page_io.c */
 extern int swap_readpage(struct page *);
 extern int swap_writepage(struct page *page, struct writeback_control *wbc);
-extern void end_swap_bio_write(struct bio *bio, int err);
+extern void end_swap_bio_write(struct bio *bio, int err,
+			       struct batch_complete *batch);
 extern int __swap_writepage(struct page *page, struct writeback_control *wbc,
-	void (*end_write_func)(struct bio *, int));
+	void (*end_write_func)(struct bio *bio, int err,
+			       struct batch_complete *batch));
 extern int swap_set_page_dirty(struct page *page);
-extern void end_swap_bio_read(struct bio *bio, int err);
+extern void end_swap_bio_read(struct bio *bio, int err,
+			      struct batch_complete *batch);
 
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 		unsigned long nr_pages, sector_t start_block);
diff -puN mm/bounce.c~block-prep-work-for-batch-completion mm/bounce.c
--- a/mm/bounce.c~block-prep-work-for-batch-completion
+++ a/mm/bounce.c
@@ -147,12 +147,14 @@ static void bounce_end_io(struct bio *bi
 	bio_put(bio);
 }
 
-static void bounce_end_io_write(struct bio *bio, int err)
+static void bounce_end_io_write(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	bounce_end_io(bio, page_pool, err);
 }
 
-static void bounce_end_io_write_isa(struct bio *bio, int err)
+static void bounce_end_io_write_isa(struct bio *bio, int err,
+				    struct batch_complete *batch)
 {
 
 	bounce_end_io(bio, isa_page_pool, err);
@@ -168,12 +170,14 @@ static void __bounce_end_io_read(struct
 	bounce_end_io(bio, pool, err);
 }
 
-static void bounce_end_io_read(struct bio *bio, int err)
+static void bounce_end_io_read(struct bio *bio, int err,
+			       struct batch_complete *batch)
 {
 	__bounce_end_io_read(bio, page_pool, err);
 }
 
-static void bounce_end_io_read_isa(struct bio *bio, int err)
+static void bounce_end_io_read_isa(struct bio *bio, int err,
+				   struct batch_complete *batch)
 {
 	__bounce_end_io_read(bio, isa_page_pool, err);
 }
diff -puN mm/page_io.c~block-prep-work-for-batch-completion mm/page_io.c
--- a/mm/page_io.c~block-prep-work-for-batch-completion
+++ a/mm/page_io.c
@@ -43,7 +43,8 @@ static struct bio *get_swap_bio(gfp_t gf
 	return bio;
 }
 
-void end_swap_bio_write(struct bio *bio, int err)
+void end_swap_bio_write(struct bio *bio, int err,
+			struct batch_complete *batch)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct page *page = bio->bi_io_vec[0].bv_page;
@@ -69,7 +70,7 @@ void end_swap_bio_write(struct bio *bio,
 	bio_put(bio);
 }
 
-void end_swap_bio_read(struct bio *bio, int err)
+void end_swap_bio_read(struct bio *bio, int err, struct batch_complete *batch)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct page *page = bio->bi_io_vec[0].bv_page;
@@ -238,7 +239,8 @@ out:
 }
 
 int __swap_writepage(struct page *page, struct writeback_control *wbc,
-	void (*end_write_func)(struct bio *, int))
+	void (*end_write_func)(struct bio *bio, int err,
+			       struct batch_complete *batch))
 {
 	struct bio *bio;
 	int ret = 0, rw = WRITE;
diff -puN drivers/md/bcache/btree.c~block-prep-work-for-batch-completion drivers/md/bcache/btree.c
--- a/drivers/md/bcache/btree.c~block-prep-work-for-batch-completion
+++ a/drivers/md/bcache/btree.c
@@ -134,7 +134,8 @@ static uint64_t btree_csum_set(struct bt
 	return crc ^ 0xffffffffffffffffULL;
 }
 
-static void btree_bio_endio(struct bio *bio, int error)
+static void btree_bio_endio(struct bio *bio, int error,
+			    struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	struct btree *b = container_of(cl, struct btree, io.cl);
diff -puN drivers/md/bcache/io.c~block-prep-work-for-batch-completion drivers/md/bcache/io.c
--- a/drivers/md/bcache/io.c~block-prep-work-for-batch-completion
+++ a/drivers/md/bcache/io.c
@@ -9,7 +9,8 @@
 #include "bset.h"
 #include "debug.h"
 
-static void bch_bi_idx_hack_endio(struct bio *bio, int error)
+static void bch_bi_idx_hack_endio(struct bio *bio, int error,
+				  struct batch_complete *batch)
 {
 	struct bio *p = bio->bi_private;
 
@@ -206,7 +207,8 @@ static void bch_bio_submit_split_done(st
 	mempool_free(s, s->p->bio_split_hook);
 }
 
-static void bch_bio_submit_split_endio(struct bio *bio, int error)
+static void bch_bio_submit_split_endio(struct bio *bio, int error,
+				       struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	struct bio_split_hook *s = container_of(cl, struct bio_split_hook, cl);
diff -puN drivers/md/bcache/journal.c~block-prep-work-for-batch-completion drivers/md/bcache/journal.c
--- a/drivers/md/bcache/journal.c~block-prep-work-for-batch-completion
+++ a/drivers/md/bcache/journal.c
@@ -22,7 +22,8 @@
  * bit.
  */
 
-static void journal_read_endio(struct bio *bio, int error)
+static void journal_read_endio(struct bio *bio, int error,
+			       struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	closure_put(cl);
@@ -390,7 +391,8 @@ found:
 
 #define last_seq(j)	((j)->seq - fifo_used(&(j)->pin) + 1)
 
-static void journal_discard_endio(struct bio *bio, int error)
+static void journal_discard_endio(struct bio *bio, int error,
+				  struct batch_complete *batch)
 {
 	struct journal_device *ja =
 		container_of(bio, struct journal_device, discard_bio);
@@ -535,7 +537,8 @@ void bch_journal_next(struct journal *j)
 		pr_debug("journal_pin full (%zu)", fifo_used(&j->pin));
 }
 
-static void journal_write_endio(struct bio *bio, int error)
+static void journal_write_endio(struct bio *bio, int error,
+				struct batch_complete *batch)
 {
 	struct journal_write *w = bio->bi_private;
 
diff -puN drivers/md/bcache/movinggc.c~block-prep-work-for-batch-completion drivers/md/bcache/movinggc.c
--- a/drivers/md/bcache/movinggc.c~block-prep-work-for-batch-completion
+++ a/drivers/md/bcache/movinggc.c
@@ -61,7 +61,8 @@ static void write_moving_finish(struct c
 	closure_return_with_destructor(cl, moving_io_destructor);
 }
 
-static void read_moving_endio(struct bio *bio, int error)
+static void read_moving_endio(struct bio *bio, int error,
+			      struct batch_complete *batch)
 {
 	struct moving_io *io = container_of(bio->bi_private,
 					    struct moving_io, s.cl);
diff -puN drivers/md/bcache/request.c~block-prep-work-for-batch-completion drivers/md/bcache/request.c
--- a/drivers/md/bcache/request.c~block-prep-work-for-batch-completion
+++ a/drivers/md/bcache/request.c
@@ -456,7 +456,8 @@ static void bch_insert_data_error(struct
 	bch_journal(cl);
 }
 
-static void bch_insert_data_endio(struct bio *bio, int error)
+static void bch_insert_data_endio(struct bio *bio, int error,
+				  struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	struct btree_op *op = container_of(cl, struct btree_op, cl);
@@ -621,7 +622,8 @@ void bch_btree_insert_async(struct closu
 
 /* Common code for the make_request functions */
 
-static void request_endio(struct bio *bio, int error)
+static void request_endio(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 
@@ -636,7 +638,8 @@ static void request_endio(struct bio *bi
 	closure_put(cl);
 }
 
-void bch_cache_read_endio(struct bio *bio, int error)
+void bch_cache_read_endio(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct bbio *b = container_of(bio, struct bbio, bio);
 	struct closure *cl = bio->bi_private;
diff -puN drivers/md/bcache/request.h~block-prep-work-for-batch-completion drivers/md/bcache/request.h
--- a/drivers/md/bcache/request.h~block-prep-work-for-batch-completion
+++ a/drivers/md/bcache/request.h
@@ -29,11 +29,10 @@ struct search {
 	struct btree_op		op;
 };
 
-void bch_cache_read_endio(struct bio *, int);
+void bch_cache_read_endio(struct bio *, int, struct batch_complete *batch);
 int bch_get_congested(struct cache_set *);
 void bch_insert_data(struct closure *cl);
 void bch_btree_insert_async(struct closure *);
-void bch_cache_read_endio(struct bio *, int);
 
 void bch_open_buckets_free(struct cache_set *);
 int bch_open_buckets_alloc(struct cache_set *);
diff -puN drivers/md/bcache/super.c~block-prep-work-for-batch-completion drivers/md/bcache/super.c
--- a/drivers/md/bcache/super.c~block-prep-work-for-batch-completion
+++ a/drivers/md/bcache/super.c
@@ -224,7 +224,8 @@ err:
 	return err;
 }
 
-static void write_bdev_super_endio(struct bio *bio, int error)
+static void write_bdev_super_endio(struct bio *bio, int error,
+				   struct batch_complete *batch)
 {
 	struct cached_dev *dc = bio->bi_private;
 	/* XXX: error checking */
@@ -285,7 +286,8 @@ void bch_write_bdev_super(struct cached_
 	closure_return(cl);
 }
 
-static void write_super_endio(struct bio *bio, int error)
+static void write_super_endio(struct bio *bio, int error,
+			      struct batch_complete *batch)
 {
 	struct cache *ca = bio->bi_private;
 
@@ -326,7 +328,7 @@ void bcache_write_super(struct cache_set
 
 /* UUID io */
 
-static void uuid_endio(struct bio *bio, int error)
+static void uuid_endio(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	struct cache_set *c = container_of(cl, struct cache_set, uuid_write.cl);
@@ -490,7 +492,8 @@ static struct uuid_entry *uuid_find_empt
  * disk.
  */
 
-static void prio_endio(struct bio *bio, int error)
+static void prio_endio(struct bio *bio, int error,
+		       struct batch_complete *batch)
 {
 	struct cache *ca = bio->bi_private;
 
diff -puN drivers/md/bcache/writeback.c~block-prep-work-for-batch-completion drivers/md/bcache/writeback.c
--- a/drivers/md/bcache/writeback.c~block-prep-work-for-batch-completion
+++ a/drivers/md/bcache/writeback.c
@@ -253,7 +253,8 @@ static void write_dirty_finish(struct cl
 	closure_return_with_destructor(cl, dirty_io_destructor);
 }
 
-static void dirty_endio(struct bio *bio, int error)
+static void dirty_endio(struct bio *bio, int error,
+			struct batch_complete *batch)
 {
 	struct keybuf_key *w = bio->bi_private;
 	struct dirty_io *io = w->private;
@@ -281,7 +282,8 @@ static void write_dirty(struct closure *
 	continue_at(cl, write_dirty_finish, dirty_wq);
 }
 
-static void read_dirty_endio(struct bio *bio, int error)
+static void read_dirty_endio(struct bio *bio, int error,
+			     struct batch_complete *batch)
 {
 	struct keybuf_key *w = bio->bi_private;
 	struct dirty_io *io = w->private;
@@ -289,7 +291,7 @@ static void read_dirty_endio(struct bio
 	bch_count_io_errors(PTR_CACHE(io->dc->disk.c, &w->key, 0),
 			    error, "reading dirty data from cache");
 
-	dirty_endio(bio, error);
+	dirty_endio(bio, error, NULL);
 }
 
 static void read_dirty_submit(struct closure *cl)
diff -puN drivers/md/bcache/alloc.c~block-prep-work-for-batch-completion drivers/md/bcache/alloc.c
--- a/drivers/md/bcache/alloc.c~block-prep-work-for-batch-completion
+++ a/drivers/md/bcache/alloc.c
@@ -156,7 +156,8 @@ static void discard_finish(struct work_s
 	closure_put(&ca->set->cl);
 }
 
-static void discard_endio(struct bio *bio, int error)
+static void discard_endio(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct discard *d = container_of(bio, struct discard, bio);
 	schedule_work(&d->work);
diff -puN drivers/md/bcache/debug.c~block-prep-work-for-batch-completion drivers/md/bcache/debug.c
--- a/drivers/md/bcache/debug.c~block-prep-work-for-batch-completion
+++ a/drivers/md/bcache/debug.c
@@ -177,7 +177,8 @@ void bch_btree_verify(struct btree *b, s
 	mutex_unlock(&b->c->verify_lock);
 }
 
-static void data_verify_endio(struct bio *bio, int error)
+static void data_verify_endio(struct bio *bio, int error,
+			      struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	closure_put(cl);
diff -puN drivers/block/nvme-core.c~block-prep-work-for-batch-completion drivers/block/nvme-core.c
--- a/drivers/block/nvme-core.c~block-prep-work-for-batch-completion
+++ a/drivers/block/nvme-core.c
@@ -413,7 +413,8 @@ struct nvme_bio_pair {
 	atomic_t cnt;
 };
 
-static void nvme_bio_pair_endio(struct bio *bio, int err)
+static void nvme_bio_pair_endio(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	struct nvme_bio_pair *bp = bio->bi_private;
 
_

Patches currently in -mm which might be from koverstreet@google.com are

linux-next.patch
block-aio-batch-completion-for-bios-kiocbs.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-convert-the-ioctx-list-to-radix-tree.patch

