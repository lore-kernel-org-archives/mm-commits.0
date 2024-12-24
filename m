Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B905442C
	for <mm-commits@vger.kernel.org>; Tue, 24 Dec 2024 00:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735001516; cv=none; b=gliwGfcZt3WC6nw3fGNkkadE9ltoNkXPtVkGy7CHPlzkr6z9ySoLwE8BczqvfUeN8D57ZriIkXN5RlmzehF/MCIldqK7XPeg/bpwkqcespBrM7YxXLnk5BMjdL77+Acxx2X0aoFcTpz4C/r3ekWWzfrDh2u6KKQjx08DKMZDTDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735001516; c=relaxed/simple;
	bh=rux2w8ROi2S1yvwmh0tc5SXWR71BvrHVQ2w6WVkAwg4=;
	h=Date:To:From:Subject:Message-Id; b=JXj9VxJFdvaSeas39Nvpep3qXTPz6c1g73Fe9EtHOgVD8mKE1EKBRbfga8p+Cy30x7syB+n/h29csWoBbTPgAQjioheii3rhOff2rP02XZrHyYyooFFo81iZ+z1vrmFnyHKAXl/iac764uInui7MFJ6oTOxQeRxE63XPL5HUFPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KqFiEyuk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KqFiEyuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BDAC4CED3;
	Tue, 24 Dec 2024 00:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735001516;
	bh=rux2w8ROi2S1yvwmh0tc5SXWR71BvrHVQ2w6WVkAwg4=;
	h=Date:To:From:Subject:From;
	b=KqFiEyukPPn7qPfEsvmj7j/rE58QJG0xtb8mC02DY+UhsI4oflVz1fhxT+wb/3OTL
	 jXgYC8Gcoue9c9mEyJjG7cGaYsq4hZ95lpw3X0DwkiEVvz8l9J4qOjqXyY1jOxgLhw
	 uFj4la4o5OnwuWOJlzynSEO/Orc00nMPQcyhNWRg=
Date: Mon, 23 Dec 2024 16:51:55 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,willy@infradead.org,wangweiyang2@huawei.com,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,mhocko@suse.com,hannes@cmpxchg.org,david@redhat.com,baohua@kernel.org,chenridong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-retry-folios-written-back-while-isolated-for-traditional-lru.patch added to mm-unstable branch
Message-Id: <20241224005156.41BDAC4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: retry folios written back while isolated for traditional LRU
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-retry-folios-written-back-while-isolated-for-traditional-lru.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-retry-folios-written-back-while-isolated-for-traditional-lru.patch

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
From: Chen Ridong <chenridong@huawei.com>
Subject: mm: vmscan: retry folios written back while isolated for traditional LRU
Date: Mon, 23 Dec 2024 08:20:04 +0000

The page reclaim isolates a batch of folios from the tail of one of the
LRU lists and works on those folios one by one.  For a suitable
swap-backed folio, if the swap device is async, it queues that folio for
writeback.  After the page reclaim finishes an entire batch, it puts back
the folios it queued for writeback to the head of the original LRU list.

In the meantime, the page writeback flushes the queued folios also by
batches.  Its batching logic is independent from that of the page reclaim.
For each of the folios it writes back, the page writeback calls
folio_rotate_reclaimable() which tries to rotate a folio to the tail.

folio_rotate_reclaimable() only works for a folio after the page reclaim
has put it back.  If an async swap device is fast enough, the page
writeback can finish with that folio while the page reclaim is still
working on the rest of the batch containing it.  In this case, that folio
will remain at the head and the page reclaim will not retry it before
reaching there.

