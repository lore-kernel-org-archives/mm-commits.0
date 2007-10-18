From: akpm@linux-foundation.org
Subject: - writeback-fix-ntfs-with-sb_has_dirty_inodes.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:02:30 -0700
Message-ID: <200710180702.l9I72Uw8031276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531AbXJRH37 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:29:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, aia21@cantab.net, kenchen@google.com, mm-commits@vger.kernel.org


The patch titled
     writeback: fix ntfs with sb_has_dirty_inodes()
has been removed from the -mm tree.  Its filename was
     writeback-fix-ntfs-with-sb_has_dirty_inodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: writeback: fix ntfs with sb_has_dirty_inodes()
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

NTFS's if-condition on dirty inodes is not complete.  Fix it with
sb_has_dirty_inodes().

Cc: Anton Altaparmakov <aia21@cantab.net>
Cc: Ken Chen <kenchen@google.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c  |   10 +++++++++-
 fs/ntfs/super.c    |    4 ++--
 include/linux/fs.h |    1 +
 3 files changed, 12 insertions(+), 3 deletions(-)

diff -puN fs/fs-writeback.c~writeback-fix-ntfs-with-sb_has_dirty_inodes fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-fix-ntfs-with-sb_has_dirty_inodes
+++ a/fs/fs-writeback.c
@@ -199,6 +199,14 @@ static void queue_io(struct super_block 
 	move_expired_inodes(&sb->s_dirty, &sb->s_io, older_than_this);
 }
 
+int sb_has_dirty_inodes(struct super_block *sb)
+{
+	return !list_empty(&sb->s_dirty) ||
+	       !list_empty(&sb->s_io) ||
+	       !list_empty(&sb->s_more_io);
+}
+EXPORT_SYMBOL(sb_has_dirty_inodes);
+
 /*
  * Write a single inode's dirty pages and inode data out to disk.
  * If `wait' is set, wait on the writeout.
@@ -497,7 +505,7 @@ writeback_inodes(struct writeback_contro
 restart:
 	sb = sb_entry(super_blocks.prev);
 	for (; sb != sb_entry(&super_blocks); sb = sb_entry(sb->s_list.prev)) {
-		if (!list_empty(&sb->s_dirty) || !list_empty(&sb->s_io)) {
+		if (sb_has_dirty_inodes(sb)) {
 			/* we're making our own get_super here */
 			sb->s_count++;
 			spin_unlock(&sb_lock);
diff -puN fs/ntfs/super.c~writeback-fix-ntfs-with-sb_has_dirty_inodes fs/ntfs/super.c
--- a/fs/ntfs/super.c~writeback-fix-ntfs-with-sb_has_dirty_inodes
+++ a/fs/ntfs/super.c
@@ -2381,14 +2381,14 @@ static void ntfs_put_super(struct super_
 	 */
 	ntfs_commit_inode(vol->mft_ino);
 	write_inode_now(vol->mft_ino, 1);
-	if (!list_empty(&sb->s_dirty)) {
+	if (sb_has_dirty_inodes(sb)) {
 		const char *s1, *s2;
 
 		mutex_lock(&vol->mft_ino->i_mutex);
 		truncate_inode_pages(vol->mft_ino->i_mapping, 0);
 		mutex_unlock(&vol->mft_ino->i_mutex);
 		write_inode_now(vol->mft_ino, 1);
-		if (!list_empty(&sb->s_dirty)) {
+		if (sb_has_dirty_inodes(sb)) {
 			static const char *_s1 = "inodes";
 			static const char *_s2 = "";
 			s1 = _s1;
diff -puN include/linux/fs.h~writeback-fix-ntfs-with-sb_has_dirty_inodes include/linux/fs.h
--- a/include/linux/fs.h~writeback-fix-ntfs-with-sb_has_dirty_inodes
+++ a/include/linux/fs.h
@@ -1729,6 +1729,7 @@ extern int bdev_read_only(struct block_d
 extern int set_blocksize(struct block_device *, int);
 extern int sb_set_blocksize(struct super_block *, int);
 extern int sb_min_blocksize(struct super_block *, int);
+extern int sb_has_dirty_inodes(struct super_block *);
 
 extern int generic_file_mmap(struct file *, struct vm_area_struct *);
 extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
