Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973023019C8
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865957; cv=none; b=l7ZBM+pi17NZr7W/9pZnk3abv3dkFB3nL6sTSBzNpStWXS1F0b5+r3DzP+LKzu73Sw3bMRdLo0t1kZXrXu5TEYkXsBLCB7Cm0XatW+LWd0D8HiXoHPykY1xMsHaipUB7rGfb8ePkzLzPycEXBr83OVShAN5azg9fSRroJDHzHWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865957; c=relaxed/simple;
	bh=NFNOtxVjVl81vbwUQndTo9PTCSGTAUIbt5+6ThHvDBs=;
	h=Date:To:From:Subject:Message-Id; b=pmq5q6bC/HWjD3XaH7MddRFJdv0P1ZTSNGUGEE3V/EcfcVxepw9GhEQv+o2B3n5d6qlqXZbWQVnSYF5Cfh1pt1SW8LEO39/aJ+ik3zAlV60BsMslN6xnQM8ILEK8uC3GFCtQ3puQ05VS0kknVig0kgnjt09CsTeJCzl2zU2W9OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I/LqgVgj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I/LqgVgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711A21F00893;
	Tue, 13 Oct 2026 04:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865956;
	bh=dN5FD05RDOQ65YRpJwulk0gz3Uj2rYWBsws57YUDltA=;
	h=Date:To:From:Subject;
	b=I/LqgVgjCUtngxjkxdH9c2CXdbb/3r15vGMsxZuYW2IEIkCXSDu7un2ibBqURy80E
	 kY6R5ojC5tOE3ct4vBidPUGEnIz3/TZBqAYWHKp8iEPazQvtvBGyklPaqko8U8Qe0l
	 2r3KL33cqRusI1XlAxNGmdk3DTNds5EeGtmy8994=
Date: Mon, 12 Oct 2026 21:32:36 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,willy@infradead.org,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max.patch removed from -mm tree
Message-Id: <20261013043236.711A21F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: constify mem_cgroup_swappiness() and mem_cgroup_get_max()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: memcontrol: constify mem_cgroup_swappiness() and mem_cgroup_get_max()
Date: Tue, 15 Sep 2026 19:20:14 -0400

Both only read swappiness and the memory limits. Constify them.

Link: https://lore.kernel.org/20260915-folio_memcg-const-v3-10-c239a6010b58@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |    2 +-
 mm/swap.h                  |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max
+++ a/include/linux/memcontrol.h
@@ -941,7 +941,7 @@ static inline void mem_cgroup_handle_ove
 		__mem_cgroup_handle_over_high(gfp_mask);
 }
 
-unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
+unsigned long mem_cgroup_get_max(const struct mem_cgroup *memcg);
 
 void mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
 				struct task_struct *p);
@@ -1372,7 +1372,7 @@ unsigned long mem_cgroup_get_zone_lru_si
 	return 0;
 }
 
-static inline unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
+static inline unsigned long mem_cgroup_get_max(const struct mem_cgroup *memcg)
 {
 	return 0;
 }
--- a/mm/memcontrol.c~mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max
+++ a/mm/memcontrol.c
@@ -1898,7 +1898,7 @@ void mem_cgroup_print_oom_meminfo(struct
 /*
  * Return the memory (and swap, if configured) limit for a memcg.
  */
-unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
+unsigned long mem_cgroup_get_max(const struct mem_cgroup *memcg)
 {
 	unsigned long max = READ_ONCE(memcg->memory.max);
 
--- a/mm/swap.h~mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max
+++ a/mm/swap.h
@@ -82,7 +82,7 @@ enum swap_cluster_flags {
 
 extern int vm_swappiness;
 
-static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
+static inline int mem_cgroup_swappiness(const struct mem_cgroup *memcg)
 {
 #ifdef CONFIG_MEMCG_V1
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
_

Patches currently in -mm which might be from tz2294@columbia.edu are


