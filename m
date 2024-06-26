Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964D5D2F0
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 18:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719424838; cv=none; b=cYtnjXvmuo5neF6kfwUvg9at88BQw2KkRNdwyOKUAFolmKNl8eflM1fq4HinCjIMyMFVF3vL0Vj0WeVeSSIxSIlqPQsa2K2BiwibvoU3DjfYImPMmj9CwSaTTJUkMJT/odudf+ywDfMzXrJUsN3lm3ELpG2PsPJz0KEOaESkcdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719424838; c=relaxed/simple;
	bh=ICA2nPmYYT7hnvN2/C6++4eEJfEcwQfh5FbnVNYI0bE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c1jWOhR4iwOObBM6eQFkvqqn0PsTKHLBNnNaKtLQDD70F+PiwPxKv+vWZSgXCnq2WY8HnW9VG/hlkItV9RCbnQKKdowM7fiSrqwai1BsHN+nXdye7PPwsEZIC7JWXYNrBu4tX0nLOZ4Pq/wkcVO3hqRrFWIzqLDB4TLcXaD3pCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s1pRdP9O; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s1pRdP9O"
X-Envelope-To: akpm@linux-foundation.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719424827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FObiZEzMT3BFvJxwy4X6FA9rQs+lUflQFClsK/mnrgU=;
	b=s1pRdP9Osno2OjMcHJHG87MUoCLAQtHkKmXCwsuTREiH9pMM9x8/PeWEc/u/BZFQrEjqlX
	zvAxqO2epu20dW9mZi7eAwkXWzEVuKkzewV51N0Y7pNAjKtN8VFS8UWS4B84qTZU3vKvWR
	83V0EoOzw8g6TLWRE9V+OEChqkc2vjA=
X-Envelope-To: mm-commits@vger.kernel.org
X-Envelope-To: willy@infradead.org
X-Envelope-To: shakeel.butt@linux.dev
X-Envelope-To: muchun.song@linux.dev
X-Envelope-To: mhocko@suse.com
X-Envelope-To: hannes@cmpxchg.org
Date: Wed, 26 Jun 2024 18:00:22 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, willy@infradead.org, shakeel.butt@linux.dev,
	muchun.song@linux.dev, mhocko@suse.com, hannes@cmpxchg.org
Subject: Re: +
 mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option.patch
 added to mm-unstable branch
Message-ID: <ZnxXNtvqllc9CDoo@google.com>
References: <20240625205047.342DBC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625205047.342DBC32781@smtp.kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 25, 2024 at 01:50:46PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm: memcg: put cgroup v1-related members of task_struct under config option
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Hi Andrew,

can you please replace this patch with the one below?

The code is the same except from the better config option description provided
by Michal, but the commit log _and_ subject are entirely different:
the previous one was taken from another patch in v1 of this series by a mistake.

I also updated the cover letter for the series a bit - also attached to this
letter.

The whole updated series is available here:
https://github.com/rgushchin/linux/tree/memcontrol_v1.2-fixup

Thank you!

--------------------------------------------------------------------------------
From a4ab44d7b70a893ebded61835006f57099bdc059 Mon Sep 17 00:00:00 2001
From: Roman Gushchin <roman.gushchin@linux.dev>
Date: Wed, 8 May 2024 15:23:37 -0700
Subject: [PATCH v2-fixup 13/14] mm: memcg: put cgroup v1-specific code under a
 config option

Put legacy cgroup v1 memory controller code under a new
CONFIG_MEMCG_V1 config option. The option is turned off by default.
Nobody except those who are still using cgroup v1 should turn it on.

If the option is not set, memory controller can still be mounted
under cgroup v1, but none of memcg-specific control files are present.

Please note, that not all cgroup v1's memory controller code is
guarded yet (but most of it), it's a subject for some follow-up work.

