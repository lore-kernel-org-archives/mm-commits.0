Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D3E3A1A29
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 19:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788378050; cv=none; b=rgkcLfaDphrZgp0QWkXv/yxVe/mnhyKlSR5jC8erRLU9/5NVowJ5iUm2Zg//QGHraF+hc0Qas+se7P9GNggU2HzQN5CuwUumu15bsJ3taoVcWZ8YmgukdxFldkUDPOVxzm8C6MEIBfDsnYypYu8QOpFYURuKDxVTWEBXDiQhzjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788378050; c=relaxed/simple;
	bh=vnTmsMgGqEgemvI7rqeqlJPPtKfB89DDevKB9axIKME=;
	h=Date:To:From:Subject:Message-Id; b=od6IqPXNuhtL8wUKswvYaCjUWFXjp2oOreYfp+BYhc5eXMXfF7PZLlNzaRb+5TaqsHtLNE/vYAXYd9hHkIkNXUJpNjFgoSZrbWQvU/dOtIccyUVSVnca4oGmY+SWFPpTDE2K0x2OhDaeAJQZa+oCA5ZE8g1Sxa3HGYmTgcs6ETY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jsm7mQBH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jsm7mQBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7C31F00ADB;
	Wed,  2 Sep 2026 19:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788378033;
	bh=tYeFobzRvA/vr1FWVAdupCoh/WBUQxdKFqwckgbM2fU=;
	h=Date:To:From:Subject;
	b=Jsm7mQBHGEdgI5Co7leHlLosxjPzBaHxUuR1AWCppzwQH9YjwLwEg+XWuKzCO7CBr
	 mk6mFj3o9WjR3lRUdNp6m684H6iscWHkjpQJ9CqS0YaivYZljJmxjTryfTzQpnd74y
	 jpnZeroEvWYhihQZBTDoqTYYKZQEPh8u8Yv2SUJw=
Date: Wed, 02 Sep 2026 12:40:32 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-remove-the-soft-limit-reclaim-tracepoints.patch added to mm-unstable branch
Message-Id: <20260902194033.0F7C31F00ADB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: remove the soft limit reclaim tracepoints
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-remove-the-soft-limit-reclaim-tracepoints.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-remove-the-soft-limit-reclaim-tracepoints.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove the soft limit reclaim tracepoints
Date: Wed, 2 Sep 2026 10:43:06 -0700

mm_vmscan_memcg_softlimit_reclaim_begin and
mm_vmscan_memcg_softlimit_reclaim_end were only emitted by
mem_cgroup_shrink_node(), which is gone, so they can never fire again.

Link: https://lore.kernel.org/20260902174311.1772372-4-shakeel.butt@linux.dev
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
memcg-remove-v1-soft-limit-reclaim.patch
memcg-remove-mem_cgroup_shrink_node.patch
memcg-remove-the-soft-limit-reclaim-tracepoints.patch
memcg-remove-the-soft-limit-rbtree.patch
memcg-remove-lru_gen_soft_reclaim.patch
memcg-remove-the-per-node-soft-limit-tree-fields.patch
memcg-remove-mem_cgroup-soft_limit.patch
memcg-simplify-v1-event-ratelimiting.patch

