From: akpm@linux-foundation.org
Subject: + fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:07:56 -0700
Message-ID: <200707210007.l6L07uGa023478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33711 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549AbXGUAIE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:08:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com


The patch titled
     fs/file_table.c: use list_for_each_entry() instead of list_for_each()
has been added to the -mm tree.  Its filename is
     fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/file_table.c: use list_for_each_entry() instead of list_for_each()
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

fs/file_table.c: use list_for_each_entry() instead of list_for_each()
in fs_may_remount_ro()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/file_table.c~fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each fs/file_table.c
--- a/fs/file_table.c~fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each
+++ a/fs/file_table.c
@@ -263,12 +263,11 @@ void file_kill(struct file *file)
 
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
kcopyd-use-mutex-instead-of-semaphore.patch
git-mtd.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch
fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch
