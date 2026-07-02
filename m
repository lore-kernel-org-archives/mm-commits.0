Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45351F30BB
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 00:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782951797; cv=none; b=b7a+uFymkEiwEbLRS9tDmx/gSyRLDU4yEXVaYaQ+M1bjYj6H4waw7FP7LDeP8Z8lgiiRgM3lw8sEzoMyS7eURj8AB+UhyBvaXGZNQ790lo3caQW0BG5PGGq2OmTQpttHLaxNxeRRkL8K/WX7XCXAPJABqb5Zaetcvv/kZahwduo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782951797; c=relaxed/simple;
	bh=AA92ezHzvZl+4txwuYlL/BVMxl7sfRvjy7W8x1l9ZeE=;
	h=Date:To:From:Subject:Message-Id; b=UpDX/TLE9hyFh9jRYsLpLcULadavhay+c8wmba0DTSf649hoeb3GJpkfpS0x8P48W4te31rWZQq/WcmCWxkh6rtup93tOFqfvWGWHsaCyGjw2iuzCH209k7mGR+w5IDhCbKeA335LBK0yEhSL1WwaW2zzHiulSpJzrZ48euIo1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RORVKZNi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RORVKZNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8A01F000E9;
	Thu,  2 Jul 2026 00:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782951795;
	bh=ep5p3kkI6Uk6grSbjwca/DQ88rKtGbpapHdnDvrUvas=;
	h=Date:To:From:Subject;
	b=RORVKZNiA6uDWqjdkK1r4VE1yPkln0lYhuJ0NbcCdzo70o4RN6uXea+yxUoG4Zylx
	 82bbAhAB0BBJE0aTaSqWo4IsI44NB+xda8h6zuybTgt5ojf1U+T9ByVkMhNDjBjnIa
	 +PxD93PGAu17w/MsWpZwAvCeyh5c8mdBLjKvr/Cs=
Date: Wed, 01 Jul 2026 17:23:14 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-remove-damon_verify_reset_aggregated.patch added to mm-new branch
Message-Id: <20260702002315.5E8A01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: remove damon_verify_reset_aggregated()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-remove-damon_verify_reset_aggregated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-remove-damon_verify_reset_aggregated.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: remove damon_verify_reset_aggregated()
Date: Mon, 29 Jun 2026 21:08:02 -0700

nr_accesses_bp is no longer being used in real use cases.  Remove its
validation function.

Link: https://lore.kernel.org/20260630040812.149729-10-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   18 ------------------
 1 file changed, 18 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-remove-damon_verify_reset_aggregated
+++ a/mm/damon/core.c
@@ -2012,23 +2012,6 @@ int damos_walk(struct damon_ctx *ctx, st
 	return 0;
 }
 
-#ifdef CONFIG_DAMON_DEBUG_SANITY
-static void damon_verify_reset_aggregated(struct damon_region *r,
-		struct damon_ctx *c)
-{
-	WARN_ONCE(r->nr_accesses_bp != r->last_nr_accesses * 10000,
-			"nr_accesses_bp %u last_nr_accesses %u sis %lu %lu\n",
-			r->nr_accesses_bp, r->last_nr_accesses,
-			c->passed_sample_intervals, c->next_aggregation_sis);
-}
-#else
-static void damon_verify_reset_aggregated(struct damon_region *r,
-		struct damon_ctx *c)
-{
-}
-#endif
-
-
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
@@ -2057,7 +2040,6 @@ static void kdamond_reset_aggregated(str
 			r->nr_accesses = 0;
 			for (i = 0; i < DAMON_MAX_PROBES; i++)
 				r->probe_hits[i] = 0;
-			damon_verify_reset_aggregated(r, c);
 		}
 		ti++;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-fix-dir-put-orders-in-access_pattern_add_dirs.patch
mm-damon-sysfs-schemes-put-stats-for-scheme_add_dirs-internal-error.patch
mm-damon-ops-common-handle-extreme-intervals-in-damon_hot_score.patch
mm-damon-add-a-kernel-doc-comment-for-damon_ctx-probes.patch
mm-damon-add-a-kernel-doc-comment-for-damon_ctx-rnd_state.patch
maintainers-s-seongjae-sj.patch
samples-damon-wsse-handle-damon_start-failure.patch
samples-damon-prcl-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_stop-failure.patch
samples-damon-wsse-stop-and-free-damon-ctx-when-damon_call-fails.patch
samples-damon-prcl-stop-and-free-damon-ctx-when-damon_call-fails.patch
mm-damon-sysfs-kobject_del-target-normal-context-and-kdamond-dirs.patch
mm-damon-sysfs-kobject_del-region-and-target-error-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-region-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-filter-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-quota-goal-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-action-destination-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs.patch
mm-damon-sysfs-kobject_del-probe-filter-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs-in-probes_addd_dir-error-path.patch
mm-damon-sysfs-schemes-kobject_del-region-for-populate_region-error.patch
docs-mm-damon-design-update-for-damos_quota_node_eligible_mem_bp.patch
docs-abi-damon-document-probe-files.patch
mm-damon-tests-core-kunit-test-damon_rand.patch
selftests-damon-sysfssh-test-multiple-probe-dirs-creation.patch
selftests-damon-sysfssh-test-coreops_filters-directories.patch
selftests-damon-sysfssh-test-dests-dir.patch
selftests-damon-sysfssh-test-all-files-in-quota-goal-dir.patch
mm-damon-core-reduce-range-setup-in-damon_commit_target_regions.patch
mm-damon-sysfs-split-probe-setup-function-out.patch
mm-damon-sysfs-split-out-filters-setup-function.patch
mm-damon-sysfs-fix-typos-in-probe_addrm_dirs-s-attr-probe.patch
mm-damon-core-introduce-damon_nr_accesses_mvsum.patch
mm-damon-tests-core-kunit-test-damon_mvsum.patch
mm-damon-core-always-update-last_nr_accesses-for-intervals-change.patch
mm-damon-core-handle-unreset-nr_accesses-in-damon_nr_accesses_mvsum.patch
mm-damon-core-use-damon_nr_accesses_mvsum-in-__damos_valid_target.patch
mm-damon-core-use-damon_nr_accesses_mvsum-for-damos-region-tracing.patch
mm-damon-sysfs-schemes-use-damon_nr_accesses_mvsum-for-damo-regions.patch
mm-damon-core-remove-damon_warn_fix_nr_accesses_corruption.patch
mm-damon-core-remove-damon_verify_reset_aggregated.patch
mm-damon-core-remove-damon_verify_merge_regions_of.patch
mm-damon-tests-core-kunit-remove-nr_accesses_bp-setup-and-tests.patch
selftests-damon-drgn_dump_damon_status-do-not-dump-nr_accesses_bp.patch
mm-damon-core-remove-nr_accesses_bp-setups-and-updates.patch
mm-damon-core-remove-attrs-param-from-damon_update_region_access_rate.patch
mm-damon-paddr-remove-attrs-param-from-__damon_pa_check_access.patch
mm-damon-vaddr-remove-attrs-param-from-__damon_va_check_access.patch
mm-damon-core-remove-damon_moving_sum-and-its-unit-test.patch
mm-damon-core-remove-damon_region-nr_accesses_bp.patch

