Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8F0318EE5
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486682; cv=none; b=jgvzYHH+jhEWEYte4rxh/n67qa5tJi9/yFkEsfPol2gNqO1cU9u8aI1jjTg3EUhnfrkPcazi0YEP2wkn45n4Nls39u6agKqHJKxjpmM9F9XtFy7T8K/1n6Oxmr9qHUO7X12uAG6SelE6X83vFy2+t/Slovv+h40iBrAJ1+mPWU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486682; c=relaxed/simple;
	bh=Loqm9h4sVxK5gB8f5yvW7ODwWZYr0pxIDeLAoqL64GU=;
	h=Date:To:From:Subject:Message-Id; b=O4lcOSuAezStJ994n+pfH75IuxjaFAgaVYRRVmVLPQtHV8SwvDxv2alJLd7ACrjbq6ssCur5GCSHmiAIYl9aBsVdU1P2UTwop5Ds9TyTDRY82R5okxjdsyEnab1WG4xS8RwNtFxe6qfIonvR9FWzNGDV9hq9Y0UW31YPTlRoHMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rreShM7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rreShM7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8F2C116C6;
	Tue, 27 Jan 2026 04:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486682;
	bh=Loqm9h4sVxK5gB8f5yvW7ODwWZYr0pxIDeLAoqL64GU=;
	h=Date:To:From:Subject:From;
	b=rreShM7/LEWcTPnl1dDkOsvaUVAS3QY+4MApWbAtO3UvwEa6KPg4JiDyR9ouy3dbM
	 P4b/WlisUgkUbyONL95Lzh0xAbG2Mt8kiyAaqc4yZp8agE3QF3o4Q85qBWb5ykX+SA
	 J3mAAVrF974afOgBCHI+2XbXH6km3af27EeshQxI=
Date: Mon, 26 Jan 2026 20:04:41 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,sj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-remove-unused-mem_cgroup_id-and-mem_cgroup_from_id.patch removed from -mm tree
Message-Id: <20260127040441.EC8F2C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: remove unused mem_cgroup_id() and mem_cgroup_from_id()
has been removed from the -mm tree.  Its filename was
     memcg-remove-unused-mem_cgroup_id-and-mem_cgroup_from_id.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove unused mem_cgroup_id() and mem_cgroup_from_id()
Date: Thu, 25 Dec 2025 15:21:15 -0800

Now that all callers have been converted to use either:
 - The private ID APIs (mem_cgroup_private_id/mem_cgroup_from_private_id)
   for internal kernel objects that outlive their cgroup
 - The public cgroup ID APIs (mem_cgroup_ino/mem_cgroup_get_from_ino)
   for external interfaces

Remove the unused wrapper functions mem_cgroup_id() and
mem_cgroup_from_id() along with their !CONFIG_MEMCG stubs.

Link: https://lkml.kernel.org/r/20251225232116.294540-8-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   18 ------------------
 mm/memcontrol.c            |    5 -----
 2 files changed, 23 deletions(-)

--- a/include/linux/memcontrol.h~memcg-remove-unused-mem_cgroup_id-and-mem_cgroup_from_id
+++ a/include/linux/memcontrol.h
@@ -830,12 +830,6 @@ static inline unsigned short mem_cgroup_
 }
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id);
 
-static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
-{
-	return mem_cgroup_private_id(memcg);
-}
-struct mem_cgroup *mem_cgroup_from_id(unsigned short id);
-
 static inline u64 mem_cgroup_ino(struct mem_cgroup *memcg)
 {
 	return memcg ? cgroup_id(memcg->css.cgroup) : 0;
@@ -1282,18 +1276,6 @@ static inline void mem_cgroup_scan_tasks
 {
 }
 
-static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
-{
-	return 0;
-}
-
-static inline struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
-{
-	WARN_ON_ONCE(id);
-	/* XXX: This should always return root_mem_cgroup */
-	return NULL;
-}
-
 static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
 {
 	return 0;
--- a/mm/memcontrol.c~memcg-remove-unused-mem_cgroup_id-and-mem_cgroup_from_id
+++ a/mm/memcontrol.c
@@ -3615,11 +3615,6 @@ struct mem_cgroup *mem_cgroup_from_priva
 	return xa_load(&mem_cgroup_private_ids, id);
 }
 
-struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
-{
-	return mem_cgroup_from_private_id(id);
-}
-
 struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino)
 {
 	struct cgroup *cgrp;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


