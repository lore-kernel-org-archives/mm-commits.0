From: akpm@linux-foundation.org
Subject: - ext4-convert-to-new-aops-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:14:47 -0700
Message-ID: <200710160414.l9G4EljB008213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59290 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695AbXJPEPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:15:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, dmonakhov@sw.ru, mark.fasheh@oracle.com, pbadari@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ext4-convert-to-new-aops fix
has been removed from the -mm tree.  Its filename was
     ext4-convert-to-new-aops-fix.patch

This patch was dropped because it was folded into ext4-convert-to-new-aops.patch

------------------------------------------------------
Subject: ext4-convert-to-new-aops fix
From: Nick Piggin <npiggin@suse.de>

Don't move journal_stop from under page lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Badari Pulavarty <pbadari@gmail.com>
Cc: Dmitriy Monakhov <dmonakhov@sw.ru>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c |   44 +++++++++++++++++++++++++++++++++++++-------
 1 files changed, 37 insertions(+), 7 deletions(-)

diff -puN fs/ext4/inode.c~ext4-convert-to-new-aops-fix fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-convert-to-new-aops-fix
+++ a/fs/ext4/inode.c
@@ -36,6 +36,7 @@
 #include <linux/mpage.h>
 #include <linux/uio.h>
 #include <linux/bio.h>
+#include <linux/swap.h> /* mark_page_accessed */
 #include "xattr.h"
 #include "acl.h"
 
@@ -1215,6 +1216,31 @@ static int write_end_fn(handle_t *handle
 }
 
 /*
+ * Generic write_end handler for ordered and writeback ext4 journal modes.
+ * We can't use generic_write_end, because that unlocks the page and we need to
+ * unlock the page after ext4_journal_stop, but ext4_journal_stop must run
+ * after block_write_end.
+ */
+static int ext4_generic_write_end(struct file *file,
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
@@ -1248,17 +1274,17 @@ static int ext4_ordered_write_end(struct
 		new_i_size = pos + copied;
 		if (new_i_size > EXT4_I(inode)->i_disksize)
 			EXT4_I(inode)->i_disksize = new_i_size;
-		copied = generic_write_end(file, mapping, pos, len, copied,
+		copied = ext4_generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
 		if (copied < 0)
 			ret = copied;
-	} else {
-		unlock_page(page);
-		page_cache_release(page);
 	}
 	ret2 = ext4_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
+	unlock_page(page);
+	page_cache_release(page);
+
 	return ret ? ret : copied;
 }
 
@@ -1276,7 +1302,7 @@ static int ext4_writeback_write_end(stru
 	if (new_i_size > EXT4_I(inode)->i_disksize)
 		EXT4_I(inode)->i_disksize = new_i_size;
 
-	copied = generic_write_end(file, mapping, pos, len, copied,
+	copied = ext4_generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
 	if (copied < 0)
 		ret = copied;
@@ -1284,6 +1310,9 @@ static int ext4_writeback_write_end(stru
 	ret2 = ext4_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
+	unlock_page(page);
+	page_cache_release(page);
+
 	return ret ? ret : copied;
 }
 
@@ -1311,8 +1340,6 @@ static int ext4_journalled_write_end(str
 				to, &partial, write_end_fn);
 	if (!partial)
 		SetPageUptodate(page);
-	unlock_page(page);
-	page_cache_release(page);
 	if (pos+copied > inode->i_size)
 		i_size_write(inode, pos+copied);
 	EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
@@ -1326,6 +1353,9 @@ static int ext4_journalled_write_end(str
 	ret2 = ext4_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
+	unlock_page(page);
+	page_cache_release(page);
+
 	return ret ? ret : copied;
 }
 
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
remove-zero_page.patch
mm-use-lockless-radix-tree-probe.patch
mm-improve-find_lock_page.patch
mm-clarify-__add_to_swap_cache-locking.patch
radix-tree-use-indirect-bit.patch
calculation-of-pgoff-in-do_linear_fault-uses-mixed.patch
fs-fix-nobh-error-handling.patch
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
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext3-convert-to-new-aops.patch
ext4-convert-to-new-aops.patch
ext4-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops-fix-fix.patch
xfs-convert-to-new-aops.patch
gfs2-convert-to-new-aops-fix.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-convert-to-new-aops-fix.patch
reiserfs-convert-to-new-aops-fix2.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
hostfs-convert-to-new-aops-fix.patch
hostfs-convert-to-new-aops-fix-fix.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
ufs-convert-to-new-aops-fix.patch
ufs-convert-to-new-aops-fix2.patch
udf-convert-to-new-aops.patch
udf-convert-to-new-aops-fix.patch
sysv-convert-to-new-aops.patch
sysv-convert-to-new-aops-fix.patch
sysv-convert-to-new-aops-fix2.patch
minix-convert-to-new-aops.patch
minix-convert-to-new-aops-fix.patch
minix-convert-to-new-aops-fix2.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
affs-convert-to-new-aops-fix.patch
affs-convert-to-new-aops-fix-fix.patch
ocfs2-convert-to-new-aops.patch
fs-restore-nobh.patch
fs-restore-nobh-checkpatch-fixes.patch
fs-remove-some-aop_truncated_page.patch
make-swappiness-safer-to-use.patch
mm-document-tree_lock-zonelock-lockorder.patch
fs-reiserfs-cleanups.patch
atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
bitops-introduce-lock-ops.patch
alpha-fix-bitops.patch
alpha-lock-bitops.patch
alpha-lock-bitops-fix.patch
ia64-lock-bitops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
bit_spin_lock-use-lock-bitops.patch
reiser4-fix-for-new-aops-patches.patch
