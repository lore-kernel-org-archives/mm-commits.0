Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798A62DAFAF
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 19:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377607; cv=none; b=jC2yJWNUlJCjy8GD399vqBKcbJt/JbJT2C+KTYLRSHCT1QT/MBDlTyD08PEM5mg+q/zXqNjek1RtcgYo1bptGPh1dE6SXxmgRRkyCoe4KtPwvcRv/7u74g8WYGj7HgAcTYCPCqn/poXH8Es2soiIlCJOZRPXMr/f+G6mNECIy9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377607; c=relaxed/simple;
	bh=cjMaKbJLCe2dte6aKXVZc7r2GOCpBKnEXXV3jHmZGjg=;
	h=Date:To:From:Subject:Message-Id; b=JmvjYfYKWT94GAeFxdT4frgJknYuQE29GCNNt+4f50bjji6wI1Dpxa8bzoQaNkqYoFQcF5ORq4PGTzW8XvAmqVQ3NYN52I89+n08kT1wMx5vY9gu4o4qzpW9ztAyrPUQmxWAly0PkTCQsdfcE5bnz886GwtKdHY7qRo4DjRjyIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fq43LGHl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fq43LGHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729FE1F00ACA;
	Wed,  2 Sep 2026 19:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788377594;
	bh=PZVm69VSbPMlVIZSfCZmWwh63UvisZrdDfnVmhvdUo0=;
	h=Date:To:From:Subject;
	b=fq43LGHlNLOJ5DK+OX7AdQLP8mF7DSVRCht0CeD8SUCLre6uGGEjSOOajqMrBWOWN
	 1Qe4tJOOb64Ef14NEzm9o2FlLzKuFyqL+pN/NeMB4/zNCqoOiSYh/XJTaM5ZTDSDLl
	 cb3gh9TWqAKIrw4zxd+7VQMvQCIpTeew6rqs/va4=
Date: Wed, 02 Sep 2026 12:33:14 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] memcg-remove-mem_cgroup-soft_limit.patch removed from -mm tree
Message-Id: <20260902193314.729FE1F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: remove mem_cgroup->soft_limit
has been removed from the -mm tree.  Its filename was
     memcg-remove-mem_cgroup-soft_limit.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove mem_cgroup->soft_limit
Date: Tue, 11 Aug 2026 13:32:02 -0700

Nothing reads it anymore, so the field and the helper that reset it on css
alloc and css reset can go.

Link: https://lore.kernel.org/20260811203203.3456029-9-shakeel.butt@linux.dev
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
memcg-simplify-v1-event-ratelimiting.patch
a.patch

