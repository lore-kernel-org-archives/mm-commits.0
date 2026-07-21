Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FAC3CB2E0
	for <mm-commits@vger.kernel.org>; Tue, 21 Jul 2026 23:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784676264; cv=none; b=aREvZruQC84kz+Pltvc1dA5SZwAMih5FuUsixKtEfPBAFy7iEBUuaWmTJsequ4UfyM+TxZ11lX71J/qqL5jogm7mL8uYWoArUi85797V6DzTuNxL2hPUb8933BYMcrBHDvZwkXkVKtcRAWFuYM7QO2Y3v3PCLeGwiMkJ/xaC9bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784676264; c=relaxed/simple;
	bh=X00ikraCWXXMaaZSW/7N5sPlGv0BGl5Rp3h01P728t4=;
	h=Date:To:From:Subject:Message-Id; b=i4l5A+6Egkg6hyNM0AGOOyXNY4cwxEXSwNiKuEVEp+OHbqVTDwUtD9imiFKRueZSHIqbdhOWjSQzaT4sQDmSLv8W/xNeDQYzC9YG1k6weO4k+AEZHifSuYIL8HLmtVBPSQFhmL9nbfIob7p8zlFuHDdqjvMmnrRXL3WfKlNRwm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KECHKmT7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KECHKmT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38AA1F000E9;
	Tue, 21 Jul 2026 23:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784676263;
	bh=y0iP36j6aoQVUAjGjfnsQJnfDqtc7elAJqbgs1lp8ls=;
	h=Date:To:From:Subject;
	b=KECHKmT7CeDtGlxWArYp9Zb47EDruwPoQX/Ces7FfODNO9ToDQYGPXCJJF+JDzRlK
	 ou5Xs4vF6IJY+MXhHEjMeOcOzJGKQ4Srs8KYg/C9YXrW9k4MgbSBvb+q9icAKNEzJX
	 q8moLI9ZMWYa6FHyIpAUPhG0j9FCZWa0q7Rvje8I=
Date: Tue, 21 Jul 2026 16:24:22 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,jiahuitry@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-ops-common-prevent-migration-fallback-to-non-target-nodes.patch added to mm-new branch
Message-Id: <20260721232422.F38AA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/ops-common: prevent migration fallback to non-target nodes
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-ops-common-prevent-migration-fallback-to-non-target-nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-ops-common-prevent-migration-fallback-to-non-target-nodes.patch

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
From: Jiahui Zhang <jiahuitry@outlook.com>
Subject: mm/damon/ops-common: prevent migration fallback to non-target nodes
Date: Tue, 21 Jul 2026 06:56:05 -0700

DAMOS_MIGRATE_{HOT,COLD} passes a target NUMA node to migrate_pages(). 
But alloc_migration_target() only treats mtc->nid as a preferred node
unless __GFP_THISNODE is set.  Hence target allocation can fall back to
another node, and migrate_pages() can report success without placing the
folio on the requested target node.

Consider a two-node tiered system where node 0 is a fast tier and node 1
is a CPU-less slow tier such as CXL memory, and the user wants to promote
hot regions from node 1 to node 0 with a command like:

  sudo damo start --ops vaddr --target_pid ${workload_pid} \
      --damos_action migrate_hot 0 \
      --damos_access_rate 70% max

Without the __GFP_THISNODE flag, when the memory allocator finds that node
0 is nearly full, it can fall back to node 1 without waking up kswapd. 
Then the pages allocated for migrate_pages() are still on node 1, and the
regions that are expected to be promoted to node 0 are only moved to
different physical pages on node 1.

Meanwhile, both the mm_migrate_pages tracepoint and DAMOS's own sz_applied
statistics (reported via the damos_stat_after_apply_interval tracepoint)
show the migrations as successful, which makes the failure practically
invisible and hard to investigate.

Running a demotion-purpose DAMOS scheme alongside the promotion scheme
does not fully avoid this either.  If demotion cannot keep up with the
promotion rate, allocation can still fall back to node 1 during promotion,
and the same misleading statistics show up.

Make DAMON's migration target allocation strict by setting __GFP_THISNODE,
so that a failed allocation on the target node is reported as a failure
instead of silently landing on a different node.  This is consistent with
alloc_misplaced_dst_folio(), alloc_demote_folio(), and with
do_move_pages_to_node(), which all use __GFP_THISNODE for migrations to an
explicit destination node.

Link: https://lore.kernel.org/20260721135607.251869-1-sj@kernel.org
Signed-off-by: Jiahui Zhang <jiahuitry@outlook.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-prevent-migration-fallback-to-non-target-nodes
+++ a/mm/damon/ops-common.c
@@ -312,7 +312,7 @@ static unsigned int __damon_migrate_foli
 		 * instead of migrated.
 		 */
 		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
-			__GFP_NOMEMALLOC | GFP_NOWAIT,
+			__GFP_NOMEMALLOC | GFP_NOWAIT | __GFP_THISNODE,
 		.nid = target_nid,
 	};
 
_

Patches currently in -mm which might be from jiahuitry@outlook.com are

mm-damon-ops-common-prevent-migration-fallback-to-non-target-nodes.patch

