Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA2F432E6F;
	Mon, 10 Aug 2026 17:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786384801; cv=none; b=ee8K3/w/hgnBmKc4TG14eqZgE2/IgUp/vNzsXNbb8KGCozvFxmulK5bCc7jkngZRnchvpp015uf6i1iZZ8+PipGjqS1EpSfLm5UmMY6jymhFsMLg+DuMH7DhM/ybXr8ZJAmI4qa6QIFQBr9iXmZIQDay+uuq4v+5//i/aKrK4ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786384801; c=relaxed/simple;
	bh=zpoZcA7Mdpneh+rgSf5xaOhrznxgyR2PAn5Y8YcH46M=;
	h=Date:To:From:Subject:Message-Id; b=Z9gGYcXE49suE8ZZjr8L6CIo/VGFZBGZluI/wKeXovOTyzLYXySTV6Ly5E6F2SAGUrSO9HktjfXeiCRUZJrBD/Az1ADpDQEI48mRrOhq747GtTaO8P2+G6EUd6bvzJsRGdp0hh46p1p8Ro8qIRS2tuysdh2cONFQqDzAj9oGrcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aVNMgTLn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aVNMgTLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440921F00A3A;
	Mon, 10 Aug 2026 17:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786384797;
	bh=4si5155qhN+PdTd12/TEKplitYSsMUS+okf2UmLd0DI=;
	h=Date:To:From:Subject;
	b=aVNMgTLnj27dUuYMqpQsOwMaB3oop5d3RtjihJ4zw3tD8af/OKk7h4lZADldUaXtY
	 Fooj12gGkPTg3KoOoFpItHiy9kkJ+wJepkEwQVbcFAVBXXoIwJ+VIIGLuOdjUoBnSt
	 524J9oqmb21P3UkMOOO9TFdksjEtqN3YWtQ7DV+k=
Date: Mon, 10 Aug 2026 10:59:56 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,paulmck@kernel.org,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-report-rcu-tasks-quiescent-states-in-shrink_lruvec.patch added to mm-hotfixes-unstable branch
Message-Id: <20260810175957.440921F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: report RCU-tasks quiescent states in shrink_lruvec()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscan-report-rcu-tasks-quiescent-states-in-shrink_lruvec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-report-rcu-tasks-quiescent-states-in-shrink_lruvec.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/all/amdWVTs0WKOxguxP@gmail.com/ [1]
Link: https://lore.kernel.org/20260810-rcu_task_shrink_lruvec-v1-1-4d9f7d5251cb@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
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

mm-vmscan-report-rcu-tasks-quiescent-states-in-shrink_lruvec.patch
mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan.patch
mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch
mm-kmemleak-factor-leak-confirmation-into-a-helper.patch
selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch
mm-kmemleak-default-min_unref_scans-to-2-for-verbose-auto-scan.patch
documentation-kmemleak-document-the-conditional-min_unref_scans-default.patch
selftests-mm-kmemleak-drop-stale-min_unref_scans-default-from-comments.patch
radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch

