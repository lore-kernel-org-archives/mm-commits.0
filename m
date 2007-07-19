From: akpm@linux-foundation.org
Subject: - lockdep-sanitise-config_prove_locking.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:03:34 -0700
Message-ID: <200707192003.l6JK3YDE019875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54568 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761308AbXGSU05 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:26:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, jbaron@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: sanitise CONFIG_PROVE_LOCKING
has been removed from the -mm tree.  Its filename was
     lockdep-sanitise-config_prove_locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: sanitise CONFIG_PROVE_LOCKING
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Ensure that all of the lock dependency tracking code is under
CONFIG_PROVE_LOCKING.  This allows us to use the held lock tracking code for
other purposes.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c  |   13 ++++++++++++-
 kernel/spinlock.c |    4 ++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff -puN kernel/lockdep.c~lockdep-sanitise-config_prove_locking kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-sanitise-config_prove_locking
+++ a/kernel/lockdep.c
@@ -95,6 +95,7 @@ static int lockdep_initialized;
 unsigned long nr_list_entries;
 static struct lock_list list_entries[MAX_LOCKDEP_ENTRIES];
 
+#ifdef CONFIG_PROVE_LOCKING
 /*
  * Allocate a lockdep entry. (assumes the graph_lock held, returns
  * with NULL on failure)
@@ -111,6 +112,7 @@ static struct lock_list *alloc_list_entr
 	}
 	return list_entries + nr_list_entries++;
 }
+#endif
 
 /*
  * All data structures here are protected by the global debug_lock.
@@ -140,7 +142,9 @@ LIST_HEAD(all_lock_classes);
 static struct list_head classhash_table[CLASSHASH_SIZE];
 
 unsigned long nr_lock_chains;
+#ifdef CONFIG_PROVE_LOCKING
 static struct lock_chain lock_chains[MAX_LOCKDEP_CHAINS];
+#endif
 
 /*
  * We put the lock dependency chains into a hash-table as well, to cache
@@ -482,6 +486,7 @@ static void print_lock_dependencies(stru
 	}
 }
 
+#ifdef CONFIG_PROVE_LOCKING
 /*
  * Add a new dependency to the head of the list:
  */
@@ -541,6 +546,7 @@ print_circular_bug_entry(struct lock_lis
 
 	return 0;
 }
+#endif
 
 static void print_kernel_version(void)
 {
@@ -549,6 +555,7 @@ static void print_kernel_version(void)
 		init_utsname()->version);
 }
 
+#ifdef CONFIG_PROVE_LOCKING
 /*
  * When a circular dependency is detected, print the
  * header first:
@@ -639,6 +646,7 @@ check_noncircular(struct lock_class *sou
 	}
 	return 1;
 }
+#endif
 
 static int very_verbose(struct lock_class *class)
 {
@@ -823,6 +831,7 @@ check_usage(struct task_struct *curr, st
 
 #endif
 
+#ifdef CONFIG_PROVE_LOCKING
 static int
 print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
 		   struct held_lock *next)
@@ -1087,7 +1096,7 @@ out_bug:
 
 	return 0;
 }
-
+#endif
 
 /*
  * Is this the address of a static object:
@@ -1307,6 +1316,7 @@ out_unlock_set:
 	return class;
 }
 
+#ifdef CONFIG_PROVE_LOCKING
 /*
  * Look up a dependency chain. If the key is not present yet then
  * add it and return 1 - in this case the new dependency chain is
@@ -1381,6 +1391,7 @@ cache_hit:
 
 	return 1;
 }
+#endif
 
 /*
  * We are building curr_chain_key incrementally, so double-check
diff -puN kernel/spinlock.c~lockdep-sanitise-config_prove_locking kernel/spinlock.c
--- a/kernel/spinlock.c~lockdep-sanitise-config_prove_locking
+++ a/kernel/spinlock.c
@@ -88,7 +88,7 @@ unsigned long __lockfunc _spin_lock_irqs
 	 * _raw_spin_lock_flags() code, because lockdep assumes
 	 * that interrupts are not re-enabled during lock-acquire:
 	 */
-#ifdef CONFIG_PROVE_LOCKING
+#ifdef CONFIG_LOCKDEP
 	_raw_spin_lock(lock);
 #else
 	_raw_spin_lock_flags(lock, &flags);
@@ -305,7 +305,7 @@ unsigned long __lockfunc _spin_lock_irqs
 	 * _raw_spin_lock_flags() code, because lockdep assumes
 	 * that interrupts are not re-enabled during lock-acquire:
 	 */
-#ifdef CONFIG_PROVE_SPIN_LOCKING
+#ifdef CONFIG_LOCKDEP
 	_raw_spin_lock(lock);
 #else
 	_raw_spin_lock_flags(lock, &flags);
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
