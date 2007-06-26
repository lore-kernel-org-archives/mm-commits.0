From: akpm@linux-foundation.org
Subject: + ext3-convert-to-new-aops-fix.patch added to -mm tree
Date: Tue, 26 Jun 2007 14:39:30 -0700
Message-ID: <200706262139.l5QLdUjW002631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57928 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751482AbXFZVkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 17:40:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, dmonakhov@sw.ru, mark.fasheh@oracle.com, pbadari@gmail.com


The patch titled
     ext3-convert-to-new-aops fix
has been added to the -mm tree.  Its filename is
     ext3-convert-to-new-aops-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext3-convert-to-new-aops fix
From: Nick Piggin <npiggin@suse.de>

Don't move journal_stop from under page lock.

Fixes: ext3-convert-to-new-aops.patch

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Badari Pulavarty <pbadari@gmail.com>
Cc: Dmitriy Monakhov <dmonakhov@sw.ru>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |   44 +++++++++++++++++++++++++++++++++++++-------
 1 files changed, 37 insertions(+), 7 deletions(-)

diff -puN fs/ext3/inode.c~ext3-convert-to-new-aops-fix fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-convert-to-new-aops-fix
+++ a/fs/ext3/inode.c
@@ -36,6 +36,7 @@
 #include <linux/mpage.h>
 #include <linux/uio.h>
 #include <linux/bio.h>
+#include <linux/swap.h> /* mark_page_accessed */
 #include "xattr.h"
 #include "acl.h"
 
@@ -1217,6 +1218,31 @@ static int write_end_fn(handle_t *handle
 }
 
 /*
+ * Generic write_end handler for ordered and writeback ext3 journal modes.
+ * We can't use generic_write_end, because that unlocks the page and we need to
+ * unlock the page after ext3_journal_stop, but ext3_journal_stop must run
+ * after block_write_end.
+ */
+static int ext3_generic_write_end(struct file *file,
+				struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
+{
+	struct inode *inode = file->f_mapping->host;
+
+	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
+
+	mark_page_accessed(page);
+
+	if (pos+copied > inode->i_size) {
+		i_size_write(inode, pos+copied);
+		mark_inode_dirty(inode);
+	}
+
+	return copied;
+}
+
+/*
  * We need to pick up the new inode size which generic_commit_write gave us
  * `file' can be NULL - eg, when called from page_symlink().
  *
@@ -1250,17 +1276,17 @@ static int ext3_ordered_write_end(struct
 		new_i_size = pos + copied;
 		if (new_i_size > EXT3_I(inode)->i_disksize)
 			EXT3_I(inode)->i_disksize = new_i_size;
-		copied = generic_write_end(file, mapping, pos, len, copied,
+		copied = ext3_generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
 		if (copied < 0)
 			ret = copied;
-	} else {
-		unlock_page(page);
-		page_cache_release(page);
 	}
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
+	unlock_page(page);
+	page_cache_release(page);
+
 	return ret ? ret : copied;
 }
 
@@ -1278,7 +1304,7 @@ static int ext3_writeback_write_end(stru
 	if (new_i_size > EXT3_I(inode)->i_disksize)
 		EXT3_I(inode)->i_disksize = new_i_size;
 
-	copied = generic_write_end(file, mapping, pos, len, copied,
+	copied = ext3_generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
 	if (copied < 0)
 		ret = copied;
@@ -1286,6 +1312,9 @@ static int ext3_writeback_write_end(stru
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
+	unlock_page(page);
+	page_cache_release(page);
+
 	return ret ? ret : copied;
 }
 
@@ -1313,8 +1342,6 @@ static int ext3_journalled_write_end(str
 				to, &partial, write_end_fn);
 	if (!partial)
 		SetPageUptodate(page);
-	unlock_page(page);
-	page_cache_release(page);
 	if (pos+copied > inode->i_size)
 		i_size_write(inode, pos+copied);
 	EXT3_I(inode)->i_state |= EXT3_STATE_JDATA;
@@ -1328,6 +1355,9 @@ static int ext3_journalled_write_end(str
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
+	unlock_page(page);
+	page_cache_release(page);
+
 	return ret ? ret : copied;
 }
 
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-kill-validate_anon_vma-to-avoid-mapcount-bug.patch
slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-merge-nopfn-into-fault-spufs-fix.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix-3.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix-4.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext3-convert-to-new-aops.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops.patch
xfs-convert-to-new-aops.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
udf-convert-to-new-aops.patch
sysv-convert-to-new-aops.patch
minix-convert-to-new-aops.patch
jfs-convert-to-new-aops.patch
fix-read-truncate-race.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
