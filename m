From: akpm@linux-foundation.org
Subject: + nfs-convert-to-new-aops.patch added to -mm tree
Date: Tue, 29 May 2007 14:20:34 -0700
Message-ID: <200705292120.l4TLKYr7011804@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751426AbXE2VUk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:20:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, Trond.Myklebust@netapp.com


The patch titled
     nfs: convert to new aops
has been added to the -mm tree.  Its filename is
     nfs-convert-to-new-aops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nfs: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/file.c |   49 +++++++++++++++++++++++++++++++++++-------------
 1 files changed, 36 insertions(+), 13 deletions(-)

diff -puN fs/nfs/file.c~nfs-convert-to-new-aops fs/nfs/file.c
--- a/fs/nfs/file.c~nfs-convert-to-new-aops
+++ a/fs/nfs/file.c
@@ -283,27 +283,50 @@ nfs_fsync(struct file *file, struct dent
 }
 
 /*
- * This does the "real" work of the write. The generic routine has
- * allocated the page, locked it, done all the page alignment stuff
- * calculations etc. Now we should just copy the data from user
- * space and write it back to the real medium..
+ * This does the "real" work of the write. We must allocate and lock the
+ * page to be sent back to the generic routine, which then copies the
+ * data from user space.
  *
  * If the writer ends up delaying the write, the writer needs to
  * increment the page use counts until he is done with the page.
  */
-static int nfs_prepare_write(struct file *file, struct page *page, unsigned offset, unsigned to)
-{
-	return nfs_flush_incompatible(file, page);
+static int nfs_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
+{
+	int ret;
+	pgoff_t index;
+	struct page *page;
+	index = pos >> PAGE_CACHE_SHIFT;
+
+	page = __grab_cache_page(mapping, index);
+	if (!page)
+		return -ENOMEM;
+	*pagep = page;
+
+	ret = nfs_flush_incompatible(file, page);
+	if (ret) {
+		unlock_page(page);
+		page_cache_release(page);
+	}
+	return ret;
 }
 
-static int nfs_commit_write(struct file *file, struct page *page, unsigned offset, unsigned to)
+static int nfs_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
 {
-	long status;
+	unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
+	int status;
 
 	lock_kernel();
-	status = nfs_updatepage(file, page, offset, to-offset);
+	status = nfs_updatepage(file, page, offset, copied);
 	unlock_kernel();
-	return status;
+
+	unlock_page(page);
+	page_cache_release(page);
+
+	return status < 0 ? status : copied;
 }
 
 static void nfs_invalidate_page(struct page *page, unsigned long offset)
@@ -331,8 +354,8 @@ const struct address_space_operations nf
 	.set_page_dirty = nfs_set_page_dirty,
 	.writepage = nfs_writepage,
 	.writepages = nfs_writepages,
-	.prepare_write = nfs_prepare_write,
-	.commit_write = nfs_commit_write,
+	.write_begin = nfs_write_begin,
+	.write_end = nfs_write_end,
 	.invalidatepage = nfs_invalidate_page,
 	.releasepage = nfs_release_page,
 #ifdef CONFIG_NFS_DIRECTIO
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
git-arm-master.patch
slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
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
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
