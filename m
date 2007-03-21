From: akpm@linux-foundation.org
Subject: + turn-do_sync_file_range-into-do_sync_mapping_range.patch added to -mm tree
Date: Wed, 21 Mar 2007 16:54:23 -0700
Message-ID: <200703212354.l2LNsOU6007477@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59898 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934098AbXCUXyh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 19:54:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mark.fasheh@oracle.com, hch@lst.de


The patch titled
     Turn do_sync_file_range() into do_sync_mapping_range()
has been added to the -mm tree.  Its filename is
     turn-do_sync_file_range-into-do_sync_mapping_range.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Turn do_sync_file_range() into do_sync_mapping_range()
From: Mark Fasheh <mark.fasheh@oracle.com>

do_sync_file_range() accepts a file * from which it takes an address_space to
sync.  Abstract out the bulk of the function into do_sync_mapping_range()
which takes the address_space directly.  This way callers who want to sync an
address_space directly can take advantage of the functionality provided.

do_sync_file_range() is preserved as a small wrapper around
do_sync_mapping_range().

Ocfs2 in particular would like to use this to initiate a sync of a specific
inode range during truncate, where a file * may not be available.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sync.c          |    8 +++-----
 include/linux/fs.h |    9 +++++++--
 2 files changed, 10 insertions(+), 7 deletions(-)

diff -puN fs/sync.c~turn-do_sync_file_range-into-do_sync_mapping_range fs/sync.c
--- a/fs/sync.c~turn-do_sync_file_range-into-do_sync_mapping_range
+++ a/fs/sync.c
@@ -239,13 +239,11 @@ out:
 /*
  * `endbyte' is inclusive
  */
-int do_sync_file_range(struct file *file, loff_t offset, loff_t endbyte,
-			unsigned int flags)
+int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
+			  loff_t endbyte, unsigned int flags)
 {
 	int ret;
-	struct address_space *mapping;
 
-	mapping = file->f_mapping;
 	if (!mapping) {
 		ret = -EINVAL;
 		goto out;
@@ -275,4 +273,4 @@ int do_sync_file_range(struct file *file
 out:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(do_sync_file_range);
+EXPORT_SYMBOL_GPL(do_sync_mapping_range);
diff -puN include/linux/fs.h~turn-do_sync_file_range-into-do_sync_mapping_range include/linux/fs.h
--- a/include/linux/fs.h~turn-do_sync_file_range-into-do_sync_mapping_range
+++ a/include/linux/fs.h
@@ -845,8 +845,13 @@ extern int fcntl_setlease(unsigned int f
 extern int fcntl_getlease(struct file *filp);
 
 /* fs/sync.c */
-extern int do_sync_file_range(struct file *file, loff_t offset, loff_t endbyte,
-			unsigned int flags);
+extern int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
+			loff_t endbyte, unsigned int flags);
+static inline int do_sync_file_range(struct file *file, loff_t offset,
+			loff_t endbyte, unsigned int flags)
+{
+	return do_sync_mapping_range(file->f_mapping, offset, endbyte, flags);
+}
 
 /* fs/locks.c */
 extern void locks_init_lock(struct file_lock *);
_

Patches currently in -mm which might be from mark.fasheh@oracle.com are

git-ocfs2.patch
turn-do_sync_file_range-into-do_sync_mapping_range.patch
remove-do_sync_file_range.patch
