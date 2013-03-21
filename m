From: akpm@linux-foundation.org
Subject: + block-prep-work-for-batch-completion.patch added to -mm tree
Date: Thu, 21 Mar 2013 15:38:50 -0700
Message-ID: <20130321223850.CF5805A421E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:59107 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3CUWiw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:38:52 -0400
Received: by mail-gg0-f201.google.com with SMTP id l2so310420ggn.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:38:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com


The patch titled
     Subject: block: prep work for batch completion
has been added to the -mm tree.  Its filename is
     block-prep-work-for-batch-completion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: block: prep work for batch completion

Add a struct batch_complete * argument to bi_end_io; infrastructure to
make use of it comes in the next patch.

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
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-flush.c                   |    3 ++-
 block/blk-lib.c                     |    3 ++-
 drivers/block/drbd/drbd_bitmap.c    |    2 +-
 drivers/block/drbd/drbd_worker.c    |    6 +++---
 drivers/block/drbd/drbd_wrappers.h  |    9 ++++++---
 drivers/block/floppy.c              |    3 ++-
 drivers/block/pktcdvd.c             |    9 ++++++---
 drivers/block/xen-blkback/blkback.c |    3 ++-
 drivers/md/dm-bufio.c               |    9 +++++----
 drivers/md/dm-crypt.c               |    3 ++-
 drivers/md/dm-io.c                  |    2 +-
 drivers/md/dm-snap.c                |    3 ++-
 drivers/md/dm-thin.c                |    3 ++-
 drivers/md/dm-verity.c              |    3 ++-
 drivers/md/dm.c                     |    6 ++++--
 drivers/md/faulty.c                 |    3 ++-
 drivers/md/md.c                     |    9 ++++++---
 drivers/md/multipath.c              |    3 ++-
 drivers/md/raid1.c                  |   15 ++++++++++-----
 drivers/md/raid10.c                 |   21 ++++++++++++++-------
 drivers/md/raid5.c                  |   15 ++++++++++-----
 drivers/target/target_core_iblock.c |    6 ++++--
 drivers/target/target_core_pscsi.c  |    3 ++-
 fs/bio-integrity.c                  |    3 ++-
 fs/bio.c                            |   14 +++++++++-----
 fs/btrfs/check-integrity.c          |   14 +++++++++-----
 fs/btrfs/compression.c              |    6 ++++--
 fs/btrfs/disk-io.c                  |    6 ++++--
 fs/btrfs/extent_io.c                |   12 ++++++++----
 fs/btrfs/inode.c                    |   13 ++++++++-----
 fs/btrfs/scrub.c                    |   18 ++++++++++++------
 fs/btrfs/volumes.c                  |    4 ++--
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
 include/linux/swap.h                |    3 ++-
 mm/bounce.c                         |   12 ++++++++----
 mm/page_io.c                        |    5 +++--
 55 files changed, 213 insertions(+), 125 deletions(-)

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
@@ -937,7 +937,7 @@ static void bm_aio_ctx_destroy(struct kr
 }
 
 /* bv_page may be a copy, or may be the original */