The commit 359a5e1416ca ("mm: multi-gen LRU: retry folios written back
while isolated") only fixed the issue for mglru.  However, this issue also
exists in the traditional active/inactive LRU.  This issue will be worse
if THP is split, which makes the list longer and needs longer time to
finish a batch of folios reclaim.

This issue should be fixed in the same way for the traditional LRU. 
Therefore, the common logic was extracted to the
'find_folios_written_back' function firstly, which is then reused in the
'shrink_inactive_list' function.  Finally, retry reclaiming those folios
that may have missed the rotation for traditional LRU.

Link: https://lore.kernel.org/linux-kernel/20241010081802.290893-1-chenridong@huaweicloud.com/
Link: https://lore.kernel.org/linux-kernel/CAGsJ_4zqL8ZHNRZ44o_CC69kE7DBVXvbZfvmQxMGiFqRxqHQdA@mail.gmail.com/
Link: https://lkml.kernel.org/r/20241223082004.3759152-1-chenridong@huaweicloud.com
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wang Weiyang <wangweiyang2@huawei.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    5 +
 mm/vmscan.c               |  108 +++++++++++++++++++++++-------------
 2 files changed, 75 insertions(+), 38 deletions(-)

--- a/include/linux/mm_inline.h~mm-vmscan-retry-folios-written-back-while-isolated-for-traditional-lru
+++ a/include/linux/mm_inline.h
@@ -342,6 +342,11 @@ static inline void folio_migrate_refs(st
 {
 
 }
+
+static inline int lru_gen_distance(struct folio *folio, bool reclaiming)
+{
+	return -1;
+}
 #endif /* CONFIG_LRU_GEN */
 
 static __always_inline
--- a/mm/vmscan.c~mm-vmscan-retry-folios-written-back-while-isolated-for-traditional-lru
+++ a/mm/vmscan.c
@@ -283,6 +283,39 @@ static void set_task_reclaim_state(struc
 	task->reclaim_state = rs;
 }
 
+/**
+ * find_folios_written_back - Find and move the written back folios to a new list.
+ * @list: filios list
+ * @clean: the written back folios list
+ * @is_retrying: whether the list is retrying.
+ */
+static inline void find_folios_written_back(struct list_head *list,
+		struct list_head *clean, bool is_retrying)
+{
+	struct folio *folio;
+	struct folio *next;
+
+	list_for_each_entry_safe_reverse(folio, next, list, lru) {
+		if (!folio_evictable(folio)) {
+			list_del(&folio->lru);
+			folio_putback_lru(folio);
+			continue;
+		}
+
+		/* retry folios that may have missed folio_rotate_reclaimable() */
+		if (!is_retrying && !folio_test_active(folio) && !folio_mapped(folio) &&
+		    !folio_test_dirty(folio) && !folio_test_writeback(folio)) {
+			list_move(&folio->lru, clean);
+			continue;
+		}
+
+		/* don't add rejected folios to the oldest generation */
+		if (lru_gen_enabled() && !lru_gen_distance(folio, false))
+			set_mask_bits(&folio->flags, LRU_REFS_FLAGS, BIT(PG_active));
+	}
+
+}
+
 /*
  * flush_reclaim_state(): add pages reclaimed outside of LRU-based reclaim to
  * scan_control->nr_reclaimed.
@@ -1959,14 +1992,18 @@ static unsigned long shrink_inactive_lis
 		enum lru_list lru)
 {
 	LIST_HEAD(folio_list);
+	LIST_HEAD(clean_list);
 	unsigned long nr_scanned;
-	unsigned int nr_reclaimed = 0;
+	unsigned int nr_reclaimed, total_reclaimed = 0;
+	unsigned int nr_pageout = 0;
+	unsigned int nr_unqueued_dirty = 0;
 	unsigned long nr_taken;
 	struct reclaim_stat stat;
 	bool file = is_file_lru(lru);
 	enum vm_event_item item;
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	bool stalled = false;
+	bool is_retrying = false;
 
 	while (unlikely(too_many_isolated(pgdat, file, sc))) {
 		if (stalled)
@@ -2000,22 +2037,47 @@ static unsigned long shrink_inactive_lis
 	if (nr_taken == 0)
 		return 0;
 
+retry:
 	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false);
 
+	sc->nr.dirty += stat.nr_dirty;
+	sc->nr.congested += stat.nr_congested;
+	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
+	sc->nr.writeback += stat.nr_writeback;
+	sc->nr.immediate += stat.nr_immediate;
+	total_reclaimed += nr_reclaimed;
+	nr_pageout += stat.nr_pageout;
+	nr_unqueued_dirty += stat.nr_unqueued_dirty;
+
+	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
+			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
+
+	find_folios_written_back(&folio_list, &clean_list, is_retrying);
+
 	spin_lock_irq(&lruvec->lru_lock);
 	move_folios_to_lru(lruvec, &folio_list);
 
 	__mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(),
 					stat.nr_demoted);
-	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	item = PGSTEAL_KSWAPD + reclaimer_offset();
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, nr_reclaimed);
 	__count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
 	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
+
+	if (!list_empty(&clean_list)) {
+		list_splice_init(&clean_list, &folio_list);
+		is_retrying = true;
+		spin_unlock_irq(&lruvec->lru_lock);
+		goto retry;
+	}
+	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	spin_unlock_irq(&lruvec->lru_lock);
+	sc->nr.taken += nr_taken;
+	if (file)
+		sc->nr.file_taken += nr_taken;
 
-	lru_note_cost(lruvec, file, stat.nr_pageout, nr_scanned - nr_reclaimed);
+	lru_note_cost(lruvec, file, nr_pageout, nr_scanned - total_reclaimed);
 
 	/*
 	 * If dirty folios are scanned that are not queued for IO, it
@@ -2028,7 +2090,7 @@ static unsigned long shrink_inactive_lis
 	 * the flushers simply cannot keep up with the allocation
 	 * rate. Nudge the flusher threads in case they are asleep.
 	 */
-	if (stat.nr_unqueued_dirty == nr_taken) {
+	if (nr_unqueued_dirty == nr_taken) {
 		wakeup_flusher_threads(WB_REASON_VMSCAN);
 		/*
 		 * For cgroupv1 dirty throttling is achieved by waking up
@@ -2043,18 +2105,7 @@ static unsigned long shrink_inactive_lis
 			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
 	}
 
-	sc->nr.dirty += stat.nr_dirty;
-	sc->nr.congested += stat.nr_congested;
-	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
-	sc->nr.writeback += stat.nr_writeback;
-	sc->nr.immediate += stat.nr_immediate;
-	sc->nr.taken += nr_taken;
-	if (file)
-		sc->nr.file_taken += nr_taken;
-
-	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
-			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
-	return nr_reclaimed;
+	return total_reclaimed;
 }
 
 /*
@@ -4585,12 +4636,10 @@ static int evict_folios(struct lruvec *l
 	int reclaimed;
 	LIST_HEAD(list);
 	LIST_HEAD(clean);
-	struct folio *folio;
-	struct folio *next;
 	enum vm_event_item item;
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
-	bool skip_retry = false;
+	bool is_retrying = false;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -4616,24 +4665,7 @@ retry:
 			scanned, reclaimed, &stat, sc->priority,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
-	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
-		if (!folio_evictable(folio)) {
-			list_del(&folio->lru);
-			folio_putback_lru(folio);
-			continue;
-		}
-
-		/* retry folios that may have missed folio_rotate_reclaimable() */
-		if (!skip_retry && !folio_test_active(folio) && !folio_mapped(folio) &&
-		    !folio_test_dirty(folio) && !folio_test_writeback(folio)) {
-			list_move(&folio->lru, &clean);
-			continue;
-		}
-
-		/* don't add rejected folios to the oldest generation */
-		if (!lru_gen_distance(folio, false))
-			set_mask_bits(&folio->flags, LRU_REFS_FLAGS, BIT(PG_active));
-	}
+	find_folios_written_back(&list, &clean, is_retrying);
 
 	spin_lock_irq(&lruvec->lru_lock);
 
@@ -4656,7 +4688,7 @@ retry:
 	list_splice_init(&clean, &list);
 
 	if (!list_empty(&list)) {
-		skip_retry = true;
+		is_retrying = true;
 		goto retry;
 	}
 
_

Patches currently in -mm which might be from chenridong@huawei.com are

mm-vmscan-retry-folios-written-back-while-isolated-for-traditional-lru.patch

