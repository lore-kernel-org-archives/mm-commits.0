Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFAF21576A
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188260; cv=none; b=t8GcKbXYdKA0sYZkXau4VsxjRxdy8smz5PlFlnecYwsbrBDccTEhYxO4qArir0IMT4cqs7sI7bcKoULfu+wUu2WqKv2J73czqsGU4vXS7TDP3LLf4W8ovd8JLfTIdMLoc1c9WnFtpL3KBvU/dSfOnlYFKyjx4RL46XzCWmDiHPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188260; c=relaxed/simple;
	bh=x/PGGlLc02XOwTh4ue+HFLgLJrulOP7Jb521PnWjqm4=;
	h=Date:To:From:Subject:Message-Id; b=Com8Ztdnq4MbIHKoxu8ucQbrnD4b68Y71P2t4UaILLrCFPmsRmgPxLsEmaAw3ST0SPtseoLym7NMqAY3jhF3AGXAFYv8XnSkL94ARm1XLxHD/OFPw7+blgXhGmgBPewrndjxYzYVRHkRC+eGWLbR/ayZJP+wboxB2Ybcjof5/KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P1q2qDJI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P1q2qDJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C206DC4CEEC;
	Mon, 17 Mar 2025 05:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188259;
	bh=x/PGGlLc02XOwTh4ue+HFLgLJrulOP7Jb521PnWjqm4=;
	h=Date:To:From:Subject:From;
	b=P1q2qDJIGLSgTjoEIf+Mk1REGQyUiEdE1dkiXl+H191UnHhy3KlgW+kwjjgagZNYV
	 nvr22GQ9Tx9YLcUcsIdXMDvA4DFxGNgDzQRlkw2e8PaQWO1g2dgIAaA6dvUoNi+9YK
	 d9vaPUK7e2ykxuYotas9g1b90Bq8W4s9e7HooEcY=
Date: Sun, 16 Mar 2025 22:10:59 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch removed from -mm tree
Message-Id: <20250317051059.C206DC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: do damos walking in entire regions granularity
has been removed from the -mm tree.  Its filename was
     mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: do damos walking in entire regions granularity
Date: Mon, 10 Feb 2025 10:27:36 -0800

damos_walk_control can be installed while DAMOS is walking the regions. 
This means the walk callback function invocations can be started from a
region at the middle of the regions list.  This makes it hard to be used
reliably.  Particularly, DAMOS tried regions update for collecting
monitoring results gets problematic results.  Increase the
walk_control_lock critical section to do walking in entire regions
granularity.

Link: https://lkml.kernel.org/r/20250210182737.134994-4-sj@kernel.org
Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-do-damos-walking-in-entire-regions-granularity
+++ a/mm/damon/core.c
@@ -1461,11 +1461,10 @@ static void damos_walk_call_walk(struct
 	if (s->walk_completed)
 		return;
 
-	mutex_lock(&ctx->walk_control_lock);
 	control = ctx->walk_control;
-	mutex_unlock(&ctx->walk_control_lock);
 	if (!control)
 		return;
+
 	control->walk_fn(control->data, ctx, t, r, s, sz_filter_passed);
 }
 
@@ -1485,9 +1484,7 @@ static void damos_walk_complete(struct d
 	struct damos *siter;
 	struct damos_walk_control *control;
 
-	mutex_lock(&ctx->walk_control_lock);
 	control = ctx->walk_control;
-	mutex_unlock(&ctx->walk_control_lock);
 	if (!control)
 		return;
 
@@ -1501,9 +1498,7 @@ static void damos_walk_complete(struct d
 		siter->walk_completed = false;
 
 	complete(&control->completion);
-	mutex_lock(&ctx->walk_control_lock);
 	ctx->walk_control = NULL;
-	mutex_unlock(&ctx->walk_control_lock);
 }
 
 /*
@@ -1850,6 +1845,7 @@ static void kdamond_apply_schemes(struct
 	if (!has_schemes_to_apply)
 		return;
 
+	mutex_lock(&c->walk_control_lock);
 	damon_for_each_target(t, c) {
 		damon_for_each_region_safe(r, next_r, t)
 			damon_do_apply_schemes(c, t, r);
@@ -1864,6 +1860,7 @@ static void kdamond_apply_schemes(struct
 			 c->attrs.aggr_interval) / sample_interval;
 		s->last_applied = NULL;
 	}
+	mutex_unlock(&c->walk_control_lock);
 }
 
 /*
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch
mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch
mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch
mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch
mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch
mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch
docs-abi-damon-document-coreops_filters-directories.patch
docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch
mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch
mm-damon-core-invoke-kdamond_call-after-merging-is-done-if-possible.patch
mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call.patch
mm-damon-sysfs-handle-commit-command-using-damon_call.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch
mm-damon-sysfs-schemes-remove-obsolete-comment-for-damon_sysfs_schemes_clear_regions.patch
mm-damon-remove-damon_callback-private.patch
mm-damon-remove-before_start-of-damon_callback.patch
mm-damon-remove-damon_callback-after_sampling.patch
mm-damon-remove-damon_callback-before_damos_apply.patch
mm-damon-remove-damon_operations-reset_aggregated.patch
mm-damon-sysfs-schemes-avoid-wformat-security-warning-on-damon_sysfs_access_pattern_add_range_dir.patch
mm-madvise-use-is_memory_failure-from-madvise_do_behavior.patch
mm-madvise-split-out-populate-behavior-check-logic.patch
mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings.patch
mm-madvise-remove-len-parameter-of-madvise_do_behavior.patch

