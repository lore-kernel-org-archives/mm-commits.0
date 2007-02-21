From: akpm@linux-foundation.org
Subject: - convert-highest_possible_processor_id-to-nr_cpu_ids.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:45:18 -0800
Message-ID: <200702211045.l1LAjIfM006347@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46842 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932516AbXBUKpg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:45:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, frederik.deweerdt@gmail.com, neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     Convert highest_possible_processor_id to nr_cpu_ids
has been removed from the -mm tree.  Its filename was
     convert-highest_possible_processor_id-to-nr_cpu_ids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Convert highest_possible_processor_id to nr_cpu_ids
From: Christoph Lameter <clameter@sgi.com>

We frequently need the maximum number of possible processors in order to
allocate arrays for all processors.  So far this was done using
highest_possible_processor_id().  However, we do need the number of
processors not the highest id.  Moreover the number was so far dynamically
calculated on each invokation.  The number of possible processors does not
change when the system is running.  We can therefore calculate that number
once.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h         |    4 ++--
 init/main.c                     |   13 +++++++++----
 lib/cpumask.c                   |   18 ++----------------
 net/bridge/netfilter/ebtables.c |    9 +++------
 net/sunrpc/svc.c                |    2 +-
 5 files changed, 17 insertions(+), 29 deletions(-)

diff -puN include/linux/cpumask.h~convert-highest_possible_processor_id-to-nr_cpu_ids include/linux/cpumask.h
--- a/include/linux/cpumask.h~convert-highest_possible_processor_id-to-nr_cpu_ids
+++ a/include/linux/cpumask.h
@@ -398,11 +398,11 @@ extern cpumask_t cpu_present_map;
 #endif
 
 #ifdef CONFIG_SMP
-int highest_possible_processor_id(void);
+extern int nr_cpu_ids;
 #define any_online_cpu(mask) __any_online_cpu(&(mask))
 int __any_online_cpu(const cpumask_t *mask);
 #else
-#define highest_possible_processor_id()	0
+#define nr_cpu_ids			1
 #define any_online_cpu(mask)		0
 #endif
 
diff -puN init/main.c~convert-highest_possible_processor_id-to-nr_cpu_ids init/main.c
--- a/init/main.c~convert-highest_possible_processor_id-to-nr_cpu_ids
+++ a/init/main.c
@@ -387,14 +387,19 @@ static void __init setup_per_cpu_areas(v
 /* Called by boot processor to activate the rest. */
 static void __init smp_init(void)
 {
-	unsigned int i;
+	unsigned int cpu;
+	unsigned highest = 0;
+
+	for_each_cpu_mask(cpu, cpu_possible_map)
+		highest = cpu;
+	nr_cpu_ids = highest + 1;
 
 	/* FIXME: This should be done in userspace --RR */
-	for_each_present_cpu(i) {
+	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= max_cpus)
 			break;
-		if (!cpu_online(i))
-			cpu_up(i);
+		if (!cpu_online(cpu))
+			cpu_up(cpu);
 	}
 
 	/* Any cleanup work */
diff -puN lib/cpumask.c~convert-highest_possible_processor_id-to-nr_cpu_ids lib/cpumask.c
--- a/lib/cpumask.c~convert-highest_possible_processor_id-to-nr_cpu_ids
+++ a/lib/cpumask.c
@@ -15,22 +15,8 @@ int __next_cpu(int n, const cpumask_t *s
 }
 EXPORT_SYMBOL(__next_cpu);
 
-/*
- * Find the highest possible smp_processor_id()
- *
- * Note: if we're prepared to assume that cpu_possible_map never changes
- * (reasonable) then this function should cache its return value.
- */
-int highest_possible_processor_id(void)
-{
-	unsigned int cpu;
-	unsigned highest = 0;
-
-	for_each_cpu_mask(cpu, cpu_possible_map)
-		highest = cpu;
-	return highest;
-}
-EXPORT_SYMBOL(highest_possible_processor_id);
+int nr_cpu_ids;
+EXPORT_SYMBOL(nr_cpu_ids);
 
 int __any_online_cpu(const cpumask_t *mask)
 {
diff -puN net/bridge/netfilter/ebtables.c~convert-highest_possible_processor_id-to-nr_cpu_ids net/bridge/netfilter/ebtables.c
--- a/net/bridge/netfilter/ebtables.c~convert-highest_possible_processor_id-to-nr_cpu_ids
+++ a/net/bridge/netfilter/ebtables.c
@@ -833,8 +833,7 @@ static int translate_table(char *name, s
 		/* this will get free'd in do_replace()/ebt_register_table()
 		   if an error occurs */
 		newinfo->chainstack =
-			vmalloc((highest_possible_processor_id()+1)
-					* sizeof(*(newinfo->chainstack)));
+			vmalloc(nr_cpu_ids * sizeof(*(newinfo->chainstack)));
 		if (!newinfo->chainstack)
 			return -ENOMEM;
 		for_each_possible_cpu(i) {
@@ -947,8 +946,7 @@ static int do_replace(void __user *user,
 	if (tmp.num_counters >= INT_MAX / sizeof(struct ebt_counter))
 		return -ENOMEM;
 
-	countersize = COUNTER_OFFSET(tmp.nentries) *
-					(highest_possible_processor_id()+1);
+	countersize = COUNTER_OFFSET(tmp.nentries) * nr_cpu_ids;
 	newinfo = vmalloc(sizeof(*newinfo) + countersize);
 	if (!newinfo)
 		return -ENOMEM;
@@ -1168,8 +1166,7 @@ int ebt_register_table(struct ebt_table 
 		return -EINVAL;
 	}
 
-	countersize = COUNTER_OFFSET(repl->nentries) *
-					(highest_possible_processor_id()+1);
+	countersize = COUNTER_OFFSET(repl->nentries) * nr_cpu_ids;
 	newinfo = vmalloc(sizeof(*newinfo) + countersize);
 	ret = -ENOMEM;
 	if (!newinfo)
diff -puN net/sunrpc/svc.c~convert-highest_possible_processor_id-to-nr_cpu_ids net/sunrpc/svc.c
--- a/net/sunrpc/svc.c~convert-highest_possible_processor_id-to-nr_cpu_ids
+++ a/net/sunrpc/svc.c
@@ -115,7 +115,7 @@ fail:
 static int
 svc_pool_map_init_percpu(struct svc_pool_map *m)
 {
-	unsigned int maxpools = highest_possible_processor_id() + 1;
+	unsigned int maxpools = nr_cpu_ids;
 	unsigned int pidx = 0;
 	unsigned int cpu;
 	int err;
_

Patches currently in -mm which might be from clameter@sgi.com are

use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages-fix.patch
make-try_to_unmap-return-a-special-exit-code.patch
add-nr_mlock-zvc.patch
add-pagemlocked-page-state-bit-and-lru-infrastructure.patch
add-pagemlocked-page-state-bit-and-lru-infrastructure-fix.patch
logic-to-move-mlocked-pages.patch
consolidate-new-anonymous-page-code-paths.patch
avoid-putting-new-mlocked-anonymous-pages-on-lru.patch
opportunistically-move-mlocked-pages-off-the-lru.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
mm-implement-swap-prefetching-vs-zvc-stuff.patch
mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
