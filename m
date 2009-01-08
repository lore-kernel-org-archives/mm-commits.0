From: akpm@linux-foundation.org
Subject: - memcg-use-css_tryget-in-memcg.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:49:48 -0800
Message-ID: <200901082249.n08Mnmov029048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760059AbZAHW6z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:58:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: use css_tryget in memcg
has been removed from the -mm tree.  Its filename was
     memcg-use-css_tryget-in-memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: use css_tryget in memcg
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

css_tryget() newly is added and we can know css is alive or not and get
refcnt of css in very safe way.  ("alive" here means "rmdir/destroy" is
not called.)

This patch replaces css_get() to css_tryget(), where I cannot explain
why css_get() is safe. And removes memcg->obsolete flag.

Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   98 +++++++++++++++++++++++++++++-----------------
 1 file changed, 62 insertions(+), 36 deletions(-)

diff -puN mm/memcontrol.c~memcg-use-css_tryget-in-memcg mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-css_tryget-in-memcg
+++ a/mm/memcontrol.c
@@ -162,7 +162,6 @@ struct mem_cgroup {
 	 */
 	bool use_hierarchy;
 	unsigned long	last_oom_jiffies;
-	int		obsolete;
 	atomic_t	refcnt;
 
 	unsigned int	swappiness;
@@ -283,6 +282,31 @@ struct mem_cgroup *mem_cgroup_from_task(
 				struct mem_cgroup, css);
 }
 
+static struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
+{
+	struct mem_cgroup *mem = NULL;
+	/*
+	 * Because we have no locks, mm->owner's may be being moved to other
+	 * cgroup. We use css_tryget() here even if this looks
+	 * pessimistic (rather than adding locks here).
+	 */
+	rcu_read_lock();
+	do {
+		mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
+		if (unlikely(!mem))
+			break;
+	} while (!css_tryget(&mem->css));
+	rcu_read_unlock();
+	return mem;
+}
+
+static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
+{
+	if (!mem)
+		return true;
+	return css_is_removed(&mem->css);
+}
+
 /*
  * Following LRU functions are allowed to be used without PCG_LOCK.
  * Operations are called by routine of global LRU independently from memcg.
@@ -622,8 +646,9 @@ mem_cgroup_get_first_node(struct mem_cgr
 {
 	struct cgroup *cgroup;
 	struct mem_cgroup *ret;
-	bool obsolete = (root_mem->last_scanned_child &&
-				root_mem->last_scanned_child->obsolete);
+	bool obsolete;
+
+	obsolete = mem_cgroup_is_obsolete(root_mem->last_scanned_child);
 
 	/*
 	 * Scan all children under the mem_cgroup mem
@@ -636,7 +661,7 @@ mem_cgroup_get_first_node(struct mem_cgr
 
 	if (!root_mem->last_scanned_child || obsolete) {
 
-		if (obsolete)
+		if (obsolete && root_mem->last_scanned_child)
 			mem_cgroup_put(root_mem->last_scanned_child);
 
 		cgroup = list_first_entry(&root_mem->css.cgroup->children,
@@ -711,7 +736,7 @@ static int mem_cgroup_hierarchical_recla
 	next_mem = mem_cgroup_get_first_node(root_mem);
 
 	while (next_mem != root_mem) {
-		if (next_mem->obsolete) {
+		if (mem_cgroup_is_obsolete(next_mem)) {
 			mem_cgroup_put(next_mem);
 			cgroup_lock();
 			next_mem = mem_cgroup_get_first_node(root_mem);
@@ -769,23 +794,17 @@ static int __mem_cgroup_try_charge(struc
 	 * thread group leader migrates. It's possible that mm is not
 	 * set, if so charge the init_mm (happens for pagecache usage).
 	 */
