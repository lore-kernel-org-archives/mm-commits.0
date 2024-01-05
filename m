Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05D13529C
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 18:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FENsgNl5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C793C433C7;
	Fri,  5 Jan 2024 18:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704478727;
	bh=MDdWlDUg3VAN7iNZ5OMynfaq+vvnZlIZTy+PU04wl58=;
	h=Date:To:From:Subject:From;
	b=FENsgNl5+RpR7v5TZrVUcXLZBWHn8n4cLLaDT3P+dT52wSLUlkXAIXjXpcRn/d9q6
	 WAoaQYHSiqbCXxEYI720IlhXcnljMsbmZSEss3dYxjc0r9Z0hkyxb9od5wilthq7yx
	 LGA7iHbPnebhvM1oJLLiQAiSObKUVjU2nISAG6z4=
Date: Fri, 05 Jan 2024 10:18:46 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,shakeelb@google.com,hannes@cmpxchg.org,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-remove-__mod_lruvec_page_state.patch removed from -mm tree
Message-Id: <20240105181847.5C793C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcontrol: remove __mod_lruvec_page_state()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-__mod_lruvec_page_state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/memcontrol: remove __mod_lruvec_page_state()
Date: Thu, 28 Dec 2023 08:57:48 +0000

There are no more callers of __mod_lruvec_page_state(), so convert the
implementation to __lruvec_stat_mod_folio(), removing two calls to
compound_head() (one explicit, one hidden inside page_memcg()).

Link: https://lkml.kernel.org/r/20231228085748.1083901-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |   36 ++++++++++++++++++------------------
 mm/memcontrol.c        |    9 ++++-----
 2 files changed, 22 insertions(+), 23 deletions(-)

--- a/include/linux/vmstat.h~mm-memcontrol-remove-__mod_lruvec_page_state
+++ a/include/linux/vmstat.h
@@ -556,19 +556,25 @@ static inline void mod_lruvec_state(stru
 	local_irq_restore(flags);
 }
 
-void __mod_lruvec_page_state(struct page *page,
+void __lruvec_stat_mod_folio(struct folio *folio,
 			     enum node_stat_item idx, int val);
 
-static inline void mod_lruvec_page_state(struct page *page,
+static inline void lruvec_stat_mod_folio(struct folio *folio,
 					 enum node_stat_item idx, int val)
 {
 	unsigned long flags;
 
 	local_irq_save(flags);
-	__mod_lruvec_page_state(page, idx, val);
+	__lruvec_stat_mod_folio(folio, idx, val);
 	local_irq_restore(flags);
 }
 
+static inline void mod_lruvec_page_state(struct page *page,
+					 enum node_stat_item idx, int val)
+{
+	lruvec_stat_mod_folio(page_folio(page), idx, val);
+}
+
 #else
 
 static inline void __mod_lruvec_state(struct lruvec *lruvec,
@@ -583,10 +589,16 @@ static inline void mod_lruvec_state(stru
 	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
 }
 
-static inline void __mod_lruvec_page_state(struct page *page,
-					   enum node_stat_item idx, int val)
+static inline void __lruvec_stat_mod_folio(struct folio *folio,
+					 enum node_stat_item idx, int val)
 {
-	__mod_node_page_state(page_pgdat(page), idx, val);
+	__mod_node_page_state(folio_pgdat(folio), idx, val);
+}
+
+static inline void lruvec_stat_mod_folio(struct folio *folio,
+					 enum node_stat_item idx, int val)
+{
+	mod_node_page_state(folio_pgdat(folio), idx, val);
 }
 
 static inline void mod_lruvec_page_state(struct page *page,
@@ -597,12 +609,6 @@ static inline void mod_lruvec_page_state
 
 #endif /* CONFIG_MEMCG */
 
-static inline void __lruvec_stat_mod_folio(struct folio *folio,
-					   enum node_stat_item idx, int val)
-{
-	__mod_lruvec_page_state(&folio->page, idx, val);
-}
-
 static inline void __lruvec_stat_add_folio(struct folio *folio,
 					   enum node_stat_item idx)
 {
@@ -615,12 +621,6 @@ static inline void __lruvec_stat_sub_fol
 	__lruvec_stat_mod_folio(folio, idx, -folio_nr_pages(folio));
 }
 
-static inline void lruvec_stat_mod_folio(struct folio *folio,
-					 enum node_stat_item idx, int val)
-{
-	mod_lruvec_page_state(&folio->page, idx, val);
-}
-
 static inline void lruvec_stat_add_folio(struct folio *folio,
 					 enum node_stat_item idx)
 {
--- a/mm/memcontrol.c~mm-memcontrol-remove-__mod_lruvec_page_state
+++ a/mm/memcontrol.c
@@ -890,16 +890,15 @@ void __mod_lruvec_state(struct lruvec *l
 		__mod_memcg_lruvec_state(lruvec, idx, val);
 }
 
-void __mod_lruvec_page_state(struct page *page, enum node_stat_item idx,
+void __lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 			     int val)
 {
-	struct page *head = compound_head(page); /* rmap on tail pages */
 	struct mem_cgroup *memcg;
-	pg_data_t *pgdat = page_pgdat(page);
+	pg_data_t *pgdat = folio_pgdat(folio);
 	struct lruvec *lruvec;
 
 	rcu_read_lock();
-	memcg = page_memcg(head);
+	memcg = folio_memcg(folio);
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
 	if (!memcg) {
 		rcu_read_unlock();
@@ -911,7 +910,7 @@ void __mod_lruvec_page_state(struct page
 	__mod_lruvec_state(lruvec, idx, val);
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL(__mod_lruvec_page_state);
+EXPORT_SYMBOL(__lruvec_stat_mod_folio);
 
 void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 {
_

Patches currently in -mm which might be from willy@infradead.org are


