Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888D73D9667
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525394; cv=none; b=m1Nw752iHvkyB3cT8QNxyAr5YfaRQO3HdyOmH8eDf+2g8sSx1yzY9zzKSI2WyRrXsswp2rDjA+iFZeIeEUjj5M1H8rj3VCv4gQHICRK5wU+QA9k6hqQC1Zi4A9Xv9F1/dQdn23DHe27LjYbi4UOk0ywOS2F9bDbVyCu7Mv1bRfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525394; c=relaxed/simple;
	bh=8qN2uR7n2fMn9VSxshW8TYL0INoFOkIcK6VetbLE98M=;
	h=Date:To:From:Subject:Message-Id; b=s3OSbnjo3CFT22B0pYxuNqdna3YFAsznGD63I+VCf37tnBqWrbJPOFghIDaDIdJug0XqWWJmbNnKFQAePDVk35XdUbau0is36lOIeR2Z2FGrJrG+0iugWL2VHyWHHunMzofYfClNxgciKTLnUuVS571EMTj/MYGYN4sjJyrQAe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WYnPybsS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WYnPybsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3311F00893;
	Fri,  9 Oct 2026 05:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525393;
	bh=C+8LeFKMEkIY7ZWb/JhvtT4ynOpYo3TCcWVr2poa6uc=;
	h=Date:To:From:Subject;
	b=WYnPybsSONd3iYVPi5j2kcIpwitFMVoYQbRGQpH8eN5QY2htRKRRLTP29ZY8dB4Lo
	 3NMn1xLIFa8ioztfYXEbanY6EtLaOnEScDvegFpjA8Mi5UG4wPRHyKl4lmHv4SAEhp
	 XXwQ2AMSwDT6tnEvgfkGLoyqy3n8QNOnbaGbmvjg=
Date: Thu, 08 Oct 2026 22:56:33 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-remove-unnecessary-damon_call-param-validation.patch removed from -mm tree
Message-Id: <20261009055633.5F3311F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: remove unnecessary damon_call() param validation
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-remove-unnecessary-damon_call-param-validation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/reclaim: remove unnecessary damon_call() param validation
Date: Wed, 2 Sep 2026 18:03:32 -0700

DAMON_RECLAIM avoids passing NULL or unstarted damon_ctx to damon_call()
with its own validation.  The validation is no longer needed, because the
DAMON core layer now handles the corner cases itself.  Remove the
unnecessary check.

Link: https://lore.kernel.org/20260903010334.93622-4-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-remove-unnecessary-damon_call-param-validation
+++ a/mm/damon/reclaim.c
@@ -271,8 +271,6 @@ static int damon_reclaim_commit_inputs_f
 	return damon_reclaim_apply_parameters();
 }
 
-static bool damon_reclaim_damon_has_started;
-
 static int damon_reclaim_commit_inputs_store(const char *val,
 					     const struct kernel_param *kp)
 {
@@ -293,10 +291,6 @@ static int damon_reclaim_commit_inputs_s
 	if (!commit_inputs_request)
 		return 0;
 
-	/* Skip damon_call() if ctx has not successfully started. */
-	if (!damon_reclaim_damon_has_started)
-		return -EINVAL;
-
 	err = damon_call(ctx, &control);
 
 	return err ? err : control.return_code;
@@ -343,8 +337,6 @@ static int damon_reclaim_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
-	if (!damon_reclaim_damon_has_started)
-		damon_reclaim_damon_has_started = true;
 	return damon_call(ctx, &call_control);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-read-sysfs_filter-addr_range-only-once.patch
mm-damon-sysfs-schemes-read-sysfs_filter-sz_range-only-once.patch
mm-damon-core-return-an-error-from-damos_commit_filter_arg.patch
mm-damon-core-disallow-max-min-damos-filter-range-arguments-commit.patch
mm-damon-sysfs-schemes-drop-centralized-filter-range-arg-validations.patch
mm-damon-sysfs-schemes-use-switch-case-in-add_scheme_filters.patch
mm-damon-core-kunit-extend-damos_commit_filter_for-for-wrong-input.patch
mm-damon-core-kunit-test-invalid-damos-filter-commits.patch
mm-damon-api-introduce-damon_filter_type_hugepage_size.patch
mm-damon-core-commit-hugepage_size-type-damon-filter.patch
mm-damon-ops-common-support-hugepage_size-damon-filter-matching.patch
mm-damon-sysfs-add-minmax-files-under-probe-filter-directory.patch
mm-damon-sysfs-support-hugepage_size-probe-filter.patch
docs-mm-damon-design-update-for-hugepage_size-probe-filter.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size.patch
docs-abi-damon-update-for-hugepage_size-probe-filter.patch
mm-damon-api-remove-nr_damos_filter_types.patch
mm-damon-core-use-abs_diff-in-damon_feed_loop_next_input.patch
mm-damon-core-use-mult_frac-in-damon_feed_loop_next_input.patch
mm-damon-core-set-damon_ctx-walk_control_obsolete-in-damon_new_ctx.patch
mm-damon-core-document-damon_call-damon_start-race-hang-issue.patch
mm-damon-paddr-remove-pa-parameter-from-damon_pa_filter_pass.patch
mm-damon-tests-core-kunit-test-eligible_mem_bp-commitment.patch
mm-damon-tests-core-kunit-add-probe_hits_wsum-damos-filter-commit-test.patch
selftests-damon-sysfs_memcg_path_leak-fail-only-for-real-damon-leak.patch
docs-mm-damon-design-clarify-bp-is-basis-point.patch
mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

