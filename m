From: akpm@linux-foundation.org
Subject: [merged] swap-allow-swap-readahead-to-be-merged.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:11:46 -0700
Message-ID: <20120801201147.3F7355C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:61666 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab2HAULu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:11:50 -0400
Received: by fat25 with SMTP id 25so341891fat.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:11:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ehrhardt@linux.vnet.ibm.com, axboe@kernel.dk, hughd@google.com, minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: swap: allow swap readahead to be merged
has been removed from the -mm tree.  Its filename was
     swap-allow-swap-readahead-to-be-merged.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

I got ~10% to ~40% more throughput in my cases and at the same time much
lower cpu consumption when broken down per transferred kilobyte (the
majority of that due to saved interrupts and better cache handling).  In a
shared SAN others might get an additional benefit as well, because this
now causes less protocol overhead.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
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

Patches currently in -mm which might be from ehrhardt@linux.vnet.ibm.com are

origin.patch

