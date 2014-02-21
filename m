From: akpm@linux-foundation.org
Subject: + mm-exclude-memory-less-nodes-from-zone_reclaim.patch added to
 -mm tree
Date: Fri, 21 Feb 2014 14:07:41 -0800
Message-ID: <5307ce2d.ejBbNFPi9UCyn9Go%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbaBUWHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 17:07:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, nacc@linux.vnet.ibm.com, mel@csn.ul.ie, mhocko@suse.cz

Subject: + mm-exclude-memory-less-nodes-from-zone_reclaim.patch added to -mm tree
To: mhocko@suse.cz,mel@csn.ul.ie,nacc@linux.vnet.ibm.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 14:07:41 -0800


The patch titled
     Subject: mm: exclude memoryless nodes from zone_reclaim
has been added to the -mm tree.  Its filename is
     mm-exclude-memory-less-nodes-from-zone_reclaim.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-exclude-memory-less-nodes-from-zone_reclaim.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-exclude-memory-less-nodes-from-zone_reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: exclude memoryless nodes from zone_reclaim

We had a report about strange OOM killer strikes on a PPC machine although
there was a lot of swap free and a tons of anonymous memory which could be
swapped out.  In the end it turned out that the OOM was a side effect of
zone reclaim which wasn't unmapping and swapping out and so the system was
pushed to the OOM.  Although this sounds like a bug somewhere in the
kswapd vs.  zone reclaim vs.  direct reclaim interaction numactl on the
said hardware suggests that the zone reclaim should not have been set in
the first place:

node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
node 0 size: 0 MB
node 0 free: 0 MB
node 2 cpus:
node 2 size: 7168 MB
node 2 free: 6019 MB
node distances:
node   0   2
0:  10  40
2:  40  10

So all the CPUs are associated with Node0 which doesn't have any memory
while Node2 contains all the available memory.  Node distances cause an
automatic zone_reclaim_mode enabling.

Zone reclaim is intended to keep the allocations local but this doesn't
make any sense on the memoryless nodes.  So let's exclude such nodes for
init_zone_allows_reclaim which evaluates zone reclaim behavior and
suitable reclaim_nodes.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Tested-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-exclude-memory-less-nodes-from-zone_reclaim mm/page_alloc.c
--- a/mm/page_alloc.c~mm-exclude-memory-less-nodes-from-zone_reclaim
+++ a/mm/page_alloc.c
@@ -1855,7 +1855,7 @@ static void __paginginit init_zone_allow
 {
 	int i;
 
-	for_each_online_node(i)
+	for_each_node_state(i, N_MEMORY)
 		if (node_distance(nid, i) <= RECLAIM_DISTANCE)
 			node_set(i, NODE_DATA(nid)->reclaim_nodes);
 		else
@@ -4901,7 +4901,8 @@ void __paginginit free_area_init_node(in
 
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
-	init_zone_allows_reclaim(nid);
+	if (node_state(nid, N_MEMORY))
+		init_zone_allows_reclaim(nid);
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
 #endif
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-thp-fix-infinite-loop-on-memcg-oom.patch
memcg-change-oom_info_lock-to-mutex.patch
mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
memcg-fix-endless-loop-in-__mem_cgroup_iter_next.patch
memcg-reparent-charges-of-children-before-processing-parent.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
drop_caches-add-some-documentation-and-info-message.patch
mm-exclude-memory-less-nodes-from-zone_reclaim.patch
printk-remove-duplicated-check-for-log-level.patch
printk-remove-obsolete-check-for-log-level-c.patch
printk-add-comment-about-tricky-check-for-text-buffer-size.patch
printk-use-also-the-last-bytes-in-the-ring-buffer.patch
printk-do-not-compute-the-size-of-the-message-twice.patch
linux-next.patch

