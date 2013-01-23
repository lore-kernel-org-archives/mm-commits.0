From: akpm@linux-foundation.org
Subject: + block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write.patch added to -mm tree
Date: Wed, 23 Jan 2013 13:40:14 -0800
Message-ID: <20130123214014.8B61E31C27E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:37965 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3AWVkQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jan 2013 16:40:16 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so823476vcd.5
        for <mm-commits@vger.kernel.org>; Wed, 23 Jan 2013 13:40:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darrick.wong@oracle.com, adrian.hunter@intel.com, axboe@kernel.dk, dedekind1@gmail.com, ericvh@gmail.com, jack@suse.cz, jlbec@evilplan.org, lucho@ionkov.net, luto@amacapital.net, mfasheh@suse.com, rminnich@sandia.gov, swhiteho@redhat.com


The patch titled
     Subject: block: optionally snapshot page contents to provide stable pages during write
has been added to the -mm tree.  Its filename is
     block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write.patch

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
Subject: block: optionally snapshot page contents to provide stable pages during write

This provides a band-aid to provide stable page writes on jbd without
needing to backport the fixed locking and page writeback bit handling
schemes of jbd2.  The band-aid works by using bounce buffers to snapshot
page contents instead of waiting.

For those wondering about the ext3 bandage -- fixing the jbd locking
(which was done as part of ext4dev years ago) is a lot of surgery, and
setting PG_writeback on data pages when we actually hold the page lock
dropped ext3 performance by nearly an order of magnitude.  If we're going
to migrate iscsi and raid to use stable page writes, the complaints about
high latency will likely return.  We might as well centralize their page
snapshotting thing to one place.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Tested-by: Andy Lutomirski <luto@amacapital.net>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/Kconfig       |    6 ----
 block/blk-core.c        |    8 +++---
 fs/ext3/super.c         |    1 
 include/uapi/linux/fs.h |    3 ++
 mm/Kconfig              |   13 ++++++++++
 mm/bounce.c             |   48 ++++++++++++++++++++++++++++++++++----
 mm/page-writeback.c     |    4 +++
 7 files changed, 70 insertions(+), 13 deletions(-)

diff -puN arch/tile/Kconfig~block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write arch/tile/Kconfig
--- a/arch/tile/Kconfig~block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write
+++ a/arch/tile/Kconfig
@@ -413,12 +413,6 @@ config TILE_USB
 	  Provides USB host adapter support for the built-in EHCI and OHCI
 	  interfaces on TILE-Gx chips.
 
-# USB OHCI needs the bounce pool since tilegx will often have more
-# than 4GB of memory, but we don't currently use the IOTLB to present
-# a 32-bit address to OHCI.  So we need to use a bounce pool instead.
-config NEED_BOUNCE_POOL
-	def_bool USB_OHCI_HCD
-
 source "drivers/pci/hotplug/Kconfig"
 
 endmenu
diff -puN block/blk-core.c~block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write block/blk-core.c
--- a/block/blk-core.c~block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write
+++ a/block/blk-core.c
@@ -1473,6 +1473,11 @@ void blk_queue_bio(struct request_queue 
 	 */
 	blk_queue_bounce(q, &bio);
 
+	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio)) {
+		bio_endio(bio, -EIO);
+		return;
+	}
+
 	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
 		spin_lock_irq(q->queue_lock);
 		where = ELEVATOR_INSERT_FLUSH;
@@ -1706,9 +1711,6 @@ generic_make_request_checks(struct bio *
 	 */
 	blk_partition_remap(bio);
 
-	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio))
-		goto end_io;
-
 	if (bio_check_eod(bio, nr_sectors))
 		goto end_io;
 
diff -puN fs/ext3/super.c~block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write fs/ext3/super.c
--- a/fs/ext3/super.c~block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write
+++ a/fs/ext3/super.c
@@ -2067,6 +2067,7 @@ static int ext3_fill_super (struct super
 		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_JOURNAL_DATA ? "journal":
 		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA ? "ordered":
 		"writeback");
+	sb->s_flags |= MS_SNAP_STABLE;
 
 	return 0;
 
