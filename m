Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991B72EB874
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334224; cv=none; b=ClH7SF+QnLKDWtjEh6II0gmTz6PrZEJiw6R1oGpy78hWgOv8hY+Gnho9GZwaADkdaHOsqP/yTMOQtrdVLtn+1KnpUw6Q/3LSgnv1Uq5jj29YWhtJG3uPSrDdg42JKEK53/CCSYD5MxtjQLyR55fBliadMJKrklqMvg7RCzeT2qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334224; c=relaxed/simple;
	bh=Bw9fUjG0mSbctVcPwNvLJlVh7cUEX+bAhArXWZFbGoQ=;
	h=Date:To:From:Subject:Message-Id; b=Tg2Khjs0qwu2KtV0GX889uWy04jUmeCCebvKHuF2qPUOqLDJVCrpvUX2fTaH8jvO1CbcZUEWzK7Tf5p+dgp1kKKuD92cfK22vAf3J+I1D/p0qq1uza9fK8lXUtL6fTUciU65PO1LYKxfVou0hfVTCK3550/f0x7XuVBoRDWYPvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=md24dL8b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="md24dL8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA531F0089B;
	Wed,  7 Oct 2026 00:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334223;
	bh=vBHQX4HFDAGLRyn5+JB+GhP1IxmvYbqOUlIQUNsckL8=;
	h=Date:To:From:Subject;
	b=md24dL8bvYPO/SGrEZDquuyEhGRq2WdkIGy8yY9IOyIEccuPQoZ5XsZD4fMZf/KCn
	 K5rU5Z5LMXwnm2Ky4YENT/+vyL7VcGVMGjEe5/sCusBjmDtjfmjVwX0W3kR7EFEzyp
	 yv/oa1ArwX5EHJd+Yda9l7lpAICff8vFB1WvMcGE=
Date: Tue, 06 Oct 2026 17:50:23 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-remove-the-per-node-soft-limit-tree-fields.patch removed from -mm tree
Message-Id: <20261007005023.6CA531F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: remove the per-node soft limit tree fields
has been removed from the -mm tree.  Its filename was
     memcg-remove-the-per-node-soft-limit-tree-fields.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove the per-node soft limit tree fields
Date: Wed, 2 Sep 2026 10:43:09 -0700

tree_node, usage_in_excess and on_tree only existed for the soft limit
rbtree. They also doubled as the buffer between the read-mostly head of
struct mem_cgroup_per_node and its update-often tail, so replace them
with the explicit padding that CONFIG_MEMCG_V1=n already used.

Link: https://lore.kernel.org/20260902174311.1772372-7-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: T.J. Mercier <tjmercier@google.com>
---

 include/linux/memcontrol.h |   13 -------------
 1 file changed, 13 deletions(-)

--- a/include/linux/memcontrol.h~memcg-remove-the-per-node-soft-limit-tree-fields
+++ a/include/linux/memcontrol.h
@@ -95,20 +95,7 @@ struct mem_cgroup_per_node {
 	struct lruvec_stats			*lruvec_stats;
 	struct shrinker_info __rcu	*shrinker_info;
 
-#ifdef CONFIG_MEMCG_V1
-	/*
-	 * Memcg-v1 only stuff in middle as buffer between read mostly fields
-	 * and update often fields to avoid false sharing. If v1 stuff is
-	 * not present, an explicit padding is needed.
-	 */
-
-	struct rb_node		tree_node;	/* RB tree node */
-	unsigned long		usage_in_excess;/* Set to the value by which */
-						/* the soft limit is exceeded*/
-	bool			on_tree;
-#else
 	CACHELINE_PADDING(_pad1_);
-#endif
 
 	/* Fields which get updated often at the end. */
 	struct lruvec		lruvec;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-move-per-node-objcg-to-the-read-mostly-fields.patch
memcg-split-mem_cgroup_private_id-into-two-fields.patch
memcg-group-the-write-hot-fields-of-struct-mem_cgroup.patch
memcg-group-the-cold-fields-of-struct-mem_cgroup.patch
memcg-group-the-read-mostly-fields-of-struct-mem_cgroup.patch
memcg-group-the-fields-of-struct-mem_cgroup_per_node.patch

