Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBF479B8E
	for <mm-commits@vger.kernel.org>; Fri, 28 Jun 2024 22:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719612484; cv=none; b=HuTQqN1/NeM2w6xYPb63pIrNMY4pPoE/MkvPmL2vnn3N3OmI2hV63Gkz5ZdHq5DUJ4Pr5l+6YFU2CuvnrJswQ8jbEu1YpTNsuSe6v3Na/LWju0hdmIg7x+mEiSrhfMSqvBn9c3fh5TIcQctgFKCB5yvmwXw7plDiXTb3ZqPoKiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719612484; c=relaxed/simple;
	bh=tSwOvHRpXXv+b5vilZytDTTuSI+sh25aUXORYTM18iI=;
	h=Date:To:From:Subject:Message-Id; b=I4AqgM6knXxMJssMbhJHFGw/08lbz6BoC0KfFtSKoDKmaBcMxXqKChvOMjHjrXnCtQk6SCJuNhiPf7ft1JUa+8bGhP9K+PkZPFhBonNxR2/XBjCr6eFEFgKrLleL2uzZKqv6bTxvrFU9Mzx0S+8PtB7H78FBkI5dWyniGfvwgzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vyh38W1G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vyh38W1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72442C2BBFC;
	Fri, 28 Jun 2024 22:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719612483;
	bh=tSwOvHRpXXv+b5vilZytDTTuSI+sh25aUXORYTM18iI=;
	h=Date:To:From:Subject:From;
	b=vyh38W1G0vx+GCRSLOiqBsR7breZNcWjkveBPL6sUrwh2lzfcBrCZ9b51f5j+TYg8
	 JRlc4DYNrR27PuxnZ9LPKUMG2JO/y7YbUfD9l/xIdt8dXF2WK4BjFoZB4qaR5zydyJ
	 xfD4OlNbHCAYi10cUUH478Kagt5BPgycQ7Pxn3bY=
Date: Fri, 28 Jun 2024 15:08:02 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-gather-memcg1-specific-fields-initialization-in-memcg1_memcg_init.patch added to mm-unstable branch
Message-Id: <20240628220803.72442C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: gather memcg1-specific fields initialization in memcg1_memcg_init()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-gather-memcg1-specific-fields-initialization-in-memcg1_memcg_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-gather-memcg1-specific-fields-initialization-in-memcg1_memcg_init.patch

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
Subject: mm: memcg: gather memcg1-specific fields initialization in memcg1_memcg_init()
Date: Fri, 28 Jun 2024 21:03:12 +0000

Gather all memcg1-specific struct mem_cgroup's members initialization in a
new memcg1_memcg_init() function, defined in mm/memcontrol-v1.c. 
Obviously, if CONFIG_MEMCG_V1 is not set, there is no need to initialize
these fields, so the function becomes trivial.

Link: https://lkml.kernel.org/r/20240628210317.272856-5-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    9 +++++++++
 mm/memcontrol-v1.h |    2 ++
 mm/memcontrol.c    |    6 +-----
 3 files changed, 12 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-gather-memcg1-specific-fields-initialization-in-memcg1_memcg_init
+++ a/mm/memcontrol.c
@@ -3627,13 +3627,9 @@ static struct mem_cgroup *mem_cgroup_all
 		goto fail;
 
 	INIT_WORK(&memcg->high_work, high_work_func);
-	INIT_LIST_HEAD(&memcg->oom_notify);
-	mutex_init(&memcg->thresholds_lock);
-	spin_lock_init(&memcg->move_lock);
 	vmpressure_init(&memcg->vmpressure);
-	INIT_LIST_HEAD(&memcg->event_list);
-	spin_lock_init(&memcg->event_list_lock);
 	memcg->socket_pressure = jiffies;
+	memcg1_memcg_init(memcg);
 #ifdef CONFIG_MEMCG_KMEM
 	memcg->kmemcg_id = -1;
 	INIT_LIST_HEAD(&memcg->objcg_list);
--- a/mm/memcontrol-v1.c~mm-memcg-gather-memcg1-specific-fields-initialization-in-memcg1_memcg_init
+++ a/mm/memcontrol-v1.c
@@ -1961,6 +1961,15 @@ out_kfree:
 	return ret;
 }
 
+void memcg1_memcg_init(struct mem_cgroup *memcg)
+{
+	INIT_LIST_HEAD(&memcg->oom_notify);
+	mutex_init(&memcg->thresholds_lock);
+	spin_lock_init(&memcg->move_lock);
+	INIT_LIST_HEAD(&memcg->event_list);
+	spin_lock_init(&memcg->event_list_lock);
+}
+
 void memcg1_css_offline(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup_event *event, *tmp;
--- a/mm/memcontrol-v1.h~mm-memcg-gather-memcg1-specific-fields-initialization-in-memcg1_memcg_init
+++ a/mm/memcontrol-v1.h
@@ -76,6 +76,7 @@ int memory_stat_show(struct seq_file *m,
 
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
+void memcg1_memcg_init(struct mem_cgroup *memcg);
 void memcg1_remove_from_trees(struct mem_cgroup *memcg);
 
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
@@ -124,6 +125,7 @@ extern struct cftype mem_cgroup_legacy_f
 
 #else	/* CONFIG_MEMCG_V1 */
 
+static inline void memcg1_memcg_init(struct mem_cgroup *memcg) {}
 static inline void memcg1_remove_from_trees(struct mem_cgroup *memcg) {}
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
 static inline bool memcg1_wait_acct_move(struct mem_cgroup *memcg) { return false; }
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

