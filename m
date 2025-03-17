Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6B52153E0
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188258; cv=none; b=tVnwsPtRXILNJLCVlfAN9xUVgq2TqIacyIQlAPEacx7qDhCsuDxNTRhOvASsgqVc2SqUhQwB9CvdWUKnakSJ7CQBcqgCNi6ZbzZ/ChjmkO7QM/7502YcrL2UPa8h4d8eCOIuoanSsDsOEJ9bqPWP09Rk6rGxBXG8zzNM+prYyN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188258; c=relaxed/simple;
	bh=3GVay6dAnxDjLdvPLlK6foZ2cSzjO0XHu6094cX9J/M=;
	h=Date:To:From:Subject:Message-Id; b=PlyArbXWMQEKS/mPFrq50JEJp/neMMAeF7rgX2zf/XlahH91aupjj/ODLBIKyUOnRm1X9p1ysI2Wp79Yr3XfkE5QXxh90CRH4vlUE0v7pQ3fHkfteoSS1G9fI/UZTHnD4qLpuNgRS+WWOIGYBOf1CRaBXb36HTkvB2vJJFd80Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QuNwgmPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QuNwgmPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2579C4CEEC;
	Mon, 17 Mar 2025 05:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188258;
	bh=3GVay6dAnxDjLdvPLlK6foZ2cSzjO0XHu6094cX9J/M=;
	h=Date:To:From:Subject:From;
	b=QuNwgmPxEVvVsXyBb/vx7DH8d+3rWesCgx25HlrCM6njQj5rG8pTcPkJViCL/6Aqs
	 pEg/y35GyHqTY9MjOdweTTbeax2s2WaP8xiuxM8ByfVgzPsJbWkL7wcaZuqOMjRQKE
	 o81KMh+Q80DnVFuSMuTW7p+vOyoDZiCJZux3Ztt0=
Date: Sun, 16 Mar 2025 22:10:58 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch removed from -mm tree
Message-Id: <20250317051058.B2579C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: do not call damos_walk_control->walk() if walk is completed
has been removed from the -mm tree.  Its filename was
     mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: do not call damos_walk_control->walk() if walk is completed
Date: Mon, 10 Feb 2025 10:27:35 -0800

damos_walk() invokes callback functions of schemes until all schemes
finishes at least one round of walks.  If there are multiple DAMOS schemes
having different apply_interval, the callback functions for longer apply
interval scheme will be called for more than a round of the walk.

The behavior is different from the document (see damos_walk() kernel-doc
comment), and not useful.  Make the behavior be same to the documented
one, by stopping invoking the callback if the walk for the given scheme is
completed.

Link: https://lkml.kernel.org/r/20250210182737.134994-3-sj@kernel.org
Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed
+++ a/mm/damon/core.c
@@ -1458,6 +1458,9 @@ static void damos_walk_call_walk(struct
 {
 	struct damos_walk_control *control;
 
+	if (s->walk_completed)
+		return;
+
 	mutex_lock(&ctx->walk_control_lock);
 	control = ctx->walk_control;
 	mutex_unlock(&ctx->walk_control_lock);
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

