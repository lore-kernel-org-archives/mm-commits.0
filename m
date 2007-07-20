From: akpm@linux-foundation.org
Subject: + fix-some-conversion-overflows.patch added to -mm tree
Date: Thu, 19 Jul 2007 23:10:43 -0700
Message-ID: <200707200610.l6K6AhwV010852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49622 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754441AbXGTGL0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 02:11:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, mark.fasheh@oracle.com, mhalcrow@us.ibm.com


The patch titled
     fix some conversion overflows
has been added to the -mm tree.  Its filename is
     fix-some-conversion-overflows.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix some conversion overflows
From: Nick Piggin <npiggin@suse.de>

Fix page index to offset conversion overflows in buffer layer, ecryptfs,
and ocfs2.

It would be nice to convert the whole tree to page_offset, but for now
just fix the bugs.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/mmap.c |    5 ++---
 fs/ocfs2/mmap.c    |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/ecryptfs/mmap.c~fix-some-conversion-overflows fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~fix-some-conversion-overflows
+++ a/fs/ecryptfs/mmap.c
@@ -409,8 +409,7 @@ static int ecryptfs_prepare_write(struct
 	if (!PageUptodate(page))
 		rc = ecryptfs_do_readpage(file, page, page->index);
 	if (page->index != 0) {
-		loff_t end_of_prev_pg_pos =
-			(((loff_t)page->index << PAGE_CACHE_SHIFT) - 1);
+		loff_t end_of_prev_pg_pos = page_offset(page) - 1;
 
 		if (end_of_prev_pg_pos > i_size_read(page->mapping->host)) {
 			rc = ecryptfs_truncate(file->f_path.dentry,
@@ -736,7 +735,7 @@ static int ecryptfs_commit_write(struct 
 		goto out;
 	}
 	inode->i_blocks = lower_inode->i_blocks;
-	pos = (page->index << PAGE_CACHE_SHIFT) + to;
+	pos = page_offset(page) + to;
 	if (pos > i_size_read(inode)) {
 		i_size_write(inode, pos);
 		ecryptfs_printk(KERN_DEBUG, "Expanded file size to "
diff -puN fs/ocfs2/mmap.c~fix-some-conversion-overflows fs/ocfs2/mmap.c
--- a/fs/ocfs2/mmap.c~fix-some-conversion-overflows
+++ a/fs/ocfs2/mmap.c
@@ -89,7 +89,7 @@ static int __ocfs2_page_mkwrite(struct i
 {
 	int ret;
 	struct address_space *mapping = inode->i_mapping;
-	loff_t pos = page->index << PAGE_CACHE_SHIFT;
+	loff_t pos = page_offset(page);
 	unsigned int len = PAGE_CACHE_SIZE;
 	pgoff_t last_index;
 	struct page *locked_page = NULL;
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
fix-some-conversion-overflows.patch
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
introduce-write_begin-write_end-aops-important-fix.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext3-convert-to-new-aops.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops.patch
ext4-convert-to-new-aops-fix.patch
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
reiserfs-convert-to-new-aops-fix.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
hostfs-convert-to-new-aops-fix.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
udf-convert-to-new-aops.patch
udf-convert-to-new-aops-fix.patch
sysv-convert-to-new-aops.patch
minix-convert-to-new-aops.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
affs-convert-to-new-aops-fix.patch
ocfs2-convert-to-new-aops.patch
fs-remove-some-aop_truncated_page.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
reiser4-fix-for-new-aops-patches.patch
