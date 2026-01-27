Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056D531A81F
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486756; cv=none; b=XcgvnnOfWiK04G0Om//JNyFiBT3JwU1BvelWMaQkLG9zAiZ5E04fqqYnnNAzUZHxT6Hgzlo1dh2L9YpPTlAAMOWaCEhUEMTEr9KbvtTYPpSt6dKs77/JL4g8sVzwtSAAgPI7D3fPkHuLILVGtMGAGBYPRGaQNtDt3sMcGDeDKwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486756; c=relaxed/simple;
	bh=0MZfvhU9ZUbMkuOpo768dreejo7Z/HkrVHK5L273OgA=;
	h=Date:To:From:Subject:Message-Id; b=DfGjc3JvKw4AmwQEs474Aup3IstEG6gx2fHGjv3+iBp2DdcSikEoqjPAUYY9vRaA/LrYED+5YS+3xYeQTzx99dy+NFtJGcfvOxryH3YPxw4kF9vkpRTvYtbtmJ7Z0HFozDyMrTxDzVHdRih6I+jgTw2RRWY2oDtMAzLuNL5PZZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KHGAx4iC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KHGAx4iC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10C0C116C6;
	Tue, 27 Jan 2026 04:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486755;
	bh=0MZfvhU9ZUbMkuOpo768dreejo7Z/HkrVHK5L273OgA=;
	h=Date:To:From:Subject:From;
	b=KHGAx4iCb37GOvsnYcSp818udDtcUhVb5vvMj+8djXu0KBcXLGj7sAxRv2XQeH77t
	 3IQfxvliQAQjxhEB1YMwppmtgt4wI+Lp2odsnsWaRkSa3nriYS5I0hEahRbeYUgKF8
	 4OTjQ5cL6CBuQQiLi5rfldCCzEicg+8uPozJZ81c=
Date: Mon, 26 Jan 2026 20:05:55 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yury.norov@gmail.com,ying.huang@linux.alibaba.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,rppt@kernel.org,rakie.kim@sk.com,mkoutny@suse.com,mhocko@suse.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,longman@redhat.com,linux@rasmusvillemoes.dk,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-nodes_and-return-value-to-simplify-client-code.patch removed from -mm tree
Message-Id: <20260127040555.D10C0C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use nodes_and() return value to simplify client code
has been removed from the -mm tree.  Its filename was
     mm-use-nodes_and-return-value-to-simplify-client-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
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
@@ -475,8 +475,7 @@ static void establish_demotion_targets(v
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

kernelh-drop-stack_magic-macro.patch
moduleparam-include-required-headers-explicitly.patch
kernelh-move-verify_octal_permissions-to-sysfsh.patch
kernelh-include-linux-instruction_pointerh-explicitly.patch
tracing-move-tracing-declarations-from-kernelh-to-a-dedicated-header.patch

