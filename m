Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD4738D
	for <mm-commits@vger.kernel.org>; Sun, 30 Aug 2026 02:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788056812; cv=none; b=Sjhz0PhR1gjw5BWZm5DUnxo/B4uc4EPcEfNvS/G0ydkGItkglewMsI4+nsym6paL0HJgPQjGAuZrWvvy6Y/TOw69RZrq469qkKRBsvyA/Inkv2nEv24r+HHEHLvaP3PQ7E3+FJ+W8NqOe8sWMrG67tU3zR0fcsO3QgSQwEV0RXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788056812; c=relaxed/simple;
	bh=0eI0VM36KCWyqaulhNBZs7XyPee/RcYoXNDLvZVNgoM=;
	h=Date:To:From:Subject:Message-Id; b=baew9LP61sDaYOxaed3lnglPT15zmAp8vPp+b9T4q/9mhV+89WfzKqYjXV2+ojhSsSaDS3fl3Qr1EZ8xFOrsSvixn+QcPFMgiuNoNsViqQNMg3Akm9BRTlEQcS9YYl3DrOf8Njcrn9yvUMBYsF54S6JZ+bxm5c6StcYBXVX2IZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YW7zFQSs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YW7zFQSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE70C1F000E9;
	Sun, 30 Aug 2026 02:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788056810;
	bh=28QkT3JzGr6cQBbvQ9rcqVyYcp5UrFxPTPtNCJ4xT6E=;
	h=Date:To:From:Subject;
	b=YW7zFQSscTD+rtSvcERufVlsNH7dMNQSrwNuK7fdE04DkexdZpB95tHfxOP4SyUb3
	 3Hkd9y/p1DjoPb/SCGrqqL9o8IusA5lCkUFp0WcgWwbEAMs0oFZbpUmYfBzIJOe38R
	 LmoQgPZTSA9is5OW184L70JVWf8c8QjcQfC7oUOY=
Date: Sat, 29 Aug 2026 19:26:50 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,rientjes@google.com,mhocko@suse.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom_kill-remove-unreachable-__gfp_thisnode-check-in-constrained_alloc.patch added to mm-new branch
Message-Id: <20260830022650.BE70C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/oom_kill: remove unreachable __GFP_THISNODE check in constrained_alloc()
has been added to the -mm mm-new branch.  Its filename is
     mm-oom_kill-remove-unreachable-__gfp_thisnode-check-in-constrained_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-oom_kill-remove-unreachable-__gfp_thisnode-check-in-constrained_alloc.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Rientjes <rientjes@google.com>
Cc: Liu Ye <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-vmalloc-fix-vmap_purge_lock-livelock-under-memory-pressure.patch
tools-mm-page_owner_sort-fix-sort-option-being-silently-ignored.patch
tools-mm-page_owner_sort-add-module-name-sort-cull-filter-support.patch
tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text.patch
mm-oom_kill-remove-unreachable-__gfp_thisnode-check-in-constrained_alloc.patch

