Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E641F41760
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724803046; cv=none; b=a7upGqBKBx0SZYYqfD10S3eMVkOsUymzgoUAyK/LYVtRcBnwxU3PPpm58gDET+ymbildj9NIe82LSN86TWFc9R6ItibRLkFt1jsUAt07WmiJJ6dkkfk6HKtgLdwTkZncmPgaDjBeiq6AxJgSanaWAOTJFiHoq+5pnU06eUCKbMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724803046; c=relaxed/simple;
	bh=BhSuISTWu8f2Fc3eIenCLuinuI6IjdjfMnZqyqfHGeY=;
	h=Date:To:From:Subject:Message-Id; b=IH6PI50cYZS6753JJffhCRFYQ5c86aW1A/inQ0YQbXsqfH+o1u2b/SGEMA3i+2OK2HAzRanDkeqpCdhn9EHnktraS7ZV01Wb2BMgewoVrKo7EPU+B3rOxu3qUwCmw4PYib3BCjSvlfJXWiBpR2Y1AZbLIT8G09CfYElmDUjnHBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DQZQ1NYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DQZQ1NYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA29C4AF10;
	Tue, 27 Aug 2024 23:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724803045;
	bh=BhSuISTWu8f2Fc3eIenCLuinuI6IjdjfMnZqyqfHGeY=;
	h=Date:To:From:Subject:From;
	b=DQZQ1NYNtOrNRWGbslb71Wk6w9saG5+JjVoANn3CAx48QnVh8GpY9562aPOKmXnrH
	 +5HAqlFvJoxJvj2lD5J6TbWMqKfB6mJGpgVvZjHBr90ohcLnLMp3iskVZ0vRfMkots
	 iQdM20b1TlzX57k4/CgvnaJEpkiQxvKpbzEeDMCw=
Date: Tue, 27 Aug 2024 16:57:25 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lizefan.x@bytedance.com,hannes@cmpxchg.org,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-increment-gen-before-restarting-traversal.patch added to mm-unstable branch
Message-Id: <20240827235725.9AA29C4AF10@smtp.kernel.org>
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
Date: Tue, 27 Aug 2024 23:07:40 +0000

The generation number in struct mem_cgroup_reclaim_iter should be
incremented on every round-trip.  Currently, it is possible for a
concurrent reclaimer to jump in at the end of the hierarchy, causing a
traversal restart (resetting the iteration position) without incrementing
the generation number.

By resetting the position without incrementing the generation, it's
possible for another ongoing mem_cgroup_iter() thread to walk the tree
twice.

Move the traversal restart such that the generation number is incremented
before the restart.

Link: https://lkml.kernel.org/r/20240827230753.2073580-4-kinseyho@google.com
Signed-off-by: Kinsey Ho <kinseyho@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~mm-increment-gen-before-restarting-traversal
+++ a/mm/memcontrol.c
@@ -997,7 +997,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		root = root_mem_cgroup;
 
 	rcu_read_lock();
-
+restart:
 	if (reclaim) {
 		struct mem_cgroup_per_node *mz;
 
@@ -1024,14 +1024,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
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
 
@@ -1054,8 +1046,18 @@ struct mem_cgroup *mem_cgroup_iter(struc
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

