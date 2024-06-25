Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9BA17D8B2
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 20:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719348645; cv=none; b=Bkf4tlPZbbQ4rg3UBkqSCici4iS0zYIsgEB3f8VyAJg5VK4sqE2Pfc3Mx/VyHO1kmKXeyX+tX1CynuMB1fr3IVrySLmn0duteV/WeHC6PODIoVbEe/9UE2Zq6A9TUKxS90oKvTMxOwMTk5oXltDkkDj4e9uvb/74xkiuJEzxk/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719348645; c=relaxed/simple;
	bh=FsLe9j8eVMngEHXtC2DPHYLcDjBAZn7kAvKh2lt0Wns=;
	h=Date:To:From:Subject:Message-Id; b=pufNwEv9yaSG+36R0/IkCi1lnkFGmMshP/GwS5SWWhoGlfRDXScdpQTbs1zMI68txc34r/XRkuiFCwqdcgzjEIH1tnK5yDEGHCpWawMe2K5pzl0XKjzlajQ/j/lUdy0P+q1qT6wm6d3QDmQjd57/I1XCPipKglskdZ+K5n7hO88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YG2BrUQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YG2BrUQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF72FC4AF07;
	Tue, 25 Jun 2024 20:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719348644;
	bh=FsLe9j8eVMngEHXtC2DPHYLcDjBAZn7kAvKh2lt0Wns=;
	h=Date:To:From:Subject:From;
	b=YG2BrUQYyLp5v7G9pmI4hwd5mkGiX8hU2lr3K+RnP/2Jya02RppGq7gZZA7D0ZYhX
	 mBIikP/Vu9YykTubM1w0db0yN3hGyAM59ABx3eP8U1hccqtx4sIfsRkIQMJVVybbbf
	 lj0XAKssbxLFOKd272pW/KYTIrta0p9rDjMR8DrQ=
Date: Tue, 25 Jun 2024 13:50:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-group-cgroup-v1-memcg-related-declarations.patch added to mm-unstable branch
Message-Id: <20240625205044.CF72FC4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: group cgroup v1 memcg related declarations
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-group-cgroup-v1-memcg-related-declarations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-group-cgroup-v1-memcg-related-declarations.patch

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
 mm/memcontrol-v1.h         |   89 +++++++++++----------
 2 files changed, 123 insertions(+), 110 deletions(-)

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
 
@@ -29,30 +23,6 @@ static inline int try_charge(struct mem_
 void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
 void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n);
 
-bool memcg1_wait_acct_move(struct mem_cgroup *memcg);
-struct cgroup_taskset;
-int memcg1_can_attach(struct cgroup_taskset *tset);
-void memcg1_cancel_attach(struct cgroup_taskset *tset);
-void memcg1_move_task(void);
-
-/*
- * Per memcg event counter is incremented at every pagein/pageout. With THP,
- * it will be incremented by the number of pages. This counter is used
- * to trigger some periodic events. This is straightforward and better
- * than using jiffies etc. to handle periodic memcg event.
- */
-enum mem_cgroup_events_target {
-	MEM_CGROUP_TARGET_THRESH,
-	MEM_CGROUP_TARGET_SOFTLIMIT,
-	MEM_CGROUP_NTARGETS,
-};
-
-/* Whether legacy memory+swap accounting is active */
-static bool do_memsw_account(void)
-{
-	return !cgroup_subsys_on_dfl(memory_cgrp_subsys);
-}
-
 /*
  * Iteration constructs for visiting all cgroups (under a tree).  If
  * loops are exited prematurely (break), mem_cgroup_iter_break() must
@@ -68,24 +38,28 @@ static bool do_memsw_account(void)
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
-void memcg1_css_offline(struct mem_cgroup *memcg);
+/* Whether legacy memory+swap accounting is active */
+static bool do_memsw_account(void)
+{
+	return !cgroup_subsys_on_dfl(memory_cgrp_subsys);
+}
 
-/* for encoding cft->private value on file */
-enum res_type {
-	_MEM,
-	_MEMSWAP,
-	_KMEM,
-	_TCP,
+/*
+ * Per memcg event counter is incremented at every pagein/pageout. With THP,
+ * it will be incremented by the number of pages. This counter is used
+ * to trigger some periodic events. This is straightforward and better
+ * than using jiffies etc. to handle periodic memcg event.
+ */
+enum mem_cgroup_events_target {
+	MEM_CGROUP_TARGET_THRESH,
+	MEM_CGROUP_TARGET_SOFTLIMIT,
+	MEM_CGROUP_NTARGETS,
 };
 
 bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
 				enum mem_cgroup_events_target target);
 unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
 
-bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked);
-void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked);
-void memcg1_oom_recover(struct mem_cgroup *memcg);
-
 void drain_all_stock(struct mem_cgroup *root_memcg);
 unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
 				      unsigned int lru_mask, bool tree);
@@ -100,6 +74,37 @@ unsigned long memcg_page_state_output(st
 unsigned long memcg_page_state_local_output(struct mem_cgroup *memcg, int item);
 int memory_stat_show(struct seq_file *m, void *v);
 
+/* Cgroup v1-specific declarations */
+
+void memcg1_remove_from_trees(struct mem_cgroup *memcg);
+
+static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
+{
+	WRITE_ONCE(memcg->soft_limit, PAGE_COUNTER_MAX);
+}
+
+bool memcg1_wait_acct_move(struct mem_cgroup *memcg);
+
+struct cgroup_taskset;
+int memcg1_can_attach(struct cgroup_taskset *tset);
+void memcg1_cancel_attach(struct cgroup_taskset *tset);
+void memcg1_move_task(void);
+void memcg1_css_offline(struct mem_cgroup *memcg);
+
+/* for encoding cft->private value on file */
+enum res_type {
+	_MEM,
+	_MEMSWAP,
+	_KMEM,
+	_TCP,
+};
+
+bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked);
+void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked);
+void memcg1_oom_recover(struct mem_cgroup *memcg);
+
+void memcg1_check_events(struct mem_cgroup *memcg, int nid);
+
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
 
 extern struct cftype memsw_files[];
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-introduce-memcontrol-v1c.patch
mm-memcg-move-soft-limit-reclaim-code-to-memcontrol-v1c.patch
mm-memcg-rename-soft-limit-reclaim-related-functions.patch
mm-memcg-move-charge-migration-code-to-memcontrol-v1c.patch
mm-memcg-rename-charge-move-related-functions.patch
mm-memcg-move-legacy-memcg-event-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_check_events.patch
mm-memcg-move-cgroup-v1-oom-handling-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_oom_recover.patch
mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c.patch
mm-memcg-make-memcg1_update_tree-static.patch
mm-memcg-group-cgroup-v1-memcg-related-declarations.patch
mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option.patch
maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files.patch

