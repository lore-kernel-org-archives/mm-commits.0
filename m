Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AFF79B8E
	for <mm-commits@vger.kernel.org>; Fri, 28 Jun 2024 22:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719612488; cv=none; b=UfCZLLlxjNfi+gtmkkjlqntlj8xM2LGCML8naCdd9ep64ZFCv1cBJflE19vYM0lFQ53NdBmQnNNcqfrGkX4o1iiyTYoodaLn7+jwbD3r6gbPTUxM+aZVkVewetWQSx0/wi8v3RdLi7mz0zshQHV9Sb85SNwJzKARQlY0AAulQlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719612488; c=relaxed/simple;
	bh=El+fLBA2ys4J2MlLuuiktc7Vb7ixXFct1fTmeB0Xb4I=;
	h=Date:To:From:Subject:Message-Id; b=EuYwX6XwQbNCR8ph7cNkBXdcCpI2WogFtwTGG4fb9YQu8ZTl5lfpUzy2I29QG/tRP52UCCvOwpsdiBSLMEXuLBPXUMX31WuY3oeXFOEB1BptrTrtI33TAF0s2dk0fqTo2McwJFfLN8z2Wlx/KSc9onJD1GpN/O3j9099/LJH6pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vVl/YU9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vVl/YU9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05946C116B1;
	Fri, 28 Jun 2024 22:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719612488;
	bh=El+fLBA2ys4J2MlLuuiktc7Vb7ixXFct1fTmeB0Xb4I=;
	h=Date:To:From:Subject:From;
	b=vVl/YU9Sc0IvnTLxcIQcXzkIDclcQ+dguKsRiOfgMSykuhF8/in9QDOXZK2l3JuiD
	 JyWfd2T6gbl7L0w946rGLtOsJR8tsCdBmjpyUM5Ay1YjD+gjCUl7izsxS2TTPhieRs
	 S1lX0XWzorz44Zd/8b/w4XSOHa9gX/5ZKU0/opEk=
Date: Fri, 28 Jun 2024 15:08:07 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-put-memcg1-specific-struct-mem_cgroups-members-under-config_memcg_v1.patch added to mm-unstable branch
Message-Id: <20240628220808.05946C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: put memcg1-specific struct mem_cgroup's members under CONFIG_MEMCG_V1
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-put-memcg1-specific-struct-mem_cgroups-members-under-config_memcg_v1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-put-memcg1-specific-struct-mem_cgroups-members-under-config_memcg_v1.patch

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
Subject: mm: memcg: put memcg1-specific struct mem_cgroup's members under CONFIG_MEMCG_V1
Date: Fri, 28 Jun 2024 21:03:14 +0000

Put memcg1-specific members of struct mem_cgroup under the CONFIG_MEMCG_V1
config option.  Also group them close to the end of struct mem_cgroup just
before the dynamic per-node part.

Link: https://lkml.kernel.org/r/20240628210317.272856-7-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |  103 ++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 50 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-put-memcg1-specific-struct-mem_cgroups-members-under-config_memcg_v1
+++ a/include/linux/memcontrol.h
@@ -188,10 +188,6 @@ struct mem_cgroup {
 		struct page_counter memsw;	/* v1 only */
 	};
 
-	/* Legacy consumer-oriented counters */
-	struct page_counter kmem;		/* v1 only */
-	struct page_counter tcpmem;		/* v1 only */
-
 	/* Range enforcement for interrupt charges */
 	struct work_struct high_work;
 
