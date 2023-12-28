Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBFEF9D7
	for <mm-commits@vger.kernel.org>; Thu, 28 Dec 2023 18:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D8T+JQ7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8809CC433C8;
	Thu, 28 Dec 2023 18:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703787339;
	bh=LMnv/fL56OiC2LotNHV7gH4ciIrt9Aq3ZjKXddGHfqA=;
	h=Date:To:From:Subject:From;
	b=D8T+JQ7MaBldqry5K+/HHCevg0Yv4SSJqInnHqSxABFk7lr8sl2JjbtDWR8ZYtP5R
	 m1kXOTYZp9s79Qvyi5QHEAR2FUWRWnVzHtvxTRbeEQvPORJoeYk94M7RsqudvlB6BH
	 Lw1l7z4gQoOEriVf72ns+HTNcuLP7fLQIBKIsmD0=
Date: Thu, 28 Dec 2023 10:15:38 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,hannes@cmpxchg.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcontrol-remove-__mod_lruvec_page_state.patch removed from -mm tree
Message-Id: <20231228181539.8809CC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcontrol: remove __mod_lruvec_page_state()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-__mod_lruvec_page_state.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/memcontrol: remove __mod_lruvec_page_state()
Date: Fri, 22 Dec 2023 20:28:07 +0000

There are no more callers of __mod_lruvec_page_state(), so convert the
implementation to __lruvec_stat_mod_folio(), removing two calls to
compound_head() (one explicit, one hidden inside page_memcg()).

Link: https://lkml.kernel.org/r/20231222202807.2135717-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios-fix.patch
mm-remove-pageanonexclusive-assertions-in-unuse_pte.patch
mm-convert-unuse_pte-to-use-a-folio-throughout.patch
mm-remove-some-calls-to-page_add_new_anon_rmap.patch
mm-remove-stale-example-from-comment.patch
mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch
mm-convert-migrate_vma_insert_page-to-use-a-folio.patch
mm-convert-collapse_huge_page-to-use-a-folio.patch
mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch
mm-return-the-folio-from-__read_swap_cache_async.patch
mm-pass-a-folio-to-__swap_writepage.patch
mm-pass-a-folio-to-swap_writepage_fs.patch
mm-pass-a-folio-to-swap_writepage_bdev_sync.patch
mm-pass-a-folio-to-swap_writepage_bdev_async.patch
mm-pass-a-folio-to-swap_readpage_fs.patch
mm-pass-a-folio-to-swap_readpage_bdev_sync.patch
mm-pass-a-folio-to-swap_readpage_bdev_async.patch
mm-convert-swap_page_sector-to-swap_folio_sector.patch
mm-convert-swap_readpage-to-swap_read_folio.patch
mm-remove-page_swap_info.patch
mm-return-a-folio-from-read_swap_cache_async.patch
mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio.patch
mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio-fix.patch
fs-remove-clean_page_buffers.patch
fs-convert-clean_buffers-to-take-a-folio.patch
fs-reduce-stack-usage-in-__mpage_writepage.patch
fs-reduce-stack-usage-in-do_mpage_readpage.patch
adfs-remove-writepage-implementation.patch
bfs-remove-writepage-implementation.patch
hfs-really-remove-hfs_writepage.patch
hfsplus-really-remove-hfsplus_writepage.patch
minix-remove-writepage-implementation.patch
ocfs2-remove-writepage-implementation.patch
sysv-remove-writepage-implementation.patch
ufs-remove-writepage-implementation.patch
fs-convert-block_write_full_page-to-block_write_full_folio.patch
fs-remove-the-bh_end_io-argument-from-__block_write_full_folio.patch

