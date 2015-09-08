From: akpm@linux-foundation.org
Subject: [merged]
 mm-slub-dont-wait-for-high-order-page-allocation-v2.patch removed from -mm
 tree
Date: Tue, 08 Sep 2015 11:03:45 -0700
Message-ID: <55ef2301.XeEBjoXalST0BXtU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbbIHSDq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:03:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, cl@linux.com, edumazet@google.com, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, shli@fb.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: don't wait for high-order page allocation
has been removed from the -mm tree.  Its filename was
     mm-slub-dont-wait-for-high-order-page-allocation-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/slub: don't wait for high-order page allocation

Description is almost copied from commit fb05e7a89f50 ("net: don't wait
for order-3 page allocation").

I saw excessive direct memory reclaim/compaction triggered by slub.  This
causes performance issues and add latency.  Slub uses high-order
allocation to reduce internal fragmentation and management overhead.  But,
direct memory reclaim/compaction has high overhead and the benefit of
high-order allocation can't compensate the overhead of both work.

This patch makes auxiliary high-order allocation atomic.  If there is no
memory pressure and memory isn't fragmented, the alloction will still
success, so we don't sacrifice high-order allocation's benefit here.  If
the atomic allocation fails, direct memory reclaim/compaction will not be
triggered, allocation fallback to low-order immediately, hence the direct
memory reclaim/compaction overhead is avoided.  In the allocation failure
case, kswapd is waken up and trying to make high-order freepages, so
allocation could success next time.

Following is the test to measure effect of this patch.

System: QEMU, CPU 8, 512 MB
Mem: 25% memory is allocated at random position to make fragmentation.
 Memory-hogger occupies 150 MB memory.
Workload: hackbench -g 20 -l 1000

Average result by 10 runs (Base va Patched)

elapsed_time(s): 4.3468 vs 2.9838
compact_stall: 461.7 vs 73.6
pgmigrate_success: 28315.9 vs 7256.1

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/slub.c~mm-slub-dont-wait-for-high-order-page-allocation-v2 mm/slub.c
--- a/mm/slub.c~mm-slub-dont-wait-for-high-order-page-allocation-v2
+++ a/mm/slub.c
@@ -1362,6 +1362,8 @@ static struct page *allocate_slab(struct
 	 * so we fall-back to the minimum order allocation.
 	 */
 	alloc_gfp = (flags | __GFP_NOWARN | __GFP_NORETRY) & ~__GFP_NOFAIL;
+	if ((alloc_gfp & __GFP_WAIT) && oo_order(oo) > oo_order(s->min))
+		alloc_gfp = (alloc_gfp | __GFP_NOMEMALLOC) & ~__GFP_WAIT;
 
 	page = alloc_slab_page(s, alloc_gfp, node, oo);
 	if (unlikely(!page)) {
_

Patches currently in -mm which might be from js1304@gmail.com are


