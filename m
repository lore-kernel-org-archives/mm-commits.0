From: akpm@osdl.org
Subject: - dm-map-and-endio-symbolic-return-codes.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:15:13 -0800
Message-ID: <200612082015.kB8KFD0n003279@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59970 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947099AbWLHUPY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:15:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k-ueda@ct.jp.nec.com, agk@redhat.com, j-nomura@ce.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     dm: map and endio symbolic return codes
has been removed from the -mm tree.  Its filename was
     dm-map-and-endio-symbolic-return-codes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm: map and endio symbolic return codes
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

Update existing targets to use the new symbols for return values from target
map and end_io functions.

There is no effect on behaviour.

Test results:
Done build test without errors.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/dm-crypt.c  |    2 +-
 drivers/md/dm-linear.c |    2 +-
 drivers/md/dm-mpath.c  |   10 +++++-----
 drivers/md/dm-raid1.c  |    8 ++++----
 drivers/md/dm-snap.c   |   12 ++++++------
 drivers/md/dm-stripe.c |    2 +-
 drivers/md/dm-zero.c   |    2 +-
 7 files changed, 19 insertions(+), 19 deletions(-)

diff -puN drivers/md/dm-crypt.c~dm-map-and-endio-symbolic-return-codes drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~dm-map-and-endio-symbolic-return-codes
+++ a/drivers/md/dm-crypt.c
@@ -962,7 +962,7 @@ static int crypt_map(struct dm_target *t
 	atomic_set(&io->pending, 0);
 	kcryptd_queue_io(io);
 
-	return 0;
+	return DM_MAPIO_SUBMITTED;
 }
 
 static int crypt_status(struct dm_target *ti, status_type_t type,
diff -puN drivers/md/dm-linear.c~dm-map-and-endio-symbolic-return-codes drivers/md/dm-linear.c
--- a/drivers/md/dm-linear.c~dm-map-and-endio-symbolic-return-codes
+++ a/drivers/md/dm-linear.c
@@ -77,7 +77,7 @@ static int linear_map(struct dm_target *
 	bio->bi_bdev = lc->dev->bdev;
 	bio->bi_sector = lc->start + (bio->bi_sector - ti->begin);
 
-	return 1;
+	return DM_MAPIO_REMAPPED;
 }
 
 static int linear_status(struct dm_target *ti, status_type_t type,
diff -puN drivers/md/dm-mpath.c~dm-map-and-endio-symbolic-return-codes drivers/md/dm-mpath.c
--- a/drivers/md/dm-mpath.c~dm-map-and-endio-symbolic-return-codes
+++ a/drivers/md/dm-mpath.c
@@ -285,7 +285,7 @@ failed:
 static int map_io(struct multipath *m, struct bio *bio, struct mpath_io *mpio,
 		  unsigned was_queued)
 {
-	int r = 1;
+	int r = DM_MAPIO_REMAPPED;
 	unsigned long flags;
 	struct pgpath *pgpath;
 
@@ -310,7 +310,7 @@ static int map_io(struct multipath *m, s
 		    !m->queue_io)
 			queue_work(kmultipathd, &m->process_queued_ios);
 		pgpath = NULL;
-		r = 0;
+		r = DM_MAPIO_SUBMITTED;
 	} else if (!pgpath)
 		r = -EIO;		/* Failed */
 	else
@@ -372,7 +372,7 @@ static void dispatch_queued_ios(struct m
 		r = map_io(m, bio, mpio, 1);
 		if (r < 0)
 			bio_endio(bio, bio->bi_size, r);
-		else if (r == 1)
+		else if (r == DM_MAPIO_REMAPPED)
 			generic_make_request(bio);
 
 		bio = next;
@@ -1042,7 +1042,7 @@ static int do_end_io(struct multipath *m
 		queue_work(kmultipathd, &m->process_queued_ios);
 	spin_unlock_irqrestore(&m->lock, flags);
 
-	return 1;	/* io not complete */
+	return DM_ENDIO_INCOMPLETE;	/* io not complete */
 }
 
 static int multipath_end_io(struct dm_target *ti, struct bio *bio,
@@ -1060,7 +1060,7 @@ static int multipath_end_io(struct dm_ta
 		if (ps->type->end_io)
 			ps->type->end_io(ps, &pgpath->path);
 	}
-	if (r <= 0)
+	if (r != DM_ENDIO_INCOMPLETE)
 		mempool_free(mpio, m->mpio_pool);
 
 	return r;
diff -puN drivers/md/dm-raid1.c~dm-map-and-endio-symbolic-return-codes drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c~dm-map-and-endio-symbolic-return-codes
+++ a/drivers/md/dm-raid1.c
@@ -1137,7 +1137,7 @@ static int mirror_map(struct dm_target *
 
 	if (rw == WRITE) {
 		queue_bio(ms, bio, rw);
-		return 0;
+		return DM_MAPIO_SUBMITTED;
 	}
 
 	r = ms->rh.log->type->in_sync(ms->rh.log,
@@ -1146,7 +1146,7 @@ static int mirror_map(struct dm_target *
 		return r;
 
 	if (r == -EWOULDBLOCK)	/* FIXME: ugly */
-		r = 0;
+		r = DM_MAPIO_SUBMITTED;
 
 	/*
 	 * We don't want to fast track a recovery just for a read
@@ -1159,7 +1159,7 @@ static int mirror_map(struct dm_target *
 	if (!r) {
 		/* Pass this io over to the daemon */
 		queue_bio(ms, bio, rw);
-		return 0;
+		return DM_MAPIO_SUBMITTED;
 	}
 
 	m = choose_mirror(ms, bio->bi_sector);
@@ -1167,7 +1167,7 @@ static int mirror_map(struct dm_target *
 		return -EIO;
 
 	map_bio(ms, m, bio);
-	return 1;
+	return DM_MAPIO_REMAPPED;
 }
 
 static int mirror_end_io(struct dm_target *ti, struct bio *bio,
diff -puN drivers/md/dm-snap.c~dm-map-and-endio-symbolic-return-codes drivers/md/dm-snap.c
--- a/drivers/md/dm-snap.c~dm-map-and-endio-symbolic-return-codes
+++ a/drivers/md/dm-snap.c
@@ -868,7 +868,7 @@ static int snapshot_map(struct dm_target
 {
 	struct exception *e;
 	struct dm_snapshot *s = (struct dm_snapshot *) ti->private;
-	int r = 1;
+	int r = DM_MAPIO_REMAPPED;
 	chunk_t chunk;
 	struct pending_exception *pe = NULL;
 
@@ -914,7 +914,7 @@ static int snapshot_map(struct dm_target
 		remap_exception(s, &pe->e, bio);
 		bio_list_add(&pe->snapshot_bios, bio);
 
-		r = 0;
+		r = DM_MAPIO_SUBMITTED;
 
 		if (!pe->started) {
 			/* this is protected by snap->lock */
@@ -992,7 +992,7 @@ static int snapshot_status(struct dm_tar
  *---------------------------------------------------------------*/
 static int __origin_write(struct list_head *snapshots, struct bio *bio)
 {
-	int r = 1, first = 0;
+	int r = DM_MAPIO_REMAPPED, first = 0;
 	struct dm_snapshot *snap;
 	struct exception *e;
 	struct pending_exception *pe, *next_pe, *primary_pe = NULL;
@@ -1050,7 +1050,7 @@ static int __origin_write(struct list_he
 
 			bio_list_add(&primary_pe->origin_bios, bio);
 
-			r = 0;
+			r = DM_MAPIO_SUBMITTED;
 		}
 
 		if (!pe->primary_pe) {
@@ -1099,7 +1099,7 @@ static int __origin_write(struct list_he
 static int do_origin(struct dm_dev *origin, struct bio *bio)
 {
 	struct origin *o;
-	int r = 1;
+	int r = DM_MAPIO_REMAPPED;
 
 	down_read(&_origins_lock);
 	o = __lookup_origin(origin->bdev);
@@ -1156,7 +1156,7 @@ static int origin_map(struct dm_target *
 		return -EOPNOTSUPP;
 
 	/* Only tell snapshots if this is a write */
-	return (bio_rw(bio) == WRITE) ? do_origin(dev, bio) : 1;
+	return (bio_rw(bio) == WRITE) ? do_origin(dev, bio) : DM_MAPIO_REMAPPED;
 }
 
 #define min_not_zero(l, r) (l == 0) ? r : ((r == 0) ? l : min(l, r))
diff -puN drivers/md/dm-stripe.c~dm-map-and-endio-symbolic-return-codes drivers/md/dm-stripe.c
--- a/drivers/md/dm-stripe.c~dm-map-and-endio-symbolic-return-codes
+++ a/drivers/md/dm-stripe.c
@@ -186,7 +186,7 @@ static int stripe_map(struct dm_target *
 	bio->bi_bdev = sc->stripe[stripe].dev->bdev;
 	bio->bi_sector = sc->stripe[stripe].physical_start +
 	    (chunk << sc->chunk_shift) + (offset & sc->chunk_mask);
-	return 1;
+	return DM_MAPIO_REMAPPED;
 }
 
 static int stripe_status(struct dm_target *ti,
diff -puN drivers/md/dm-zero.c~dm-map-and-endio-symbolic-return-codes drivers/md/dm-zero.c
--- a/drivers/md/dm-zero.c~dm-map-and-endio-symbolic-return-codes
+++ a/drivers/md/dm-zero.c
@@ -46,7 +46,7 @@ static int zero_map(struct dm_target *ti
 	bio_endio(bio, bio->bi_size, 0);
 
 	/* accepted bio, don't make new request */
-	return 0;
+	return DM_MAPIO_SUBMITTED;
 }
 
 static struct target_type zero_target = {
_

Patches currently in -mm which might be from k-ueda@ct.jp.nec.com are

dm-map-and-endio-symbolic-return-codes.patch
dm-ioctl-add-noflush-suspend.patch
dm-suspend-add-noflush-pushback.patch
dm-mpath-use-noflush-suspending.patch

