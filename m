From: akpm@linux-foundation.org
Subject: [wrecked]
 mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code.patch
 removed from -mm tree
Date: Thu, 23 Jun 2016 14:53:05 -0700
Message-ID: <576c5a41.14+V+yQPT/LN2v5B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbcFWVxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jun 2016 17:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@virtuozzo.com, xiaolong.ye@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix vm-scalability regression in cgroup-aware working=
set code
has been removed from the -mm tree.  Its filename was
     mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code.p=
atch

This patch was dropped because other changes were merged, which wrecked=
 this patch

------------------------------------------------------
=46rom: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: fix vm-scalability regression in cgroup-aware workingset c=
ode

23047a96d7cf ("mm: workingset: per-cgroup cache thrash detection") adde=
d a
page->mem_cgroup lookup to the cache eviction, refault, and activation
paths, as well as locking to the activation path, and the vm-scalabilit=
y
tests showed a regression of -23%.  While the test in question is an
artificial worst-case scenario that doesn't occur in real workloads -
reading two sparse files in parallel at full CPU speed just to hammer t=
he
LRU paths - there is still some optimizations that can be done in those
paths.

Inline the lookup functions to eliminate calls.  Also, page->mem_cgroup
doesn't need to be stabilized when counting an activation; we merely ne=
ed
to hold the RCU lock to prevent the memcg from being freed.

This cuts down on overhead quite a bit:

23047a96d7cfcfca 063f6715e77a7be5770d6081fe
---------------- --------------------------
         %stddev     %change         %stddev
                       |                  21621405 =C2=B1  0%     +11.3=
%   24069657 =C2=B1  2%  vm-scalability.throughput

Link: http://lkml.kernel.org/r/20160622182019.24064-1-hannes@cmpxchg.or=
g
Reported-by: Ye Xiaolong <xiaolong.ye@intel.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   39 ++++++++++++++++++++++++++++++++++-
 include/linux/mm.h         |    8 +++++++
 mm/memcontrol.c            |   39 -----------------------------------
 mm/workingset.c            |   10 +++++---
 4 files changed, 52 insertions(+), 44 deletions(-)

