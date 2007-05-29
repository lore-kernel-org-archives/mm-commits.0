From: akpm@linux-foundation.org
Subject: + fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch added to -mm tree
Date: Tue, 29 May 2007 15:38:13 -0700
Message-ID: <200705292238.l4TMcDBc013370@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254AbXE2WiR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 18:38:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     fs: introduce write_begin, write_end, and perform_write aops (revoke)
has been added to the -mm tree.  Its filename is
     fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs: introduce write_begin, write_end, and perform_write aops (revoke)
From: Nick Piggin <npiggin@suse.de>

These are intended to replace prepare_write and commit_write with more
flexible alternatives that are also able to avoid the buffered write deadlock
problems efficiently (which prepare_write is unable to do).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 filemap.c          |    0 
 fs/revoked_inode.c |   14 ++++++++++++++
 2 files changed, 14 insertions(+)

diff -puN Documentation/filesystems/Locking~fs-introduce-write_begin-write_end-and-perform_write-aops-revoke Documentation/filesystems/Locking
diff -puN Documentation/filesystems/vfs.txt~fs-introduce-write_begin-write_end-and-perform_write-aops-revoke Documentation/filesystems/vfs.txt
diff -puN drivers/block/loop.c~fs-introduce-write_begin-write_end-and-perform_write-aops-revoke drivers/block/loop.c
diff -puN fs/buffer.c~fs-introduce-write_begin-write_end-and-perform_write-aops-revoke fs/buffer.c
diff -puN fs/libfs.c~fs-introduce-write_begin-write_end-and-perform_write-aops-revoke fs/libfs.c
diff -puN fs/namei.c~fs-introduce-write_begin-write_end-and-perform_write-aops-revoke fs/namei.c
diff -puN fs/revoked_inode.c~fs-introduce-write_begin-write_end-and-perform_write-aops-revoke fs/revoked_inode.c
--- a/fs/revoked_inode.c~fs-introduce-write_begin-write_end-and-perform_write-aops-revoke
+++ a/fs/revoked_inode.c
@@ -384,6 +384,20 @@ static int revoked_commit_write(struct f
 	return -EIO;
 }
 
+static int revoked_write_begin(struct file *file, struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned flags,
+				struct page **pagep, void **fsdata)
+{
+	return -EIO;
+}
+
+static int revoked_write_end(struct file *file, struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
+{
+	return -EIO;
+}
+
 static ssize_t revoked_direct_IO(int rw, struct kiocb *iocb,
 				 const struct iovec *iov, loff_t offset,
 				 unsigned long nr_segs)
diff -puN fs/splice.c~fs-introduce-write_begin-write_end-and-perform_write-aops-revoke fs/splice.c
diff -puN include/linux/buffer_head.h~fs-introduce-write_begin-write_end-and-perform_write-aops-revoke include/linux/buffer_head.h
diff -puN include/linux/fs.h~fs-introduce-write_begin-write_end-and-perform_write-aops-revoke include/linux/fs.h
diff -puN include/linux/pagemap.h~fs-introduce-write_begin-write_end-and-perform_write-aops-revoke include/linux/pagemap.h
diff -puN mm/filemap.c~fs-introduce-write_begin-write_end-and-perform_write-aops-revoke mm/filemap.c
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
