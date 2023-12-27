Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AAE481BA
	for <mm-commits@vger.kernel.org>; Wed, 27 Dec 2023 22:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aZ7YBnCt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A55C433C7;
	Wed, 27 Dec 2023 22:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703714585;
	bh=oQhbQ+m6cZrZixw3W2IH6FuxunEsuXm2plz0omhq6H0=;
	h=Date:To:From:Subject:From;
	b=aZ7YBnCtRdPu92Mlev9NJCFpGVujh8pU6zfbv6ChJCr+LVzcEmus3/TRYTems32mv
	 KWAOO3msnIWI0AvvZvV918XfuE+pqCf1PuZ/h6zzCdpV5mgI2pJxAQSbzpB/4ltt/+
	 dgS6tmuFctrR7mWoIu5OBcAIvYJHzj+7uNSQfpvg=
Date: Wed, 27 Dec 2023 14:03:05 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,hannes@cmpxchg.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-remove-__mod_lruvec_page_state.patch added to mm-unstable branch
Message-Id: <20231227220305.A1A55C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcontrol: remove __mod_lruvec_page_state()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-remove-__mod_lruvec_page_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-remove-__mod_lruvec_page_state.patch

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
mm-remove-inc-dec-lruvec-page-state-functions.patch
slab-convert-__kmalloc_large_node-and-free_large_kmalloc-to-use-folios.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

