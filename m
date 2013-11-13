From: akpm@linux-foundation.org
Subject: [merged]
 mm-nobootmemc-have-__free_pages_memory-free-in-larger-chunks.patch removed
 from -mm tree
Date: Wed, 13 Nov 2013 12:38:07 -0800
Message-ID: <5283e32f.lZ0V8iOpFYhBbhP9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3KMUiI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, travis@sgi.com, robinmholt@linux.com, nzimmer@sgi.com, mingo@kernel.org, mgorman@suse.de, liwanp@linux.vnet.ibm.com, hpa@zytor.com, hannes@cmpxchg.org, robin.m.holt@gmail.com

Subject: [merged] mm-nobootmemc-have-__free_pages_memory-free-in-larger-chunks.patch removed from -mm tree
To: robin.m.holt@gmail.com,hannes@cmpxchg.org,hpa@zytor.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mingo@kernel.org,nzimmer@sgi.com,robinmholt@linux.com,travis@sgi.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:07 -0800


The patch titled
     Subject: mm/nobootmem.c: have __free_pages_memory() free in larger chunks.
has been removed from the -mm tree.  Its filename was
     mm-nobootmemc-have-__free_pages_memory-free-in-larger-chunks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Robin Holt <robin.m.holt@gmail.com>
Subject: mm/nobootmem.c: have __free_pages_memory() free in larger chunks.

On large memory machines it can take a few minutes to get through
free_all_bootmem().

Currently, when free_all_bootmem() calls __free_pages_memory(), the number
of contiguous pages that __free_pages_memory() passes to the buddy
allocator is limited to BITS_PER_LONG.  BITS_PER_LONG was originally
chosen to keep things similar to mm/nobootmem.c.  But it is more efficient
to limit it to MAX_ORDER.

       base   new  change
8TB    202s  172s   30s
16TB   401s  351s   50s

That is around 1%-3% improvement on total boot time.

This patch was spun off from the boot time rfc Robin and I had been
working on.

Signed-off-by: Robin Holt <robin.m.holt@gmail.com>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Cc: Robin Holt <robinmholt@linux.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nobootmem.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff -puN mm/nobootmem.c~mm-nobootmemc-have-__free_pages_memory-free-in-larger-chunks mm/nobootmem.c
--- a/mm/nobootmem.c~mm-nobootmemc-have-__free_pages_memory-free-in-larger-chunks
+++ a/mm/nobootmem.c
@@ -82,27 +82,18 @@ void __init free_bootmem_late(unsigned l
 
 static void __init __free_pages_memory(unsigned long start, unsigned long end)
 {
-	unsigned long i, start_aligned, end_aligned;
-	int order = ilog2(BITS_PER_LONG);
+	int order;
 
-	start_aligned = (start + (BITS_PER_LONG - 1)) & ~(BITS_PER_LONG - 1);
-	end_aligned = end & ~(BITS_PER_LONG - 1);
+	while (start < end) {
+		order = min(MAX_ORDER - 1UL, __ffs(start));
 
-	if (end_aligned <= start_aligned) {
-		for (i = start; i < end; i++)
-			__free_pages_bootmem(pfn_to_page(i), 0);
+		while (start + (1UL << order) > end)
+			order--;
 
-		return;
-	}
-
-	for (i = start; i < start_aligned; i++)
-		__free_pages_bootmem(pfn_to_page(i), 0);
+		__free_pages_bootmem(pfn_to_page(start), order);
 
-	for (i = start_aligned; i < end_aligned; i += BITS_PER_LONG)
-		__free_pages_bootmem(pfn_to_page(i), order);
