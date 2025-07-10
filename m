Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519002905
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126191; cv=none; b=c0JxyiUdJIopLd5dRYRkQ/ob0VYMKAegUT5tOKKW8h6GfUfabt3OqrMx0ZUU84mAf70xqDI0w7DFfSuxo+Q6cbEcgzjvQ6dS0Rp/a3bPIBmMDUXxdKhaejhYINITn4ojp5It2ecV/oKIi8NXPWwO1KiMEjrM2+sxbiS6rOisLu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126191; c=relaxed/simple;
	bh=XQ/JVoaOXtO4/ZgSCtIE+3V1aJFevZ2DDC30Ucu71PY=;
	h=Date:To:From:Subject:Message-Id; b=SqSGUzf55IONT2gW4QWZUYlTLVOMrwT2Rs7gA3mqJWumW1h1wZb5zYA4nozIRGNeMLPKhf9fp7BlFu55qawQXbZPwHwIguvrGj5xcQCW/vSXnBQ2Jfb1bTlZCIMCMIS13Ef3uMhSy3gUnw0IcDQ+/EFNsgZZw78Oi6o5DZA9z50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yLCdfqlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yLCdfqlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16531C4CEE3;
	Thu, 10 Jul 2025 05:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126191;
	bh=XQ/JVoaOXtO4/ZgSCtIE+3V1aJFevZ2DDC30Ucu71PY=;
	h=Date:To:From:Subject:From;
	b=yLCdfqlZSLPQTa3igviG434Ow8kccR7oR67waCfe+mqx/vPQMm2uy1VFOeXOfG3SZ
	 RFKawqiFEjH8Q/HLWtjEDgnqwcrl5KOcddpvv4Ryfjk28roAdmsTCDJ/H0juzArYXW
	 V5OjsxOyl103Ge09kh2w09BtXq07UJ3dGV/+4fxw=
Date: Wed, 09 Jul 2025 22:43:10 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,axelrasmussen@google.com,koichiro.den@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-apply-proportional-reclaim-pressure-for-memcg-when-mglru-is-enabled.patch removed from -mm tree
Message-Id: <20250710054311.16531C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: apply proportional reclaim pressure for memcg when MGLRU is enabled
has been removed from the -mm tree.  Its filename was
     mm-vmscan-apply-proportional-reclaim-pressure-for-memcg-when-mglru-is-enabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Koichiro Den <koichiro.den@canonical.com>
Subject: mm: vmscan: apply proportional reclaim pressure for memcg when MGLRU is enabled
Date: Sat, 31 May 2025 01:23:53 +0900

The scan implementation for MGLRU was missing proportional reclaim
pressure for memcg, which contradicts the description in
Documentation/admin-guide/cgroup-v2.rst (memory.{low,min} section).

This issue can be observed in kselftest cgroup:test_memcontrol
(specifically test_memcg_min and test_memcg_low).  The following table
shows the actual values observed in my local test env (on xfs) and the
error "e", which is the symmetric absolute percentage error from the ideal
values of 29M for c[0] and 21M for c[1].

  test_memcg_min

         | MGLRU enabled   | MGLRU enabled   | MGLRU disabled
         | Without patch   | With patch      |
    -----|-----------------|-----------------|---------------
    c[0] | 25964544 (e=8%) | 28770304 (e=3%) | 27820032 (e=4%)
    c[1] | 26214400 (e=9%) | 23998464 (e=4%) | 24776704 (e=6%)

  test_memcg_low

         | MGLRU enabled   | MGLRU enabled   | MGLRU disabled
         | Without patch   | With patch      |
    -----|-----------------|-----------------|---------------
    c[0] | 26214400 (e=7%) | 27930624 (e=4%) | 27688960 (e=5%)
    c[1] | 26214400 (e=9%) | 24764416 (e=6%) | 24920064 (e=6%)

Factor out the proportioning logic to a new function and have MGLRU reuse
it.  While at it, update the eviction behavior via debugfs 'lru_gen'
interface ('-' command with an explicit 'nr_to_reclaim' parameter) to
ensure eviction is limited to the specified number.

Link: https://lkml.kernel.org/r/20250530162353.541882-1-den@valinux.co.jp
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Reviewed-by: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |  149 ++++++++++++++++++++++++++------------------------
 1 file changed, 79 insertions(+), 70 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-apply-proportional-reclaim-pressure-for-memcg-when-mglru-is-enabled
+++ a/mm/vmscan.c
@@ -2482,6 +2482,69 @@ static inline void calculate_pressure_ba
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
@@ -2560,70 +2623,10 @@ out:
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
@@ -4554,8 +4557,9 @@ static bool isolate_folio(struct lruvec
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
@@ -4564,7 +4568,7 @@ static int scan_folios(struct lruvec *lr
 	int scanned = 0;
 	int isolated = 0;
 	int skipped = 0;
-	int remaining = MAX_LRU_BATCH;
+	int remaining = min(nr_to_scan, MAX_LRU_BATCH);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
@@ -4675,7 +4679,8 @@ static int get_type_to_scan(struct lruve
 	return positive_ctrl_err(&sp, &pv);
 }
 
-static int isolate_folios(struct lruvec *lruvec, struct scan_control *sc, int swappiness,
+static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
+			  struct scan_control *sc, int swappiness,
 			  int *type_scanned, struct list_head *list)
 {
 	int i;
@@ -4687,7 +4692,7 @@ static int isolate_folios(struct lruvec
 
 		*type_scanned = type;
 
-		scanned = scan_folios(lruvec, sc, type, tier, list);
+		scanned = scan_folios(nr_to_scan, lruvec, sc, type, tier, list);
 		if (scanned)
 			return scanned;
 
@@ -4697,7 +4702,8 @@ static int isolate_folios(struct lruvec
 	return 0;
 }
 
-static int evict_folios(struct lruvec *lruvec, struct scan_control *sc, int swappiness)
+static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
+			struct scan_control *sc, int swappiness)
 {
 	int type;
 	int scanned;
@@ -4716,7 +4722,7 @@ static int evict_folios(struct lruvec *l
 
 	spin_lock_irq(&lruvec->lru_lock);
 
-	scanned = isolate_folios(lruvec, sc, swappiness, &type, &list);
+	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list);
 
 	scanned += try_to_inc_min_seq(lruvec, swappiness);
 
@@ -4837,6 +4843,8 @@ static long get_nr_to_scan(struct lruvec
 	if (nr_to_scan && !mem_cgroup_online(memcg))
 		return nr_to_scan;
 
+	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
+
 	/* try to get away with not aging at the default priority */
 	if (!success || sc->priority == DEF_PRIORITY)
 		return nr_to_scan >> sc->priority;
@@ -4889,7 +4897,7 @@ static bool try_to_shrink_lruvec(struct
 		if (nr_to_scan <= 0)
 			break;
 
-		delta = evict_folios(lruvec, sc, swappiness);
+		delta = evict_folios(nr_to_scan, lruvec, sc, swappiness);
 		if (!delta)
 			break;
 
@@ -5510,7 +5518,8 @@ static int run_eviction(struct lruvec *l
 		if (sc->nr_reclaimed >= nr_to_reclaim)
 			return 0;
 
-		if (!evict_folios(lruvec, sc, swappiness))
+		if (!evict_folios(nr_to_reclaim - sc->nr_reclaimed, lruvec, sc,
+				  swappiness))
 			return 0;
 
 		cond_resched();
_

Patches currently in -mm which might be from koichiro.den@canonical.com are