-	if (likely(!*memcg)) {
-		rcu_read_lock();
-		mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
-		if (unlikely(!mem)) {
-			rcu_read_unlock();
-			return 0;
-		}
-		/*
-		 * For every charge from the cgroup, increment reference count
-		 */
-		css_get(&mem->css);
+	mem = *memcg;
+	if (likely(!mem)) {
+		mem = try_get_mem_cgroup_from_mm(mm);
 		*memcg = mem;
-		rcu_read_unlock();
 	} else {
-		mem = *memcg;
 		css_get(&mem->css);
 	}
+	if (unlikely(!mem))
+		return 0;
+
+	VM_BUG_ON(mem_cgroup_is_obsolete(mem));
 
 	while (1) {
 		int ret;
@@ -1072,12 +1091,19 @@ int mem_cgroup_cache_charge(struct page 
 				MEM_CGROUP_CHARGE_TYPE_SHMEM, NULL);
 }
 
+/*
+ * While swap-in, try_charge -> commit or cancel, the page is locked.
+ * And when try_charge() successfully returns, one refcnt to memcg without
+ * struct page_cgroup is aquired. This refcnt will be cumsumed by
+ * "commit()" or removed by "cancel()"
+ */
 int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
 				 struct page *page,
 				 gfp_t mask, struct mem_cgroup **ptr)
 {
 	struct mem_cgroup *mem;
 	swp_entry_t     ent;
+	int ret;
 
 	if (mem_cgroup_disabled())
 		return 0;
@@ -1096,10 +1122,15 @@ int mem_cgroup_try_charge_swapin(struct 
 	ent.val = page_private(page);
 
 	mem = lookup_swap_cgroup(ent);
-	if (!mem || mem->obsolete)
+	if (!mem)
+		goto charge_cur_mm;
+	if (!css_tryget(&mem->css))
 		goto charge_cur_mm;
 	*ptr = mem;
-	return __mem_cgroup_try_charge(NULL, mask, ptr, true);
+	ret = __mem_cgroup_try_charge(NULL, mask, ptr, true);
+	/* drop extra refcnt from tryget */
+	css_put(&mem->css);
+	return ret;
 charge_cur_mm:
 	if (unlikely(!mm))
 		mm = &init_mm;
@@ -1130,13 +1161,18 @@ int mem_cgroup_cache_charge_swapin(struc
 		ent.val = page_private(page);
 		if (do_swap_account) {
 			mem = lookup_swap_cgroup(ent);
-			if (mem && mem->obsolete)
-				mem = NULL;
-			if (mem)
-				mm = NULL;
+			if (mem) {
+				if (css_tryget(&mem->css))
+					mm = NULL; /* charge to recorded */
+				else
+					mem = NULL; /* charge to current */
+			}
 		}
 		ret = mem_cgroup_charge_common(page, mm, mask,
 				MEM_CGROUP_CHARGE_TYPE_SHMEM, mem);
+		/* drop extra refcnt from tryget */
+		if (mem)
+			css_put(&mem->css);
 
 		if (!ret && do_swap_account) {
 			/* avoid double counting */
@@ -1178,7 +1214,6 @@ void mem_cgroup_commit_charge_swapin(str
 		struct mem_cgroup *memcg;
 		memcg = swap_cgroup_record(ent, NULL);
 		if (memcg) {
-			/* If memcg is obsolete, memcg can be != ptr */
 			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
 			mem_cgroup_put(memcg);
 		}
@@ -1421,14 +1456,9 @@ int mem_cgroup_shrink_usage(struct mm_st
 	if (!mm)
 		return 0;
 
-	rcu_read_lock();
-	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
-	if (unlikely(!mem)) {
-		rcu_read_unlock();
+	mem = try_get_mem_cgroup_from_mm(mm);
+	if (unlikely(!mem))
 		return 0;
-	}
-	css_get(&mem->css);
-	rcu_read_unlock();
 
 	do {
 		progress = mem_cgroup_hierarchical_reclaim(mem, gfp_mask, true);
@@ -2086,9 +2116,6 @@ static struct mem_cgroup *mem_cgroup_all
  * the number of reference from swap_cgroup and free mem_cgroup when
  * it goes down to 0.
  *
- * When mem_cgroup is destroyed, mem->obsolete will be set to 0 and
- * entry which points to this memcg will be ignore at swapin.
- *
  * Removal of cgroup itself succeeds regardless of refs from swap.
  */
 
@@ -2174,7 +2201,6 @@ static void mem_cgroup_pre_destroy(struc
 					struct cgroup *cont)
 {
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
-	mem->obsolete = 1;
 	mem_cgroup_force_empty(mem, false);
 }
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch

