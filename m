From: akpm@linux-foundation.org
Subject: + mm-add-__gfp_other_node-flag.patch added to -mm tree
Date: Fri, 04 Mar 2011 16:07:00 -0800
Message-ID: <201103050007.p25070aa011887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760032Ab1CEAHT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 19:07:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: add __GFP_OTHER_NODE flag
has been added to the -mm tree.  Its filename is
     mm-add-__gfp_other_node-flag.patch

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
Subject: mm: add __GFP_OTHER_NODE flag
From: Andi Kleen <ak@linux.intel.com>

Add a new __GFP_OTHER_NODE flag to tell the low level numa statistics in
zone_statistics() that an allocation is on behalf of another thread.  This
way the local and remote counters can be still correct, even when
background daemons like khugepaged are changing memory mappings.

This only affects the accounting, but I think it's worth doing that right
to avoid confusing users.

I first tried to just pass down the right node, but this required a lot of
changes to pass down this parameter and at least one addition of a 10th
argument to a 9 argument function.  Using the flag is a lot less
intrusive.

Open: should be also used for migration?

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h    |    2 ++
 include/linux/vmstat.h |    4 ++--
 mm/page_alloc.c        |    2 +-
 mm/vmstat.c            |    9 +++++++--
 4 files changed, 12 insertions(+), 5 deletions(-)

diff -puN include/linux/gfp.h~mm-add-__gfp_other_node-flag include/linux/gfp.h
--- a/include/linux/gfp.h~mm-add-__gfp_other_node-flag
+++ a/include/linux/gfp.h
@@ -35,6 +35,7 @@ struct vm_area_struct;
 #define ___GFP_NOTRACK		0
 #endif
 #define ___GFP_NO_KSWAPD	0x400000u
+#define ___GFP_OTHER_NODE	0x800000u
 
 /*
  * GFP bitmasks..
@@ -83,6 +84,7 @@ struct vm_area_struct;
 #define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)  /* Don't track with kmemcheck */
 
 #define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
+#define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE) /* On behalf of other node */
 
 /*
  * This may seem redundant, but it's a way of annotating false positives vs.
diff -puN include/linux/vmstat.h~mm-add-__gfp_other_node-flag include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-add-__gfp_other_node-flag
+++ a/include/linux/vmstat.h
@@ -220,12 +220,12 @@ static inline unsigned long node_page_st
 		zone_page_state(&zones[ZONE_MOVABLE], item);
 }
 
-extern void zone_statistics(struct zone *, struct zone *);
+extern void zone_statistics(struct zone *, struct zone *, gfp_t gfp);
 
 #else
 
 #define node_page_state(node, item) global_page_state(item)
-#define zone_statistics(_zl,_z) do { } while (0)
+#define zone_statistics(_zl,_z, gfp) do { } while (0)
 
 #endif /* CONFIG_NUMA */
 
diff -puN mm/page_alloc.c~mm-add-__gfp_other_node-flag mm/page_alloc.c
--- a/mm/page_alloc.c~mm-add-__gfp_other_node-flag
+++ a/mm/page_alloc.c
@@ -1337,7 +1337,7 @@ again:
 	}
 
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
-	zone_statistics(preferred_zone, zone);
+	zone_statistics(preferred_zone, zone, gfp_flags);
 	local_irq_restore(flags);
 
 	VM_BUG_ON(bad_range(zone, page));
diff -puN mm/vmstat.c~mm-add-__gfp_other_node-flag mm/vmstat.c
--- a/mm/vmstat.c~mm-add-__gfp_other_node-flag
+++ a/mm/vmstat.c
@@ -500,8 +500,12 @@ void refresh_cpu_vm_stats(int cpu)
  * z 	    = the zone from which the allocation occurred.
  *
  * Must be called with interrupts disabled.
+ * 
+ * When __GFP_OTHER_NODE is set assume the node of the preferred
+ * zone is the local node. This is useful for daemons who allocate
+ * memory on behalf of other processes.
  */
-void zone_statistics(struct zone *preferred_zone, struct zone *z)
+void zone_statistics(struct zone *preferred_zone, struct zone *z, gfp_t flags)
 {
 	if (z->zone_pgdat == preferred_zone->zone_pgdat) {
 		__inc_zone_state(z, NUMA_HIT);
@@ -509,7 +513,8 @@ void zone_statistics(struct zone *prefer
 		__inc_zone_state(z, NUMA_MISS);
 		__inc_zone_state(preferred_zone, NUMA_FOREIGN);
 	}
-	if (z->node == numa_node_id())
+	if (z->node == ((flags & __GFP_OTHER_NODE) ? 
+			preferred_zone->node : numa_node_id()))
 		__inc_zone_state(z, NUMA_LOCAL);
 	else
 		__inc_zone_state(z, NUMA_OTHER);
_

Patches currently in -mm which might be from ak@linux.intel.com are

mm-change-alloc_pages_vma-to-pass-down-the-policy-node-for-local-policy.patch
mm-add-alloc_page_vma_node.patch
mm-preserve-original-node-for-transparent-huge-page-copies.patch
mm-use-correct-numa-policy-node-for-transparent-hugepages.patch
mm-use-correct-numa-policy-node-for-transparent-hugepages-checkpatch-fixes.patch
linux-next.patch
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu.patch
mm-add-__gfp_other_node-flag.patch
mm-use-__gfp_other_node-for-transparent-huge-pages.patch
mm-add-vm-counters-for-transparent-hugepages.patch
llist-irq_work-use-llist-in-irq_work.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch

