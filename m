From: akpm@linux-foundation.org
Subject: +
 mm-memblockc-check-return-value-of-memblock_reserve-in-memblock_virt_alloc_internal.patch added to -mm tree
Date: Mon, 09 Jan 2017 15:01:47 -0800
Message-ID: <5874165b.sZKqIX+7n4Fgz8Pq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44610 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754352AbdAIXAU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2017 18:00:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.weiyang@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: check return value of memblock_reserve() in memblock_virt_alloc_internal()
has been added to the -mm tree.  Its filename is
     mm-memblockc-check-return-value-of-memblock_reserve-in-memblock_virt_alloc_internal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblockc-check-return-value-of-memblock_reserve-in-memblock_virt_alloc_internal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblockc-check-return-value-of-memblock_reserve-in-memblock_virt_alloc_internal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memblock.c: check return value of memblock_reserve() in memblock_virt_alloc_internal()

memblock_reserve() would add a new range to memblock.reserved in case the
new range is not totally covered by any of the current memblock.reserved
range.  If the memblock.reserved is full and can't resize,
memblock_reserve() would fail.

This doesn't happen in real world now, I observed this during code review.
While theoretically, it has the chance to happen.  And if it happens,
others would think this range of memory is still available and may corrupt
the memory.

This patch checks the return value and goto "done" after it succeeds.

Link: http://lkml.kernel.org/r/1482363033-24754-3-git-send-email-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/memblock.c~mm-memblockc-check-return-value-of-memblock_reserve-in-memblock_virt_alloc_internal mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-check-return-value-of-memblock_reserve-in-memblock_virt_alloc_internal
+++ a/mm/memblock.c
@@ -1299,18 +1299,17 @@ static void * __init memblock_virt_alloc
 
 	if (max_addr > memblock.current_limit)
 		max_addr = memblock.current_limit;
-
 again:
 	alloc = memblock_find_in_range_node(size, align, min_addr, max_addr,
 					    nid, flags);
-	if (alloc)
+	if (alloc && !memblock_reserve(alloc, size))
 		goto done;
 
 	if (nid != NUMA_NO_NODE) {
 		alloc = memblock_find_in_range_node(size, align, min_addr,
 						    max_addr, NUMA_NO_NODE,
 						    flags);
-		if (alloc)
+		if (alloc && !memblock_reserve(alloc, size))
 			goto done;
 	}
 
@@ -1328,7 +1327,6 @@ again:
 
 	return NULL;
 done:
-	memblock_reserve(alloc, size);
 	ptr = phys_to_virt(alloc);
 	memset(ptr, 0, size);
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memblockc-trivial-code-refine-in-memblock_is_region_memory.patch
mm-memblockc-check-return-value-of-memblock_reserve-in-memblock_virt_alloc_internal.patch

