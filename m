From: akpm@linux-foundation.org
Subject: + huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask.patch
 added to -mm tree
Date: Tue, 05 Apr 2016 16:16:39 -0700
Message-ID: <57044757.OqA2O5mAhnmgfuQJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760067AbcDEXQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 19:16:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: shmem_huge_gfpmask and shmem_recovery_gfpmask
has been added to the -mm tree.  Its filename is
     huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: huge tmpfs: shmem_huge_gfpmask and shmem_recovery_gfpmask

We know that compaction latencies can be a problem for transparent
hugepage allocation; and there has been a history of tweaking the gfpmask
used for anon THP allocation at fault time and by khugepaged.  Plus we
keep on changing our minds as to whether local smallpages are generally
preferable to remote hugepages, or not.

Anon THP has at least /sys/kernel/mm/transparent_hugepage/defrag and
/sys/kernel/mm/transparent_hugepage/khugepaged/defrag to play with
__GFP_RECLAIM bits in its gfpmasks; but so far there's been nothing at all
in huge tmpfs to experiment with these issues, and doubts looming on
whether we've made the right choices.

Add /proc/sys/vm/{shmem_huge_gfpmask,shmem_recovery_gfpmask} to override
the defaults we've been using for its synchronous and asynchronous
hugepage allocations so far: make these tunable now, but no thought yet
given to what values worth experimenting with.  Only numeric validation of
the input: root must just take care.

Three things make this a more awkward patch than you might expect:

1. We shall want to play with __GFP_THISNODE, but that got added
   down inside alloc_pages_vma(): change huge_memory.c to supply it
   for anon THP, then alloc_pages_vma() remove it when unsuitable.

2. It took some time to work out how a global gfpmask template should
   modulate a non-standard incoming gfpmask, different bits having
   different effects: shmem_huge_gfp() helper added for that.

3. __alloc_pages_slowpath() compared gfpmask with GFP_TRANSHUGE
   in a couple of places: which is appropriate for anonymous THP,
   but needed a little rework to extend it to huge tmpfs usage,
   when we're hoping to be able to tune behavior with these sysctls.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/tmpfs.txt |   19 ++++++++
 Documentation/sysctl/vm.txt         |   23 +++++++++-
 include/linux/shmem_fs.h            |    2 
 kernel/sysctl.c                     |   14 ++++++
 mm/huge_memory.c                    |    2 
 mm/mempolicy.c                      |   13 +++--
 mm/page_alloc.c                     |   34 ++++++++-------
 mm/shmem.c                          |   58 +++++++++++++++++++++++---
 8 files changed, 134 insertions(+), 31 deletions(-)

diff -puN Documentation/filesystems/tmpfs.txt~huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask Documentation/filesystems/tmpfs.txt
--- a/Documentation/filesystems/tmpfs.txt~huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask
+++ a/Documentation/filesystems/tmpfs.txt
@@ -192,11 +192,28 @@ In addition to 0 and 1, it also accepts
 automatically on for all tmpfs mounts (intended for testing), or -1
 to force huge off for all (intended for safety if bugs appeared).
 
+/proc/sys/vm/shmem_huge_gfpmask (intended for experimentation only):
+
+Default 38146762, that is 0x24612ca:
+GFP_HIGHUSER_MOVABLE|__GFP_NOWARN|__GFP_THISNODE|__GFP_NORETRY.
+Write a gfpmask built from __GFP flags in include/linux/gfp.h, to experiment
+with better alternatives for the synchronous huge tmpfs allocation used
+when faulting or writing.
+
 /proc/sys/vm/shmem_huge_recoveries:
 
 Default 8, allows up to 8 concurrent workitems, recovering hugepages
 after fragmentation prevented or reclaim disbanded; write 0 to disable
