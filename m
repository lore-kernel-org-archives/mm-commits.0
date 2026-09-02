Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3E21F419A
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 19:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377609; cv=none; b=K/5sS7XkYr4g5L+NlBglAGYmJp5zqF2NEUiOIOO/Bn9st2ooGJJ161mlFeHYhkqsa1LpvHb6c6/2FXDk5cOChivMCyuiuwgEYcReLtSIrXbk4fxd0Sn5w8eaR0eP3DPzFrBkcllYt8gd9nnxzgOywxQfHVKX5yLhS+6KUNzmm5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377609; c=relaxed/simple;
	bh=tMRT9kqwCO5+AfvRIyMuaOwu2BL4mhcj26S3fyw+yok=;
	h=Date:To:From:Subject:Message-Id; b=X4dQVk6IKjpsy7fnmIQC/et3Xr6/mVljcuDgxtXOjz4PPxNE2vLciY5HRvlRDryQFvlVL5QHW4zEyOaxxrR5/qkNR4H3qdBeL/RWJmqfH6dDJhcBuFtUD1SeuEr9HKkZ9ulCzYR+Sal/HSuhYUjN+Gj7FiNyFlddh5yyzEr3JI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iBL3+2Nn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iBL3+2Nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7F31F00AC4;
	Wed,  2 Sep 2026 19:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788377593;
	bh=824NO7amO+0uOEooOafVJ6IoTBXUh1gNJjrC8Atne9g=;
	h=Date:To:From:Subject;
	b=iBL3+2NnOBvxbE25mipw70KDa6B18LIfJ45qTrAZYMhU6xSrBtaU+YYcPwH2F5Tz+
	 e3FhqwPoB/jkOdtPHdO9uCR/j/ad7hP3jG03NtCxCgd/S3H7GePKR1mhO9nLfxlpn5
	 9fQWqs04kMIlBJVz6YBlKImJkU7EQEYMrRVqFnfA=
Date: Wed, 02 Sep 2026 12:33:12 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] memcg-remove-the-per-node-soft-limit-tree-fields.patch removed from -mm tree
Message-Id: <20260902193313.3B7F31F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: remove the per-node soft limit tree fields
has been removed from the -mm tree.  Its filename was
     memcg-remove-the-per-node-soft-limit-tree-fields.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove the per-node soft limit tree fields
Date: Tue, 11 Aug 2026 13:32:01 -0700

tree_node, usage_in_excess and on_tree only existed for the soft limit
rbtree.  They also doubled as the buffer between the read-mostly head of
struct mem_cgroup_per_node and its update-often tail, so replace them with
the explicit padding that CONFIG_MEMCG_V1=n already used.

Link: https://lore.kernel.org/20260811203203.3456029-8-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

memcg-avoid-charging-the-root-memcg-from-obj_cgroup_charge_pages.patch
mm-mlock-use-the-irq-safe-accessor-for-nr_mlock-in-__munlock_folio.patch
memcg-clear-flushing_cached_charge-on-cpu-offline.patch
memcg-trim-the-per-cpu-charge-stock-instead-of-draining-it.patch
memcg-remove-mem_cgroup-soft_limit.patch
memcg-simplify-v1-event-ratelimiting.patch
a.patch

