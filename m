From: akpm@linux-foundation.org
Subject: + fs-introduce-write_begin-write_end-and-perform_write-aops-fix-3.patch added to -mm tree
Date: Tue, 26 Jun 2007 14:38:07 -0700
Message-ID: <200706262138.l5QLc7ow002612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53990 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751817AbXFZVjB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 17:39:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, dmonakhov@sw.ru, mark.fasheh@oracle.com, pbadari@gmail.com


The patch titled
     fs-introduce-write_begin-write_end-and-perform_write-aops fix 3
has been added to the -mm tree.  Its filename is
     fs-introduce-write_begin-write_end-and-perform_write-aops-fix-3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs-introduce-write_begin-write_end-and-perform_write-aops fix 3
From: Nick Piggin <npiggin@suse.de>

Dmitriy noticed some weird code I had in __page_symlink that is wrong.

Fixes: fs-introduce-write_begin-write_end-and-perform_write-aops.patch

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Badari Pulavarty <pbadari@gmail.com>
Cc: Dmitriy Monakhov <dmonakhov@sw.ru>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/namei.c~fs-introduce-write_begin-write_end-and-perform_write-aops-fix-3 fs/namei.c
--- a/fs/namei.c~fs-introduce-write_begin-write_end-and-perform_write-aops-fix-3
+++ a/fs/namei.c
@@ -2702,21 +2702,20 @@ int __page_symlink(struct inode *inode, 
 	char *kaddr;
 
 retry:
-	err = pagecache_write_begin(NULL, mapping, 0, PAGE_CACHE_SIZE,
+	err = pagecache_write_begin(NULL, mapping, 0, len-1,
 				AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
 	if (err)
 		goto fail;
 
 	kaddr = kmap_atomic(page, KM_USER0);
 	memcpy(kaddr, symname, len-1);
-	memset(kaddr+len-1, 0, PAGE_CACHE_SIZE-(len-1));
 	kunmap_atomic(kaddr, KM_USER0);
 
-	err = pagecache_write_end(NULL, mapping, 0, PAGE_CACHE_SIZE, PAGE_CACHE_SIZE,
+	err = pagecache_write_end(NULL, mapping, 0, len-1, len-1,
 							page, fsdata);
 	if (err < 0)
 		goto fail;
-	if (err < PAGE_CACHE_SIZE)
+	if (err < len-1)
 		goto retry;
 
 	mark_inode_dirty(inode);
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
fix-read-truncate-race.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
