From: akpm@linux-foundation.org
Subject: + mm-direct-io-starvation-improvement.patch added to -mm tree
Date: Thu, 11 Dec 2008 13:00:35 -0800
Message-ID: <200812112100.mBBL0ZL8013593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755216AbYLKVBK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 16:01:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm: direct IO starvation improvement
has been added to the -mm tree.  Its filename is
     mm-direct-io-starvation-improvement.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: direct IO starvation improvement
From: Nick Piggin <npiggin@suse.de>

Direct IO can invalidate and sync a lot of pagecache pages in the mapping.
 A 4K direct IO will actually try to sync and/or invalidate the pagecache
of the entire file, for example (which might be many GB or TB large).

Improve this by doing range syncs.  Also, memory no longer has to be
unmapped to catch the dirty bits for syncing, as dirty bits would remain
coherent due to dirty mmap accounting.

This fixes the immediate DM deadlocks when doing direct IO reads to block
device with a mounted filesystem, if only by papering over the problem
somewhat rather than addressing the fsync starvation cases.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN mm/filemap.c~mm-direct-io-starvation-improvement mm/filemap.c
--- a/mm/filemap.c~mm-direct-io-starvation-improvement
+++ a/mm/filemap.c
@@ -1369,7 +1369,8 @@ generic_file_aio_read(struct kiocb *iocb
 			goto out; /* skip atime */
 		size = i_size_read(inode);
 		if (pos < size) {
-			retval = filemap_write_and_wait(mapping);
+			retval = filemap_write_and_wait_range(mapping, pos,
+					pos + iov_length(iov, nr_segs) - 1);
 			if (!retval) {
 				retval = mapping->a_ops->direct_IO(READ, iocb,
 							iov, pos, nr_segs);
@@ -2137,18 +2138,10 @@ generic_file_direct_write(struct kiocb *
 	if (count != ocount)
 		*nr_segs = iov_shorten((struct iovec *)iov, *nr_segs, count);
 
-	/*
-	 * Unmap all mmappings of the file up-front.
-	 *
-	 * This will cause any pte dirty bits to be propagated into the
-	 * pageframes for the subsequent filemap_write_and_wait().
-	 */
 	write_len = iov_length(iov, *nr_segs);
 	end = (pos + write_len - 1) >> PAGE_CACHE_SHIFT;
-	if (mapping_mapped(mapping))
-		unmap_mapping_range(mapping, pos, write_len, 0);
 
-	written = filemap_write_and_wait(mapping);
+	written = filemap_write_and_wait_range(mapping, pos, pos + write_len - 1);
 	if (written)
 		goto out;
 
@@ -2363,7 +2356,8 @@ generic_file_buffered_write(struct kiocb
 	 * the file data here, to try to honour O_DIRECT expectations.
 	 */
 	if (unlikely(file->f_flags & O_DIRECT) && written)
-		status = filemap_write_and_wait(mapping);
+		status = filemap_write_and_wait_range(mapping,
+					pos, pos + written - 1);
 
 	return written ? written : status;
 }
_

Patches currently in -mm which might be from npiggin@suse.de are

linux-next.patch
mm-dont-mark_page_accessed-in-fault-path.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-cyclic-fix.patch
mm-write_cache_pages-cyclic-fix-fix.patch
mm-write_cache_pages-early-loop-termination.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-write_cache_pages-integrity-fix.patch
mm-write_cache_pages-cleanups.patch
mm-write_cache_pages-optimise-page-cleaning.patch
mm-write_cache_pages-terminate-quickly.patch
mm-write_cache_pages-more-terminate-quickly.patch
mm-do_sync_mapping_range-integrity-fix.patch
mm-get-rid-of-pagevec_release_nonlru.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-vmalloc-tweak-failure-printk.patch
mm-vmalloc-improve-vmallocinfo.patch
mm-vmalloc-use-mutex-for-purge.patch
mm-vmalloc-make-lazy-unmapping-configurable.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
hugetlb-unsigned-ret-cannot-be-negative.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-direct-io-starvation-improvement.patch
fs-remove-wb_sync_hold.patch
fs-sync_sb_inodes-fix.patch
fs-sys_sync-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
mm-fsync-livelock-avoidance.patch
reiser4.patch

