From: akpm@linux-foundation.org
Subject: + sysv-convert-to-new-aops-fix.patch added to -mm tree
Date: Tue, 24 Jul 2007 15:15:09 -0700
Message-ID: <200707242215.l6OMF9Fj003643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37506 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756724AbXGXWPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 18:15:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     sysv convert to new aops fix
has been added to the -mm tree.  Its filename is
     sysv-convert-to-new-aops-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysv convert to new aops fix
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/dir.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/sysv/dir.c~sysv-convert-to-new-aops-fix fs/sysv/dir.c
--- a/fs/sysv/dir.c~sysv-convert-to-new-aops-fix
+++ a/fs/sysv/dir.c
@@ -219,7 +219,7 @@ int sysv_add_link(struct dentry *dentry,
 	return -EINVAL;
 
 got_it:
-	pos = (page->index << PAGE_CACHE_SHIFT) +
+	pos = page_offset(page) +
 			(char*)de - (char*)page_address(page);
 	lock_page(page);
 	err = __sysv_write_begin(NULL, page->mapping, pos, SYSV_DIRSIZE,
@@ -246,7 +246,7 @@ int sysv_delete_entry(struct sysv_dir_en
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = (struct inode*)mapping->host;
 	char *kaddr = (char*)page_address(page);
-	loff_t pos = (page->index << PAGE_CACHE_SHIFT) + (char *)de - kaddr;
+	loff_t pos = page_offset(page) + (char *)de - kaddr;
 	int err;
 
 	lock_page(page);
@@ -347,7 +347,7 @@ void sysv_set_link(struct sysv_dir_entry
 {
 	struct address_space *mapping = page->mapping;
 	struct inode *dir = mapping->host;
-	loff_t pos = (page->index << PAGE_CACHE_SHIFT) +
+	loff_t pos = page_offset(page) +
 			(char *)de-(char*)page_address(page);
 	int err;
 
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
