From: akpm@linux-foundation.org
Subject: - reiser4-specify-splice-file-operations.patch removed from -mm tree
Date: Thu, 01 May 2008 02:23:21 -0700
Message-ID: <200805010923.m419NLnh030088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755213AbYEAJX6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:23:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: specify splice file operations
has been removed from the -mm tree.  Its filename was
     reiser4-specify-splice-file-operations.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
reiser4.patch
reiser4-specify-splice-file-operations.patch
reiser4-fix-dummy-ioctl_cryptcompress.patch
reiser4-granulate-rw-serialization-when-accessing-file-conversion-set.patch
reiser4-fix-disk-cluster-synchronization.patch
reiser4-use-balance_dirty_pages_ratelimited_nr.patch
reiser4-correct-references-to-filemap_nopage.patch
reiser4-fix-null-pointer-dereference-in-reiser4_write_extent.patch
reiser4-code-cleanups.patch

