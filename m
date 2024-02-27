Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF0E5102E
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 18:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059686; cv=none; b=FztBnzAKXFYQfVF6/+hsIdqeG+w42ANYOLj4grOMbadlEJLvCXOAOJXA8/X2S0eothtQpCAyRusPAkfNrU2MP+5e+4cJLwn9flwZxacD96APlSXFYvGvRVpZ8OFtqA7EFYKPCzXMFVqt3TluJ0l+GNHuwUXgQ0mjoa21QORcYcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059686; c=relaxed/simple;
	bh=JsrRDNcSj/Ka7mPn8qd/oH9JGc0zRvhc0NX6eLCt7ug=;
	h=Date:To:From:Subject:Message-Id; b=V1e5cvvc9qJ1uoh+f14ifwCn1VFvaovwgAPjZaGW0ZOtWk7rWA6Ib6ngkjr007WInLKf3J19WH6V6xhdq0L4X8TR0IvOjsafWPMz0U/JJG1S8ryfRHi7G1Vsl+TffegtLkC62OmSt9K7XkqAgwGwTed9Q13W35d1WucgitlbITU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GKKvlbyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GKKvlbyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F172EC43390;
	Tue, 27 Feb 2024 18:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709059686;
	bh=JsrRDNcSj/Ka7mPn8qd/oH9JGc0zRvhc0NX6eLCt7ug=;
	h=Date:To:From:Subject:From;
	b=GKKvlbyU0rdPSMe4Ks7wog+yuiKiLT8RxgIYZDMZbRSyqol4EplOrje6ARCvZfZve
	 6wplbFu0JFKOO8xC0HVHrYm7lRDQ1pklQX6EjRrbbIjQ6/ich/QCOim1zGevB/FrlF
	 E0LclHhPTWt0mEp+WAnO+tNcVUBOs0NaJ2GonGOE=
Date: Tue, 27 Feb 2024 10:48:05 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-free-folios-directly-in-move_folios_to_lru.patch added to mm-unstable branch
Message-Id: <20240227184805.F172EC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: free folios directly in move_folios_to_lru()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-free-folios-directly-in-move_folios_to_lru.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-free-folios-directly-in-move_folios_to_lru.patch

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
@@ -1784,7 +1784,6 @@ static bool too_many_isolated(struct pgl
 
 /*
  * move_folios_to_lru() moves folios from private @list to appropriate LRU list.
- * On return, @list is reused as a list of folios to be freed by the caller.
  *
  * Returns the number of pages moved to the given lruvec.
  */
@@ -1792,8 +1791,9 @@ static unsigned int move_folios_to_lru(s
 		struct list_head *list)
 {
 	int nr_pages, nr_moved = 0;
-	LIST_HEAD(folios_to_free);
+	struct folio_batch free_folios;
 
+	folio_batch_init(&free_folios);
 	while (!list_empty(list)) {
 		struct folio *folio = lru_to_folio(list);
 
@@ -1822,12 +1822,12 @@ static unsigned int move_folios_to_lru(s
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
@@ -1844,10 +1844,12 @@ static unsigned int move_folios_to_lru(s
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
@@ -1926,8 +1928,6 @@ static unsigned long shrink_inactive_lis
 	spin_unlock_irq(&lruvec->lru_lock);
 
 	lru_note_cost(lruvec, file, stat.nr_pageout, nr_scanned - nr_reclaimed);
-	mem_cgroup_uncharge_list(&folio_list);
-	free_unref_page_list(&folio_list);
 
 	/*
 	 * If dirty folios are scanned that are not queued for IO, it
@@ -2068,8 +2068,6 @@ static void shrink_active_list(unsigned
 
 	nr_activate = move_folios_to_lru(lruvec, &l_active);
 	nr_deactivate = move_folios_to_lru(lruvec, &l_inactive);
-	/* Keep all free folios in l_active list */
-	list_splice(&l_inactive, &l_active);
 
 	__count_vm_events(PGDEACTIVATE, nr_deactivate);
 	__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
@@ -2079,8 +2077,6 @@ static void shrink_active_list(unsigned
 
 	if (nr_rotated)
 		lru_note_cost(lruvec, file, 0, nr_rotated);
-	mem_cgroup_uncharge_list(&l_active);
-	free_unref_page_list(&l_active);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
 			nr_deactivate, nr_rotated, sc->priority, file);
 }
@@ -4586,10 +4582,6 @@ retry:
 
 	spin_unlock_irq(&lruvec->lru_lock);
 
-	mem_cgroup_uncharge_list(&list);
-	free_unref_page_list(&list);
-
-	INIT_LIST_HEAD(&list);
 	list_splice_init(&clean, &list);
 
 	if (!list_empty(&list)) {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-support-order-1-folios-in-the-page-cache.patch
mm-make-folios_put-the-basis-of-release_pages.patch
mm-convert-free_unref_page_list-to-use-folios.patch
mm-add-free_unref_folios.patch
mm-use-folios_put-in-__folio_batch_release.patch
memcg-add-mem_cgroup_uncharge_folios.patch
mm-remove-use-of-folio-list-from-folios_put.patch
mm-use-free_unref_folios-in-put_pages_list.patch
mm-use-__page_cache_release-in-folios_put.patch
mm-handle-large-folios-in-free_unref_folios.patch
mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch
mm-free-folios-in-a-batch-in-shrink_folio_list.patch
mm-free-folios-directly-in-move_folios_to_lru.patch
memcg-remove-mem_cgroup_uncharge_list.patch
mm-remove-free_unref_page_list.patch
mm-remove-lru_to_page.patch
mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch
mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch
mm-convert-free_swap_cache-to-take-a-folio.patch