Thanks to Michal Hocko for providing a better Kconfig option
description.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
---
 include/linux/memcontrol.h |  6 +++---
 init/Kconfig               | 17 +++++++++++++++++
 mm/Makefile                |  3 ++-
 mm/memcontrol-v1.h         | 21 ++++++++++++++++++++-
 mm/memcontrol.c            | 10 +++++++---
 5 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a70d64ed04f5..796cfa842346 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1851,7 +1851,7 @@ static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
 
 /* Cgroup v1-related declarations */
 
-#ifdef CONFIG_MEMCG
+#ifdef CONFIG_MEMCG_V1
 unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
 					gfp_t gfp_mask,
 					unsigned long *total_scanned);
@@ -1883,7 +1883,7 @@ static inline void mem_cgroup_unlock_pages(void)
 	rcu_read_unlock();
 }
 
-#else /* CONFIG_MEMCG */
+#else /* CONFIG_MEMCG_V1 */
 static inline
 unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
 					gfp_t gfp_mask,
@@ -1922,6 +1922,6 @@ static inline bool mem_cgroup_oom_synchronize(bool wait)
 	return false;
 }
 
-#endif /* CONFIG_MEMCG */
+#endif /* CONFIG_MEMCG_V1 */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff --git a/init/Kconfig b/init/Kconfig
index febdea2afc3b..aca0ae9be04f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -969,6 +969,23 @@ config MEMCG
 	help
 	  Provides control over the memory footprint of tasks in a cgroup.
 
+config MEMCG_V1
+	bool "Legacy cgroup v1 memory controller"
+	depends on MEMCG
+	default n
+	help
+	  Legacy cgroup v1 memory controller which has been deprecated by
+	  cgroup v2 implementation. The v1 is there for legacy applications
+	  which haven't migrated to the new cgroup v2 interface yet. If you
+	  do not have any such application then you are completely fine leaving
+	  this option disabled.
+
+	  Please note that feature set of the legacy memory controller is likely
+	  going to shrink due to deprecation process. New deployments with v1
+	  controller are highly discouraged.
+
+	  San N is unsure.
+
 config MEMCG_KMEM
 	bool
 	depends on MEMCG
diff --git a/mm/Makefile b/mm/Makefile
index 124d4dea2035..d2915f8c9dc0 100644
--- a/mm/Makefile
+++ b/mm/Makefile
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
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 89d420793048..64b053d7f131 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -75,7 +75,7 @@ unsigned long memcg_page_state_local_output(struct mem_cgroup *memcg, int item);
 int memory_stat_show(struct seq_file *m, void *v);
 
 /* Cgroup v1-specific declarations */
-
+#ifdef CONFIG_MEMCG_V1
 void memcg1_remove_from_trees(struct mem_cgroup *memcg);
 
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
@@ -110,4 +110,23 @@ void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
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
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c7341e811945..d2e1f8baeae8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4471,18 +4471,20 @@ struct cgroup_subsys memory_cgrp_subsys = {
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
 
@@ -5653,7 +5655,9 @@ static int __init mem_cgroup_swap_init(void)
 		return 0;
 
 	WARN_ON(cgroup_add_dfl_cftypes(&memory_cgrp_subsys, swap_files));
+#ifdef CONFIG_MEMCG_V1
 	WARN_ON(cgroup_add_legacy_cftypes(&memory_cgrp_subsys, memsw_files));
+#endif
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 	WARN_ON(cgroup_add_dfl_cftypes(&memory_cgrp_subsys, zswap_files));
 #endif
-- 
2.45.2.741.gdbec12cfda-goog



--------------------------------------------------------------------------------
From 2cfdba4681e34d4468d36febaa016a29da1d338f Mon Sep 17 00:00:00 2001
From: Roman Gushchin <roman.gushchin@linux.dev>
Date: Wed, 26 Jun 2024 17:52:11 +0000
Subject: [PATCH v2-fixup 00/14] mm: memcg: separate legacy cgroup v1 code and put under config option

Cgroups v2 have been around for a while and many users have fully adopted them,
so they never use cgroups v1 features and functionality. Yet they have to "pay"
for the cgroup v1 support anyway:
1) the kernel binary contains an unused cgroup v1 code,
2) some code paths have additional checks which are not needed,
3) some common structures like task_struct and mem_cgroup contain unused
   cgroup v1-specific members.

