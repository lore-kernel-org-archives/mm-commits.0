Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1488E1DE4E0
	for <mm-commits@vger.kernel.org>; Fri, 20 Mar 2026 19:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774034548; cv=none; b=gkX+nMIzANWfNRw8RDmsjMSmdTMYT9uqE7PIhrA1/X1/vv50KHyDDWiy9ccmjOWEDx7U2K5Hx1B/MzGQqJXY1iBP8Sgl9LFdteZbEbnJWRXhvP2mZ0Qc4U29z4Z+mMI0O3ZOp9eU9n7sY6IxxBjFYlA/k6WNOcaBg+wNRq8xMXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774034548; c=relaxed/simple;
	bh=d4Q/8e5gjWy276asN58xqNUEIT8om756i9gh1PHMWK8=;
	h=Date:To:From:Subject:Message-Id; b=o1uryh4i0mUD6yHG+yTf2bfVT3MGYiO0AZtqWQPQ8YJzmZmu6YeuHU3OLseQovKlDeAZlcD7wNFFcZlFpk/KP1yI29yjU0jg9Viq5oE74w8vt2LMTX+SwtG2RknVEF8vA9gaJ7zhg+LGbbvnlub7bgYB+ji/dUTFWjcXcLlNDZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NoX5pqT0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NoX5pqT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA7CC19425;
	Fri, 20 Mar 2026 19:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774034547;
	bh=d4Q/8e5gjWy276asN58xqNUEIT8om756i9gh1PHMWK8=;
	h=Date:To:From:Subject:From;
	b=NoX5pqT0eY90AumNi9AJllCvgnlDIpOgfCHVxFgb2zYzAAoTsJuXDIAmbdYUkPfv+
	 cDXBVgoEKktiKbeTWmdWz9dqANsZgNEdRK+Aga0YO2eunTGvCXy0Ey8WfY9xkgPDQM
	 raokThz1OD6DAmpnCzR4771nfysj8VNzK2xUqMaQ=
Date: Fri, 20 Mar 2026 12:22:27 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-avoid-use-of-half-online-committed-context-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20260320192227.9FA7CC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: let kdamond_call() with cancel regardless of maybe_corrupted
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-avoid-use-of-half-online-committed-context-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-avoid-use-of-half-online-committed-context-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: let kdamond_call() with cancel regardless of maybe_corrupted
Date: Thu, 19 Mar 2026 20:09:27 -0700

Otherwise, damon_call() callers could indefinitely wait [1].

Link: https://lkml.kernel.org/r/20260320031553.2479-1-sj@kernel.org
Link: https://sashiko.dev/#/patchset/20260319145218.86197-1-sj%40kernel.org [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-avoid-use-of-half-online-committed-context-fix
+++ a/mm/damon/core.c
@@ -2680,7 +2680,7 @@ static void kdamond_call(struct damon_ct
 			complete(&control->completion);
 		else if (control->canceled && control->dealloc_on_cancel)
 			kfree(control);
-		if (ctx->maybe_corrupted)
+		if (!cancel && ctx->maybe_corrupted)
 			break;
 	}
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-stat-monitor-all-system-ram-resources.patch
mm-damon-core-avoid-use-of-half-online-committed-context.patch
mm-damon-core-avoid-use-of-half-online-committed-context-fix.patch
mm-damon-core-set-quota-score-histogram-with-core-filters.patch
mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch
mm-damon-core-split-regions-for-min_nr_regions.patch
mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch
mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch
mm-damon-add-config_damon_debug_sanity.patch
mm-damon-core-add-damon_new_region-debug_sanity-check.patch
mm-damon-core-add-damon_del_region-debug_sanity-check.patch
mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch
mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch
mm-damon-core-add-damon_reset_aggregated-debug_sanity-check.patch
mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch
selftests-damon-config-enable-damon_debug_sanity.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch
docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch
mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch
mm-damon-core-use-time_before-for-next_apply_sis.patch
mm-damon-core-use-time_after_eq-in-kdamond_fn.patch
mm-damon-core-use-mult_frac.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch
mm-damon-core-clarify-damon_set_attrs-usages.patch
mm-damon-document-non-zero-length-damon_region-assumption.patch
docs-admin-guide-mm-damn-lru_sort-fix-intervals-autotune-parameter-name.patch
docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch
docs-mm-damon-index-fix-typo-autoamted-automated.patch
mm-damon-core-introduce-damos_quota_goal_tuner.patch
mm-damon-core-allow-quota-goals-set-zero-effective-size-quota.patch
mm-damon-core-introduce-damos_quota_goal_tuner_temporal.patch
mm-damon-sysfs-schemes-implement-quotas-goal_tuner-file.patch
docs-mm-damon-design-document-the-goal-based-quota-tuner-selections.patch
docs-admin-guide-mm-damon-usage-document-goal_tuner-sysfs-file.patch
docs-abi-damon-update-for-goal_tuner.patch
mm-damon-tests-core-kunit-test-goal_tuner-commit.patch
selftests-damon-_damon_sysfs-support-goal_tuner-setup.patch
selftests-damon-drgn_dump_damon_status-support-quota-goal_tuner-dumping.patch
selftests-damon-sysfspy-test-goal_tuner-commit.patch
mm-damon-core-fix-wrong-end-address-assignment-on-walk_system_ram.patch
mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram.patch
mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram-fix.patch
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default.patch
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default-fix.patch
mm-damon-reclaim-respect-addr_unit-on-default-monitoring-region-setup.patch
mm-damon-lru_sort-respect-addr_unit-on-default-monitoring-region-setup.patch

