From: akpm@osdl.org
Subject: - fs-freeze_bdev-with-semaphore-not-mutex.patch removed from -mm tree
Date: Wed, 06 Dec 2006 21:27:18 -0800
Message-ID: <200612070527.kB75RISL031406__39718.5803427876$1165469258$gmane$org@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50268 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968812AbWLGF1d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 00:27:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srinivasa@in.ibm.com, agk@redhat.com, dm-devel@redhat.com, mingo@elte.hu, sandeen@sandeen.net, mm-commits@vger.kernel.org


The patch titled
     fs: freeze_bdev with semaphore not mutex
has been removed from the -mm tree.  Its filename was
     fs-freeze_bdev-with-semaphore-not-mutex.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: fs: freeze_bdev with semaphore not mutex
From: Srinivasa Ds <srinivasa@in.ibm.com>

On debugging I found out that,"dmsetup suspend <device name>" calls
"freeze_bdev()",which locks "bd_mount_mutex" to make sure that no new mounts
happen on bdev until thaw_bdev() is called.  This "thaw_bdev()" is getting
called when we resume the device through "dmsetup resume <device-name>". 
Hence we have 2 processes,one of which locks "bd_mount_mutex"(dmsetup suspend)
and another(dmsetup resume) unlocks it.

Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Sandeen <sandeen@sandeen.net>
Cc: <dm-devel@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/block_dev.c     |    2 +-
 fs/buffer.c        |    6 ++++--
 fs/super.c         |    4 ++--
 include/linux/fs.h |    2 +-
 4 files changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/block_dev.c~fs-freeze_bdev-with-semaphore-not-mutex fs/block_dev.c
--- a/fs/block_dev.c~fs-freeze_bdev-with-semaphore-not-mutex
+++ a/fs/block_dev.c
@@ -263,7 +263,7 @@ static void init_once(void * foo, kmem_c
 	{
 		memset(bdev, 0, sizeof(*bdev));
 		mutex_init(&bdev->bd_mutex);
-		mutex_init(&bdev->bd_mount_mutex);
+		sema_init(&bdev->bd_mount_sem, 1);
 		INIT_LIST_HEAD(&bdev->bd_inodes);
 		INIT_LIST_HEAD(&bdev->bd_list);
 #ifdef CONFIG_SYSFS
diff -puN fs/buffer.c~fs-freeze_bdev-with-semaphore-not-mutex fs/buffer.c
--- a/fs/buffer.c~fs-freeze_bdev-with-semaphore-not-mutex
+++ a/fs/buffer.c
@@ -188,7 +188,9 @@ struct super_block *freeze_bdev(struct b
 {
 	struct super_block *sb;
 
-	mutex_lock(&bdev->bd_mount_mutex);
+	if (down_trylock(&bdev->bd_mount_sem))
+		return -EBUSY;
+
 	sb = get_super(bdev);
 	if (sb && !(sb->s_flags & MS_RDONLY)) {
 		sb->s_frozen = SB_FREEZE_WRITE;
@@ -230,7 +232,7 @@ void thaw_bdev(struct block_device *bdev
 		drop_super(sb);
 	}
 
-	mutex_unlock(&bdev->bd_mount_mutex);
+	up(&bdev->bd_mount_sem);
 }
 EXPORT_SYMBOL(thaw_bdev);
 
diff -puN fs/super.c~fs-freeze_bdev-with-semaphore-not-mutex fs/super.c
--- a/fs/super.c~fs-freeze_bdev-with-semaphore-not-mutex
+++ a/fs/super.c
@@ -735,9 +735,9 @@ int get_sb_bdev(struct file_system_type 
 	 * will protect the lockfs code from trying to start a snapshot
 	 * while we are mounting
 	 */
-	mutex_lock(&bdev->bd_mount_mutex);
+	down(&bdev->bd_mount_sem);
 	s = sget(fs_type, test_bdev_super, set_bdev_super, bdev);
-	mutex_unlock(&bdev->bd_mount_mutex);
+	up(&bdev->bd_mount_sem);
 	if (IS_ERR(s))
 		goto error_s;
 
diff -puN include/linux/fs.h~fs-freeze_bdev-with-semaphore-not-mutex include/linux/fs.h
--- a/include/linux/fs.h~fs-freeze_bdev-with-semaphore-not-mutex
+++ a/include/linux/fs.h
@@ -456,7 +456,7 @@ struct block_device {
 	struct inode *		bd_inode;	/* will die */
 	int			bd_openers;
 	struct mutex		bd_mutex;	/* open/close mutex */
-	struct mutex		bd_mount_mutex;	/* mount mutex */
+	struct semaphore        bd_mount_sem;
 	struct list_head	bd_inodes;
 	void *			bd_holder;
 	int			bd_holders;
_

Patches currently in -mm which might be from srinivasa@in.ibm.com are

git-gfs2-nmw.patch

