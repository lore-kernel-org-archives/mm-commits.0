From: akpm@linux-foundation.org
Subject: + nilfs2-fix-deadlock-issue-between-chcp-and-thaw-ioctls.patch added to -mm tree
Date: Mon, 16 Jul 2012 14:29:37 -0700
Message-ID: <20120716212937.D0EEA20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:63684 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab2GPV3k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jul 2012 17:29:40 -0400
Received: by fat25 with SMTP id 25so326089fat.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Jul 2012 14:29:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp, fernando@oss.ntt.co.jp, stable@vger.kernel.org


The patch titled
     Subject: nilfs2: fix deadlock issue between chcp and thaw ioctls
has been added to the -mm tree.  Its filename is
     nilfs2-fix-deadlock-issue-between-chcp-and-thaw-ioctls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: fix deadlock issue between chcp and thaw ioctls

An fs-thaw ioctl causes deadlock with a chcp or mkcp -s command:

 chcp            D ffff88013870f3d0     0  1325   1324 0x00000004
 ...
 Call Trace:
  [<ffffffffa06cd409>] ? nilfs_transaction_begin+0x11c/0x1a0 [nilfs2]
  [<ffffffff81056011>] ? wake_up_bit+0x20/0x20
  [<ffffffffa06d3e04>] ? copy_from_user+0x18/0x30 [nilfs2]
  [<ffffffffa06d3e99>] ? nilfs_ioctl_change_cpmode+0x7d/0xcf [nilfs2]
  [<ffffffffa06d4cf8>] ? nilfs_ioctl+0x252/0x61a [nilfs2]
  [<ffffffff813b8966>] ? do_page_fault+0x311/0x34c
  [<ffffffff810e1c2f>] ? get_unmapped_area+0x132/0x14e
  [<ffffffff8110e95c>] ? do_vfs_ioctl+0x44b/0x490
  [<ffffffff81049b7f>] ? __set_task_blocked+0x5a/0x61
  [<ffffffff810d63c1>] ? vm_mmap_pgoff+0x76/0x87
  [<ffffffff81049bb6>] ? __set_current_blocked+0x30/0x4a
  [<ffffffff8110e9ec>] ? sys_ioctl+0x4b/0x6f
  [<ffffffff813bbc79>] ? system_call_fastpath+0x16/0x1b
 thaw            D ffff88013870d890     0  1352   1351 0x00000004
 ...
 Call Trace:
  [<ffffffff813b5551>] ? rwsem_down_failed_common+0xdb/0x10f
  [<ffffffff812172c3>] ? call_rwsem_down_write_failed+0x13/0x20
  [<ffffffff813b42f4>] ? down_write+0x25/0x27
  [<ffffffff811032e7>] ? thaw_super+0x13/0x9e
  [<ffffffff8110e706>] ? do_vfs_ioctl+0x1f5/0x490
  [<ffffffff810d63c1>] ? vm_mmap_pgoff+0x76/0x87
  [<ffffffff8110e9ec>] ? sys_ioctl+0x4b/0x6f
  [<ffffffff810ff731>] ? filp_close+0x64/0x6c
  [<ffffffff813bbc79>] ? system_call_fastpath+0x16/0x1b

where the thaw ioctl deadlocked at thaw_super() when called while chcp was
waiting at nilfs_transaction_begin() called from
nilfs_ioctl_change_cpmode().  This deadlock is 100% reproducible.

This is because nilfs_ioctl_change_cpmode() first locks sb->s_umount in
read mode and then waits for unfreezing in nilfs_transaction_begin(),
whereas thaw_super() locks sb->s_umount in write mode.  The locking of
sb->s_umount here was intended to make snapshot mounts and the downgrade
of snapshots to checkpoints exclusive.

This fixes the deadlock issue by replacing the sb->s_umount usage in
nilfs_ioctl_change_cpmode() with a dedicated mutex which protects snapshot
mounts.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c     |    4 ++--
 fs/nilfs2/super.c     |    3 +++
 fs/nilfs2/the_nilfs.c |    1 +
 fs/nilfs2/the_nilfs.h |    2 ++
 4 files changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/nilfs2/ioctl.c~nilfs2-fix-deadlock-issue-between-chcp-and-thaw-ioctls fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-fix-deadlock-issue-between-chcp-and-thaw-ioctls
