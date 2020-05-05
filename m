From: akpm@linux-foundation.org
Subject: +
 mm-memcg-decouple-elowmin-state-mutations-from-protection-checks.patch
 added to -mm tree
Date: Tue, 05 May 2020 12:57:37 -0700
Message-ID: <20200505195737.BWOevmVjW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgEET5k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 May 2020 15:57:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, laoar.shao@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: decouple e{low,min} state mutations from protection checks
has been added to the -mm tree.  Its filename is
     mm-memcg-decouple-elowmin-state-mutations-from-protection-checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-decouple-elowmin-state-mutations-from-protection-checks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-decouple-elowmin-state-mutations-from-protection-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Down <chris@chrisdown.name>
Subject: mm, memcg: decouple e{low,min} state mutations from protection checks

mem_cgroup_protected currently is both used to set effective low and min
and return a mem_cgroup_protection based on the result.  As a user, this
can be a little unexpected: it appears to be a simple predicate function,
if not for the big warning in the comment above about the order in which
it must be executed.

This change makes it so that we separate the state mutations from the
actual protection checks, which makes it more obvious where we need to be
careful mutating internal state, and where we are simply checking and
don't need to worry about that.

Link: http://lkml.kernel.org/r/20200505084127.12923-3-laoar.shao@gmail.com
Signed-off-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   43 ++++++++++++++++++++++++++---------
 mm/memcontrol.c            |   28 +++++-----------------
 mm/vmscan.c                |   17 +++----------
 3 files changed, 43 insertions(+), 45 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-decouple-elowmin-state-mutations-from-protection-checks
+++ a/include/linux/memcontrol.h
@@ -50,12 +50,6 @@ enum memcg_memory_event {
 	MEMCG_NR_MEMORY_EVENTS,
 };
 
-enum mem_cgroup_protection {
-	MEMCG_PROT_NONE,
-	MEMCG_PROT_LOW,
-	MEMCG_PROT_MIN,
-};
-
 struct mem_cgroup_reclaim_cookie {
 	pg_data_t *pgdat;
 	unsigned int generation;
@@ -394,8 +388,26 @@ static inline unsigned long mem_cgroup_p
 		   READ_ONCE(memcg->memory.elow));
 }
 
-enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
-						struct mem_cgroup *memcg);
+void mem_cgroup_calculate_protection(struct mem_cgroup *root,
+				     struct mem_cgroup *memcg);
+
+static inline bool mem_cgroup_below_low(struct mem_cgroup *memcg)
+{
+	if (mem_cgroup_disabled())
+		return false;
+
+	return READ_ONCE(memcg->memory.elow) >=
+		page_counter_read(&memcg->memory);
+}
+
+static inline bool mem_cgroup_below_min(struct mem_cgroup *memcg)
+{
+	if (mem_cgroup_disabled())
+		return false;
+
+	return READ_ONCE(memcg->memory.emin) >=
+		page_counter_read(&memcg->memory);
+}
 
 int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
 			  gfp_t gfp_mask, struct mem_cgroup **memcgp,
@@ -881,10 +893,19 @@ static inline unsigned long mem_cgroup_p
 	return 0;
 }
 
-static inline enum mem_cgroup_protection mem_cgroup_protected(
-	struct mem_cgroup *root, struct mem_cgroup *memcg)
+static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
+						   struct mem_cgroup *memcg)
+{
+}
+
+static inline bool mem_cgroup_below_low(struct mem_cgroup *memcg)
+{
+	return false;
+}
+
+static inline bool mem_cgroup_below_min(struct mem_cgroup *memcg)
 {
-	return MEMCG_PROT_NONE;
+	return false;
 }
 
 static inline int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
--- a/mm/memcontrol.c~mm-memcg-decouple-elowmin-state-mutations-from-protection-checks
+++ a/mm/memcontrol.c
@@ -6376,21 +6376,15 @@ static unsigned long effective_protectio
  *
  * WARNING: This function is not stateless! It can only be used as part
  *          of a top-down tree iteration, not for isolated queries.