-huge recoveries, or a higher number to allow more concurrent recoveries.
+huge recoveries, or a higher number to allow more concurrent recoveries
+(or a negative number to disable both retry after shrinking, and recovery).
+
+/proc/sys/vm/shmem_recovery_gfpmask (intended for experimentation only):
+
+Default 38142666, that is 0x24602ca:
+GFP_HIGHUSER_MOVABLE|__GFP_NOWARN|__GFP_THISNODE.
+Write a gfpmask built from __GFP flags in include/linux/gfp.h, to experiment
+with alternatives for the asynchronous huge tmpfs allocation used in recovery
+from fragmentation or swapping.
 
 /proc/<pid>/smaps shows:
 
diff -puN Documentation/sysctl/vm.txt~huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask
+++ a/Documentation/sysctl/vm.txt
@@ -57,7 +57,9 @@ Currently, these files are in /proc/sys/
 - panic_on_oom
 - percpu_pagelist_fraction
 - shmem_huge
+- shmem_huge_gfpmask
 - shmem_huge_recoveries
+- shmem_recovery_gfpmask
 - stat_interval
 - stat_refresh
 - swappiness
@@ -765,11 +767,30 @@ See Documentation/filesystems/tmpfs.txt
 
 ==============================================================
 
+shmem_huge_gfpmask
+
+Write a gfpmask built from __GFP flags in include/linux/gfp.h, to experiment
+with better alternatives for the synchronous huge tmpfs allocation used
+when faulting or writing.  See Documentation/filesystems/tmpfs.txt.
+/proc/sys/vm/shmem_huge_gfpmask is intended for experimentation only.
+
+==============================================================
+
 shmem_huge_recoveries
 
 Default 8, allows up to 8 concurrent workitems, recovering hugepages
 after fragmentation prevented or reclaim disbanded; write 0 to disable
-huge recoveries, or a higher number to allow more concurrent recoveries.
+huge recoveries, or a higher number to allow more concurrent recoveries
+(or a negative number to disable both retry after shrinking, and recovery).
+
+==============================================================
+
+shmem_recovery_gfpmask
+
+Write a gfpmask built from __GFP flags in include/linux/gfp.h, to experiment
+with alternatives for the asynchronous huge tmpfs allocation used in recovery
+from fragmentation or swapping.  See Documentation/filesystems/tmpfs.txt.
+/proc/sys/vm/shmem_recovery_gfpmask is intended for experimentation only.
 
 ==============================================================
 
diff -puN include/linux/shmem_fs.h~huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask
+++ a/include/linux/shmem_fs.h
@@ -89,7 +89,7 @@ extern bool shmem_recovery_migrate_page(
 # ifdef CONFIG_SYSCTL
 struct ctl_table;
 extern int shmem_huge, shmem_huge_min, shmem_huge_max;
-extern int shmem_huge_recoveries;
+extern int shmem_huge_recoveries, shmem_huge_gfpmask, shmem_recovery_gfpmask;
 extern int shmem_huge_sysctl(struct ctl_table *table, int write,
 			     void __user *buffer, size_t *lenp, loff_t *ppos);
 # endif /* CONFIG_SYSCTL */
diff -puN kernel/sysctl.c~huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask kernel/sysctl.c
--- a/kernel/sysctl.c~huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask
+++ a/kernel/sysctl.c
@@ -1325,12 +1325,26 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &shmem_huge_max,
 	},
 	{
+		.procname	= "shmem_huge_gfpmask",
+		.data		= &shmem_huge_gfpmask,
+		.maxlen		= sizeof(shmem_huge_gfpmask),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
 		.procname	= "shmem_huge_recoveries",
 		.data		= &shmem_huge_recoveries,
 		.maxlen		= sizeof(shmem_huge_recoveries),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "shmem_recovery_gfpmask",
+		.data		= &shmem_recovery_gfpmask,
+		.maxlen		= sizeof(shmem_recovery_gfpmask),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 #endif
 #ifdef CONFIG_HUGETLB_PAGE
 	{
diff -puN mm/huge_memory.c~huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask mm/huge_memory.c
--- a/mm/huge_memory.c~huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask
+++ a/mm/huge_memory.c
@@ -883,7 +883,7 @@ static inline gfp_t alloc_hugepage_direc
 	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags))
 		reclaim_flags = __GFP_DIRECT_RECLAIM;
 
