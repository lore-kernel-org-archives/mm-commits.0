Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01554C142
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141612; cv=none; b=kB2YfeMobAhHBc8cGI+wBbowZeoccPWbNb7pyMk5PsRklTJbFXLpgkgbz9rPkhfM2yXiqTL1GcvA5t548ZnLZW4S6rSoVVtRVTtm9gaEPMjFgAzLN/B3kMPIv06kQ3ZsC7BOxtuFsP16IGLSqIyB9O7JPBzdJyGBxHvcMk0a71A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141612; c=relaxed/simple;
	bh=e3q1Dwyykwt6Ucjbe/GEpSwDPfoDWp+o5HWba/KavE4=;
	h=Date:To:From:Subject:Message-Id; b=hAMLdwd6o/h/DXWm9IOAOGjf9tvUSce4AtW961LqaMfwdRmcA+NO2OkGOXyElVIx/RaCFE5z1nU41syEm61lfxNOKUJusqlUBWDYMecrNcAN2o7vZnE+JCSaxxTUVyOKAYuSv12sQ6sKRuV3KKG2VH2aiTFm3VLHy+hd7Qo9q4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vNTnd+dC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vNTnd+dC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F27C3277B;
	Fri,  5 Jul 2024 01:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141611;
	bh=e3q1Dwyykwt6Ucjbe/GEpSwDPfoDWp+o5HWba/KavE4=;
	h=Date:To:From:Subject:From;
	b=vNTnd+dCsRKTw/zQTeNWMsLbKqAyAzjHNOh0z0EVT6QMYDnaeTVPekVHTfO6mQDlV
	 9PeboxQ/68wuNGMsQCd0WO5MkARZxYOottdcrsNKhYKgW6AapQtFpzj7T19fQbXDXQ
	 L2f+CCfkeoqZ5ZkbfE0jf3AoUQ+FQKeG8MctZMco=
Date: Thu, 04 Jul 2024 18:06:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-group-cgroup-v1-memcg-related-declarations.patch removed from -mm tree
Message-Id: <20240705010651.C8F27C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: group cgroup v1 memcg related declarations
has been removed from the -mm tree.  Its filename was
     mm-memcg-group-cgroup-v1-memcg-related-declarations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: group cgroup v1 memcg related declarations
Date: Mon, 24 Jun 2024 17:59:04 -0700

Group all cgroup v1-related declarations at the end of memcontrol.h and
mm/memcontrol-v1.h with an intention to put them all together under a
config option later on.  It should make things easier to follow and
maintain too.

Link: https://lkml.kernel.org/r/20240625005906.106920-13-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |  144 ++++++++++++++++++-----------------
 mm/memcontrol-v1.h         |   87 +++++++++++----------
 2 files changed, 122 insertions(+), 109 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-group-cgroup-v1-memcg-related-declarations
+++ a/include/linux/memcontrol.h
@@ -950,39 +950,13 @@ static inline void mem_cgroup_exit_user_
 	current->in_user_fault = 0;
 }
 
-static inline bool task_in_memcg_oom(struct task_struct *p)
-{
-	return p->memcg_in_oom;
-}
-
-bool mem_cgroup_oom_synchronize(bool wait);
 struct mem_cgroup *mem_cgroup_get_oom_group(struct task_struct *victim,
 					    struct mem_cgroup *oom_domain);
 void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 
-void folio_memcg_lock(struct folio *folio);
-void folio_memcg_unlock(struct folio *folio);
-
 void __mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
 		       int val);
 
-/* try to stablize folio_memcg() for all the pages in a memcg */
-static inline bool mem_cgroup_trylock_pages(struct mem_cgroup *memcg)
-{
-	rcu_read_lock();
-
-	if (mem_cgroup_disabled() || !atomic_read(&memcg->moving_account))
-		return true;
-
-	rcu_read_unlock();
-	return false;
-}
-
-static inline void mem_cgroup_unlock_pages(void)
-{
-	rcu_read_unlock();
-}
-
 /* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline void mod_memcg_state(struct mem_cgroup *memcg,
 				   enum memcg_stat_item idx, int val)
@@ -1109,10 +1083,6 @@ static inline void memcg_memory_event_mm
 
 void split_page_memcg(struct page *head, int old_order, int new_order);
 
-unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
-					gfp_t gfp_mask,
-					unsigned long *total_scanned);
-
 #else /* CONFIG_MEMCG */
 
 #define MEM_CGROUP_ID_SHIFT	0
