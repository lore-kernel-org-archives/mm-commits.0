Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257852512C6
	for <mm-commits@vger.kernel.org>; Thu,  1 May 2025 20:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746131255; cv=none; b=bD7PCROmboZ46H7IzucRSCnRUuM04w0YW7rwDjBDbPBNGOgIzr12XvLUPBVRYtKCgT7uQJQ+IoXwUOai6Fv5HdPzSoXEPQRLBCAUGS92Fs62duaFfhpMbAtHjNP85Mv+eoYF+KnATw78TEWo0dscudYW3mjPJL9SajW6W/Uoojc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746131255; c=relaxed/simple;
	bh=hGXvyqGk/zdKlhjSPTsy+6X0WdozgHHxMbzzJG+kuGo=;
	h=Date:To:From:Subject:Message-Id; b=uGqill9BWhB+cVAOPFq9Dn8T9Cf6l3MpCbAdlwX5AfiSRLq/NvGYDgsVt6LeGkeswE58SilWIN3G5ACd/UcGBQjtcqU7akuAx32aE7XUhhkUhQp5VY87oA4a8G8TNpi43+Zsf3HCL6E7bUs3TS8zkft4yS8pviFDHimBe5qMkM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iieR5KXa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iieR5KXa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD28C4CEE4;
	Thu,  1 May 2025 20:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746131254;
	bh=hGXvyqGk/zdKlhjSPTsy+6X0WdozgHHxMbzzJG+kuGo=;
	h=Date:To:From:Subject:From;
	b=iieR5KXaPEyXkAT+oAnEzlIS2+5PsRm594YggaH4XDnlAYWcVIAtYWLGxfyGkEIv+
	 EaQ792O8uuEmOLKMDMl1sOHnxj6zrjlsqgmuNKb6sMBEOxc9OTHNqginqU+Ghe53BU
	 kfgojOnI8TT/70uucTD/V4BNGC6NsDFoSnn/Htmc=
Date: Thu, 01 May 2025 13:27:34 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,chen.haonan2@zte.com.cn,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcontrol-rename-mem_cgroup_scan_tasks.patch added to mm-new branch
Message-Id: <20250501202734.8CD28C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcontrol: rename mem_cgroup_scan_tasks()
has been added to the -mm mm-new branch.  Its filename is
     memcontrol-rename-mem_cgroup_scan_tasks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcontrol-rename-mem_cgroup_scan_tasks.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: xu xin <xu.xin16@zte.com.cn>
Subject: memcontrol: rename mem_cgroup_scan_tasks()
Date: Thu, 1 May 2025 04:11:34 +0000

With the enablement of container-level KSM (e.g., via prctl [1]), there is
a growing demand for container-level observability of KSM behavior. 
However, current cgroup implementations lack support for exposing
KSM-related metrics.

This patchset introduces a new interface named ksm_stat at the cgroup
hierarchy level, enabling users to monitor KSM merging statistics
specifically for containers where this feature has been activated,
eliminating the need to manually inspect KSM information for each
individual process within the cgroup.

Users can obtain the KSM information of a cgroup just by:

# cat /sys/fs/cgroup/memory.ksm_stat
ksm_rmap_items 76800
ksm_zero_pages 0
ksm_merging_pages 76800
ksm_process_profit 309657600

This implementation supports both cgroup v2 and cgroup v1.


This patch (of 9):

Current Issue:
==============
mem_cgroup_scan_tasks in memcontrol.c has a naming ambiguity.  While its
name suggests it only iterates through processes belonging to the current
memcgroup, it actually scans all descendant cgroups under the subtree
rooted at this memcgroup.  This discrepancy can cause confusion for
developers relying on the semantic meaning of the function name.

Resolution:
===========
Renaming: We have renamed the original function to
**mem_cgroup_tree_scan_tasks** to explicitly reflect its subtree-traversal
behavior.

A subsequent patch will introduce a new mem_cgroup_scan_tasks function
that strictly iterates processes only within the current memcgroup,
aligning its behavior with its name.

