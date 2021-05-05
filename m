Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A267C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55BA261029
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhEEBhv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:37:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231925AbhEEBhv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:37:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3D2C611AB;
        Wed,  5 May 2021 01:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178615;
        bh=noL33l62T4tjuIOhcWlUO3xnlCfC3YQDKnSsgwDTQQ8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jXIY1XhIuyidumUkLQjQM8V+P2F7oipi2y4k1KUSJkGBVG3xpxXj5YJDPASLRru4Y
         tFe0y8KljldzsAiIQmgHeLZCNXkc9VZ/7OK/tFIiKWtELgHqL2aaQe0KuiYhqYILY+
         4VxP62vG6hOaMZTWxQw+zn6QT+CvEU/6A9BJ4QFw=
Date:   Tue, 04 May 2021 18:36:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cgoldswo@codeaurora.org,
        david@redhat.com, joaodias@google.com, linux-mm@kvack.org,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        oliver.sang@intel.com, surenb@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 077/143] mm: disable LRU pagevec during the
 migration temporarily
Message-ID: <20210505013654.DvbBdw4C4%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Subject: mm: disable LRU pagevec during the migration temporarily

LRU pagevec holds refcount of pages until the pagevec are drained.  It
could prevent migration since the refcount of the page is greater than the
expection in migration logic.  To mitigate the issue, callers of
migrate_pages drains LRU pagevec via migrate_prep or lru_add_drain_all
before migrate_pages call.

However, it's not enough because pages coming into pagevec after the
draining call still could stay at the pagevec so it could keep preventing
page migration.  Since some callers of migrate_pages have retrial logic
with LRU draining, the page would migrate at next trail but it is still
fragile in that it doesn't close the fundamental race between upcoming LRU
pages into pagvec and migration so the migration failure could cause
contiguous memory allocation failure in the end.

To close the race, this patch disables lru caches(i.e, pagevec) during
ongoing migration until migrate is done.

Since it's really hard to reproduce, I measured how many times
migrate_pages retried with force mode(it is about a fallback to a sync
migration) with below debug code.