-	return GFP_TRANSHUGE | reclaim_flags;
+	return GFP_TRANSHUGE | __GFP_THISNODE | reclaim_flags;
 }
 
 /* Defrag for khugepaged will enter direct reclaim/compaction if necessary */
diff -puN mm/mempolicy.c~huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask mm/mempolicy.c
--- a/mm/mempolicy.c~huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask
+++ a/mm/mempolicy.c
@@ -1989,11 +1989,14 @@ retry_cpuset:
 
 		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT + order);
 		mpol_cond_put(pol);
+		if (hugepage)
+			gfp &= ~__GFP_THISNODE;
 		page = alloc_page_interleave(gfp, order, nid);
 		goto out;
 	}
 
-	if (unlikely(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && hugepage)) {
+	if (unlikely(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && hugepage &&
+	    (gfp & __GFP_THISNODE))) {
 		int hpage_node = node;
 
 		/*
@@ -2006,17 +2009,17 @@ retry_cpuset:
 		 * If the policy is interleave, or does not allow the current
 		 * node in its nodemask, we allocate the standard way.
 		 */
-		if (pol->mode == MPOL_PREFERRED &&
-						!(pol->flags & MPOL_F_LOCAL))
+		if (pol->mode == MPOL_PREFERRED && !(pol->flags & MPOL_F_LOCAL))
 			hpage_node = pol->v.preferred_node;
 
 		nmask = policy_nodemask(gfp, pol);
 		if (!nmask || node_isset(hpage_node, *nmask)) {
 			mpol_cond_put(pol);
-			page = __alloc_pages_node(hpage_node,
-						gfp | __GFP_THISNODE, order);
+			page = __alloc_pages_node(hpage_node, gfp, order);
 			goto out;
 		}
+
+		gfp &= ~__GFP_THISNODE;
 	}
 
 	nmask = policy_nodemask(gfp, pol);
diff -puN mm/page_alloc.c~huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask mm/page_alloc.c
--- a/mm/page_alloc.c~huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask
+++ a/mm/page_alloc.c
@@ -3135,9 +3135,15 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_ma
 	return !!(gfp_to_alloc_flags(gfp_mask) & ALLOC_NO_WATERMARKS);
 }
 
-static inline bool is_thp_gfp_mask(gfp_t gfp_mask)
+static inline bool is_thp_allocation(gfp_t gfp_mask, unsigned int order)
 {
-	return (gfp_mask & (GFP_TRANSHUGE | __GFP_KSWAPD_RECLAIM)) == GFP_TRANSHUGE;
+	/*
+	 * !__GFP_KSWAPD_RECLAIM is an unusual choice, and no harm is done if a
+	 * similar high order allocation is occasionally misinterpreted as THP.
+	 */
+	return IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+		!(gfp_mask & __GFP_KSWAPD_RECLAIM) &&
+		(order == HPAGE_PMD_ORDER);
 }
 
 static inline struct page *
@@ -3255,7 +3261,7 @@ retry:
 		goto got_pg;
 
 	/* Checks for THP-specific high-order allocations */
