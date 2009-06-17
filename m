From: akpm@linux-foundation.org
Subject: [merged] readahead-introduce-context-readahead-algorithm.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:33:06 -0700
Message-ID: <200906171833.n5HIX7ju031629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758410AbZFQSdx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:33:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, jens.axboe@oracle.com, jmoyer@redhat.com, vst@vlnb.net, mm-commits@vger.kernel.org


The patch titled
     readahead: introduce context readahead algorithm
has been removed from the -mm tree.  Its filename was
     readahead-introduce-context-readahead-algorithm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: readahead: introduce context readahead algorithm
From: Wu Fengguang <fengguang.wu@intel.com>

Introduce page cache context based readahead algorithm.
This is to better support concurrent read streams in general.

RATIONALE
---------
The current readahead algorithm detects interleaved reads in a _passive_ way.
Given a sequence of interleaved streams 1,1001,2,1002,3,4,1003,5,1004,1005,6,...
By checking for (offset == prev_offset + 1), it will discover the sequentialness
between 3,4 and between 1004,1005, and start doing sequential readahead for the
individual streams since page 4 and page 1005.

The context readahead algorithm guarantees to discover the sequentialness no
matter how the streams are interleaved. For the above example, it will start
sequential readahead since page 2 and 1002.

The trick is to poke for page @offset-1 in the page cache when it has no other
clues on the sequentialness of request @offset: if the current requenst belongs
to a sequential stream, that stream must have accessed page @offset-1 recently,
and the page will still be cached now. So if page @offset-1 is there, we can
take request @offset as a sequential access.

BENEFICIARIES
-------------
- strictly interleaved reads  i.e. 1,1001,2,1002,3,1003,...
  the current readahead will take them as silly random reads;
  the context readahead will take them as two sequential streams.

- cooperative IO processes   i.e. NFS and SCST
  They create a thread pool, farming off (sequential) IO requests to different
  threads which will be performing interleaved IO.

  It was not easy(or possible) to reliably tell from file->f_ra all those
  cooperative processes working on the same sequential stream, since they will
  have different file->f_ra instances. And NFSD's file->f_ra is particularly
  unusable, since their file objects are dynamically created for each request.
  The nfsd does have code trying to restore the f_ra bits, but not satisfactory.

  The new scheme is to detect the sequential pattern via looking up the page
  cache, which provides one single and consistent view of the pages recently
  accessed. That makes sequential detection for cooperative processes possible.

USER REPORT
-----------
Vladislav recommends the addition of context readahead as a result of his SCST
benchmarks. It leads to 6%~40% performance gains in various cases and achieves
equal performance in others.                http://lkml.org/lkml/2009/3/19/239

OVERHEADS
---------
In theory, it introduces one extra page cache lookup per random read.  However
the below benchmark shows context readahead to be slightly faster, wondering..

Randomly reading 200MB amount of data on a sparse file, repeat 20 times for
each block size. The average throughputs are:

                       	original ra	context ra	gain
 4K random reads:	 65.561MB/s	 65.648MB/s	+0.1%
16K random reads:	124.767MB/s	124.951MB/s	+0.1%
64K random reads: 	162.123MB/s	162.278MB/s	+0.1%

Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Tested-by: Vladislav Bolkhovitin <vst@vlnb.net>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff -puN mm/readahead.c~readahead-introduce-context-readahead-algorithm mm/readahead.c
--- a/mm/readahead.c~readahead-introduce-context-readahead-algorithm
+++ a/mm/readahead.c
@@ -330,6 +330,59 @@ static unsigned long get_next_ra_size(st
  */
 
 /*
+ * Count contiguously cached pages from @offset-1 to @offset-@max,
+ * this count is a conservative estimation of
+ * 	- length of the sequential read sequence, or
+ * 	- thrashing threshold in memory tight systems
+ */
+static pgoff_t count_history_pages(struct address_space *mapping,
+				   struct file_ra_state *ra,
+				   pgoff_t offset, unsigned long max)
+{
+	pgoff_t head;
+
+	rcu_read_lock();
+	head = radix_tree_prev_hole(&mapping->page_tree, offset - 1, max);
+	rcu_read_unlock();
+
+	return offset - 1 - head;
+}
+
+/*
+ * page cache context based read-ahead
+ */
+static int try_context_readahead(struct address_space *mapping,
+				 struct file_ra_state *ra,
+				 pgoff_t offset,
+				 unsigned long req_size,
+				 unsigned long max)
+{
+	pgoff_t size;
+
+	size = count_history_pages(mapping, ra, offset, max);
+
+	/*
+	 * no history pages:
+	 * it could be a random read
+	 */
+	if (!size)
+		return 0;
+
+	/*
+	 * starts from beginning of file:
+	 * it is a strong indication of long-run stream (or whole-file-read)
+	 */
+	if (size >= offset)
+		size *= 2;
+
+	ra->start = offset;
+	ra->size = get_init_ra_size(size + req_size, max);
+	ra->async_size = ra->size;
+
+	return 1;
+}
+
+/*
  * A minimal readahead algorithm for trivial sequential/random reads.
  */
 static unsigned long
@@ -395,6 +448,13 @@ ondemand_readahead(struct address_space 
 		goto initial_readahead;
 
 	/*
+	 * Query the page cache and look for the traces(cached history pages)
+	 * that a sequential stream would leave behind.
+	 */
+	if (try_context_readahead(mapping, ra, offset, req_size, max))
+		goto readit;
+
+	/*
 	 * standalone, small random read
 	 * Read as is, and do not pollute the readahead state.
 	 */
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch

