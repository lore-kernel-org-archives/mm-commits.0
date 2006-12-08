From: akpm@osdl.org
Subject: - dm-map-and-endio-return-code-clarification.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:15:10 -0800
Message-ID: <200612082015.kB8KFAmr003276@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59952 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947077AbWLHUPU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:15:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k-ueda@ct.jp.nec.com, agk@redhat.com, j-nomura@ce.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     dm: map and endio return code clarification
has been removed from the -mm tree.  Its filename was
     dm-map-and-endio-return-code-clarification.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm: map and endio return code clarification
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

Tighten the use of return values from the target map and end_io functions. 
Values of 2 and above are now explictly reserved for future use.  There are no
existing targets using such values.

The patch has no effect on existing behaviour.

o Reserve return values of 2 and above from target map functions.
  Any positive value currently indicates "mapping complete", but all
  existing drivers use the value 1.  We now make that a requirement
  so we can assign new meaning to higher values in future.

  The new definition of return values from target map functions is:
      < 0 : error
      = 0 : The target will handle the io (DM_MAPIO_SUBMITTED).
      = 1 : Mapping completed (DM_MAPIO_REMAPPED).
      > 1 : Reserved (undefined).  Previously this was the same as '= 1'.

o Reserve return values of 2 and above from target end_io functions
  for similar reasons.
  DM_ENDIO_INCOMPLETE is introduced for a return value of 1.

Test results:

  I have tested by using the multipath target.

  I/Os succeed when valid paths exist.

  I/Os are queued in the multipath target when there are no valid paths and
queue_if_no_path is set.

  I/Os fail when there are no valid paths and queue_if_no_path is not set.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/dm.c               |   13 ++++++++++---
 drivers/md/dm.h               |   11 +++++++++++
 include/linux/device-mapper.h |    2 +-
 3 files changed, 22 insertions(+), 4 deletions(-)

diff -puN drivers/md/dm.c~dm-map-and-endio-return-code-clarification drivers/md/dm.c
--- a/drivers/md/dm.c~dm-map-and-endio-return-code-clarification
+++ a/drivers/md/dm.c
@@ -482,9 +482,13 @@ static int clone_endio(struct bio *bio, 
 		r = endio(tio->ti, bio, error, &tio->info);
 		if (r < 0)
 			error = r;
-		else if (r > 0)
-			/* the target wants another shot at the io */
+		else if (r == DM_ENDIO_INCOMPLETE)
+			/* The target will handle the io */
 			return 1;
+		else if (r) {
+			DMWARN("unimplemented target endio return value: %d", r);
+			BUG();
+		}
 	}
 
 	dec_pending(tio->io, error);
@@ -542,7 +546,7 @@ static void __map_bio(struct dm_target *
 	atomic_inc(&tio->io->io_count);
 	sector = clone->bi_sector;
 	r = ti->type->map(ti, clone, &tio->info);
-	if (r > 0) {
+	if (r == DM_MAPIO_REMAPPED) {
 		/* the bio has been remapped so dispatch it */
 
 		blk_add_trace_remap(bdev_get_queue(clone->bi_bdev), clone,
@@ -560,6 +564,9 @@ static void __map_bio(struct dm_target *
 		clone->bi_private = md->bs;
 		bio_put(clone);
 		free_tio(md, tio);
+	} else if (r) {
+		DMWARN("unimplemented target map return value: %d", r);
+		BUG();
 	}
 }
 
diff -puN drivers/md/dm.h~dm-map-and-endio-return-code-clarification drivers/md/dm.h
--- a/drivers/md/dm.h~dm-map-and-endio-return-code-clarification
+++ a/drivers/md/dm.h
@@ -33,6 +33,17 @@
 #define SECTOR_SHIFT 9
 
 /*
+ * Definitions of return values from target end_io function.
+ */
+#define DM_ENDIO_INCOMPLETE	1
+
+/*
+ * Definitions of return values from target map function.
+ */
+#define DM_MAPIO_SUBMITTED	0
+#define DM_MAPIO_REMAPPED	1
+
+/*
  * Suspend feature flags
  */
 #define DM_SUSPEND_LOCKFS_FLAG		(1 << 0)
diff -puN include/linux/device-mapper.h~dm-map-and-endio-return-code-clarification include/linux/device-mapper.h
--- a/include/linux/device-mapper.h~dm-map-and-endio-return-code-clarification
+++ a/include/linux/device-mapper.h
@@ -39,7 +39,7 @@ typedef void (*dm_dtr_fn) (struct dm_tar
  * The map function must return:
  * < 0: error
  * = 0: The target will handle the io by resubmitting it later
- * > 0: simple remap complete
+ * = 1: simple remap complete
  */
 typedef int (*dm_map_fn) (struct dm_target *ti, struct bio *bio,
 			  union map_info *map_context);
_

Patches currently in -mm which might be from k-ueda@ct.jp.nec.com are

dm-map-and-endio-return-code-clarification.patch
dm-map-and-endio-symbolic-return-codes.patch
dm-ioctl-add-noflush-suspend.patch
dm-suspend-add-noflush-pushback.patch
dm-mpath-use-noflush-suspending.patch