+++ a/fs/nilfs2/ioctl.c
@@ -182,7 +182,7 @@ static int nilfs_ioctl_change_cpmode(str
 	if (copy_from_user(&cpmode, argp, sizeof(cpmode)))
 		goto out;
 
-	down_read(&inode->i_sb->s_umount);
+	mutex_lock(&nilfs->ns_snapshot_mount_mutex);
 
 	nilfs_transaction_begin(inode->i_sb, &ti, 0);
 	ret = nilfs_cpfile_change_cpmode(
@@ -192,7 +192,7 @@ static int nilfs_ioctl_change_cpmode(str
 	else
 		nilfs_transaction_commit(inode->i_sb); /* never fails */
 
-	up_read(&inode->i_sb->s_umount);
+	mutex_unlock(&nilfs->ns_snapshot_mount_mutex);
 out:
 	mnt_drop_write_file(filp);
 	return ret;
diff -puN fs/nilfs2/super.c~nilfs2-fix-deadlock-issue-between-chcp-and-thaw-ioctls fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-fix-deadlock-issue-between-chcp-and-thaw-ioctls
+++ a/fs/nilfs2/super.c
@@ -945,6 +945,8 @@ static int nilfs_attach_snapshot(struct 
 	struct nilfs_root *root;
 	int ret;
 
+	mutex_lock(&nilfs->ns_snapshot_mount_mutex);
+
 	down_read(&nilfs->ns_segctor_sem);
 	ret = nilfs_cpfile_is_snapshot(nilfs->ns_cpfile, cno);
 	up_read(&nilfs->ns_segctor_sem);
@@ -969,6 +971,7 @@ static int nilfs_attach_snapshot(struct 
 	ret = nilfs_get_root_dentry(s, root, root_dentry);
 	nilfs_put_root(root);
  out:
+	mutex_unlock(&nilfs->ns_snapshot_mount_mutex);
 	return ret;
 }
 
diff -puN fs/nilfs2/the_nilfs.c~nilfs2-fix-deadlock-issue-between-chcp-and-thaw-ioctls fs/nilfs2/the_nilfs.c
--- a/fs/nilfs2/the_nilfs.c~nilfs2-fix-deadlock-issue-between-chcp-and-thaw-ioctls
+++ a/fs/nilfs2/the_nilfs.c
@@ -76,6 +76,7 @@ struct the_nilfs *alloc_nilfs(struct blo
 	nilfs->ns_bdev = bdev;
 	atomic_set(&nilfs->ns_ndirtyblks, 0);
 	init_rwsem(&nilfs->ns_sem);
+	mutex_init(&nilfs->ns_snapshot_mount_mutex);
 	INIT_LIST_HEAD(&nilfs->ns_dirty_files);
 	INIT_LIST_HEAD(&nilfs->ns_gc_inodes);
 	spin_lock_init(&nilfs->ns_inode_lock);
diff -puN fs/nilfs2/the_nilfs.h~nilfs2-fix-deadlock-issue-between-chcp-and-thaw-ioctls fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-fix-deadlock-issue-between-chcp-and-thaw-ioctls
+++ a/fs/nilfs2/the_nilfs.h
@@ -47,6 +47,7 @@ enum {
  * @ns_flags: flags
  * @ns_bdev: block device
  * @ns_sem: semaphore for shared states
+ * @ns_snapshot_mount_mutex: mutex to protect snapshot mounts
  * @ns_sbh: buffer heads of on-disk super blocks
  * @ns_sbp: pointers to super block data
  * @ns_sbwtime: previous write time of super block
@@ -100,6 +101,7 @@ struct the_nilfs {
 
 	struct block_device    *ns_bdev;
 	struct rw_semaphore	ns_sem;
+	struct mutex		ns_snapshot_mount_mutex;
 
 	/*
 	 * used for
_
Subject: Subject: nilfs2: fix deadlock issue between chcp and thaw ioctls

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-add-omitted-comment-for-ns_mount_state-field-of-the_nilfs-structure.patch
nilfs2-remove-references-to-long-gone-super-operations.patch
nilfs2-fix-timing-issue-between-rmcp-and-chcp-ioctls.patch
nilfs2-fix-deadlock-issue-between-chcp-and-thaw-ioctls.patch

