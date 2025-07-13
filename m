Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF660219A9B
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450086; cv=none; b=kgOrgoBjOJ2ed3MJzAFYQUTucEcEzKlql/mpCbwOw5VmqiIrsYK0Jm45HP4YKwbSQaCNEDWXTmhqbvV8LfSmNCm82GGAFHtEsIPiSQAxtV9RO+kBTca/J+hfSsEOQIFbCvjwTxBpN8p1MHM+Q838BH7E2UWWjaucwj5y/YP/2Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450086; c=relaxed/simple;
	bh=Yc9TIoPLImvXL/vkCkMSRAIsbw7ycplHMg1nOnvNTvM=;
	h=Date:To:From:Subject:Message-Id; b=q6xNgb5mMc4rj6rXXPCt5zER4rFw6wfWhxyZsotKwJHD4uhWtWOfoByTs112SMFEGDIxL+DPe9FEZNUJMloGyfD/yCjVWf+EVv8v0XRvOa1EdyPovEObIcpmzcufCJMeAFC2AuqoOKb+DWi03eijyZCX8XJYknScTdiCX3mIIEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rQE24Qip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rQE24Qip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C6EC4CEE3;
	Sun, 13 Jul 2025 23:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450086;
	bh=Yc9TIoPLImvXL/vkCkMSRAIsbw7ycplHMg1nOnvNTvM=;
	h=Date:To:From:Subject:From;
	b=rQE24QipRls9ua8Ny7ZfLQljvjw7mavw+gWKh5srm+PckAJoBUgsx59FauWOWavbc
	 hvTZsjoLhbIVUY/+HtCcncFyE6PRmMJQ5UilOz8efAS/fLQqCAoTW70XqaDy9RiwwC
	 M0yFwihx4XDciggg+sZHBccLPdKWwFxApWD7wIwU=
Date: Sun, 13 Jul 2025 16:41:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,xuanzhuo@linux.alibaba.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,senozhatsky@chromium.org,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,nao.horiguchi@gmail.com,mst@redhat.com,mpe@ellerman.id.au,minchan@kernel.org,mhocko@suse.com,matthew.brost@intel.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,jgg@ziepe.ca,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,jack@suse.cz,jackmanb@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,gourry@gourry.net,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chengming.zhou@linux.dev,byungchul@sk.com,brauner@kernel.org,arnd@arndb.de,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-__folio_test_movable.patch removed from -mm tree
Message-Id: <20250713234126.99C6EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove __folio_test_movable()
has been removed from the -mm tree.  Its filename was
     mm-remove-__folio_test_movable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: remove __folio_test_movable()
Date: Fri, 4 Jul 2025 12:25:12 +0200

Convert to page_has_movable_ops().  While at it, cleanup relevant code a
bit.

The data_race() in migrate_folio_unmap() is questionable: we already hold
a page reference, and concurrent modifications can no longer happen (iow:
__ClearPageMovable() no longer exists).  Drop it for now, we'll rework
page_has_movable_ops() soon either way to no longer rely on page->mapping.

Wherever we cast from folio to page now is a clear sign that this code has
to be decoupled.

Link: https://lkml.kernel.org/r/20250704102524.326966-19-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Eugenio Pé rez <eperezma@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    6 ----
 mm/migrate.c               |   43 ++++++++++-------------------------
 mm/vmscan.c                |    6 +++-
 3 files changed, 17 insertions(+), 38 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-__folio_test_movable
+++ a/include/linux/page-flags.h
@@ -744,12 +744,6 @@ static __always_inline bool PageAnon(con
 	return folio_test_anon(page_folio(page));
 }
 
