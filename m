Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9811EEA47
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119333; cv=none; b=VXIqwdr3rpighED2oqySO0oSd5O9h4YJySYtqu2IKsbvfQQ1Yl3ZdeW4Pbre7JgocJzM0/G04xQIXags1SG/BVBLhf7MYsEB51XNarhd32Irbun/s1beemwayaeoL70R6xCEK2qxN0PaI+C6OOvy055emdB3wFXRkq8ZqcLtMvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119333; c=relaxed/simple;
	bh=18CHgtJU9JkEyATR0hZK1HIR8dkjqnfUi4P79xzw/uM=;
	h=Date:To:From:Subject:Message-Id; b=Nh4iYcJ/pNxAa2hkNTcU/+SbEkJsWM4WFmrbMIsxrpqfZOTafMlUtbPQiaP0RKuQ9w2rQoRnSbBJR6rsF2LhdQeMqnJM5Z/thyU2jLZz46rVdj7Cga1C7jiwRUCmhODFg4kfNzaBXWYD7MgzyWKPHPLwdCGi52NUs4MYLt9ZDNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ieqLjMKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ieqLjMKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157F5C4CEE4;
	Tue, 13 May 2025 06:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119333;
	bh=18CHgtJU9JkEyATR0hZK1HIR8dkjqnfUi4P79xzw/uM=;
	h=Date:To:From:Subject:From;
	b=ieqLjMKnXtDpx3p8jTkRM0bDDR42/jQ2exW6Rmsjr69PG6zxR0kIYZOiFakFtfK7g
	 fs+Jzrml+10KMK8fYVT7d9EZ3a3tqj9RHnS8hli0CAUNnTOF76k8+JigU1o09Fq5+6
	 pBb1SLrq0/He/8jLgMyHq9SbDYeisKdzMaFKFzNY=
Date: Mon, 12 May 2025 23:55:32 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,chen.haonan2@zte.com.cn,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcontrol-introduce-the-new-mem_cgroup_scan_tasks.patch removed from -mm tree
Message-Id: <20250513065533.157F5C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcontrol: introduce the new mem_cgroup_scan_tasks()
has been removed from the -mm tree.  Its filename was
     memcontrol-introduce-the-new-mem_cgroup_scan_tasks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: memcontrol: introduce the new mem_cgroup_scan_tasks()
Date: Thu, 1 May 2025 04:13:50 +0000

Introduce a new mem_cgroup_scan_tasks function that strictly iterates
processes only within the current memcgroup, aligning its behavior with
its name.

Link: https://lkml.kernel.org/r/20250501041350.3324212-1-xu.xin16@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Haonan Chen <chen.haonan2@zte.com.cn>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 +++++++
 mm/memcontrol.c            |   24 ++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

--- a/include/linux/memcontrol.h~memcontrol-introduce-the-new-mem_cgroup_scan_tasks
+++ a/include/linux/memcontrol.h
@@ -795,6 +795,8 @@ struct mem_cgroup *mem_cgroup_iter(struc
 				   struct mem_cgroup *,
 				   struct mem_cgroup_reclaim_cookie *);
 void mem_cgroup_iter_break(struct mem_cgroup *, struct mem_cgroup *);
+void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
+			   int (*)(struct task_struct *, void *), void *arg);
 void mem_cgroup_tree_scan_tasks(struct mem_cgroup *memcg,
 			   int (*)(struct task_struct *, void *), void *arg);
 
@@ -1290,6 +1292,11 @@ static inline void mem_cgroup_iter_break
 {
 }
 
+static inline void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
+		int (*fn)(struct task_struct *, void *), void *arg)
+{
+}
+
 static inline void mem_cgroup_tree_scan_tasks(struct mem_cgroup *memcg,
 		int (*fn)(struct task_struct *, void *), void *arg)
 {
--- a/mm/memcontrol.c~memcontrol-introduce-the-new-mem_cgroup_scan_tasks
+++ a/mm/memcontrol.c
@@ -1165,6 +1165,30 @@ static void invalidate_reclaim_iterators
 						dead_memcg);
 }
 
+/* *
+ * mem_cgroup_scan_tasks - iterate over tasks of only this memory cgroup.
+ * @memcg: the specified memory cgroup.
+ * @fn: function to call for each task
+ * @arg: argument passed to @fn
+ *
+ * Unlike mem_cgroup_tree_scan_tasks(), this function only iterate over
+ * these tasks attached to @memcg, not including any of its descendants
+ * memcg. And this could be called for the root memory cgroup.
+ */
+void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
+			  int (*fn)(struct task_struct *, void *), void *arg)
+{
+	int ret = 0;
+	struct css_task_iter it;
+	struct task_struct *task;
+
+	css_task_iter_start(&memcg->css, CSS_TASK_ITER_PROCS, &it);
+	while (!ret && (task = css_task_iter_next(&it)))
+		ret = fn(task, arg);
+
+	css_task_iter_end(&it);
+}
+
 /**
  * mem_cgroup_tree_scan_tasks - iterate over tasks of a memory cgroup hierarchy
  * @memcg: hierarchy root
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are


