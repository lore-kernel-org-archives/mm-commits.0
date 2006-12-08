From: akpm@osdl.org
Subject: - use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:00:35 -0800
Message-ID: <200612082000.kB8K0Zmf001761@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56638 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426210AbWLHUAs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:00:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: use mutex_lock_nested for bd_mutex to avoid lockdep warning
has been removed from the -mm tree.  Its filename was
     use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: use mutex_lock_nested for bd_mutex to avoid lockdep warning
From: NeilBrown <neilb@suse.de>

Now that the nesting in blkdev_{get,put} is simpler, adding mutex_lock_nested
is trivial.

Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/block_dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/block_dev.c~use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning fs/block_dev.c
--- a/fs/block_dev.c~use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning
+++ a/fs/block_dev.c
@@ -920,7 +920,7 @@ static int do_open(struct block_device *
 	}
 	owner = disk->fops->owner;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	if (!bdev->bd_openers) {
 		bdev->bd_disk = disk;
 		bdev->bd_contains = bdev;
@@ -1062,7 +1062,7 @@ static int __blkdev_put(struct block_dev
 	struct gendisk *disk = bdev->bd_disk;
 	struct block_device *victim = NULL;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	lock_kernel();
 	if (for_part)
 		bdev->bd_part_count--;
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
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

