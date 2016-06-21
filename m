From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs.patch added to -mm tree
Date: Tue, 21 Jun 2016 16:28:57 -0700
Message-ID: <5769cdb9.5IrkAkA9gvxvhspB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbcFUXa0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2016 19:30:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kernel@kyup.com, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix cgroup creation failure after many small jobs
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs.patch

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
Subject: mm: memcontrol: fix cgroup creation failure after many small jobs

The memory controller has quite a bit of state that usually outlives the
cgroup and pins its CSS until said state disappears.  At the same time it
imposes a 16-bit limit on the CSS ID space to economically store IDs in
the wild.  Consequently, when we use cgroups to contain frequent but small
and short-lived jobs that leave behind some page cache, we quickly run
into the 64k limitations of outstanding CSSs.  Creating a new cgroup fails
with -ENOSPC while there are only a few, or even no user-visible cgroups
in existence.

Although pinning CSSs past cgroup removal is common, there are only two
instances that actually need an ID after a cgroup is deleted: cache shadow
entries and swapout records.

Cache shadow entries reference the ID weakly and can deal with the CSS
having disappeared when it's looked up later.  They pose no hurdle.

Swap-out records do need to pin the css to hierarchically attribute
swapins after the cgroup has been deleted; though the only pages that
remain swapped out after offlining are tmpfs/shmem pages.  And those
references are under the user's control, so they are manageable.

This patch introduces a private 16-bit memcg ID and switches swap and
cache shadow entries over to using that.  This ID can then be recycled
after offlining when the CSS remains pinned only by objects that don't
specifically need it.

This script demonstrates the problem by faulting one cache page in a new
cgroup and deleting it again:

set -e
mkdir -p pages
for x in `seq 128000`; do
  [ $((x % 1000)) -eq 0 ] && echo $x
  mkdir /cgroup/foo
  echo $$ >/cgroup/foo/cgroup.procs
  echo trex >pages/$x
  echo $$ >/cgroup/cgroup.procs
  rmdir /cgroup/foo
done

When run on an unpatched kernel, we eventually run out of possible IDs
even though there are no visible cgroups:

[root@ham ~]# ./cssidstress.sh
[...]
65000
mkdir: cannot create directory '/cgroup/foo': No space left on device

After this patch, the IDs get released upon cgroup destruction and the
cache and css objects get released once memory reclaim kicks in.

Link: http://lkml.kernel.org/r/20160617162516.GD19084@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Nikolay Borisov <kernel@kyup.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   25 ++++------
 mm/memcontrol.c            |   82 ++++++++++++++++++++++++++++++++---
 mm/slab_common.c           |    4 -
 3 files changed, 87 insertions(+), 24 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs
