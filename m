Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFBF1684BE
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 23:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774394173; cv=none; b=txlzRV5aCp0hjz62Dt4qXVJcEpQlxI1W0Mrm8aDCNtxdUzxRFg0S3sboDRZpcQdV+bs1kXrl3LK47QCnvkFO+5F/vMwxOPAexNE4p4cDAfH5hipQhvHyOZhA9t6mQT01E41tWwRuMiMLfR3UUI+grGFPqn4fQcQt6UJkdDJStGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774394173; c=relaxed/simple;
	bh=oEDra/0g8/JR9FNoByAjU/kc1wRLOftf5KJJYdriGQ8=;
	h=Date:To:From:Subject:Message-Id; b=S2685MleWpqYARROgNAI6NG85wu5yGCK/4H0wA2jjkxQHqzLT8aGJGAcDXx+SIluuGybzy8f2VCdQiTbpt2a4X3iEJx/JaSLd2YTzWhjIEZOEqBmcbrGMoo4YuVCUrrmC5t/XOqXfbnnuAiRZ5D+dCMmoETICADroTtOutZwK4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BpDw2saQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BpDw2saQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FC0C19424;
	Tue, 24 Mar 2026 23:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774394173;
	bh=oEDra/0g8/JR9FNoByAjU/kc1wRLOftf5KJJYdriGQ8=;
	h=Date:To:From:Subject:From;
	b=BpDw2saQUXPFZrna7BoROdMTyeol48t/HzHjU88u8lAfxDjHG3SNBCqQFMXcHPEV5
	 rgwCqSSPwaQ8b+LXylGllvTwsNCBbyn/OF6aT+mtRDBNROqfEywCFpjR1jL3r3WydY
	 vEFQZIlWvp8CI/y1nU4LrH+8YJRKerwl2amk5+Ag=
Date: Tue, 24 Mar 2026 16:16:13 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2.patch removed from -mm tree
Message-Id: <20260324231613.84FC0C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcontrol: fix obj_cgroup leak in mem_cgroup_css_online() error path
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2.patch

This patch was dropped because it was folded into mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type.patch

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
Signed-off-by: David Carlier <devnexen@gmail.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
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

mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix.patch
mm-page_io-fix-pswpin-undercount-for-large-folios-in-sio_read_complete.patch

