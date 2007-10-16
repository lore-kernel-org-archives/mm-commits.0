From: akpm@linux-foundation.org
Subject: - revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:31:56 -0700
Message-ID: <200710162031.l9GKVu8g014542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41537 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933431AbXJPVe1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:34:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     Revert 81b0c8713385ce1b1b9058e916edcf9561ad76d6
has been removed from the -mm tree.  Its filename was
     revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Revert 81b0c8713385ce1b1b9058e916edcf9561ad76d6
From: Andrew Morton <akpm@osdl.org>

This was a bugfix against 6527c2bdf1f833cc18e8f42bd97973d583e4aa83, which we
also revert.

Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    9 +--------
 mm/filemap.h |    4 ++--
 2 files changed, 3 insertions(+), 10 deletions(-)

diff -puN mm/filemap.c~revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6 mm/filemap.c
--- a/mm/filemap.c~revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6
+++ a/mm/filemap.c
@@ -1895,12 +1895,6 @@ generic_file_buffered_write(struct kiocb
 			break;
 		}
 
-		if (unlikely(bytes == 0)) {
-			status = 0;
-			copied = 0;
-			goto zero_length_segment;
-		}
-
 		status = a_ops->prepare_write(file, page, offset, offset+bytes);
 		if (unlikely(status)) {
 			loff_t isize = i_size_read(inode);
@@ -1930,8 +1924,7 @@ generic_file_buffered_write(struct kiocb
 			page_cache_release(page);
 			continue;
 		}
-zero_length_segment:
-		if (likely(copied >= 0)) {
+		if (likely(copied > 0)) {
 			if (!status)
 				status = copied;
 
diff -puN mm/filemap.h~revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6 mm/filemap.h
--- a/mm/filemap.h~revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6
+++ a/mm/filemap.h
@@ -87,7 +87,7 @@ filemap_set_next_iovec(const struct iove
 	const struct iovec *iov = *iovp;
 	size_t base = *basep;
 
-	do {
+	while (bytes) {
 		int copy = min(bytes, iov->iov_len - base);
 
 		bytes -= copy;
@@ -96,7 +96,7 @@ filemap_set_next_iovec(const struct iove
 			iov++;
 			base = 0;
 		}
-	} while (bytes);
+	}
 	*iovp = iov;
 	*basep = base;
 }
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-ipwireless_cs.patch
deprecate-smbfs-in-favour-of-cifs.patch
sync_sb_inodes-propagate-errors.patch
ext2-reservations.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
