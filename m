From: akpm@linux-foundation.org
Subject: + dio-invalidate-clean-pages-before-dio-write.patch added to -mm tree
Date: Sun, 11 Mar 2007 00:29:13 -0800
Message-ID: <200703110829.l2B8TDu7007837@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39857 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbXCKI3Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 04:29:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach.brown@oracle.com, bcrl@kvack.org, leonid.i.ananiev@linux.intel.com, nickpiggin@yahoo.com.au


The patch titled
     dio: invalidate clean pages before dio write
has been added to the -mm tree.  Its filename is
     dio-invalidate-clean-pages-before-dio-write.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dio: invalidate clean pages before dio write
From: Zach Brown <zach.brown@oracle.com>

This patch fixes a user-triggerable oops that was reported by Leonid
Ananiev as archived at http://lkml.org/lkml/2007/2/8/337.

dio writes invalidate clean pages that intersect the written region so that
subsequent buffered reads go to disk to read the new data.  If this fails
the interface tries to tell the caller that the cache is inconsistent by
returning EIO.

Before this patch we had the problem where this invalidation failure would
clobber -EIOCBQUEUED as it made its way from fs/direct-io.c to fs/aio.c. 
Both fs/aio.c and bio completion call aio_complete() and we reference freed
memory, usually oopsing.

This patch addresses this problem by invalidating before the write so that
we can cleanly return -EIO before ->direct_IO() has had a chance to return
-EIOCBQUEUED.

There is a compromise here.  During the dio write we can fault in mmap()ed
pages which intersect the written range with get_user_pages() if the user
provided them for the source buffer.  This is a crazy thing to do, but we
can make it mostly work in most cases by trying the invalidation again. 
The compromise is that we won't return an error if this second invalidation
fails if it's an AIO write and we have -EIOCBQUEUED.

This was tested by having two processes race performing large O_DIRECT and
buffered ordered writes.  Within minutes ext3 would see a race between
ext3_releasepage() and jbd holding a reference on ordered data buffers and
would cause invalidation to fail, panicing the box.  The test can be found
in the 'aio_dio_bugs' test group in test.kernel.org/autotest.  After this
patch the test passes.

Signed-off-by: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Cc: Leonid Ananiev <leonid.i.ananiev@linux.intel.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   46 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff -puN mm/filemap.c~dio-invalidate-clean-pages-before-dio-write mm/filemap.c
--- a/mm/filemap.c~dio-invalidate-clean-pages-before-dio-write
+++ a/mm/filemap.c
@@ -2196,7 +2196,8 @@ generic_file_direct_IO(int rw, struct ki
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	ssize_t retval;
-	size_t write_len = 0;
+	size_t write_len;
+	pgoff_t end = 0; /* silence gcc */
 
 	/*
 	 * If it's a write, unmap all mmappings of the file up-front.  This
@@ -2205,23 +2206,46 @@ generic_file_direct_IO(int rw, struct ki
 	 */
 	if (rw == WRITE) {
 		write_len = iov_length(iov, nr_segs);
+		end = (offset + write_len - 1) >> PAGE_CACHE_SHIFT;
 	       	if (mapping_mapped(mapping))
 			unmap_mapping_range(mapping, offset, write_len, 0);
 	}
 
 	retval = filemap_write_and_wait(mapping);
-	if (retval == 0) {
-		retval = mapping->a_ops->direct_IO(rw, iocb, iov,
-						offset, nr_segs);
-		if (rw == WRITE && mapping->nrpages) {
-			pgoff_t end = (offset + write_len - 1)
-						>> PAGE_CACHE_SHIFT;
-			int err = invalidate_inode_pages2_range(mapping,
+	if (retval)
+		goto out;
+
+	/*
+	 * After a write we want buffered reads to be sure to go to disk to get
+	 * the new data.  We invalidate clean cached page from the region we're
+	 * about to write.  We do this *before* the write so that we can return
+	 * -EIO without clobbering -EIOCBQUEUED from ->direct_IO().
+	 */
+	if (rw == WRITE && mapping->nrpages) {
+		retval = invalidate_inode_pages2_range(mapping,
 					offset >> PAGE_CACHE_SHIFT, end);
-			if (err)
-				retval = err;
-		}
+		if (retval)
+			goto out;
+	}
+
+	retval = mapping->a_ops->direct_IO(rw, iocb, iov, offset, nr_segs);
+	if (retval)
+		goto out;
+
+	/*
+	 * Finally, try again to invalidate clean pages which might have been
+	 * faulted in by get_user_pages() if the source of the write was an
+	 * mmap()ed region of the file we're writing.  That's a pretty crazy
+	 * thing to do, so we don't support it 100%.  If this invalidation
+	 * fails and we have -EIOCBQUEUED we ignore the failure.
+	 */
+	if (rw == WRITE && mapping->nrpages) {
+		int err = invalidate_inode_pages2_range(mapping,
+					      offset >> PAGE_CACHE_SHIFT, end);
+		if (err && retval >= 0)
+			retval = err;
 	}
+out:
 	return retval;
 }
 
_

Patches currently in -mm which might be from zach.brown@oracle.com are

dio-invalidate-clean-pages-before-dio-write.patch
aio-use-flush_work.patch
aio-is-unlikely.patch
