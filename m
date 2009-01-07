From: akpm@linux-foundation.org
Subject: - mm-direct-io-starvation-improvement.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:33 -0800
Message-ID: <200901072214.n07MEXjU014480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760731AbZAGWOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: direct IO starvation improvement
has been removed from the -mm tree.  Its filename was
     mm-direct-io-starvation-improvement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN mm/filemap.c~mm-direct-io-starvation-improvement mm/filemap.c
--- a/mm/filemap.c~mm-direct-io-starvation-improvement
+++ a/mm/filemap.c
@@ -1317,7 +1317,8 @@ generic_file_aio_read(struct kiocb *iocb
 			goto out; /* skip atime */
 		size = i_size_read(inode);
 		if (pos < size) {
-			retval = filemap_write_and_wait(mapping);
+			retval = filemap_write_and_wait_range(mapping, pos,
+					pos + iov_length(iov, nr_segs) - 1);
 			if (!retval) {
 				retval = mapping->a_ops->direct_IO(READ, iocb,
 							iov, pos, nr_segs);
@@ -2059,18 +2060,10 @@ generic_file_direct_write(struct kiocb *
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
 
@@ -2290,7 +2283,8 @@ generic_file_buffered_write(struct kiocb
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

origin.patch
linux-next.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

