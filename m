Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C660D54F81
	for <mm-commits@vger.kernel.org>; Mon, 14 Jul 2025 22:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752533287; cv=none; b=cXEUVe4nPq6zwqPC3PyZ39H8jnBmQ02TF8pTUi5BQtt4nJV7tv51TMFl2+jduffHT1pGpANXcnLlNPEaoTvnRylLwZfPS9p/v9Bn2/rcJwq9OyzqHgc/KSrjAs9cEi5VF/AuIvxd3HCYnmrVxO57qYnJi5qidyUQnuplYo8FT6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752533287; c=relaxed/simple;
	bh=0E0x8gHkcI0gQo49ecHk82m+3J8vLzL5epUBsPnhmrc=;
	h=Date:To:From:Subject:Message-Id; b=d+hc77QXO7l55yDJROAJLTKGko5/rwwMVOTGkXWiHSg2Sq5ryHayzJpTBoDp1YvZJiM3isKTsOfmBLRtaEoVHKGl2MXl8JGDZKRvruUv2eDw53LoEeuFoUlaNarJsFLOl7S1u/y4NrQswCLHtttquVfBuOOjBRZf/KP1m/n/PXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N+1Yf8UI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N+1Yf8UI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284D8C4CEED;
	Mon, 14 Jul 2025 22:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752533287;
	bh=0E0x8gHkcI0gQo49ecHk82m+3J8vLzL5epUBsPnhmrc=;
	h=Date:To:From:Subject:From;
	b=N+1Yf8UI+C1ZXRgmsBjXZPzayHh89l92DqOaR3p92jWCsW0Jmh1G9rWjzUl+lJGoW
	 ADG8I7s8RJ6bRT4bcQvxVLg+VlF1sXkSp8JtgQG+0A3D8kDeUsmEXlmvAX3jXW0GfT
	 7GTVLPEriuvuAZMkIB0eIerZRkVtp1thLSpEwBgY=
Date: Mon, 14 Jul 2025 15:48:06 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq.patch added to mm-new branch
Message-Id: <20250714224807.284D8C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: optimize lru_note_cost() by adding lru_note_cost_unlock_irq()
has been added to the -mm mm-new branch.  Its filename is
     mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Hugh Dickins <hughd@google.com>
Subject: mm: optimize lru_note_cost() by adding lru_note_cost_unlock_irq()
Date: Sun, 13 Jul 2025 12:57:18 -0700 (PDT)

Dropping a lock, just to demand it again for an afterthought, cannot be
good if contended: convert lru_note_cost() to lru_note_cost_unlock_irq().

Link: https://lkml.kernel.org/r/21100102-51b6-79d5-03db-1bb7f97fa94c@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Tested-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 +++--
 mm/swap.c            |   26 +++++++++++++++++++-------
 mm/vmscan.c          |    8 +++-----
 3 files changed, 25 insertions(+), 14 deletions(-)

--- a/include/linux/swap.h~mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq
+++ a/include/linux/swap.h
@@ -376,8 +376,9 @@ extern unsigned long totalreserve_pages;
 
 
 /* linux/mm/swap.c */
-void lru_note_cost(struct lruvec *lruvec, bool file,
-		   unsigned int nr_io, unsigned int nr_rotated);
+void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
+		unsigned int nr_io, unsigned int nr_rotated)
+		__releases(lruvec->lru_lock);
 void lru_note_cost_refault(struct folio *);
 void folio_add_lru(struct folio *);
 void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
--- a/mm/swap.c~mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq
+++ a/mm/swap.c
@@ -237,8 +237,9 @@ void folio_rotate_reclaimable(struct fol
 	folio_batch_add_and_move(folio, lru_move_tail, true);
 }
 
-void lru_note_cost(struct lruvec *lruvec, bool file,
-		   unsigned int nr_io, unsigned int nr_rotated)
+void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
+		unsigned int nr_io, unsigned int nr_rotated)
+		__releases(lruvec->lru_lock)
 {
 	unsigned long cost;
 
@@ -250,8 +251,12 @@ void lru_note_cost(struct lruvec *lruvec
 	 * different between them, adjust scan balance for CPU work.
 	 */
 	cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated;
+	if (!cost) {
+		spin_unlock_irq(&lruvec->lru_lock);
+		return;
+	}
 
-	do {
+	for (;;) {
 		unsigned long lrusize;
 
 		/*
@@ -261,7 +266,6 @@ void lru_note_cost(struct lruvec *lruvec
 		 *    rcu lock, so would be safe even if the page was on the LRU
 		 *    and could move simultaneously to a new lruvec).
 		 */
-		spin_lock_irq(&lruvec->lru_lock);
 		/* Record cost event */
 		if (file)
 			lruvec->file_cost += cost;
@@ -285,14 +289,22 @@ void lru_note_cost(struct lruvec *lruvec
 			lruvec->file_cost /= 2;
 			lruvec->anon_cost /= 2;
 		}
+
 		spin_unlock_irq(&lruvec->lru_lock);
-	} while ((lruvec = parent_lruvec(lruvec)));
+		lruvec = parent_lruvec(lruvec);
+		if (!lruvec)
+			break;
+		spin_lock_irq(&lruvec->lru_lock);
+	}
 }
 
 void lru_note_cost_refault(struct folio *folio)
 {
-	lru_note_cost(folio_lruvec(folio), folio_is_file_lru(folio),
-		      folio_nr_pages(folio), 0);
+	struct lruvec *lruvec;
+
+	lruvec = folio_lruvec_lock_irq(folio);
+	lru_note_cost_unlock_irq(lruvec, folio_is_file_lru(folio),
+				folio_nr_pages(folio), 0);
 }
 
 static void lru_activate(struct lruvec *lruvec, struct folio *folio)
--- a/mm/vmscan.c~mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq
+++ a/mm/vmscan.c
@@ -2061,9 +2061,9 @@ static unsigned long shrink_inactive_lis
 		__count_vm_events(item, nr_reclaimed);
 	count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
 	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
-	spin_unlock_irq(&lruvec->lru_lock);
 
-	lru_note_cost(lruvec, file, stat.nr_pageout, nr_scanned - nr_reclaimed);
+	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
+					nr_scanned - nr_reclaimed);
 
 	/*
 	 * If dirty folios are scanned that are not queued for IO, it
@@ -2209,10 +2209,8 @@ static void shrink_active_list(unsigned
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
 
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
-	spin_unlock_irq(&lruvec->lru_lock);
 
-	if (nr_rotated)
-		lru_note_cost(lruvec, file, 0, nr_rotated);
+	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
 			nr_deactivate, nr_rotated, sc->priority, file);
 }
_

Patches currently in -mm which might be from hughd@google.com are

mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq.patch