diff -puN include/linux/memcontrol.h~mm-fix-vm-scalability-regression-i=
n-cgroup-aware-workingset-code include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-fix-vm-scalability-regression-in-cg=
roup-aware-workingset-code
+++ a/include/linux/memcontrol.h
@@ -310,7 +310,44 @@ void mem_cgroup_uncharge_list(struct lis
=20
 void mem_cgroup_migrate(struct page *oldpage, struct page *newpage);
=20
-struct lruvec *mem_cgroup_lruvec(struct pglist_data *, struct mem_cgro=
up *);
+static inline struct mem_cgroup_per_node *
+mem_cgroup_nodeinfo(struct mem_cgroup *memcg, int nid)
+{
+	return memcg->nodeinfo[nid];
+}
+
+/**
+ * mem_cgroup_lruvec - get the lru list vector for a memcg node
+ * @node: node of the wanted lruvec
+ * @memcg: memcg of the wanted lruvec
+ *
+ * Returns the lru list vector holding pages for a given @node and @me=
mcg.
+ * This can be the node lruvec, if the memory controller is disabled.
+ */
+static inline struct lruvec *mem_cgroup_lruvec(struct pglist_data *pgd=
at,
+					       struct mem_cgroup *memcg)
+{
+	struct mem_cgroup_per_node *mz;
+	struct lruvec *lruvec;
+
+	if (mem_cgroup_disabled()) {
+		lruvec =3D node_lruvec(pgdat);
+		goto out;
+	}
+
+	mz =3D mem_cgroup_nodeinfo(memcg, pgdat->node_id);
+	lruvec =3D &mz->lruvec;
+out:
+	/*
+	 * Since a node can be onlined after the mem_cgroup was created,
+	 * we have to be prepared to initialize lruvec->zone here;
+	 * and if offlined then reonlined, we need to reinitialize it.
+	 */
+	if (unlikely(lruvec->pgdat !=3D pgdat))
+		lruvec->pgdat =3D pgdat;
+	return lruvec;
+}
+
 struct lruvec *mem_cgroup_page_lruvec(struct page *, struct pglist_dat=
a *);
=20
 bool task_in_mem_cgroup(struct task_struct *task, struct mem_cgroup *m=
emcg);
diff -puN include/linux/mm.h~mm-fix-vm-scalability-regression-in-cgroup=
-aware-workingset-code include/linux/mm.h
--- a/include/linux/mm.h~mm-fix-vm-scalability-regression-in-cgroup-awa=
re-workingset-code
+++ a/include/linux/mm.h
@@ -978,11 +978,19 @@ static inline struct mem_cgroup *page_me
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
=20
 /*
diff -puN mm/memcontrol.c~mm-fix-vm-scalability-regression-in-cgroup-aw=
are-workingset-code mm/memcontrol.c
--- a/mm/memcontrol.c~mm-fix-vm-scalability-regression-in-cgroup-aware-=
workingset-code
+++ a/mm/memcontrol.c
@@ -319,12 +319,6 @@ EXPORT_SYMBOL(memcg_kmem_enabled_key);
=20
 #endif /* !CONFIG_SLOB */
=20
-static struct mem_cgroup_per_node *
-mem_cgroup_nodeinfo(struct mem_cgroup *memcg, int nid)
-{
-	return memcg->nodeinfo[nid];
-}
-
 /**
  * mem_cgroup_css_from_page - css of the memcg associated with a page
  * @page: page of interest
@@ -927,39 +921,6 @@ static void invalidate_reclaim_iterators
 	     iter =3D mem_cgroup_iter(NULL, iter, NULL))
=20
 /**
- * mem_cgroup_lruvec - get the lru list vector for a node or a memcg z=
one
- * @node: node of the wanted lruvec
- * @memcg: memcg of the wanted lruvec
- *
- * Returns the lru list vector holding pages for a given @node or a gi=
ven
- * @memcg and @zone. This can be the node lruvec, if the memory contro=
ller
- * is disabled.
- */
-struct lruvec *mem_cgroup_lruvec(struct pglist_data *pgdat,
-				 struct mem_cgroup *memcg)
-{
-	struct mem_cgroup_per_node *mz;
-	struct lruvec *lruvec;
-
-	if (mem_cgroup_disabled()) {
-		lruvec =3D node_lruvec(pgdat);
-		goto out;
-	}
-
-	mz =3D mem_cgroup_nodeinfo(memcg, pgdat->node_id);
-	lruvec =3D &mz->lruvec;
-out:
-	/*
-	 * Since a node can be onlined after the mem_cgroup was created,
-	 * we have to be prepared to initialize lruvec->zone here;
-	 * and if offlined then reonlined, we need to reinitialize it.
-	 */
-	if (unlikely(lruvec->pgdat !=3D pgdat))
-		lruvec->pgdat =3D pgdat;
-	return lruvec;
-}
-
-/**
  * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU=
 page
  * @page: the page
  * @zone: zone of the page
diff -puN mm/workingset.c~mm-fix-vm-scalability-regression-in-cgroup-aw=
are-workingset-code mm/workingset.c
--- a/mm/workingset.c~mm-fix-vm-scalability-regression-in-cgroup-aware-=
workingset-code
+++ a/mm/workingset.c
@@ -302,9 +302,10 @@ bool workingset_refault(void *shadow)
  */
 void workingset_activation(struct page *page)
 {
+	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
=20
-	lock_page_memcg(page);
+	rcu_read_lock();
 	/*
 	 * Filter non-memcg pages here, e.g. unmap can call
 	 * mark_page_accessed() on VDSO pages.
@@ -312,12 +313,13 @@ void workingset_activation(struct page *
 	 * XXX: See workingset_refault() - this should return
 	 * root_mem_cgroup even for !CONFIG_MEMCG.
 	 */
-	if (!mem_cgroup_disabled() && !page_memcg(page))
+	memcg =3D page_memcg_rcu(page);
+	if (!mem_cgroup_disabled() && !memcg)
 		goto out;
-	lruvec =3D mem_cgroup_lruvec(page_pgdat(page), page_memcg(page));
+	lruvec =3D mem_cgroup_lruvec(page_pgdat(page), memcg);
 	atomic_long_inc(&lruvec->inactive_age);
 out:
-	unlock_page_memcg(page);
+	rcu_read_unlock();
 }
=20
 /*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

cgroup-fix-idr-leak-for-the-first-cgroup-root.patch
cgroup-remove-unnecessary-0-check-from-css_from_id.patch
mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs.patch
mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs-fix.pat=
ch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
