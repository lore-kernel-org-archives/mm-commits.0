Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6571A17D8B2
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 20:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719348647; cv=none; b=E/mv3XItj7aQmJtOjifdnxVdL42jQvvIhE9EWJoBNSsbQz8PjuhWLxpWlaVKk+3XT73qdw3sndep68Yc38743mrCQTbl2EslEMipQCojy0zi8M3X1ETxVcjdfU+zNImm3NF0jAcBUxAdv/ypTtBElULZv/GGpyIfhP9tDRlY2sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719348647; c=relaxed/simple;
	bh=jWBow6CXQ6hTk1WLh64Z7Q/S3lD59zKwVZFGlj1WRoA=;
	h=Date:To:From:Subject:Message-Id; b=BwcakMnw5VsT7qhMGENa4lnDnxcNc93AlfZgp2CZ2MjHth7rwjCIt99kAMYfrwipnunRjARt5OmSxSjeNLuakzECKx1H2S5+krQirbMue4vo8+gQU5CCdYwBvOVPlaE77OoYG1BAFoTkDJJKqHWKygkVmyxUSP6ZaMfBJP8dInI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kbmbomcP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kbmbomcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342DBC32781;
	Tue, 25 Jun 2024 20:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719348647;
	bh=jWBow6CXQ6hTk1WLh64Z7Q/S3lD59zKwVZFGlj1WRoA=;
	h=Date:To:From:Subject:From;
	b=kbmbomcPsQUmLVMih1qpUIVn+P2huOEUTo+Z2L5HmnOE1rwZK8ruv6o8JTnkztAsj
	 E/qhszPoaYlOs2gYjh9kUcUQ9MjjjIDUtYA46s5v2wFbk3hcFTx4lmHKkIsGSXSmHY
	 IntwAjpUja8kiQzcSFbiF2g7xhXk+dvnFxjd98UA=
Date: Tue, 25 Jun 2024 13:50:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option.patch added to mm-unstable branch
Message-Id: <20240625205047.342DBC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: put cgroup v1-related members of task_struct under config option
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option.patch

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
Subject: mm: memcg: put cgroup v1-related members of task_struct under config option
Date: Mon, 24 Jun 2024 17:59:05 -0700

Guard cgroup v1-related members of task_struct under the CONFIG_MEMCG_V1
config option, so that users who adopted cgroup v2 don't have to waste the
memory for fields which are never accessed.

Link: https://lkml.kernel.org/r/20240625005906.106920-14-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 +++---
 init/Kconfig               |    9 +++++++++
 mm/Makefile                |    3 ++-
 mm/memcontrol-v1.h         |   21 ++++++++++++++++++++-
 mm/memcontrol.c            |   10 +++++++---
 5 files changed, 41 insertions(+), 8 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option
+++ a/include/linux/memcontrol.h
@@ -1851,7 +1851,7 @@ static inline bool mem_cgroup_zswap_writ
 
 /* Cgroup v1-related declarations */
 
-#ifdef CONFIG_MEMCG
+#ifdef CONFIG_MEMCG_V1
 unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
 					gfp_t gfp_mask,
 					unsigned long *total_scanned);
@@ -1883,7 +1883,7 @@ static inline void mem_cgroup_unlock_pag
 	rcu_read_unlock();
 }
 
-#else /* CONFIG_MEMCG */
+#else /* CONFIG_MEMCG_V1 */
 static inline
 unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
 					gfp_t gfp_mask,
@@ -1922,6 +1922,6 @@ static inline bool mem_cgroup_oom_synchr
 	return false;
 }
 
-#endif /* CONFIG_MEMCG */
+#endif /* CONFIG_MEMCG_V1 */
 
 #endif /* _LINUX_MEMCONTROL_H */
--- a/init/Kconfig~mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option
+++ a/init/Kconfig
@@ -969,6 +969,15 @@ config MEMCG
 	help
 	  Provides control over the memory footprint of tasks in a cgroup.
 
