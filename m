Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF083D9048
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 18:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777314198; cv=none; b=HcVIl5yTib1aC51Nt0NstYw2kG3hPenwlad/D6pbuO9PjQgsFodjvPJu/5TF8ievko1OsBHtFJ59Geup8pOimn7DuzuPLe00TeqnBOG/RSqUMqq8YomA3MlPG/8fsmugWMeYKdffyu8AkAPpune0B2IKdyOOdysCW5+kk3myGao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777314198; c=relaxed/simple;
	bh=7yK4hQfbzvtrX0kUNi8fjoGffbgmey6hPLydVKd1fE0=;
	h=Date:To:From:Subject:Message-Id; b=IPb7V9BXyq2bjAhV286ZiH1AkAwE2hzaGUTr+0gac4AZ3X1xdZLqAopVokZcc79y5gnnUPGFkv0P5yDdbTiEV4MIKpEYSuNrCHlVMN663Y00slTjxN/xJbiS2ggvFSOxhC00wjEHd+i5POn7WoEyXPJgxRPo21eeGENegpBiAvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YueUXT5C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YueUXT5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC3DC19425;
	Mon, 27 Apr 2026 18:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777314197;
	bh=7yK4hQfbzvtrX0kUNi8fjoGffbgmey6hPLydVKd1fE0=;
	h=Date:To:From:Subject:From;
	b=YueUXT5CmDBJaTx7DgJyCS1HcMphwgxG0HQmQ8nlOmSt0hKg9HHMWTBXXoGshfXrz
	 Qi4qlKO19bFXn3kEHId0yMyvufwSQ8oskQLEE9anSqvPpJpF0X2XGHGfeixXjX2MQs
	 xipin7vABIXFrqlBnef37AJAR5Pzx+F9Rjk7HHoo=
Date: Mon, 27 Apr 2026 11:23:17 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-scan-and-count-the-exact-number-of-folios.patch added to mm-new branch
Message-Id: <20260427182317.DCC3DC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: scan and count the exact number of folios
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-scan-and-count-the-exact-number-of-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-scan-and-count-the-exact-number-of-folios.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: scan and count the exact number of folios
Date: Tue, 28 Apr 2026 02:06:56 +0800

Make the scan helpers return the exact number of folios being scanned or
isolated.  Since the reclaim loop now has a natural scan budget that
controls the scan progress, returning the scan number and consuming the
budget makes the scan more accurate and easier to follow.

The number of scanned folios for each iteration is always larger than 0,
unless the reclaim must stop for a forced aging, so there is no more need
for any special handling when there is no progress made:

- `return isolated || !remaining ?  scanned : 0` in scan_folios: both
  the function and the call now just return the exact scan count, combined
  with the scan budget introduced in the previous commit to avoid livelock
  or under scan.

- `scanned += try_to_inc_min_seq` in evict_folios: adding a bool as a
  scan count was kind of confusing and no longer needed, as scan number
  should never be zero as long as there are still evictable gens.  We may
  encounter a empty old gen that returns 0 scan count, to avoid that, do a
  try_to_inc_min_seq before toisolation which have slight to none overhead
  in most cases.

- `evictable_min_seq + MIN_NR_GENS > max_seq` guard in evict_folios: the
  per-type get_nr_gens == MIN_NR_GENS check in scan_folios naturally
  returns 0 when only two gens remain and breaks the loop.

Also change try_to_inc_min_seq to return void, as its return value is no
longer used by any caller.  Call it before isolate_folios to flush any
empty gens left by external folio freeing, and again after isolate_folios
when scanning moved or protected folios may have emptied the oldest gen.

The scan still stops if only two gens are left, as the scan number will be
zero.  This matches the previous behavior.  This forced gen protection may
be removed or softened later to improve reclaim further.

Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-5-02fabb92dc43@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Leno Hou <lenohou@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   58 +++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

--- a/mm/vmscan.c~mm-mglru-scan-and-count-the-exact-number-of-folios
+++ a/mm/vmscan.c
@@ -3878,10 +3878,9 @@ done:
 	return true;
 }
 
