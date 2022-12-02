Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F064C47088
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 21:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbiLBVE3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Dec 2022 16:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234190AbiLBVE2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2022 16:04:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A319ACBA4F
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 13:04:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D81DB82212
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 21:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF783C433D6;
        Fri,  2 Dec 2022 21:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670015064;
        bh=GWETTOFtut23aj9mdhn774oSoKyaY9z3PxX8jfo2RzQ=;
        h=Date:To:From:Subject:From;
        b=lz+XsVD/ZZP4dDTwImYZ3++s/QD65CH7UyMZ3zs+UKsak4oS9K2ADOmXoeJeKbyED
         zN/C7g+xlxupNyFS3EzQ7tOG9JbILEa6WRa77WdkK4UHaq70LkePYWnCcjoeL2VrGV
         9napa3fG2iMmk2MZCfaXuEazGg9hcO4BOzsha16s=
Date:   Fri, 02 Dec 2022 13:04:22 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, vasily.averin@linux.dev, tj@kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, rientjes@google.com, mhocko@suse.com,
        hannes@cmpxchg.org, chris@chrisdown.name, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-fix-stale-protection-of-reclaim-target-memcg.patch added to mm-unstable branch
Message-Id: <20221202210423.EF783C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: fix stale protection of reclaim target memcg
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-fix-stale-protection-of-reclaim-target-memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-fix-stale-protection-of-reclaim-target-memcg.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: memcg: fix stale protection of reclaim target memcg
Date: Fri, 2 Dec 2022 03:15:10 +0000

Patch series "mm: memcg: fix protection of reclaim target memcg", v3.

This series fixes a bug in calculating the protection of the reclaim
target memcg where we end up using stale effective protection values from
the last reclaim operation, instead of completely ignoring the protection
of the reclaim target as intended.  More detailed explanation and examples
in patch 1, which includes the fix.  Patches 2 & 3 introduce a selftest
case that catches the bug.


This patch (of 3):

During reclaim, mem_cgroup_calculate_protection() is used to determine the
effective protection (emin and elow) values of a memcg.  The protection of
the reclaim target is ignored, but we cannot set their effective
protection to 0 due to a limitation of the current implementation (see
comment in mem_cgroup_protection()).  Instead, we leave their effective
protection values unchaged, and later ignore it in
mem_cgroup_protection().

However, mem_cgroup_protection() is called later in
shrink_lruvec()->get_scan_count(), which is after the
mem_cgroup_below_{min/low}() checks in shrink_node_memcgs().  As a result,
the stale effective protection values of the target memcg may lead us to
skip reclaiming from the target memcg entirely, before calling
shrink_lruvec().  This can be even worse with recursive protection, where
the stale target memcg protection can be higher than its standalone
protection.  See two examples below (a similar version of example (a) is
added to test_memcontrol in a later patch).

(a) A simple example with proactive reclaim is as follows. Consider the
following hierarchy:
ROOT
 |
 A
 |
 B (memory.min = 10M)

Consider the following scenario:
- B has memory.current = 10M.
- The system undergoes global reclaim (or memcg reclaim in A).
- In shrink_node_memcgs():
  - mem_cgroup_calculate_protection() calculates the effective min (emin)
    of B as 10M.
  - mem_cgroup_below_min() returns true for B, we do not reclaim from B.
- Now if we want to reclaim 5M from B using proactive reclaim
  (memory.reclaim), we should be able to, as the protection of the
  target memcg should be ignored.
- In shrink_node_memcgs():
  - mem_cgroup_calculate_protection() immediately returns for B without
    doing anything, as B is the target memcg, relying on
    mem_cgroup_protection() to ignore B's stale effective min (still 10M).
  - mem_cgroup_below_min() reads the stale effective min for B and we
    skip it instead of ignoring its protection as intended, as we never
    reach mem_cgroup_protection().

(b) An more complex example with recursive protection is as follows.
Consider the following hierarchy with memory_recursiveprot:
ROOT
 |
 A (memory.min = 50M)
 |
 B (memory.min = 10M, memory.high = 40M)