+++ a/include/linux/memcontrol.h
@@ -97,6 +97,11 @@ enum mem_cgroup_events_target {
 #define MEM_CGROUP_ID_SHIFT	16
 #define MEM_CGROUP_ID_MAX	USHRT_MAX
 
+struct mem_cgroup_id {
+	int id;
+	atomic_t ref;
+};
+
 struct mem_cgroup_stat_cpu {
 	long count[MEMCG_NR_STAT];
 	unsigned long events[MEMCG_NR_EVENTS];
@@ -172,6 +177,9 @@ enum memcg_kmem_state {
 struct mem_cgroup {
 	struct cgroup_subsys_state css;
 
+	/* Private memcg ID. Used to ID objects that outlive the cgroup */
+	struct mem_cgroup_id id;
+
 	/* Accounted resources */
 	struct page_counter memory;
 	struct page_counter swap;
@@ -330,22 +338,9 @@ static inline unsigned short mem_cgroup_
 	if (mem_cgroup_disabled())
 		return 0;
 
-	return memcg->css.id;
-}
-
-/**
- * mem_cgroup_from_id - look up a memcg from an id
- * @id: the id to look up
- *
- * Caller must hold rcu_read_lock() and use css_tryget() as necessary.
- */
-static inline struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
-{
-	struct cgroup_subsys_state *css;
-
-	css = css_from_id(id, &memory_cgrp_subsys);
-	return mem_cgroup_from_css(css);
+	return memcg->id.id;
 }
+struct mem_cgroup *mem_cgroup_from_id(unsigned short id);
 
 /**
  * parent_mem_cgroup - find the accounting parent of a memcg
diff -puN mm/memcontrol.c~mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs
+++ a/mm/memcontrol.c
@@ -4093,6 +4093,60 @@ static struct cftype mem_cgroup_legacy_f
 	{ },	/* terminate */
 };
 
+/*
+ * Private memory cgroup IDR
+ *
+ * Swap-out records and page cache shadow entries need to store memcg
+ * references in constrained space, so we maintain an ID space that is
+ * limited to 16 bit (MEM_CGROUP_ID_MAX), limiting the total number of
+ * memory-controlled cgroups to 64k.
+ *
+ * However, there usually are many references to the oflline CSS after
+ * the cgroup has been destroyed, such as page cache or reclaimable
+ * slab objects, that don't need to hang on to the ID. We want to keep
+ * those dead CSS from occupying IDs, or we might quickly exhaust the
+ * relatively small ID space and prevent the creation of new cgroups
+ * even when there are much fewer than 64k cgroups - possibly none.
+ *
+ * Maintain a private 16-bit ID space for memcg, and allow the ID to
+ * be freed and recycled when it's no longer needed, which is usually
+ * when the CSS is offlined.
+ *
+ * The only exception to that are records of swapped out tmpfs/shmem
+ * pages that need to be attributed to live ancestors on swapin. But
+ * those references are manageable from userspace.
+ */
+
+static struct idr mem_cgroup_idr;
+
+static void mem_cgroup_id_get(struct mem_cgroup *memcg)
+{
+	atomic_inc(&memcg->id.ref);
+}
+
+static void mem_cgroup_id_put(struct mem_cgroup *memcg)
+{
+	if (atomic_dec_and_test(&memcg->id.ref)) {
+		idr_remove(&mem_cgroup_idr, memcg->id.id);
+		memcg->id.id = 0;
+
+		/* Memcg ID pins CSS */
+		css_put(&memcg->css);
+	}
+}
+
+/**
+ * mem_cgroup_from_id - look up a memcg from a memcg id
+ * @id: the memcg id to look up
+ *
+ * Caller must hold rcu_read_lock().
+ */
+struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
+{
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	return idr_find(&mem_cgroup_idr, id);
+}
+
 static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
 {
 	struct mem_cgroup_per_node *pn;
@@ -4152,6 +4206,12 @@ static struct mem_cgroup *mem_cgroup_all
 	if (!memcg)
 		return NULL;
 
+	memcg->id.id = idr_alloc(&mem_cgroup_idr, NULL,
+				 1, MEM_CGROUP_ID_MAX,
+				 GFP_KERNEL);
+	if (memcg->id.id < 0)
+		goto fail;
+
 	memcg->stat = alloc_percpu(struct mem_cgroup_stat_cpu);
 	if (!memcg->stat)
 		goto fail;
@@ -4178,8 +4238,11 @@ static struct mem_cgroup *mem_cgroup_all
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
 #endif
+	idr_replace(&mem_cgroup_idr, memcg, memcg->id.id);
 	return memcg;
 fail:
+	if (memcg->id.id > 0)
+		idr_remove(&mem_cgroup_idr, memcg->id.id);
 	mem_cgroup_free(memcg);
 	return NULL;
 }
@@ -4242,12 +4305,11 @@ fail:
 	return ERR_PTR(-ENOMEM);
 }
 
-static int
-mem_cgroup_css_online(struct cgroup_subsys_state *css)
+static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 {
-	if (css->id > MEM_CGROUP_ID_MAX)
-		return -ENOSPC;
-
+	/* Online state pins memcg ID, memcg ID pins CSS */
+	mem_cgroup_id_get(mem_cgroup_from_css(css));
+	css_get(css);
 	return 0;
 }
 
@@ -4270,6 +4332,8 @@ static void mem_cgroup_css_offline(struc
 
 	memcg_offline_kmem(memcg);
 	wb_memcg_offline(memcg);
+
+	mem_cgroup_id_put(memcg);
 }
 
 static void mem_cgroup_css_released(struct cgroup_subsys_state *css)
@@ -5800,6 +5864,7 @@ void mem_cgroup_swapout(struct page *pag
 	if (!memcg)
 		return;
 
+	mem_cgroup_id_get(memcg);
 	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg));
 	VM_BUG_ON_PAGE(oldid, page);
 	mem_cgroup_swap_statistics(memcg, true);
@@ -5818,6 +5883,9 @@ void mem_cgroup_swapout(struct page *pag
 	VM_BUG_ON(!irqs_disabled());
 	mem_cgroup_charge_statistics(memcg, page, false, -1);
 	memcg_check_events(memcg, page);
+
+	if (!mem_cgroup_is_root(memcg))
+		css_put(&memcg->css);
 }
 
 /*
@@ -5848,11 +5916,11 @@ int mem_cgroup_try_charge_swap(struct pa
 	    !page_counter_try_charge(&memcg->swap, 1, &counter))
 		return -ENOMEM;
 
+	mem_cgroup_id_get(memcg);
 	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg));
 	VM_BUG_ON_PAGE(oldid, page);
 	mem_cgroup_swap_statistics(memcg, true);
 
-	css_get(&memcg->css);
 	return 0;
 }
 
@@ -5881,7 +5949,7 @@ void mem_cgroup_uncharge_swap(swp_entry_
 				page_counter_uncharge(&memcg->memsw, 1);
 		}
 		mem_cgroup_swap_statistics(memcg, false);
-		css_put(&memcg->css);
+		mem_cgroup_id_put(memcg);
 	}
 	rcu_read_unlock();
 }
diff -puN mm/slab_common.c~mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs mm/slab_common.c
--- a/mm/slab_common.c~mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs
+++ a/mm/slab_common.c
@@ -526,8 +526,8 @@ void memcg_create_kmem_cache(struct mem_
 		goto out_unlock;
 
 	cgroup_name(css->cgroup, memcg_name_buf, sizeof(memcg_name_buf));
-	cache_name = kasprintf(GFP_KERNEL, "%s(%d:%s)", root_cache->name,
-			       css->id, memcg_name_buf);
+	cache_name = kasprintf(GFP_KERNEL, "%s(%llu:%s)", root_cache->name,
+			       css->serial_nr, memcg_name_buf);
 	if (!cache_name)
 		goto out_unlock;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

cgroup-fix-idr-leak-for-the-first-cgroup-root.patch
cgroup-remove-unnecessary-0-check-from-css_from_id.patch
mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs.patch
mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs-fix.patch

