From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-decouple-reference-counting-from-page-accounting.patch added to
 -mm tree
Date: Wed, 24 Jun 2020 14:47:01 -0700
Message-ID: <20200624214701.ALRFQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731881AbgFXVrC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 17:47:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tj@kernel.org, shakeelb@google.com, mhocko@kernel.org, guro@fb.com, cl@linux.com, hannes@cmpxchg.org


The patch titled
     Subject: mm: memcontrol: decouple reference counting from page accounting
has been added to the -mm tree.  Its filename is
     mm-memcontrol-decouple-reference-counting-from-page-accounting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-decouple-reference-counting-from-page-accounting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-decouple-reference-counting-from-page-accounting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: decouple reference counting from page accounting

The reference counting of a memcg is currently coupled directly to how
many 4k pages are charged to it.  This doesn't work well with Roman's new
slab controller, which maintains pools of objects and doesn't want to keep
an extra balance sheet for the pages backing those objects.

This unusual refcounting design (reference counts usually track pointers
to an object) is only for historical reasons: memcg used to not take any
css references and simply stalled offlining until all charges had been
reparented and the page counters had dropped to zero.  When we got rid of
the reparenting requirement, the simple mechanical translation was to take
a reference for every charge.

More historical context can be found in commit e8ea14cc6ead ("mm:
memcontrol: take a css reference for each charged page"), commit
64f219938941 ("mm: memcontrol: remove obsolete kmemcg pinning tricks") and
commit b2052564e66d ("mm: memcontrol: continue cache reclaim from offlined
groups").

The new slab controller exposes the limitations in this scheme, so let's
switch it to a more idiomatic reference counting model based on actual
kernel pointers to the memcg:

- The per-cpu stock holds a reference to the memcg its caching

- User pages hold a reference for their page->mem_cgroup. Transparent
  huge pages will no longer acquire tail references in advance, we'll
  get them if needed during the split.

- Kernel pages hold a reference for their page->mem_cgroup

- Pages allocated in the root cgroup will acquire and release css
  references for simplicity. css_get() and css_put() optimize that.

- The current memcg_charge_slab() already hacked around the per-charge
  references; this change gets rid of that as well.

Roman:
1) Rebased on top of the current mm tree: added css_get() in
   mem_cgroup_charge(), dropped mem_cgroup_try_charge() part
2) I've reformatted commit references in the commit log to make
   checkpatch.pl happy.

Link: http://lkml.kernel.org/r/20200623174037.3951353-6-guro@fb.com
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   37 +++++++++++++++++++++----------------
 mm/slab.h       |    2 --
 2 files changed, 21 insertions(+), 18 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-decouple-reference-counting-from-page-accounting
