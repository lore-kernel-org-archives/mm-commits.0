From: akpm@linux-foundation.org
Subject: - md-change-iterate_rdev-to-rdev_for_each.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:30:07 -0800
Message-ID: <200802070029.m170TmvD007318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40401 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764431AbYBGAnf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:43:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: change ITERATE_RDEV to rdev_for_each
has been removed from the -mm tree.  Its filename was
     md-change-iterate_rdev-to-rdev_for_each.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: change ITERATE_RDEV to rdev_for_each
From: NeilBrown <neilb@suse.de>

As this is more in line with common practice in the kernel.  Also swap the
args around to be more like list_for_each.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c       |    4 +-
 drivers/md/faulty.c       |    2 -
 drivers/md/linear.c       |    2 -
 drivers/md/md.c           |   64 ++++++++++++++++++------------------
 drivers/md/multipath.c    |    2 -
 drivers/md/raid0.c        |    8 ++--
 drivers/md/raid1.c        |    2 -
 drivers/md/raid10.c       |    2 -
 drivers/md/raid5.c        |    6 +--
 include/linux/raid/md_k.h |    2 -
 10 files changed, 47 insertions(+), 47 deletions(-)

diff -puN drivers/md/bitmap.c~md-change-iterate_rdev-to-rdev_for_each drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-change-iterate_rdev-to-rdev_for_each
+++ a/drivers/md/bitmap.c
@@ -237,7 +237,7 @@ static struct page *read_sb_page(mddev_t
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
-	ITERATE_RDEV(mddev, rdev, tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		if (! test_bit(In_sync, &rdev->flags)
 		    || test_bit(Faulty, &rdev->flags))
 			continue;
@@ -261,7 +261,7 @@ static int write_sb_page(struct bitmap *
 	struct list_head *tmp;
 	mddev_t *mddev = bitmap->mddev;
 
-	ITERATE_RDEV(mddev, rdev, tmp)
+	rdev_for_each(rdev, tmp, mddev)
 		if (test_bit(In_sync, &rdev->flags)
 		    && !test_bit(Faulty, &rdev->flags)) {
 			int size = PAGE_SIZE;
diff -puN drivers/md/faulty.c~md-change-iterate_rdev-to-rdev_for_each drivers/md/faulty.c
--- a/drivers/md/faulty.c~md-change-iterate_rdev-to-rdev_for_each
+++ a/drivers/md/faulty.c
@@ -294,7 +294,7 @@ static int run(mddev_t *mddev)
 	}
 	conf->nfaults = 0;
 
-	ITERATE_RDEV(mddev, rdev, tmp)
+	rdev_for_each(rdev, tmp, mddev)
 		conf->rdev = rdev;
 
 	mddev->array_size = mddev->size;
diff -puN drivers/md/linear.c~md-change-iterate_rdev-to-rdev_for_each drivers/md/linear.c
--- a/drivers/md/linear.c~md-change-iterate_rdev-to-rdev_for_each
+++ a/drivers/md/linear.c
@@ -122,7 +122,7 @@ static linear_conf_t *linear_conf(mddev_
 	cnt = 0;
 	conf->array_size = 0;
 
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		int j = rdev->raid_disk;
 		dev_info_t *disk = conf->disks + j;
 
diff -puN drivers/md/md.c~md-change-iterate_rdev-to-rdev_for_each drivers/md/md.c
--- a/drivers/md/md.c~md-change-iterate_rdev-to-rdev_for_each
+++ a/drivers/md/md.c
@@ -311,7 +311,7 @@ static mdk_rdev_t * find_rdev_nr(mddev_t
 	mdk_rdev_t * rdev;
 	struct list_head *tmp;
 
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		if (rdev->desc_nr == nr)
 			return rdev;
 	}
@@ -323,7 +323,7 @@ static mdk_rdev_t * find_rdev(mddev_t * 
 	struct list_head *tmp;
 	mdk_rdev_t *rdev;
 
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		if (rdev->bdev->bd_dev == dev)
 			return rdev;
 	}
@@ -943,7 +943,7 @@ static void super_90_sync(mddev_t *mddev
 		sb->state |= (1<<MD_SB_BITMAP_PRESENT);
 
 	sb->disks[0].state = (1<<MD_DISK_REMOVED);
-	ITERATE_RDEV(mddev,rdev2,tmp) {
+	rdev_for_each(rdev2, tmp, mddev) {
 		mdp_disk_t *d;
 		int desc_nr;
 		if (rdev2->raid_disk >= 0 && test_bit(In_sync, &rdev2->flags)
@@ -1295,7 +1295,7 @@ static void super_1_sync(mddev_t *mddev,
 	}
 
 	max_dev = 0;
-	ITERATE_RDEV(mddev,rdev2,tmp)
+	rdev_for_each(rdev2, tmp, mddev)
 		if (rdev2->desc_nr+1 > max_dev)
 			max_dev = rdev2->desc_nr+1;
 
@@ -1304,7 +1304,7 @@ static void super_1_sync(mddev_t *mddev,
 	for (i=0; i<max_dev;i++)
 		sb->dev_roles[i] = cpu_to_le16(0xfffe);
 	
-	ITERATE_RDEV(mddev,rdev2,tmp) {
+	rdev_for_each(rdev2, tmp, mddev) {
 		i = rdev2->desc_nr;
 		if (test_bit(Faulty, &rdev2->flags))
 			sb->dev_roles[i] = cpu_to_le16(0xfffe);
@@ -1342,8 +1342,8 @@ static int match_mddev_units(mddev_t *md
 	struct list_head *tmp, *tmp2;
 	mdk_rdev_t *rdev, *rdev2;
 
-	ITERATE_RDEV(mddev1,rdev,tmp)
-		ITERATE_RDEV(mddev2, rdev2, tmp2)
+	rdev_for_each(rdev, tmp, mddev1)
+		rdev_for_each(rdev2, tmp2, mddev2)
 			if (rdev->bdev->bd_contains ==
 			    rdev2->bdev->bd_contains)
 				return 1;
@@ -1516,7 +1516,7 @@ static void export_array(mddev_t *mddev)
 	struct list_head *tmp;
 	mdk_rdev_t *rdev;
 
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		if (!rdev->mddev) {
 			MD_BUG();
 			continue;
@@ -1600,11 +1600,11 @@ static void md_print_devices(void)
 			bitmap_print_sb(mddev->bitmap);
 		else
 			printk("%s: ", mdname(mddev));
-		ITERATE_RDEV(mddev,rdev,tmp2)
+		rdev_for_each(rdev, tmp2, mddev)
 			printk("<%s>", bdevname(rdev->bdev,b));
 		printk("\n");
 
-		ITERATE_RDEV(mddev,rdev,tmp2)
+		rdev_for_each(rdev, tmp2, mddev)
 			print_rdev(rdev);
 	}
 	printk("md:	**********************************\n");
@@ -1623,7 +1623,7 @@ static void sync_sbs(mddev_t * mddev, in
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
 
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		if (rdev->sb_events == mddev->events ||
 		    (nospares &&
 		     rdev->raid_disk < 0 &&
@@ -1730,7 +1730,7 @@ repeat:
 		mdname(mddev),mddev->in_sync);
 
 	bitmap_update_sb(mddev->bitmap);
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		char b[BDEVNAME_SIZE];
 		dprintk(KERN_INFO "md: ");
 		if (rdev->sb_loaded != 1)
@@ -2016,7 +2016,7 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 			mdk_rdev_t *rdev2;
 
 			mddev_lock(mddev);
-			ITERATE_RDEV(mddev, rdev2, tmp2)
+			rdev_for_each(rdev2, tmp2, mddev)
 				if (test_bit(AllReserved, &rdev2->flags) ||
 				    (rdev->bdev == rdev2->bdev &&
 				     rdev != rdev2 &&
@@ -2202,7 +2202,7 @@ static void analyze_sbs(mddev_t * mddev)
 	char b[BDEVNAME_SIZE];
 
 	freshest = NULL;
-	ITERATE_RDEV(mddev,rdev,tmp)
+	rdev_for_each(rdev, tmp, mddev)
 		switch (super_types[mddev->major_version].
 			load_super(rdev, freshest, mddev->minor_version)) {
 		case 1:
@@ -2223,7 +2223,7 @@ static void analyze_sbs(mddev_t * mddev)
 		validate_super(mddev, freshest);
 
 	i = 0;
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		if (rdev != freshest)
 			if (super_types[mddev->major_version].
 			    validate_super(mddev, rdev)) {
@@ -3317,7 +3317,7 @@ static int do_md_run(mddev_t * mddev)
 		}
 
 		/* devices must have minimum size of one chunk */
-		ITERATE_RDEV(mddev,rdev,tmp) {
+		rdev_for_each(rdev, tmp, mddev) {
 			if (test_bit(Faulty, &rdev->flags))
 				continue;
 			if (rdev->size < chunk_size / 1024) {
@@ -3344,7 +3344,7 @@ static int do_md_run(mddev_t * mddev)
 	 * the only valid external interface is through the md
 	 * device.
 	 */
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		if (test_bit(Faulty, &rdev->flags))
 			continue;
 		sync_blockdev(rdev->bdev);
@@ -3410,8 +3410,8 @@ static int do_md_run(mddev_t * mddev)
 		mdk_rdev_t *rdev2;
 		struct list_head *tmp2;
 		int warned = 0;
-		ITERATE_RDEV(mddev, rdev, tmp) {
-			ITERATE_RDEV(mddev, rdev2, tmp2) {
+		rdev_for_each(rdev, tmp, mddev) {
+			rdev_for_each(rdev2, tmp2, mddev) {
 				if (rdev < rdev2 &&
 				    rdev->bdev->bd_contains ==
 				    rdev2->bdev->bd_contains) {
@@ -3471,7 +3471,7 @@ static int do_md_run(mddev_t * mddev)
 	mddev->safemode_delay = (200 * HZ)/1000 +1; /* 200 msec delay */
 	mddev->in_sync = 1;
 
-	ITERATE_RDEV(mddev,rdev,tmp)
+	rdev_for_each(rdev, tmp, mddev)
 		if (rdev->raid_disk >= 0) {
 			char nm[20];
 			sprintf(nm, "rd%d", rdev->raid_disk);
@@ -3504,7 +3504,7 @@ static int do_md_run(mddev_t * mddev)
 	if (mddev->degraded && !mddev->sync_thread) {
 		struct list_head *rtmp;
 		int spares = 0;
-		ITERATE_RDEV(mddev,rdev,rtmp)
+		rdev_for_each(rdev, rtmp, mddev)
 			if (rdev->raid_disk >= 0 &&
 			    !test_bit(In_sync, &rdev->flags) &&
 			    !test_bit(Faulty, &rdev->flags))
@@ -3681,7 +3681,7 @@ static int do_md_stop(mddev_t * mddev, i
 		}
 		mddev->bitmap_offset = 0;
 
-		ITERATE_RDEV(mddev,rdev,tmp)
+		rdev_for_each(rdev, tmp, mddev)
 			if (rdev->raid_disk >= 0) {
 				char nm[20];
 				sprintf(nm, "rd%d", rdev->raid_disk);
@@ -3723,7 +3723,7 @@ static void autorun_array(mddev_t *mddev
 
 	printk(KERN_INFO "md: running: ");
 
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		char b[BDEVNAME_SIZE];
 		printk("<%s>", bdevname(rdev->bdev,b));
 	}
@@ -3851,7 +3851,7 @@ static int get_array_info(mddev_t * mdde
 	struct list_head *tmp;
 
 	nr=working=active=failed=spare=0;
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		nr++;
 		if (test_bit(Faulty, &rdev->flags))
 			failed++;
@@ -4391,7 +4391,7 @@ static int update_size(mddev_t *mddev, u
 	 */
 	if (mddev->sync_thread)
 		return -EBUSY;
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		sector_t avail;
 		avail = rdev->size * 2;
 
@@ -5132,7 +5132,7 @@ static int md_seq_show(struct seq_file *
 		}
 
 		size = 0;
-		ITERATE_RDEV(mddev,rdev,tmp2) {
+		rdev_for_each(rdev, tmp2, mddev) {
 			char b[BDEVNAME_SIZE];
 			seq_printf(seq, " %s[%d]",
 				bdevname(rdev->bdev,b), rdev->desc_nr);
@@ -5288,7 +5288,7 @@ static int is_mddev_idle(mddev_t *mddev)
 	long curr_events;
 
 	idle = 1;
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		struct gendisk *disk = rdev->bdev->bd_contains->bd_disk;
 		curr_events = disk_stat_read(disk, sectors[0]) + 
 				disk_stat_read(disk, sectors[1]) - 
@@ -5515,7 +5515,7 @@ void md_do_sync(mddev_t *mddev)
 		/* recovery follows the physical size of devices */
 		max_sectors = mddev->size << 1;
 		j = MaxSector;
-		ITERATE_RDEV(mddev,rdev,rtmp)
+		rdev_for_each(rdev, rtmp, mddev)
 			if (rdev->raid_disk >= 0 &&
 			    !test_bit(Faulty, &rdev->flags) &&
 			    !test_bit(In_sync, &rdev->flags) &&
@@ -5668,7 +5668,7 @@ void md_do_sync(mddev_t *mddev)
 		} else {
 			if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 				mddev->curr_resync = MaxSector;
-			ITERATE_RDEV(mddev,rdev,rtmp)
+			rdev_for_each(rdev, rtmp, mddev)
 				if (rdev->raid_disk >= 0 &&
 				    !test_bit(Faulty, &rdev->flags) &&
 				    !test_bit(In_sync, &rdev->flags) &&
@@ -5706,7 +5706,7 @@ static int remove_and_add_spares(mddev_t
 	struct list_head *rtmp;
 	int spares = 0;
 
-	ITERATE_RDEV(mddev,rdev,rtmp)
+	rdev_for_each(rdev, rtmp, mddev)
 		if (rdev->raid_disk >= 0 &&
 		    !mddev->external &&
 		    (test_bit(Faulty, &rdev->flags) ||
@@ -5722,7 +5722,7 @@ static int remove_and_add_spares(mddev_t
 		}
 
 	if (mddev->degraded) {
-		ITERATE_RDEV(mddev,rdev,rtmp)
+		rdev_for_each(rdev, rtmp, mddev)
 			if (rdev->raid_disk < 0
 			    && !test_bit(Faulty, &rdev->flags)) {
 				rdev->recovery_offset = 0;
@@ -5836,7 +5836,7 @@ void md_check_recovery(mddev_t *mddev)
 			 * information must be scrapped
 			 */
 			if (!mddev->degraded)
-				ITERATE_RDEV(mddev,rdev,rtmp)
+				rdev_for_each(rdev, rtmp, mddev)
 					rdev->saved_raid_disk = -1;
 
 			mddev->recovery = 0;
diff -puN drivers/md/multipath.c~md-change-iterate_rdev-to-rdev_for_each drivers/md/multipath.c
--- a/drivers/md/multipath.c~md-change-iterate_rdev-to-rdev_for_each
+++ a/drivers/md/multipath.c
@@ -436,7 +436,7 @@ static int multipath_run (mddev_t *mddev
 	}
 
 	conf->working_disks = 0;
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx < 0 ||
 		    disk_idx >= mddev->raid_disks)
diff -puN drivers/md/raid0.c~md-change-iterate_rdev-to-rdev_for_each drivers/md/raid0.c
--- a/drivers/md/raid0.c~md-change-iterate_rdev-to-rdev_for_each
+++ a/drivers/md/raid0.c
@@ -72,11 +72,11 @@ static int create_strip_zones (mddev_t *
 	 */
 	conf->nr_strip_zones = 0;
  
-	ITERATE_RDEV(mddev,rdev1,tmp1) {
+	rdev_for_each(rdev1, tmp1, mddev) {
 		printk("raid0: looking at %s\n",
 			bdevname(rdev1->bdev,b));
 		c = 0;
-		ITERATE_RDEV(mddev,rdev2,tmp2) {
+		rdev_for_each(rdev2, tmp2, mddev) {
 			printk("raid0:   comparing %s(%llu)",
 			       bdevname(rdev1->bdev,b),
 			       (unsigned long long)rdev1->size);
@@ -124,7 +124,7 @@ static int create_strip_zones (mddev_t *
 	cnt = 0;
 	smallest = NULL;
 	zone->dev = conf->devlist;
-	ITERATE_RDEV(mddev, rdev1, tmp1) {
+	rdev_for_each(rdev1, tmp1, mddev) {
 		int j = rdev1->raid_disk;
 
 		if (j < 0 || j >= mddev->raid_disks) {
@@ -293,7 +293,7 @@ static int raid0_run (mddev_t *mddev)
 
 	/* calculate array device size */
 	mddev->array_size = 0;
-	ITERATE_RDEV(mddev,rdev,tmp)
+	rdev_for_each(rdev, tmp, mddev)
 		mddev->array_size += rdev->size;
 
 	printk("raid0 : md_size is %llu blocks.\n", 
diff -puN drivers/md/raid1.c~md-change-iterate_rdev-to-rdev_for_each drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-change-iterate_rdev-to-rdev_for_each
+++ a/drivers/md/raid1.c
@@ -1887,7 +1887,7 @@ static int run(mddev_t *mddev)
 	if (!conf->r1bio_pool)
 		goto out_no_mem;
 
-	ITERATE_RDEV(mddev, rdev, tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
 		    || disk_idx < 0)
diff -puN drivers/md/raid10.c~md-change-iterate_rdev-to-rdev_for_each drivers/md/raid10.c
--- a/drivers/md/raid10.c~md-change-iterate_rdev-to-rdev_for_each
+++ a/drivers/md/raid10.c
@@ -2026,7 +2026,7 @@ static int run(mddev_t *mddev)
 		goto out_free_conf;
 	}
 
-	ITERATE_RDEV(mddev, rdev, tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
 		    || disk_idx < 0)
diff -puN drivers/md/raid5.c~md-change-iterate_rdev-to-rdev_for_each drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-change-iterate_rdev-to-rdev_for_each
+++ a/drivers/md/raid5.c
@@ -4136,7 +4136,7 @@ static int run(mddev_t *mddev)
 
 	pr_debug("raid5: run(%s) called.\n", mdname(mddev));
 
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		raid_disk = rdev->raid_disk;
 		if (raid_disk >= conf->raid_disks
 		    || raid_disk < 0)
@@ -4549,7 +4549,7 @@ static int raid5_start_reshape(mddev_t *
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
 
-	ITERATE_RDEV(mddev, rdev, rtmp)
+	rdev_for_each(rdev, rtmp, mddev)
 		if (rdev->raid_disk < 0 &&
 		    !test_bit(Faulty, &rdev->flags))
 			spares++;
@@ -4571,7 +4571,7 @@ static int raid5_start_reshape(mddev_t *
 	/* Add some new drives, as many as will fit.
 	 * We know there are enough to make the newly sized array work.
 	 */
-	ITERATE_RDEV(mddev, rdev, rtmp)
+	rdev_for_each(rdev, rtmp, mddev)
 		if (rdev->raid_disk < 0 &&
 		    !test_bit(Faulty, &rdev->flags)) {
 			if (raid5_add_disk(mddev, rdev)) {
diff -puN include/linux/raid/md_k.h~md-change-iterate_rdev-to-rdev_for_each include/linux/raid/md_k.h
--- a/include/linux/raid/md_k.h~md-change-iterate_rdev-to-rdev_for_each
+++ a/include/linux/raid/md_k.h
@@ -322,7 +322,7 @@ static inline char * mdname (mddev_t * m
 /*
  * iterates through the 'same array disks' ringlist
  */
-#define ITERATE_RDEV(mddev,rdev,tmp)					\
+#define rdev_for_each(rdev, tmp, mddev)				\
 	ITERATE_RDEV_GENERIC((mddev)->disks,rdev,tmp)
 
 /*
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
d_path-make-d_path-use-a-struct-path-fix.patch
