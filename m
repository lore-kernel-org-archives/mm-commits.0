From: akpm@osdl.org
Subject: - remove-lock_key-approach-to-managing-nested-bd_mutex-locks.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:00:29 -0800
Message-ID: <200612082000.kB8K0Tlu001746@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56623 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426203AbWLHUAn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:00:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: remove lock_key approach to managing nested bd_mutex locks
has been removed from the -mm tree.  Its filename was
     remove-lock_key-approach-to-managing-nested-bd_mutex-locks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: remove lock_key approach to managing nested bd_mutex locks
From: NeilBrown <neilb@suse.de>

The extra call to get_gendisk is not good.  It causes a ->probe and possible
module load before it is really appropriate to do this.

Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/block_dev.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN fs/block_dev.c~remove-lock_key-approach-to-managing-nested-bd_mutex-locks fs/block_dev.c
--- a/fs/block_dev.c~remove-lock_key-approach-to-managing-nested-bd_mutex-locks
+++ a/fs/block_dev.c
@@ -355,14 +355,10 @@ static int bdev_set(struct inode *inode,
 
 static LIST_HEAD(all_bdevs);
 
-static struct lock_class_key bdev_part_lock_key;
-
 struct block_device *bdget(dev_t dev)
 {
 	struct block_device *bdev;
 	struct inode *inode;
-	struct gendisk *disk;
-	int part = 0;
 
 	inode = iget5_locked(bd_mnt->mnt_sb, hash(dev),
 			bdev_test, bdev_set, &dev);
@@ -388,11 +384,6 @@ struct block_device *bdget(dev_t dev)
 		list_add(&bdev->bd_list, &all_bdevs);
 		spin_unlock(&bdev_lock);
 		unlock_new_inode(inode);
-		mutex_init(&bdev->bd_mutex);
-		disk = get_gendisk(dev, &part);
-		if (part)
-			lockdep_set_class(&bdev->bd_mutex, &bdev_part_lock_key);
-		put_disk(disk);
 	}
 	return bdev;
 }
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
remove-lock_key-approach-to-managing-nested-bd_mutex-locks.patch
simplify-some-aspects-of-bd_mutex-nesting.patch
use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning.patch
avoid-lockdep-warning-in-md.patch
bdev-fix-bd_part_count-leak.patch
lockdep-annotate-nfsd4-recover-code.patch
nfs2-calculate-w-a-bit-later-in-nfsaclsvc_encode_getaclres.patch
nfs3-calculate-w-a-bit-later-in-nfs3svc_encode_getaclres.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-tidy-up-device-change-notification-when-an-md-array-is-stopped.patch
md-define-raid5_mergeable_bvec.patch
md-handle-bypassing-the-read-cache-assuming-nothing-fails.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-aligned-read-handling-including-raid6-read-corruption.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-error-handling-of-aligned-reads.patch
md-enable-bypassing-cache-for-reads.patch
md-fix-innocuous-bug-in-raid6-stripe_to_pdidx.patch
md-conditionalize-some-code.patch
md-change-lifetime-rules-for-md-devices.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch

