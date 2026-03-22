Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE865367F53
	for <mm-commits@vger.kernel.org>; Sun, 22 Mar 2026 22:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774218906; cv=none; b=s8bYisgKAMVQlnLrlEH8Xakqx4VEmAj+URaaP1yD81g7UnSyy2NKiEcXzM8LrfwS5Ah6RB30EAmg9Uurzp2ypnmggXJopCs5LQncXNMQ/dkpN5JSBecmUqkALsAeZ4sQAFgy1yvB2ECqNKtR7Vu5JxNEHldkeWyDdWVEToLBJxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774218906; c=relaxed/simple;
	bh=zcHAiMH6a+cok4rWKT30/xZ39NfZaNMbvcc11LX6IKE=;
	h=Date:To:From:Subject:Message-Id; b=Z+Zx3/kbicYJAetmWE0dSJki/QVbJ9j6tmSbN0EeCuT9ZkAYZRcdN/ZVF+g8n0MVkBpSvsEEQ3j7XPrfxROaYEMmkHtk/865no9QJ92PDs3HlOKIWxAcip25NtZu22r5AQP69zmge1O3g+CtMbxpwgz2+sOL83q9OINm5aE1VL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nRyEqD0k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nRyEqD0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8983FC19424;
	Sun, 22 Mar 2026 22:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774218905;
	bh=zcHAiMH6a+cok4rWKT30/xZ39NfZaNMbvcc11LX6IKE=;
	h=Date:To:From:Subject:From;
	b=nRyEqD0kVb77foWijRNgq6RcRPuo54fo+WQIw1+LoqH7xWxdkWbAdu/XvbvxD6Ij/
	 vARuy3nF8I9EEa9el3ld+mIBM1u5LOOke0scCGyoaz0gA4GuIvTrReGLFF6TXe8tBr
	 scqS/z9lW8LeemrUB7kUEtUGUD6Q5/Jc/HObVxNk=
Date: Sun, 22 Mar 2026 15:35:04 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2.patch added to mm-unstable branch
Message-Id: <20260322223505.8983FC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcontrol: fix obj_cgroup leak in mem_cgroup_css_online() error path
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2.patch

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
From: David Carlier <devnexen@gmail.com>
Subject: mm/memcontrol: fix obj_cgroup leak in mem_cgroup_css_online() error path
Date: Sun, 22 Mar 2026 19:36:31 +0000

When obj_cgroup_alloc() fails partway through the NUMA node loop in
mem_cgroup_css_online(), the free_objcg error path drops the extra
reference held by pn->orig_objcg but never kills the initial percpu_ref
from obj_cgroup_alloc() stored in pn->objcg.

Since css_offline is never called when css_online fails,
memcg_reparent_objcgs() never runs, so the percpu_ref_kill() that normally
drops this initial reference never executes.  The obj_cgroup and its
per-cpu ref allocations are leaked.

Clear pn->objcg via rcu_replace_pointer() and add the missing
percpu_ref_kill() in the error path, matching the normal teardown sequence
in memcg_reparent_objcgs().

Also add a NULL check for pn in __mem_cgroup_free() to prevent a NULL
pointer dereference when alloc_mem_cgroup_per_node_info() fails partway
through the node loop in mem_cgroup_alloc().

Link: https://lkml.kernel.org/r/20260322193631.45457-1-devnexen@gmail.com
Fixes: 098fad3e1621 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Signed-off-by: David Carlier <devnexen@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2
+++ a/mm/memcontrol.c
@@ -3854,6 +3854,8 @@ static void __mem_cgroup_free(struct mem
 
 	for_each_node(node) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
+		if (!pn)
+			continue;
 
 		obj_cgroup_put(pn->orig_objcg);
 		free_mem_cgroup_per_node_info(pn);
@@ -4055,8 +4057,11 @@ static int mem_cgroup_css_online(struct
 free_objcg:
 	for_each_node(nid) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
+		objcg = rcu_replace_pointer(pn->objcg, NULL, true);
+		if (objcg)
+			percpu_ref_kill(&objcg->refcnt);
 
-		if (pn && pn->orig_objcg) {
+		if (pn->orig_objcg) {
 			obj_cgroup_put(pn->orig_objcg);
 			/*
 			 * Reset pn->orig_objcg to NULL to prevent
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2.patch