-	if (is_thp_gfp_mask(gfp_mask)) {
+	if (is_thp_allocation(gfp_mask, order)) {
 		/*
 		 * If compaction is deferred for high-order allocations, it is
 		 * because sync compaction recently failed. If this is the case
@@ -3277,20 +3283,16 @@ retry:
 
 		/*
 		 * If compaction was aborted due to need_resched(), we do not
-		 * want to further increase allocation latency, unless it is
-		 * khugepaged trying to collapse.
-		 */
-		if (contended_compaction == COMPACT_CONTENDED_SCHED
-			&& !(current->flags & PF_KTHREAD))
+		 * want to further increase allocation latency at fault.
+		 * If continuing, still use asynchronous memory compaction
+		 * for THP, unless it is khugepaged trying to collapse,
+		 * or an asynchronous huge tmpfs recovery work item.
+		 */
+		if (current->flags & PF_KTHREAD)
+			migration_mode = MIGRATE_SYNC_LIGHT;
+		else if (contended_compaction == COMPACT_CONTENDED_SCHED)
 			goto nopage;
-	}
-
-	/*
-	 * It can become very expensive to allocate transparent hugepages at
-	 * fault, so use asynchronous memory compaction for THP unless it is
-	 * khugepaged trying to collapse.
-	 */
-	if (!is_thp_gfp_mask(gfp_mask) || (current->flags & PF_KTHREAD))
+	} else
 		migration_mode = MIGRATE_SYNC_LIGHT;
 
 	/* Try direct reclaim and then allocating */
