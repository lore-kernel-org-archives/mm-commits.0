Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921E73ACA7A
	for <mm-commits@vger.kernel.org>; Wed, 14 Jan 2026 22:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768428310; cv=none; b=FLacxXxZxtwwWEO0+CsIBPVeQ1NQTpktLY956+0mOwfp3/l5hSGoBsfaet1zWhBKxUxofE1CFOn+d+kDrQ45d87kdddv/yBhCIgREuN8i6jzqMdRBuEHUYTVev540oY8AwVTsCKRIv11/RzdIpmO3zXmbWNT+LV6t258IJbB8+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768428310; c=relaxed/simple;
	bh=MyaHQZKuqUllT+b9SoibkZP2zinBe4Gpu+7pfSb6hWY=;
	h=Date:To:From:Subject:Message-Id; b=h/HDgiRrdzT+bUwae9lgU5oBMvnX2w/OaGIFnxCzopWeiJ1cR+WO/UvCG76R3xJKTl1l+tqbXLj9VHXE1J8l6O/R4MwJvW/Pw6mK/9zRA/9V6YV4NY74eRf8bzQY/NXp71t9kcnrTB9CQIAbFpPvaLFPwquAdMCNLnoIPP/8ovE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fGkKGBT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fGkKGBT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7BFC4CEF7;
	Wed, 14 Jan 2026 22:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768428308;
	bh=MyaHQZKuqUllT+b9SoibkZP2zinBe4Gpu+7pfSb6hWY=;
	h=Date:To:From:Subject:From;
	b=fGkKGBT99Afff7BUCXQU+p6bL/AlMftlo+DF9utORSclKiIqA5lZX21Lcvqa4OUA3
	 mKwc6GmswqIVrHQTF4h2Le/gwSP1aZ//u1jm65uXGhm5bzIZVAULlMkdyZaI1xA8P1
	 rXmyztUbGr+kgR7XACUzQkG/O8nhgnjmbnbp1dHs=
Date: Wed, 14 Jan 2026 14:05:07 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yury.norov@gmail.com,ying.huang@linux.alibaba.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,rppt@kernel.org,rakie.kim@sk.com,mkoutny@suse.com,mhocko@suse.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,longman@redhat.com,linux@rasmusvillemoes.dk,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-nodes_and-return-value-to-simplify-client-code.patch added to mm-new branch
Message-Id: <20260114220507.DF7BFC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use nodes_and() return value to simplify client code
has been added to the -mm mm-new branch.  Its filename is
     mm-use-nodes_and-return-value-to-simplify-client-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-nodes_and-return-value-to-simplify-client-code.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Yury Norov <ynorov@nvidia.com>
Subject: mm: use nodes_and() return value to simplify client code
Date: Wed, 14 Jan 2026 12:22:14 -0500

establish_demotion_targets() and kernel_migrate_pages() call node_empty()
immediately after calling nodes_and().  Now that nodes_and() return false
if nodemask is empty, drop the latter.

Link: https://lkml.kernel.org/r/20260114172217.861204-3-ynorov@nvidia.com
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |    3 +--
 mm/mempolicy.c    |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/mm/memory-tiers.c~mm-use-nodes_and-return-value-to-simplify-client-code
+++ a/mm/memory-tiers.c
@@ -478,8 +478,7 @@ static void establish_demotion_targets(v
 	 */
 	list_for_each_entry_reverse(memtier, &memory_tiers, list) {
 		tier_nodes = get_memtier_nodemask(memtier);
-		nodes_and(tier_nodes, node_states[N_CPU], tier_nodes);
-		if (!nodes_empty(tier_nodes)) {
+		if (nodes_and(tier_nodes, node_states[N_CPU], tier_nodes)) {
 			/*
 			 * abstract distance below the max value of this memtier
 			 * is considered toptier.
--- a/mm/mempolicy.c~mm-use-nodes_and-return-value-to-simplify-client-code
+++ a/mm/mempolicy.c
@@ -1909,8 +1909,7 @@ static int kernel_migrate_pages(pid_t pi
 	}
 
 	task_nodes = cpuset_mems_allowed(current);
-	nodes_and(*new, *new, task_nodes);
-	if (nodes_empty(*new))
+	if (!nodes_and(*new, *new, task_nodes))
 		goto out_put;
 
 	err = security_task_movememory(task);
_

Patches currently in -mm which might be from ynorov@nvidia.com are

nodemask-propagate-boolean-for-nodes_andnot.patch
mm-use-nodes_and-return-value-to-simplify-client-code.patch
cgroup-use-nodes_and-output-where-appropriate.patch