Link: https://lkml.kernel.org/r/20250501120854885LyBCW0syCGojqnJ8crLVl@zte.com.cn
Link: https://lkml.kernel.org/r/20250501041134.3324145-1-xu.xin16@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Haonan Chen <chen.haonan2@zte.com.cn>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |    4 ++--
 mm/oom_kill.c              |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/memcontrol.h~memcontrol-rename-mem_cgroup_scan_tasks
+++ a/include/linux/memcontrol.h
@@ -795,7 +795,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 				   struct mem_cgroup *,
 				   struct mem_cgroup_reclaim_cookie *);
 void mem_cgroup_iter_break(struct mem_cgroup *, struct mem_cgroup *);
-void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
+void mem_cgroup_tree_scan_tasks(struct mem_cgroup *memcg,
 			   int (*)(struct task_struct *, void *), void *arg);
 
 static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
@@ -1290,7 +1290,7 @@ static inline void mem_cgroup_iter_break
 {
 }
 
-static inline void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
+static inline void mem_cgroup_tree_scan_tasks(struct mem_cgroup *memcg,
 		int (*fn)(struct task_struct *, void *), void *arg)
 {
 }
--- a/mm/memcontrol.c~memcontrol-rename-mem_cgroup_scan_tasks
+++ a/mm/memcontrol.c
@@ -1168,7 +1168,7 @@ static void invalidate_reclaim_iterators
 }
 
 /**
- * mem_cgroup_scan_tasks - iterate over tasks of a memory cgroup hierarchy
+ * mem_cgroup_tree_scan_tasks - iterate over tasks of a memory cgroup hierarchy
  * @memcg: hierarchy root
  * @fn: function to call for each task
  * @arg: argument passed to @fn
@@ -1180,7 +1180,7 @@ static void invalidate_reclaim_iterators
  *
  * This function must not be called for the root memory cgroup.
  */
-void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
+void mem_cgroup_tree_scan_tasks(struct mem_cgroup *memcg,
 			   int (*fn)(struct task_struct *, void *), void *arg)
 {
 	struct mem_cgroup *iter;
--- a/mm/oom_kill.c~memcontrol-rename-mem_cgroup_scan_tasks
+++ a/mm/oom_kill.c
@@ -367,7 +367,7 @@ static void select_bad_process(struct oo
 	oc->chosen_points = LONG_MIN;
 
 	if (is_memcg_oom(oc))
-		mem_cgroup_scan_tasks(oc->memcg, oom_evaluate_task, oc);
+		mem_cgroup_tree_scan_tasks(oc->memcg, oom_evaluate_task, oc);
 	else {
 		struct task_struct *p;
 
@@ -428,7 +428,7 @@ static void dump_tasks(struct oom_contro
 	pr_info("[  pid  ]   uid  tgid total_vm      rss rss_anon rss_file rss_shmem pgtables_bytes swapents oom_score_adj name\n");
 
 	if (is_memcg_oom(oc))
-		mem_cgroup_scan_tasks(oc->memcg, dump_task, oc);
+		mem_cgroup_tree_scan_tasks(oc->memcg, dump_task, oc);
 	else {
 		struct task_struct *p;
 		int i = 0;
@@ -1056,7 +1056,7 @@ static void oom_kill_process(struct oom_
 	if (oom_group) {
 		memcg_memory_event(oom_group, MEMCG_OOM_GROUP_KILL);
 		mem_cgroup_print_oom_group(oom_group);
-		mem_cgroup_scan_tasks(oom_group, oom_kill_memcg_member,
+		mem_cgroup_tree_scan_tasks(oom_group, oom_kill_memcg_member,
 				      (void *)message);
 		mem_cgroup_put(oom_group);
 	}
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

memcontrol-rename-mem_cgroup_scan_tasks.patch
memcontrol-introduce-the-new-mem_cgroup_scan_tasks.patch
memcontrol-introduce-ksm_stat-at-memcg-v2.patch
memcontrol-add-ksm_zero_pages-in-cgroup-memoryksm_stat.patch
memcontrol-add-ksm_merging_pages-in-cgroup-memoryksm_stat.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat.patch
memcontrol-v1-add-ksm_stat-at-memcg-v1.patch
documentation-add-ksm_stat-description-in-cgroup-v1-memoryrst.patch
documentation-add-ksm_stat-description-in-cgroup-v2rst.patch