diff -puN mm/shmem.c~huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask mm/shmem.c
--- a/mm/shmem.c~huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask
+++ a/mm/shmem.c
@@ -323,6 +323,43 @@ static DEFINE_SPINLOCK(shmem_shrinklist_
 int shmem_huge __read_mostly;
 int shmem_huge_recoveries __read_mostly = 8;	/* concurrent recovery limit */
 
+int shmem_huge_gfpmask __read_mostly =
+	(int)(GFP_HIGHUSER_MOVABLE|__GFP_NOWARN|__GFP_THISNODE|__GFP_NORETRY);
+int shmem_recovery_gfpmask __read_mostly =
+	(int)(GFP_HIGHUSER_MOVABLE|__GFP_NOWARN|__GFP_THISNODE);
+
+/*
+ * Compose the requested_gfp for a small page together with the tunable
+ * template above, to construct a suitable gfpmask for a huge allocation.
+ */
+static gfp_t shmem_huge_gfp(int tunable_template, gfp_t requested_gfp)
+{
+	gfp_t huge_gfpmask = (gfp_t)tunable_template;
+	gfp_t relaxants;
+
+	/*
+	 * Relaxants must only be applied when they are permitted in both.
+	 * GFP_KERNEL happens to be the name for
+	 * __GFP_IO|__GFP_FS|__GFP_DIRECT_RECLAIM|__GFP_KSWAPD_RECLAIM.
+	 */
+	relaxants = huge_gfpmask & requested_gfp & GFP_KERNEL;
+
+	/*
+	 * Zone bits must be taken exclusively from the requested gfp mask.
+	 * __GFP_COMP would be a disaster: make sure the sysctl cannot add it.
+	 */
+	huge_gfpmask &= __GFP_BITS_MASK & ~(GFP_ZONEMASK|__GFP_COMP|GFP_KERNEL);
+
+	/*
+	 * These might be right for a small page, but unsuitable for the huge.
+	 * REPEAT and NOFAIL very likely wrong in huge_gfpmask, but permitted.
+	 */
+	requested_gfp &= ~(__GFP_REPEAT|__GFP_NOFAIL|__GFP_COMP|GFP_KERNEL);
+
+	/* Beyond that, we can simply use the union, sensible or not */
+	return huge_gfpmask | requested_gfp | relaxants;
+}
+
 static struct page *shmem_hugeteam_lookup(struct address_space *mapping,
 					  pgoff_t index, bool speculative)
 {
@@ -1395,8 +1432,9 @@ static void shmem_recovery_work(struct w
 		 * often choose an unsuitable NUMA node: something to fix soon,
 		 * but not an immediate blocker.
 		 */
+		gfp = shmem_huge_gfp(shmem_recovery_gfpmask, gfp);
 		head = __alloc_pages_node(page_to_nid(page),
-			gfp | __GFP_NOWARN | __GFP_THISNODE, HPAGE_PMD_ORDER);
+					  gfp, HPAGE_PMD_ORDER);
 		if (!head) {
 			shr_stats(huge_failed);
 			error = -ENOMEM;
@@ -1732,9 +1770,15 @@ static struct shrinker shmem_hugehole_sh
 #else /* !CONFIG_TRANSPARENT_HUGEPAGE */
 
 #define shmem_huge SHMEM_HUGE_DENY
+#define shmem_huge_gfpmask GFP_HIGHUSER_MOVABLE
 #define shmem_huge_recoveries 0
 #define shr_stats(x) do {} while (0)
 
+static inline gfp_t shmem_huge_gfp(int tunable_template, gfp_t requested_gfp)
+{
+	return requested_gfp;
+}
+
 static inline struct page *shmem_hugeteam_lookup(struct address_space *mapping,
 					pgoff_t index, bool speculative)
 {
@@ -2626,14 +2670,16 @@ static struct page *shmem_alloc_page(gfp
 		rcu_read_unlock();
 
 		if (*hugehint == SHMEM_ALLOC_HUGE_PAGE) {
-			head = alloc_pages_vma(gfp|__GFP_NORETRY|__GFP_NOWARN,
-				HPAGE_PMD_ORDER, &pvma, 0, numa_node_id(),
-				true);
+			gfp_t huge_gfp;
+
+			huge_gfp = shmem_huge_gfp(shmem_huge_gfpmask, gfp);
+			head = alloc_pages_vma(huge_gfp,
+					HPAGE_PMD_ORDER, &pvma, 0,
+					numa_node_id(), true);
 			/* Shrink and retry? Or leave it to recovery worker */
 			if (!head && !shmem_huge_recoveries &&
 			    shmem_shrink_hugehole(NULL, NULL) != SHRINK_STOP) {
-				head = alloc_pages_vma(
-					gfp|__GFP_NORETRY|__GFP_NOWARN,
+				head = alloc_pages_vma(huge_gfp,
 					HPAGE_PMD_ORDER, &pvma, 0,
 					numa_node_id(), true);
 			}
_

Patches currently in -mm which might be from hughd@google.com are

mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch
arch-fix-has_transparent_hugepage.patch
huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m.patch
huge-tmpfs-include-shmem-freeholes-in-available-memory.patch
huge-tmpfs-huge=n-mount-option-and-proc-sys-vm-shmem_huge.patch
huge-tmpfs-try-to-allocate-huge-pages-split-into-a-team.patch
huge-tmpfs-avoid-team-pages-in-a-few-places.patch
huge-tmpfs-shrinker-to-migrate-and-free-underused-holes.patch
huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page.patch
huge-tmpfs-try_to_unmap_one-use-page_check_address_transhuge.patch
huge-tmpfs-avoid-premature-exposure-of-new-pagetable.patch
huge-tmpfs-map-shmem-by-huge-page-pmd-or-by-page-team-ptes.patch
huge-tmpfs-disband-split-huge-pmds-on-race-or-memory-failure.patch
huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd.patch
huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages.patch
huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks.patch
huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings.patch
huge-tmpfs-mem_cgroup-move-charge-on-shmem-huge-pages.patch
huge-tmpfs-proc-pid-smaps-show-shmemhugepages.patch
huge-tmpfs-recovery-framework-for-reconstituting-huge-pages.patch
huge-tmpfs-recovery-shmem_recovery_populate-to-fill-huge-page.patch
huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd.patch
huge-tmpfs-recovery-shmem_recovery_swapin-to-read-from-swap.patch
huge-tmpfs-recovery-tweak-shmem_getpage_gfp-to-fill-team.patch
huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase.patch
huge-tmpfs-recovery-page-migration-call-back-into-shmem.patch
huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask.patch

