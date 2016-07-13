From: akpm@linux-foundation.org
Subject: + mm-page_alloc-fix-dirtyable-highmem-calculation.patch added to
 -mm tree
Date: Wed, 13 Jul 2016 14:04:39 -0700
Message-ID: <5786ace7.cOPk/Mj6i9vih+ZA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbcGMVEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 17:04:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hannes@cmpxchg.org, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: fix dirtyable highmem calculation
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-dirtyable-highmem-calculation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-dirtyable-highmem-calculation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-dirtyable-highmem-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm, page_alloc: fix dirtyable highmem calculation

When I tested vmscale in mmtest in 32bit, I found the benchmark was slow
down 0.5 times.

                base        node
                   1    global-1
User           12.98       16.04
System        147.61      166.42
Elapsed        26.48       38.08

With vmstat, I found IO wait avg is much increased compared to base.

The reason was highmem_dirtyable_memory accumulates free pages and
highmem_file_pages from HIGHMEM to MOVABLE zones which was wrong. With
that, dirth_thresh in throtlle_vm_write is always 0 so that it calls
congestion_wait frequently if writeback starts.

With this patch, it is much recovered.

                base        node          fi
                   1    global-1         fix
User           12.98       16.04       13.78
System        147.61      166.42      143.92
Elapsed        26.48       38.08       29.64

Link: http://lkml.kernel.org/r/1468404004-5085-4-git-send-email-mgorman@techsingularity.net
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN mm/page-writeback.c~mm-page_alloc-fix-dirtyable-highmem-calculation mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page_alloc-fix-dirtyable-highmem-calculation
+++ a/mm/page-writeback.c
@@ -307,27 +307,31 @@ static unsigned long highmem_dirtyable_m
 {
 #ifdef CONFIG_HIGHMEM
 	int node;
-	unsigned long x = 0;
+	unsigned long x;
 	int i;
-	unsigned long dirtyable = atomic_read(&highmem_file_pages);
+	unsigned long dirtyable = 0;
 
 	for_each_node_state(node, N_HIGH_MEMORY) {
 		for (i = ZONE_NORMAL + 1; i < MAX_NR_ZONES; i++) {
 			struct zone *z;
+			unsigned long nr_pages;
 
 			if (!is_highmem_idx(i))
 				continue;
 
 			z = &NODE_DATA(node)->node_zones[i];
-			dirtyable += zone_page_state(z, NR_FREE_PAGES);
+			if (!populated_zone(z))
+				continue;
 
+			nr_pages = zone_page_state(z, NR_FREE_PAGES);
 			/* watch for underflows */
-			dirtyable -= min(dirtyable, high_wmark_pages(z));
-
-			x += dirtyable;
+			nr_pages -= min(nr_pages, high_wmark_pages(z));
+			dirtyable += nr_pages;
 		}
 	}
 
+	x = dirtyable + atomic_read(&highmem_file_pages);
+
 	/*
 	 * Unreclaimable memory (kernel memory or anonymous memory
 	 * without swap) can bring down the dirtyable pages below
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-use-put_page-to-free-page-instead-of-putback_lru_page.patch
mm-migrate-support-non-lru-movable-page-migration.patch
mm-balloon-use-general-non-lru-movable-page-feature.patch
zsmalloc-keep-max_object-in-size_class.patch
zsmalloc-use-bit_spin_lock.patch
zsmalloc-use-accessor.patch
zsmalloc-factor-page-chain-functionality-out.patch
zsmalloc-introduce-zspage-structure.patch
zsmalloc-separate-free_zspage-from-putback_zspage.patch
zsmalloc-use-freeobj-for-index.patch
zsmalloc-page-migration-support.patch
zsmalloc-page-migration-support-fix.patch
zsmalloc-page-migration-support-fix-2.patch
zram-use-__gfp_movable-for-memory-allocation.patch
zsmalloc-use-obj_tag_bit-for-bit-shifter.patch
mm-add-nr_zsmalloc-to-vmstat.patch
mm-add-nr_zsmalloc-to-vmstat-fix-2.patch
mm-fix-build-warnings-in-linux-compactionh.patch
mm-page_alloc-fix-dirtyable-highmem-calculation.patch