int migrate_pages(struct list_head *from, new_page_t get_new_page,
			..
			..

if (rc && reason == MR_CONTIG_RANGE && pass > 2) {
       printk(KERN_ERR, "pfn 0x%lx reason %d
", page_to_pfn(page), rc);
       dump_page(page, "fail to migrate");
}

The test was repeating android apps launching with cma allocation in
background every five seconds.  Total cma allocation count was about 500
during the testing.  With this patch, the dump_page count was reduced from
400 to 30.

The new interface is also useful for memory hotplug which currently drains
lru pcp caches after each migration failure.  This is rather suboptimal as
it has to disrupt others running during the operation.  With the new
interface the operation happens only once.  This is also in line with pcp
allocator cache which are disabled for the offlining as well.

Link: https://lkml.kernel.org/r/20210319175127.886124-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Chris Goldsworthy <cgoldswo@codeaurora.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: John Dias <joaodias@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Oliver Sang <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    2 +
 include/linux/swap.h    |   14 ++++++++
 mm/memory_hotplug.c     |    3 +
 mm/mempolicy.c          |    4 ++
 mm/migrate.c            |   11 ++++--
 mm/page_alloc.c         |    2 +
 mm/swap.c               |   64 ++++++++++++++++++++++++++++++++------
 7 files changed, 86 insertions(+), 14 deletions(-)

--- a/include/linux/migrate.h~mm-disable-lru-pagevec-during-the-migration-temporarily
+++ a/include/linux/migrate.h
@@ -46,6 +46,7 @@ extern int isolate_movable_page(struct p
 extern void putback_movable_page(struct page *page);
 
 extern void migrate_prep(void);
+extern void migrate_finish(void);
 extern void migrate_prep_local(void);
 extern void migrate_page_states(struct page *newpage, struct page *page);
 extern void migrate_page_copy(struct page *newpage, struct page *page);
@@ -67,6 +68,7 @@ static inline int isolate_movable_page(s
 	{ return -EBUSY; }
 
 static inline int migrate_prep(void) { return -ENOSYS; }
+static inline int migrate_finish(void) { return -ENOSYS; }
 static inline int migrate_prep_local(void) { return -ENOSYS; }
 
 static inline void migrate_page_states(struct page *newpage, struct page *page)
--- a/include/linux/swap.h~mm-disable-lru-pagevec-during-the-migration-temporarily
+++ a/include/linux/swap.h
@@ -340,6 +340,20 @@ extern void lru_note_cost(struct lruvec
 extern void lru_note_cost_page(struct page *);
 extern void lru_cache_add(struct page *);
 extern void mark_page_accessed(struct page *);
+
+extern atomic_t lru_disable_count;
+
+static inline bool lru_cache_disabled(void)
+{
+	return atomic_read(&lru_disable_count);
+}
+
+static inline void lru_cache_enable(void)
+{
+	atomic_dec(&lru_disable_count);
+}
+
+extern void lru_cache_disable(void);
 extern void lru_add_drain(void);
 extern void lru_add_drain_cpu(int cpu);
 extern void lru_add_drain_cpu_zone(struct zone *zone);
--- a/mm/memory_hotplug.c~mm-disable-lru-pagevec-during-the-migration-temporarily
+++ a/mm/memory_hotplug.c
@@ -1611,6 +1611,7 @@ int __ref offline_pages(unsigned long st
 	 * in a way that pages from isolated pageblock are left on pcplists.
 	 */
 	zone_pcp_disable(zone);
+	lru_cache_disable();
 
 	/* set above range as isolated */
 	ret = start_isolate_page_range(start_pfn, end_pfn,
@@ -1642,7 +1643,6 @@ int __ref offline_pages(unsigned long st
 			}
 
 			cond_resched();
-			lru_add_drain_all();
 
 			ret = scan_movable_pages(pfn, end_pfn, &pfn);
 			if (!ret) {
@@ -1687,6 +1687,7 @@ int __ref offline_pages(unsigned long st
 	zone->nr_isolate_pageblock -= nr_pages / pageblock_nr_pages;
 	spin_unlock_irqrestore(&zone->lock, flags);
 
+	lru_cache_enable();
 	zone_pcp_enable(zone);
 
 	/* removal success */
--- a/mm/mempolicy.c~mm-disable-lru-pagevec-during-the-migration-temporarily
+++ a/mm/mempolicy.c
@@ -1208,6 +1208,8 @@ int do_migrate_pages(struct mm_struct *m
 			break;
 	}
 	mmap_read_unlock(mm);
+
+	migrate_finish();
 	if (err < 0)
 		return err;
 	return busy;
@@ -1371,6 +1373,8 @@ up_out:
 	mmap_write_unlock(mm);
 mpol_out:
 	mpol_put(new);
+	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
+		migrate_finish();
 	return err;
 }
 
--- a/mm/migrate.c~mm-disable-lru-pagevec-during-the-migration-temporarily
+++ a/mm/migrate.c
@@ -66,11 +66,13 @@ void migrate_prep(void)
 {
 	/*
 	 * Clear the LRU lists so pages can be isolated.
-	 * Note that pages may be moved off the LRU after we have
-	 * drained them. Those pages will fail to migrate like other
-	 * pages that may be busy.
 	 */
-	lru_add_drain_all();
+	lru_cache_disable();
+}
+
+void migrate_finish(void)
+{
+	lru_cache_enable();
 }
 
 /* Do the necessary work of migrate_prep but not if it involves other CPUs */
@@ -1838,6 +1840,7 @@ out_flush:
 	if (err >= 0)
 		err = err1;
 out:
+	migrate_finish();
 	return err;
 }
 
--- a/mm/page_alloc.c~mm-disable-lru-pagevec-during-the-migration-temporarily
+++ a/mm/page_alloc.c
@@ -8715,6 +8715,8 @@ static int __alloc_contig_migrate_range(
 		if (ret == -ENOMEM)
 			break;
 	}
+
+	migrate_finish();
 	if (ret < 0) {
 		alloc_contig_dump_pages(&cc->migratepages);
 		putback_movable_pages(&cc->migratepages);
--- a/mm/swap.c~mm-disable-lru-pagevec-during-the-migration-temporarily
+++ a/mm/swap.c
@@ -235,6 +235,18 @@ static void pagevec_move_tail_fn(struct
 	}
 }
 
+/* return true if pagevec needs to drain */
+static bool pagevec_add_and_need_flush(struct pagevec *pvec, struct page *page)
+{
+	bool ret = false;
+
+	if (!pagevec_add(pvec, page) || PageCompound(page) ||
+			lru_cache_disabled())
+		ret = true;
+
+	return ret;
+}
+
 /*
  * Writeback is about to end against a page which has been marked for immediate
  * reclaim.  If it still appears to be reclaimable, move it to the tail of the
@@ -252,7 +264,7 @@ void rotate_reclaimable_page(struct page
 		get_page(page);
 		local_lock_irqsave(&lru_rotate.lock, flags);
 		pvec = this_cpu_ptr(&lru_rotate.pvec);
-		if (!pagevec_add(pvec, page) || PageCompound(page))
+		if (pagevec_add_and_need_flush(pvec, page))
 			pagevec_lru_move_fn(pvec, pagevec_move_tail_fn);
 		local_unlock_irqrestore(&lru_rotate.lock, flags);
 	}
@@ -343,7 +355,7 @@ static void activate_page(struct page *p
 		local_lock(&lru_pvecs.lock);
 		pvec = this_cpu_ptr(&lru_pvecs.activate_page);
 		get_page(page);
-		if (!pagevec_add(pvec, page) || PageCompound(page))
+		if (pagevec_add_and_need_flush(pvec, page))
 			pagevec_lru_move_fn(pvec, __activate_page);
 		local_unlock(&lru_pvecs.lock);
 	}
@@ -458,7 +470,7 @@ void lru_cache_add(struct page *page)
 	get_page(page);
 	local_lock(&lru_pvecs.lock);
 	pvec = this_cpu_ptr(&lru_pvecs.lru_add);
-	if (!pagevec_add(pvec, page) || PageCompound(page))
+	if (pagevec_add_and_need_flush(pvec, page))
 		__pagevec_lru_add(pvec);
 	local_unlock(&lru_pvecs.lock);
 }
@@ -654,7 +666,7 @@ void deactivate_file_page(struct page *p
 		local_lock(&lru_pvecs.lock);
 		pvec = this_cpu_ptr(&lru_pvecs.lru_deactivate_file);
 
-		if (!pagevec_add(pvec, page) || PageCompound(page))
+		if (pagevec_add_and_need_flush(pvec, page))
 			pagevec_lru_move_fn(pvec, lru_deactivate_file_fn);
 		local_unlock(&lru_pvecs.lock);
 	}
@@ -676,7 +688,7 @@ void deactivate_page(struct page *page)
 		local_lock(&lru_pvecs.lock);
 		pvec = this_cpu_ptr(&lru_pvecs.lru_deactivate);
 		get_page(page);
-		if (!pagevec_add(pvec, page) || PageCompound(page))
+		if (pagevec_add_and_need_flush(pvec, page))
 			pagevec_lru_move_fn(pvec, lru_deactivate_fn);
 		local_unlock(&lru_pvecs.lock);
 	}
@@ -698,7 +710,7 @@ void mark_page_lazyfree(struct page *pag
 		local_lock(&lru_pvecs.lock);
 		pvec = this_cpu_ptr(&lru_pvecs.lru_lazyfree);
 		get_page(page);
-		if (!pagevec_add(pvec, page) || PageCompound(page))
+		if (pagevec_add_and_need_flush(pvec, page))
 			pagevec_lru_move_fn(pvec, lru_lazyfree_fn);
 		local_unlock(&lru_pvecs.lock);
 	}
@@ -735,7 +747,7 @@ static void lru_add_drain_per_cpu(struct
  * Calling this function with cpu hotplug locks held can actually lead
  * to obscure indirect dependencies via WQ context.
  */
-void lru_add_drain_all(void)
+inline void __lru_add_drain_all(bool force_all_cpus)
 {
 	/*
 	 * lru_drain_gen - Global pages generation number
@@ -780,7 +792,7 @@ void lru_add_drain_all(void)
 	 * (C) Exit the draining operation if a newer generation, from another
 	 * lru_add_drain_all(), was already scheduled for draining. Check (A).
 	 */
-	if (unlikely(this_gen != lru_drain_gen))
+	if (unlikely(this_gen != lru_drain_gen && !force_all_cpus))
 		goto done;
 
 	/*
@@ -810,7 +822,8 @@ void lru_add_drain_all(void)
 	for_each_online_cpu(cpu) {
 		struct work_struct *work = &per_cpu(lru_add_drain_work, cpu);
 
-		if (pagevec_count(&per_cpu(lru_pvecs.lru_add, cpu)) ||
+		if (force_all_cpus ||
+		    pagevec_count(&per_cpu(lru_pvecs.lru_add, cpu)) ||
 		    data_race(pagevec_count(&per_cpu(lru_rotate.pvec, cpu))) ||
 		    pagevec_count(&per_cpu(lru_pvecs.lru_deactivate_file, cpu)) ||
 		    pagevec_count(&per_cpu(lru_pvecs.lru_deactivate, cpu)) ||
@@ -828,6 +841,11 @@ void lru_add_drain_all(void)
 done:
 	mutex_unlock(&lock);
 }
+
+void lru_add_drain_all(void)
+{
+	__lru_add_drain_all(false);
+}
 #else
 void lru_add_drain_all(void)
 {
@@ -835,6 +853,34 @@ void lru_add_drain_all(void)
 }
 #endif /* CONFIG_SMP */
 
+atomic_t lru_disable_count = ATOMIC_INIT(0);
+
+/*
+ * lru_cache_disable() needs to be called before we start compiling
+ * a list of pages to be migrated using isolate_lru_page().
+ * It drains pages on LRU cache and then disable on all cpus until
+ * lru_cache_enable is called.
+ *
+ * Must be paired with a call to lru_cache_enable().
+ */
+void lru_cache_disable(void)
+{
+	atomic_inc(&lru_disable_count);
+#ifdef CONFIG_SMP
+	/*
+	 * lru_add_drain_all in the force mode will schedule draining on
+	 * all online CPUs so any calls of lru_cache_disabled wrapped by
+	 * local_lock or preemption disabled would be ordered by that.
+	 * The atomic operation doesn't need to have stronger ordering
+	 * requirements because that is enforeced by the scheduling
+	 * guarantees.
+	 */
+	__lru_add_drain_all(true);
+#else
+	lru_add_drain();
+#endif
+}
+
 /**
  * release_pages - batched put_page()
  * @pages: array of pages to release
_
