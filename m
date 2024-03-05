Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3340710A3C
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600573; cv=none; b=aehdvsiII2yU4jdwYHG6f1L6lON7FYt1hEpshFB5KbTiJTgifRAbF7Dn6tbsi2VRar3ovG3FzLZt2EdGhQugCl6MDoDFMQsa2lAVT5jZ2GUBRPtXzhmqemzX8xs1IBJKraj37lgTEP1WSYBlTkfIqWxB3uiEISw/7DI8JMbzK+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600573; c=relaxed/simple;
	bh=Wq+a5jfuTauEmY+Daf/8hKNsQdnXmPoCN3BhtNP708E=;
	h=Date:To:From:Subject:Message-Id; b=VB5nFbSXDdrwLPXdATmOJeVWrD9luCtPrSYNzVuRimtnKF4AMWBYG53Rr21DkzXchWQErw5SPoR7BHd6jfVkhz7iIM+WKav7lgw2ZyvhVRG+TzQo8gbVKnzFZpUuqyOxA+HNCmk4Ky5rMovcdDeEXJIiSWwJaBqJMNBhI9FS44I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h6QdIM3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h6QdIM3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3914C433F1;
	Tue,  5 Mar 2024 01:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600573;
	bh=Wq+a5jfuTauEmY+Daf/8hKNsQdnXmPoCN3BhtNP708E=;
	h=Date:To:From:Subject:From;
	b=h6QdIM3Wr+97k8RfoRIMVd8pz/RzgH99ZknbkiMtAIj8NYquGpwfGTUddeGjuKDHa
	 cOE1rWLHzLn2odIMRJGqVwRGw0JjPq0OD2bML2Ir+A7d4lsS8+RZvVosCv1yuzDjEk
	 c0X8lxZBKpmNWGRiejzVqkrNC2xF44Q7h7c5KMxE=
Date: Mon, 04 Mar 2024 17:02:52 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-free-folios-directly-in-move_folios_to_lru.patch removed from -mm tree
Message-Id: <20240305010252.F3914C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: free folios directly in move_folios_to_lru()
has been removed from the -mm tree.  Its filename was
     mm-free-folios-directly-in-move_folios_to_lru.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: free folios directly in move_folios_to_lru()
Date: Tue, 27 Feb 2024 17:42:46 +0000

The few folios which can't be moved to the LRU list (because their
refcount dropped to zero) used to be returned to the caller to dispose of.
Make this simpler to call by freeing the folios directly through
free_unref_folios().

Link: https://lkml.kernel.org/r/20240227174254.710559-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

--- a/mm/vmscan.c~mm-free-folios-directly-in-move_folios_to_lru
+++ a/mm/vmscan.c
@@ -1781,7 +1781,6 @@ static bool too_many_isolated(struct pgl
 
 /*
  * move_folios_to_lru() moves folios from private @list to appropriate LRU list.
- * On return, @list is reused as a list of folios to be freed by the caller.
  *
  * Returns the number of pages moved to the given lruvec.
  */
@@ -1789,8 +1788,9 @@ static unsigned int move_folios_to_lru(s
 		struct list_head *list)
 {
 	int nr_pages, nr_moved = 0;
-	LIST_HEAD(folios_to_free);
+	struct folio_batch free_folios;
 
+	folio_batch_init(&free_folios);
 	while (!list_empty(list)) {
 		struct folio *folio = lru_to_folio(list);
 
@@ -1819,12 +1819,12 @@ static unsigned int move_folios_to_lru(s
 		if (unlikely(folio_put_testzero(folio))) {
 			__folio_clear_lru_flags(folio);
 
-			if (unlikely(folio_test_large(folio))) {
+			if (folio_batch_add(&free_folios, folio) == 0) {
 				spin_unlock_irq(&lruvec->lru_lock);
-				destroy_large_folio(folio);
+				mem_cgroup_uncharge_folios(&free_folios);
+				free_unref_folios(&free_folios);
 				spin_lock_irq(&lruvec->lru_lock);
-			} else
-				list_add(&folio->lru, &folios_to_free);
+			}
 
 			continue;
 		}
@@ -1841,10 +1841,12 @@ static unsigned int move_folios_to_lru(s
 			workingset_age_nonresident(lruvec, nr_pages);
 	}
 
-	/*
-	 * To save our caller's stack, now use input list for pages to free.
-	 */
-	list_splice(&folios_to_free, list);
+	if (free_folios.nr) {
+		spin_unlock_irq(&lruvec->lru_lock);
+		mem_cgroup_uncharge_folios(&free_folios);
+		free_unref_folios(&free_folios);
+		spin_lock_irq(&lruvec->lru_lock);
+	}
 
 	return nr_moved;
 }
@@ -1923,8 +1925,6 @@ static unsigned long shrink_inactive_lis
 	spin_unlock_irq(&lruvec->lru_lock);
 
 	lru_note_cost(lruvec, file, stat.nr_pageout, nr_scanned - nr_reclaimed);
-	mem_cgroup_uncharge_list(&folio_list);
-	free_unref_page_list(&folio_list);
 
 	/*
 	 * If dirty folios are scanned that are not queued for IO, it
@@ -2065,8 +2065,6 @@ static void shrink_active_list(unsigned
 
 	nr_activate = move_folios_to_lru(lruvec, &l_active);
 	nr_deactivate = move_folios_to_lru(lruvec, &l_inactive);
-	/* Keep all free folios in l_active list */
-	list_splice(&l_inactive, &l_active);
 
 	__count_vm_events(PGDEACTIVATE, nr_deactivate);
 	__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
@@ -2076,8 +2074,6 @@ static void shrink_active_list(unsigned
 
 	if (nr_rotated)
 		lru_note_cost(lruvec, file, 0, nr_rotated);
-	mem_cgroup_uncharge_list(&l_active);
-	free_unref_page_list(&l_active);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
 			nr_deactivate, nr_rotated, sc->priority, file);
 }
@@ -4578,10 +4574,6 @@ retry:
 
 	spin_unlock_irq(&lruvec->lru_lock);
 
-	mem_cgroup_uncharge_list(&list);
-	free_unref_page_list(&list);
-
-	INIT_LIST_HEAD(&list);
 	list_splice_init(&clean, &list);
 
 	if (!list_empty(&list)) {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-add-__dump_folio-fix.patch
mm-add-__dump_folio-fix-2.patch
mm-add-__dump_folio-fix-3.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch
mm-mempolicy-use-a-folio-in-do_mbind.patch

