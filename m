From: akpm@linux-foundation.org
Subject: + reiser4-vfs-add-super_operationssync_inodes-2.patch added to -mm tree
Date: Thu, 08 May 2008 12:30:55 -0700
Message-ID: <200805081930.m48JUtOE001865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933085AbYEHTbc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 15:31:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dedekind@yandex.ru, Artem.Bityutskiy@nokia.com, edward.shishkin@gmail.com


The patch titled
     reiser4: vfs: add super_operations.sync_inodes() (2)
has been added to the -mm tree.  Its filename is
     reiser4-vfs-add-super_operationssync_inodes-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -531,7 +531,10 @@ EXPORT_SYMBOL_GPL(generic_sync_sb_inodes
 static void sync_sb_inodes(struct super_block *sb,
 				struct writeback_control *wbc)
 {
-	generic_sync_sb_inodes(sb, wbc);
+	if (sb->s_op->sync_inodes)
+		sb->s_op->sync_inodes(sb, wbc);
+	else
+		generic_sync_sb_inodes(sb, wbc);
 }
 
 /*
diff -puN include/linux/fs.h~reiser4-vfs-add-super_operationssync_inodes-2 include/linux/fs.h
--- a/include/linux/fs.h~reiser4-vfs-add-super_operationssync_inodes-2
+++ a/include/linux/fs.h
@@ -1315,6 +1315,8 @@ struct super_operations {
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

