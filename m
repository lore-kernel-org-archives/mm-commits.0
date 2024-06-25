Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F9C13C9A2
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291562; cv=none; b=lRQ831W777jrdR9W9A6WHxnSpuUFIMKmpT84en2TAp+SM9dPjN1/ijEte9ie/MiSeQ4jOs6PMOO2Wuv4zADKM+Z27uonsfUy1ybsDl15g9rkcAoe6uJ27Qlt17jMvoKN5Bsrg5SAIqRncn0UZ0kYvZwKf3lz3+NIBs5EGhSYO5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291562; c=relaxed/simple;
	bh=Lw6bQn26ZV6X09VzKZVB4w6WGFaZTsw1tg6mHkrAuFk=;
	h=Date:To:From:Subject:Message-Id; b=BXhkpMQGFkEHizFQ3/lDIVnB8wcJXN9CLKqX2v9VCDnwTmT9IQdtuaGIcUdc2S7xJwLNIjUrzH88YkNZPhW8n1Kdnm4zWkF6fgDHqnPNE1E1gJ/g4rXhEHWs5BE8VOJk2M6qJrGC50Z94Vi689ebxCAMUNR1QBTwITvS1dHhABw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OgTjvwne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OgTjvwne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D70C32782;
	Tue, 25 Jun 2024 04:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291561;
	bh=Lw6bQn26ZV6X09VzKZVB4w6WGFaZTsw1tg6mHkrAuFk=;
	h=Date:To:From:Subject:From;
	b=OgTjvwne3vTyqTGZPPaDFC6Z1lEJdMfx+hOYp5K2pXz6ofStwBfhE0l3QdzmxbfLi
	 9IxrQqKYMTeF8qsCvsLef1YV8+Yh6ANpQuh/GybcqmQdJKZBxrjHsVney/mymf72DI
	 jCK6/roeUXM3u/CKwLzLoBqhtEq7XdiKWReiJwiY=
Date: Mon, 24 Jun 2024 21:59:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ioworker0@gmail.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-refactor-folio_undo_large_rmappable.patch removed from -mm tree
Message-Id: <20240625045921.D8D70C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: refactor folio_undo_large_rmappable()
has been removed from the -mm tree.  Its filename was
     mm-refactor-folio_undo_large_rmappable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: refactor folio_undo_large_rmappable()
Date: Tue, 21 May 2024 21:03:15 +0800

Folios of order <= 1 are not in deferred list, the check of order is added
into folio_undo_large_rmappable() from commit 8897277acfef ("mm: support
order-1 folios in the page cache"), but there is a repeated check for
small folio (order 0) during each call of the
folio_undo_large_rmappable(), so only keep folio_order() check inside the
function.

In addition, move all the checks into header file to save a function call
for non-large-rmappable or empty deferred_list folio.

Link: https://lkml.kernel.org/r/20240521130315.46072-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   13 +------------
 mm/internal.h    |   17 ++++++++++++++++-
 mm/memcontrol.c  |    3 +--
 mm/page_alloc.c  |    3 +--
 mm/swap.c        |    8 ++------
 mm/vmscan.c      |    8 ++------
 6 files changed, 23 insertions(+), 29 deletions(-)

--- a/mm/huge_memory.c~mm-refactor-folio_undo_large_rmappable
+++ a/mm/huge_memory.c
@@ -3188,22 +3188,11 @@ out:
 	return ret;
 }
 