- *
- * Returns one of the following:
- *   MEMCG_PROT_NONE: cgroup memory is not protected
- *   MEMCG_PROT_LOW: cgroup memory is protected as long there is
- *     an unprotected supply of reclaimable memory from other cgroups.
- *   MEMCG_PROT_MIN: cgroup memory is protected
  */
-enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
-						struct mem_cgroup *memcg)
+void mem_cgroup_calculate_protection(struct mem_cgroup *root,
+				     struct mem_cgroup *memcg)
 {
 	unsigned long usage, parent_usage;
 	struct mem_cgroup *parent;
 
 	if (mem_cgroup_disabled())
-		return MEMCG_PROT_NONE;
+		return;
 
 	if (!root)
 		root = root_mem_cgroup;
@@ -6403,21 +6397,21 @@ enum mem_cgroup_protection mem_cgroup_pr
 	 * that special casing.
 	 */
 	if (memcg == root)
-		return MEMCG_PROT_NONE;
+		return;
 
 	usage = page_counter_read(&memcg->memory);
 	if (!usage)
-		return MEMCG_PROT_NONE;
+		return;
 
 	parent = parent_mem_cgroup(memcg);
 	/* No parent means a non-hierarchical mode on v1 memcg */
 	if (!parent)
-		return MEMCG_PROT_NONE;
+		return;
 
 	if (parent == root) {
 		memcg->memory.emin = READ_ONCE(memcg->memory.min);
 		memcg->memory.elow = memcg->memory.low;
-		goto out;
+		return;
 	}
 
 	parent_usage = page_counter_read(&parent->memory);
@@ -6430,14 +6424,6 @@ enum mem_cgroup_protection mem_cgroup_pr
 	WRITE_ONCE(memcg->memory.elow, effective_protection(usage, parent_usage,
 			memcg->memory.low, READ_ONCE(parent->memory.elow),
 			atomic_long_read(&parent->memory.children_low_usage)));
-
-out:
-	if (usage <= memcg->memory.emin)
-		return MEMCG_PROT_MIN;
-	else if (usage <= memcg->memory.elow)
-		return MEMCG_PROT_LOW;
-	else
-		return MEMCG_PROT_NONE;
 }
 
 /**
--- a/mm/vmscan.c~mm-memcg-decouple-elowmin-state-mutations-from-protection-checks
+++ a/mm/vmscan.c
@@ -2634,14 +2634,15 @@ static void shrink_node_memcgs(pg_data_t
 		unsigned long reclaimed;
 		unsigned long scanned;
 
-		switch (mem_cgroup_protected(target_memcg, memcg)) {
-		case MEMCG_PROT_MIN:
+		mem_cgroup_calculate_protection(target_memcg, memcg);
+
+		if (mem_cgroup_below_min(memcg)) {
 			/*
 			 * Hard protection.
 			 * If there is no reclaimable memory, OOM.
 			 */
 			continue;
-		case MEMCG_PROT_LOW:
+		} else if (mem_cgroup_below_low(memcg)) {
 			/*
 			 * Soft protection.
 			 * Respect the protection only as long as
@@ -2653,16 +2654,6 @@ static void shrink_node_memcgs(pg_data_t
 				continue;
 			}
 			memcg_memory_event(memcg, MEMCG_LOW);
-			break;
-		case MEMCG_PROT_NONE:
-			/*
-			 * All protection thresholds breached. We may
-			 * still choose to vary the scan pressure
-			 * applied based on by how much the cgroup in
-			 * question has exceeded its protection
-			 * thresholds (see get_scan_count).
-			 */
-			break;
 		}
 
 		reclaimed = sc->nr_reclaimed;
_

Patches currently in -mm which might be from chris@chrisdown.name are

mm-memcg-decouple-elowmin-state-mutations-from-protection-checks.patch
