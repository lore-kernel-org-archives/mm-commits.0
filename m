Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54B12040A8
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409656; cv=none; b=eZASQvTcEH+ftGj93K+HjjpagMXORQomvVt1Fr6fgESyhfgzoLBE9YrU4y64aqSDkycqTR7h2nBhzWJk3CdtmaKbCJlKypu0OgIjwIyTa5rPaLyn1dDL884vuhOD9r//WzA2hQR09Zuod11sJZ9VMYPPRz1UFNb/Jfq4I6+JU38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409656; c=relaxed/simple;
	bh=XDUpEykFdLF7g6FpAC3PN1K4J+37KMDD1TR4LnR0vJ4=;
	h=Date:To:From:Subject:Message-Id; b=XeRiRLzkB8K62KGspYD0B9daA+mMOcp6bHOjayZAWyR3CDl7K1BzIEZwHMpSEKO59EjMrFsA3nBtJIVoBHADO4ks0GhLS/EqLveoarXP5/ipmYAVAhEe2iErHrBJkjqUNJU/kVsvAYsQKD7qNruXLGWuJatv9zBMZqY4y7jgrfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gdRhQvbC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gdRhQvbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21679C4CEED;
	Fri, 25 Jul 2025 02:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409656;
	bh=XDUpEykFdLF7g6FpAC3PN1K4J+37KMDD1TR4LnR0vJ4=;
	h=Date:To:From:Subject:From;
	b=gdRhQvbCLkx+8g2RbtpKpU6E+5pzVmnmM2oapDeyOWrkEf8Vhq/37D3LijYFM9wl+
	 B13P7GNEo835GYfQY1IchhyrHvzIcvEnS+aX36EJneaxuLTJiRhY5vedyRXAAntMhZ
	 G0NIkcnyJr/+uh/Z4DFGiSGnXwiV3+tVG17QftqE=
Date: Thu, 24 Jul 2025 19:14:15 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq.patch removed from -mm tree
Message-Id: <20250725021416.21679C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: optimize lru_note_cost() by adding lru_note_cost_unlock_irq()
has been removed from the -mm tree.  Its filename was
     mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: optimize lru_note_cost() by adding lru_note_cost_unlock_irq()
Date: Sun, 13 Jul 2025 12:57:18 -0700 (PDT)

Dropping a lock, just to demand it again for an afterthought, cannot be
good if contended: convert lru_note_cost() to lru_note_cost_unlock_irq().

[hughd@google.com: delete unneeded comment]
  Link: https://lkml.kernel.org/r/dbf9352a-1ed9-a021-c0c7-9309ac73e174@google.com
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
 mm/swap.c            |   33 +++++++++++++++++++--------------
 mm/vmscan.c          |    8 +++-----
 3 files changed, 25 insertions(+), 21 deletions(-)

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
 
@@ -250,18 +251,14 @@ void lru_note_cost(struct lruvec *lruvec
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
 
-		/*
-		 * Hold lruvec->lru_lock is safe here, since
-		 * 1) The pinned lruvec in reclaim, or
-		 * 2) From a pre-LRU page during refault (which also holds the
-		 *    rcu lock, so would be safe even if the page was on the LRU
-		 *    and could move simultaneously to a new lruvec).
-		 */
-		spin_lock_irq(&lruvec->lru_lock);
 		/* Record cost event */
 		if (file)
 			lruvec->file_cost += cost;
@@ -285,14 +282,22 @@ void lru_note_cost(struct lruvec *lruvec
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
@@ -2053,9 +2053,9 @@ static unsigned long shrink_inactive_lis
 		__count_vm_events(item, nr_reclaimed);
 	count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
 	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
-	spin_unlock_irq(&lruvec->lru_lock);
 
-	lru_note_cost(lruvec, file, stat.nr_pageout, nr_scanned - nr_reclaimed);
+	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
+					nr_scanned - nr_reclaimed);
 
 	/*
 	 * If dirty folios are scanned that are not queued for IO, it
@@ -2201,10 +2201,8 @@ static void shrink_active_list(unsigned
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


