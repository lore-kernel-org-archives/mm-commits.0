Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479D81103;
	Fri, 28 Jun 2024 00:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719533078; cv=none; b=ZL6JRrWC3IbXaFUUeLcy6Re3r95revKz6aCUxk0H+mwI0uKiLD43Cuzxg3CT3rJwg+LvVf6F6++TGn9Hg+1BFn/58wcTz0Eh8mkkohUoQPCk66wm59y3qf3QgD0wDO0e15ly6Lz/T88Z3lZMzZjHLrCyWNZlSsL6+nBcy2/WA/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719533078; c=relaxed/simple;
	bh=zjYz4DHNKIxOpYwECB8XIpUQl3n0gmbAknDVHY8tVy4=;
	h=Date:To:From:Subject:Message-Id; b=uTbTprWQ/ovA5mXSz8Mp4/qydCnjzA2Scy8AApB+bCReDD2qsKNtTeaEXz05yvUqbnKwhpvbT7aavoU72l6u7G7119rmVLFIc7Pwkjt4/HyE7749Ro1QkKGIlGmaVOeQe6lyX3Fl+zrR9uTSUum4hbc8/daFVxs802HheV6zDwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PsOyJL8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PsOyJL8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C017DC2BBFC;
	Fri, 28 Jun 2024 00:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719533077;
	bh=zjYz4DHNKIxOpYwECB8XIpUQl3n0gmbAknDVHY8tVy4=;
	h=Date:To:From:Subject:From;
	b=PsOyJL8FeyWNLyDUf+MUXqObrpN/VIBaxERgiK8GCUoWXumSl/Uvw++5x3W1D2nMb
	 gzH3LQYCSnnaTz5c9V6Xh3Ixc9f2DWczg0diKgLuG9bpuDHeOhbS7xGhAlJMW9EdoX
	 O4YBaxfmbeAvWgIBk8T75fPjy3dmk1lrICEGuL08=
Date: Thu, 27 Jun 2024 17:04:37 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shli@kernel.org,david@redhat.com,baolin.wang@linux.alibaba.com,alex.shi@linux.alibaba.com,yangge1116@126.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch.patch removed from -mm tree
Message-Id: <20240628000437.C017DC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: clear the LRU flag of a page before adding to LRU batch
has been removed from the -mm tree.  Its filename was
     mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: yangge <yangge1116@126.com>
Subject: mm/gup: clear the LRU flag of a page before adding to LRU batch
Date: Sat, 22 Jun 2024 14:48:04 +0800

If a large number of CMA memory are configured in system (for example, the
CMA memory accounts for 50% of the system memory), starting a virtual
machine, it will call pin_user_pages_remote(..., FOLL_LONGTERM, ...) to
pin memory.  Normally if a page is present and in CMA area,
pin_user_pages_remote() will migrate the page from CMA area to non-CMA
area because of FOLL_LONGTERM flag.  But the current code will cause the
migration failure due to unexpected page refcounts, and eventually cause
the virtual machine fail to start.

If a page is added in LRU batch, its refcount increases one, remove the
page from LRU batch decreases one.  Page migration requires the page is
not referenced by others except page mapping.  Before migrating a page, we
should try to drain the page from LRU batch in case the page is in it,
however, folio_test_lru() is not sufficient to tell whether the page is in
LRU batch or not, if the page is in LRU batch, the migration will fail.

To solve the problem above, we modify the logic of adding to LRU batch. 
Before adding a page to LRU batch, we clear the LRU flag of the page so
that we can check whether the page is in LRU batch by
folio_test_lru(page).  Seems making the LRU flag of the page invisible a
long time is no problem, because a new page is allocated from buddy and
added to the lru batch, its LRU flag is also not visible for a long time.

Link: https://lkml.kernel.org/r/1719038884-1903-1-git-send-email-yangge1116@126.com
Signed-off-by: yangge <yangge1116@126.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

