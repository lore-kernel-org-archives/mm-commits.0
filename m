Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5523625634
	for <mm-commits@vger.kernel.org>; Sun,  6 Apr 2025 22:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743978392; cv=none; b=QP+lVZNMQaH57oBpHXsNRgpE1dsONkF6pIj1U7DP8IritvhWHdFe6cF6SJUYb8eb+Z12bCNTn56VQSD8xf5rhbVnj7p6bhtU8ixctyo1XJZpuT9UJscP/tt/6KSOUl+KLPEKFNUbJ8PdvoR4Ipra9vd2qiaMVbhYeo2uPwDmXGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743978392; c=relaxed/simple;
	bh=ysGWJ8bDsAjhicvHF2k/8mb7/Mq5v/s9OxfLkxWuj4g=;
	h=Date:To:From:Subject:Message-Id; b=CnkoYGm7vKn4HhE3jCjtfauHuFr6yrfM39Al3HwcenKCOCTGQEbydNT7hcAgrP8z0c+ypgPc4kimABIlULnRPxhV3awcF/GteC5Md9X1v08HK8SCQqshwfQ9bryF2UG9pf8qhZPoYRVccqqoDIdglhWEfdpjtWNQKpGoyC24HrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cf4e9g2m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cf4e9g2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4A1C4CEE3;
	Sun,  6 Apr 2025 22:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743978390;
	bh=ysGWJ8bDsAjhicvHF2k/8mb7/Mq5v/s9OxfLkxWuj4g=;
	h=Date:To:From:Subject:From;
	b=cf4e9g2mhz8SsBR7Gol9tJKRcNyx48tQ7lBPcwo2y47Vd+xJk+xY90589q4MqD6Br
	 h7W1ScH6KQWIYbwML2jaMu/Nk7Z0Z3z/u3rqh+qeqXzgVdQlWVs/w2SR+M7gAhBbxg
	 CGpWpjWiUGV+wXBpV9t0f0YZQCSDCOki7aOU6Btk=
Date: Sun, 06 Apr 2025 15:26:29 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,koichiro.den@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-apply-proportional-reclaim-pressure-for-memcg-when-mglru-is-enabled.patch added to mm-new branch
Message-Id: <20250406222630.9A4A1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: apply proportional reclaim pressure for memcg when MGLRU is enabled
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-apply-proportional-reclaim-pressure-for-memcg-when-mglru-is-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-apply-proportional-reclaim-pressure-for-memcg-when-mglru-is-enabled.patch

This patch will later appear in the mm-new branch at
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
From: Koichiro Den <koichiro.den@canonical.com>
Subject: mm: vmscan: apply proportional reclaim pressure for memcg when MGLRU is enabled
Date: Fri, 4 Apr 2025 23:11:18 +0900

The scan implementation for MGLRU was missing proportional reclaim
pressure for memcg, which contradicts the description in
Documentation/admin-guide/cgroup-v2.rst (memory.{low,min} section).

This issue was revealed by the LTP memcontrol03 [1] test case.  The
following example output from a local test env with no NUMA shows that
prior to this patch, proportional protection was not working:

* Without this patch (MGLRU enabled):
  $ sudo LTP_SINGLE_FS_TYPE=xfs ./memcontrol03
    ...
    memcontrol03.c:214: TPASS: Expect: (A/B/C memory.current=25964544) ~= 34603008
    memcontrol03.c:216: TPASS: Expect: (A/B/D memory.current=26038272) ~= 17825792
    ...

* With this patch (MGLRU enabled):
  $ sudo LTP_SINGLE_FS_TYPE=xfs ./memcontrol03
    ...
    memcontrol03.c:214: TPASS: Expect: (A/B/C memory.current=29327360) ~= 34603008
    memcontrol03.c:216: TPASS: Expect: (A/B/D memory.current=23748608) ~= 17825792
    ...

* When MGLRU is disabled:
  $ sudo LTP_SINGLE_FS_TYPE=xfs ./memcontrol03
    ...
    memcontrol03.c:214: TPASS: Expect: (A/B/C memory.current=28819456) ~= 34603008
    memcontrol03.c:216: TPASS: Expect: (A/B/D memory.current=24018944) ~= 17825792
    ...

Note that the test shows TPASS for all cases here due to its lenient
criteria. And even with this patch, or when MGLRU is disabled, the
results above show slight deviation from the expected values, but this
is due to relatively small mem usage compared to the >> DEF_PRIORITY
adjustment.

