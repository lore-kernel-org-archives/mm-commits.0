Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEB91EF375
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119332; cv=none; b=TP2NMZsh2QRCGa44wnKLwtKuox2fCrIYbb0gsciD7oXaAvEZSXir9clJKbyg2OZBZfwADXSSLo/L5VjyebiHyJ2s/WeqVHq5ryk3/xe8Awu8KV+iTpLs78PoLyDlusgF/YiZYYgbIqV8eZG9QWPPVHBJmgdzrQ/ciHNkLU/r21U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119332; c=relaxed/simple;
	bh=KoMWCZCKN6d2yhJyfJLPLbxdN8ZJJRigJoNF9zxjSHo=;
	h=Date:To:From:Subject:Message-Id; b=mYOERheGG9B3UYubbp6FqmQ/lymXlVdViQkdlRgYd5MPG2+Do84vT/sIFFIL651Geq1gTD3/QVw2hcRraMs0lwaOrmAkpjxfd0j4Umiw27CD9NsYbztTIc59D6Dhwmc+P6EYDgkkTp4MdbBDGZwJpXA7fzmfImykg06lRiW69J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gjE5E83w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gjE5E83w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D79C4CEE4;
	Tue, 13 May 2025 06:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119331;
	bh=KoMWCZCKN6d2yhJyfJLPLbxdN8ZJJRigJoNF9zxjSHo=;
	h=Date:To:From:Subject:From;
	b=gjE5E83wW9P9UGPgKKYUvdMlzHt5olWSngy9IGHLMeFqJnHOY1+c+N9XPVAB/5txN
	 NTZofKy9fNfYQjQM7U1KCI9xMQtFv8Bae5JL5bWAJKEmA3vPKo4gVFbXqjh/1ESyY2
	 P4NH4ruUc0YdXaWO+YkIPH3VKOKyE4y4C1J6sp24=
Date: Mon, 12 May 2025 23:55:31 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,chen.haonan2@zte.com.cn,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcontrol-rename-mem_cgroup_scan_tasks.patch removed from -mm tree
Message-Id: <20250513065531.D8D79C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcontrol: rename mem_cgroup_scan_tasks()
has been removed from the -mm tree.  Its filename was
     memcontrol-rename-mem_cgroup_scan_tasks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1166,7 +1166,7 @@ static void invalidate_reclaim_iterators
 }
 
 /**
- * mem_cgroup_scan_tasks - iterate over tasks of a memory cgroup hierarchy
+ * mem_cgroup_tree_scan_tasks - iterate over tasks of a memory cgroup hierarchy
  * @memcg: hierarchy root
  * @fn: function to call for each task
  * @arg: argument passed to @fn
@@ -1178,7 +1178,7 @@ static void invalidate_reclaim_iterators
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


