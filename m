Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70754C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jun 2022 20:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbiFUUHc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 16:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236071AbiFUUHc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 16:07:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322C263B0
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 13:07:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE4DC617EE
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 20:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A4DC3411C;
        Tue, 21 Jun 2022 20:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655842050;
        bh=oxdf/EDK+Pnvj6PQg8Taz5j9W9C0wgwlRuBOL3Fd6hM=;
        h=Date:To:From:Subject:From;
        b=frA5tPLyWyAG2CYJpDayV7kno2XSMmRpad4bXtFFY/X9FG9VMl79pu9T7FYyx347l
         rs+M0jnaaRkKWzfKyOqgFI3p5CQT9H1mLoxf0nxx6yhW2V12lcYoiPh0QM4idY1dko
         SYjzmz5eCj5qBqRCNWFaEGlk2ueuWERluVe79jUE=
Date:   Tue, 21 Jun 2022 13:07:16 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        longman@redhat.com, hannes@cmpxchg.org,
        duanxiongchun@bytedance.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented.patch added to mm-unstable branch
Message-Id: <20220621200726.00A4DC3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: make lruvec lock safe when LRU pages are reparented
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: make lruvec lock safe when LRU pages are reparented
Date: Tue, 21 Jun 2022 20:56:51 +0800

The diagram below shows how to make the folio lruvec lock safe when LRU
pages are reparented.

folio_lruvec_lock(folio)
	rcu_read_lock();
    retry:
	lruvec = folio_lruvec(folio);

        // The folio is reparented at this time.
        spin_lock(&lruvec->lru_lock);

        if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio)))
            // Acquired the wrong lruvec lock and need to retry.
            // Because this folio is on the parent memcg lruvec list.
            spin_unlock(&lruvec->lru_lock);
	    goto retry;

        // If we reach here, it means that folio_memcg(folio) is stable.

memcg_reparent_objcgs(memcg)
    // lruvec belongs to memcg and lruvec_parent belongs to parent memcg.
    spin_lock(&lruvec->lru_lock);
    spin_lock(&lruvec_parent->lru_lock);

    // Move all the pages from the lruvec list to the parent lruvec list.

    spin_unlock(&lruvec_parent->lru_lock);
    spin_unlock(&lruvec->lru_lock);

After we acquire the lruvec lock, we need to check whether the folio is
reparented.  If so, we need to reacquire the new lruvec lock.  On the
routine of the LRU pages reparenting, we will also acquire the lruvec lock
(will be implemented in the later patch).  So folio_memcg() cannot be
changed when we hold the lruvec lock.

Since lruvec_memcg(lruvec) is always equal to folio_memcg(folio) after we
hold the lruvec lock, lruvec_memcg_debug() check is pointless.  So remove
it.

This is a preparation for reparenting the LRU pages.

Link: https://lkml.kernel.org/r/20220621125658.64935-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   18 +----------
 mm/compaction.c            |   27 +++++++++++++++--
 mm/memcontrol.c            |   53 +++++++++++++++++++----------------
 mm/swap.c                  |    5 +++
 4 files changed, 61 insertions(+), 42 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented
+++ a/include/linux/memcontrol.h
@@ -758,7 +758,9 @@ out:
  * folio_lruvec - return lruvec for isolating/putting an LRU folio
  * @folio: Pointer to the folio.
  *
- * This function relies on folio->mem_cgroup being stable.
+ * The lruvec can be changed to its parent lruvec when the page reparented.
+ * The caller need to recheck if it cares about this changes (just like
+ * folio_lruvec_lock() does).
  */
 static inline struct lruvec *folio_lruvec(struct folio *folio)
 {
@@ -777,15 +779,6 @@ struct lruvec *folio_lruvec_lock_irq(str
 struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
 						unsigned long *flags);
 
-#ifdef CONFIG_DEBUG_VM
-void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio);
-#else
-static inline
-void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio)
-{
-}
-#endif
-
 static inline
 struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css){
 	return css ? container_of(css, struct mem_cgroup, css) : NULL;
@@ -1260,11 +1253,6 @@ static inline struct lruvec *folio_lruve
 	return &pgdat->__lruvec;
 }
 