@@ -1423,26 +1393,6 @@ mem_cgroup_print_oom_meminfo(struct mem_
 {
 }
 
-static inline void folio_memcg_lock(struct folio *folio)
-{
-}
-
-static inline void folio_memcg_unlock(struct folio *folio)
-{
-}
-
-static inline bool mem_cgroup_trylock_pages(struct mem_cgroup *memcg)
-{
-	/* to match folio_memcg_rcu() */
-	rcu_read_lock();
-	return true;
-}
-
-static inline void mem_cgroup_unlock_pages(void)
-{
-	rcu_read_unlock();
-}
-
 static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 {
 }
@@ -1455,16 +1405,6 @@ static inline void mem_cgroup_exit_user_
 {
 }
 
-static inline bool task_in_memcg_oom(struct task_struct *p)
-{
-	return false;
-}
-
-static inline bool mem_cgroup_oom_synchronize(bool wait)
-{
-	return false;
-}
-
 static inline struct mem_cgroup *mem_cgroup_get_oom_group(
 	struct task_struct *victim, struct mem_cgroup *oom_domain)
 {
@@ -1558,14 +1498,6 @@ void count_memcg_event_mm(struct mm_stru
 static inline void split_page_memcg(struct page *head, int old_order, int new_order)
 {
 }
-
-static inline
-unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
-					gfp_t gfp_mask,
-					unsigned long *total_scanned)
-{
-	return 0;
-}
 #endif /* CONFIG_MEMCG */
 
 /*
@@ -1916,4 +1848,80 @@ static inline bool mem_cgroup_zswap_writ
 }
 #endif
 
+
+/* Cgroup v1-related declarations */
+
+#ifdef CONFIG_MEMCG
+unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
+					gfp_t gfp_mask,
+					unsigned long *total_scanned);
+
+bool mem_cgroup_oom_synchronize(bool wait);
+
+static inline bool task_in_memcg_oom(struct task_struct *p)
+{
+	return p->memcg_in_oom;
+}
+
+void folio_memcg_lock(struct folio *folio);
+void folio_memcg_unlock(struct folio *folio);
+
+/* try to stablize folio_memcg() for all the pages in a memcg */
+static inline bool mem_cgroup_trylock_pages(struct mem_cgroup *memcg)
+{
+	rcu_read_lock();
+
+	if (mem_cgroup_disabled() || !atomic_read(&memcg->moving_account))
+		return true;
+
+	rcu_read_unlock();
+	return false;
+}
+
+static inline void mem_cgroup_unlock_pages(void)
+{
+	rcu_read_unlock();
+}
+
+#else /* CONFIG_MEMCG */
+static inline
+unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
+					gfp_t gfp_mask,
+					unsigned long *total_scanned)
+{
+	return 0;
+}
+
+static inline void folio_memcg_lock(struct folio *folio)
+{
+}
+
+static inline void folio_memcg_unlock(struct folio *folio)
+{
+}
+
+static inline bool mem_cgroup_trylock_pages(struct mem_cgroup *memcg)
+{
+	/* to match folio_memcg_rcu() */
+	rcu_read_lock();
+	return true;
+}
+
+static inline void mem_cgroup_unlock_pages(void)
+{
+	rcu_read_unlock();
+}
+
+static inline bool task_in_memcg_oom(struct task_struct *p)
+{
+	return false;
+}
+
+static inline bool mem_cgroup_oom_synchronize(bool wait)
+{
+	return false;
+}
+
+#endif /* CONFIG_MEMCG */
+
 #endif /* _LINUX_MEMCONTROL_H */
--- a/mm/memcontrol-v1.h~mm-memcg-group-cgroup-v1-memcg-related-declarations
+++ a/mm/memcontrol-v1.h
@@ -5,15 +5,9 @@
 
 #include <linux/cgroup-defs.h>
 
-void memcg1_remove_from_trees(struct mem_cgroup *memcg);
-
-static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
-{
-	WRITE_ONCE(memcg->soft_limit, PAGE_COUNTER_MAX);
-}
+/* Cgroup v1 and v2 common declarations */
 
 void mem_cgroup_charge_statistics(struct mem_cgroup *memcg, int nr_pages);
