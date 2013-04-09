From: akpm@linux-foundation.org
Subject: + mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-v3.patch added to -mm tree
Date: Tue, 09 Apr 2013 14:00:18 -0700
Message-ID: <20130409210018.8EEF65A4252@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:56406 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936020Ab3DIVAU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Apr 2013 17:00:20 -0400
Received: by mail-ie0-f201.google.com with SMTP id a11so1872735iee.0
        for <mm-commits@vger.kernel.org>; Tue, 09 Apr 2013 14:00:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darrick.wong@oracle.com, adrian.hunter@intel.com, axboe@kernel.dk, dedekind1@gmail.com, jack@suse.cz, luto@amacapital.net


The patch titled
     Subject: mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-v3
has been added to the -mm tree.  Its filename is
     mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-v3

v3: Improve the documentation in jbd for why we're doing this, and clean up
some code.
[darrick.wong@oracle.com: Fold in a couple of small cleanups from akpm]

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c               |    2 +-
 fs/jbd/commit.c           |   21 ++++++++++++++++++++-
 include/linux/blk_types.h |    1 +
 3 files changed, 22 insertions(+), 2 deletions(-)

diff -puN fs/buffer.c~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-v3 fs/buffer.c
--- a/fs/buffer.c~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-v3
+++ a/fs/buffer.c
@@ -2999,7 +2999,7 @@ int _submit_bh(int rw, struct buffer_hea
 }
 EXPORT_SYMBOL_GPL(_submit_bh);
 
-int submit_bh(int rw, struct buffer_head * bh)
+int submit_bh(int rw, struct buffer_head *bh)
 {
 	return _submit_bh(rw, bh, 0);
 }
diff -puN fs/jbd/commit.c~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-v3 fs/jbd/commit.c
--- a/fs/jbd/commit.c~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-v3
+++ a/fs/jbd/commit.c
@@ -162,7 +162,16 @@ static void journal_do_submit_data(struc
 
 	for (i = 0; i < bufs; i++) {
 		wbuf[i]->b_end_io = end_buffer_write_sync;
-		/* We use-up our safety reference in submit_bh() */
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
 		_submit_bh(write_op, wbuf[i], 1 << BIO_SNAP_STABLE);
 	}
 }
@@ -667,6 +676,16 @@ start_journal_io:
 				clear_buffer_dirty(bh);
 				set_buffer_uptodate(bh);
 				bh->b_end_io = journal_end_buffer_io_sync;
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
 				_submit_bh(write_op, bh, 1 << BIO_SNAP_STABLE);
 			}
 			cond_resched();
diff -puN include/linux/blk_types.h~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-v3 include/linux/blk_types.h
--- a/include/linux/blk_types.h~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-v3
+++ a/include/linux/blk_types.h
@@ -112,6 +112,7 @@ struct bio {
 #define BIO_QUIET	10	/* Make BIO Quiet */
 #define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
 #define BIO_SNAP_STABLE	12	/* bio data must be snapshotted during write */
+
 /*
  * Flags starting here get preserved by bio_reset() - this includes
  * BIO_POOL_IDX()
_

Patches currently in -mm which might be from darrick.wong@oracle.com are

linux-next.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-v3.patch

