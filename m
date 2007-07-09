From: akpm@linux-foundation.org
Subject: - fs-introduce-write_begin-write_end-and-perform_write-aops-fix-4.patch removed from -mm tree
Date: Mon, 09 Jul 2007 13:39:59 -0700
Message-ID: <200707092039.l69KdxE2010075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57960 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754723AbXGIUkw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 16:40:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, dmonakhov@sw.ru, mark.fasheh@oracle.com, pbadari@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs-introduce-write_begin-write_end-and-perform_write-aops fix 4
has been removed from the -mm tree.  Its filename was
     fs-introduce-write_begin-write_end-and-perform_write-aops-fix-4.patch

This patch was dropped because it was folded into fs-introduce-write_begin-write_end-and-perform_write-aops.patch

------------------------------------------------------
Subject: fs-introduce-write_begin-write_end-and-perform_write-aops fix 4
From: Nick Piggin <npiggin@suse.de>

Dmitriy noticed that iov_iter_fault_in_readable could go past the end
of the first iov in a multi-iov situation, and that could be considered
an EFAULT by the caller. Fix and comment.

Fixes: fs-introduce-write_begin-write_end-and-perform_write-aops.patch

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Badari Pulavarty <pbadari@gmail.com>
Cc: Dmitriy Monakhov <dmonakhov@sw.ru>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN mm/filemap.c~fs-introduce-write_begin-write_end-and-perform_write-aops-fix-4 mm/filemap.c
--- a/mm/filemap.c~fs-introduce-write_begin-write_end-and-perform_write-aops-fix-4
+++ a/mm/filemap.c
@@ -1774,9 +1774,19 @@ void iov_iter_advance(struct iov_iter *i
 	i->count -= bytes;
 }
 
+/*
+ * Fault in the first iovec of the given iov_iter, to a maximum length
+ * of bytes. Returns 0 on success, or non-zero if the memory could not be
+ * accessed (ie. because it is an invalid address).
+ *
+ * writev-intensive code may want this to prefault several iovecs -- that
+ * would be possible (callers must not rely on the fact that _only_ the
+ * first iovec will be faulted with the current implementation).
+ */
 int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes)
 {
 	char __user *buf = i->iov->iov_base + i->iov_offset;
+	bytes = min(bytes, i->iov->iov_len - i->iov_offset);
 	return fault_in_pages_readable(buf, bytes);
 }
 
_

Patches currently in -mm which might be from npiggin@suse.de are

slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
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
fs-introduce-write_begin-write_end-and-perform_write-aops-fix-4.patch
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
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
ufs-convert-to-new-aops-fix.patch
udf-convert-to-new-aops.patch
sysv-convert-to-new-aops.patch
sysv-convert-to-new-aops-fix.patch
minix-convert-to-new-aops.patch
minix-convert-to-new-aops-fix.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
ocfs2-convert-to-new-aops.patch
fix-read-truncate-race.patch
fs-remove-some-aop_truncated_page.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
reiser4-fix-for-new-aops-patches.patch
