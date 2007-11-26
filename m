From: akpm@linux-foundation.org
Subject: + fs-use-list_for_each_entry_reverse-and-kill-sb_entry.patch added to -mm tree
Date: Mon, 26 Nov 2007 00:04:09 -0800
Message-ID: <200711260804.lAQ849wA023537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38479 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753300AbXKZIEM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 03:04:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     fs: use list_for_each_entry_reverse and kill sb_entry
has been added to the -mm tree.  Its filename is
     fs-use-list_for_each_entry_reverse-and-kill-sb_entry.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -514,8 +514,7 @@ writeback_inodes(struct writeback_contro
 	might_sleep();
 	spin_lock(&sb_lock);
 restart:
-	sb = sb_entry(super_blocks.prev);
-	for (; sb != sb_entry(&super_blocks); sb = sb_entry(sb->s_list.prev)) {
+	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
 		if (sb_has_dirty_inodes(sb)) {
 			/* we're making our own get_super here */
 			sb->s_count++;
@@ -580,10 +579,8 @@ static void set_sb_syncing(int val)
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
@@ -974,7 +974,6 @@ extern int send_sigurg(struct fown_struc
 extern struct list_head super_blocks;
 extern spinlock_t sb_lock;
 
-#define sb_entry(list)	list_entry((list), struct super_block, s_list)
 #define S_BIAS (1<<30)
 struct super_block {
 	struct list_head	s_list;		/* Keep this first */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

fs-use-hlist_unhashed.patch
power-use-kasprintf.patch
partitions-use-kasprintf.patch
fs-use-list_for_each_entry_reverse-and-kill-sb_entry.patch