Cgroup v1's memory controller has a number of features that are not supported
by cgroup v2 and their implementation is pretty much self contained.
Most notably, these features are: soft limit reclaim, oom handling in userspace,
complicated event notification system, charge migration. Cgroup v1-specific code
in memcontrol.c is close to 4k lines in size and it's intervened with generic
and cgroup v2-specific code. It's a burden on developers and maintainers.

This patchset aims to solve these problems by:
1) moving cgroup v1-specific memcg code to the new mm/memcontrol-v1.c file,
2) putting definitions shared by memcontrol.c and memcontrol-v1.c into the
   mm/memcontrol-v1.h header,
3) introducing the CONFIG_MEMCG_V1 config option, turned off by default,
4) making memcontrol-v1.c to compile only if CONFIG_MEMCG_V1 is set.

If CONFIG_MEMCG_V1 is not set, cgroup v1 memory controller is still available
for mounting, however no memory-specific control knobs are present.

v2:
  - minor compilation fix
  - #else/#endif comments fix (Lance Yang)
  - better config option description (Michal Hocko)

v1:
  - switched to CONFIG_MEMCG_V1 being off by default based on LSFMMBPF
    discussion [1]
  - switched to memcg1_ prefix (Johannes)
  - many minor fixes
  - dropped patches which put struct memcg members under CONFIG_MEMCG_V1
    (will post as a separate patchset)

rfc:
  https://lwn.net/Articles/973082/

[1]: https://lwn.net/Articles/974575/


MAINTAINERS                |    2 +
include/linux/memcontrol.h |  156 ++--
init/Kconfig               |   17 +
mm/Makefile                |    2 +
mm/memcontrol-v1.c         | 2933 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
mm/memcontrol-v1.h         |  132 +++
mm/memcontrol.c            | 4141 ++++++++++++++------------------------------------------------------------------------------
mm/vmscan.c                |   10 +-
8 files changed, 3788 insertions(+), 3605 deletions(-)

Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>


Roman Gushchin (14):
  mm: memcg: introduce memcontrol-v1.c
  mm: memcg: move soft limit reclaim code to memcontrol-v1.c
  mm: memcg: rename soft limit reclaim-related functions
  mm: memcg: move charge migration code to memcontrol-v1.c
  mm: memcg: rename charge move-related functions
  mm: memcg: move legacy memcg event code into memcontrol-v1.c
  mm: memcg: rename memcg_check_events()
  mm: memcg: move cgroup v1 oom handling code into memcontrol-v1.c
  mm: memcg: rename memcg_oom_recover()
  mm: memcg: move cgroup v1 interface files to memcontrol-v1.c
  mm: memcg: make memcg1_update_tree() static
  mm: memcg: group cgroup v1 memcg related declarations
  mm: memcg: put cgroup v1-specific code under a config option
  MAINTAINERS: add mm/memcontrol-v1.c/h to the list of maintained files

 MAINTAINERS                |    2 +
 include/linux/memcontrol.h |  156 +-
 init/Kconfig               |   17 +
 mm/Makefile                |    2 +
 mm/memcontrol-v1.c         | 2933 +++++++++++++++++++++++++
 mm/memcontrol-v1.h         |  132 ++
 mm/memcontrol.c            | 4141 ++++++------------------------------
 mm/vmscan.c                |   10 +-
 8 files changed, 3788 insertions(+), 3605 deletions(-)
 create mode 100644 mm/memcontrol-v1.c
 create mode 100644 mm/memcontrol-v1.h

-- 
2.45.2.741.gdbec12cfda-goog

