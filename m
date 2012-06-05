From: akpm@linux-foundation.org
Subject: + swap-allow-swap-readahead-to-be-merged.patch added to -mm tree
Date: Tue, 05 Jun 2012 16:46:17 -0700
Message-ID: <20120605234618.57ED5A018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:44735 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2FEXqV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2012 19:46:21 -0400
Received: by fat25 with SMTP id 25so111665fat.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Jun 2012 16:46:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ehrhardt@linux.vnet.ibm.com, axboe@kernel.dk, minchan@kernel.org, riel@redhat.com


The patch titled
     Subject: swap: allow swap readahead to be merged
has been added to the -mm tree.  Its filename is
     swap-allow-swap-readahead-to-be-merged.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Subject: swap: allow swap readahead to be merged

Swap readahead works fine, but the I/O to disk is almost always done in
page size requests, despite the fact that readahead submits
1<<page-cluster pages at a time.

On older kernels the old per device plugging behavior might have captured
this and merged the requests, but currently all comes down to much more
I/Os than required.

On a single device this might not be an issue, but as soon as a server
runs on shared san resources savin I/Os not only improves swapin
throughput but also provides a lower resource utilization.

With a load running KVM in a lot of memory overcommitment (the hot memory
is 1.5 times the host memory) swapping throughput improves significantly
and the lead feels more responsive as well as achieves more throughput.

In a test setup with 16 swap disks running blocktrace on one of those disks
shows the improved merging:
Prior:
Reads Queued:     560,888,    2,243MiB  Writes Queued:     226,242,  904,968KiB
Read Dispatches:  544,701,    2,243MiB  Write Dispatches:  159,318,  904,968KiB
Reads Requeued:         0               Writes Requeued:         0
Reads Completed:  544,716,    2,243MiB  Writes Completed:  159,321,  904,980KiB
Read Merges:       16,187,   64,748KiB  Write Merges:       61,744,  246,976KiB
IO unplugs:       149,614               Timer unplugs:       2,940

With the patch:
Reads Queued:     734,315,    2,937MiB  Writes Queued:     300,188,    1,200MiB
Read Dispatches:  214,972,    2,937MiB  Write Dispatches:  215,176,    1,200MiB
Reads Requeued:         0               Writes Requeued:         0
Reads Completed:  214,971,    2,937MiB  Writes Completed:  215,177,    1,200MiB
Read Merges:      519,343,    2,077MiB  Write Merges:       73,325,  293,300KiB
IO unplugs:       337,130               Timer unplugs:      11,184

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/swap_state.c~swap-allow-swap-readahead-to-be-merged mm/swap_state.c
--- a/mm/swap_state.c~swap-allow-swap-readahead-to-be-merged
+++ a/mm/swap_state.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/pagemap.h>
 #include <linux/backing-dev.h>
+#include <linux/blkdev.h>
 #include <linux/pagevec.h>
 #include <linux/migrate.h>
 #include <linux/page_cgroup.h>
@@ -376,6 +377,7 @@ struct page *swapin_readahead(swp_entry_
 	unsigned long offset = swp_offset(entry);
 	unsigned long start_offset, end_offset;
 	unsigned long mask = (1UL << page_cluster) - 1;
+	struct blk_plug plug;
 
 	/* Read a page_cluster sized and aligned cluster around offset. */
 	start_offset = offset & ~mask;
@@ -383,6 +385,7 @@ struct page *swapin_readahead(swp_entry_
 	if (!start_offset)	/* First page is swap header. */
 		start_offset++;
 
+	blk_start_plug(&plug);
 	for (offset = start_offset; offset <= end_offset ; offset++) {
 		/* Ok, do the async read-ahead now */
 		page = read_swap_cache_async(swp_entry(swp_type(entry), offset),
@@ -391,6 +394,8 @@ struct page *swapin_readahead(swp_entry_
 			continue;
 		page_cache_release(page);
 	}
+	blk_finish_plug(&plug);
+
 	lru_add_drain();	/* Push any new pages onto the LRU now */
 	return read_swap_cache_async(entry, gfp_mask, vma, addr);
 }
_
Subject: Subject: swap: allow swap readahead to be merged

Patches currently in -mm which might be from ehrhardt@linux.vnet.ibm.com are

swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch

