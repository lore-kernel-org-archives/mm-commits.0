From: akpm@linux-foundation.org
Subject: +
 mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code.patch
 added to -mm tree
Date: Fri, 24 Jun 2016 13:00:38 -0700
Message-ID: <576d9166.fa7d1sPpclfBsCa8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbcFXUAj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 16:00:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@virtuozzo.com, xiaolong.ye@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix vm-scalability regression in cgroup-aware workingset code
has been added to the -mm tree.  Its filename is
     mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: fix vm-scalability regression in cgroup-aware workingset code

23047a96d7cf ("mm: workingset: per-cgroup cache thrash detection") added a
page->mem_cgroup lookup to the cache eviction, refault, and activation
paths, as well as locking to the activation path, and the vm-scalability
tests showed a regression of -23%.  While the test in question is an
artificial worst-case scenario that doesn't occur in real workloads -
reading two sparse files in parallel at full CPU speed just to hammer the
LRU paths - there is still some optimizations that can be done in those
paths.

Inline the lookup functions to eliminate calls.  Also, page->mem_cgroup
doesn't need to be stabilized when counting an activation; we merely need
to hold the RCU lock to prevent the memcg from being freed.

This cuts down on overhead quite a bit:

23047a96d7cfcfca 063f6715e77a7be5770d6081fe
---------------- --------------------------
         %stddev     %change         %stddev
                       |                  21621405 +- 0%     +11.3%   24069657 +- 2%  vm-scalability.throughput

Link: http://lkml.kernel.org/r/20160624175101.GA3024@cmpxchg.org
Reported-by: Ye Xiaolong <xiaolong.ye@intel.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   44 ++++++++++++++++++++++++++++++++++-
 include/linux/mm.h         |    8 ++++++
 mm/memcontrol.c            |   42 ---------------------------------
 mm/workingset.c            |   10 ++++---
 4 files changed, 57 insertions(+), 47 deletions(-)

diff -puN include/linux/memcontrol.h~mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code
+++ a/include/linux/memcontrol.h
@@ -29,6 +29,7 @@
 #include <linux/mmzone.h>
 #include <linux/writeback.h>
 #include <linux/page-flags.h>
+#include <linux/mm.h>
 
 struct mem_cgroup;
 struct page;
@@ -314,7 +315,48 @@ void mem_cgroup_uncharge_list(struct lis
 
 void mem_cgroup_migrate(struct page *oldpage, struct page *newpage);
 
-struct lruvec *mem_cgroup_zone_lruvec(struct zone *, struct mem_cgroup *);
+static inline struct mem_cgroup_per_zone *
+mem_cgroup_zone_zoneinfo(struct mem_cgroup *memcg, struct zone *zone)
+{
+	int nid = zone_to_nid(zone);
+	int zid = zone_idx(zone);
+
+	return &memcg->nodeinfo[nid]->zoneinfo[zid];
+}
+
+/**
+ * mem_cgroup_zone_lruvec - get the lru list vector for a zone and memcg
+ * @zone: zone of the wanted lruvec
+ * @memcg: memcg of the wanted lruvec
+ *
+ * Returns the lru list vector holding pages for the given @zone and
+ * @mem.  This can be the global zone lruvec, if the memory controller
+ * is disabled.
+ */
+static inline struct lruvec *mem_cgroup_zone_lruvec(struct zone *zone,
+						    struct mem_cgroup *memcg)
+{
+	struct mem_cgroup_per_zone *mz;
+	struct lruvec *lruvec;
+
+	if (mem_cgroup_disabled()) {
+		lruvec = &zone->lruvec;
+		goto out;
+	}
+
+	mz = mem_cgroup_zone_zoneinfo(memcg, zone);
+	lruvec = &mz->lruvec;
+out:
+	/*
+	 * Since a node can be onlined after the mem_cgroup was created,
+	 * we have to be prepared to initialize lruvec->zone here;
+	 * and if offlined then reonlined, we need to reinitialize it.
+	 */
+	if (unlikely(lruvec->zone != zone))
+		lruvec->zone = zone;
+	return lruvec;
+}
+
 struct lruvec *mem_cgroup_page_lruvec(struct page *, struct zone *);
 
 bool task_in_mem_cgroup(struct task_struct *task, struct mem_cgroup *memcg);
diff -puN include/linux/mm.h~mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code include/linux/mm.h
--- a/include/linux/mm.h~mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code
+++ a/include/linux/mm.h
@@ -973,11 +973,19 @@ static inline struct mem_cgroup *page_me
 {
 	return page->mem_cgroup;
 }
+static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
+{
+	return READ_ONCE(page->mem_cgroup);
+}
 #else
 static inline struct mem_cgroup *page_memcg(struct page *page)
 {
 	return NULL;
 }
+static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
+{
+	return NULL;
+}
 #endif
 
 /*
diff -puN mm/memcontrol.c~mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code mm/memcontrol.c
--- a/mm/memcontrol.c~mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code
+++ a/mm/memcontrol.c
@@ -323,15 +323,6 @@ EXPORT_SYMBOL(memcg_kmem_enabled_key);
 
 #endif /* !CONFIG_SLOB */
 
-static struct mem_cgroup_per_zone *
-mem_cgroup_zone_zoneinfo(struct mem_cgroup *memcg, struct zone *zone)
-{
-	int nid = zone_to_nid(zone);
-	int zid = zone_idx(zone);
-
-	return &memcg->nodeinfo[nid]->zoneinfo[zid];
-}
-
 /**
  * mem_cgroup_css_from_page - css of the memcg associated with a page
  * @page: page of interest
@@ -944,39 +935,6 @@ static void invalidate_reclaim_iterators
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
 /**
- * mem_cgroup_zone_lruvec - get the lru list vector for a zone and memcg
- * @zone: zone of the wanted lruvec
- * @memcg: memcg of the wanted lruvec
- *
- * Returns the lru list vector holding pages for the given @zone and
- * @mem.  This can be the global zone lruvec, if the memory controller
- * is disabled.
- */
-struct lruvec *mem_cgroup_zone_lruvec(struct zone *zone,
-				      struct mem_cgroup *memcg)
-{
-	struct mem_cgroup_per_zone *mz;
-	struct lruvec *lruvec;
-
-	if (mem_cgroup_disabled()) {
-		lruvec = &zone->lruvec;
-		goto out;
-	}
-
-	mz = mem_cgroup_zone_zoneinfo(memcg, zone);
-	lruvec = &mz->lruvec;
-out:
-	/*
-	 * Since a node can be onlined after the mem_cgroup was created,
-	 * we have to be prepared to initialize lruvec->zone here;
-	 * and if offlined then reonlined, we need to reinitialize it.
-	 */
-	if (unlikely(lruvec->zone != zone))
-		lruvec->zone = zone;
-	return lruvec;
-}
-
-/**
  * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU page
  * @page: the page
  * @zone: zone of the page
diff -puN mm/workingset.c~mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code mm/workingset.c
--- a/mm/workingset.c~mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code
+++ a/mm/workingset.c
@@ -305,9 +305,10 @@ bool workingset_refault(void *shadow)
  */
 void workingset_activation(struct page *page)
 {
+	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 
-	lock_page_memcg(page);
+	rcu_read_lock();
 	/*
 	 * Filter non-memcg pages here, e.g. unmap can call
 	 * mark_page_accessed() on VDSO pages.
@@ -315,12 +316,13 @@ void workingset_activation(struct page *
 	 * XXX: See workingset_refault() - this should return
 	 * root_mem_cgroup even for !CONFIG_MEMCG.
 	 */
-	if (!mem_cgroup_disabled() && !page_memcg(page))
+	memcg = page_memcg_rcu(page);
+	if (!mem_cgroup_disabled() && !memcg)
 		goto out;
-	lruvec = mem_cgroup_zone_lruvec(page_zone(page), page_memcg(page));
+	lruvec = mem_cgroup_zone_lruvec(page_zone(page), memcg);
 	atomic_long_inc(&lruvec->inactive_age);
 out:
-	unlock_page_memcg(page);
+	rcu_read_unlock();
 }
 
 /*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

cgroup-fix-idr-leak-for-the-first-cgroup-root.patch
cgroup-remove-unnecessary-0-check-from-css_from_id.patch
mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs.patch
mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs-fix.patch
mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code.patch

