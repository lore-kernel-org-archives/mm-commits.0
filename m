Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E18236196A;
	Wed,  5 Aug 2026 03:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785898983; cv=none; b=pHKlFLLJNI5gNT3fJlpCKlqNSFcqTp/0Qyz/HVuM/+ku5I/LkkIvr941/W4nllj4dz91OzcNY6nZqcv9mGNffmInF289WjkEJRK2AFtNtMYBk2jsNvweR529LmFScWy3LSnW96uztiCRdGtGZJejR/uJTCc2eNpzcXolyTkkxu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785898983; c=relaxed/simple;
	bh=wUm0150Ej5vP7ogB9C2HTpeqy+B8f/eEAxkqK6LqPlQ=;
	h=Date:To:From:Subject:Message-Id; b=h31Wz26LgGo71wqo3y41Fm9V3pcdmW6R8Ek2PypdJsAfUTxYl1ORMI7hrSmI9JwMfNwyRJpcratwVRZa9E9RDaM4XkK7ySsu7wTL8xiRCfvLY0WEBfdg+9Y+QG+CmjC654fAL1JNzcH2GwXCOAweZqVpisbAPnzfI2Jg0L6QXUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XBjjTY5d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XBjjTY5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F5C1F000E9;
	Wed,  5 Aug 2026 03:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785898982;
	bh=4EL4rOY6KnFbyQl+FBmJRW5spuQMWifrLFmPeDBm6gY=;
	h=Date:To:From:Subject;
	b=XBjjTY5dGxFV6dhe0NTS2wvSMh2PkX+uJzHq4F2croc8jFPBdZKMa4p9YFsoczjlQ
	 ZOQcybqRaDcDURjMaSVYE2h24YKkaH+fREekWKcZ9d4/jYPimQCgKkhuz7gYFT532K
	 P/OonI8v6P2/lpHIe8+QKyq+svN0Ywy2I1bt+E+o=
Date: Tue, 04 Aug 2026 20:03:01 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch removed from -mm tree
Message-Id: <20260805030302.44F5C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: error out for >10000 active_mem_bp
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/lru_sort: error out for >10000 active_mem_bp
Date: Mon, 3 Aug 2026 06:40:33 -0700

damos_quota_score() can trigger division by zero if the target value is
zero.  DAMON_LRU_SORT lets users set the target value for the hot memory
scheme via active_mem_bp parameter.  It avoids setting it as the target
value if the parameter value is zero.  However, it also sets the cold
memory scheme with a target value that is calculated as '10000 -
active_mem_bp + 2'.  Hence, if a user sets active_mem_bp 10002, the cold
memory scheme's quota goal target value can be zero.  As a result,
division by zero can be triggered.  Fix by returning an error when the
user tries to start DAMON with >10000 active_mem_bp parameter value.

It makes no sense to set active_mem_bp with 10002.  It also requires
module parameters write permission to reproduce the issue.  That said, the
consequence is quite bad.

One reliable way to reproduce the issue is like below:

    # cd /sys/module/damon_lru_sort/parameters
    # echo 1000 > wmarks_high
    # echo 995 > wmarks_mid
    # echo 0 > wmarks_low
    # echo 10002 > active_mem_bp
    # echo Y > enabled
    # dmesg -w
    [...]
    [  597.421247] Oops: divide error: 0000 [#1] SMP NOPTI
    [  597.428848] RIP: 0010:damos_quota_score+0x6f/0x480

This issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260803134034.15217-3-sj@kernel.org
Link: https://lore.kernel.org/20260801213028.5127-1-sj@kernel.org [1]
Fixes: 40d98d31cd70 ("mm/damon/lru_sort: support active:inactive memory ratio based auto-tuning")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-error-out-for-10000-active_mem_bp
+++ a/mm/damon/lru_sort.c
@@ -233,6 +233,8 @@ static int damon_lru_sort_add_quota_goal
 
 	if (!active_mem_bp)
 		return 0;
+	if (10000 < active_mem_bp)
+		return -EINVAL;
 	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, active_mem_bp);
 	if (!goal)
 		return -ENOMEM;
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

