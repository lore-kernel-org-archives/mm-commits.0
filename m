Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D45C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27BED60F9C
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:07:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhG0UH1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230469AbhG0UHZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 16:07:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6098460F9B;
        Tue, 27 Jul 2021 20:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627416445;
        bh=UUrqKYumwK4iaePHggxcUBMQIbBARcciK55wi06TjZE=;
        h=Date:From:To:Subject:From;
        b=rN6XK/laWgo+tohb9RCi9PNEfVlG7DmhggH7siELWsOfxm7KbzSfQlMOtSu76l1gf
         BXEVwhznvhuOQAwPunXTH2mKvi2kvWI74K6OriIS1qbCVlMqE1MSga5NwqeXKmzBa/
         awhk6K9W7Uayhqo5a1TJ3dXerTTEp+kF0aGNouOo=
Date:   Tue, 27 Jul 2021 13:07:24 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-rejects.patch added to -mm tree
Message-ID: <20210727200724.syEUCZW_K%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   17 +---
 mm/memcontrol.c            |   89 ++++++++++-----------
 mm/page-writeback.c        |  145 ++++++++++++++++++++---------------
 3 files changed, 135 insertions(+), 116 deletions(-)

--- a/include/linux/memcontrol.h~linux-next-rejects
+++ a/include/linux/memcontrol.h
@@ -704,26 +704,25 @@ static inline bool mem_cgroup_below_min(
 		page_counter_read(&memcg->memory);
 }
 
-int __mem_cgroup_charge(struct page *page, struct mm_struct *mm,
-			gfp_t gfp_mask);
-static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
-				    gfp_t gfp_mask)
+int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp);
+static inline int mem_cgroup_charge(struct folio *folio, struct mm_struct *mm,
+				    gfp_t gfp)
 {
 	if (mem_cgroup_disabled())
 		return 0;
-	return __mem_cgroup_charge(page, mm, gfp_mask);
+	return __mem_cgroup_charge(folio, mm, gfp);
 }
 
 int mem_cgroup_swapin_charge_page(struct page *page, struct mm_struct *mm,
 				  gfp_t gfp, swp_entry_t entry);
 void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry);
 
-void __mem_cgroup_uncharge(struct page *page);
-static inline void mem_cgroup_uncharge(struct page *page)
+void __mem_cgroup_uncharge(struct folio *folio);
+static inline void mem_cgroup_uncharge(struct folio *folio)
 {
 	if (mem_cgroup_disabled())
 		return;
-	__mem_cgroup_uncharge(page);
+	__mem_cgroup_uncharge(folio);
 }
 
 void __mem_cgroup_uncharge_list(struct list_head *page_list);
@@ -734,7 +733,7 @@ static inline void mem_cgroup_uncharge_l
 	__mem_cgroup_uncharge_list(page_list);
 }
 
-void mem_cgroup_migrate(struct page *oldpage, struct page *newpage);
+void mem_cgroup_migrate(struct folio *old, struct folio *new);
 
 /**
  * mem_cgroup_lruvec - get the lru list vector for a memcg & node
--- a/mm/memcontrol.c~linux-next-rejects
+++ a/mm/memcontrol.c
@@ -6675,9 +6675,10 @@ void mem_cgroup_calculate_protection(str
 			atomic_long_read(&parent->memory.children_low_usage)));
 }
 
-static int charge_memcg(struct page *page, struct mem_cgroup *memcg, gfp_t gfp)
+static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
+			gfp_t gfp)
 {
-	unsigned int nr_pages = thp_nr_pages(page);
+	unsigned int nr_pages = folio_nr_pages(folio);
 	int ret;
 
 	ret = try_charge(memcg, gfp, nr_pages);
@@ -6685,38 +6686,37 @@ static int charge_memcg(struct page *pag
 		goto out;
 
 	css_get(&memcg->css);
-	commit_charge(page, memcg);
+	commit_charge(folio, memcg);
 
 	local_irq_disable();
-	mem_cgroup_charge_statistics(memcg, page, nr_pages);
-	memcg_check_events(memcg, page);
+	mem_cgroup_charge_statistics(memcg, nr_pages);
+	memcg_check_events(memcg, folio_nid(folio));
 	local_irq_enable();
 out:
 	return ret;
 }
 
 /**
- * __mem_cgroup_charge - charge a newly allocated page to a cgroup
- * @page: page to charge
- * @mm: mm context of the victim
- * @gfp_mask: reclaim mode
+ * __mem_cgroup_charge - Charge a newly allocated folio to a cgroup.
+ * @folio: Folio to charge.
+ * @mm: mm context of the allocating task.
+ * @gfp: Reclaim mode.
  *
- * Try to charge @page to the memcg that @mm belongs to, reclaiming
- * pages according to @gfp_mask if necessary. if @mm is NULL, try to
+ * Try to charge @folio to the memcg that @mm belongs to, reclaiming
+ * pages according to @gfp if necessary.  If @mm is NULL, try to
  * charge to the active memcg.
  *
- * Do not use this for pages allocated for swapin.
+ * Do not use this for folios allocated for swapin.
  *
- * Returns 0 on success. Otherwise, an error code is returned.
+ * Return: 0 on success. Otherwise, an error code is returned.
  */
