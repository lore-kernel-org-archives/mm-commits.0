From: akpm@linux-foundation.org
Subject: [nacked] reiser4-vfs-add-super_operationssync_inodes-2.patch removed from -mm tree
Date: Wed, 03 Feb 2010 12:13:00 -0800
Message-ID: <201002032013.o13KD01a016341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757783Ab0BCUNZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 15:13:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dedekind@yandex.ru, Artem.Bityutskiy@nokia.com, edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: vfs: add super_operations.sync_inodes() (2)
has been removed from the -mm tree.  Its filename was
     reiser4-vfs-add-super_operationssync_inodes-2.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: vfs: add super_operations.sync_inodes() (2)
From: Artem Bityutskiy <dedekind@yandex.ru>

This patch adds new operation to struct super_operations - sync_inodes,
generic implementaion and changes fs-writeback.c:sync_sb_inodes() to call
filesystem's sync_inodes if it is defined or generic implementaion otherwise.
This new operation allows filesystem to decide itself what to flush.

Reiser4 flushes dirty pages on basic of atoms, not of inodes.  sync_sb_inodes
used to call address space flushing method (writepages) for every dirty inode.
 For reiser4 it caused having to commit atoms unnecessarily often.  This
turned into substantial slowdown.  Having this method helped to fix that
problem.

akpm: this patch needs to be chnaged to remove the `sb' arg.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c  |    5 ++++-
 include/linux/fs.h |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~reiser4-vfs-add-super_operationssync_inodes-2 fs/fs-writeback.c
--- a/fs/fs-writeback.c~reiser4-vfs-add-super_operationssync_inodes-2
+++ a/fs/fs-writeback.c
@@ -1196,7 +1196,10 @@ EXPORT_SYMBOL(writeback_inodes_sb);
  */
 void sync_inodes_sb(struct super_block *sb)
 {
-	bdi_sync_writeback(sb->s_bdi, sb);
+	if (sb->s_op->sync_inodes)
+		sb->s_op->sync_inodes(sb, NULL);
+	else
+		bdi_sync_writeback(sb->s_bdi, sb);
 	wait_sb_inodes(sb);
 }
 EXPORT_SYMBOL(sync_inodes_sb);
diff -puN include/linux/fs.h~reiser4-vfs-add-super_operationssync_inodes-2 include/linux/fs.h
--- a/include/linux/fs.h~reiser4-vfs-add-super_operationssync_inodes-2
+++ a/include/linux/fs.h
@@ -1574,6 +1574,8 @@ struct super_operations {
 	void (*clear_inode) (struct inode *);
 	void (*umount_begin) (struct super_block *);
 
+	void (*sync_inodes)(struct super_block *sb,
+				struct writeback_control *wbc);
 	int (*show_options)(struct seq_file *, struct vfsmount *);
 	int (*show_stats)(struct seq_file *, struct vfsmount *);
 #ifdef CONFIG_QUOTA
_

Patches currently in -mm which might be from dedekind@yandex.ru are

reiser4-vfs-add-super_operationssync_inodes-2.patch