diff -puN include/uapi/linux/fs.h~block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write include/uapi/linux/fs.h
--- a/include/uapi/linux/fs.h~block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write
+++ a/include/uapi/linux/fs.h
@@ -86,6 +86,9 @@ struct inodes_stat_t {
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
+
+/* These sb flags are internal to the kernel */
+#define MS_SNAP_STABLE	(1<<27) /* Snapshot pages during writeback, if needed */
 #define MS_NOSEC	(1<<28)
 #define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)
diff -puN mm/Kconfig~block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write mm/Kconfig
--- a/mm/Kconfig~block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write
+++ a/mm/Kconfig
@@ -266,6 +266,19 @@ config BOUNCE
 	def_bool y
 	depends on BLOCK && MMU && (ZONE_DMA || HIGHMEM)
 
+# On the 'tile' arch, USB OHCI needs the bounce pool since tilegx will often
+# have more than 4GB of memory, but we don't currently use the IOTLB to present
+# a 32-bit address to OHCI.  So we need to use a bounce pool instead.
+#
+# We also use the bounce pool to provide stable page writes for jbd.  jbd
+# initiates buffer writeback without locking the page or setting PG_writeback,
+# and fixing that behavior (a second time; jbd2 doesn't have this problem) is
+# a major rework effort.  Instead, use the bounce buffer to snapshot pages
+# (until jbd goes away).  The only jbd user is ext3.
+config NEED_BOUNCE_POOL
+	bool
+	default y if (TILE && USB_OHCI_HCD) || (BLK_DEV_INTEGRITY && JBD)
+
 config NR_QUICK
 	int
 	depends on QUICKLIST
diff -puN mm/bounce.c~block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write mm/bounce.c
--- a/mm/bounce.c~block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write
+++ a/mm/bounce.c
@@ -178,8 +178,45 @@ static void bounce_end_io_read_isa(struc
 	__bounce_end_io_read(bio, isa_page_pool, err);
 }
 
+#ifdef CONFIG_NEED_BOUNCE_POOL
+static int must_snapshot_stable_pages(struct request_queue *q, struct bio *bio)
+{
+	struct page *page;
+	struct backing_dev_info *bdi;
+	struct address_space *mapping;
+	struct bio_vec *from;
+	int i;
+
+	if (bio_data_dir(bio) != WRITE)
+		return 0;
+
+	if (!bdi_cap_stable_pages_required(&q->backing_dev_info))
+		return 0;
+
+	/*
+	 * Based on the first page that has a valid mapping, decide whether or
+	 * not we have to employ bounce buffering to guarantee stable pages.
+	 */
+	bio_for_each_segment(from, bio, i) {
+		page = from->bv_page;
+		mapping = page_mapping(page);
+		if (!mapping)
+			continue;
+		bdi = mapping->backing_dev_info;
+		return mapping->host->i_sb->s_flags & MS_SNAP_STABLE;
+	}
+
+	return 0;
+}
+#else
+static int must_snapshot_stable_pages(struct request_queue *q, struct bio *bio)
+{
+	return 0;
+}
+#endif /* CONFIG_NEED_BOUNCE_POOL */
+
 static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
-			       mempool_t *pool)
+			       mempool_t *pool, int force)
 {
 	struct page *page;
 	struct bio *bio = NULL;
@@ -192,7 +229,7 @@ static void __blk_queue_bounce(struct re
 		/*
 		 * is destination page below bounce pfn?
 		 */
-		if (page_to_pfn(page) <= queue_bounce_pfn(q))
+		if (page_to_pfn(page) <= queue_bounce_pfn(q) && !force)
 			continue;
 
 		/*
@@ -270,6 +307,7 @@ static void __blk_queue_bounce(struct re
 
 void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
 {
+	int must_bounce;
 	mempool_t *pool;
 
 	/*
@@ -278,13 +316,15 @@ void blk_queue_bounce(struct request_que
 	if (!bio_has_data(*bio_orig))
 		return;
 
+	must_bounce = must_snapshot_stable_pages(q, *bio_orig);
+
 	/*
 	 * for non-isa bounce case, just check if the bounce pfn is equal
 	 * to or bigger than the highest pfn in the system -- in that case,
 	 * don't waste time iterating over bio segments
 	 */
 	if (!(q->bounce_gfp & GFP_DMA)) {
-		if (queue_bounce_pfn(q) >= blk_max_pfn)
+		if (queue_bounce_pfn(q) >= blk_max_pfn && !must_bounce)
 			return;
 		pool = page_pool;
 	} else {
@@ -295,7 +335,7 @@ void blk_queue_bounce(struct request_que
 	/*
 	 * slow path
 	 */
-	__blk_queue_bounce(q, bio_orig, pool);
+	__blk_queue_bounce(q, bio_orig, pool, must_bounce);
 }
 
 EXPORT_SYMBOL(blk_queue_bounce);
diff -puN mm/page-writeback.c~block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write mm/page-writeback.c
--- a/mm/page-writeback.c~block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write
+++ a/mm/page-writeback.c
@@ -2310,6 +2310,10 @@ void wait_for_stable_page(struct page *p
 
 	if (!bdi_cap_stable_pages_required(bdi))
 		return;
+#ifdef CONFIG_NEED_BOUNCE_POOL
+	if (mapping->host->i_sb->s_flags & MS_SNAP_STABLE)
+		return;
+#endif /* CONFIG_NEED_BOUNCE_POOL */
 
 	wait_on_page_writeback(page);
 }
_

Patches currently in -mm which might be from darrick.wong@oracle.com are

bdi-allow-block-devices-to-say-that-they-require-stable-page-writes.patch
mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it.patch
9pfs-fix-filesystem-to-wait-for-stable-page-writeback.patch
block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write.patch
ocfs2-wait-for-page-writeback-to-provide-stable-pages.patch
ubifs-wait-for-page-writeback-to-provide-stable-pages.patch

