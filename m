Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F8A2B9BA
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 00:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782951786; cv=none; b=IT8jjhQ+bqoNsvo6HvOegRelouCTYRMgT7MB/dRvQdFWruE6mnA+quYZcSVUuEH9pJHdSOt5116dgNVs8ln6ZY+dPhNh8IWTFUbhDONmb5uCG1QwTK7YtKhLSXjVas9HNDNpr4M4agyATn779EQ8bl/ghWLhJsh3mkdzz4RuDx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782951786; c=relaxed/simple;
	bh=JBngguhOIz4wUaLqZw/PYovQ4zSenQSGOLtY0kju2nI=;
	h=Date:To:From:Subject:Message-Id; b=qONbaL8Aupq4F9zFo7/nuSthk0mRFRaEEiOw+OEaATG86SkM9g/L5C25z/uQQ8+bBD8QfG01MbiQCZvP03pYUc0hfvkLZqhGBCf0V6SKgDDcfS0EhuBNwl5UyvBw70hPJpdEBTJfARiB0dXY0zzX1aBNOj54mDEBrDQeu0+aTlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kSM3MTzM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kSM3MTzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C361F000E9;
	Thu,  2 Jul 2026 00:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782951785;
	bh=JMOLS2l0cseFgCuT7TmKc5GgbEHFHAzBkbp49DS/514=;
	h=Date:To:From:Subject;
	b=kSM3MTzMP0+0/XjyW87ZMAnCRo6CQlWTHxFzEHtPxqWfXHtBYMQgCKDu0wVr03R3f
	 DrHlLKJFBZEYnMwIX1MI1T3AvIrVnV5NB7P8rA7/qS/CE+Lt+4N02K26Tn4pif+yBP
	 kyMVDaKsBzMRVpwm6xfZFh2mqD7FbCF2/ju8sHaU=
Date: Wed, 01 Jul 2026 17:23:04 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-handle-unreset-nr_accesses-in-damon_nr_accesses_mvsum.patch added to mm-new branch
Message-Id: <20260702002305.32C361F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: handle unreset nr_accesses in damon_nr_accesses_mvsum()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-handle-unreset-nr_accesses-in-damon_nr_accesses_mvsum.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-handle-unreset-nr_accesses-in-damon_nr_accesses_mvsum.patch

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
Subject: mm/damon/core: handle unreset nr_accesses in damon_nr_accesses_mvsum()
Date: Mon, 29 Jun 2026 21:07:57 -0700

damon_set_attrs() works like reverting aggregations that were made so far
for this aggregation window.  If this is the end of the aggregation,
however, kdamond_fn() will do the operations at the end of the aggregation
interval, using cached timestamps.  For such operations that rely on
damon_region->nr_accesses, damon_update_monitoring_results() doesn't reset
the nr_accesses if it is called at the end of the aggregation window.

damon_nr_accesses_mvsum() works with fresh timestamps, though.  The
nr_accesses that are not reset in this case can make the logic to
unnecessarily count nr_accesses, resulting in returning
higher-than-expected pseudo moving sum nr_accesses.  No code is using
damon_nr_accesses_mvsum() yet, so this is not causing a real problem. 
Following commits will add usage of the function, though.  For safe
usages, calculate the pseudo moving sum without nr_accesses if the
remaining window is full.

Link: https://lore.kernel.org/20260630040812.149729-5-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-handle-unreset-nr_accesses-in-damon_nr_accesses_mvsum
+++ a/mm/damon/core.c
@@ -266,6 +266,9 @@ unsigned int damon_nr_accesses_mvsum(str
 			ctx->passed_sample_intervals;
 	left_window_bp = mult_frac(left_window, 10000, window_len);
 
+	if (left_window_bp == 10000)
+		return r->last_nr_accesses;
+
 	return damon_mvsum(r->nr_accesses, r->last_nr_accesses,
 			left_window_bp);
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

