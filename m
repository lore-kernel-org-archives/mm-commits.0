Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C76348C76;
	Wed,  5 Aug 2026 03:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785898986; cv=none; b=l7cLDvO/dOidyNO/uHEvIxnibN1YehHNXXWujGWqG6YFcTusP2Yf38SEljFHMziPVmDNTiX9BP/sicte44+lz9hDlDs3TbVRr3MlPDhWlN0eXzUWCY8Q3flOCQHozd94+CTIDoPBYQ0lkYwp9i2Z8hAjPqzg0iQP7ZNVF1UCHr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785898986; c=relaxed/simple;
	bh=CAx5USJ2MARDGHVLzoKDG1+NX9Ng7aIhyQlxe/Wel8Q=;
	h=Date:To:From:Subject:Message-Id; b=cyZwVL7tIpqk6flqZl3Z6bAXp8pQgjVoQQ4VOdWXV7iC9oyjClaJ4aQXCkWyFzb0rwfjdWAbAenqS6NU+IwTaPOpYukKJIAWbiUiQm2MRhMRYHRe5B3GXUggJivo0R3knmdpFA+X7yBmwVH6mRxxqktE9HOpqJzFNabJPu+nodU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HCLAEBaS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HCLAEBaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97E61F000E9;
	Wed,  5 Aug 2026 03:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785898985;
	bh=zUUy4tPdrZ/ddM72O6iQDInsQzrRqS+6Gkc0jkiNLvY=;
	h=Date:To:From:Subject;
	b=HCLAEBaS25VdrYw2BqYR03Oc35gPrEaaaIse8saC3GTBQEMzyafXCgFMgeKgwjDMq
	 z3gZQnjhNbG9k4h5khFdYD6mTfcss5GzQdqHkWOjLuWRsfm39EzW7c7zToRghPVZYv
	 82vIa9ZQgeG2zs38OInC9i3orax2/95xRuDt1nS4=
Date: Tue, 04 Aug 2026 20:03:04 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,aethernet65535@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-lru_sort-skip-damon_call-if-ctx-has-not-started.patch removed from -mm tree
Message-Id: <20260805030304.E97E61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: skip damon_call() if ctx has not started
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-skip-damon_call-if-ctx-has-not-started.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/lru_sort: skip damon_call() if ctx has not started
Date: Mon, 3 Aug 2026 06:46:45 -0700

DAMON_LRU_SORT calls damon_call() for commit_inputs parameter user input
if the DAMON context is initialized.  The context could be initialized,
but not yet successfully started.  In the case, damon_call() could
indefinitely hang.  Read the comment on damon_call() for more detail.  Fix
the problem by memorizing if the DAMON context has ever successfully
started, and skip damon_call() if it has not.

This issue can easily be reproduced by writing Y to the commit_inputs
parameter file on a system that DAMON_LRU_SORT has not turned on before.

Link: https://lore.kernel.org/20260803134646.16640-3-sj@kernel.org
Fixes: de3c60e1c831 ("mm/damon: add synchronous commit for commit_inputs")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Cc: <stable@vger.kernel.org> # 7.2.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-skip-damon_call-if-ctx-has-not-started
+++ a/mm/damon/lru_sort.c
@@ -351,6 +351,8 @@ static int damon_lru_sort_commit_inputs_
 	return damon_lru_sort_apply_parameters();
 }
 
+static bool damon_lru_sort_damon_has_started;
+
 static int damon_lru_sort_commit_inputs_store(const char *val,
 					      const struct kernel_param *kp)
 {
@@ -371,11 +373,8 @@ static int damon_lru_sort_commit_inputs_
 	if (!commit_inputs_request)
 		return 0;
 
-	/*
-	 * Skip damon_call() if ctx is not initialized to avoid
-	 * NULL pointer dereference.
-	 */
-	if (!ctx)
+	/* Skip damon_call() if ctx has not successfully started. */
+	if (!damon_lru_sort_damon_has_started)
 		return -EINVAL;
 
 	err = damon_call(ctx, &control);
@@ -426,6 +425,8 @@ static int damon_lru_sort_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
+	if (!damon_lru_sort_damon_has_started)
+		damon_lru_sort_damon_has_started = true;
 	return damon_call(ctx, &call_control);
 }
 
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