-int __mem_cgroup_charge(struct page *page, struct mm_struct *mm,
-			gfp_t gfp_mask)
+int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp)
 {
 	struct mem_cgroup *memcg;
 	int ret;
 
 	memcg = get_mem_cgroup_from_mm(mm);
-	ret = charge_memcg(page, memcg, gfp_mask);
+	ret = charge_memcg(folio, memcg, gfp);
 	css_put(&memcg->css);
 
 	return ret;
@@ -6752,7 +6752,7 @@ int mem_cgroup_swapin_charge_page(struct
 		memcg = get_mem_cgroup_from_mm(mm);
 	rcu_read_unlock();
 
-	ret = charge_memcg(page, memcg, gfp);
+	ret = charge_memcg(folio, memcg, gfp);
 
 	css_put(&memcg->css);
 	return ret;
@@ -6881,28 +6881,28 @@ static void uncharge_folio(struct folio
 			ug->nr_memory += nr_pages;
 		ug->pgpgout++;
 
-		page->memcg_data = 0;
+		folio->memcg_data = 0;
 	}
 
 	css_put(&memcg->css);
 }
 
 /**
- * __mem_cgroup_uncharge - uncharge a page
- * @page: page to uncharge
+ * __mem_cgroup_uncharge - Uncharge a folio.
+ * @folio: Folio to uncharge.
  *
- * Uncharge a page previously charged with __mem_cgroup_charge().
+ * Uncharge a folio previously charged with mem_cgroup_charge().
  */
-void __mem_cgroup_uncharge(struct page *page)
+void __mem_cgroup_uncharge(struct folio *folio)
 {
 	struct uncharge_gather ug;
 
-	/* Don't touch page->lru of any random page, pre-check: */
-	if (!page_memcg(page))
+	/* Don't touch folio->lru of any random page, pre-check: */
+	if (!folio_memcg(folio))
 		return;
 
 	uncharge_gather_clear(&ug);
-	uncharge_page(page, &ug);
+	uncharge_folio(folio, &ug);
 	uncharge_batch(&ug);
 }
 
@@ -6916,52 +6916,49 @@ void __mem_cgroup_uncharge(struct page *
 void __mem_cgroup_uncharge_list(struct list_head *page_list)
 {
 	struct uncharge_gather ug;
-	struct page *page;
+	struct folio *folio;
 
 	uncharge_gather_clear(&ug);
-	list_for_each_entry(page, page_list, lru)
-		uncharge_page(page, &ug);
+	list_for_each_entry(folio, page_list, lru)
+		uncharge_folio(folio, &ug);
 	if (ug.memcg)
 		uncharge_batch(&ug);
 }
 
 /**
- * mem_cgroup_migrate - charge a page's replacement
- * @oldpage: currently circulating page
- * @newpage: replacement page
+ * mem_cgroup_migrate - Charge a folio's replacement.
+ * @old: Currently circulating folio.
+ * @new: Replacement folio.
  *
- * Charge @newpage as a replacement page for @oldpage. @oldpage will
+ * Charge @new as a replacement folio for @old. @old will
  * be uncharged upon free.
  *
- * Both pages must be locked, @newpage->mapping must be set up.
+ * Both folios must be locked, @new->mapping must be set up.
  */
-void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
+void mem_cgroup_migrate(struct folio *old, struct folio *new)
 {
 	struct mem_cgroup *memcg;
-	unsigned int nr_pages;
+	unsigned int nr_pages = folio_nr_pages(new);
 	unsigned long flags;
 
-	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
-	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
-	VM_BUG_ON_PAGE(PageAnon(oldpage) != PageAnon(newpage), newpage);
-	VM_BUG_ON_PAGE(PageTransHuge(oldpage) != PageTransHuge(newpage),
-		       newpage);
+	VM_BUG_ON_FOLIO(!folio_test_locked(old), old);
+	VM_BUG_ON_FOLIO(!folio_test_locked(new), new);
+	VM_BUG_ON_FOLIO(folio_test_anon(old) != folio_test_anon(new), new);
+	VM_BUG_ON_FOLIO(folio_nr_pages(old) != nr_pages, new);
 
 	if (mem_cgroup_disabled())
 		return;
 
-	/* Page cache replacement: new page already charged? */
-	if (page_memcg(newpage))
+	/* Page cache replacement: new folio already charged? */
+	if (folio_memcg(new))
 		return;
 
-	memcg = page_memcg(oldpage);
-	VM_WARN_ON_ONCE_PAGE(!memcg, oldpage);
+	memcg = folio_memcg(old);
+	VM_WARN_ON_ONCE_FOLIO(!memcg, old);
 	if (!memcg)
 		return;
 
 	/* Force-charge the new page. The old one will be freed soon */
-	nr_pages = thp_nr_pages(newpage);
-
 	if (!mem_cgroup_is_root(memcg)) {
 		page_counter_charge(&memcg->memory, nr_pages);
 		if (do_memsw_account())
--- a/mm/page-writeback.c~linux-next-rejects
+++ a/mm/page-writeback.c
@@ -2723,48 +2723,49 @@ bool folio_clear_dirty_for_io(struct fol
 		 * We use this sequence to make sure that
 		 *  (a) we account for dirty stats properly
 		 *  (b) we tell the low-level filesystem to
-		 *      mark the whole page dirty if it was
+		 *      mark the whole folio dirty if it was
 		 *      dirty in a pagetable. Only to then
-		 *  (c) clean the page again and return 1 to
+		 *  (c) clean the folio again and return 1 to
 		 *      cause the writeback.
 		 *
 		 * This way we avoid all nasty races with the
 		 * dirty bit in multiple places and clearing
 		 * them concurrently from different threads.
 		 *
-		 * Note! Normally the "set_page_dirty(page)"
+		 * Note! Normally the "folio_mark_dirty(folio)"
 		 * has no effect on the actual dirty bit - since
 		 * that will already usually be set. But we
 		 * need the side effects, and it can help us
 		 * avoid races.
 		 *
-		 * We basically use the page "master dirty bit"
+		 * We basically use the folio "master dirty bit"
 		 * as a serialization point for all the different
 		 * threads doing their things.
 		 */
-		if (page_mkclean(page))
-			set_page_dirty(page);
+		if (folio_mkclean(folio))
+			folio_mark_dirty(folio);
 		/*
 		 * We carefully synchronise fault handlers against
-		 * installing a dirty pte and marking the page dirty
+		 * installing a dirty pte and marking the folio dirty
 		 * at this point.  We do this by having them hold the
-		 * page lock while dirtying the page, and pages are
+		 * page lock while dirtying the folio, and folios are
 		 * always locked coming in here, so we get the desired
 		 * exclusion.
 		 */
 		wb = unlocked_inode_to_wb_begin(inode, &cookie);
-		if (TestClearPageDirty(page)) {
-			dec_lruvec_page_state(page, NR_FILE_DIRTY);
-			dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
-			dec_wb_stat(wb, WB_RECLAIMABLE);
-			ret = 1;
+		if (folio_test_clear_dirty(folio)) {
+			long nr = folio_nr_pages(folio);
+			lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
+			zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
+			wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
+			ret = true;
 		}
 		unlocked_inode_to_wb_end(inode, &cookie);
 		return ret;
 	}
-	return TestClearPageDirty(page);
+	return folio_test_clear_dirty(folio);
 }
-EXPORT_SYMBOL(clear_page_dirty_for_io);
+EXPORT_SYMBOL(folio_clear_dirty_for_io);
 
 static void wb_inode_writeback_start(struct bdi_writeback *wb)
 {
@@ -2784,27 +2785,28 @@ static void wb_inode_writeback_end(struc
 	queue_delayed_work(bdi_wq, &wb->bw_dwork, BANDWIDTH_INTERVAL);
 }
 
-int test_clear_page_writeback(struct page *page)
+bool __folio_end_writeback(struct folio *folio)
 {
-	struct address_space *mapping = page_mapping(page);
-	int ret;
+	long nr = folio_nr_pages(folio);
+	struct address_space *mapping = folio_mapping(folio);
+	bool ret;
 
-	lock_page_memcg(page);
+	folio_memcg_lock(folio);
 	if (mapping && mapping_use_writeback_tags(mapping)) {
 		struct inode *inode = mapping->host;
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
 		unsigned long flags;
 
 		xa_lock_irqsave(&mapping->i_pages, flags);
-		ret = TestClearPageWriteback(page);
+		ret = folio_test_clear_writeback(folio);
 		if (ret) {
-			__xa_clear_mark(&mapping->i_pages, page_index(page),
+			__xa_clear_mark(&mapping->i_pages, folio_index(folio),
 						PAGECACHE_TAG_WRITEBACK);
 			if (bdi->capabilities & BDI_CAP_WRITEBACK_ACCT) {
 				struct bdi_writeback *wb = inode_to_wb(inode);
 
-				dec_wb_stat(wb, WB_WRITEBACK);
-				__wb_writeout_inc(wb);
+				wb_stat_mod(wb, WB_WRITEBACK, -nr);
+				__wb_writeout_add(wb, nr);
 				if (!mapping_tagged(mapping,
 						    PAGECACHE_TAG_WRITEBACK))
 					wb_inode_writeback_end(wb);
@@ -2855,84 +2857,105 @@ bool __folio_start_writeback(struct foli
 			if (bdi->capabilities & BDI_CAP_WRITEBACK_ACCT) {
 				struct bdi_writeback *wb = inode_to_wb(inode);
 
-				inc_wb_stat(wb, WB_WRITEBACK);
+				wb_stat_mod(wb, WB_WRITEBACK, nr);
 				if (!on_wblist)
 					wb_inode_writeback_start(wb);
 			}
 
 			/*
-			 * We can come through here when swapping anonymous
-			 * pages, so we don't necessarily have an inode to track
-			 * for sync.
+			 * We can come through here when swapping
+			 * anonymous folios, so we don't necessarily
+			 * have an inode to track for sync.
 			 */
 			if (mapping->host && !on_wblist)
 				sb_mark_inode_writeback(mapping->host);
 		}
-		if (!PageDirty(page))
+		if (!folio_test_dirty(folio))
 			xas_clear_mark(&xas, PAGECACHE_TAG_DIRTY);
 		if (!keep_write)
 			xas_clear_mark(&xas, PAGECACHE_TAG_TOWRITE);
 		xas_unlock_irqrestore(&xas, flags);
 	} else {
-		ret = TestSetPageWriteback(page);
+		ret = folio_test_set_writeback(folio);
 	}
 	if (!ret) {
-		inc_lruvec_page_state(page, NR_WRITEBACK);
-		inc_zone_page_state(page, NR_ZONE_WRITE_PENDING);
+		lruvec_stat_mod_folio(folio, NR_WRITEBACK, nr);
+		zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
 	}
-	unlock_page_memcg(page);
-	access_ret = arch_make_page_accessible(page);
+	folio_memcg_unlock(folio);
+	access_ret = arch_make_folio_accessible(folio);
 	/*
 	 * If writeback has been triggered on a page that cannot be made
 	 * accessible, it is too late to recover here.
 	 */
-	VM_BUG_ON_PAGE(access_ret != 0, page);
+	VM_BUG_ON_FOLIO(access_ret != 0, folio);
 
 	return ret;
-
 }
-EXPORT_SYMBOL(__test_set_page_writeback);
+EXPORT_SYMBOL(__folio_start_writeback);
 
-/*
- * Wait for a page to complete writeback
+/**
+ * folio_wait_writeback - Wait for a folio to finish writeback.
+ * @folio: The folio to wait for.
+ *
+ * If the folio is currently being written back to storage, wait for the
+ * I/O to complete.
+ *
+ * Context: Sleeps.  Must be called in process context and with
+ * no spinlocks held.  Caller should hold a reference on the folio.
+ * If the folio is not locked, writeback may start again after writeback
+ * has finished.
  */
-void wait_on_page_writeback(struct page *page)
+void folio_wait_writeback(struct folio *folio)
 {
-	while (PageWriteback(page)) {
-		trace_wait_on_page_writeback(page, page_mapping(page));
-		wait_on_page_bit(page, PG_writeback);
+	while (folio_test_writeback(folio)) {
+		trace_folio_wait_writeback(folio, folio_mapping(folio));
+		folio_wait_bit(folio, PG_writeback);
 	}
 }
-EXPORT_SYMBOL_GPL(wait_on_page_writeback);
+EXPORT_SYMBOL_GPL(folio_wait_writeback);
 
-/*
- * Wait for a page to complete writeback.  Returns -EINTR if we get a
- * fatal signal while waiting.
+/**
+ * folio_wait_writeback_killable - Wait for a folio to finish writeback.
+ * @folio: The folio to wait for.
+ *
+ * If the folio is currently being written back to storage, wait for the
+ * I/O to complete or a fatal signal to arrive.
+ *
+ * Context: Sleeps.  Must be called in process context and with
+ * no spinlocks held.  Caller should hold a reference on the folio.
+ * If the folio is not locked, writeback may start again after writeback
+ * has finished.
+ * Return: 0 on success, -EINTR if we get a fatal signal while waiting.
  */
-int wait_on_page_writeback_killable(struct page *page)
+int folio_wait_writeback_killable(struct folio *folio)
 {
-	while (PageWriteback(page)) {
-		trace_wait_on_page_writeback(page, page_mapping(page));
-		if (wait_on_page_bit_killable(page, PG_writeback))
+	while (folio_test_writeback(folio)) {
+		trace_folio_wait_writeback(folio, folio_mapping(folio));
+		if (folio_wait_bit_killable(folio, PG_writeback))
 			return -EINTR;
 	}
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(wait_on_page_writeback_killable);
+EXPORT_SYMBOL_GPL(folio_wait_writeback_killable);
 
 /**
- * wait_for_stable_page() - wait for writeback to finish, if necessary.
- * @page:	The page to wait on.
+ * folio_wait_stable() - wait for writeback to finish, if necessary.
+ * @folio: The folio to wait on.
+ *
+ * This function determines if the given folio is related to a backing
+ * device that requires folio contents to be held stable during writeback.
+ * If so, then it will wait for any pending writeback to complete.
  *
- * This function determines if the given page is related to a backing device
- * that requires page contents to be held stable during writeback.  If so, then
- * it will wait for any pending writeback to complete.
+ * Context: Sleeps.  Must be called in process context and with
+ * no spinlocks held.  Caller should hold a reference on the folio.
+ * If the folio is not locked, writeback may start again after writeback
+ * has finished.
  */
-void wait_for_stable_page(struct page *page)
+void folio_wait_stable(struct folio *folio)
 {
-	page = thp_head(page);
-	if (page->mapping->host->i_sb->s_iflags & SB_I_STABLE_WRITES)
-		wait_on_page_writeback(page);
+	if (folio->mapping->host->i_sb->s_iflags & SB_I_STABLE_WRITES)
+		folio_wait_writeback(folio);
 }
-EXPORT_SYMBOL_GPL(wait_for_stable_page);
+EXPORT_SYMBOL_GPL(folio_wait_stable);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

