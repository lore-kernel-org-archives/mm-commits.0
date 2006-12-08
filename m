From: akpm@osdl.org
Subject: - dm-tidy-core-formatting.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:15:05 -0800
Message-ID: <200612082015.kB8KF5pT003264@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59973 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947092AbWLHUPY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:15:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k-ueda@ct.jp.nec.com, agk@redhat.com, j-nomura@ce.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     dm: tidy core formatting
has been removed from the -mm tree.  Its filename was
     dm-tidy-core-formatting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm: tidy core formatting
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

Remove unnecessary spaces in dm.c.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/dm.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN drivers/md/dm.c~dm-tidy-core-formatting drivers/md/dm.c
--- a/drivers/md/dm.c~dm-tidy-core-formatting
+++ a/drivers/md/dm.c
@@ -89,7 +89,7 @@ struct mapped_device {
 	 */
 	atomic_t pending;
 	wait_queue_head_t wait;
- 	struct bio_list deferred;
+	struct bio_list deferred;
 
 	/*
 	 * The current mapping.
@@ -482,7 +482,6 @@ static int clone_endio(struct bio *bio, 
 		r = endio(tio->ti, bio, error, &tio->info);
 		if (r < 0)
 			error = r;
-
 		else if (r > 0)
 			/* the target wants another shot at the io */
 			return 1;
@@ -551,9 +550,7 @@ static void __map_bio(struct dm_target *
 				    clone->bi_sector);
 
 		generic_make_request(clone);
-	}
-
-	else if (r < 0) {
+	} else if (r < 0) {
 		/* error the io and bail out */
 		md = tio->io->md;
 		dec_pending(tio->io, r);
@@ -966,8 +963,8 @@ static struct mapped_device *alloc_dev(i
 	md->queue->issue_flush_fn = dm_flush_all;
 
 	md->io_pool = mempool_create_slab_pool(MIN_IOS, _io_cache);
- 	if (!md->io_pool)
- 		goto bad2;
+	if (!md->io_pool)
+		goto bad2;
 
 	md->tio_pool = mempool_create_slab_pool(MIN_IOS, _tio_cache);
 	if (!md->tio_pool)
_

Patches currently in -mm which might be from k-ueda@ct.jp.nec.com are

dm-tidy-core-formatting.patch
dm-suspend-parameter-change.patch
dm-map-and-endio-return-code-clarification.patch
dm-map-and-endio-symbolic-return-codes.patch
dm-ioctl-add-noflush-suspend.patch
dm-suspend-add-noflush-pushback.patch
dm-mpath-use-noflush-suspending.patch

