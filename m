Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A516145BE3
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 20:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719348624; cv=none; b=Zv9oD+V4QzYpGBXDk7nhgMR3SNYmsWUYReHWLLI2iniZOW0SkrpIrJ8nRsda7M0Con1Sa0M0qfuQeyEtEiMINqphAhFUzbICbkkj4fNfLPx3qYO4bOmB+UKeSMkxIBCWI3bCzPqZhcbrgI/II7JnfZd/hhQtfL7hGAyT6BLmozs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719348624; c=relaxed/simple;
	bh=+oUiQOA1zuffanmLZQ3lckCN+4gpialF4mYH8Oo9bqU=;
	h=Date:To:From:Subject:Message-Id; b=b+COnl6LxrIM4o9YDhI1c+lrqPirgfp/TiAq2ddSAbZMukb9djVnvmqqxwBES4Xw86wmlwC/MPUTQtq6+zQIpVzqa6LcoUzcrB9mVxHK2FWJvAvS4fCJsFNu24nZmd5QoUQj1qyvS7leypKHyrVl7pq0Tqnkp0njgNtlNQsfA7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=naND4kwO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="naND4kwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1E0C32781;
	Tue, 25 Jun 2024 20:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719348624;
	bh=+oUiQOA1zuffanmLZQ3lckCN+4gpialF4mYH8Oo9bqU=;
	h=Date:To:From:Subject:From;
	b=naND4kwOogDoHzyaiH1g/asoTn6dEnJvGBVU6ddXReXPHGxTqIyGf9MzaHz4UiUIm
	 o8NUzOpA59B+mw7LWrUgr+8/E7JZl53/mozbv06YemJAdnhVvEVHQs73dEYQ1wPiAO
	 4HV4i4/6NDilv9rNaBwbp5qqBQ14XtRcN/MltoPA=
Date: Tue, 25 Jun 2024 13:50:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-rename-charge-move-related-functions.patch added to mm-unstable branch
Message-Id: <20240625205024.1F1E0C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: rename charge move-related functions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-rename-charge-move-related-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-rename-charge-move-related-functions.patch

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
Subject: mm: memcg: rename charge move-related functions
Date: Mon, 24 Jun 2024 17:58:57 -0700

Rename exported function related to the charge move to have the memcg1_
prefix.

Link: https://lkml.kernel.org/r/20240625005906.106920-6-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |   14 +++++++-------
 mm/memcontrol-v1.h |    8 ++++----
 mm/memcontrol.c    |    8 ++++----
 3 files changed, 15 insertions(+), 15 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-rename-charge-move-related-functions
+++ a/mm/memcontrol.c
@@ -2580,7 +2580,7 @@ retry:
 	 * At task move, charge accounts can be doubly counted. So, it's
 	 * better to wait until the end of task_move if something is going on.
 	 */
-	if (mem_cgroup_wait_acct_move(mem_over_limit))
+	if (memcg1_wait_acct_move(mem_over_limit))
 		goto retry;
 
 	if (nr_retries--)
@@ -5995,12 +5995,12 @@ struct cgroup_subsys memory_cgrp_subsys
 	.css_free = mem_cgroup_css_free,
 	.css_reset = mem_cgroup_css_reset,
 	.css_rstat_flush = mem_cgroup_css_rstat_flush,
-	.can_attach = mem_cgroup_can_attach,
+	.can_attach = memcg1_can_attach,
 #if defined(CONFIG_LRU_GEN) || defined(CONFIG_MEMCG_KMEM)
 	.attach = mem_cgroup_attach,
 #endif
-	.cancel_attach = mem_cgroup_cancel_attach,
-	.post_attach = mem_cgroup_move_task,
+	.cancel_attach = memcg1_cancel_attach,
+	.post_attach = memcg1_move_task,
 #ifdef CONFIG_MEMCG_KMEM
 	.fork = mem_cgroup_fork,
 	.exit = mem_cgroup_exit,
--- a/mm/memcontrol-v1.c~mm-memcg-rename-charge-move-related-functions
+++ a/mm/memcontrol-v1.c
@@ -384,7 +384,7 @@ unlock:
 	return ret;
 }
 
-bool mem_cgroup_wait_acct_move(struct mem_cgroup *memcg)
+bool memcg1_wait_acct_move(struct mem_cgroup *memcg)
 {
 	if (mc.moving_task && current != mc.moving_task) {
 		if (mem_cgroup_under_move(memcg)) {
@@ -1056,7 +1056,7 @@ static void mem_cgroup_clear_mc(void)
 	mmput(mm);
 }
 
-int mem_cgroup_can_attach(struct cgroup_taskset *tset)
+int memcg1_can_attach(struct cgroup_taskset *tset)
 {
 	struct cgroup_subsys_state *css;
 	struct mem_cgroup *memcg = NULL; /* unneeded init to make gcc happy */
@@ -1126,7 +1126,7 @@ int mem_cgroup_can_attach(struct cgroup_
 	return ret;
 }
 
-void mem_cgroup_cancel_attach(struct cgroup_taskset *tset)
+void memcg1_cancel_attach(struct cgroup_taskset *tset)
 {
 	if (mc.to)
 		mem_cgroup_clear_mc();
@@ -1285,7 +1285,7 @@ retry:
 	atomic_dec(&mc.from->moving_account);
 }
 
-void mem_cgroup_move_task(void)
+void memcg1_move_task(void)
 {
 	if (mc.to) {
 		mem_cgroup_move_charge();
@@ -1294,14 +1294,14 @@ void mem_cgroup_move_task(void)
 }
 
 #else	/* !CONFIG_MMU */
-static int mem_cgroup_can_attach(struct cgroup_taskset *tset)
+int memcg1_can_attach(struct cgroup_taskset *tset)
 {
 	return 0;
 }
-static void mem_cgroup_cancel_attach(struct cgroup_taskset *tset)
+void memcg1_cancel_attach(struct cgroup_taskset *tset)
 {
 }
-static void mem_cgroup_move_task(void)
+void memcg1_move_task(void)
 {
 }
 #endif
--- a/mm/memcontrol-v1.h~mm-memcg-rename-charge-move-related-functions
+++ a/mm/memcontrol-v1.h
@@ -29,11 +29,11 @@ static inline int try_charge(struct mem_
 void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
 void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n);
 
-bool mem_cgroup_wait_acct_move(struct mem_cgroup *memcg);
+bool memcg1_wait_acct_move(struct mem_cgroup *memcg);
 struct cgroup_taskset;
-int mem_cgroup_can_attach(struct cgroup_taskset *tset);
-void mem_cgroup_cancel_attach(struct cgroup_taskset *tset);
-void mem_cgroup_move_task(void);
+int memcg1_can_attach(struct cgroup_taskset *tset);
+void memcg1_cancel_attach(struct cgroup_taskset *tset);
+void memcg1_move_task(void);
 
 struct cftype;
 u64 mem_cgroup_move_charge_read(struct cgroup_subsys_state *css,
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

