Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18976C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 19:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8F2960EBD
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 19:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhHQTOO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Aug 2021 15:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229821AbhHQTOO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 17 Aug 2021 15:14:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A398860FC3;
        Tue, 17 Aug 2021 19:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629227620;
        bh=6q5bn0+rx20tGW5uexKc7nWXnbNklw5jLFt8lrcoYno=;
        h=Date:From:To:Subject:From;
        b=ApAVpI0LHzD5qNwCh99NPbgp/3uPRAXfnPbvRVUwv33J3Zi1L9SqL8S0Ra9zohux3
         oBsqeLE1ZzzJ9tCfh3N320jGK86Onfw4NktQfBCgC3rBWEsTq1V4zLekmZzDrSBmJc
         j24uTrp3lbRdsB2o0LwyEHtnoVQc6HKoXkHTCbPM=
Date:   Tue, 17 Aug 2021 12:13:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, riel@surriel.com, mhocko@suse.com,
        lnyng@fb.com, guro@fb.com, chris@chrisdown.name, hannes@cmpxchg.org
Subject:  +
 mm-memcontrol-fix-occasional-ooms-due-to-proportional-memorylow-reclaim.patch
 added to -mm tree
Message-ID: <20210817191340.4UzLQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix occasional OOMs due to proportional memory.low reclaim
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-occasional-ooms-due-to-proportional-memorylow-reclaim.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-occasional-ooms-due-to-proportional-memorylow-reclaim.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-occasional-ooms-due-to-proportional-memorylow-reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: fix occasional OOMs due to proportional memory.low reclaim

We've noticed occasional OOM killing when memory.low settings are in
effect for cgroups.  This is unexpected and undesirable as memory.low is
supposed to express non-OOMing memory priorities between cgroups.

The reason for this is proportional memory.low reclaim.  When cgroups are
below their memory.low threshold, reclaim passes them over in the first
round, and then retries if it couldn't find pages anywhere else.  But when
cgroups are slighly above their memory.low setting, page scan force is
scaled down and diminished in proportion to the overage, to the point
where it can cause reclaim to fail as well - only in that case we
currently don't retry, and instead trigger OOM.

To fix this, hook proportional reclaim into the same retry logic we have
in place for when cgroups are skipped entirely.  This way if reclaim fails
and some cgroups were scanned with dimished pressure, we'll try another
full-force cycle before giving up and OOMing.

Link: https://lkml.kernel.org/r/20210817180506.220056-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Leon Yang <lnyng@fb.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   29 +++++++++++++++--------------
 mm/vmscan.c                |   27 +++++++++++++++++++--------
 2 files changed, 34 insertions(+), 22 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-fix-occasional-ooms-due-to-proportional-memorylow-reclaim
+++ a/include/linux/memcontrol.h
@@ -612,12 +612,15 @@ static inline bool mem_cgroup_disabled(v
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
-static inline unsigned long mem_cgroup_protection(struct mem_cgroup *root,
-						  struct mem_cgroup *memcg,
-						  bool in_low_reclaim)
+static inline void mem_cgroup_protection(struct mem_cgroup *root,
+					 struct mem_cgroup *memcg,
+					 unsigned long *min,
+					 unsigned long *low)
 {
+	*min = *low = 0;
+
 	if (mem_cgroup_disabled())
-		return 0;
+		return;
 
 	/*
 	 * There is no reclaim protection applied to a targeted reclaim.
@@ -653,13 +656,10 @@ static inline unsigned long mem_cgroup_p
 	 *
 	 */
 	if (root == memcg)
-		return 0;
-
-	if (in_low_reclaim)
-		return READ_ONCE(memcg->memory.emin);
+		return;
 
-	return max(READ_ONCE(memcg->memory.emin),
-		   READ_ONCE(memcg->memory.elow));
+	*min = READ_ONCE(memcg->memory.emin);
+	*low = READ_ONCE(memcg->memory.elow);
 }
 
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
@@ -1147,11 +1147,12 @@ static inline void memcg_memory_event_mm
 {
 }
 
-static inline unsigned long mem_cgroup_protection(struct mem_cgroup *root,
-						  struct mem_cgroup *memcg,
-						  bool in_low_reclaim)
+static inline void mem_cgroup_protection(struct mem_cgroup *root,
+					 struct mem_cgroup *memcg,
+					 unsigned long *min,
+					 unsigned long *low)
 {
-	return 0;
+	*min = *low = 0;
 }
 
 static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
--- a/mm/vmscan.c~mm-memcontrol-fix-occasional-ooms-due-to-proportional-memorylow-reclaim
+++ a/mm/vmscan.c
@@ -100,9 +100,12 @@ struct scan_control {
 	unsigned int may_swap:1;
 
 	/*
-	 * Cgroups are not reclaimed below their configured memory.low,
-	 * unless we threaten to OOM. If any cgroups are skipped due to
-	 * memory.low and nothing was reclaimed, go back for memory.low.
+	 * Cgroup memory below memory.low is protected as long as we
+	 * don't threaten to OOM. If any cgroup is reclaimed at
+	 * reduced force or passed over entirely due to its memory.low
+	 * setting (memcg_low_skipped), and nothing is reclaimed as a
+	 * result, then go back back for one more cycle that reclaims
+	 * the protected memory (memcg_low_reclaim) to avert OOM.
 	 */
 	unsigned int memcg_low_reclaim:1;
 	unsigned int memcg_low_skipped:1;
@@ -2537,15 +2540,14 @@ out:
 	for_each_evictable_lru(lru) {
 		int file = is_file_lru(lru);
 		unsigned long lruvec_size;
+		unsigned long low, min;
 		unsigned long scan;
-		unsigned long protection;
 
 		lruvec_size = lruvec_lru_size(lruvec, lru, sc->reclaim_idx);
-		protection = mem_cgroup_protection(sc->target_mem_cgroup,
-						   memcg,
-						   sc->memcg_low_reclaim);
+		mem_cgroup_protection(sc->target_mem_cgroup, memcg,
+				      &min, &low);
 
-		if (protection) {
+		if (min || low) {
 			/*
 			 * Scale a cgroup's reclaim pressure by proportioning
 			 * its current usage to its memory.low or memory.min
@@ -2576,6 +2578,15 @@ out:
 			 * hard protection.
 			 */
 			unsigned long cgroup_size = mem_cgroup_size(memcg);
+			unsigned long protection;
+
+			/* memory.low scaling, make sure we retry before OOM */
+			if (!sc->memcg_low_reclaim && low > min) {
+				protection = low;
+				sc->memcg_low_skipped = 1;
+			} else {
+				protection = min;
+			}
 
 			/* Avoid TOCTOU with earlier protection check */
 			cgroup_size = max(cgroup_size, protection);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-fix-occasional-ooms-due-to-proportional-memorylow-reclaim.patch
mm-remove-irqsave-restore-locking-from-contexts-with-irqs-enabled.patch
fs-drop_caches-fix-skipping-over-shadow-cache-inodes.patch
fs-inode-count-invalidated-shadow-pages-in-pginodesteal.patch
vfs-keep-inodes-with-page-cache-off-the-inode-shrinker-lru.patch