-void folio_undo_large_rmappable(struct folio *folio)
+void __folio_undo_large_rmappable(struct folio *folio)
 {
 	struct deferred_split *ds_queue;
 	unsigned long flags;
 
-	if (folio_order(folio) <= 1)
-		return;
-
-	/*
-	 * At this point, there is no one trying to add the folio to
-	 * deferred_list. If folio is not in deferred_list, it's safe
-	 * to check without acquiring the split_queue_lock.
-	 */
-	if (data_race(list_empty(&folio->_deferred_list)))
-		return;
-
 	ds_queue = get_deferred_split_queue(folio);
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	if (!list_empty(&folio->_deferred_list)) {
--- a/mm/internal.h~mm-refactor-folio_undo_large_rmappable
+++ a/mm/internal.h
@@ -604,7 +604,22 @@ static inline void folio_set_order(struc
 #endif
 }
 
-void folio_undo_large_rmappable(struct folio *folio);
+void __folio_undo_large_rmappable(struct folio *folio);
+static inline void folio_undo_large_rmappable(struct folio *folio)
+{
+	if (folio_order(folio) <= 1 || !folio_test_large_rmappable(folio))
+		return;
+
+	/*
+	 * At this point, there is no one trying to add the folio to
+	 * deferred_list. If folio is not in deferred_list, it's safe
+	 * to check without acquiring the split_queue_lock.
+	 */
+	if (data_race(list_empty(&folio->_deferred_list)))
+		return;
+
+	__folio_undo_large_rmappable(folio);
+}
 
 static inline struct folio *page_rmappable_folio(struct page *page)
 {
--- a/mm/memcontrol.c~mm-refactor-folio_undo_large_rmappable
+++ a/mm/memcontrol.c
@@ -7832,8 +7832,7 @@ void mem_cgroup_migrate(struct folio *ol
 	 * In addition, the old folio is about to be freed after migration, so
 	 * removing from the split queue a bit earlier seems reasonable.
 	 */
-	if (folio_test_large(old) && folio_test_large_rmappable(old))
-		folio_undo_large_rmappable(old);
+	folio_undo_large_rmappable(old);
 	old->memcg_data = 0;
 }
 
--- a/mm/page_alloc.c~mm-refactor-folio_undo_large_rmappable
+++ a/mm/page_alloc.c
@@ -2627,8 +2627,7 @@ void free_unref_folios(struct folio_batc
 		unsigned long pfn = folio_pfn(folio);
 		unsigned int order = folio_order(folio);
 
-		if (order > 0 && folio_test_large_rmappable(folio))
-			folio_undo_large_rmappable(folio);
+		folio_undo_large_rmappable(folio);
 		if (!free_pages_prepare(&folio->page, order))
 			continue;
 		/*
--- a/mm/swap.c~mm-refactor-folio_undo_large_rmappable
+++ a/mm/swap.c
@@ -123,8 +123,7 @@ void __folio_put(struct folio *folio)
 	}
 
 	page_cache_release(folio);
-	if (folio_test_large(folio) && folio_test_large_rmappable(folio))
-		folio_undo_large_rmappable(folio);
+	folio_undo_large_rmappable(folio);
 	mem_cgroup_uncharge(folio);
 	free_unref_page(&folio->page, folio_order(folio));
 }
@@ -1002,10 +1001,7 @@ void folios_put_refs(struct folio_batch
 			free_huge_folio(folio);
 			continue;
 		}
-		if (folio_test_large(folio) &&
-		    folio_test_large_rmappable(folio))
-			folio_undo_large_rmappable(folio);
-
+		folio_undo_large_rmappable(folio);
 		__page_cache_release(folio, &lruvec, &flags);
 
 		if (j != i)
--- a/mm/vmscan.c~mm-refactor-folio_undo_large_rmappable
+++ a/mm/vmscan.c
@@ -1440,9 +1440,7 @@ free_it:
 		 */
 		nr_reclaimed += nr_pages;
 
-		if (folio_test_large(folio) &&
-		    folio_test_large_rmappable(folio))
-			folio_undo_large_rmappable(folio);
+		folio_undo_large_rmappable(folio);
 		if (folio_batch_add(&free_folios, folio) == 0) {
 			mem_cgroup_uncharge_folios(&free_folios);
 			try_to_unmap_flush();
@@ -1849,9 +1847,7 @@ static unsigned int move_folios_to_lru(s
 		if (unlikely(folio_put_testzero(folio))) {
 			__folio_clear_lru_flags(folio);
 
-			if (folio_test_large(folio) &&
-			    folio_test_large_rmappable(folio))
-				folio_undo_large_rmappable(folio);
+			folio_undo_large_rmappable(folio);
 			if (folio_batch_add(&free_folios, folio) == 0) {
 				spin_unlock_irq(&lruvec->lru_lock);
 				mem_cgroup_uncharge_folios(&free_folios);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
mm-remove-page_maybe_dma_pinned-fix.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch
mm-memory-convert-clear_huge_page-to-folio_zero_user.patch
mm-memory-use-folio-in-struct-copy_subpage_arg.patch
mm-memory-improve-copy_user_large_folio.patch
mm-memory-rename-pages_per_huge_page-to-nr_pages.patch

