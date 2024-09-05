Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F350018EFF8
	for <mm-commits@vger.kernel.org>; Thu,  5 Sep 2024 23:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725577492; cv=none; b=Eyv02822o1v4n6EZ6KpnjI9aLhENvo+OlGif2m9JHYR9zGO6fCdyUWDLS2zmoCcT2xFhQ+BLOnJFFk4yg40R9CqAsGwUf0LVPHGPN8beWimAJdkDpo6WFunNuY41OMnh8TCJCgOEL/uHH0AsNKczWtGxDAWdmbVGrRifdNE+qWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725577492; c=relaxed/simple;
	bh=lkGOEGTmtnxwrirDoqHcB/uOimnpFNrsc4h9AztyyGU=;
	h=Date:To:From:Subject:Message-Id; b=ArH/QgpVAoWNTJEJs9N/5b1vNYXyPJ9KI+uNW1ao2KLPw5fuqqxciDYYy9FmTYsSogyJ2hHnrXimmD/X/bRhEM2SM9vzKn6AJo/BGvt9SSylGI6HT1qz2ujzDzLO2RhBVGSeInCJaZdY8qOp6p6pxJvnHlYFUdu/GxjhlqeemJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EyjRJVeP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EyjRJVeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BE2C4CEC3;
	Thu,  5 Sep 2024 23:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725577491;
	bh=lkGOEGTmtnxwrirDoqHcB/uOimnpFNrsc4h9AztyyGU=;
	h=Date:To:From:Subject:From;
	b=EyjRJVePSMUpZqstj3nCckAVctxTZesxC8B/6INoX1LQ5G2CNP0xcO3KGoOKoIuJp
	 IT5LPHqGwKLOJEvLRJbjXV1ddGTGJd8GHB/4EyOken30hXDMRKL/BK/wQyfyElBb7j
	 K0xfCfYRF3wQIEEFP88KKDweocwkqTVNaXh07rxs=
Date: Thu, 05 Sep 2024 16:04:51 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lizefan.x@bytedance.com,hughd@google.com,hannes@cmpxchg.org,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-increment-gen-before-restarting-traversal.patch added to mm-unstable branch
Message-Id: <20240905230451.B8BE2C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: increment gen # before restarting traversal
has been added to the -mm mm-unstable branch.  Its filename is
     mm-increment-gen-before-restarting-traversal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-increment-gen-before-restarting-traversal.patch

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
From: Kinsey Ho <kinseyho@google.com>
Subject: mm: increment gen # before restarting traversal
Date: Thu, 5 Sep 2024 00:30:52 +0000

The generation number in struct mem_cgroup_reclaim_iter should be
incremented on every round-trip.  Currently, it is possible for a
concurrent reclaimer to jump in at the end of the hierarchy, causing a
traversal restart (resetting the iteration position) without incrementing
the generation number.

By resetting the position without incrementing the generation, it's
possible for another ongoing mem_cgroup_iter() thread to walk the tree
twice.

Move the traversal restart such that the generation number is
incremented before the restart.

Link: https://lkml.kernel.org/r/20240905003058.1859929-4-kinseyho@google.com
Signed-off-by: Kinsey Ho <kinseyho@google.com>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~mm-increment-gen-before-restarting-traversal
+++ a/mm/memcontrol.c
@@ -999,7 +999,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		root = root_mem_cgroup;
 
 	rcu_read_lock();
-
+restart:
 	if (reclaim) {
 		struct mem_cgroup_per_node *mz;
 
@@ -1026,14 +1026,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	for (;;) {
 		css = css_next_descendant_pre(css, &root->css);
 		if (!css) {
-			/*
-			 * Reclaimers share the hierarchy walk, and a
-			 * new one might jump in right at the end of
-			 * the hierarchy - make sure they see at least
-			 * one group and restart from the beginning.
-			 */
-			if (!prev)
-				continue;
 			break;
 		}
 
@@ -1056,8 +1048,18 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		 */
 		(void)cmpxchg(&iter->position, pos, memcg);
 
-		if (!memcg)
+		if (!memcg) {
 			iter->generation++;
+
+			/*
+			 * Reclaimers share the hierarchy walk, and a
+			 * new one might jump in right at the end of
+			 * the hierarchy - make sure they see at least
+			 * one group and restart from the beginning.
+			 */
+			if (!prev)
+				goto restart;
+		}
 	}
 
 out_unlock:
_

Patches currently in -mm which might be from kinseyho@google.com are

cgroup-clarify-css-sibling-linkage-is-protected-by-cgroup_mutex-or-rcu.patch
mm-dont-hold-css-refcnt-during-traversal.patch
mm-increment-gen-before-restarting-traversal.patch
mm-restart-if-multiple-traversals-raced.patch
mm-clean-up-mem_cgroup_iter.patch

