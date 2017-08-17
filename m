From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-allow-to-uncharge-page-without-using-page-lru-field.patch
 added to -mm tree
Date: Thu, 17 Aug 2017 14:41:58 -0700
Message-ID: <59960da6.bfQWlGehTXsxHmiC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40544 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753796AbdHQVmA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Aug 2017 17:42:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, SCheung@nvidia.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, bsingharora@gmail.com, dan.j.williams@intel.com, dnellans@nvidia.com, ebaskakov@nvidia.com, hannes@cmpxchg.org, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mhairgrove@nvidia.com, mhocko@kernel.org, paulmck@linux.vnet.ibm.com, ross.zwisler@linux.intel.com, sgutti@nvidia.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol: allow to uncharge page without using page->lru field
has been added to the -mm tree.  Its filename is
     mm-memcontrol-allow-to-uncharge-page-without-using-page-lru-field.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-allow-to-uncharge-page-without-using-page-lru-field.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-allow-to-uncharge-page-without-using-page-lru-field.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/memcontrol: allow to uncharge page without using page->lru field

HMM pages (private or public device pages) are ZONE_DEVICE page and
thus you can not use page->lru fields of those pages. This patch
re-arrange the uncharge to allow single page to be uncharge without
modifying the lru field of the struct page.

There is no change to memcontrol logic, it is the same as it was
before this patch.

Link: http://lkml.kernel.org/r/20170817000548.32038-10-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Evgeny Baskakov <ebaskakov@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mark Hairgrove <mhairgrove@nvidia.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Sherry Cheung <SCheung@nvidia.com>
Cc: Subhash Gutti <sgutti@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  168 +++++++++++++++++++++++++---------------------
 1 file changed, 92 insertions(+), 76 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-allow-to-uncharge-page-without-using-page-lru-field mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-allow-to-uncharge-page-without-using-page-lru-field
+++ a/mm/memcontrol.c
@@ -5540,48 +5540,102 @@ void mem_cgroup_cancel_charge(struct pag
 	cancel_charge(memcg, nr_pages);
 }
 
-static void uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
-			   unsigned long nr_anon, unsigned long nr_file,
-			   unsigned long nr_kmem, unsigned long nr_huge,
-			   unsigned long nr_shmem, struct page *dummy_page)
+struct uncharge_gather {
+	struct mem_cgroup *memcg;
+	unsigned long pgpgout;
+	unsigned long nr_anon;
+	unsigned long nr_file;
+	unsigned long nr_kmem;
+	unsigned long nr_huge;
+	unsigned long nr_shmem;
+	struct page *dummy_page;
+};
+
+static inline void uncharge_gather_clear(struct uncharge_gather *ug)
+{
+	memset(ug, 0, sizeof(*ug));
+}
+
+static void uncharge_batch(const struct uncharge_gather *ug)
 {
-	unsigned long nr_pages = nr_anon + nr_file + nr_kmem;
+	unsigned long nr_pages = ug->nr_anon + ug->nr_file + ug->nr_kmem;
 	unsigned long flags;
 
-	if (!mem_cgroup_is_root(memcg)) {
-		page_counter_uncharge(&memcg->memory, nr_pages);
+	if (!mem_cgroup_is_root(ug->memcg)) {
+		page_counter_uncharge(&ug->memcg->memory, nr_pages);
 		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, nr_pages);
-		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && nr_kmem)
-			page_counter_uncharge(&memcg->kmem, nr_kmem);
-		memcg_oom_recover(memcg);
+			page_counter_uncharge(&ug->memcg->memsw, nr_pages);
+		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && ug->nr_kmem)
+			page_counter_uncharge(&ug->memcg->kmem, ug->nr_kmem);
+		memcg_oom_recover(ug->memcg);
 	}
 
 	local_irq_save(flags);
-	__this_cpu_sub(memcg->stat->count[MEMCG_RSS], nr_anon);
-	__this_cpu_sub(memcg->stat->count[MEMCG_CACHE], nr_file);
-	__this_cpu_sub(memcg->stat->count[MEMCG_RSS_HUGE], nr_huge);
-	__this_cpu_sub(memcg->stat->count[NR_SHMEM], nr_shmem);
-	__this_cpu_add(memcg->stat->events[PGPGOUT], pgpgout);
-	__this_cpu_add(memcg->stat->nr_page_events, nr_pages);
-	memcg_check_events(memcg, dummy_page);
+	__this_cpu_sub(ug->memcg->stat->count[MEMCG_RSS], ug->nr_anon);
+	__this_cpu_sub(ug->memcg->stat->count[MEMCG_CACHE], ug->nr_file);
+	__this_cpu_sub(ug->memcg->stat->count[MEMCG_RSS_HUGE], ug->nr_huge);
+	__this_cpu_sub(ug->memcg->stat->count[NR_SHMEM], ug->nr_shmem);
+	__this_cpu_add(ug->memcg->stat->events[PGPGOUT], ug->pgpgout);
+	__this_cpu_add(ug->memcg->stat->nr_page_events, nr_pages);
+	memcg_check_events(ug->memcg, ug->dummy_page);
 	local_irq_restore(flags);
 
