Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497BF45BE3
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 20:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719348631; cv=none; b=Sw2xT8ImGDLR1xUtUGmBvkUW5xq4vHnqusBdOeihyUBDr/j4ZbbHXZV8S7Eb/F+ktZ24k3xkDwyB4se+MqlwHFvuy1b3YaKXz8IZsoDVHvAPOBDpEg0OpaEhj+bLsCI/4Rgu7DKV6GopbjqU4C/m0iaAQEOIFgORm4s1IK82tww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719348631; c=relaxed/simple;
	bh=SioCa9pBXJeEfAQvilbcMVh2WS7IEstLVUpPKsUzNSw=;
	h=Date:To:From:Subject:Message-Id; b=KCyvx7v1vkZuur+6V2kBCT1bRr8vKPmsS2ffovT7LXdS3cuOblT5G+BO8TdEqVdZkSEW54O3OGVmZu+GSslPp06fnGcg4ShPNGVD0GLGZJahj1jcv0vUklwVKxZCbZr4cREZhB5QpGVS+YJHyOam7j4N2fXQ6uT/m2aQXDaVX5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ng19sbLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ng19sbLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC945C32781;
	Tue, 25 Jun 2024 20:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719348630;
	bh=SioCa9pBXJeEfAQvilbcMVh2WS7IEstLVUpPKsUzNSw=;
	h=Date:To:From:Subject:From;
	b=ng19sbLMAzwHIfm6evCjM0UJBPWRskbGS/tQDdXEi0ILiz0VAiNNJer2nnx9qttdx
	 ogwN4Me8815BF/eW/og9k1Y7HzsvU2QXWxehDtPjqX+TcWY3DR8tSYsRSAC4LEYaVH
	 7zRvzu2hpkQlXd0ugcA47TlrZp27MiBq74jr++eI=
Date: Tue, 25 Jun 2024 13:50:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-rename-memcg_check_events.patch added to mm-unstable branch
Message-Id: <20240625205030.BC945C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: rename memcg_check_events()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-rename-memcg_check_events.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-rename-memcg_check_events.patch

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
Subject: mm: memcg: rename memcg_check_events()
Date: Mon, 24 Jun 2024 17:58:59 -0700

Rename memcg_check_events() into memcg1_check_events() for consistency
with other cgroup v1-specific functions.

Link: https://lkml.kernel.org/r/20240625005906.106920-8-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    6 +++---
 mm/memcontrol-v1.h |    2 +-
 mm/memcontrol.c    |    8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-rename-memcg_check_events
+++ a/mm/memcontrol.c
@@ -2630,7 +2630,7 @@ void mem_cgroup_commit_charge(struct fol
 
 	local_irq_disable();
 	mem_cgroup_charge_statistics(memcg, folio_nr_pages(folio));
-	memcg_check_events(memcg, folio_nid(folio));
+	memcg1_check_events(memcg, folio_nid(folio));
 	local_irq_enable();
 }
 
@@ -5662,7 +5662,7 @@ static void uncharge_batch(const struct
 	local_irq_save(flags);
 	__count_memcg_events(ug->memcg, PGPGOUT, ug->pgpgout);
 	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, ug->nr_memory);
-	memcg_check_events(ug->memcg, ug->nid);
+	memcg1_check_events(ug->memcg, ug->nid);
 	local_irq_restore(flags);
 
 	/* drop reference from uncharge_folio */
@@ -5801,7 +5801,7 @@ void mem_cgroup_replace_folio(struct fol
 
 	local_irq_save(flags);
 	mem_cgroup_charge_statistics(memcg, nr_pages);
-	memcg_check_events(memcg, folio_nid(new));
+	memcg1_check_events(memcg, folio_nid(new));
 	local_irq_restore(flags);
 }
 
@@ -6069,7 +6069,7 @@ void mem_cgroup_swapout(struct folio *fo
 	memcg_stats_lock();
 	mem_cgroup_charge_statistics(memcg, -nr_entries);
 	memcg_stats_unlock();
-	memcg_check_events(memcg, folio_nid(folio));
+	memcg1_check_events(memcg, folio_nid(folio));
 
 	css_put(&memcg->css);
 }
--- a/mm/memcontrol-v1.c~mm-memcg-rename-memcg_check_events
+++ a/mm/memcontrol-v1.c
@@ -835,9 +835,9 @@ static int mem_cgroup_move_account(struc
 
 	local_irq_disable();
 	mem_cgroup_charge_statistics(to, nr_pages);
-	memcg_check_events(to, nid);
+	memcg1_check_events(to, nid);
 	mem_cgroup_charge_statistics(from, -nr_pages);
-	memcg_check_events(from, nid);
+	memcg1_check_events(from, nid);
 	local_irq_enable();
 out:
 	return ret;
@@ -1424,7 +1424,7 @@ static void mem_cgroup_threshold(struct
  * Check events in order.
  *
  */
-void memcg_check_events(struct mem_cgroup *memcg, int nid)
+void memcg1_check_events(struct mem_cgroup *memcg, int nid)
 {
 	if (IS_ENABLED(CONFIG_PREEMPT_RT))
 		return;
--- a/mm/memcontrol-v1.h~mm-memcg-rename-memcg_check_events
+++ a/mm/memcontrol-v1.h
@@ -12,7 +12,7 @@ static inline void memcg1_soft_limit_res
 }
 
 void mem_cgroup_charge_statistics(struct mem_cgroup *memcg, int nr_pages);
-void memcg_check_events(struct mem_cgroup *memcg, int nid);
+void memcg1_check_events(struct mem_cgroup *memcg, int nid);
 void memcg_oom_recover(struct mem_cgroup *memcg);
 int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		     unsigned int nr_pages);
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

