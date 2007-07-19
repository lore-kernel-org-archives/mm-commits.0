From: akpm@linux-foundation.org
Subject: + reiserfs-convert-to-new-aops-fix.patch added to -mm tree
Date: Wed, 18 Jul 2007 19:52:40 -0700
Message-ID: <200707190252.l6J2qeQ3010251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42308 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757659AbXGSCww (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 22:52:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, hugh@veritas.com


The patch titled
     reiserfs convert to new aops fix
has been added to the -mm tree.  Its filename is
     reiserfs-convert-to-new-aops-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiserfs convert to new aops fix
From: Nick Piggin <npiggin@suse.de>

Lock ordering fix for the same problem for reiserfs.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/inode.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/reiserfs/inode.c~reiserfs-convert-to-new-aops-fix fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~reiserfs-convert-to-new-aops-fix
+++ a/fs/reiserfs/inode.c
@@ -2695,9 +2695,6 @@ static int reiserfs_write_end(struct fil
 	flush_dcache_page(page);
 
 	reiserfs_commit_page(inode, page, start, start + copied);
-	unlock_page(page);
-	mark_page_accessed(page);
-	page_cache_release(page);
 
 	/* generic_commit_write does this for us, but does not update the
 	 ** transaction tracking stuff when the size changes.  So, we have
@@ -2747,6 +2744,9 @@ static int reiserfs_write_end(struct fil
 	}
 
       out:
+	unlock_page(page);
+	mark_page_accessed(page);
+	page_cache_release(page);
 	return ret == 0 ? copied : ret;
 
       journal_error:
@@ -2758,7 +2758,7 @@ static int reiserfs_write_end(struct fil
 		reiserfs_write_unlock(inode->i_sb);
 	}
 
-	return ret;
+	goto out;
 }
 
 int reiserfs_commit_write(struct file *f, struct page *page,
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-fault-feedback-1.patch
mm-fault-feedback-2.patch
mm-fault-feedback-2-fix.patch
mm-fault-feedback-2-fix-2.patch
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