-static void bm_async_io_complete(struct bio *bio, int error)
+static void bm_async_io_complete(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct bm_aio_ctx *ctx = bio->bi_private;
 	struct drbd_conf *mdev = ctx->mdev;
diff -puN drivers/block/drbd/drbd_worker.c~block-prep-work-for-batch-completion drivers/block/drbd/drbd_worker.c
--- a/drivers/block/drbd/drbd_worker.c~block-prep-work-for-batch-completion
+++ a/drivers/block/drbd/drbd_worker.c
@@ -64,7 +64,7 @@ rwlock_t global_state_lock;
 /* used for synchronous meta data and bitmap IO
  * submitted by drbd_md_sync_page_io()
  */
-void drbd_md_io_complete(struct bio *bio, int error)
+void drbd_md_io_complete(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct drbd_md_io *md_io;
 	struct drbd_conf *mdev;
@@ -166,7 +166,7 @@ static void drbd_endio_write_sec_final(s
 /* writes on behalf of the partner, or resync writes,
  * "submitted" by the receiver.
  */
-void drbd_peer_request_endio(struct bio *bio, int error)
+void drbd_peer_request_endio(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct drbd_peer_request *peer_req = bio->bi_private;
 	struct drbd_conf *mdev = peer_req->w.mdev;
@@ -202,7 +202,7 @@ void drbd_peer_request_endio(struct bio
 
 /* read, readA or write requests on R_PRIMARY coming from drbd_make_request
  */
-void drbd_request_endio(struct bio *bio, int error)
+void drbd_request_endio(struct bio *bio, int error, struct batch_complete *batch)
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
@@ -3748,7 +3748,8 @@ static unsigned int floppy_check_events(
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
@@ -1005,7 +1005,8 @@ static void pkt_make_local_copy(struct p
 	}
 }
 
-static void pkt_end_io_read(struct bio *bio, int err)
+static void pkt_end_io_read(struct bio *bio, int err,
+			    struct batch_complete *batch)
 {
 	struct packet_data *pkt = bio->bi_private;
 	struct pktcdvd_device *pd = pkt->pd;
@@ -1023,7 +1024,8 @@ static void pkt_end_io_read(struct bio *
 	pkt_bio_finished(pd);
 }
 
-static void pkt_end_io_packet_write(struct bio *bio, int err)
+static void pkt_end_io_packet_write(struct bio *bio, int err,
+				    struct batch_complete *batch)
 {
 	struct packet_data *pkt = bio->bi_private;
 	struct pktcdvd_device *pd = pkt->pd;
@@ -2395,7 +2397,8 @@ static int pkt_close(struct gendisk *dis
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
@@ -740,7 +740,8 @@ static void __end_block_io_op(struct pen
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
@@ -472,7 +472,7 @@ static void dmio_complete(unsigned long
 {
 	struct dm_buffer *b = context;
 
-	b->bio.bi_end_io(&b->bio, error ? -EIO : 0);
+	b->bio.bi_end_io(&b->bio, error ? -EIO : 0, NULL);
 }
 
 static void use_dmio(struct dm_buffer *b, int rw, sector_t block,
@@ -503,7 +503,7 @@ static void use_dmio(struct dm_buffer *b
 
 	r = dm_io(&io_req, 1, &region, NULL);
 	if (r)
-		end_io(&b->bio, r);
+		end_io(&b->bio, r, NULL);
 }
 
 static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
@@ -570,7 +570,8 @@ static void submit_io(struct dm_buffer *
  * Set the error, clear B_WRITING bit and wake anyone who was waiting on
  * it.
  */
-static void write_endio(struct bio *bio, int error)
+static void write_endio(struct bio *bio, int error,
+			struct batch_complete *batch)
 {
 	struct dm_buffer *b = container_of(bio, struct dm_buffer, bio);
 
@@ -943,7 +944,7 @@ found_buffer:
  * The endio routine for reading: set the error, clear the bit and wake up
  * anyone waiting on the buffer.
  */
-static void read_endio(struct bio *bio, int error)
+static void read_endio(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct dm_buffer *b = container_of(bio, struct dm_buffer, bio);
 
diff -puN drivers/md/dm-crypt.c~block-prep-work-for-batch-completion drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~block-prep-work-for-batch-completion
+++ a/drivers/md/dm-crypt.c
@@ -930,7 +930,8 @@ static void crypt_dec_pending(struct dm_
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
@@ -1485,7 +1485,8 @@ static void start_copy(struct dm_snap_pe
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
@@ -616,7 +616,8 @@ static void dec_pending(struct dm_io *io
 	}
 }
 
-static void clone_endio(struct bio *bio, int error)
+static void clone_endio(struct bio *bio, int error,
+			struct batch_complete *batch)
 {
 	int r = 0;
 	struct dm_target_io *tio = bio->bi_private;
@@ -651,7 +652,8 @@ static void clone_endio(struct bio *bio,
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
@@ -388,7 +388,8 @@ EXPORT_SYMBOL(mddev_congested);
  * Generic flush handling for md
  */
 
-static void md_end_flush(struct bio *bio, int err)
+static void md_end_flush(struct bio *bio, int err,
+			 struct batch_complete *batch)
 {
 	struct md_rdev *rdev = bio->bi_private;
 	struct mddev *mddev = rdev->mddev;
@@ -765,7 +766,8 @@ void md_rdev_clear(struct md_rdev *rdev)
 }
 EXPORT_SYMBOL_GPL(md_rdev_clear);
 
-static void super_written(struct bio *bio, int error)
+static void super_written(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct md_rdev *rdev = bio->bi_private;
 	struct mddev *mddev = rdev->mddev;
@@ -816,7 +818,8 @@ void md_super_wait(struct mddev *mddev)
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
@@ -304,7 +304,8 @@ static int find_bio_disk(struct r1bio *r
 	return mirror;
 }
 
-static void raid1_end_read_request(struct bio *bio, int error)
+static void raid1_end_read_request(struct bio *bio, int error,
+				   struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r1bio *r1_bio = bio->bi_private;
@@ -389,7 +390,8 @@ static void r1_bio_write_done(struct r1b
 	}
 }
 
-static void raid1_end_write_request(struct bio *bio, int error)
+static void raid1_end_write_request(struct bio *bio, int error,
+				    struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r1bio *r1_bio = bio->bi_private;
@@ -1621,7 +1623,8 @@ abort:
 }
 
 
-static void end_sync_read(struct bio *bio, int error)
+static void end_sync_read(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct r1bio *r1_bio = bio->bi_private;
 
@@ -1639,7 +1642,8 @@ static void end_sync_read(struct bio *bi
 		reschedule_retry(r1_bio);
 }
 
-static void end_sync_write(struct bio *bio, int error)
+static void end_sync_write(struct bio *bio, int error,
+			   struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r1bio *r1_bio = bio->bi_private;
@@ -2059,7 +2063,8 @@ static void fix_read_error(struct r1conf
 	}
 }
 
-static void bi_complete(struct bio *bio, int error)
+static void bi_complete(struct bio *bio, int error,
+			struct batch_complete *batch)
 {
 	complete((struct completion *)bio->bi_private);
 }
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
@@ -1909,7 +1912,8 @@ abort:
 }
 
 
-static void end_sync_read(struct bio *bio, int error)
+static void end_sync_read(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct r10bio *r10_bio = bio->bi_private;
 	struct r10conf *conf = r10_bio->mddev->private;
@@ -1970,7 +1974,8 @@ static void end_sync_request(struct r10b
 	}
 }
 
-static void end_sync_write(struct bio *bio, int error)
+static void end_sync_write(struct bio *bio, int error,
+			   struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r10bio *r10_bio = bio->bi_private;
@@ -2531,7 +2536,8 @@ static void fix_read_error(struct r10con
 	}
 }
 
-static void bi_complete(struct bio *bio, int error)
+static void bi_complete(struct bio *bio, int error,
+			struct batch_complete *batch)
 {
 	complete((struct completion *)bio->bi_private);
 }
@@ -4628,7 +4634,8 @@ static int handle_reshape_read_error(str
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
@@ -556,9 +556,11 @@ static int use_new_offset(struct r5conf
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
@@ -1738,7 +1740,8 @@ static void shrink_stripes(struct r5conf
 	conf->slab_cache = NULL;
 }
 
-static void raid5_end_read_request(struct bio * bi, int error)
+static void raid5_end_read_request(struct bio * bi, int error,
+				   struct batch_complete *batch)
 {
 	struct stripe_head *sh = bi->bi_private;
 	struct r5conf *conf = sh->raid_conf;
@@ -1858,7 +1861,8 @@ static void raid5_end_read_request(struc
 	release_stripe(sh);
 }
 
-static void raid5_end_write_request(struct bio *bi, int error)
+static void raid5_end_write_request(struct bio *bi, int error,
+				    struct batch_complete *batch)
 {
 	struct stripe_head *sh = bi->bi_private;
 	struct r5conf *conf = sh->raid_conf;
@@ -3936,7 +3940,8 @@ static struct bio *remove_bio_from_retry
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
@@ -544,7 +544,8 @@ static void bio_integrity_verify_fn(stru
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
@@ -1136,7 +1136,8 @@ void bio_unmap_user(struct bio *bio)
 }
 EXPORT_SYMBOL(bio_unmap_user);
 
-static void bio_map_kern_endio(struct bio *bio, int err)
+static void bio_map_kern_endio(struct bio *bio, int err,
+			       struct batch_complete *batch)
 {
 	bio_put(bio);
 }
@@ -1208,7 +1209,8 @@ struct bio *bio_map_kern(struct request_
 }
 EXPORT_SYMBOL(bio_map_kern);
 
-static void bio_copy_kern_endio(struct bio *bio, int err)
+static void bio_copy_kern_endio(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	struct bio_vec *bvec;
 	const int read = bio_data_dir(bio) == READ;
@@ -1431,7 +1433,7 @@ void bio_endio(struct bio *bio, int erro
 	trace_block_bio_complete(bio, error);
 
 	if (bio->bi_end_io)
-		bio->bi_end_io(bio, error);
+		bio->bi_end_io(bio, error, NULL);
 }
 EXPORT_SYMBOL(bio_endio);
 
@@ -1446,7 +1448,8 @@ void bio_pair_release(struct bio_pair *b
 }
 EXPORT_SYMBOL(bio_pair_release);
 
-static void bio_pair_end_1(struct bio *bi, int err)
+static void bio_pair_end_1(struct bio *bi, int err,
+			   struct batch_complete *batch)
 {
 	struct bio_pair *bp = container_of(bi, struct bio_pair, bio1);
 
@@ -1456,7 +1459,8 @@ static void bio_pair_end_1(struct bio *b
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
@@ -153,7 +153,8 @@ fail:
  * The compressed pages are freed here, and it must be run
  * in process context
  */
-static void end_compressed_bio_read(struct bio *bio, int err)
+static void end_compressed_bio_read(struct bio *bio, int err,
+				    struct batch_complete *batch)
 {
 	struct compressed_bio *cb = bio->bi_private;
 	struct inode *inode;
@@ -263,7 +264,8 @@ static noinline void end_compressed_writ
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
@@ -669,7 +669,8 @@ static int btree_io_failed_hook(struct p
 	return -EIO;	/* we fixed nothing */
 }
 
-static void end_workqueue_bio(struct bio *bio, int err)
+static void end_workqueue_bio(struct bio *bio, int err,
+			      struct batch_complete *batch)
 {
 	struct end_io_wq *end_io_wq = bio->bi_private;
 	struct btrfs_fs_info *fs_info;
@@ -2951,7 +2952,8 @@ static int write_dev_supers(struct btrfs
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
@@ -1904,7 +1904,8 @@ static int free_io_failure(struct inode
 	return err;
 }
 
-static void repair_io_failure_callback(struct bio *bio, int err)
+static void repair_io_failure_callback(struct bio *bio, int err,
+				       struct batch_complete *batch)
 {
 	complete(bio->bi_private);
 }
@@ -2284,7 +2285,8 @@ int end_extent_writepage(struct page *pa
  * Scheduling is not allowed, so the extent state tree is expected
  * to have one and only one object corresponding to this IO.
  */
-static void end_bio_extent_writepage(struct bio *bio, int err)
+static void end_bio_extent_writepage(struct bio *bio, int err,
+				     struct batch_complete *batch)
 {
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct extent_io_tree *tree;
@@ -2330,7 +2332,8 @@ static void end_bio_extent_writepage(str
  * Scheduling is not allowed, so the extent state tree is expected
  * to have one and only one object corresponding to this IO.
  */
-static void end_bio_extent_readpage(struct bio *bio, int err)
+static void end_bio_extent_readpage(struct bio *bio, int err,
+				    struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
@@ -3154,7 +3157,8 @@ static void end_extent_buffer_writeback(
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
@@ -6900,7 +6900,8 @@ struct btrfs_dio_private {
 	struct bio *orig_bio;
 };
 
-static void btrfs_endio_direct_read(struct bio *bio, int err)
+static void btrfs_endio_direct_read(struct bio *bio, int err,
+				    struct batch_complete *batch)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
 	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
@@ -6954,10 +6955,11 @@ failed:
 	/* If we had a csum failure make sure to clear the uptodate flag */
 	if (err)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
-	dio_end_io(bio, err);
+	dio_end_io(bio, err, batch);
 }
 
-static void btrfs_endio_direct_write(struct bio *bio, int err)
+static void btrfs_endio_direct_write(struct bio *bio, int err,
+				     struct batch_complete *batch)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
 	struct inode *inode = dip->inode;
@@ -6999,7 +7001,7 @@ out_done:
 	/* If we had an error make sure to clear the uptodate flag */
 	if (err)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
-	dio_end_io(bio, err);
+	dio_end_io(bio, err, batch);
 }
 
 static int __btrfs_submit_bio_start_direct_io(struct inode *inode, int rw,
@@ -7013,7 +7015,8 @@ static int __btrfs_submit_bio_start_dire
 	return 0;
 }
 
-static void btrfs_end_dio_bio(struct bio *bio, int err)
+static void btrfs_end_dio_bio(struct bio *bio, int err,
+			      struct batch_complete *batch)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
 
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
@@ -1385,7 +1388,8 @@ static void scrub_recheck_block_checksum
 		sblock->checksum_error = 1;
 }
 
-static void scrub_complete_bio_end_io(struct bio *bio, int err)
+static void scrub_complete_bio_end_io(struct bio *bio, int err,
+				      struct batch_complete *batch)
 {
 	complete((struct completion *)bio->bi_private);
 }
@@ -1585,7 +1589,8 @@ static void scrub_wr_submit(struct scrub
 	btrfsic_submit_bio(WRITE, sbio->bio);
 }
 
-static void scrub_wr_bio_end_io(struct bio *bio, int err)
+static void scrub_wr_bio_end_io(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	struct scrub_bio *sbio = bio->bi_private;
 	struct btrfs_fs_info *fs_info = sbio->dev->dev_root->fs_info;
@@ -2055,7 +2060,8 @@ leave_nomem:
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
@@ -5018,7 +5018,7 @@ static unsigned int extract_stripe_index
 	return (unsigned int)((uintptr_t)bi_private) & 3;
 }
 
-static void btrfs_end_bio(struct bio *bio, int err)
+static void btrfs_end_bio(struct bio *bio, int err, struct batch_complete *batch)
 {
 	struct btrfs_bio *bbio = extract_bbio_from_bio_private(bio->bi_private);
 	int is_orig_bio = 0;
@@ -5075,7 +5075,7 @@ static void btrfs_end_bio(struct bio *bi
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
@@ -2884,7 +2884,8 @@ sector_t generic_block_bmap(struct addre
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
@@ -239,7 +239,8 @@ static void buffer_io_error(struct buffe
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
@@ -301,7 +301,7 @@ struct page *get_new_data_page(struct in
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
@@ -601,7 +601,8 @@ static const struct segment_allocation d
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
@@ -200,7 +200,8 @@ static void gfs2_end_log_write_bh(struct
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
@@ -2154,7 +2154,7 @@ static void lbmStartIO(struct lbuf * bp)
 	/* check if journaling to disk has been disabled */
 	if (log->no_integrity) {
 		bio->bi_size = 0;
-		lbmIODone(bio, 0);
+		lbmIODone(bio, 0, NULL);
 	} else {
 		submit_bio(WRITE_SYNC, bio);
 		INCREMENT(lmStat.submitted);
@@ -2192,7 +2192,7 @@ static int lbmIOWait(struct lbuf * bp, i
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
@@ -65,7 +66,8 @@ static int bdev_readpage(void *_sb, stru
 
 static DECLARE_WAIT_QUEUE_HEAD(wq);
 
-static void writeseg_end_io(struct bio *bio, int err)
+static void writeseg_end_io(struct bio *bio, int err,
+			    struct batch_complete *batch)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
@@ -171,7 +173,7 @@ static void bdev_writeseg(struct super_b
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
@@ -553,7 +553,7 @@ extern int bio_integrity_enabled(struct
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
@@ -2447,7 +2447,7 @@ enum {
 	DIO_SKIP_HOLES	= 0x02,
 };
 
-void dio_end_io(struct bio *bio, int error);
+void dio_end_io(struct bio *bio, int error, struct batch_complete *batch);
 
 ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, const struct iovec *iov, loff_t offset,
diff -puN include/linux/swap.h~block-prep-work-for-batch-completion include/linux/swap.h
--- a/include/linux/swap.h~block-prep-work-for-batch-completion
+++ a/include/linux/swap.h
@@ -331,7 +331,8 @@ static inline void mem_cgroup_uncharge_s
 extern int swap_readpage(struct page *);
 extern int swap_writepage(struct page *page, struct writeback_control *wbc);
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
 
-static void end_swap_bio_write(struct bio *bio, int err)
+static void end_swap_bio_write(struct bio *bio, int err,
+			       struct batch_complete *batch)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct page *page = bio->bi_io_vec[0].bv_page;
@@ -69,7 +70,7 @@ static void end_swap_bio_write(struct bi
 	bio_put(bio);
 }
 
-void end_swap_bio_read(struct bio *bio, int err)
+void end_swap_bio_read(struct bio *bio, int err, struct batch_complete *batch)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct page *page = bio->bi_io_vec[0].bv_page;
_

Patches currently in -mm which might be from koverstreet@google.com are

mm-remove-old-aio-use_mm-comment.patch
aio-remove-dead-code-from-aioh.patch
gadget-remove-only-user-of-aio-retry.patch
aio-remove-retry-based-aio.patch
char-add-aio_readwrite-to-dev-nullzero.patch
aio-kill-return-value-of-aio_complete.patch
aio-add-kiocb_cancel.patch
aio-move-private-stuff-out-of-aioh.patch
aio-dprintk-pr_debug.patch
aio-do-fget-after-aio_get_req.patch
aio-make-aio_put_req-lockless.patch
aio-refcounting-cleanup.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-flush_dcache_page.patch
aio-use-cancellation-list-lazily.patch
aio-change-reqs_active-to-include-unreaped-completions.patch
aio-kill-batch-allocation.patch
aio-kill-struct-aio_ring_info.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
block-prep-work-for-batch-completion.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

