From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs.patch
 removed from -mm tree
Date: Tue, 21 Jun 2016 16:26:03 -0700
Message-ID: <5769cd0b.NSpnzt5gbyelay5s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbcFUXv5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2016 19:51:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, lizefan@huawei.com, mhocko@suse.cz, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix cgroup creation failure after many small jobs
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs.patch

This patch was dropped because an updated version will be merged

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
instances that actually need a CSS ID after a cgroup is deleted: cache
shadow entries and swapout records.

Cache shadow entries reference the ID weakly and can deal with the CSS
having disappeared when it's looked up later.  They pose no hurdle.

Swap-out records do need to pin the css to hierarchically attribute
swapins after the cgroup has been deleted; though the only pages that
remain swapped out after a process exits are tmpfs/shmem pages.  Those
references are under the user's control and thus manageable.

This patch introduces a private 16bit memcg ID and switches swap and cache
shadow entries over to using that.  It then decouples the CSS lifetime
from the CSS ID lifetime, such that a CSS ID can be recycled when the CSS
is only pinned by common objects that don't need an ID.

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

When run on an unpatched kernel, we eventually run out of possible CSS IDs
even though there is no visible cgroup existing anymore:

[root@ham ~]# ./cssidstress.sh
[...]
65000
mkdir: cannot create directory '/cgroup/foo': No space left on device

After this patch, the CSS IDs get released upon cgroup destruction and
the cache and css objects get released once memory reclaim kicks in.

Link: http://lkml.kernel.org/r/20160616034244.14839-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h     |    3 +
 include/linux/memcontrol.h |   25 ++++++---------
 kernel/cgroup.c            |   22 ++++++++++++-
 mm/memcontrol.c            |   56 ++++++++++++++++++++++++++++++-----
 mm/slab_common.c           |    4 +-
 5 files changed, 83 insertions(+), 27 deletions(-)

diff -puN include/linux/cgroup.h~mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs include/linux/cgroup.h
--- a/include/linux/cgroup.h~mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs
+++ a/include/linux/cgroup.h
@@ -85,9 +85,10 @@ struct cgroup_subsys_state *cgroup_get_e
 					     struct cgroup_subsys *ss);
 struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
 						       struct cgroup_subsys *ss);
-
 struct cgroup *cgroup_get_from_path(const char *path);
 
+void css_id_free(struct cgroup_subsys_state *css);
+
 int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
 int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from);
 
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
diff -puN kernel/cgroup.c~mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs kernel/cgroup.c
--- a/kernel/cgroup.c~mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs
+++ a/kernel/cgroup.c
@@ -4961,10 +4961,10 @@ static void css_free_work_fn(struct work
 	if (ss) {
 		/* css free path */
 		struct cgroup_subsys_state *parent = css->parent;
-		int id = css->id;
 
 		ss->css_free(css);
-		cgroup_idr_remove(&ss->css_idr, id);
+		if (css->id)
+			cgroup_idr_remove(&ss->css_idr, css->id);
 		cgroup_put(cgrp);
 
 		if (parent)
@@ -6205,6 +6205,24 @@ struct cgroup *cgroup_get_from_path(cons
 }
 EXPORT_SYMBOL_GPL(cgroup_get_from_path);
 
+/**
+ * css_id_free - relinquish an existing CSS's ID
+ * @css: the CSS
+ *
+ * This releases the @css's ID and allows it to be recycled while the
+ * CSS continues to exist. This is useful for controllers with state
+ * that extends past a cgroup's lifetime but doesn't need precious ID
+ * address space.
+ *
+ * This invalidates @css->id, and css_from_id() might return NULL or a
+ * new css if the ID has been recycled in the meantime.
+ */
+void css_id_free(struct cgroup_subsys_state *css)
+{
+	cgroup_idr_remove(&css->ss->css_idr, css->id);
+	css->id = 0;
+}
+
 /*
  * sock->sk_cgrp_data handling.  For more info, see sock_cgroup_data
  * definition in cgroup-defs.h.
diff -puN mm/memcontrol.c~mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs
+++ a/mm/memcontrol.c
@@ -4093,6 +4093,34 @@ static struct cftype mem_cgroup_legacy_f
 	{ },	/* terminate */
 };
 
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
+		css_id_free(&memcg->css);
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
+	return id > 0 ? idr_find(&mem_cgroup_idr, id) : NULL;
+}
+
 static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
 {
 	struct mem_cgroup_per_node *pn;
@@ -4152,6 +4180,12 @@ static struct mem_cgroup *mem_cgroup_all
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
@@ -4178,8 +4212,11 @@ static struct mem_cgroup *mem_cgroup_all
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
@@ -4242,12 +4279,11 @@ fail:
 	return ERR_PTR(-ENOMEM);
 }
 
-static int
-mem_cgroup_css_online(struct cgroup_subsys_state *css)
+static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 {
-	if (css->id > MEM_CGROUP_ID_MAX)
-		return -ENOSPC;
-
+	/* Online state pins memcg ID, memcg ID pins CSS and CSS ID */
+	mem_cgroup_id_get(mem_cgroup_from_css(css));
+	css_get(css);
 	return 0;
 }
 
@@ -4270,6 +4306,8 @@ static void mem_cgroup_css_offline(struc
 
 	memcg_offline_kmem(memcg);
 	wb_memcg_offline(memcg);
+
+	mem_cgroup_id_put(memcg);
 }
 
 static void mem_cgroup_css_released(struct cgroup_subsys_state *css)
@@ -5800,6 +5838,7 @@ void mem_cgroup_swapout(struct page *pag
 	if (!memcg)
 		return;
 
+	mem_cgroup_id_get(memcg);
 	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg));
 	VM_BUG_ON_PAGE(oldid, page);
 	mem_cgroup_swap_statistics(memcg, true);
@@ -5818,6 +5857,9 @@ void mem_cgroup_swapout(struct page *pag
 	VM_BUG_ON(!irqs_disabled());
 	mem_cgroup_charge_statistics(memcg, page, false, -1);
 	memcg_check_events(memcg, page);
+
+	if (!mem_cgroup_is_root(memcg))
+		css_put(&memcg->css);
 }
 
 /*
@@ -5848,11 +5890,11 @@ int mem_cgroup_try_charge_swap(struct pa
 	    !page_counter_try_charge(&memcg->swap, 1, &counter))
 		return -ENOMEM;
 
+	mem_cgroup_id_get(memcg);
 	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg));
 	VM_BUG_ON_PAGE(oldid, page);
 	mem_cgroup_swap_statistics(memcg, true);
 
-	css_get(&memcg->css);
 	return 0;
 }
 
@@ -5881,7 +5923,7 @@ void mem_cgroup_uncharge_swap(swp_entry_
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
mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs-fix.patch