-static __always_inline bool __folio_test_movable(const struct folio *folio)
-{
-	return ((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS) ==
-			PAGE_MAPPING_MOVABLE;
-}
-
 static __always_inline bool page_has_movable_ops(const struct page *page)
 {
 	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) ==
--- a/mm/migrate.c~mm-remove-__folio_test_movable
+++ a/mm/migrate.c
@@ -221,12 +221,7 @@ void putback_movable_pages(struct list_h
 			continue;
 		}
 		list_del(&folio->lru);
-		/*
-		 * We isolated non-lru movable folio so here we can use
-		 * __folio_test_movable because LRU folio's mapping cannot
-		 * have PAGE_MAPPING_MOVABLE.
-		 */
-		if (unlikely(__folio_test_movable(folio))) {
+		if (unlikely(page_has_movable_ops(&folio->page))) {
 			putback_movable_ops_page(&folio->page);
 		} else {
 			node_stat_mod_folio(folio, NR_ISOLATED_ANON +
@@ -239,26 +234,20 @@ void putback_movable_pages(struct list_h
 /* Must be called with an elevated refcount on the non-hugetlb folio */
 bool isolate_folio_to_list(struct folio *folio, struct list_head *list)
 {
-	bool isolated, lru;
-
 	if (folio_test_hugetlb(folio))
 		return folio_isolate_hugetlb(folio, list);
 
-	lru = !__folio_test_movable(folio);
-	if (lru)
-		isolated = folio_isolate_lru(folio);
-	else
-		isolated = isolate_movable_ops_page(&folio->page,
-						    ISOLATE_UNEVICTABLE);
-
-	if (!isolated)
-		return false;
-
-	list_add(&folio->lru, list);
-	if (lru)
+	if (page_has_movable_ops(&folio->page)) {
+		if (!isolate_movable_ops_page(&folio->page,
+					      ISOLATE_UNEVICTABLE))
+			return false;
+	} else {
+		if (!folio_isolate_lru(folio))
+			return false;
 		node_stat_add_folio(folio, NR_ISOLATED_ANON +
 				    folio_is_file_lru(folio));
-
+	}
+	list_add(&folio->lru, list);
 	return true;
 }
 
@@ -1142,12 +1131,7 @@ static void migrate_folio_undo_dst(struc
 static void migrate_folio_done(struct folio *src,
 			       enum migrate_reason reason)
 {
-	/*
-	 * Compaction can migrate also non-LRU pages which are
-	 * not accounted to NR_ISOLATED_*. They can be recognized
-	 * as __folio_test_movable
-	 */
-	if (likely(!__folio_test_movable(src)) && reason != MR_DEMOTION)
+	if (likely(!page_has_movable_ops(&src->page)) && reason != MR_DEMOTION)
 		mod_node_page_state(folio_pgdat(src), NR_ISOLATED_ANON +
 				    folio_is_file_lru(src), -folio_nr_pages(src));
 
@@ -1166,7 +1150,6 @@ static int migrate_folio_unmap(new_folio
 	int rc = -EAGAIN;
 	int old_page_state = 0;
 	struct anon_vma *anon_vma = NULL;
-	bool is_lru = data_race(!__folio_test_movable(src));
 	bool locked = false;
 	bool dst_locked = false;
 
@@ -1267,7 +1250,7 @@ static int migrate_folio_unmap(new_folio
 		goto out;
 	dst_locked = true;
 
-	if (unlikely(!is_lru)) {
+	if (unlikely(page_has_movable_ops(&src->page))) {
 		__migrate_folio_record(dst, old_page_state, anon_vma);
 		return MIGRATEPAGE_UNMAP;
 	}
@@ -1332,7 +1315,7 @@ static int migrate_folio_move(free_folio
 	prev = dst->lru.prev;
 	list_del(&dst->lru);
 
-	if (unlikely(__folio_test_movable(src))) {
+	if (unlikely(page_has_movable_ops(&src->page))) {
 		rc = migrate_movable_ops_page(&dst->page, &src->page, mode);
 		if (rc)
 			goto out;
--- a/mm/vmscan.c~mm-remove-__folio_test_movable
+++ a/mm/vmscan.c
@@ -1651,9 +1651,11 @@ unsigned int reclaim_clean_pages_from_li
 	unsigned int noreclaim_flag;
 
 	list_for_each_entry_safe(folio, next, folio_list, lru) {
+		/* TODO: these pages should not even appear in this list. */
+		if (page_has_movable_ops(&folio->page))
+			continue;
 		if (!folio_test_hugetlb(folio) && folio_is_file_lru(folio) &&
-		    !folio_test_dirty(folio) && !__folio_test_movable(folio) &&
-		    !folio_test_unevictable(folio)) {
+		    !folio_test_dirty(folio) && !folio_test_unevictable(folio)) {
 			folio_clear_active(folio);
 			list_move(&folio->lru, &clean_folios);
 		}
_

Patches currently in -mm which might be from david@redhat.com are

mm-convert-fpb_ignore_-into-fpb_respect_.patch
mm-smaller-folio_pte_batch-improvements.patch
mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags.patch
mm-remove-boolean-output-parameters-from-folio_pte_batch_ext.patch
mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch

