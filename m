Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2148615A
	for <mm-commits@vger.kernel.org>; Sat,  8 Nov 2025 00:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762561494; cv=none; b=oRGLmTeKqKCPa6JqGv9DzNCmswDXuHDCntS5vryMvyd6+8hzzTcmH9zq9fYoiGlNxvJHS+/rZxIGRwcEEbWVuJlk7kg3jKBkCQ2cK2/7flwfYsvDSApBaKYJPmlU9g5I6wWk8KD7DqTbC6iaNn9m506v9TZABAv0C1iR6NsdUY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762561494; c=relaxed/simple;
	bh=4SqtQiKnYRy4rP90AS8c09YsF6wAzDz4o7rtqW5fJeI=;
	h=Date:To:From:Subject:Message-Id; b=RwKC7FMQEkCfZzcq7y5JWbZ4ZAV7ok6jsJKkqLL0FwKm8TuLUy9knPSKIyQ/qxY+g7uQfUsss02gW0qi833PEJBBv/8ss5WwdhukgPXd66KuWVBlNj9q4Wa07Ns0PdRk4RrVdhDDv73e0YTrx8FpeHx20dbkHhgIF/7zgOoC1Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v/rmSHPr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v/rmSHPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB24C116C6;
	Sat,  8 Nov 2025 00:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762561493;
	bh=4SqtQiKnYRy4rP90AS8c09YsF6wAzDz4o7rtqW5fJeI=;
	h=Date:To:From:Subject:From;
	b=v/rmSHPrpAhwl99vam2iP/2/Vkpz3Qd39QsA8pNRGgzmuHZEUk6Foe63MuFDm6Qy9
	 ddh5O8OrRWO96G9ZV88qBwCNFF7xRpyvYIClBUJAuhCIlbtZxM5wCVGOYXTGExpEjh
	 4AIZiYLuZr1kSNB2hhXB3+MBW3qyxk17+3tRf6Qg=
Date: Fri, 07 Nov 2025 16:24:52 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,songmuchun@bytedance.com,roman.gushchin@linux.dev,rientjes@google.com,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-dump-memcg-protection-info-on-oom-or-alloc-failures.patch added to mm-new branch
Message-Id: <20251108002453.4EB24C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: dump memcg protection info on oom or alloc failures
has been added to the -mm mm-new branch.  Its filename is
     mm-memcg-dump-memcg-protection-info-on-oom-or-alloc-failures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-dump-memcg-protection-info-on-oom-or-alloc-failures.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

memcg-net-track-network-throttling-due-to-memcg-memory-pressure.patch
memcg-manually-uninline-__memcg_memory_event.patch
mm-memcg-dump-memcg-protection-info-on-oom-or-alloc-failures.patch

