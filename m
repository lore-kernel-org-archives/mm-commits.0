Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B840D155757
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188521; cv=none; b=IRiHLWMzcC0Xd3QLLX60xUqkJekyTVthERzv8tJr94tOFbxTiC44J6xcsEW1VxrrQLwqebflC0pZZ2Rn/7ChROB2NaEGGx7oPivr4hmGmQz+wghT5MSh0wmg5G5RJtKARff43dMymKx0DaC9QQQGpLbLhkSuzlda/WquK/9NIRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188521; c=relaxed/simple;
	bh=oY0UoUNS9YmI/ujP7C7gYvYn3/NfGshUIlT81tAH4zo=;
	h=Date:To:From:Subject:Message-Id; b=lBeSNXCzGAOJ0wojiZbYCERxMc0D8mwU6FiFDFJ+6j/CqiTrMcrjeQkyIP4/8ajhcVKOUQenH14UcpOn1teZjzw0TIjC9KwQxLW9N7AgIlOFf5gVqekBfntTpnJ1vJx3m9QDpb2rXMMOZClIHIbjkVHzIM3/i//C8PKqjS7TBYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fiRcn04Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fiRcn04Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26193C4CEEC;
	Mon, 17 Mar 2025 05:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188521;
	bh=oY0UoUNS9YmI/ujP7C7gYvYn3/NfGshUIlT81tAH4zo=;
	h=Date:To:From:Subject:From;
	b=fiRcn04Z+mq5mF2a7F5do38uwqyL6bBEw+qlgBrE3ATMAz6mPD1R/5iCtc6MuBnO0
	 HVBwQ/6Nj4p5jQDnD2rMWTt7FQyBNM+DF94l+sZW+cnJl8xSstU2TYMNNs1PJAjkOl
	 REVmYoNM057m7FshVwiHa9VigFFIOZY+7xMomsNw=
Date: Sun, 16 Mar 2025 22:15:20 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-dont-call-propagate_protected_usage-for-v1.patch removed from -mm tree
Message-Id: <20250317051521.26193C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: don't call propagate_protected_usage() for v1
has been removed from the -mm tree.  Its filename was
     memcg-dont-call-propagate_protected_usage-for-v1.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: don't call propagate_protected_usage() for v1
Date: Thu, 27 Feb 2025 23:58:06 -0800

Patch series "page_counter cleanup and size reduction".

Commit c6f53ed8f213a ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
accidently increased the size of struct page_counter.  This series
rearrange the fields to reduce its size and also has some cleanups.


This patch (of 3):

Memcg-v1 does not support memory protection (min/low) and thus there is no
need to track protected memory usage for it.

Link: https://lkml.kernel.org/r/20250228075808.207484-1-shakeel.butt@linux.dev
Link: https://lkml.kernel.org/r/20250228075808.207484-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-dont-call-propagate_protected_usage-for-v1
+++ a/mm/memcontrol.c
@@ -3610,6 +3610,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 {
 	struct mem_cgroup *parent = mem_cgroup_from_css(parent_css);
 	struct mem_cgroup *memcg, *old_memcg;
+	bool memcg_on_dfl = cgroup_subsys_on_dfl(memory_cgrp_subsys);
 
 	old_memcg = set_active_memcg(parent);
 	memcg = mem_cgroup_alloc(parent);
@@ -3627,7 +3628,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	if (parent) {
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 
-		page_counter_init(&memcg->memory, &parent->memory, true);
+		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
@@ -3647,7 +3648,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 		return &memcg->css;
 	}
 
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
+	if (memcg_on_dfl && !cgroup_memory_nosocket)
 		static_branch_inc(&memcg_sockets_enabled_key);
 
 	if (!cgroup_memory_nobpf)
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-add-hierarchical-effective-limits-for-v2.patch
memcg-avoid-refill_stock-for-root-memcg.patch
memcg-move-do_memsw_account-to-config_memcg_v1.patch

