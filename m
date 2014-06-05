From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:52:23 -0700
Message-ID: <5390ca77.23K8xKu89k4B8fMe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaFETwY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tytso@mit.edu, sfr@canb.auug.org.au, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mhocko@suse.cz, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, mgorman@suse.de

Subject: [merged] mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch removed from -mm tree
To: mgorman@suse.de,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,mhocko@suse.cz,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,sfr@canb.auug.org.au,tytso@mit.edu,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:23 -0700


The patch titled
     Subject: mm: page_alloc: use jump labels to avoid checking number_of_cpusets
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page_alloc: use jump labels to avoid checking number_of_cpusets

If cpusets are not in use then we still check a global variable on every
page allocation.  Use jump labels to avoid the overhead.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |   29 ++++++++++++++++++++++++++---
 kernel/cpuset.c        |   14 ++++----------
 mm/page_alloc.c        |    3 ++-
 3 files changed, 32 insertions(+), 14 deletions(-)

diff -puN include/linux/cpuset.h~mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets include/linux/cpuset.h
--- a/include/linux/cpuset.h~mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets
+++ a/include/linux/cpuset.h
@@ -12,10 +12,31 @@
 #include <linux/cpumask.h>
 #include <linux/nodemask.h>
 #include <linux/mm.h>
+#include <linux/jump_label.h>
 
 #ifdef CONFIG_CPUSETS
 
-extern int number_of_cpusets;	/* How many cpusets are defined in system? */
+extern struct static_key cpusets_enabled_key;
+static inline bool cpusets_enabled(void)
+{
+	return static_key_false(&cpusets_enabled_key);
+}
+
+static inline int nr_cpusets(void)
+{
+	/* jump label reference count + the top-level cpuset */
+	return static_key_count(&cpusets_enabled_key) + 1;
+}
+
+static inline void cpuset_inc(void)
+{
+	static_key_slow_inc(&cpusets_enabled_key);
+}
+
+static inline void cpuset_dec(void)
+{
+	static_key_slow_dec(&cpusets_enabled_key);
+}
 
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
@@ -32,13 +53,13 @@ extern int __cpuset_node_allowed_hardwal
 
 static inline int cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
 {
-	return number_of_cpusets <= 1 ||
+	return nr_cpusets() <= 1 ||
 		__cpuset_node_allowed_softwall(node, gfp_mask);
 }
 
 static inline int cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask)
 {
-	return number_of_cpusets <= 1 ||
+	return nr_cpusets() <= 1 ||
 		__cpuset_node_allowed_hardwall(node, gfp_mask);
 }
 
@@ -124,6 +145,8 @@ static inline void set_mems_allowed(node
 
 #else /* !CONFIG_CPUSETS */
 
+static inline bool cpusets_enabled(void) { return false; }
+
 static inline int cpuset_init(void) { return 0; }
 static inline void cpuset_init_smp(void) {}
 
diff -puN kernel/cpuset.c~mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets kernel/cpuset.c
--- a/kernel/cpuset.c~mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets
+++ a/kernel/cpuset.c
@@ -61,12 +61,7 @@
 #include <linux/cgroup.h>
 #include <linux/wait.h>
 
-/*
- * Tracks how many cpusets are currently defined in system.
- * When there is only one cpuset (the root cpuset) we can
- * short circuit some hooks.
- */
-int number_of_cpusets __read_mostly;
+struct static_key cpusets_enabled_key __read_mostly = STATIC_KEY_INIT_FALSE;
 
 /* See "Frequency meter" comments, below. */
 
@@ -611,7 +606,7 @@ static int generate_sched_domains(cpumas
 		goto done;
 	}
 
-	csa = kmalloc(number_of_cpusets * sizeof(cp), GFP_KERNEL);
+	csa = kmalloc(nr_cpusets() * sizeof(cp), GFP_KERNEL);
 	if (!csa)
 		goto done;
 	csn = 0;
@@ -1888,7 +1883,7 @@ static int cpuset_css_online(struct cgro
 	if (is_spread_slab(parent))
 		set_bit(CS_SPREAD_SLAB, &cs->flags);
 
-	number_of_cpusets++;
+	cpuset_inc();
 
 	if (!test_bit(CGRP_CPUSET_CLONE_CHILDREN, &css->cgroup->flags))
 		goto out_unlock;
@@ -1939,7 +1934,7 @@ static void cpuset_css_offline(struct cg
 	if (is_sched_load_balance(cs))
 		update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
 
-	number_of_cpusets--;
+	cpuset_dec();
 	clear_bit(CS_ONLINE, &cs->flags);
 
 	mutex_unlock(&cpuset_mutex);
@@ -1992,7 +1987,6 @@ int __init cpuset_init(void)
 	if (!alloc_cpumask_var(&cpus_attach, GFP_KERNEL))
 		BUG();
 
-	number_of_cpusets = 1;
 	return 0;
 }
 
diff -puN mm/page_alloc.c~mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets
+++ a/mm/page_alloc.c
@@ -1921,7 +1921,8 @@ zonelist_scan:
 		if (IS_ENABLED(CONFIG_NUMA) && zlc_active &&
 			!zlc_zone_worth_trying(zonelist, z, allowednodes))
 				continue;
-		if ((alloc_flags & ALLOC_CPUSET) &&
+		if (cpusets_enabled() &&
+			(alloc_flags & ALLOC_CPUSET) &&
 			!cpuset_zone_allowed_softwall(zone, gfp_mask))
 				continue;
 		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch

