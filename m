Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE6C3C13EE
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439181; cv=none; b=sQCmjPZqSlcDuzeiUDh9zdLvSQXimb+HTDlW9nCAEGA7xEZnBvDzCrqJPlI15hmQ6HQ0ZBL+SE58sz9QoIjRWP+h6SWUH+M00xaPEnazqJCIjy9no3gyiixjPJu6TyOX4emmHRwiBix0/jLhPYU5NYAMC4fYAJO2cuUqaRUDbI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439181; c=relaxed/simple;
	bh=zt5VtZrfcES9hFTIzCR7mn87aT0YspjalgNUh29guVU=;
	h=Date:To:From:Subject:Message-Id; b=gWlm0bIfQZy+6JdjazPmxbwSeCFItPIPUbuMswVr9KuNXPB/uCr7kycvGA4RLOeXQdfnQj61BtgQQWZr0lzLKe0ro9MiZtDw4X9/PodF19PVVtg/potd9W1W0TTESrBvsPiQdQBjLi8ek9nD2G3F0E7vtyGUulf/9U4gJhMskXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mFa3bm8j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mFa3bm8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439A21F00893;
	Tue,  2 Jun 2026 22:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439180;
	bh=o/FDhKyjA54mTNKpg7G5Gsz1Cj9uPS4MXD4PAeKlFko=;
	h=Date:To:From:Subject;
	b=mFa3bm8jABofFhaXoUm+F2W2Iv5n0gs6b49TaQxHYQZri3QBfX8uFvEbVX9FflTzW
	 R7hBalkRxnbLlAAsMnNNHi4DTE5viTdSODD7jo94em8qlKw9ZRheKSEOawEbFmEoV+
	 qH6TZ6vUbmDgTNqZBQdRNJNNFH43YGbEhDuRUOCs=
Date: Tue, 02 Jun 2026 15:26:19 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vernon2gm@gmail.com,surenb@google.com,stevensd@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,lenohou@gmail.com,laoar.shao@gmail.com,kaleshsingh@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chenridong@huaweicloud.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-scan-and-count-the-exact-number-of-folios.patch removed from -mm tree
Message-Id: <20260602222620.439A21F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: scan and count the exact number of folios
has been removed from the -mm tree.  Its filename was
     mm-mglru-scan-and-count-the-exact-number-of-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3882,10 +3882,9 @@ done:
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
@@ -3911,11 +3910,10 @@ next:
 
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
@@ -3933,10 +3931,7 @@ next:
 
 		reset_ctrl_pos(lruvec, type, true);
 		WRITE_ONCE(lrugen->min_seq[type], min_seq[type]);
-		success = true;
 	}
-
-	return success;
 }
 
 static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness)
@@ -4690,7 +4685,7 @@ static bool isolate_folio(struct lruvec
 
 static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct scan_control *sc, int type, int tier,
-		       struct list_head *list)
+		       struct list_head *list, int *isolatedp)
 {
 	int i;
 	int gen;
@@ -4760,11 +4755,9 @@ static int scan_folios(unsigned long nr_
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
@@ -4808,33 +4801,36 @@ static int get_type_to_scan(struct lruve
 
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
@@ -4842,19 +4838,23 @@ static int evict_folios(unsigned long nr
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
 
@@ -4865,7 +4865,7 @@ retry:
 	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr_reclaimed += reclaimed;
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
-			scanned, reclaimed, &stat, sc->priority,
+			type_scanned, reclaimed, &stat, sc->priority,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
_

Patches currently in -mm which might be from kasong@tencent.com are


