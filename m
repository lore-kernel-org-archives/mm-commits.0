From: akpm@osdl.org
Subject: - new-bd_mutex-lockdep-annotation.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:00:27 -0800
Message-ID: <200612082000.kB8K0RpW001739@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56624 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426204AbWLHUAo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:00:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, arjan@linux.intel.com, jbaron@redhat.com, mingo@elte.hu, neilb@cse.unsw.edu.au, mm-commits@vger.kernel.org


The patch titled
     new bd_mutex lockdep annotation
has been removed from the -mm tree.  Its filename was
     new-bd_mutex-lockdep-annotation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: new bd_mutex lockdep annotation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Use the gendisk partition number to set a lock class.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/block_dev.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/block_dev.c~new-bd_mutex-lockdep-annotation fs/block_dev.c
--- a/fs/block_dev.c~new-bd_mutex-lockdep-annotation
+++ a/fs/block_dev.c
@@ -355,10 +355,14 @@ static int bdev_set(struct inode *inode,
 
 static LIST_HEAD(all_bdevs);
 
+static struct lock_class_key bdev_part_lock_key;
+
 struct block_device *bdget(dev_t dev)
 {
 	struct block_device *bdev;
 	struct inode *inode;
+	struct gendisk *disk;
+	int part = 0;
 
 	inode = iget5_locked(bd_mnt->mnt_sb, hash(dev),
 			bdev_test, bdev_set, &dev);
@@ -384,6 +388,11 @@ struct block_device *bdget(dev_t dev)
 		list_add(&bdev->bd_list, &all_bdevs);
 		spin_unlock(&bdev_lock);
 		unlock_new_inode(inode);
+		mutex_init(&bdev->bd_mutex);
+		disk = get_gendisk(dev, &part);
+		if (part)
+			lockdep_set_class(&bdev->bd_mutex, &bdev_part_lock_key);
+		put_disk(disk);
 	}
 	return bdev;
 }
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
new-bd_mutex-lockdep-annotation.patch
remove-lock_key-approach-to-managing-nested-bd_mutex-locks.patch
simplify-some-aspects-of-bd_mutex-nesting.patch
use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning.patch
avoid-lockdep-warning-in-md.patch
bdev-fix-bd_part_count-leak.patch
lockdep-annotate-nfsd4-recover-code.patch