Consider the following scenario:
- B has memory.current = 35M.
- The system undergoes global reclaim (target memcg is NULL).
- B will have an effective min of 50M (all of A's unclaimed protection).
- B will not be reclaimed from.
- Now allocate 10M more memory in B, pushing it above it's high limit.
- The system undergoes memcg reclaim from B (target memcg is B).
- Like example (a), we do nothing in mem_cgroup_calculate_protection(),
  then call mem_cgroup_below_min(), which will read the stale effective
  min for B (50M) and skip it. In this case, it's even worse because we
  are not just considering B's standalone protection (10M), but we are
  reading a much higher stale protection (50M) which will cause us to not
  reclaim from B at all.

This is an artifact of commit 45c7f7e1ef17 ("mm, memcg: decouple
e{low,min} state mutations from protection checks") which made
mem_cgroup_calculate_protection() only change the state without returning
any value.  Before that commit, we used to return MEMCG_PROT_NONE for the
target memcg, which would cause us to skip the
mem_cgroup_below_{min/low}() checks.  After that commit we do not return
anything and we end up checking the min & low effective protections for
the target memcg, which are stale.

Update mem_cgroup_supports_protection() to also check if we are reclaiming
from the target, and rename it to mem_cgroup_unprotected() (now returns
true if we should not protect the memcg, much simpler logic).

Link: https://lkml.kernel.org/r/20221202031512.1365483-1-yosryahmed@google.com
Link: https://lkml.kernel.org/r/20221202031512.1365483-2-yosryahmed@google.com
Fixes: 45c7f7e1ef17 ("mm, memcg: decouple e{low,min} state mutations from protection checks")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Chris Down <chris@chrisdown.name>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vasily Averin <vasily.averin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   31 +++++++++++++++++++++----------
 mm/vmscan.c                |   11 ++++++-----
 2 files changed, 27 insertions(+), 15 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-fix-stale-protection-of-reclaim-target-memcg
+++ a/include/linux/memcontrol.h
@@ -615,28 +615,32 @@ static inline void mem_cgroup_protection
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 				     struct mem_cgroup *memcg);
 
-static inline bool mem_cgroup_supports_protection(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
+					  struct mem_cgroup *memcg)
 {
 	/*
 	 * The root memcg doesn't account charges, and doesn't support
-	 * protection.
+	 * protection. The target memcg's protection is ignored, see
+	 * mem_cgroup_calculate_protection() and mem_cgroup_protection()
 	 */
-	return !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg);
-
+	return mem_cgroup_disabled() || mem_cgroup_is_root(memcg) ||
+		memcg == target;
 }
 
-static inline bool mem_cgroup_below_low(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
+					struct mem_cgroup *memcg)
 {
-	if (!mem_cgroup_supports_protection(memcg))
+	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
 	return READ_ONCE(memcg->memory.elow) >=
 		page_counter_read(&memcg->memory);
 }
 
-static inline bool mem_cgroup_below_min(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
+					struct mem_cgroup *memcg)
 {
-	if (!mem_cgroup_supports_protection(memcg))
+	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
 	return READ_ONCE(memcg->memory.emin) >=
@@ -1209,12 +1213,19 @@ static inline void mem_cgroup_calculate_
 {
 }
 
-static inline bool mem_cgroup_below_low(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
+					  struct mem_cgroup *memcg)
+{
+	return true;
+}
+static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
+					struct mem_cgroup *memcg)
 {
 	return false;
 }
 
-static inline bool mem_cgroup_below_min(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
+					struct mem_cgroup *memcg)
 {
 	return false;
 }
--- a/mm/vmscan.c~mm-memcg-fix-stale-protection-of-reclaim-target-memcg
+++ a/mm/vmscan.c
@@ -4513,7 +4513,7 @@ static bool age_lruvec(struct lruvec *lr
 
 	mem_cgroup_calculate_protection(NULL, memcg);
 
-	if (mem_cgroup_below_min(memcg))
+	if (mem_cgroup_below_min(NULL, memcg))
 		return false;
 
 	need_aging = should_run_aging(lruvec, max_seq, min_seq, sc, swappiness, &nr_to_scan);
@@ -5100,8 +5100,9 @@ static unsigned long get_nr_to_scan(stru
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
-	if (mem_cgroup_below_min(memcg) ||
-	    (mem_cgroup_below_low(memcg) && !sc->memcg_low_reclaim))
+	if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg) ||
+	    (mem_cgroup_below_low(sc->target_mem_cgroup, memcg) &&
+	     !sc->memcg_low_reclaim))
 		return 0;
 
 	*need_aging = should_run_aging(lruvec, max_seq, min_seq, sc, can_swap, &nr_to_scan);
@@ -6096,13 +6097,13 @@ static void shrink_node_memcgs(pg_data_t
 
 		mem_cgroup_calculate_protection(target_memcg, memcg);
 
-		if (mem_cgroup_below_min(memcg)) {
+		if (mem_cgroup_below_min(target_memcg, memcg)) {
 			/*
 			 * Hard protection.
 			 * If there is no reclaimable memory, OOM.
 			 */
 			continue;
-		} else if (mem_cgroup_below_low(memcg)) {
+		} else if (mem_cgroup_below_low(target_memcg, memcg)) {
 			/*
 			 * Soft protection.
 			 * Respect the protection only as long as
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-fix-stale-protection-of-reclaim-target-memcg.patch
selftests-cgroup-refactor-proactive-reclaim-code-to-reclaim_until.patch
selftests-cgroup-make-sure-reclaim-target-memcg-is-unprotected.patch

