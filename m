Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BE5B674
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 02:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719886858; cv=none; b=KK4fEfHDshUIbkCnN/tT2BAEg7XbAmerjZf6oKxLKKTVQWKAOFUIOmbHESrJvu4kdGe3AwOpcZZtL0xyxMjLm8qXUn37PrcFJuPfmzLkoag7i7G5P3CcqFWgrEE/d4G+M9U1psB/5sAcEzw0EuoYDz7R8nUHPj9bnZk4JDiLHTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719886858; c=relaxed/simple;
	bh=Pkxuyp5X6JAmq2HJAiDS155NajPOMCL1fBN283UHX8c=;
	h=Date:To:From:Subject:Message-Id; b=MD09i/hfHhJAhQXYdN0mEFpJjZ92qGSeGKCnkNoFAf45j8MTjxF5oLwbKfrzo4YXmD21rnk6D2lOFQ9WYuf436HkJBJwvBnXK7DaDI011Rrx2aiEjUf4PjzFyeZ1wYA5uxQ/V6Jm1ftoa/huMZgDcNLuv1EkvDaq+HG5edlz0f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0o+fgnIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0o+fgnIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8ACC116B1;
	Tue,  2 Jul 2024 02:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719886858;
	bh=Pkxuyp5X6JAmq2HJAiDS155NajPOMCL1fBN283UHX8c=;
	h=Date:To:From:Subject:From;
	b=0o+fgnIQpJ/rOS01aNSzz3GdM6lzZ9D93egHSyX7cluA582zltpkqKgmliH1Clt+z
	 PCJClGzOQiHqjRyNc54vtKoAn4N2edCrCVPvC4fwERqLKiZXzDykL0kyB7lcJ+QO/+
	 OZnzf82btks/A5n92Oyvamd7ejDPOHx+K2vgcWp8=
Date: Mon, 01 Jul 2024 19:20:57 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch added to mm-unstable branch
Message-Id: <20240702022058.2D8ACC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: drop obsolete cache line padding in struct mem_cgroup
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: drop obsolete cache line padding in struct mem_cgroup
Date: Mon, 1 Jul 2024 18:59:31 +0000

After the grouping of the cgroup v1-related fields and the corresponding
reorganization of the struct mem_cgroup, the existing cache line padding
doesn't make much sense anymore.  Let's drop it for now and put back to
new places, if necessary.

Link: https://lkml.kernel.org/r/20240701185932.704807-1-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup
+++ a/include/linux/memcontrol.h
@@ -220,8 +220,6 @@ struct mem_cgroup {
 	/* handle for "memory.swap.events" */
 	struct cgroup_file swap_events_file;
 
-	CACHELINE_PADDING(_pad1_);
-
 	/* memory.stat */
 	struct memcg_vmstats	*vmstats;
 
@@ -305,8 +303,6 @@ struct mem_cgroup {
 	bool tcpmem_active;
 	int tcpmem_pressure;
 
-	CACHELINE_PADDING(_pad2_);
-
 	/*
 	 * set > 0 if pages under this cgroup are moving to other cgroup.
 	 */
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-introduce-memcontrol-v1c.patch
mm-memcg-move-soft-limit-reclaim-code-to-memcontrol-v1c.patch
mm-memcg-rename-soft-limit-reclaim-related-functions.patch
mm-memcg-move-charge-migration-code-to-memcontrol-v1c.patch
mm-memcg-rename-charge-move-related-functions.patch
mm-memcg-move-legacy-memcg-event-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_check_events.patch
mm-memcg-move-cgroup-v1-oom-handling-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_oom_recover.patch
mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c.patch
mm-memcg-make-memcg1_update_tree-static.patch
mm-memcg-group-cgroup-v1-memcg-related-declarations.patch
mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option.patch
mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option-fix.patch
maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files.patch
mm-memcg-move-memcg_account_kmem-to-memcontrol-v1c.patch
mm-memcg-factor-out-legacy-socket-memory-accounting-code.patch
mm-memcg-guard-cgroup-v1-specific-code-in-mem_cgroup_print_oom_meminfo.patch
mm-memcg-gather-memcg1-specific-fields-initialization-in-memcg1_memcg_init.patch
mm-memcg-guard-memcg1-specific-fields-accesses-in-mm-memcontrolc.patch
mm-memcg-put-memcg1-specific-struct-mem_cgroups-members-under-config_memcg_v1.patch
mm-memcg-guard-memcg1-specific-members-of-struct-mem_cgroup_per_node.patch
mm-memcg-put-struct-task_struct-memcg_in_oom-under-config_memcg_v1.patch
mm-memcg-put-struct-task_struct-in_user_fault-under-config_memcg_v1.patch
mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

