From: akpm@linux-foundation.org
Subject: + readahead-fix-pipeline-break-caused-by-block-plug.patch added to -mm tree
Date: Tue, 31 Jan 2012 12:21:57 -0800
Message-ID: <20120131202157.B631DA00B3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:48664 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2AaUWA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2012 15:22:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, axboe@kernel.dk, eric.dumazet@gmail.com, fengguang.wu@intel.com, hch@infradead.org, herbert@13thfloor.at, stable@vger.kernel.org


The patch titled
     Subject: readahead: fix pipeline break caused by block plug
has been added to the -mm tree.  Its filename is
     readahead-fix-pipeline-break-caused-by-block-plug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shaohua Li <shaohua.li@intel.com>
Subject: readahead: fix pipeline break caused by block plug

Herbert Poetzl reported a performance regression since 2.6.39.  The test
is a simple dd read, but with big block size.  The reason is:

T1: ra (A, A+128k), (A+128k, A+256k)
T2: lock_page for page A, submit the 256k
T3: hit page A+128K, ra (A+256k, A+384). the range isn't submitted
because of plug and there isn't any lock_page till we hit page A+256k
because all pages from A to A+256k is in memory
T4: hit page A+256k, ra (A+384, A+ 512). Because of plug, the range isn't
submitted again.
T5: lock_page A+256k, so (A+256k, A+512k) will be submitted. The task is
waitting for (A+256k, A+512k) finish.

There is no request to disk in T3 and T4, so readahead pipeline breaks.

We really don't need block plug for generic_file_aio_read() for buffered
I/O.  The readahead already has plug and has fine grained control when I/O
should be submitted.  Deleting plug for buffered I/O fixes the regression.

One side effect is plug makes the request size 256k, the size is 128k
without it.  This is because default ra size is 128k and not a reason we
need plug here.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Reported-by: Herbert Poetzl <herbert@13thfloor.at>
Tested-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/filemap.c~readahead-fix-pipeline-break-caused-by-block-plug mm/filemap.c
--- a/mm/filemap.c~readahead-fix-pipeline-break-caused-by-block-plug
+++ a/mm/filemap.c
@@ -1400,15 +1400,12 @@ generic_file_aio_read(struct kiocb *iocb
 	unsigned long seg = 0;
 	size_t count;
 	loff_t *ppos = &iocb->ki_pos;
-	struct blk_plug plug;
 
 	count = 0;
 	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
 	if (retval)
 		return retval;
 
-	blk_start_plug(&plug);
-
 	/* coalesce the iovecs and go direct-to-BIO for O_DIRECT */
 	if (filp->f_flags & O_DIRECT) {
 		loff_t size;
@@ -1424,8 +1421,12 @@ generic_file_aio_read(struct kiocb *iocb
 			retval = filemap_write_and_wait_range(mapping, pos,
 					pos + iov_length(iov, nr_segs) - 1);
 			if (!retval) {
+				struct blk_plug plug;
+
+				blk_start_plug(&plug);
 				retval = mapping->a_ops->direct_IO(READ, iocb,
 							iov, pos, nr_segs);
+				blk_finish_plug(&plug);
 			}
 			if (retval > 0) {
 				*ppos = pos + retval;
@@ -1481,7 +1482,6 @@ generic_file_aio_read(struct kiocb *iocb
 			break;
 	}
 out:
-	blk_finish_plug(&plug);
 	return retval;
 }
 EXPORT_SYMBOL(generic_file_aio_read);
_
Subject: Subject: readahead: fix pipeline break caused by block plug

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
readahead-fix-pipeline-break-caused-by-block-plug.patch

