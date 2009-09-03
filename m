From: akpm@linux-foundation.org
Subject: + mm-fix-numa-accounting-in-numastattxt.patch added to -mm tree
Date: Thu, 03 Sep 2009 14:16:30 -0700
Message-ID: <200909032116.n83LGU6s032200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752384AbZICVQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Sep 2009 17:16:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: fix NUMA accounting in numastat.txt
has been added to the -mm tree.  Its filename is
     mm-fix-numa-accounting-in-numastattxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix NUMA accounting in numastat.txt
From: Minchan Kim <minchan.kim@gmail.com>

In Documentation/numastat.txt, it confused me.  For example, there are
nodes [0,1] in system.

barrios:~$ cat /proc/zoneinfo | egrep 'numa|zone'
Node 0, zone	DMA
	numa_hit	33226
	numa_miss	1739
	numa_foreign	27978
	..
	..
Node 1, zone	DMA
	numa_hit	307
	numa_miss	46900
	numa_foreign	0

1) In node 0,  NUMA_MISS means it wanted to allocate page
in node 1 but ended up with page in node 0

2) In node 0, NUMA_FOREIGN means it wanted to allocate page
in node 0 but ended up with page from Node 1.

But now, numastat explains it oppositely about (MISS, FOREIGN).
Let's fix up with viewpoint of zone.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/numastat.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/numastat.txt~mm-fix-numa-accounting-in-numastattxt Documentation/numastat.txt
--- a/Documentation/numastat.txt~mm-fix-numa-accounting-in-numastattxt
+++ a/Documentation/numastat.txt
@@ -7,10 +7,10 @@ All units are pages. Hugepages have sepa
 
 numa_hit			A process wanted to allocate memory from this node,
 					and succeeded.
-numa_miss			A process wanted to allocate memory from this node,
-					but ended up with memory from another.
-numa_foreign		A process wanted to allocate on another node,
-				    but ended up with memory from this one.
+numa_miss			A process wanted to allocate memory from another node,
+					but ended up with memory from this node.
+numa_foreign		A process wanted to allocate on this node,
+				    but ended up with memory from another one.
 local_node			A process ran on this node and got memory from it.
 other_node			A process ran on this node and got memory from another node.
 interleave_hit 		Interleaving wanted to allocate from this node
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

linux-next.patch
mm-memory-failure-remove-config_unevictable_lru-config-option.patch
mm-show_free_areas-display-slab-pages-in-two-separate-fields.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-rename-pgmoved-variable-in-shrink_active_list.patch
mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch
mm-vmstat-add-isolate-pages.patch
mm-vmstat-add-isolate-pages-fix.patch
mm-remove-__addsub_zone_page_state.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
mm-introduce-page_lru_base_type.patch
mm-introduce-page_lru_base_type-fix.patch
memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory.patch
mm-do-batched-scans-for-mem_cgroup.patch
vmscan-move-pgdeactivate-modification-to-shrink_active_list-fix.patch
page-allocator-split-per-cpu-list-into-one-list-per-migrate-type.patch
page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
mm-fix-numa-accounting-in-numastattxt.patch

