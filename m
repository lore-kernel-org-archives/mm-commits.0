From: akpm@linux-foundation.org
Subject: + ext2-convert-to-new-aops-fix.patch added to -mm tree
Date: Tue, 24 Jul 2007 15:14:57 -0700
Message-ID: <200707242214.l6OMEvmi003629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56707 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755899AbXGXWPH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 18:15:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     ext2 convert to new aops fix
has been added to the -mm tree.  Its filename is
     ext2-convert-to-new-aops-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext2 convert to new aops fix
From: Nick Piggin <npiggin@suse.de>

These are some write_begin aops conversion fixes for the current -mm tree.  I
didn't quite get it building, but did compile test at least.

Patches all address the same silly bug in my directory pagecache conversions.

ext2 directory code has a conversion overflow.  Spotted by Hugh Dickins. 
Probably would hurt anyone in practice unless they are using >4GB directories,
but must fix.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ext2/dir.c~ext2-convert-to-new-aops-fix fs/ext2/dir.c
--- a/fs/ext2/dir.c~ext2-convert-to-new-aops-fix
+++ a/fs/ext2/dir.c
@@ -424,7 +424,7 @@ ino_t ext2_inode_by_name(struct inode * 
 void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
 			struct page *page, struct inode *inode)
 {
-	loff_t pos = (page->index << PAGE_CACHE_SHIFT) +
+	loff_t pos = page_offset(page) +
 			(char *) de - (char *) page_address(page);
 	unsigned len = le16_to_cpu(de->rec_len);
 	int err;
@@ -511,7 +511,7 @@ int ext2_add_link (struct dentry *dentry
 	return -EINVAL;
 
 got_it:
-	pos = (page->index << PAGE_CACHE_SHIFT) +
+	pos = page_offset(page) +
 		(char*)de - (char*)page_address(page);
 	err = __ext2_write_begin(NULL, page->mapping, pos, rec_len, 0,
 							&page, NULL);
@@ -569,7 +569,7 @@ int ext2_delete_entry (struct ext2_dir_e
 	}
 	if (pde)
 		from = (char*)pde - (char*)page_address(page);
-	pos = (page->index << PAGE_CACHE_SHIFT) + from;
+	pos = page_offset(page) + from;
 	lock_page(page);
 	err = __ext2_write_begin(NULL, page->mapping, pos, to - from, 0,
 							&page, NULL);
_

Patches currently in -mm which might be from npiggin@suse.de are

geode-setup-correct-chipset-access-functions-fix.patch
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
ext2-convert-to-new-aops-fix.patch
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
ufs-convert-to-new-aops-fix.patch
udf-convert-to-new-aops.patch
udf-convert-to-new-aops-fix.patch
sysv-convert-to-new-aops.patch
sysv-convert-to-new-aops-fix.patch
minix-convert-to-new-aops.patch
minix-convert-to-new-aops-fix.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
affs-convert-to-new-aops-fix.patch
ocfs2-convert-to-new-aops.patch
fs-remove-some-aop_truncated_page.patch
fs-remove-some-aop_truncated_page-fix.patch
fs-reiserfs-cleanups.patch
documentation-update-sched-stattxt.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
reiser4-fix-for-new-aops-patches.patch