-static inline
-void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio)
-{
-}
-
 static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
 {
 	return NULL;
--- a/mm/compaction.c~mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented
+++ a/mm/compaction.c
@@ -508,6 +508,25 @@ static bool compact_lock_irqsave(spinloc
 	return true;
 }
 
+static struct lruvec *
+compact_folio_lruvec_lock_irqsave(struct folio *folio, unsigned long *flags,
+				  struct compact_control *cc)
+{
+	struct lruvec *lruvec;
+
+	rcu_read_lock();
+retry:
+	lruvec = folio_lruvec(folio);
+	compact_lock_irqsave(&lruvec->lru_lock, flags, cc);
+	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
+		spin_unlock_irqrestore(&lruvec->lru_lock, *flags);
+		goto retry;
+	}
+	rcu_read_unlock();
+
+	return lruvec;
+}
+
 /*
  * Compaction requires the taking of some coarse locks that are potentially
  * very heavily contended. The lock should be periodically unlocked to avoid
@@ -834,6 +853,7 @@ isolate_migratepages_block(struct compac
 
 	/* Time to isolate some pages for migration */
 	for (; low_pfn < end_pfn; low_pfn++) {
+		struct folio *folio;
 
 		if (skip_on_failure && low_pfn >= next_skip_pfn) {
 			/*
@@ -1055,18 +1075,17 @@ isolate_migratepages_block(struct compac
 		if (!TestClearPageLRU(page))
 			goto isolate_fail_put;
 
-		lruvec = folio_lruvec(page_folio(page));
+		folio = page_folio(page);
+		lruvec = folio_lruvec(folio);
 
 		/* If we already hold the lock, we can skip some rechecking */
 		if (lruvec != locked) {
 			if (locked)
 				lruvec_unlock_irqrestore(locked, flags);
 
-			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
+			lruvec = compact_folio_lruvec_lock_irqsave(folio, &flags, cc);
 			locked = lruvec;
 
-			lruvec_memcg_debug(lruvec, page_folio(page));
-
 			/* Try get exclusive access under lock */
 			if (!skip_updated) {
 				skip_updated = true;
--- a/mm/memcontrol.c~mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented
+++ a/mm/memcontrol.c
@@ -1195,23 +1195,6 @@ int mem_cgroup_scan_tasks(struct mem_cgr
 	return ret;
 }
 
-#ifdef CONFIG_DEBUG_VM
-void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio)
-{
-	struct mem_cgroup *memcg;
-
-	if (mem_cgroup_disabled())
-		return;
-
-	memcg = folio_memcg(folio);
-
-	if (!memcg)
-		VM_BUG_ON_FOLIO(lruvec_memcg(lruvec) != root_mem_cgroup, folio);
-	else
-		VM_BUG_ON_FOLIO(lruvec_memcg(lruvec) != memcg, folio);
-}
-#endif
-
 /**
  * folio_lruvec_lock - Lock the lruvec for a folio.
  * @folio: Pointer to the folio.
@@ -1226,10 +1209,18 @@ void lruvec_memcg_debug(struct lruvec *l
  */
 struct lruvec *folio_lruvec_lock(struct folio *folio)
 {
-	struct lruvec *lruvec = folio_lruvec(folio);
+	struct lruvec *lruvec;
 
+	rcu_read_lock();
+retry:
+	lruvec = folio_lruvec(folio);
 	spin_lock(&lruvec->lru_lock);
-	lruvec_memcg_debug(lruvec, folio);
+
+	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
+		spin_unlock(&lruvec->lru_lock);
+		goto retry;
+	}
+	rcu_read_unlock();
 
 	return lruvec;
 }
@@ -1249,10 +1240,18 @@ struct lruvec *folio_lruvec_lock(struct
  */
 struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
 {
-	struct lruvec *lruvec = folio_lruvec(folio);
+	struct lruvec *lruvec;
 
+	rcu_read_lock();
+retry:
+	lruvec = folio_lruvec(folio);
 	spin_lock_irq(&lruvec->lru_lock);
-	lruvec_memcg_debug(lruvec, folio);
+
+	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
+		spin_unlock_irq(&lruvec->lru_lock);
+		goto retry;
+	}
+	rcu_read_unlock();
 
 	return lruvec;
 }
@@ -1274,10 +1273,18 @@ struct lruvec *folio_lruvec_lock_irq(str
 struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
 		unsigned long *flags)
 {
-	struct lruvec *lruvec = folio_lruvec(folio);
+	struct lruvec *lruvec;
 
+	rcu_read_lock();
+retry:
+	lruvec = folio_lruvec(folio);
 	spin_lock_irqsave(&lruvec->lru_lock, *flags);
-	lruvec_memcg_debug(lruvec, folio);
+
+	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
+		spin_unlock_irqrestore(&lruvec->lru_lock, *flags);
+		goto retry;
+	}
+	rcu_read_unlock();
 
 	return lruvec;
 }
--- a/mm/swap.c~mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented
+++ a/mm/swap.c
@@ -337,6 +337,11 @@ void lru_note_cost(struct lruvec *lruvec
 
 void lru_note_cost_folio(struct folio *folio)
 {
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	/*
+	 * The rcu read lock is held by the caller, so we do not need to
+	 * care about the lruvec returned by folio_lruvec() being released.
+	 */
 	lru_note_cost(folio_lruvec(folio), folio_is_file_lru(folio),
 			folio_nr_pages(folio));
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-enumerate-all-supported-section-flags.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory.patch
mm-hugetlb-remove-minimum_order-variable.patch
mm-memcontrol-remove-dead-code-and-comments.patch
mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore.patch
mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch
mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented.patch
mm-vmscan-rework-move_pages_to_lru.patch
mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented.patch
mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe.patch
mm-memcontrol-introduce-memcg_reparent_ops.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-the-lru-pages.patch
mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function.patch
mm-lru-use-lruvec-lock-to-serialize-memcg-changes.patch