+++ a/mm/memcontrol.c
@@ -2094,13 +2094,17 @@ static void drain_stock(struct memcg_sto
 {
 	struct mem_cgroup *old = stock->cached;
 
+	if (!old)
+		return;
+
 	if (stock->nr_pages) {
 		page_counter_uncharge(&old->memory, stock->nr_pages);
 		if (do_memsw_account())
 			page_counter_uncharge(&old->memsw, stock->nr_pages);
-		css_put_many(&old->css, stock->nr_pages);
 		stock->nr_pages = 0;
 	}
+
+	css_put(&old->css);
 	stock->cached = NULL;
 }
 
@@ -2136,6 +2140,7 @@ static void refill_stock(struct mem_cgro
 	stock = this_cpu_ptr(&memcg_stock);
 	if (stock->cached != memcg) { /* reset if necessary */
 		drain_stock(stock);
+		css_get(&memcg->css);
 		stock->cached = memcg;
 	}
 	stock->nr_pages += nr_pages;
@@ -2594,12 +2599,10 @@ force:
 	page_counter_charge(&memcg->memory, nr_pages);
 	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
-	css_get_many(&memcg->css, nr_pages);
 
 	return 0;
 
 done_restock:
-	css_get_many(&memcg->css, batch);
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
 
@@ -2657,8 +2660,6 @@ static void cancel_charge(struct mem_cgr
 	page_counter_uncharge(&memcg->memory, nr_pages);
 	if (do_memsw_account())
 		page_counter_uncharge(&memcg->memsw, nr_pages);
-
-	css_put_many(&memcg->css, nr_pages);
 }
 #endif
 
@@ -2966,6 +2967,7 @@ int __memcg_kmem_charge_page(struct page
 		if (!ret) {
 			page->mem_cgroup = memcg;
 			__SetPageKmemcg(page);
+			return 0;
 		}
 	}
 	css_put(&memcg->css);
@@ -2988,12 +2990,11 @@ void __memcg_kmem_uncharge_page(struct p
 	VM_BUG_ON_PAGE(mem_cgroup_is_root(memcg), page);
 	__memcg_kmem_uncharge(memcg, nr_pages);
 	page->mem_cgroup = NULL;
+	css_put(&memcg->css);
 
 	/* slab pages do not have PageKmemcg flag set */
 	if (PageKmemcg(page))
 		__ClearPageKmemcg(page);
-
-	css_put_many(&memcg->css, nr_pages);
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
@@ -3005,13 +3006,16 @@ void __memcg_kmem_uncharge_page(struct p
  */
 void mem_cgroup_split_huge_fixup(struct page *head)
 {
+	struct mem_cgroup *memcg = head->mem_cgroup;
 	int i;
 
 	if (mem_cgroup_disabled())
 		return;
 
-	for (i = 1; i < HPAGE_PMD_NR; i++)
-		head[i].mem_cgroup = head->mem_cgroup;
+	for (i = 1; i < HPAGE_PMD_NR; i++) {
+		css_get(&memcg->css);
+		head[i].mem_cgroup = memcg;
+	}
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -5456,7 +5460,10 @@ static int mem_cgroup_move_account(struc
 	 */
 	smp_mb();
 
-	page->mem_cgroup = to; 	/* caller should have done css_get */
+	css_get(&to->css);
+	css_put(&from->css);
+
+	page->mem_cgroup = to;
 
 	__unlock_page_memcg(from);
 
@@ -6506,6 +6513,7 @@ int mem_cgroup_charge(struct page *page,
 	if (ret)
 		goto out_put;
 
+	css_get(&memcg->css);
 	commit_charge(page, memcg);
 
 	local_irq_disable();
@@ -6560,9 +6568,6 @@ static void uncharge_batch(const struct
 	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, ug->nr_pages);
 	memcg_check_events(ug->memcg, ug->dummy_page);
 	local_irq_restore(flags);
-
-	if (!mem_cgroup_is_root(ug->memcg))
-		css_put_many(&ug->memcg->css, ug->nr_pages);
 }
 
 static void uncharge_page(struct page *page, struct uncharge_gather *ug)
@@ -6600,6 +6605,7 @@ static void uncharge_page(struct page *p
 
 	ug->dummy_page = page;
 	page->mem_cgroup = NULL;
+	css_put(&ug->memcg->css);
 }
 
 static void uncharge_list(struct list_head *page_list)
@@ -6705,8 +6711,8 @@ void mem_cgroup_migrate(struct page *old
 	page_counter_charge(&memcg->memory, nr_pages);
 	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
-	css_get_many(&memcg->css, nr_pages);
 
+	css_get(&memcg->css);
 	commit_charge(newpage, memcg);
 
 	local_irq_save(flags);
@@ -6943,8 +6949,7 @@ void mem_cgroup_swapout(struct page *pag
 	mem_cgroup_charge_statistics(memcg, page, -nr_entries);
 	memcg_check_events(memcg, page);
 
-	if (!mem_cgroup_is_root(memcg))
-		css_put_many(&memcg->css, nr_entries);
+	css_put(&memcg->css);
 }
 
 /**
--- a/mm/slab.h~mm-memcontrol-decouple-reference-counting-from-page-accounting
+++ a/mm/slab.h
@@ -401,9 +401,7 @@ static __always_inline int memcg_charge_
 	lruvec = mem_cgroup_lruvec(memcg, page_pgdat(page));
 	mod_lruvec_state(lruvec, cache_vmstat_idx(s), nr_pages << PAGE_SHIFT);
 
-	/* transer try_charge() page references to kmem_cache */
 	percpu_ref_get_many(&s->memcg_params.refcnt, nr_pages);
-	css_put_many(&memcg->css, nr_pages);
 out:
 	css_put(&memcg->css);
 	return ret;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-handle-div0-crash-race-condition-in-memorylow.patch
mm-workingset-age-nonresident-information-alongside-anonymous-pages.patch
mm-memcontrol-decouple-reference-counting-from-page-accounting.patch
