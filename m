Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E29D2EF653
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334226; cv=none; b=u1gekDLUzC3lD2jQXvBTY6LkOKJMqTPgGXQUdxPfaCEckUjMLqGrPDTdBYVAqczO6AlA0vOPtvqPsN/AS+arHaKCxClSakSJtULOM/dP4TxgvngTsRdcCjUEZMv2pnS8UTyOW3Oa0JC+LowPL9rdk5Bs21WFiC3F/mT4tFzoiAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334226; c=relaxed/simple;
	bh=yR6QjUNSL/DGF/5WvCMBqd98j8HUMIyIpFOSG8wt8pY=;
	h=Date:To:From:Subject:Message-Id; b=RqY04Rw+Dz04SVw/Lg61cnVNTZTWBskhRYAHs+41RB06WlIAG6f2EgAyP9BGqoR2NsEQ39DvFKwMPuvGxcgou988o6HCALQpiz3O/5xFUC1KhEHp3XiLQZUFQ/2W8rQTxxAIvwvmyPjjC7Ms8VofGV7p1hSI6PWWui6llzF3WGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EOkuQR0S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EOkuQR0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56C41F0089B;
	Wed,  7 Oct 2026 00:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334224;
	bh=TsQVuoCmH72RXi51+EyTOhDwpNaGgMtRFXww34omb6s=;
	h=Date:To:From:Subject;
	b=EOkuQR0SsA/dFnV5kNApwrc6aVxOT0FGcUVXgg6AN+2pLEF8TUYMlxGODZH7Iz/Vi
	 lwTfZ61FSy8N0/PyKlrtQVj1d3E5n5UJ2a6jd5dmJGc/fjQUEZNm09xDZY61ZOZiJu
	 2pYvwh81xDFW7QLorNBZH2HIlPACe3jcTb/4cEvo=
Date: Tue, 06 Oct 2026 17:50:24 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-remove-mem_cgroup-soft_limit.patch removed from -mm tree
Message-Id: <20261007005024.D56C41F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: remove mem_cgroup->soft_limit
has been removed from the -mm tree.  Its filename was
     memcg-remove-mem_cgroup-soft_limit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove mem_cgroup->soft_limit
Date: Wed, 2 Sep 2026 10:43:10 -0700

Nothing reads it anymore, so the field and the helper that reset it on
css alloc and css reset can go.

Link: https://lore.kernel.org/20260902174311.1772372-8-shakeel.butt@linux.dev
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

memcg-move-per-node-objcg-to-the-read-mostly-fields.patch
memcg-split-mem_cgroup_private_id-into-two-fields.patch
memcg-group-the-write-hot-fields-of-struct-mem_cgroup.patch
memcg-group-the-cold-fields-of-struct-mem_cgroup.patch
memcg-group-the-read-mostly-fields-of-struct-mem_cgroup.patch
memcg-group-the-fields-of-struct-mem_cgroup_per_node.patch

