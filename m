From: akpm@linux-foundation.org
Subject: - fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:51:04 -0700
Message-ID: <200710192251.l9JMp4jm024152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57987 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760682AbXJSXFK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs/file_table.c: use list_for_each_entry() instead of list_for_each()
has been removed from the -mm tree.  Its filename was
     fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/file_table.c: use list_for_each_entry() instead of list_for_each()
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

fs/file_table.c: use list_for_each_entry() instead of list_for_each()
in fs_may_remount_ro()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/file_table.c~fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each fs/file_table.c
--- a/fs/file_table.c~fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each
+++ a/fs/file_table.c
@@ -323,12 +323,11 @@ void file_kill(struct file *file)
 
 int fs_may_remount_ro(struct super_block *sb)
 {
-	struct list_head *p;
+	struct file *file;
 
 	/* Check that no files are currently opened for writing. */
 	file_list_lock();
-	list_for_each(p, &sb->s_files) {
-		struct file *file = list_entry(p, struct file, f_u.fu_list);
+	list_for_each_entry(file, &sb->s_files, f_u.fu_list) {
 		struct inode *inode = file->f_path.dentry->d_inode;
 
 		/* File with pending delete? */
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch
ftdi-elan-driver-convert-ftdi-u132_lock-to-mutex.patch