--- a/mm/swap.c~mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch
+++ a/mm/swap.c
@@ -212,10 +212,6 @@ static void folio_batch_move_lru(struct
 	for (i = 0; i < folio_batch_count(fbatch); i++) {
 		struct folio *folio = fbatch->folios[i];
 
-		/* block memcg migration while the folio moves between lru */
-		if (move_fn != lru_add_fn && !folio_test_clear_lru(folio))
-			continue;
-
 		folio_lruvec_relock_irqsave(folio, &lruvec, &flags);
 		move_fn(lruvec, folio);
 
@@ -256,11 +252,16 @@ static void lru_move_tail_fn(struct lruv
 void folio_rotate_reclaimable(struct folio *folio)
 {
 	if (!folio_test_locked(folio) && !folio_test_dirty(folio) &&
-	    !folio_test_unevictable(folio) && folio_test_lru(folio)) {
+	    !folio_test_unevictable(folio)) {
 		struct folio_batch *fbatch;
 		unsigned long flags;
 
 		folio_get(folio);
+		if (!folio_test_clear_lru(folio)) {
+			folio_put(folio);
+			return;
+		}
+
 		local_lock_irqsave(&lru_rotate.lock, flags);
 		fbatch = this_cpu_ptr(&lru_rotate.fbatch);
 		folio_batch_add_and_move(fbatch, folio, lru_move_tail_fn);
@@ -353,11 +354,15 @@ static void folio_activate_drain(int cpu
 
 void folio_activate(struct folio *folio)
 {
-	if (folio_test_lru(folio) && !folio_test_active(folio) &&
-	    !folio_test_unevictable(folio)) {
+	if (!folio_test_active(folio) && !folio_test_unevictable(folio)) {
 		struct folio_batch *fbatch;
 
 		folio_get(folio);
+		if (!folio_test_clear_lru(folio)) {
+			folio_put(folio);
+			return;
+		}
+
 		local_lock(&cpu_fbatches.lock);
 		fbatch = this_cpu_ptr(&cpu_fbatches.activate);
 		folio_batch_add_and_move(fbatch, folio, folio_activate_fn);
@@ -701,6 +706,11 @@ void deactivate_file_folio(struct folio
 		return;
 
 	folio_get(folio);
+	if (!folio_test_clear_lru(folio)) {
+		folio_put(folio);
+		return;
+	}
+
 	local_lock(&cpu_fbatches.lock);
 	fbatch = this_cpu_ptr(&cpu_fbatches.lru_deactivate_file);
 	folio_batch_add_and_move(fbatch, folio, lru_deactivate_file_fn);
@@ -717,11 +727,16 @@ void deactivate_file_folio(struct folio
  */
 void folio_deactivate(struct folio *folio)
 {
-	if (folio_test_lru(folio) && !folio_test_unevictable(folio) &&
-	    (folio_test_active(folio) || lru_gen_enabled())) {
+	if (!folio_test_unevictable(folio) && (folio_test_active(folio) ||
+	    lru_gen_enabled())) {
 		struct folio_batch *fbatch;
 
 		folio_get(folio);
+		if (!folio_test_clear_lru(folio)) {
+			folio_put(folio);
+			return;
+		}
+
 		local_lock(&cpu_fbatches.lock);
 		fbatch = this_cpu_ptr(&cpu_fbatches.lru_deactivate);
 		folio_batch_add_and_move(fbatch, folio, lru_deactivate_fn);
@@ -738,12 +753,16 @@ void folio_deactivate(struct folio *foli
  */
 void folio_mark_lazyfree(struct folio *folio)
 {
-	if (folio_test_lru(folio) && folio_test_anon(folio) &&
-	    folio_test_swapbacked(folio) && !folio_test_swapcache(folio) &&
-	    !folio_test_unevictable(folio)) {
+	if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
+	    !folio_test_swapcache(folio) && !folio_test_unevictable(folio)) {
 		struct folio_batch *fbatch;
 
 		folio_get(folio);
+		if (!folio_test_clear_lru(folio)) {
+			folio_put(folio);
+			return;
+		}
+
 		local_lock(&cpu_fbatches.lock);
 		fbatch = this_cpu_ptr(&cpu_fbatches.lru_lazyfree);
 		folio_batch_add_and_move(fbatch, folio, lru_lazyfree_fn);
_

Patches currently in -mm which might be from yangge1116@126.com are


