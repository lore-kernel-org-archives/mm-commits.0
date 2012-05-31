From: akpm@linux-foundation.org
Subject: [merged] tmpfs-optimize-clearing-when-writing.patch removed from -mm tree
Date: Thu, 31 May 2012 12:15:34 -0700
Message-ID: <20120531191534.8EAF8A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:60314 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752Ab2EaTPf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:15:35 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so136095qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:15:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hch@infradead.org, npiggin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: optimize clearing when writing
has been removed from the -mm tree.  Its filename was
     tmpfs-optimize-clearing-when-writing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: tmpfs: optimize clearing when writing

Nick proposed years ago that tmpfs should avoid clearing its pages where
write will overwrite them with new data, as ramfs has long done.  But I
messed it up and just got bad data.  Tried again recently, it works fine.

Here's time output for writing 4GiB 16 times on this Core i5 laptop:

before: real	0m21.169s user	0m0.028s sys	0m21.057s
        real	0m21.382s user	0m0.016s sys	0m21.289s
        real	0m21.311s user	0m0.020s sys	0m21.217s

after:  real	0m18.273s user	0m0.032s sys	0m18.165s
        real	0m18.354s user	0m0.020s sys	0m18.265s
        real	0m18.440s user	0m0.032s sys	0m18.337s

ramfs:  real	0m16.860s user	0m0.028s sys	0m16.765s
        real	0m17.382s user	0m0.040s sys	0m17.273s
        real	0m17.133s user	0m0.044s sys	0m17.021s

Yes, I have done perf reports, but they need more explanation than they
deserve: in summary, clear_page vanishes, its cache loading shifts into
copy_user_generic_unrolled; shmem_getpage_gfp goes down, and surprisingly
mark_page_accessed goes way up - I think because they are respectively
where the cache gets to be reloaded after being purged by clear or copy.

Suggested-by: Nick Piggin <npiggin@gmail.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff -puN mm/shmem.c~tmpfs-optimize-clearing-when-writing mm/shmem.c
--- a/mm/shmem.c~tmpfs-optimize-clearing-when-writing
+++ a/mm/shmem.c
@@ -1095,9 +1095,14 @@ repeat:
 		shmem_recalc_inode(inode);
 		spin_unlock(&info->lock);
 
-		clear_highpage(page);
-		flush_dcache_page(page);
-		SetPageUptodate(page);
+		/*
+		 * Let SGP_WRITE caller clear ends if write does not fill page
+		 */
+		if (sgp != SGP_WRITE) {
+			clear_highpage(page);
+			flush_dcache_page(page);
+			SetPageUptodate(page);
+		}
 		if (sgp == SGP_DIRTY)
 			set_page_dirty(page);
 	}
@@ -1307,6 +1312,14 @@ shmem_write_end(struct file *file, struc
 	if (pos + copied > inode->i_size)
 		i_size_write(inode, pos + copied);
 
+	if (!PageUptodate(page)) {
+		if (copied < PAGE_CACHE_SIZE) {
+			unsigned from = pos & (PAGE_CACHE_SIZE - 1);
+			zero_user_segments(page, 0, from,
+					from + copied, PAGE_CACHE_SIZE);
+		}
+		SetPageUptodate(page);
+	}
 	set_page_dirty(page);
 	unlock_page(page);
 	page_cache_release(page);
@@ -1768,6 +1781,7 @@ static int shmem_symlink(struct inode *d
 		kaddr = kmap_atomic(page);
 		memcpy(kaddr, symname, len);
 		kunmap_atomic(kaddr);
+		SetPageUptodate(page);
 		set_page_dirty(page);
 		unlock_page(page);
 		page_cache_release(page);
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
prio_tree-debugging-patch.patch

