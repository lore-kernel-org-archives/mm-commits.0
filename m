From: akpm@linux-foundation.org
Subject: +
 mm-nobootmemc-have-__free_pages_memory-free-in-larger-chunks.patch added to -mm tree
Date: Thu, 19 Sep 2013 16:39:42 -0700
Message-ID: <523b8b3e.tzQw+0BvDS8oEy9t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3ISXjn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 19:39:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, travis@sgi.com, robinmholt@linux.com, nzimmer@sgi.com, mingo@kernel.org, mgorman@suse.de, hpa@zytor.com, hannes@cmpxchg.org, robin.m.holt@gmail.com

Subject: + mm-nobootmemc-have-__free_pages_memory-free-in-larger-chunks.patch added to -mm tree
To: robin.m.holt@gmail.com,hannes@cmpxchg.org,hpa@zytor.com,mgorman@suse.de,mingo@kernel.org,nzimmer@sgi.com,robinmholt@linux.com,travis@sgi.com,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 16:39:42 -0700


The patch titled
     Subject: mm/nobootmem.c: have __free_pages_memory() free in larger chunks.
has been added to the -mm tree.  Its filename is
     mm-nobootmemc-have-__free_pages_memory-free-in-larger-chunks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-nobootmemc-have-__free_pages_memory-free-in-larger-chunks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-nobootmemc-have-__free_pages_memory-free-in-larger-chunks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
