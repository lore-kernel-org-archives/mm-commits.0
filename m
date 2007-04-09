From: akpm@linux-foundation.org
Subject: + slab-x86_64-skip-cache_free_alien-on-non-numa.patch added to -mm tree
Date: Mon, 09 Apr 2007 13:23:51 -0700
Message-ID: <200704092023.l39KNpSB022561@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58973 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbXDIUY2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 16:24:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suresh.b.siddha@intel.com, andi@firstfloor.org, clameter@engr.sgi.com, dada1@cosmosbay.com, rientjes@google.com


The patch titled
     slab, x86_64: skip cache_free_alien() on non NUMA
has been added to the -mm tree.  Its filename is
     slab-x86_64-skip-cache_free_alien-on-non-numa.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slab, x86_64: skip cache_free_alien() on non NUMA
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Set use_alien_caches to 0 on non NUMA platforms.  And avoid calling the
cache_free_alien() when use_alien_caches is not set.  This will avoid the
cache miss that happens while dereferencing slabp to get nodeid.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~slab-x86_64-skip-cache_free_alien-on-non-numa mm/slab.c
--- a/mm/slab.c~slab-x86_64-skip-cache_free_alien-on-non-numa
+++ a/mm/slab.c
@@ -1146,7 +1146,7 @@ static inline int cache_free_alien(struc
 	 * Make sure we are not freeing a object from another node to the array
 	 * cache on this cpu.
 	 */
-	if (likely(slabp->nodeid == node) || unlikely(!use_alien_caches))
+	if (likely(slabp->nodeid == node))
 		return 0;
 
 	l3 = cachep->nodelists[node];
@@ -1394,6 +1394,9 @@ void __init kmem_cache_init(void)
 	int order;
 	int node;
 
+	if (num_possible_nodes() == 1)
+		use_alien_caches = 0;
+
 	for (i = 0; i < NUM_INIT_LISTS; i++) {
 		kmem_list3_init(&initkmem_list3[i]);
 		if (i < MAX_NUMNODES)
@@ -3563,7 +3566,7 @@ static inline void __cache_free(struct k
 	check_irq_off();
 	objp = cache_free_debugcheck(cachep, objp, __builtin_return_address(0));
 
-	if (cache_free_alien(cachep, objp))
+	if (use_alien_caches && cache_free_alien(cachep, objp))
 		return;
 
 	if (likely(ac->avail < ac->limit)) {
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

x86_64-set-node_possible_map-at-runtime.patch
slab-x86_64-skip-cache_free_alien-on-non-numa.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-dynticks-idle-load-balancing-v3.patch
sched-optimize-siblings-status-check-logic-in-wake_idle.patch
sched-dont-renice-kernel-threads.patch
sched-remove-sleepavg-from-proc.patch
sched-implement-staircase-deadline-cpu-scheduler.patch
sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