-	if (!mem_cgroup_is_root(memcg))
-		css_put_many(&memcg->css, nr_pages);
+	if (!mem_cgroup_is_root(ug->memcg))
+		css_put_many(&ug->memcg->css, nr_pages);
+}
+
+static void uncharge_page(struct page *page, struct uncharge_gather *ug)
+{
+	VM_BUG_ON_PAGE(PageLRU(page), page);
+	VM_BUG_ON_PAGE(!PageHWPoison(page) && page_count(page), page);
+
+	if (!page->mem_cgroup)
+		return;
+
+	/*
+	 * Nobody should be changing or seriously looking at
+	 * page->mem_cgroup at this point, we have fully
+	 * exclusive access to the page.
+	 */
+
+	if (ug->memcg != page->mem_cgroup) {
+		if (ug->memcg) {
+			uncharge_batch(ug);
+			uncharge_gather_clear(ug);
+		}
+		ug->memcg = page->mem_cgroup;
+	}
+
+	if (!PageKmemcg(page)) {
+		unsigned int nr_pages = 1;
+
+		if (PageTransHuge(page)) {
+			nr_pages <<= compound_order(page);
+			ug->nr_huge += nr_pages;
+		}
+		if (PageAnon(page))
+			ug->nr_anon += nr_pages;
+		else {
+			ug->nr_file += nr_pages;
+			if (PageSwapBacked(page))
+				ug->nr_shmem += nr_pages;
+		}
+		ug->pgpgout++;
+	} else {
+		ug->nr_kmem += 1 << compound_order(page);
+		__ClearPageKmemcg(page);
+	}
+
+	ug->dummy_page = page;
+	page->mem_cgroup = NULL;
 }
 
 static void uncharge_list(struct list_head *page_list)
 {
-	struct mem_cgroup *memcg = NULL;
-	unsigned long nr_shmem = 0;
-	unsigned long nr_anon = 0;
-	unsigned long nr_file = 0;
-	unsigned long nr_huge = 0;
-	unsigned long nr_kmem = 0;
-	unsigned long pgpgout = 0;
+	struct uncharge_gather ug;
 	struct list_head *next;
-	struct page *page;
+
+	uncharge_gather_clear(&ug);
 
 	/*
 	 * Note that the list can be a single page->lru; hence the
@@ -5589,57 +5643,16 @@ static void uncharge_list(struct list_he
 	 */
 	next = page_list->next;
 	do {
+		struct page *page;
+
 		page = list_entry(next, struct page, lru);
 		next = page->lru.next;
 
-		VM_BUG_ON_PAGE(PageLRU(page), page);
-		VM_BUG_ON_PAGE(!PageHWPoison(page) && page_count(page), page);
-
-		if (!page->mem_cgroup)
-			continue;
-
-		/*
-		 * Nobody should be changing or seriously looking at
-		 * page->mem_cgroup at this point, we have fully
-		 * exclusive access to the page.
-		 */
-
-		if (memcg != page->mem_cgroup) {
-			if (memcg) {
-				uncharge_batch(memcg, pgpgout, nr_anon, nr_file,
-					       nr_kmem, nr_huge, nr_shmem, page);
-				pgpgout = nr_anon = nr_file = nr_kmem = 0;
-				nr_huge = nr_shmem = 0;
-			}
-			memcg = page->mem_cgroup;
-		}
-
-		if (!PageKmemcg(page)) {
-			unsigned int nr_pages = 1;
-
-			if (PageTransHuge(page)) {
-				nr_pages <<= compound_order(page);
-				nr_huge += nr_pages;
-			}
-			if (PageAnon(page))
-				nr_anon += nr_pages;
-			else {
-				nr_file += nr_pages;
-				if (PageSwapBacked(page))
-					nr_shmem += nr_pages;
-			}
-			pgpgout++;
-		} else {
-			nr_kmem += 1 << compound_order(page);
-			__ClearPageKmemcg(page);
-		}
-
-		page->mem_cgroup = NULL;
+		uncharge_page(page, &ug);
 	} while (next != page_list);
 
-	if (memcg)
-		uncharge_batch(memcg, pgpgout, nr_anon, nr_file,
-			       nr_kmem, nr_huge, nr_shmem, page);
+	if (ug.memcg)
+		uncharge_batch(&ug);
 }
 
 /**
@@ -5651,6 +5664,8 @@ static void uncharge_list(struct list_he
  */
 void mem_cgroup_uncharge(struct page *page)
 {
+	struct uncharge_gather ug;
+
 	if (mem_cgroup_disabled())
 		return;
 
@@ -5658,8 +5673,9 @@ void mem_cgroup_uncharge(struct page *pa
 	if (!page->mem_cgroup)
 		return;
 
-	INIT_LIST_HEAD(&page->lru);
-	uncharge_list(&page->lru);
+	uncharge_gather_clear(&ug);
+	uncharge_page(page, &ug);
+	uncharge_batch(&ug);
 }
 
 /**
_

Patches currently in -mm which might be from jglisse@redhat.com are

hmm-heterogeneous-memory-management-documentation-v3.patch
mm-hmm-heterogeneous-memory-management-hmm-for-short-v5.patch
mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers-v3.patch
mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v4.patch
mm-hmm-mirror-device-page-fault-handler.patch
mm-zone_device-new-type-of-zone_device-for-unaddressable-memory-v5.patch
mm-zone_device-special-case-put_page-for-device-private-pages-v4.patch
mm-memcontrol-allow-to-uncharge-page-without-using-page-lru-field.patch
mm-memcontrol-support-memory_device_private-v4.patch
mm-hmm-devmem-device-memory-hotplug-using-zone_device-v7.patch
mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v3.patch
mm-migrate-new-migrate-mode-migrate_sync_no_copy.patch
mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v5.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
mm-migrate-support-un-addressable-zone_device-page-in-migration-v3.patch
mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-v4.patch
mm-device-public-memory-device-memory-cache-coherent-with-cpu-v5.patch
mm-hmm-add-new-helper-to-hotplug-cdm-memory-region-v3.patch
lib-interval_tree-fast-overlap-detection-fix.patch

