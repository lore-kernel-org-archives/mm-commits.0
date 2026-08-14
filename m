Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CAE298CAB;
	Fri, 14 Aug 2026 01:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786669720; cv=none; b=KIC7Mu++wUoK+YaqHWFpvG9Mzspb3wTaD5i7wwAUMBwq0me0nbP7slNzns57U1U0pVNckB7UD3R57qNkNVpryQvG2DGxw+4Ec5FL5VWs8TmtbeMswkDN9RB9cZJ1EOzikSZNEWrl31+eGRrKNbb1oS3HznOxzltGl3d4J5BxlVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786669720; c=relaxed/simple;
	bh=UwH6E3sKTUCoIfPMlgkqetXzwbAHvpZFh1TyhVQo2nQ=;
	h=Date:To:From:Subject:Message-Id; b=o3R8MQKXMUqeXWN2v93dG+2MmtIq2yJJJw6cpn49E/5SoqdxLKoMWTvn8J7WZzwctyvS6PIqXXE8X4+cYaS65uTp3MrOGJxp6A1m0IRA53CgwcTjwBkNOPg9l7sHPTLhX/2CSWdEzOGHj49OssQ1caVWhQagM8Z1e/h0m9WclBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oblsa+0F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oblsa+0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDDF1F000E9;
	Fri, 14 Aug 2026 01:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786669719;
	bh=z+mDFWh8lXdx8lsqlWcQEtFHsXG0U9C8cRrkSIQHzt0=;
	h=Date:To:From:Subject;
	b=Oblsa+0FXhJOP2gGAQg9DQdRVu0IeP8813Y1pdfd+Dv9kfUm6qF5uAG24p0JQHPo/
	 aAEPgVogcMR163pQMi8R7go4RggwZlUTOgyQxmjamIXHBZtUcxieF+mM+SuDWQjGFe
	 +DgAnowvU3N6bhMVVYq/zT7U/JJU98ohMrE293tY=
Date: Thu, 13 Aug 2026 18:08:38 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,paulmck@kernel.org,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmscan-report-rcu-tasks-quiescent-states-in-shrink_lruvec.patch removed from -mm tree
Message-Id: <20260814010838.EBDDF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: report RCU-tasks quiescent states in shrink_lruvec()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-report-rcu-tasks-quiescent-states-in-shrink_lruvec.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/vmscan: report RCU-tasks quiescent states in shrink_lruvec()
Date: Mon, 10 Aug 2026 02:57:36 -0700

I am seeing some rcu_tasks stalls in the Meta fleet during reclaim.

  INFO: rcu_tasks detected stalls on tasks:
	0000000088620d09: .. nvcsw: 6735/6735 holdout: 1 idle_cpu: -1/8
	task:GlobalCPUThread state:R  running task  pid:2552016 tgid:2524552
  Call Trace:
   shrink_lruvec
   mem_cgroup_iter
   shrink_node
   do_try_to_free_pages
   try_to_free_pages
   __alloc_frozen_pages_noprof
   alloc_pages_noprof
   pte_alloc_one
   __pte_alloc
   handle_mm_fault

Nothing promises direct reclaim returns in bounded time, and the scan loop
in shrink_lruvec() only calls cond_resched(), which is a no-op on
PREEMPTION kernels.  Involuntary preemption is not a Tasks-RCU quiescent
state, so the reclaiming task never reports one and becomes a holdout.

Upgrade it to cond_resched_tasks_rcu_qs(), which reports a quiescent state
even when cond_resched() does nothing.

PS: This has been discussed in [1]

Link: https://lore.kernel.org/20260810-rcu_task_shrink_lruvec-v1-1-4d9f7d5251cb@debian.org
Link: https://lore.kernel.org/all/amdWVTs0WKOxguxP@gmail.com/ [1]
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-report-rcu-tasks-quiescent-states-in-shrink_lruvec
+++ a/mm/vmscan.c
@@ -5927,7 +5927,7 @@ static void shrink_lruvec(struct lruvec
 			}
 		}
 
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		if (nr_reclaimed < nr_to_reclaim || proportional_reclaim)
 			continue;
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan.patch
mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch
mm-kmemleak-factor-leak-confirmation-into-a-helper.patch
selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch
mm-kmemleak-default-min_unref_scans-to-2-for-verbose-auto-scan.patch
documentation-kmemleak-document-the-conditional-min_unref_scans-default.patch
selftests-mm-kmemleak-drop-stale-min_unref_scans-default-from-comments.patch