@@ -205,8 +201,6 @@ struct mem_cgroup {
 	bool zswap_writeback;
 #endif
 
-	unsigned long soft_limit;
-
 	/* vmpressure notifications */
 	struct vmpressure vmpressure;
 
@@ -215,13 +209,7 @@ struct mem_cgroup {
 	 */
 	bool oom_group;
 
-	/* protected by memcg_oom_lock */
-	bool		oom_lock;
-	int		under_oom;
-
-	int	swappiness;
-	/* OOM-Killer disable */
-	int		oom_kill_disable;
+	int swappiness;
 
 	/* memory.events and memory.events.local */
 	struct cgroup_file events_file;
@@ -230,27 +218,6 @@ struct mem_cgroup {
 	/* handle for "memory.swap.events" */
 	struct cgroup_file swap_events_file;
 
-	/* protect arrays of thresholds */
-	struct mutex thresholds_lock;
-
-	/* thresholds for memory usage. RCU-protected */
-	struct mem_cgroup_thresholds thresholds;
-
-	/* thresholds for mem+swap usage. RCU-protected */
-	struct mem_cgroup_thresholds memsw_thresholds;
-
-	/* For oom notifier event fd */
-	struct list_head oom_notify;
-
-	/*
-	 * Should we move charges of a task when a task is moved into this
-	 * mem_cgroup ? And what type of charges should we move ?
-	 */
-	unsigned long move_charge_at_immigrate;
-	/* taken only while moving_account > 0 */
-	spinlock_t		move_lock;
-	unsigned long		move_lock_flags;
-
 	CACHELINE_PADDING(_pad1_);
 
 	/* memory.stat */
@@ -267,10 +234,6 @@ struct mem_cgroup {
 	 */
 	unsigned long		socket_pressure;
 
-	/* Legacy tcp memory accounting */
-	bool			tcpmem_active;
-	int			tcpmem_pressure;
-
 #ifdef CONFIG_MEMCG_KMEM
 	int kmemcg_id;
 	/*
@@ -284,14 +247,6 @@ struct mem_cgroup {
 	struct list_head objcg_list;
 #endif
 
-	CACHELINE_PADDING(_pad2_);
-
-	/*
-	 * set > 0 if pages under this cgroup are moving to other cgroup.
-	 */
-	atomic_t		moving_account;
-	struct task_struct	*move_lock_task;
-
 	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
@@ -300,10 +255,6 @@ struct mem_cgroup {
 	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
 #endif
 
-	/* List of events which userspace want to receive */
-	struct list_head event_list;
-	spinlock_t event_list_lock;
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	struct deferred_split deferred_split_queue;
 #endif
@@ -313,6 +264,58 @@ struct mem_cgroup {
 	struct lru_gen_mm_list mm_list;
 #endif
 
+#ifdef CONFIG_MEMCG_V1
+	/* Legacy consumer-oriented counters */
+	struct page_counter kmem;		/* v1 only */
+	struct page_counter tcpmem;		/* v1 only */
+
+	unsigned long soft_limit;
+
+	/* protected by memcg_oom_lock */
+	bool oom_lock;
+	int under_oom;
+
+	/* OOM-Killer disable */
+	int oom_kill_disable;
+
+	/* protect arrays of thresholds */
+	struct mutex thresholds_lock;
+
+	/* thresholds for memory usage. RCU-protected */
+	struct mem_cgroup_thresholds thresholds;
+
+	/* thresholds for mem+swap usage. RCU-protected */
+	struct mem_cgroup_thresholds memsw_thresholds;
+
+	/* For oom notifier event fd */
+	struct list_head oom_notify;
+
+	/*
+	 * Should we move charges of a task when a task is moved into this
+	 * mem_cgroup ? And what type of charges should we move ?
+	 */
+	unsigned long move_charge_at_immigrate;
+	/* taken only while moving_account > 0 */
+	spinlock_t move_lock;
+	unsigned long move_lock_flags;
+
+	/* Legacy tcp memory accounting */
+	bool tcpmem_active;
+	int tcpmem_pressure;
+
+	CACHELINE_PADDING(_pad2_);
+
+	/*
+	 * set > 0 if pages under this cgroup are moving to other cgroup.
+	 */
+	atomic_t moving_account;
+	struct task_struct *move_lock_task;
+
+	/* List of events which userspace want to receive */
+	struct list_head event_list;
+	spinlock_t event_list_lock;
+#endif /* CONFIG_MEMCG_V1 */
+
 	struct mem_cgroup_per_node *nodeinfo[];
 };
 
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
mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option-fix.patch
maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files.patch
mm-memcg-move-memcg_account_kmem-to-memcontrol-v1c.patch
mm-memcg-factor-out-legacy-socket-memory-accounting-code.patch
mm-memcg-guard-cgroup-v1-specific-code-in-mem_cgroup_print_oom_meminfo.patch
mm-memcg-gather-memcg1-specific-fields-initialization-in-memcg1_memcg_init.patch
mm-memcg-guard-memcg1-specific-fields-accesses-in-mm-memcontrolc.patch
mm-memcg-put-memcg1-specific-struct-mem_cgroups-members-under-config_memcg_v1.patch
mm-memcg-guard-memcg1-specific-members-of-struct-mem_cgroup_per_node.patch
mm-memcg-put-struct-task_struct-memcg_in_oom-under-config_memcg_v1.patch
mm-memcg-put-struct-task_struct-in_user_fault-under-config_memcg_v1.patch

