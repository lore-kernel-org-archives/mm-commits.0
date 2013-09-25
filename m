From: akpm@linux-foundation.org
Subject: [merged]
 revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch removed from -mm tree
Date: Wed, 25 Sep 2013 12:06:02 -0700
Message-ID: <5243341a.665J1KTVodI6jsX8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab3IYTGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 15:06:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, mhocko@suse.cz, hannes@cmpxchg.org, akpm@linux-foundation.org

Subject: [merged] revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch removed from -mm tree
To: akpm@linux-foundation.org,hannes@cmpxchg.org,mhocko@suse.cz,torvalds@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 12:06:02 -0700


The patch titled
     Subject: revert "memcg: track children in soft limit excess to improve soft limit"
has been removed from the -mm tree.  Its filename was
     revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "memcg: track children in soft limit excess to improve soft limit"

Revert

: commit 7d910c054be42515cd3e43f2e1bec8c536632de2
: Author:     Michal Hocko <mhocko@suse.cz>
: AuthorDate: Thu Sep 12 15:13:28 2013 -0700
: Commit:     Linus Torvalds <torvalds@linux-foundation.org>
: CommitDate: Thu Sep 12 15:38:00 2013 -0700
: 
:     memcg: track children in soft limit excess to improve soft limit

I merged this prematurely - Michal and Johannes still disagree about the
overall design direction and the future remains unclear.

Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   71 ----------------------------------------------
 1 file changed, 71 deletions(-)

diff -puN mm/memcontrol.c~revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit mm/memcontrol.c
--- a/mm/memcontrol.c~revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit
+++ a/mm/memcontrol.c
@@ -124,7 +124,6 @@ static const char * const mem_cgroup_lru
  */
 enum mem_cgroup_events_target {
 	MEM_CGROUP_TARGET_THRESH,
-	MEM_CGROUP_TARGET_SOFTLIMIT,
 	MEM_CGROUP_TARGET_NUMAINFO,
 	MEM_CGROUP_NTARGETS,
 };
@@ -303,22 +302,6 @@ struct mem_cgroup {
 	atomic_t	numainfo_events;
 	atomic_t	numainfo_updating;
 #endif
-	/*
-	 * Protects soft_contributed transitions.
-	 * See mem_cgroup_update_soft_limit
-	 */
-	spinlock_t soft_lock;
-
-	/*
-	 * If true then this group has increased parents' children_in_excess
-	 * when it got over the soft limit.
-	 * When a group falls bellow the soft limit, parents' children_in_excess
-	 * is decreased and soft_contributed changed to false.
-	 */
-	bool soft_contributed;
-
-	/* Number of children that are in soft limit excess */
-	atomic_t children_in_excess;
 
 	struct mem_cgroup_per_node *nodeinfo[0];
 	/* WARNING: nodeinfo must be the last member here */
@@ -806,9 +789,6 @@ static bool mem_cgroup_event_ratelimit(s
 		case MEM_CGROUP_TARGET_THRESH:
 			next = val + THRESHOLDS_EVENTS_TARGET;
 			break;
-		case MEM_CGROUP_TARGET_SOFTLIMIT:
-			next = val + SOFTLIMIT_EVENTS_TARGET;
-			break;
 		case MEM_CGROUP_TARGET_NUMAINFO:
 			next = val + NUMAINFO_EVENTS_TARGET;
 			break;
@@ -822,42 +802,6 @@ static bool mem_cgroup_event_ratelimit(s
 }
 
 /*
- * Called from rate-limited memcg_check_events when enough
- * MEM_CGROUP_TARGET_SOFTLIMIT events are accumulated and it makes sure
- * that all the parents up the hierarchy will be notified that this group
- * is in excess or that it is not in excess anymore. mmecg->soft_contributed
- * makes the transition a single action whenever the state flips from one to
- * the other.
- */
-static void mem_cgroup_update_soft_limit(struct mem_cgroup *memcg)
-{
-	unsigned long long excess = res_counter_soft_limit_excess(&memcg->res);
-	struct mem_cgroup *parent = memcg;
-	int delta = 0;
-
-	spin_lock(&memcg->soft_lock);
-	if (excess) {
-		if (!memcg->soft_contributed) {
-			delta = 1;
-			memcg->soft_contributed = true;
-		}
-	} else {
-		if (memcg->soft_contributed) {
-			delta = -1;
-			memcg->soft_contributed = false;
-		}
-	}
-
-	/*
-	 * Necessary to update all ancestors when hierarchy is used
-	 * because their event counter is not touched.
-	 */
-	while (delta && (parent = parent_mem_cgroup(parent)))
-		atomic_add(delta, &parent->children_in_excess);
-	spin_unlock(&memcg->soft_lock);
-}
-
-/*
  * Check events in order.
  *
  */
@@ -867,11 +811,8 @@ static void memcg_check_events(struct me
 	/* threshold event is triggered in finer grain than soft limit */
 	if (unlikely(mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_THRESH))) {
-		bool do_softlimit;
 		bool do_numainfo __maybe_unused;
 
-		do_softlimit = mem_cgroup_event_ratelimit(memcg,
-						MEM_CGROUP_TARGET_SOFTLIMIT);
 #if MAX_NUMNODES > 1
 		do_numainfo = mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_NUMAINFO);
@@ -879,8 +820,6 @@ static void memcg_check_events(struct me
 		preempt_enable();
 
 		mem_cgroup_threshold(memcg);
-		if (unlikely(do_softlimit))
-			mem_cgroup_update_soft_limit(memcg);
 #if MAX_NUMNODES > 1
 		if (unlikely(do_numainfo))
 			atomic_inc(&memcg->numainfo_events);
@@ -1864,9 +1803,6 @@ int mem_cgroup_select_victim_node(struct
  * hierarchy if
  *	a) it is over its soft limit
  *	b) any parent up the hierarchy is over its soft limit
- *
- * If the given group doesn't have any children over the limit then it
- * doesn't make any sense to iterate its subtree.
  */
 enum mem_cgroup_filter_t
 mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
@@ -1888,8 +1824,6 @@ mem_cgroup_soft_reclaim_eligible(struct
 			break;
 	}
 
-	if (!atomic_read(&memcg->children_in_excess))
-		return SKIP_TREE;
 	return SKIP;
 }
 
@@ -6021,7 +5955,6 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	mutex_init(&memcg->thresholds_lock);
 	spin_lock_init(&memcg->move_lock);
 	vmpressure_init(&memcg->vmpressure);
-	spin_lock_init(&memcg->soft_lock);
 
 	return &memcg->css;
 
@@ -6099,10 +6032,6 @@ static void mem_cgroup_css_offline(struc
 
 	mem_cgroup_invalidate_reclaim_iterators(memcg);
 	mem_cgroup_reparent_charges(memcg);
-	if (memcg->soft_contributed) {
-		while ((memcg = parent_mem_cgroup(memcg)))
-			atomic_dec(&memcg->children_in_excess);
-	}
 	mem_cgroup_destroy_all_caches(memcg);
 	vmpressure_cleanup(&memcg->vmpressure);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix.patch
sound-soc-atmel-atmel-pcmc-fix-warning.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
kernel-printk-printkc-convert-to-pr_foo.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

