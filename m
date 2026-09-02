Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87634AEBD7
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 19:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788378058; cv=none; b=TN2lnEq8oq81JX4EMddliePvbqRJaBnF36mi0WjPx3OP55w/HZ4AcEJUnEuNIduOulRYZzo5cth8i06oBeVz8KVQp6hXQfnulRHjTCH1WwXwaIxe2A4EsdbtAxSlvWuNyh2P5px32qurdtupx2Gc7/oT5/rYhc+6BF/2VDMowMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788378058; c=relaxed/simple;
	bh=VkUGxbPa7ijrb1mVRb/I8P1arKnhDpcNkgIqGefMQgQ=;
	h=Date:To:From:Subject:Message-Id; b=NB7tV1KjArPuIHcSw9wzD43VeHXRqkInwoEUYrAdEtbPQZlt59O0GCNG6IkjgC2a6MnZH89rR4kC1g8lx3+qPr3QMYefWORPmTsoqG0O//1wOoLixqMaJcDhClzf+n1f1Q3ELg2cudMBhUsceGjkyZ1FqR30ZHm4v+bO+0z1i08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IEeX8CLN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IEeX8CLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A181A1F00A3F;
	Wed,  2 Sep 2026 19:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788378042;
	bh=Ka6UbGhygzKnRIpfwjF1bnlgv7dv6QA0dr58PpF3Ikw=;
	h=Date:To:From:Subject;
	b=IEeX8CLNVyQZVsKwklAzpOMyc0W9vBZtsNcT4U3pE+VhlL2esfBYI0cyjSvTYScOM
	 aaZ+/dJp36vawbK/I+uJQankAfoNUnBXY1gBKZywZoWzZgF7HseH7XcsyOAkvhkIwo
	 Fjwv6DJsyiIWaFL9TrKF/YYt/6tqMMpvVrwGjWbs=
Date: Wed, 02 Sep 2026 12:40:42 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-remove-mem_cgroup-soft_limit.patch added to mm-unstable branch
Message-Id: <20260902194042.A181A1F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: remove mem_cgroup->soft_limit
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-remove-mem_cgroup-soft_limit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-remove-mem_cgroup-soft_limit.patch

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
Subject: memcg: remove mem_cgroup->soft_limit
Date: Wed, 2 Sep 2026 10:43:10 -0700

Nothing reads it anymore, so the field and the helper that reset it on
css alloc and css reset can go.

Link: https://lore.kernel.org/20260902174311.1772372-8-shakeel.butt@linux.dev
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

 include/linux/memcontrol.h |    2 --
 mm/memcontrol-v1.h         |    6 ------
 mm/memcontrol.c            |    2 --
 3 files changed, 10 deletions(-)

--- a/include/linux/memcontrol.h~memcg-remove-mem_cgroup-soft_limit
+++ a/include/linux/memcontrol.h
@@ -280,8 +280,6 @@ struct mem_cgroup {
 
 	struct memcg1_events_percpu __percpu *events_percpu;
 
-	unsigned long soft_limit;
-
 	/* protected by memcg_oom_lock */
 	bool oom_lock;
 	int under_oom;
--- a/mm/memcontrol.c~memcg-remove-mem_cgroup-soft_limit
+++ a/mm/memcontrol.c
@@ -4257,7 +4257,6 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 		return ERR_CAST(memcg);
 
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
-	memcg1_soft_limit_reset(memcg);
 #ifdef CONFIG_ZSWAP
 	memcg->zswap_max = PAGE_COUNTER_MAX;
 	WRITE_ONCE(memcg->zswap_writeback, true);
@@ -4464,7 +4463,6 @@ static void mem_cgroup_css_reset(struct
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
-	memcg1_soft_limit_reset(memcg);
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	memcg_wb_domain_size_changed(memcg);
 }
--- a/mm/memcontrol-v1.h~memcg-remove-mem_cgroup-soft_limit
+++ a/mm/memcontrol-v1.h
@@ -42,11 +42,6 @@ void memcg1_free_events(struct mem_cgrou
 
 void memcg1_memcg_init(struct mem_cgroup *memcg);
 
-static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
-{
-	WRITE_ONCE(memcg->soft_limit, PAGE_COUNTER_MAX);
-}
-
 struct cgroup_taskset;
 void memcg1_css_offline(struct mem_cgroup *memcg);
 
@@ -97,7 +92,6 @@ static inline bool memcg1_alloc_events(s
 static inline void memcg1_free_events(struct mem_cgroup *memcg) {}
 
 static inline void memcg1_memcg_init(struct mem_cgroup *memcg) {}
-static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
 static inline void memcg1_css_offline(struct mem_cgroup *memcg) {}
 
 static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked)
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

