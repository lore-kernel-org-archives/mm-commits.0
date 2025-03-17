Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84C621884A
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188502; cv=none; b=sMhb4xwvQrrwx9am8h0awdqjrFtIeZ9sNb7hKAU5TX3BfT3eu6tJXKcOAoZ2oL4+euArBpbJlDY+nXK78uQQGSRywxY61mlIY6ZDgEPpW9EFGAz0/JBNgDR61F04jdMgKG1alxUWmZN8SiAIC+vxn3SVw36qy+Prhe98NsLDDRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188502; c=relaxed/simple;
	bh=RK0Qc8wYcZ2TUmwqdLEEONDA8ZTbzxu5EFcurjmiZBw=;
	h=Date:To:From:Subject:Message-Id; b=mBZGA8lXP2tBwBwGp4Q6rUGssAxBDm7WR+ylPRSsxA3+Ei+TVpWIbo1asonzDX67v+doMMUqLo9+RtlN1gv6GwBoKqdyp8irU29g5tzGuB49FomZqv/LMi9K0LAhffYPoW69VL0Q1/zVIL9EO+q514qFospBeRS1n67WFKiP7a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=irhN4EKu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="irhN4EKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F5CC4CEEC;
	Mon, 17 Mar 2025 05:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188502;
	bh=RK0Qc8wYcZ2TUmwqdLEEONDA8ZTbzxu5EFcurjmiZBw=;
	h=Date:To:From:Subject:From;
	b=irhN4EKu9JpPwcs99jyRgKXI9WXciQkw9An78jHpmo0cP3091KdWcq2C4w9VmyjHE
	 krIfW9zxcDJODSNTZQPi7B39LTHcAG8GXLkrVJtaDuq9G/lIcnyUXoSUxvmcUzvtiO
	 6BEk7rHl14rhpkE5diyv08aQ97hnDTg0k2endHMU=
Date: Sun, 16 Mar 2025 22:15:01 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-commit-intervals-tuning-goal.patch removed from -mm tree
Message-Id: <20250317051502.99F5CC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: commit intervals tuning goal
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-commit-intervals-tuning-goal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: commit intervals tuning goal
Date: Mon, 3 Mar 2025 14:17:22 -0800

Connect DAMON sysfs interface for sampling and aggregation intervals
auto-tuning with DAMON core API, so that users can really use the feature
using the sysfs files.

Link: https://lkml.kernel.org/r/20250303221726.484227-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-commit-intervals-tuning-goal
+++ a/mm/damon/sysfs.c
@@ -1273,11 +1273,18 @@ static int damon_sysfs_set_attrs(struct
 		struct damon_sysfs_attrs *sys_attrs)
 {
 	struct damon_sysfs_intervals *sys_intervals = sys_attrs->intervals;
+	struct damon_sysfs_intervals_goal *sys_goal =
+		sys_intervals->intervals_goal;
 	struct damon_sysfs_ul_range *sys_nr_regions =
 		sys_attrs->nr_regions_range;
 	struct damon_attrs attrs = {
 		.sample_interval = sys_intervals->sample_us,
 		.aggr_interval = sys_intervals->aggr_us,
+		.intervals_goal = {
+			.access_bp = sys_goal->access_bp,
+			.aggrs = sys_goal->aggrs,
+			.min_sample_us = sys_goal->min_sample_us,
+			.max_sample_us = sys_goal->max_sample_us},
 		.ops_update_interval = sys_intervals->update_us,
 		.min_nr_regions = sys_nr_regions->min,
 		.max_nr_regions = sys_nr_regions->max,
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

