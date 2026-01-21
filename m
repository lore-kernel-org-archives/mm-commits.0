Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE1635A938
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966059; cv=none; b=MCvPK8JJnVgRTci+ZGmJAg06T80vhT0Wi8tUiP1RDHdJHnlclWuO2rYcFHq7EbQIsYpsq34i6f4B4dfKQTwSbcHwJvQHCD3dJ16+6F2B4169XFUHyVHezVw643CxKIyXaV04lpDRF3Ze63M1T5A91JPFOLxAkKw7XOKmJ1mEx20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966059; c=relaxed/simple;
	bh=GpLH1i/sq8CKRfxVwatbJwKzR0p6lNkMREDCFvxon2Y=;
	h=Date:To:From:Subject:Message-Id; b=AdYEJFP83cDj4LsgqjgyNIuu1SEpegnkd7N7TtjdNMLibbPjZGpMQsRJtT//KLb+zZZti3Ju4VYrVM6Gdmwfv3u9tqUnfyq8CdyY03i0IXr4mthVPQRmMp+8iqnCkztz4B6E0WSqqXofVFzP21CNnLMagB6oSJeUHaout/CeEtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EC9oO7QA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EC9oO7QA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BADC16AAE;
	Wed, 21 Jan 2026 03:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966059;
	bh=GpLH1i/sq8CKRfxVwatbJwKzR0p6lNkMREDCFvxon2Y=;
	h=Date:To:From:Subject:From;
	b=EC9oO7QAAT44EknOg7JUL3wH+jZTqHSnbEFuJAUs9lKC15LDZqgqMwpYyU6GO+gWI
	 Qijk1jtA9izL5NOa0q02t9wjx/UBCwMT4dt0153vOpUZsocZmxCwqEOelb9M80S+XP
	 YTAneNODDA3D8NLH2SR4coafXUbG5V2pDbFNDHG8=
Date: Tue, 20 Jan 2026 19:27:38 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,lujialin4@huawei.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,axelrasmussen@google.com,chenridong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-remove-mem_cgroup_size.patch removed from -mm tree
Message-Id: <20260121032739.33BADC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: remove mem_cgroup_size()
has been removed from the -mm tree.  Its filename was
     memcg-remove-mem_cgroup_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chen Ridong <chenridong@huawei.com>
Subject: memcg: remove mem_cgroup_size()
Date: Thu, 11 Dec 2025 01:30:19 +0000

The mem_cgroup_size helper is used only in apply_proportional_protection
to read the current memory usage.  Its semantics are unclear and
inconsistent with other sites, which directly call page_counter_read for
the same purpose.

Remove this helper and get its usage via mem_cgroup_protection for
clarity.  Additionally, rename the local variable 'cgroup_size' to 'usage'
to better reflect its meaning.

No functional changes intended.

Link: https://lkml.kernel.org/r/20251211013019.2080004-3-chenridong@huaweicloud.com
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lu Jialin <lujialin4@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   18 +++++++-----------
 mm/memcontrol.c            |    5 -----
 mm/vmscan.c                |    9 ++++-----
 3 files changed, 11 insertions(+), 21 deletions(-)

--- a/include/linux/memcontrol.h~memcg-remove-mem_cgroup_size
+++ a/include/linux/memcontrol.h
@@ -557,13 +557,15 @@ static inline bool mem_cgroup_disabled(v
 static inline void mem_cgroup_protection(struct mem_cgroup *root,
 					 struct mem_cgroup *memcg,
 					 unsigned long *min,
-					 unsigned long *low)
+					 unsigned long *low,
+					 unsigned long *usage)
 {
-	*min = *low = 0;
+	*min = *low = *usage = 0;
 
 	if (mem_cgroup_disabled())
 		return;
 
+	*usage = page_counter_read(&memcg->memory);
 	/*
 	 * There is no reclaim protection applied to a targeted reclaim.
 	 * We are special casing this specific case here because
@@ -919,8 +921,6 @@ static inline void mem_cgroup_handle_ove
 
 unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
 
-unsigned long mem_cgroup_size(struct mem_cgroup *memcg);
-
 void mem_cgroup_print_oom_context(struct mem_cgroup *memcg,
 				struct task_struct *p);
 
@@ -1102,9 +1102,10 @@ static inline void memcg_memory_event_mm
 static inline void mem_cgroup_protection(struct mem_cgroup *root,
 					 struct mem_cgroup *memcg,
 					 unsigned long *min,
-					 unsigned long *low)
+					 unsigned long *low,
+					 unsigned long *usage)
 {
-	*min = *low = 0;
+	*min = *low = *usage = 0;
 }
 
 static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
@@ -1327,11 +1328,6 @@ static inline unsigned long mem_cgroup_g
 {
 	return 0;
 }
-
-static inline unsigned long mem_cgroup_size(struct mem_cgroup *memcg)
-{
-	return 0;
-}
 
 static inline void
 mem_cgroup_print_oom_context(struct mem_cgroup *memcg, struct task_struct *p)
--- a/mm/memcontrol.c~memcg-remove-mem_cgroup_size
+++ a/mm/memcontrol.c
@@ -1621,11 +1621,6 @@ unsigned long mem_cgroup_get_max(struct
 	return max;
 }
 
-unsigned long mem_cgroup_size(struct mem_cgroup *memcg)
-{
-	return page_counter_read(&memcg->memory);
-}
-
 void __memcg_memory_event(struct mem_cgroup *memcg,
 			  enum memcg_memory_event event, bool allow_spinning)
 {
--- a/mm/vmscan.c~memcg-remove-mem_cgroup_size
+++ a/mm/vmscan.c
@@ -2451,9 +2451,9 @@ static inline void calculate_pressure_ba
 static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
 		struct scan_control *sc, unsigned long scan)
 {
-	unsigned long min, low;
+	unsigned long min, low, usage;
 
-	mem_cgroup_protection(sc->target_mem_cgroup, memcg, &min, &low);
+	mem_cgroup_protection(sc->target_mem_cgroup, memcg, &min, &low, &usage);
 
 	if (min || low) {
 		/*
@@ -2485,7 +2485,6 @@ static unsigned long apply_proportional_
 		 * again by how much of the total memory used is under
 		 * hard protection.
 		 */
-		unsigned long cgroup_size = mem_cgroup_size(memcg);
 		unsigned long protection;
 
 		/* memory.low scaling, make sure we retry before OOM */
@@ -2497,9 +2496,9 @@ static unsigned long apply_proportional_
 		}
 
 		/* Avoid TOCTOU with earlier protection check */
-		cgroup_size = max(cgroup_size, protection);
+		usage = max(usage, protection);
 
-		scan -= scan * protection / (cgroup_size + 1);
+		scan -= scan * protection / (usage + 1);
 
 		/*
 		 * Minimally target SWAP_CLUSTER_MAX pages to keep
_

Patches currently in -mm which might be from chenridong@huawei.com are