-static bool try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
+static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 {
 	int gen, type, zone;
-	bool success = false;
 	bool seq_inc_flag = false;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MIN_SEQ(lruvec);
@@ -3907,11 +3906,10 @@ next:
 
 	/*
 	 * If min_seq[type] of both anonymous and file is not increased,
-	 * we can directly return false to avoid unnecessary checking
-	 * overhead later.
+	 * return here to avoid unnecessary checking overhead later.
 	 */
 	if (!seq_inc_flag)
-		return success;
+		return;
 
 	/* see the comment on lru_gen_folio */
 	if (swappiness && swappiness <= MAX_SWAPPINESS) {
@@ -3929,10 +3927,7 @@ next:
 
 		reset_ctrl_pos(lruvec, type, true);
 		WRITE_ONCE(lrugen->min_seq[type], min_seq[type]);
-		success = true;
 	}
-
-	return success;
 }
 
 static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness)
@@ -4686,7 +4681,7 @@ static bool isolate_folio(struct lruvec
 
 static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct scan_control *sc, int type, int tier,
-		       struct list_head *list)
+		       struct list_head *list, int *isolatedp)
 {
 	int i;
 	int gen;
@@ -4756,11 +4751,9 @@ static int scan_folios(unsigned long nr_
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 	if (type == LRU_GEN_FILE)
 		sc->nr.file_taken += isolated;
-	/*
-	 * There might not be eligible folios due to reclaim_idx. Check the
-	 * remaining to prevent livelock if it's not making progress.
-	 */
-	return isolated || !remaining ? scanned : 0;
+
+	*isolatedp = isolated;
+	return scanned;
 }
 
 static int get_tier_idx(struct lruvec *lruvec, int type)
@@ -4804,33 +4797,36 @@ static int get_type_to_scan(struct lruve
 
 static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			  struct scan_control *sc, int swappiness,
-			  int *type_scanned, struct list_head *list)
+			  struct list_head *list, int *isolated,
+			  int *isolate_type, int *isolate_scanned)
 {
 	int i;
+	int total_scanned = 0;
 	int type = get_type_to_scan(lruvec, swappiness);
 
 	for_each_evictable_type(i, swappiness) {
 		int scanned;
 		int tier = get_tier_idx(lruvec, type);
 
-		*type_scanned = type;
+		scanned = scan_folios(nr_to_scan, lruvec, sc,
+				      type, tier, list, isolated);
 
-		scanned = scan_folios(nr_to_scan, lruvec, sc, type, tier, list);
-		if (scanned)
-			return scanned;
+		total_scanned += scanned;
+		if (*isolated) {
+			*isolate_type = type;
+			*isolate_scanned = scanned;
+			break;
+		}
 
 		type = !type;
 	}
 
-	return 0;
+	return total_scanned;
 }
 
 static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			struct scan_control *sc, int swappiness)
 {
-	int type;
-	int scanned;
-	int reclaimed;
 	LIST_HEAD(list);
 	LIST_HEAD(clean);
 	struct folio *folio;
@@ -4838,19 +4834,23 @@ static int evict_folios(unsigned long nr
 	enum node_stat_item item;
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
+	int scanned, reclaimed;
+	int isolated = 0, type, type_scanned;
 	bool skip_retry = false;
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
 	lruvec_lock_irq(lruvec);
 
-	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list);
+	/* In case folio deletion left empty old gens, flush them */
+	try_to_inc_min_seq(lruvec, swappiness);
 
-	scanned += try_to_inc_min_seq(lruvec, swappiness);
+	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
+				 &list, &isolated, &type, &type_scanned);
 
-	if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS > lrugen->max_seq)
-		scanned = 0;
+	/* Scanning may have emptied the oldest gen, flush it */
+	if (scanned)
+		try_to_inc_min_seq(lruvec, swappiness);
 
 	lruvec_unlock_irq(lruvec);
 
@@ -4861,7 +4861,7 @@ retry:
 	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr_reclaimed += reclaimed;
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
-			scanned, reclaimed, &stat, sc->priority,
+			type_scanned, reclaimed, &stat, sc->priority,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-consolidate-common-code-for-retrieving-evictable-size.patch
mm-mglru-rename-variables-related-to-aging-and-rotation.patch
mm-mglru-relocate-the-lru-scan-batch-limit-to-callers.patch
mm-mglru-restructure-the-reclaim-loop.patch
mm-mglru-scan-and-count-the-exact-number-of-folios.patch
mm-mglru-use-a-smaller-batch-for-reclaim.patch
mm-mglru-dont-abort-scan-immediately-right-after-aging.patch
mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch
mm-mglru-use-the-common-routine-for-dirty-writeback-reactivation.patch
mm-mglru-simplify-and-improve-dirty-writeback-handling.patch
mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch
mm-vmscan-remove-sc-file_taken.patch
mm-vmscan-remove-sc-unqueued_dirty.patch
mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch

