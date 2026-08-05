Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1573128314C;
	Wed,  5 Aug 2026 03:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785898982; cv=none; b=MnyTZipDQKtgriyYeX1c/rVpdgTLjLG+0dmwcI6DCPkx8EeLsg9Ooq8eSgsgdkUfZDyswqYN+s9jeEf2PVmasCI4HFWfgoqOAZgxWBALWp7TadpwspBUQUoTQuAeAdWIrpdCw03alM8IWs+iC3oe7vVE1yTGbrLysg/0uEu0ml0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785898982; c=relaxed/simple;
	bh=KbzlIFfWXlR6ZosiBANbD0AOY1PPO1JoIkwFvp+pgNA=;
	h=Date:To:From:Subject:Message-Id; b=AAesjY4WmqjLKjfn0Ltpc/zStbbJuhNRgR4dPbNkBdBXEegsN7FokxAvXLvNpzWbf74AThj+vwcsrNvQ0OByunymlji9rERnj4ZbtAKrl7kDyQzPCzzmDvqAVmyB+3NUBNrCreSgyCAP8DdokXkQq/VElNdfVCnBBvglft6Z+OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zg+AmVla; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zg+AmVla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74391F00A3A;
	Wed,  5 Aug 2026 03:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785898981;
	bh=b2e/WV+/Emq1Z52nOIVbUZgDWMalKz2r/jhAu5riC/U=;
	h=Date:To:From:Subject;
	b=Zg+AmVlanjmcj4hxdE17uNTyEBT3ZqC7OIxOB4lraG6Mc1n8Dz7kCpeCl1/8v/JrQ
	 QqX+Mz9b80e4ryh2e3qcFeu7gJdAsdqw4jqIxwArinYX6kaZ1XKKZoZD8WSZOddEAP
	 cbmjVe8YKcMiHdsUk2SmrfEzfd4/4ZvoHNfzSHUY=
Date: Tue, 04 Aug 2026 20:03:00 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch removed from -mm tree
Message-Id: <20260805030300.D74391F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/mtier: error out for zero quota goal target values
has been removed from the -mm tree.  Its filename was
     samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: samples/damon/mtier: error out for zero quota goal target values
Date: Mon, 3 Aug 2026 06:40:32 -0700

Patch series "mm/damon: avoid division by zero from damos_quota_score()".

DAMON_SAMPLE_MTIER and DAMON_LRU_SORT allow the user to trigger division
by zero in damos_quota_score().  Avoid it by adding parameters validation
checks.


This patch (of 2):

damos_quota_score() can trigger division by zero if the target_value is
zero.  DAMON_SAMPLE_MTIER lets users set the target_value via
node0_mem_{used,free}_bp parameters.  It doesn't guard zero value case,
though.  As a result, users can trigger division by zero.  Fix the issue
by returning an error when the user tries to start DAMON with zero
node0_mem_{used,free}_bp parameter values.

DAMON_SAMPLE_MTIER is just a sample module, but the consequence is quite
bad.  Also the zero node0_mem_free_bp parameter might look like a
reasonable setup to some users.  Hence, the issue might really happen in
the real world.

One reliable way to reproduce the issue is like below:

    # cd /sys/module/damon_sample_mtier/parameters
    # echo 4096 > node0_start_addr
    # echo 8192 > node0_end_addr
    # echo 8192 > node1_start_addr
    # echo 81920 > node1_end_addr
    # echo 0 > node0_mem_free_bp
    # echo Y > enabled
    # dmesg -w
    [...]
    [18792.235916] Oops: divide error: 0000 [#1] SMP NOPTI
    [...]
    [18792.242787] RIP: 0010:damos_quota_score+0x6f/0x480
    [...]

This issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260803134034.15217-1-sj@kernel.org
Link: https://lore.kernel.org/20260803134034.15217-2-sj@kernel.org
Link: https://lore.kernel.org/20260801202657.117135-1-sj@kernel.org [1]
Fixes: c5e67d40a102 ("samples/damon/mtier: add parameters for node0 memory usage")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/samples/damon/mtier.c~samples-damon-mtier-error-out-for-zero-quota-goal-target-values
+++ a/samples/damon/mtier.c
@@ -156,6 +156,9 @@ static struct damon_ctx *damon_sample_mt
 	if (!scheme)
 		goto free_out;
 	damon_set_schemes(ctx, &scheme, 1);
+	/* zero target value causes division by zero in damos_quota_store() */
+	if (!node0_mem_used_bp || !node0_mem_free_bp)
+		goto free_out;
 	quota_goal = damos_new_quota_goal(
 			promote ? DAMOS_QUOTA_NODE_MEM_USED_BP :
 			DAMOS_QUOTA_NODE_MEM_FREE_BP,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-skip-aging-from-repeated-aggressive-merging.patch
mm-damon-core-hide-private-damon_region-fields.patch
mm-damon-core-hide-private-damon_target-fields.patch
mm-damon-core-hide-private-damos_quota_goal-fields.patch
mm-damon-core-hide-private-damos_quota-fields.patch
mm-damon-core-hide-private-damos_filter-fields.patch
mm-damon-core-hide-private-damos-fields.patch
mm-damon-core-hide-private-damon_filter-fields.patch
mm-damon-core-hide-private-damon_probe-fields.patch
mm-damon-sysfs-do-not-directly-access-damon_ctx-ops.patch
mm-damon-core-hide-core-private-damon_ctx-fields.patch
mm-damon-core-avoid-infinite-kdamond_merge_regions-internal-loop.patch
mm-damon-tests-core-kunit-catch-test-failure-in-test_merge_regions_of.patch
mm-damon-vaddr-drop-last-same-folio-access-check-optimization.patch
mm-damon-paddr-drop-last-same-folio-access-check-reuse-optimization.patch
mm-damon-sysfs-read-addr_unit-only-once-in-damon_sysfs_apply_inputs.patch
mm-damon-sysfs-read-ops_id-only-once-in-damon_sysfs_apply_inputs.patch
mm-damon-core-initialize-damos-last_applied.patch
mm-damon-core-kunit-check-region-count-before-testing-in-split_at.patch
mm-damon-vaddr-kunit-check-region-count-in-three_regions-test.patch
mm-damon-core-kunit-handle-region-split-failure-in-filter_out.patch
mm-damon-core-kunit-skip-wrong-dest-walk-in-commit_dests_for.patch
mm-damon-core-kunit-skip-wrong-quota-goal-walk-in-commit_quota_goals.patch
mm-damon-core-kunit-skip-wrong-region-walk-in-commit_target_regions.patch
mm-damon-ops-common-use-nr_accesses-moving-sum-for-quota-score.patch
mm-damon-core-handle-region-split-failure-in-apply_min_nr_regions.patch

