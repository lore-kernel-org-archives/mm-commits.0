Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334B03B6363;
	Fri,  7 Aug 2026 02:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068160; cv=none; b=cS7w63opahKGXBw5hyeIo57FNDR4peOakkDmyUGVzCBc9T4UeEzspxzOjDuDPhQtDfBT7fqliLktYtI5a+uPVwv0Lsg+bAzUzrshMy3u+angqxc04HI2pIbggQ5p+au73sOj2yaKSWDXQujxCXH0WVToCZ8d5GX5hxhQLOOfApI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068160; c=relaxed/simple;
	bh=Cm1fgpX/FgQsKNuimrEd+KcUHPiLTq7ilR6NhLRqNd4=;
	h=Date:To:From:Subject:Message-Id; b=cNt5o9BSh63SznNtC9NC2wuC36ed6KNmnkW8rFpbe0gWYTx4JMj8KSPDXIhPQLl2FEjvimEgkP/du6+myaX+qGA498Bph9d1XsCBI2lCQ9CAO6KmOdL5FgO77Xf1h1Mt5gjUybVsrhncwnRJj9aLpKBjy9TZSCn4WhStfcTmmEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T8yeeIQ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T8yeeIQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0011F000E9;
	Fri,  7 Aug 2026 02:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068159;
	bh=TJmCCmOzIWlgogVXxHeJhUY/6PkXKezdrdCMnkLbI8E=;
	h=Date:To:From:Subject;
	b=T8yeeIQ1s+ytZm8X1lVlnMHdKUKHs3DBvjiI0iEDIRE7KizVXKY0jcLOopG6uUWba
	 vx911mVdTU6Y59aqAlFSohRFxzlCYJIMyghwwASS9bolzijtdnqnoatUxND9Y/7zUA
	 arRTeDOn1+MlV2i25XRCi69cG4Kj2SsxuyPIhKfs=
Date: Thu, 06 Aug 2026 19:02:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,stable@vger.kernel.org,rakie.kim@sk.com,paulmck@kernel.org,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-report-rcu-tasks-quiescent-states-in-migrate_pages_batch.patch removed from -mm tree
Message-Id: <20260807020239.0A0011F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: report RCU-tasks quiescent states in migrate_pages_batch()
has been removed from the -mm tree.  Its filename was
     mm-migrate-report-rcu-tasks-quiescent-states-in-migrate_pages_batch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/migrate: report RCU-tasks quiescent states in migrate_pages_batch()
Date: Mon, 27 Jul 2026 06:50:19 -0700

migrate_pages_batch() unmaps each folio before moving it, and every
unmap runs the mmu_notifier invalidate callbacks.  On KVM hosts
try_to_migrate() ends up in kvm_mmu_notifier_invalidate_range_start() ->
tdp_mmu_zap_leafs(), which is expensive, so unmapping a large batch keeps
the CPU busy for a long time.

The loop already calls cond_resched(), but on PREEMPTION kernels that is
a no-op, and involuntary preemption is not a Tasks-RCU quiescent state.

A long batch therefore never reports a quiescent state, and the
migrating task (e.g. kcompactd) becomes a Tasks-RCU holdout, stalling the
Tasks-RCU grace period for minutes, which is common at Meta fleet:

  INFO: rcu_tasks detected stalls on tasks:
  0000000055349ecc: .. nvcsw: 1157401/1157401 holdout: 1 idle_cpu: -1/56 task:kcompactd0      state:R  running task
  Call Trace:
   tdp_mmu_zap_leafs
   tdp_mmu_next_root
   gfn_to_pfn_cache_invalidate_start
   kvm_mmu_notifier_invalidate_range_start
   __mmu_notifier_invalidate_range_start
   try_to_migrate_one
   try_to_migrate
   migrate_pages_batch
   migrate_pages
   compact_zone
   compact_node
   kcompactd
   kthread

Use cond_resched_tasks_rcu_qs() so a quiescent state is reported even
when cond_resched() does nothing.

This has also been discussed at [1]

Link: https://lore.kernel.org/20260727-kcompact-v1-1-bdfefddd6874@debian.org
Link: https://lore.kernel.org/all/amdWVTs0WKOxguxP@gmail.com/ [1]
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-report-rcu-tasks-quiescent-states-in-migrate_pages_batch
+++ a/mm/migrate.c
@@ -1841,7 +1841,7 @@ static int migrate_pages_batch(struct li
 			is_thp = folio_test_pmd_mappable(folio);
 			nr_pages = folio_nr_pages(folio);
 
-			cond_resched();
+			cond_resched_tasks_rcu_qs();
 
 			/*
 			 * The rare folio on the deferred split list should
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch
mm-kmemleak-factor-leak-confirmation-into-a-helper.patch
selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch
radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan.patch
mm-kmemleak-default-min_unref_scans-to-2-for-verbose-auto-scan.patch
documentation-kmemleak-document-the-conditional-min_unref_scans-default.patch
selftests-mm-kmemleak-drop-stale-min_unref_scans-default-from-comments.patch

