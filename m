From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblockc-check-return-value-of-memblock_reserve-in-memblock_virt_alloc_internal.patch removed from -mm tree
Date: Thu, 23 Feb 2017 13:16:08 -0800
Message-ID: <58af5118.rEJAWeeDaeTGL1+j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40456 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdBWVQN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:16:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.weiyang@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: check return value of memblock_reserve() in memblock_virt_alloc_internal()
has been removed from the -mm tree.  Its filename was
     mm-memblockc-check-return-value-of-memblock_reserve-in-memblock_virt_alloc_internal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch
mm-page_alloc-remove-redundant-init-code-for-zone_movable.patch

