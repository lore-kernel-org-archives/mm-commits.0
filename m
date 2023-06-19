Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7718BC0015E
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjFSX0w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjFSXZH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B52186
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4E0C60F4F
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B922C433C8;
        Mon, 19 Jun 2023 23:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216998;
        bh=kNemG5+mNLairFj10+fZAaymEwkTkKw2aCn7LVz7o+M=;
        h=Date:To:From:Subject:From;
        b=rKI/0SRfMWKkLwLER0mF4Uy2dkzDcFY8LzkvXKTyufoFz6zrJ9zws1GGFzHs2JnSf
         /euDXG+UmD/5ehoNhzBsz46EJGpg1QroNn/L4SvXW9jbIifeFy+ecR7uzT21Mi+Rne
         rr1bebY3mnKNV3R+WMT2m6Q5pEpwRHFDuOKhSzqI=
Date:   Mon, 19 Jun 2023 16:23:17 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        hannes@cmpxchg.org, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kill-lockunlock_page_memcg.patch removed from -mm tree
Message-Id: <20230619232318.2B922C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kill lock|unlock_page_memcg()
has been removed from the -mm tree.  Its filename was
     mm-kill-lockunlock_page_memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: kill lock|unlock_page_memcg()
Date: Wed, 14 Jun 2023 22:36:12 +0800

Since commit c7c3dec1c9db ("mm: rmap: remove lock_page_memcg()"),
no more user, kill lock_page_memcg() and unlock_page_memcg().

Link: https://lkml.kernel.org/r/20230614143612.62575-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |    2 -
 include/linux/memcontrol.h                     |   12 ----------
 mm/filemap.c                                   |    2 -
 mm/memcontrol.c                                |   18 +++------------
 mm/page-writeback.c                            |    6 ++---
 5 files changed, 10 insertions(+), 30 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~mm-kill-lockunlock_page_memcg
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -297,7 +297,7 @@ Lock order is as follows::
 
   Page lock (PG_locked bit of page->flags)
     mm->page_table_lock or split pte_lock
-      lock_page_memcg (memcg->move_lock)
+      folio_memcg_lock (memcg->move_lock)
         mapping->i_pages lock
           lruvec->lru_lock.
 
--- a/include/linux/memcontrol.h~mm-kill-lockunlock_page_memcg
+++ a/include/linux/memcontrol.h
@@ -419,7 +419,7 @@ static inline struct obj_cgroup *__folio
  *
  * - the folio lock
  * - LRU isolation
- * - lock_page_memcg()
+ * - folio_memcg_lock()
  * - exclusive reference
  * - mem_cgroup_trylock_pages()
  *
