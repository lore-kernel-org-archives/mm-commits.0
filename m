Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCA646521
	for <mm-commits@vger.kernel.org>; Tue, 21 May 2024 21:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716326722; cv=none; b=q5m5Ni3P3wEqPnkMVBUhUXPF3/T28IKj+DbXNd58oQdKzgLVd7QTk8tqn4Ng1W9S1BdFMz9occtH/fDe3382FZ7q6613ktJZCJDSb2ngg7A3L83Zt1kgLJt0U9dvl/B/qHSjCBrUjgMJUyTEhXeq3ce8WKD1YCVe3Z1/b5R/um0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716326722; c=relaxed/simple;
	bh=YZJOYhkwJeRKpi0wlVptCotzLsUAeP1homNrGyLIj7w=;
	h=Date:To:From:Subject:Message-Id; b=etQ/1nWPLXeAWuyMsqcygOIO7NTZzmGxtZYC1BIdTlBuow4W1eJNEj+AnNYqvPg5oI36lZjz+uttfKVttcJaQQJnRYTDWxRLghK+bZHOZe4TIs54XtLYmy8Z/2YtHSM3okjouheWeY4gSe30gG2dFH/pDdJ2sDCFt6OC/yOvsbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IR41gkLu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IR41gkLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09574C2BD11;
	Tue, 21 May 2024 21:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716326722;
	bh=YZJOYhkwJeRKpi0wlVptCotzLsUAeP1homNrGyLIj7w=;
	h=Date:To:From:Subject:From;
	b=IR41gkLuwy4KQqWSrNDppsYIzAZYFrDfxHTr4KGGgoBLoYkcDJkyyUidHC73TklAZ
	 beaMOjWbw7iRDyll61OEyTQdqO0Bq3sL9QJB6GQSz0flfW/tcaugTSh9Zwb3SxmDq7
	 RaqyQiZzavPKS/smK7JlkuydQ5b3AMPw+TGK3qFI=
Date: Tue, 21 May 2024 14:25:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ioworker0@gmail.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-refactor-folio_undo_large_rmappable.patch added to mm-unstable branch
Message-Id: <20240521212522.09574C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: refactor folio_undo_large_rmappable()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-refactor-folio_undo_large_rmappable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-refactor-folio_undo_large_rmappable.patch

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
@@ -3182,22 +3182,11 @@ out:
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
@@ -605,7 +605,22 @@ static inline void folio_set_order(struc
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
@@ -7835,8 +7835,7 @@ void mem_cgroup_migrate(struct folio *ol
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
@@ -2609,8 +2609,7 @@ void free_unref_folios(struct folio_batc
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

mm-add-folio_alloc_mpol.patch
mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch
mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch
mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch
mm-memcontrol-remove-page_memcg.patch
mm-refactor-folio_undo_large_rmappable.patch

