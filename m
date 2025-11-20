Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD062F60A4
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675099; cv=none; b=efxuCuDm974RzF+ursxJaEXCKgYf9gD3LhTyQsWJfQyeggTjalvLK4rZbEg1VFVCRhNZWApj+mQKDR9b9hYKzyBkx6jmPr4cfBc34EUeynz3i3JXmg1TIMmr0cCJdwhduCz0nVrMq+cXqqk7jLg0PNvDgU5W7bblUqzgQBy1uG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675099; c=relaxed/simple;
	bh=HNeHgrd3Lav2YGsKeGHoLZzpqGMAkU97eGevpf9hd78=;
	h=Date:To:From:Subject:Message-Id; b=NI1SJVaqMJeKmsy4aNI9T5jXXZkOSzMgKvHY9hxZLshh/MmvKY6V5iJ6d+yOrzH46YF1/JrSxlXjPptd74p8qRcNFfw7JTMqUnHw8KjxgHZ8wPdJ4XsMN4Jl32UAMQsPDP4tAf++iihCVIrHQTFq5+1Yp/OQH1QTu12AMYJUdTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s6TrDye9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s6TrDye9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80FCC4CEF1;
	Thu, 20 Nov 2025 21:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675098;
	bh=HNeHgrd3Lav2YGsKeGHoLZzpqGMAkU97eGevpf9hd78=;
	h=Date:To:From:Subject:From;
	b=s6TrDye94TG2DmVx5ZLP8lSjmGK7HaT7dDANUhhUzeMjgyNV0A1fPEmfUcNH/tKSR
	 ivAHiU3KJpRXmMmYuIr9U7O3h7H3mQRfbmqODJymml1AUZE64se8dvzikaWTvmksld
	 UedxDGi+MpqaZPK/OZqGzJHlw8wKCnUoLhWjsfyc=
Date: Thu, 20 Nov 2025 13:44:58 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,songmuchun@bytedance.com,roman.gushchin@linux.dev,rientjes@google.com,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-dump-memcg-protection-info-on-oom-or-alloc-failures.patch removed from -mm tree
Message-Id: <20251120214458.A80FCC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: dump memcg protection info on oom or alloc failures
has been removed from the -mm tree.  Its filename was
     mm-memcg-dump-memcg-protection-info-on-oom-or-alloc-failures.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm: memcg: dump memcg protection info on oom or alloc failures
Date: Fri, 7 Nov 2025 15:40:41 -0800

Currently kernel dumps memory state on oom and allocation failures.  One
of the question usually raised on those dumps is why the kernel has not
reclaimed the reclaimable memory instead of triggering oom.  One potential
reason is the usage of memory protection provided by memcg.  So, let's
also dump the memory protected by the memcg in such reports to ease the
debugging.

Link: https://lkml.kernel.org/r/20251107234041.3632644-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +++++
 mm/memcontrol.c            |   13 +++++++++++++
 mm/oom_kill.c              |    1 +
 mm/page_alloc.c            |    1 +
 4 files changed, 20 insertions(+)

--- a/include/linux/memcontrol.h~mm-memcg-dump-memcg-protection-info-on-oom-or-alloc-failures
+++ a/include/linux/memcontrol.h
@@ -1764,6 +1764,7 @@ static inline void count_objcg_events(st
 
 bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
 
+void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);
 #else
 static inline bool mem_cgroup_kmem_disabled(void)
 {
@@ -1830,6 +1831,10 @@ static inline bool mem_cgroup_node_allow
 {
 	return true;
 }
+
+static inline void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
+{
+}
 #endif /* CONFIG_MEMCG */
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
--- a/mm/memcontrol.c~mm-memcg-dump-memcg-protection-info-on-oom-or-alloc-failures
+++ a/mm/memcontrol.c
@@ -5635,3 +5635,16 @@ bool mem_cgroup_node_allowed(struct mem_
 {
 	return memcg ? cpuset_node_allowed(memcg->css.cgroup, nid) : true;
 }
+
+void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
+{
+	if (mem_cgroup_disabled() || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
+	if (!memcg)
+		memcg = root_mem_cgroup;
+
+	pr_warn("Memory cgroup min protection %lukB -- low protection %lukB",
+		K(atomic_long_read(&memcg->memory.children_min_usage)*PAGE_SIZE),
+		K(atomic_long_read(&memcg->memory.children_low_usage)*PAGE_SIZE));
+}
--- a/mm/oom_kill.c~mm-memcg-dump-memcg-protection-info-on-oom-or-alloc-failures
+++ a/mm/oom_kill.c
@@ -472,6 +472,7 @@ static void dump_header(struct oom_contr
 		if (should_dump_unreclaim_slab())
 			dump_unreclaimable_slab();
 	}
+	mem_cgroup_show_protected_memory(oc->memcg);
 	if (sysctl_oom_dump_tasks)
 		dump_tasks(oc);
 }
--- a/mm/page_alloc.c~mm-memcg-dump-memcg-protection-info-on-oom-or-alloc-failures
+++ a/mm/page_alloc.c
@@ -3977,6 +3977,7 @@ static void warn_alloc_show_mem(gfp_t gf
 		filter &= ~SHOW_MEM_FILTER_NODES;
 
 	__show_mem(filter, nodemask, gfp_zone(gfp_mask));
+	mem_cgroup_show_protected_memory(NULL);
 }
 
 void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-use-mod_node_page_state-to-update-stats.patch
memcg-remove-__mod_lruvec_kmem_state.patch
memcg-remove-__mod_lruvec_state.patch
memcg-remove-__lruvec_stat_mod_folio.patch

