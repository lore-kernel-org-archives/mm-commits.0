From: akpm@linux-foundation.org
Subject: + introduce-write_begin-write_end-aops-fix2.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:16:27 -0700
Message-ID: <200708311816.l7VIGRKp020323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35147 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965785AbXHaSQc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:16:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     introduce write_begin write_end aops fix2
has been added to the -mm tree.  Its filename is
     introduce-write_begin-write_end-aops-fix2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: introduce write_begin write_end aops fix2
From: Nick Piggin <npiggin@suse.de>

Callers should do the mark_page_accessed, as it is more flexible and in
some contexts they don't want to be doing so, eg.  dir-in-pagecache writes
into buffer cache (although that's debateable, it wouldn't be possible if
write_end() did the mark_page_accessed()).

Subsequent patches contain fixes either to take mark_page_accessed out of
their write_end implementation, or in the case of dir-in-pagecache
filesystems, I had incorrectly added a mark_page_accessed where there was
previously none (it looks like the logical place to mark the page accessed,
but changing behaviour is obviously wrong for this bugfix series).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c  |    1 -
 mm/filemap.c |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/buffer.c~introduce-write_begin-write_end-aops-fix2 fs/buffer.c
--- a/fs/buffer.c~introduce-write_begin-write_end-aops-fix2
+++ a/fs/buffer.c
@@ -2052,7 +2052,6 @@ int generic_write_end(struct file *file,
 	}
 
 	unlock_page(page);
-	mark_page_accessed(page);
 	page_cache_release(page);
 
 	return copied;
diff -puN mm/filemap.c~introduce-write_begin-write_end-aops-fix2 mm/filemap.c
--- a/mm/filemap.c~introduce-write_begin-write_end-aops-fix2
+++ a/mm/filemap.c
@@ -1913,6 +1913,7 @@ int pagecache_write_end(struct file *fil
 	int ret;
 
 	if (aops->write_end) {
+		mark_page_accessed(page);
 		ret = aops->write_end(file, mapping, pos, len, copied,
 							page, fsdata);
 	} else {
@@ -1922,6 +1923,7 @@ int pagecache_write_end(struct file *fil
 		flush_dcache_page(page);
 		ret = aops->commit_write(file, page, offset, offset+len);
 		unlock_page(page);
+		mark_page_accessed(page);
 		page_cache_release(page);
 		BUG_ON(ret == AOP_TRUNCATED_PAGE); /* can't deal with */
 
_

Patches currently in -mm which might be from npiggin@suse.de are

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
introduce-write_begin-write_end-aops-important-fix.patch
introduce-write_begin-write_end-aops-fix2.patch
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
make-swappiness-safer-to-use.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
reiser4-fix-for-new-aops-patches.patch
