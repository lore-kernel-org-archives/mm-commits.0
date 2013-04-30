From: akpm@linux-foundation.org
Subject: [merged] mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:47:16 -0700
Message-ID: <20130430184716.8C8475A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:64354 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778Ab3D3SrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:47:18 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so84876qcr.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:47:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrick.wong@oracle.com, adrian.hunter@intel.com, axboe@kernel.dk, dedekind1@gmail.com, jack@suse.cz, luto@amacapital.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make snapshotting pages for stable writes a per-bio operation
has been removed from the -mm tree.  Its filename was
     mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Darrick J. Wong <darrick.wong@oracle.com>
Subject: mm: make snapshotting pages for stable writes a per-bio operation

Walking a bio's page mappings has proved problematic, so create a new bio
flag to indicate that a bio's data needs to be snapshotted in order to
guarantee stable pages during writeback.  Next, for the one user
(ext3/jbd) of snapshotting, hook all the places where writes can be
initiated without PG_writeback set, and set BIO_SNAP_STABLE there.

We must also flag journal "metadata" bios for stable writeout, since file
data can be written through the journal.  Finally, the MS_SNAP_STABLE
mount flag (only used by ext3) is now superfluous, so get rid of it.

[akpm@linux-foundation.org: rename _submit_bh()'s `flags' to `bio_flags', delobotomize the _submit_bh declaration]
[akpm@linux-foundation.org: teeny cleanup]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |    9 ++++++++-
 fs/ext3/super.c             |    1 -
 fs/jbd/commit.c             |   25 ++++++++++++++++++++++---
 include/linux/blk_types.h   |    3 ++-
 include/linux/buffer_head.h |    1 +
 include/uapi/linux/fs.h     |    1 -
 mm/bounce.c                 |   21 +--------------------
 mm/page-writeback.c         |    4 ----
 8 files changed, 34 insertions(+), 31 deletions(-)

diff -puN fs/buffer.c~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation fs/buffer.c
--- a/fs/buffer.c~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation
+++ a/fs/buffer.c
@@ -2949,7 +2949,7 @@ static void guard_bh_eod(int rw, struct
 	}
 }
 
-int submit_bh(int rw, struct buffer_head * bh)
+int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags)
 {
 	struct bio *bio;
 	int ret = 0;
@@ -2984,6 +2984,7 @@ int submit_bh(int rw, struct buffer_head
 
 	bio->bi_end_io = end_bio_bh_io_sync;
 	bio->bi_private = bh;
+	bio->bi_flags |= bio_flags;
 
 	/* Take care of bh's that straddle the end of the device */
 	guard_bh_eod(rw, bio, bh);
@@ -2997,6 +2998,12 @@ int submit_bh(int rw, struct buffer_head
 	bio_put(bio);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(_submit_bh);
+
+int submit_bh(int rw, struct buffer_head *bh)
+{
+	return _submit_bh(rw, bh, 0);
+}
 EXPORT_SYMBOL(submit_bh);
 
 /**
diff -puN fs/ext3/super.c~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation fs/ext3/super.c
--- a/fs/ext3/super.c~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation
+++ a/fs/ext3/super.c
@@ -2067,7 +2067,6 @@ static int ext3_fill_super (struct super
 		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_JOURNAL_DATA ? "journal":
 		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA ? "ordered":
 		"writeback");
-	sb->s_flags |= MS_SNAP_STABLE;
 
 	return 0;
 
diff -puN fs/jbd/commit.c~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation fs/jbd/commit.c
--- a/fs/jbd/commit.c~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation
+++ a/fs/jbd/commit.c
@@ -162,8 +162,17 @@ static void journal_do_submit_data(struc
 
 	for (i = 0; i < bufs; i++) {
 		wbuf[i]->b_end_io = end_buffer_write_sync;
-		/* We use-up our safety reference in submit_bh() */
-		submit_bh(write_op, wbuf[i]);
+		/*
+		 * Here we write back pagecache data that may be mmaped. Since
+		 * we cannot afford to clean the page and set PageWriteback
+		 * here due to lock ordering (page lock ranks above transaction
+		 * start), the data can change while IO is in flight. Tell the
+		 * block layer it should bounce the bio pages if stable data
+		 * during write is required.
+		 *
+		 * We use up our safety reference in submit_bh().
+		 */
+		_submit_bh(write_op, wbuf[i], 1 << BIO_SNAP_STABLE);
 	}
 }
 
@@ -667,7 +676,17 @@ start_journal_io:
 				clear_buffer_dirty(bh);
 				set_buffer_uptodate(bh);
 				bh->b_end_io = journal_end_buffer_io_sync;
-				submit_bh(write_op, bh);
+				/*
+				 * In data=journal mode, here we can end up
+				 * writing pagecache data that might be
+				 * mmapped. Since we can't afford to clean the
+				 * page and set PageWriteback (see the comment
+				 * near the other use of _submit_bh()), the
+				 * data can change while the write is in
+				 * flight.  Tell the block layer to bounce the
+				 * bio pages if stable pages are required.
+				 */
+				_submit_bh(write_op, bh, 1 << BIO_SNAP_STABLE);
 			}
 			cond_resched();
 
diff -puN include/linux/blk_types.h~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation include/linux/blk_types.h
--- a/include/linux/blk_types.h~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation
+++ a/include/linux/blk_types.h
@@ -111,12 +111,13 @@ struct bio {
 #define BIO_FS_INTEGRITY 9	/* fs owns integrity data, not block layer */
 #define BIO_QUIET	10	/* Make BIO Quiet */
 #define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
+#define BIO_SNAP_STABLE	12	/* bio data must be snapshotted during write */
 
 /*
  * Flags starting here get preserved by bio_reset() - this includes
  * BIO_POOL_IDX()
  */
-#define BIO_RESET_BITS	12
+#define BIO_RESET_BITS	13
 
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
diff -puN include/linux/buffer_head.h~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation
+++ a/include/linux/buffer_head.h
@@ -181,6 +181,7 @@ void ll_rw_block(int, int, struct buffer
 int sync_dirty_buffer(struct buffer_head *bh);
 int __sync_dirty_buffer(struct buffer_head *bh, int rw);
 void write_dirty_buffer(struct buffer_head *bh, int rw);
+int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags);
 int submit_bh(int, struct buffer_head *);
 void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize);
diff -puN include/uapi/linux/fs.h~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation include/uapi/linux/fs.h
--- a/include/uapi/linux/fs.h~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation
+++ a/include/uapi/linux/fs.h
@@ -88,7 +88,6 @@ struct inodes_stat_t {
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
 
 /* These sb flags are internal to the kernel */
-#define MS_SNAP_STABLE	(1<<27) /* Snapshot pages during writeback, if needed */
 #define MS_NOSEC	(1<<28)
 #define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)
diff -puN mm/bounce.c~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation mm/bounce.c
--- a/mm/bounce.c~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation
+++ a/mm/bounce.c
@@ -181,32 +181,13 @@ static void bounce_end_io_read_isa(struc
 #ifdef CONFIG_NEED_BOUNCE_POOL
 static int must_snapshot_stable_pages(struct request_queue *q, struct bio *bio)
 {
-	struct page *page;
-	struct backing_dev_info *bdi;
-	struct address_space *mapping;
-	struct bio_vec *from;
-	int i;
-
 	if (bio_data_dir(bio) != WRITE)
 		return 0;
 
 	if (!bdi_cap_stable_pages_required(&q->backing_dev_info))
 		return 0;
 
-	/*
-	 * Based on the first page that has a valid mapping, decide whether or
-	 * not we have to employ bounce buffering to guarantee stable pages.
-	 */
-	bio_for_each_segment(from, bio, i) {
-		page = from->bv_page;
-		mapping = page_mapping(page);
-		if (!mapping)
-			continue;
-		bdi = mapping->backing_dev_info;
-		return mapping->host->i_sb->s_flags & MS_SNAP_STABLE;
-	}
-
-	return 0;
+	return test_bit(BIO_SNAP_STABLE, &bio->bi_flags);
 }
 #else
 static int must_snapshot_stable_pages(struct request_queue *q, struct bio *bio)
diff -puN mm/page-writeback.c~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation mm/page-writeback.c
--- a/mm/page-writeback.c~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation
+++ a/mm/page-writeback.c
@@ -2311,10 +2311,6 @@ void wait_for_stable_page(struct page *p
 
 	if (!bdi_cap_stable_pages_required(bdi))
 		return;
-#ifdef CONFIG_NEED_BOUNCE_POOL
-	if (mapping->host->i_sb->s_flags & MS_SNAP_STABLE)
-		return;
-#endif /* CONFIG_NEED_BOUNCE_POOL */
 
 	wait_on_page_writeback(page);
 }
_

Patches currently in -mm which might be from darrick.wong@oracle.com are

origin.patch
linux-next.patch