@@ -949,8 +949,6 @@ void mem_cgroup_print_oom_group(struct m
 
 void folio_memcg_lock(struct folio *folio);
 void folio_memcg_unlock(struct folio *folio);
-void lock_page_memcg(struct page *page);
-void unlock_page_memcg(struct page *page);
 
 void __mod_memcg_state(struct mem_cgroup *memcg, int idx, int val);
 
@@ -1438,14 +1436,6 @@ mem_cgroup_print_oom_meminfo(struct mem_
 {
 }
 
-static inline void lock_page_memcg(struct page *page)
-{
-}
-
-static inline void unlock_page_memcg(struct page *page)
-{
-}
-
 static inline void folio_memcg_lock(struct folio *folio)
 {
 }
--- a/mm/filemap.c~mm-kill-lockunlock_page_memcg
+++ a/mm/filemap.c
@@ -117,7 +117,7 @@
  *    ->i_pages lock		(page_remove_rmap->set_page_dirty)
  *    bdi.wb->list_lock		(page_remove_rmap->set_page_dirty)
  *    ->inode->i_lock		(page_remove_rmap->set_page_dirty)
- *    ->memcg->move_lock	(page_remove_rmap->lock_page_memcg)
+ *    ->memcg->move_lock	(page_remove_rmap->folio_memcg_lock)
  *    bdi.wb->list_lock		(zap_pte_range->set_page_dirty)
  *    ->inode->i_lock		(zap_pte_range->set_page_dirty)
  *    ->private_lock		(zap_pte_range->block_dirty_folio)
--- a/mm/memcontrol.c~mm-kill-lockunlock_page_memcg
+++ a/mm/memcontrol.c
@@ -2148,17 +2148,12 @@ again:
 	 * When charge migration first begins, we can have multiple
 	 * critical sections holding the fast-path RCU lock and one
 	 * holding the slowpath move_lock. Track the task who has the
-	 * move_lock for unlock_page_memcg().
+	 * move_lock for folio_memcg_unlock().
 	 */
 	memcg->move_lock_task = current;
 	memcg->move_lock_flags = flags;
 }
 
-void lock_page_memcg(struct page *page)
-{
-	folio_memcg_lock(page_folio(page));
-}
-
 static void __folio_memcg_unlock(struct mem_cgroup *memcg)
 {
 	if (memcg && memcg->move_lock_task == current) {
@@ -2186,11 +2181,6 @@ void folio_memcg_unlock(struct folio *fo
 	__folio_memcg_unlock(folio_memcg(folio));
 }
 
-void unlock_page_memcg(struct page *page)
-{
-	folio_memcg_unlock(page_folio(page));
-}
-
 struct memcg_stock_pcp {
 	local_lock_t stock_lock;
 	struct mem_cgroup *cached; /* this never be root cgroup */
@@ -2866,7 +2856,7 @@ static void commit_charge(struct folio *
 	 *
 	 * - the page lock
 	 * - LRU isolation
-	 * - lock_page_memcg()
+	 * - folio_memcg_lock()
 	 * - exclusive reference
 	 * - mem_cgroup_trylock_pages()
 	 */
@@ -5829,7 +5819,7 @@ static int mem_cgroup_move_account(struc
 	 * with (un)charging, migration, LRU putback, or anything else
 	 * that would rely on a stable page's memory cgroup.
 	 *
-	 * Note that lock_page_memcg is a memcg lock, not a page lock,
+	 * Note that folio_memcg_lock is a memcg lock, not a page lock,
 	 * to save space. As soon as we switch page's memory cgroup to a
 	 * new memcg that isn't locked, the above state can change
 	 * concurrently again. Make sure we're truly done with it.
@@ -6320,7 +6310,7 @@ static void mem_cgroup_move_charge(void)
 {
 	lru_add_drain_all();
 	/*
-	 * Signal lock_page_memcg() to take the memcg's move_lock
+	 * Signal folio_memcg_lock() to take the memcg's move_lock
 	 * while we're moving its pages to another memcg. Then wait
 	 * for already started RCU-only updates to finish.
 	 */
--- a/mm/page-writeback.c~mm-kill-lockunlock_page_memcg
+++ a/mm/page-writeback.c
@@ -2597,7 +2597,7 @@ EXPORT_SYMBOL(noop_dirty_folio);
 /*
  * Helper function for set_page_dirty family.
  *
- * Caller must hold lock_page_memcg().
+ * Caller must hold folio_memcg_lock().
  *
  * NOTE: This relies on being atomic wrt interrupts.
  */
@@ -2631,7 +2631,7 @@ static void folio_account_dirtied(struct
 /*
  * Helper function for deaccounting dirty page without writeback.
  *
- * Caller must hold lock_page_memcg().
+ * Caller must hold folio_memcg_lock().
  */
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
 {
@@ -2650,7 +2650,7 @@ void folio_account_cleaned(struct folio
  * If warn is true, then emit a warning if the folio is not uptodate and has
  * not been truncated.
  *
- * The caller must hold lock_page_memcg().  Most callers have the folio
+ * The caller must hold folio_memcg_lock().  Most callers have the folio
  * locked.  A few have the folio blocked from truncation through other
  * means (eg zap_vma_pages() has it mapped and is holding the page table
  * lock).  This can also be called from mark_buffer_dirty(), which I
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


