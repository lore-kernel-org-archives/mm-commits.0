Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E11BE6C
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141611; cv=none; b=KlKcwO1oma/RwOJiRLU9PUzJtNH3ASyzwmfPy8tLc6hm84HVc8sZPSv+7qQOZnY3xx+WKuMjCP/jhAUq5lIX5kEgLi6r5qFKWx9H8WeMTqZltretj8Mcwwztw+SwAwqX4v0LYkC6t3SK/ITHPkRO1MEtSGz1F9h1WmjXSKzjnwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141611; c=relaxed/simple;
	bh=FLPxDwaz0ZKtrN8T1Wefi0YBPs6oEeob1XuKKUOflmA=;
	h=Date:To:From:Subject:Message-Id; b=cyAgc0l/UYrL1t6pq7O01mcI/nQbgU2296bd5z0ttLBKJ5f0f3n8D/4RHMUr0u3J0qZ1oY8Bv3l1NbmhgvRFGBVt3EuRZmXBER3Fh0lqO+U7Zccjf0pvvj+SLufudwIBqkAZI9F8kpqQYZvW05aFku3PqiAAvseumIaAauJNjDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sXFH8svI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sXFH8svI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66F5C4AF0A;
	Fri,  5 Jul 2024 01:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141610;
	bh=FLPxDwaz0ZKtrN8T1Wefi0YBPs6oEeob1XuKKUOflmA=;
	h=Date:To:From:Subject:From;
	b=sXFH8svItfL02Q08tL/d5yX97fBD0GHlVFNmTmADhNY1VMzB7gW4tmGFhgwUod0W8
	 A0uZmClHmqe6kY+6rxM89tAiZai6YuU88c8I8TI+/vKC1cAmZ2FAPhAdnSWKLEFmxf
	 6t6RkFhhlCdDISizOIUaj7TMwAObi5ZglalVcCl4=
Date: Thu, 04 Jul 2024 18:06:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-make-memcg1_update_tree-static.patch removed from -mm tree
Message-Id: <20240705010650.B66F5C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: make memcg1_update_tree() static
has been removed from the -mm tree.  Its filename was
     mm-memcg-make-memcg1_update_tree-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: make memcg1_update_tree() static
Date: Mon, 24 Jun 2024 17:59:03 -0700

memcg1_update_tree() is not used outside of mm/memcontrol-v1.c anymore,
define it as static and remove the declaration from the header file.

Link: https://lkml.kernel.org/r/20240625005906.106920-12-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    2 +-
 mm/memcontrol-v1.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memcontrol-v1.c~mm-memcg-make-memcg1_update_tree-static
+++ a/mm/memcontrol-v1.c
@@ -201,7 +201,7 @@ static unsigned long soft_limit_excess(s
 	return excess;
 }
 
-void memcg1_update_tree(struct mem_cgroup *memcg, int nid)
+static void memcg1_update_tree(struct mem_cgroup *memcg, int nid)
 {
 	unsigned long excess;
 	struct mem_cgroup_per_node *mz;
--- a/mm/memcontrol-v1.h~mm-memcg-make-memcg1_update_tree-static
+++ a/mm/memcontrol-v1.h
@@ -5,7 +5,6 @@
 
 #include <linux/cgroup-defs.h>
 
-void memcg1_update_tree(struct mem_cgroup *memcg, int nid);
 void memcg1_remove_from_trees(struct mem_cgroup *memcg);
 
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

