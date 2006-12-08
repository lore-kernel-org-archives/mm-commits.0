From: akpm@osdl.org
Subject: - dm-mpath-use-noflush-suspending.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:15:21 -0800
Message-ID: <200612082015.kB8KFLdA003291@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60003 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947099AbWLHUPa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:15:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k-ueda@ct.jp.nec.com, agk@redhat.com, j-nomura@ce.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     dm: mpath: use noflush suspending
has been removed from the -mm tree.  Its filename was
     dm-mpath-use-noflush-suspending.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm: mpath: use noflush suspending
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

Implement the pushback feature for the multipath target.

The pushback request is used when:
  1) there are no valid paths;
  2) queue_if_no_path was set;
  3) a suspend is being issued with the DMF_NOFLUSH_SUSPENDING flag.
     Otherwise bios are returned to applications with -EIO.

To check whether queue_if_no_path is specified or not, you need to check
both queue_if_no_path and saved_queue_if_no_path, because presuspend saves
the original queue_if_no_path value to saved_queue_if_no_path.

The check for 1 already exists in both map_io() and do_end_io().
So this patch adds __must_push_back() to check 2 and 3.

Test results:
See the test results in the preceding patch.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/dm-mpath.c |   34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff -puN drivers/md/dm-mpath.c~dm-mpath-use-noflush-suspending drivers/md/dm-mpath.c
--- a/drivers/md/dm-mpath.c~dm-mpath-use-noflush-suspending
+++ a/drivers/md/dm-mpath.c
@@ -282,6 +282,23 @@ failed:
 	m->current_pg = NULL;
 }
 
+/*
+ * Check whether bios must be queued in the device-mapper core rather
+ * than here in the target.
+ *
+ * m->lock must be held on entry.
+ *
+ * If m->queue_if_no_path and m->saved_queue_if_no_path hold the
+ * same value then we are not between multipath_presuspend()
+ * and multipath_resume() calls and we have no need to check
+ * for the DMF_NOFLUSH_SUSPENDING flag.
+ */
+static int __must_push_back(struct multipath *m)
+{
+	return (m->queue_if_no_path != m->saved_queue_if_no_path &&
+		dm_noflush_suspending(m->ti));
+}
+
 static int map_io(struct multipath *m, struct bio *bio, struct mpath_io *mpio,
 		  unsigned was_queued)
 {
@@ -311,10 +328,12 @@ static int map_io(struct multipath *m, s
 			queue_work(kmultipathd, &m->process_queued_ios);
 		pgpath = NULL;
 		r = DM_MAPIO_SUBMITTED;
-	} else if (!pgpath)
-		r = -EIO;		/* Failed */
-	else
+	} else if (pgpath)
 		bio->bi_bdev = pgpath->path.dev->bdev;
+	else if (__must_push_back(m))
+		r = DM_MAPIO_REQUEUE;
+	else
+		r = -EIO;	/* Failed */
 
 	mpio->pgpath = pgpath;
 
@@ -374,6 +393,8 @@ static void dispatch_queued_ios(struct m
 			bio_endio(bio, bio->bi_size, r);
 		else if (r == DM_MAPIO_REMAPPED)
 			generic_make_request(bio);
+		else if (r == DM_MAPIO_REQUEUE)
+			bio_endio(bio, bio->bi_size, -EIO);
 
 		bio = next;
 	}
@@ -783,7 +804,7 @@ static int multipath_map(struct dm_targe
 	map_context->ptr = mpio;
 	bio->bi_rw |= (1 << BIO_RW_FAILFAST);
 	r = map_io(m, bio, mpio, 0);
-	if (r < 0)
+	if (r < 0 || r == DM_MAPIO_REQUEUE)
 		mempool_free(mpio, m->mpio_pool);
 
 	return r;
@@ -1007,7 +1028,10 @@ static int do_end_io(struct multipath *m
 
 	spin_lock_irqsave(&m->lock, flags);
 	if (!m->nr_valid_paths) {
-		if (!m->queue_if_no_path) {
+		if (__must_push_back(m)) {
+			spin_unlock_irqrestore(&m->lock, flags);
+			return DM_ENDIO_REQUEUE;
+		} else if (!m->queue_if_no_path) {
 			spin_unlock_irqrestore(&m->lock, flags);
 			return -EIO;
 		} else {
_

Patches currently in -mm which might be from k-ueda@ct.jp.nec.com are

dm-mpath-use-noflush-suspending.patch

