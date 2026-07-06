Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEAA2F7ACE
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 17:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783357845; cv=none; b=VTN4q9NZHtNWdt/PdQQ+sQPkuNct97IL9ZhfoapCV3MN9IWzTHmVZW5+/NLJNBrKtPvNCeg5fkB5LZfnBVqIbAwjtzijncH/Z27NPwpmNDs7VnjdDn4WjSsy81VJc9Zm42U5flDz4EL0E3l0yYKAKDPnOu1o+qrsp2lXkGtQk1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783357845; c=relaxed/simple;
	bh=YtMXWGu+e5hf2TvIyyHbHh9RC5rA/vjPgTOtKant6Mg=;
	h=Date:To:From:Subject:Message-Id; b=XzzvXRX+NM8UcM6SrWJn6FXSDKrLXijB9vrlZqCWu2Wjelv5y8i8QrJA6PW0whDe1+4oW9Ad7wAOY+kHBBLIsjixevYbibLRAhKXnDc8JwcBl5CLaO1QgZpJtyTHWyFNnLpmbWkVd4Y1gdX6Yjkwq8jtr3NyEsPUYGMpg0Sqyb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F4sojT2Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F4sojT2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BDF1F00A3D;
	Mon,  6 Jul 2026 17:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783357843;
	bh=4fG+dNBroO19zXuQ9AX/AAZgM95RwqtOJzxdWbKKVuI=;
	h=Date:To:From:Subject;
	b=F4sojT2ZoriqSgiYPtoIcIN2MHBqa93kiNRB78OHpRo8zc/72i/wF+8XRO+J3YbhU
	 JcQlW9K+FQWV12bQOAqX18/OSqETzvMOOaT1JJsv907wpzRaXTk5ofO0/r20/5qdlX
	 a4UdxbYBHBq9O/E8Nw8FUz+IWuytBaVc5fnpDg7U=
Date: Mon, 06 Jul 2026 10:10:43 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-mtier-stop-all-contexts-with-single-damon_stop-call.patch added to mm-new branch
Message-Id: <20260706171043.A8BDF1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/mtier: stop all contexts with single damon_stop() call
has been added to the -mm mm-new branch.  Its filename is
     samples-damon-mtier-stop-all-contexts-with-single-damon_stop-call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-mtier-stop-all-contexts-with-single-damon_stop-call.patch

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
Subject: samples/damon/mtier: stop all contexts with single damon_stop() call
Date: Mon, 6 Jul 2026 07:06:23 -0700

damon_stop() was theoretically able to return failure while keeping the
second context for mtier running.  mtier stops its contexts one by one
with two damon_stop() call for the reason.  damon_stop() is refactored to
always successfully stop all requested DAMON contexts.  The two calls are
unnecessary.  Use only single damon_stop() call for all contexts.

Link: https://lore.kernel.org/20260706140628.87414-9-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/samples/damon/mtier.c~samples-damon-mtier-stop-all-contexts-with-single-damon_stop-call
+++ a/samples/damon/mtier.c
@@ -200,8 +200,7 @@ static int damon_sample_mtier_start(void
 
 static void damon_sample_mtier_stop(void)
 {
-	damon_stop(ctxs, 1);
-	damon_stop(&ctxs[1], 1);
+	damon_stop(ctxs, 2);
 	damon_destroy_ctx(ctxs[0]);
 	damon_destroy_ctx(ctxs[1]);
 }
_

Patches currently in -mm which might be from sj@kernel.org are

maintainers-s-seongjae-sj.patch
mm-damon-core-validate-ranges-in-damon_set_regions.patch
mm-damon-core-disallow-overlapping-input-ranges-for-damon_set_regions.patch
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
mm-damon-add-damon_region-last_probe_hits.patch
mm-damon-core-introduce-damon_probe_hits_mvsum.patch
mm-damon-sysfs-schemes-set-probe-hits-as-pseudo-moving-sums.patch
mm-damon-core-safely-validate-src-on-damon_commit_ctx.patch
mm-damon-core-do-parameter-testing-commit-on-damon_start.patch
mm-damon-sysfs-remove-duplicated-commit-input-validity-check.patch
mm-damon-reclaim-remove-duplicated-min_region_sz-power-of-2-check.patch
mm-damon-lru_sort-remove-duplicated-min_region_sz-power_of_2-check.patch
mm-damon-document-region-size-validation-in-damon_set_regions.patch
mm-damon-core-remove-start-end-check-in-damon_set_region_system_rams.patch
mm-damon-sysfs-remove-region-size-validation.patch
mm-damon-core-stop-ctxs-in-damon_start-before-returning-an-error.patch
samples-damon-mtier-do-not-stop-first-context-for-damon_start-failure.patch
mm-damon-core-make-damon_stop-never-fails.patch
mm-damon-sysfs-ignore-damon_stop-return-value.patch
mm-damon-reclaaim-ignore-damon_stop-return-value.patch
mm-damon-lru_sort-ignore-damon_stop-return-value.patch
mm-damon-core-change-damon_stop-return-type-to-void.patch
samples-damon-mtier-stop-all-contexts-with-single-damon_stop-call.patch
mm-damon-core-wait-ctx-stop-in-damon_call-before-reruning-an-error.patch
samples-damon-wsse-do-not-stop-ctx-for-damon_call-failure.patch
samples-damon-prcl-do-not-stop-damon-for-damon_call-failure.patch