+config MEMCG_V1
+	bool "Legacy memory controller"
+	depends on MEMCG
+	default n
+	help
+	  Legacy cgroup v1 memory controller.
+
+	  San N is unsure.
+
 config MEMCG_KMEM
 	bool
 	depends on MEMCG
--- a/mm/Makefile~mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option
+++ a/mm/Makefile
@@ -96,7 +96,8 @@ obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
-obj-$(CONFIG_MEMCG) += memcontrol.o memcontrol-v1.o vmpressure.o
+obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
+obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
 ifdef CONFIG_SWAP
 obj-$(CONFIG_MEMCG) += swap_cgroup.o
 endif
--- a/mm/memcontrol.c~mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option
+++ a/mm/memcontrol.c
@@ -4436,18 +4436,20 @@ struct cgroup_subsys memory_cgrp_subsys
 	.css_free = mem_cgroup_css_free,
 	.css_reset = mem_cgroup_css_reset,
 	.css_rstat_flush = mem_cgroup_css_rstat_flush,
-	.can_attach = memcg1_can_attach,
 #if defined(CONFIG_LRU_GEN) || defined(CONFIG_MEMCG_KMEM)
 	.attach = mem_cgroup_attach,
 #endif
-	.cancel_attach = memcg1_cancel_attach,
-	.post_attach = memcg1_move_task,
 #ifdef CONFIG_MEMCG_KMEM
 	.fork = mem_cgroup_fork,
 	.exit = mem_cgroup_exit,
 #endif
 	.dfl_cftypes = memory_files,
+#ifdef CONFIG_MEMCG_V1
+	.can_attach = memcg1_can_attach,
+	.cancel_attach = memcg1_cancel_attach,
+	.post_attach = memcg1_move_task,
 	.legacy_cftypes = mem_cgroup_legacy_files,
+#endif
 	.early_init = 0,
 };
 
@@ -5618,7 +5620,9 @@ static int __init mem_cgroup_swap_init(v
 		return 0;
 
 	WARN_ON(cgroup_add_dfl_cftypes(&memory_cgrp_subsys, swap_files));
+#ifdef CONFIG_MEMCG_V1
 	WARN_ON(cgroup_add_legacy_cftypes(&memory_cgrp_subsys, memsw_files));
+#endif
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 	WARN_ON(cgroup_add_dfl_cftypes(&memory_cgrp_subsys, zswap_files));
 #endif
--- a/mm/memcontrol-v1.h~mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option
+++ a/mm/memcontrol-v1.h
@@ -75,7 +75,7 @@ unsigned long memcg_page_state_local_out
 int memory_stat_show(struct seq_file *m, void *v);
 
 /* Cgroup v1-specific declarations */
-
+#ifdef CONFIG_MEMCG_V1
 void memcg1_remove_from_trees(struct mem_cgroup *memcg);
 
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
@@ -110,4 +110,23 @@ void memcg1_stat_format(struct mem_cgrou
 extern struct cftype memsw_files[];
 extern struct cftype mem_cgroup_legacy_files[];
 
+#else	/* CONFIG_MEMCG_V1 */
+
+static inline void memcg1_remove_from_trees(struct mem_cgroup *memcg) {}
+static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
+static inline bool memcg1_wait_acct_move(struct mem_cgroup *memcg) { return false; }
+static inline void memcg1_css_offline(struct mem_cgroup *memcg) {}
+
+static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked) { return true; }
+static inline void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked) {}
+static inline void memcg1_oom_recover(struct mem_cgroup *memcg) {}
+
+static inline void memcg1_check_events(struct mem_cgroup *memcg, int nid) {}
+
+static inline void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s) {}
+
+extern struct cftype memsw_files[];
+extern struct cftype mem_cgroup_legacy_files[];
+#endif	/* CONFIG_MEMCG_V1 */
+
 #endif	/* __MM_MEMCONTROL_V1_H */
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