Factor out the proportioning logic to a new function and have MGLRU
reuse it.

Link: https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/controllers/memcg/memcontrol03.c [1]
Link: https://lkml.kernel.org/r/20250404141118.3895592-1-koichiro.den@canonical.com
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |  148 ++++++++++++++++++++++++++------------------------
 1 file changed, 78 insertions(+), 70 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-apply-proportional-reclaim-pressure-for-memcg-when-mglru-is-enabled
+++ a/mm/vmscan.c
@@ -2491,6 +2491,69 @@ static inline void calculate_pressure_ba
 	*denominator = ap + fp;
 }
 
+static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
+		struct scan_control *sc, unsigned long scan)
+{
+	unsigned long min, low;
+
+	mem_cgroup_protection(sc->target_mem_cgroup, memcg, &min, &low);
+
+	if (min || low) {
+		/*
+		 * Scale a cgroup's reclaim pressure by proportioning
+		 * its current usage to its memory.low or memory.min
+		 * setting.
+		 *
+		 * This is important, as otherwise scanning aggression
+		 * becomes extremely binary -- from nothing as we
+		 * approach the memory protection threshold, to totally
+		 * nominal as we exceed it.  This results in requiring
+		 * setting extremely liberal protection thresholds. It
+		 * also means we simply get no protection at all if we
+		 * set it too low, which is not ideal.
+		 *
+		 * If there is any protection in place, we reduce scan
+		 * pressure by how much of the total memory used is
+		 * within protection thresholds.
+		 *
+		 * There is one special case: in the first reclaim pass,
+		 * we skip over all groups that are within their low
+		 * protection. If that fails to reclaim enough pages to
+		 * satisfy the reclaim goal, we come back and override
+		 * the best-effort low protection. However, we still
+		 * ideally want to honor how well-behaved groups are in
+		 * that case instead of simply punishing them all
+		 * equally. As such, we reclaim them based on how much
+		 * memory they are using, reducing the scan pressure
+		 * again by how much of the total memory used is under
+		 * hard protection.
+		 */
+		unsigned long cgroup_size = mem_cgroup_size(memcg);
+		unsigned long protection;
+
+		/* memory.low scaling, make sure we retry before OOM */
+		if (!sc->memcg_low_reclaim && low > min) {
+			protection = low;
+			sc->memcg_low_skipped = 1;
+		} else {
+			protection = min;
+		}
+
+		/* Avoid TOCTOU with earlier protection check */
+		cgroup_size = max(cgroup_size, protection);
+
+		scan -= scan * protection / (cgroup_size + 1);
+
+		/*
+		 * Minimally target SWAP_CLUSTER_MAX pages to keep
+		 * reclaim moving forwards, avoiding decrementing
+		 * sc->priority further than desirable.
+		 */
+		scan = max(scan, SWAP_CLUSTER_MAX);
+	}
+	return scan;
+}
+
 /*
  * Determine how aggressively the anon and file LRU lists should be
  * scanned.
@@ -2561,70 +2624,10 @@ out:
 	for_each_evictable_lru(lru) {
 		bool file = is_file_lru(lru);
 		unsigned long lruvec_size;
-		unsigned long low, min;
 		unsigned long scan;
 
 		lruvec_size = lruvec_lru_size(lruvec, lru, sc->reclaim_idx);
-		mem_cgroup_protection(sc->target_mem_cgroup, memcg,
-				      &min, &low);
-
-		if (min || low) {
-			/*
-			 * Scale a cgroup's reclaim pressure by proportioning
-			 * its current usage to its memory.low or memory.min
-			 * setting.
-			 *
-			 * This is important, as otherwise scanning aggression
-			 * becomes extremely binary -- from nothing as we
-			 * approach the memory protection threshold, to totally
-			 * nominal as we exceed it.  This results in requiring
-			 * setting extremely liberal protection thresholds. It
-			 * also means we simply get no protection at all if we
-			 * set it too low, which is not ideal.
-			 *
-			 * If there is any protection in place, we reduce scan
-			 * pressure by how much of the total memory used is
-			 * within protection thresholds.
-			 *
-			 * There is one special case: in the first reclaim pass,
-			 * we skip over all groups that are within their low
-			 * protection. If that fails to reclaim enough pages to
-			 * satisfy the reclaim goal, we come back and override
-			 * the best-effort low protection. However, we still
-			 * ideally want to honor how well-behaved groups are in
-			 * that case instead of simply punishing them all
-			 * equally. As such, we reclaim them based on how much
-			 * memory they are using, reducing the scan pressure
-			 * again by how much of the total memory used is under
-			 * hard protection.
-			 */
-			unsigned long cgroup_size = mem_cgroup_size(memcg);
-			unsigned long protection;
-
-			/* memory.low scaling, make sure we retry before OOM */
-			if (!sc->memcg_low_reclaim && low > min) {
-				protection = low;
-				sc->memcg_low_skipped = 1;
-			} else {
-				protection = min;
-			}
-
-			/* Avoid TOCTOU with earlier protection check */
-			cgroup_size = max(cgroup_size, protection);
-
-			scan = lruvec_size - lruvec_size * protection /
-				(cgroup_size + 1);
-
-			/*
-			 * Minimally target SWAP_CLUSTER_MAX pages to keep
-			 * reclaim moving forwards, avoiding decrementing
-			 * sc->priority further than desirable.
-			 */
-			scan = max(scan, SWAP_CLUSTER_MAX);
-		} else {
-			scan = lruvec_size;
-		}
-
+		scan = apply_proportional_protection(memcg, sc, lruvec_size);
 		scan >>= sc->priority;
 
 		/*
@@ -4545,8 +4548,9 @@ static bool isolate_folio(struct lruvec
 	return true;
 }
 
-static int scan_folios(struct lruvec *lruvec, struct scan_control *sc,
-		       int type, int tier, struct list_head *list)
+static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
+		       struct scan_control *sc, int type, int tier,
+		       struct list_head *list)
 {
 	int i;
 	int gen;
@@ -4555,7 +4559,7 @@ static int scan_folios(struct lruvec *lr
 	int scanned = 0;
 	int isolated = 0;
 	int skipped = 0;
-	int remaining = MAX_LRU_BATCH;
+	int remaining = min(nr_to_scan, MAX_LRU_BATCH);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
@@ -4666,7 +4670,8 @@ static int get_type_to_scan(struct lruve
 	return positive_ctrl_err(&sp, &pv);
 }
 
-static int isolate_folios(struct lruvec *lruvec, struct scan_control *sc, int swappiness,
+static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
+			  struct scan_control *sc, int swappiness,
 			  int *type_scanned, struct list_head *list)
 {
 	int i;
@@ -4678,7 +4683,7 @@ static int isolate_folios(struct lruvec
 
 		*type_scanned = type;
 
-		scanned = scan_folios(lruvec, sc, type, tier, list);
+		scanned = scan_folios(nr_to_scan, lruvec, sc, type, tier, list);
 		if (scanned)
 			return scanned;
 
@@ -4688,7 +4693,8 @@ static int isolate_folios(struct lruvec
 	return 0;
 }
 
-static int evict_folios(struct lruvec *lruvec, struct scan_control *sc, int swappiness)
+static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
+			struct scan_control *sc, int swappiness)
 {
 	int type;
 	int scanned;
@@ -4707,7 +4713,7 @@ static int evict_folios(struct lruvec *l
 
 	spin_lock_irq(&lruvec->lru_lock);
 
-	scanned = isolate_folios(lruvec, sc, swappiness, &type, &list);
+	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list);
 
 	scanned += try_to_inc_min_seq(lruvec, swappiness);
 
@@ -4828,6 +4834,8 @@ static long get_nr_to_scan(struct lruvec
 	if (nr_to_scan && !mem_cgroup_online(memcg))
 		return nr_to_scan;
 
+	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
+
 	/* try to get away with not aging at the default priority */
 	if (!success || sc->priority == DEF_PRIORITY)
 		return nr_to_scan >> sc->priority;
@@ -4880,7 +4888,7 @@ static bool try_to_shrink_lruvec(struct
 		if (nr_to_scan <= 0)
 			break;
 
-		delta = evict_folios(lruvec, sc, swappiness);
+		delta = evict_folios(nr_to_scan, lruvec, sc, swappiness);
 		if (!delta)
 			break;
 
@@ -5501,7 +5509,7 @@ static int run_eviction(struct lruvec *l
 		if (sc->nr_reclaimed >= nr_to_reclaim)
 			return 0;
 
-		if (!evict_folios(lruvec, sc, swappiness))
+		if (!evict_folios(MAX_LRU_BATCH, lruvec, sc, swappiness))
 			return 0;
 
 		cond_resched();
_

Patches currently in -mm which might be from koichiro.den@canonical.com are

mm-vmscan-apply-proportional-reclaim-pressure-for-memcg-when-mglru-is-enabled.patch

