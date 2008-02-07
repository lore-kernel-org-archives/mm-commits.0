From: akpm@linux-foundation.org
Subject: - fs-use-list_for_each_entry_reverse-and-kill-sb_entry.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:22:59 -0800
Message-ID: <200802070022.m170MeFp006454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47442 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764215AbYBGAoN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs: use list_for_each_entry_reverse and kill sb_entry
has been removed from the -mm tree.  Its filename was
     fs-use-list_for_each_entry_reverse-and-kill-sb_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: use list_for_each_entry_reverse and kill sb_entry
From: Akinobu Mita <akinobu.mita@gmail.com>

Use list_for_each_entry_reverse for super_blocks list and remove
unused sb_entry macro.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c  |    7 ++-----
 include/linux/fs.h |    1 -
 2 files changed, 2 insertions(+), 6 deletions(-)

diff -puN fs/fs-writeback.c~fs-use-list_for_each_entry_reverse-and-kill-sb_entry fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-use-list_for_each_entry_reverse-and-kill-sb_entry
+++ a/fs/fs-writeback.c
@@ -515,8 +515,7 @@ writeback_inodes(struct writeback_contro
 	might_sleep();
 	spin_lock(&sb_lock);
 restart:
-	sb = sb_entry(super_blocks.prev);
-	for (; sb != sb_entry(&super_blocks); sb = sb_entry(sb->s_list.prev)) {
+	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
 		if (sb_has_dirty_inodes(sb)) {
 			/* we're making our own get_super here */
 			sb->s_count++;
@@ -581,10 +580,8 @@ static void set_sb_syncing(int val)
 {
 	struct super_block *sb;
 	spin_lock(&sb_lock);
-	sb = sb_entry(super_blocks.prev);
-	for (; sb != sb_entry(&super_blocks); sb = sb_entry(sb->s_list.prev)) {
+	list_for_each_entry_reverse(sb, &super_blocks, s_list)
 		sb->s_syncing = val;
-	}
 	spin_unlock(&sb_lock);
 }
 
diff -puN include/linux/fs.h~fs-use-list_for_each_entry_reverse-and-kill-sb_entry include/linux/fs.h
--- a/include/linux/fs.h~fs-use-list_for_each_entry_reverse-and-kill-sb_entry
+++ a/include/linux/fs.h
@@ -977,7 +977,6 @@ extern int send_sigurg(struct fown_struc
 extern struct list_head super_blocks;
 extern spinlock_t sb_lock;
 
-#define sb_entry(list)	list_entry((list), struct super_block, s_list)
 #define S_BIAS (1<<30)
 struct super_block {
 	struct list_head	s_list;		/* Keep this first */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-dvb.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
