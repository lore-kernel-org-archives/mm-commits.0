Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123493C10A7
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 19:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377598; cv=none; b=WANXfNjmAjuy4pJv8wpYUbCCkQBgtQ1YreP2QK7YkMWwWriPo9dlw9rNRmw8WlPLl/955t1J8EEPR/fMl083KvwtSVKvO4LBNdW+cCXF/kmRZQ+Jct8Odc3h00vDxROKcbTo8Z6T0+bWdz8cxCrdaNRHXZK0ip+u3NQd/o6DOqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377598; c=relaxed/simple;
	bh=ZZatbtZHfJPxxEfq6/3WSQD0RoAcJq4qX7Q3i6C8vYU=;
	h=Date:To:From:Subject:Message-Id; b=RkvRkxL3ZqImV2di6GJYvjCv7nksW8/0nwCMmy8BZ6vIE1Gejd5mmzcU4E4rFSyQfd0stkB+3bq06JDfO4eg4fcDWThpcrbBQxxVQ9ME9SwQCDj/ZyHG3IlEGzHv3MGSx6eMTUfz5XJ/7oHCHGSdF8cY/B1HJVFLZrhPuIbWVnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aJ+1bowB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aJ+1bowB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FAE1F00A3D;
	Wed,  2 Sep 2026 19:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788377589;
	bh=hwl+dfVQ3gFIuytIFn3BlZMPDfvb/BDp5LQFztpXziI=;
	h=Date:To:From:Subject;
	b=aJ+1bowBWFIHcOlJC9xkUtBeOjd7+0m7AvR+GZa+e0hNFjtox6NXKp150v9+r4nUR
	 aYhzGe+xl37IMEIqLIYqzBt4aoyPsQ2qIxRx+BMGF62sMYkB5x2i47rcNN2WTWcYO6
	 2KtK/JQ9Lqtpeo5g+eV7nPTfeqlsdhZKvUeUwOm8=
Date: Wed, 02 Sep 2026 12:33:09 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] memcg-remove-the-soft-limit-reclaim-tracepoints.patch removed from -mm tree
Message-Id: <20260902193309.82FAE1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: remove the soft limit reclaim tracepoints
has been removed from the -mm tree.  Its filename was
     memcg-remove-the-soft-limit-reclaim-tracepoints.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove the soft limit reclaim tracepoints
Date: Tue, 11 Aug 2026 13:31:58 -0700

mm_vmscan_memcg_softlimit_reclaim_begin and
mm_vmscan_memcg_softlimit_reclaim_end were only emitted by
mem_cgroup_shrink_node(), which is gone, so they can never fire again.

Link: https://lore.kernel.org/20260811203203.3456029-5-shakeel.butt@linux.dev
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

 include/trace/events/vmscan.h |   14 --------------
 1 file changed, 14 deletions(-)

--- a/include/trace/events/vmscan.h~memcg-remove-the-soft-limit-reclaim-tracepoints
+++ a/include/trace/events/vmscan.h
@@ -214,13 +214,6 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_be
 
 	TP_ARGS(gfp_flags, order, memcg)
 );
-
-DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_softlimit_reclaim_begin,
-
-	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
-
-	TP_ARGS(gfp_flags, order, memcg)
-);
 #endif /* CONFIG_MEMCG */
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
@@ -258,13 +251,6 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_en
 
 	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
 
-	TP_ARGS(nr_reclaimed, memcg)
-);
-
-DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_softlimit_reclaim_end,
-
-	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
-
 	TP_ARGS(nr_reclaimed, memcg)
 );
 #endif /* CONFIG_MEMCG */
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-avoid-charging-the-root-memcg-from-obj_cgroup_charge_pages.patch
mm-mlock-use-the-irq-safe-accessor-for-nr_mlock-in-__munlock_folio.patch
memcg-clear-flushing_cached_charge-on-cpu-offline.patch
memcg-trim-the-per-cpu-charge-stock-instead-of-draining-it.patch
memcg-remove-the-soft-limit-rbtree.patch
memcg-remove-lru_gen_soft_reclaim.patch
memcg-remove-the-per-node-soft-limit-tree-fields.patch
memcg-remove-mem_cgroup-soft_limit.patch
memcg-simplify-v1-event-ratelimiting.patch
a.patch

