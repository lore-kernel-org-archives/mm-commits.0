Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1542EEE61
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334258; cv=none; b=ClDxr/5ccKnLLdEBHN+QhmK0q0ne7g3usw+pX5jh42XiVLFsPH4t204xVjAbFbmbg5D0i2cWhle2eYQ5jbDp01ae3bkC8ED5TVNaLDG/5R3TQqbSubXH9BXaSc4RcJQYX1nUBvJwVJWrfEvS/azMsqiVReNKOcOZ7/g1oZ6+XVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334258; c=relaxed/simple;
	bh=GU5cABxj3k3MpQj3WyPOAVs4q0AHzkb4gRikn7MMdY4=;
	h=Date:To:From:Subject:Message-Id; b=oT4onVzO1Ippt/rvR+T88YM5MfSmWnLbubDW3Z0U0/uWcu8PjPkIsvqQLu0bOO7Ydi/7b4zK2qaEY5bgrhNcNtgujGyafAFTCKgsWBrWAg9eJ1fiZMOatNrxi4nmRqYG42umZw3PHuZ1+UgYGd/ciUjJ9RrVpv4dHKMWkIyvk20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L2cBH69c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L2cBH69c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244441F0089B;
	Wed,  7 Oct 2026 00:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334257;
	bh=u/ejk7YORl956LhMJUeYDJoHKTBDPMoIG0dVaJz7Ynw=;
	h=Date:To:From:Subject;
	b=L2cBH69c4Iyczh2g5esRIM1kCIBfhGJucikokPuBdY51Ee9SaV547qqNAz5wPAPfc
	 U4S0SndktpETqokzYQQEDu03KmWmD00/RupO0qY3BOFyGPUUgNSuwlABzbPXliB1JG
	 rJDOV6OZdbG+SwuRRUw9KHxhEgb4xKMWP9Gp7KKk=
Date: Tue, 06 Oct 2026 17:50:56 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,rientjes@google.com,mhocko@suse.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-oom_kill-remove-unreachable-__gfp_thisnode-check-in-constrained_alloc.patch removed from -mm tree
Message-Id: <20261007005057.244441F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/oom_kill: remove unreachable __GFP_THISNODE check in constrained_alloc()
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-remove-unreachable-__gfp_thisnode-check-in-constrained_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/oom_kill: remove unreachable __GFP_THISNODE check in constrained_alloc()
Date: Thu, 13 Aug 2026 17:38:09 +0800

The __GFP_THISNODE check in constrained_alloc() is dead code: global OOM
is never triggered with __GFP_THISNODE (blocked in __alloc_pages_may_oom
before out_of_memory() is called), and memcg OOM returns CONSTRAINT_MEMCG
at the top of the function before reaching this point.  Remove the check,
its stale comment, and update the following comment that referenced
__GFP_THISNODE.

Link: https://lore.kernel.org/20260813093810.573302-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Rientjes <rientjes@google.com>
---

 mm/oom_kill.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/mm/oom_kill.c~mm-oom_kill-remove-unreachable-__gfp_thisnode-check-in-constrained_alloc
+++ a/mm/oom_kill.c
@@ -267,18 +267,11 @@ static enum oom_constraint constrained_a
 
 	if (!oc->zonelist)
 		return CONSTRAINT_NONE;
-	/*
-	 * Reach here only when __GFP_NOFAIL is used. So, we should avoid
-	 * to kill current.We have to random task kill in this case.
-	 * Hopefully, CONSTRAINT_THISNODE...but no way to handle it, now.
-	 */
-	if (oc->gfp_mask & __GFP_THISNODE)
-		return CONSTRAINT_NONE;
 
 	/*
-	 * This is not a __GFP_THISNODE allocation, so a truncated nodemask in
-	 * the page allocator means a mempolicy is in effect.  Cpuset policy
-	 * is enforced in get_page_from_freelist().
+	 * A truncated nodemask in the page allocator means a mempolicy
+	 * is in effect.  Cpuset policy is enforced in
+	 * get_page_from_freelist().
 	 */
 	if (oc->nodemask &&
 	    !nodes_subset(node_states[N_MEMORY], *oc->nodemask)) {
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch
mm-vmalloc-extract-vmap_insert_free_area-helper.patch
mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show.patch
mm-vmalloc-fix-vmalloc_dump_obj-address-alignment-for-last-page-lookups.patch
mm-vmalloc-fix-vmalloc_dump_obj-cross-zone-va-lookup.patch

