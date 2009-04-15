From: akpm@linux-foundation.org
Subject: + readahead-introduce-context-readahead-algorithm-update.patch added to -mm tree
Date: Tue, 14 Apr 2009 17:16:00 -0700
Message-ID: <200904150016.n3F0G0Qa015337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751912AbZDOATt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 20:19:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, jens.axboe@oracle.com, jmoyer@redhat.com, vst@vlnb.net


The patch titled
     readahead: introduce context readahead algorithm
has been added to the -mm tree.  Its filename is
     readahead-introduce-context-readahead-algorithm-update.patch

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

 mm/readahead.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/readahead.c~readahead-introduce-context-readahead-algorithm-update mm/readahead.c
--- a/mm/readahead.c~readahead-introduce-context-readahead-algorithm-update
+++ a/mm/readahead.c
@@ -330,14 +330,14 @@ static unsigned long get_next_ra_size(st
  */
 
 /*
- * Count continuously cached pages from @offset-1 to @offset-@max,
+ * Count contiguously cached pages from @offset-1 to @offset-@max,
  * this count is a conservative estimation of
  * 	- length of the sequential read sequence, or
  * 	- thrashing threshold in memory tight systems
  */
-static unsigned long count_history_pages(struct address_space *mapping,
-					 struct file_ra_state *ra,
-					 pgoff_t offset, unsigned long max)
+static pgoff_t count_history_pages(struct address_space *mapping,
+				   struct file_ra_state *ra,
+				   pgoff_t offset, unsigned long max)
 {
 	pgoff_t head;
 
@@ -357,7 +357,7 @@ static int try_context_readahead(struct 
 				 unsigned long req_size,
 				 unsigned long max)
 {
-	unsigned long size;
+	pgoff_t size;
 
 	size = count_history_pages(mapping, ra, offset, max);
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
readahead-make-mmap_miss-an-unsigned-int.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-one-unnecessary-radix-tree-lookup.patch
readahead-increase-interleaved-readahead-size.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
radix-tree-add-radix_tree_prev_hole.patch
readahead-move-the-random-read-case-to-bottom.patch
readahead-introduce-context-readahead-algorithm.patch
readahead-introduce-context-readahead-algorithm-update.patch
readahead-introduce-context-readahead-algorithm-fix.patch

