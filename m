Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535F725332A
	for <mm-commits@vger.kernel.org>; Thu,  1 May 2025 20:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746131256; cv=none; b=EzgvcdmKcQ2JDsTg9jVsuInzbA+g78Atxztxf0sWZ6jQbHKR+I7AXBR3pAGpHfKiBNa66/9VHcq97TLMxAsQD07uVy7Up/3KVSL8S5IqdkuNBAiEmgoZTKy/ufjEKAZJ9RefmJuhkEf9O/Q8KfivsVIKcF0C6LZGQbTtGyrFTOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746131256; c=relaxed/simple;
	bh=lz5SfEog69KcH/oCrJQODLRvlkdbPWevNFhUBz3aOOc=;
	h=Date:To:From:Subject:Message-Id; b=HOjRObxTcceG+hlPwFkdz14AcBbL/p6M88oyc4SEAx4ggEkg7WDg28zSHMMqIeB7220yVDtgDNVRT/g4Dt6WEciUr2gF5KhTCMfMfNFB3thy1jB5gL/srA10ULAJs0RG4YLk2mHlmNBjrl8thj8c/1h14NtTEW0Gk2CihKtupAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nKZwVTIx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nKZwVTIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F215C4CEE4;
	Thu,  1 May 2025 20:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746131256;
	bh=lz5SfEog69KcH/oCrJQODLRvlkdbPWevNFhUBz3aOOc=;
	h=Date:To:From:Subject:From;
	b=nKZwVTIxhLB7QR5zTDKmunJTSxezF3gEflux4UPp6/+DGAmJaSiLdZNgU6PygFJmg
	 8iYh7vkhCP/z3aDhaKOhHK3C9BBh2tBb5181roZWT+oLW9puSyjofsVQPCoZnAArg7
	 bKKJvl7twHnlIp6/rB1l/iTjPfgLpen8Ro/MJgPw=
Date: Thu, 01 May 2025 13:27:35 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,chen.haonan2@zte.com.cn,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcontrol-introduce-the-new-mem_cgroup_scan_tasks.patch added to mm-new branch
Message-Id: <20250501202736.1F215C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcontrol: introduce the new mem_cgroup_scan_tasks()
has been added to the -mm mm-new branch.  Its filename is
     memcontrol-introduce-the-new-mem_cgroup_scan_tasks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcontrol-introduce-the-new-mem_cgroup_scan_tasks.patch

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
@@ -1167,6 +1167,30 @@ static void invalidate_reclaim_iterators
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

memcontrol-rename-mem_cgroup_scan_tasks.patch
memcontrol-introduce-the-new-mem_cgroup_scan_tasks.patch
memcontrol-introduce-ksm_stat-at-memcg-v2.patch
memcontrol-add-ksm_zero_pages-in-cgroup-memoryksm_stat.patch
memcontrol-add-ksm_merging_pages-in-cgroup-memoryksm_stat.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat.patch
memcontrol-v1-add-ksm_stat-at-memcg-v1.patch
documentation-add-ksm_stat-description-in-cgroup-v1-memoryrst.patch
documentation-add-ksm_stat-description-in-cgroup-v2rst.patch

