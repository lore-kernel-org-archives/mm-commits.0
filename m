Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9471C84A3
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188507; cv=none; b=qAFmCIVr7mg3BtX0OF50lz2cobDcKKlTqShVeE2cfU8JHoWm0juAW2VNCexW0VjBugRq3kFNtJF0Rt7NA8y6a4MhA1ignQWoDtz9D2bisFN6x9/lXuQC1nT7vddefW1oC4C6vn6KACEvu6nJYR+YkMY7PYoEhXw8g18DXKJCfp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188507; c=relaxed/simple;
	bh=2cXiVh2tFqVRhl4TohsiDi4utNTBntoXj2DRU2B3O+k=;
	h=Date:To:From:Subject:Message-Id; b=i7K8mkrQju8r1xEkvc7YoPfHHq7hIQGB1Fch/zIdLDpbquJf02Olc78sLHYHsTr5kXlHn/1Xs0BdN82Y5No08BuKipAzoDuQHGI/mO0WlFSdXDuP4l/637rTyh4ikOLeiTg+W9WqLHTYl2Sa45Ia3TB/YhZSRDlg2ltcYDtYTVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j8GAs2D9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j8GAs2D9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DECC4CEEC;
	Mon, 17 Mar 2025 05:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188507;
	bh=2cXiVh2tFqVRhl4TohsiDi4utNTBntoXj2DRU2B3O+k=;
	h=Date:To:From:Subject:From;
	b=j8GAs2D9sptGyarAChKbF65NPrwD8bt/Ma1HAtQLqLYZLuOGE1jFKT2I8ABK7lm5B
	 wz1QPPWtIp23vHsYehzwvy4StABEhkqizrN+9e9W87n2/UDHkXaNutYkBAy03T7fCC
	 7KVY8QMVdY98EfkPKxD55KUD1DXQEZ5Lq7AB4g0s=
Date: Sun, 16 Mar 2025 22:15:06 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-document-intervals-auto-tuning-abi.patch removed from -mm tree
Message-Id: <20250317051507.60DECC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: document intervals auto-tuning ABI
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-document-intervals-auto-tuning-abi.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: document intervals auto-tuning ABI
Date: Mon, 3 Mar 2025 14:17:25 -0800

Document the DAMON user-space ABI for DAMON sampling and aggregation
intervals auto-tuning.

Link: https://lkml.kernel.org/r/20250303221726.484227-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   30 ++++++++++++++
 1 file changed, 30 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-intervals-auto-tuning-abi
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -91,6 +91,36 @@ Description:	Writing a value to this fil
 		DAMON context in microseconds as the value.  Reading this file
 		returns the value.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/access_bp
+Date:		Feb 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a value to this file sets the monitoring intervals
+		auto-tuning target DAMON-observed access events ratio within
+		the given time interval (aggrs in same directory), in bp
+		(1/10,000).  Reading this file returns the value.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/aggrs
+Date:		Feb 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a value to this file sets the time interval to achieve
+		the monitoring intervals auto-tuning target DAMON-observed
+		access events ratio (access_bp in same directory) within.
+		Reading this file returns the value.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/min_sample_us
+Date:		Feb 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a value to this file sets the minimum value of
+		auto-tuned sampling interval in microseconds.  Reading this
+		file returns the value.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/max_sample_us
+Date:		Feb 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a value to this file sets the maximum value of
+		auto-tuned sampling interval in microseconds.  Reading this
+		file returns the value.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/nr_regions/min
 
 WDate:		Mar 2022
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

