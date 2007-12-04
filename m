From: akpm@linux-foundation.org
Subject: + reiser4-specify-splice-file-operations.patch added to -mm tree
Date: Tue, 04 Dec 2007 12:19:34 -0800
Message-ID: <200712042019.lB4KJYbG003119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45126 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbXLDUUf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 15:20:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward.shishkin@gmail.com, jens.axboe@oracle.com


The patch titled
     reiser4: specify splice file operations
has been added to the -mm tree.  Its filename is
     reiser4-specify-splice-file-operations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiser4: specify splice file operations
From: Edward Shishkin <edward.shishkin@gmail.com>

Specify splice_read, splice_write file operations for loopback
functionality.

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/cryptcompress.c |    3 ++-
 fs/reiser4/plugin/object.c             |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-specify-splice-file-operations fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-specify-splice-file-operations
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -3747,13 +3747,14 @@ int release_cryptcompress(struct inode *
 int prepare_write_cryptcompress(struct file *file, struct page *page,
 				unsigned from, unsigned to)
 {
-	return 0;
+	return -EINVAL;
 }
 
 /* plugin->commit_write */
 int commit_write_cryptcompress(struct file *file, struct page *page,
 			       unsigned from, unsigned to)
 {
+	BUG();
 	return 0;
 }
 
diff -puN fs/reiser4/plugin/object.c~reiser4-specify-splice-file-operations fs/reiser4/plugin/object.c
--- a/fs/reiser4/plugin/object.c~reiser4-specify-splice-file-operations
+++ a/fs/reiser4/plugin/object.c
@@ -103,7 +103,9 @@ static struct file_operations regular_fi
 	.mmap = reiser4_mmap_careful,
 	.open = reiser4_open_careful,
 	.release = reiser4_release_careful,
-	.fsync = reiser4_sync_file_common
+	.fsync = reiser4_sync_file_common,
+	.splice_read = generic_file_splice_read,
+	.splice_write = generic_file_splice_write
 };
 static struct address_space_operations regular_file_a_ops = {
 	.writepage = reiser4_writepage,
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

reiser4-specify-splice-file-operations.patch