-void memcg1_check_events(struct mem_cgroup *memcg, int nid);
 int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		     unsigned int nr_pages);
 
@@ -29,11 +23,26 @@ static inline int try_charge(struct mem_
 void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
 void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n);
 
-bool memcg1_wait_acct_move(struct mem_cgroup *memcg);
-struct cgroup_taskset;
-int memcg1_can_attach(struct cgroup_taskset *tset);
-void memcg1_cancel_attach(struct cgroup_taskset *tset);
-void memcg1_move_task(void);
+/*
+ * Iteration constructs for visiting all cgroups (under a tree).  If
+ * loops are exited prematurely (break), mem_cgroup_iter_break() must
+ * be used for reference counting.
+ */
+#define for_each_mem_cgroup_tree(iter, root)		\
+	for (iter = mem_cgroup_iter(root, NULL, NULL);	\
+	     iter != NULL;				\
+	     iter = mem_cgroup_iter(root, iter, NULL))
+
+#define for_each_mem_cgroup(iter)			\
+	for (iter = mem_cgroup_iter(NULL, NULL, NULL);	\
+	     iter != NULL;				\
+	     iter = mem_cgroup_iter(NULL, iter, NULL))
+
+/* Whether legacy memory+swap accounting is active */
+static bool do_memsw_account(void)
+{
+	return !cgroup_subsys_on_dfl(memory_cgrp_subsys);
+}
 
 /*
  * Per memcg event counter is incremented at every pagein/pageout. With THP,
@@ -47,27 +56,34 @@ enum mem_cgroup_events_target {
 	MEM_CGROUP_NTARGETS,
 };
 
-/* Whether legacy memory+swap accounting is active */
-static bool do_memsw_account(void)
+bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
+				enum mem_cgroup_events_target target);
+unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
+
+void drain_all_stock(struct mem_cgroup *root_memcg);
+
+unsigned long memcg_events(struct mem_cgroup *memcg, int event);
+unsigned long memcg_events_local(struct mem_cgroup *memcg, int event);
+unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx);
+unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
+unsigned long memcg_page_state_local_output(struct mem_cgroup *memcg, int item);
+int memory_stat_show(struct seq_file *m, void *v);
+
+/* Cgroup v1-specific declarations */
+
+void memcg1_remove_from_trees(struct mem_cgroup *memcg);
+
+static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
 {
-	return !cgroup_subsys_on_dfl(memory_cgrp_subsys);
+	WRITE_ONCE(memcg->soft_limit, PAGE_COUNTER_MAX);
 }
 
-/*
- * Iteration constructs for visiting all cgroups (under a tree).  If
- * loops are exited prematurely (break), mem_cgroup_iter_break() must
- * be used for reference counting.
- */
-#define for_each_mem_cgroup_tree(iter, root)		\
-	for (iter = mem_cgroup_iter(root, NULL, NULL);	\
-	     iter != NULL;				\
-	     iter = mem_cgroup_iter(root, iter, NULL))
-
-#define for_each_mem_cgroup(iter)			\
-	for (iter = mem_cgroup_iter(NULL, NULL, NULL);	\
-	     iter != NULL;				\
-	     iter = mem_cgroup_iter(NULL, iter, NULL))
+bool memcg1_wait_acct_move(struct mem_cgroup *memcg);
 
+struct cgroup_taskset;
+int memcg1_can_attach(struct cgroup_taskset *tset);
+void memcg1_cancel_attach(struct cgroup_taskset *tset);
+void memcg1_move_task(void);
 void memcg1_css_offline(struct mem_cgroup *memcg);
 
 /* for encoding cft->private value on file */
@@ -78,22 +94,11 @@ enum res_type {
 	_TCP,
 };
 
-bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
-				enum mem_cgroup_events_target target);
-unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
-
 bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked);
 void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked);
 void memcg1_oom_recover(struct mem_cgroup *memcg);
 
-void drain_all_stock(struct mem_cgroup *root_memcg);
-
-unsigned long memcg_events(struct mem_cgroup *memcg, int event);
-unsigned long memcg_events_local(struct mem_cgroup *memcg, int event);
-unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx);
-unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
-unsigned long memcg_page_state_local_output(struct mem_cgroup *memcg, int item);
-int memory_stat_show(struct seq_file *m, void *v);
+void memcg1_check_events(struct mem_cgroup *memcg, int nid);
 
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
 
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

