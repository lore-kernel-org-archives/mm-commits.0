Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF931B4223
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896570; cv=none; b=UPWrWPCGgp1cMIjaMQBY3Eio7uIYkXW1k+sX4d8XVNWzuxfofyrIOU730h41Ik9uryKKMzn0ZYqY2EdfV3qDaFIj/3DIpzyhOcmh8oSlwtjKrROPpdtfXHPg74oDgHyT5c0MGRFZumvE0cH/JfXv3JT55PToU0w5Lw7eTC2ku18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896570; c=relaxed/simple;
	bh=bVWl+NPUJyjh/czIXq3two5yijeLaNsPFW1NDnSj210=;
	h=Date:To:From:Subject:Message-Id; b=o5IQQ3Cdb7ThBSAXDabyiqmYnnsiKCNn/qeR6IwxqhxBCmUA+IkkB4I0t5+7hIJea0bHBkOKnvyG3X28phSU/FV1RXCThBG51KAAX8wlJY4fLK6UhbRyImOXT+Nl/vqSAA+yvsi+UjcLxkXmuoPD4OIWvTYCB9s+yqSG8xJz4yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C/eBDwAx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C/eBDwAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03011F000E9;
	Wed,  5 Aug 2026 02:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896568;
	bh=ErzFICooca5VuGnz3ThC72uO27jU2GJcapVSun9NzvI=;
	h=Date:To:From:Subject;
	b=C/eBDwAxbcRosmMuCYxiqCpTnPnFd1UQUYdv8gpTXPcp+WD+cpOJcpEaCGL9P820y
	 c4rkHbjrRtjJBMA1aDxwywOMfJPeG8TbkQZB+C6B+vcMu3QTllNPWKelFxQ6VXHn+Z
	 EFavWtM26g6gCzyJfHnIBITahykpIuOb/IUh0fSk=
Date: Tue, 04 Aug 2026 19:22:48 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-stop-ctxs-in-damon_start-before-returning-an-error.patch removed from -mm tree
Message-Id: <20260805022248.A03011F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: stop ctxs in damon_start() before returning an error
has been removed from the -mm tree.  Its filename was
     mm-damon-core-stop-ctxs-in-damon_start-before-returning-an-error.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: stop ctxs in damon_start() before returning an error
Date: Mon, 6 Jul 2026 07:06:16 -0700

Patch series "mm/damon: refactor damon_{start,stop,commit}() for simple
error handling".

damon_start() and damon_stop() could leave a few of requested DAMON
contexts running when they return an error.  damon_commit() failure stops
the DAMON context, but in an asynchronous way.  Callers should stop the
left-over DAMON contexts.  It is easy to make mistakes, and indeed a few
bugs from such mistakes were found and fixed.

Refactor the core API functions to guarantee contexts are completely
stopped under failures.  Remove the caller side error handlers that are no
longer needed due to the refactoring.

Patches Sequence
================

Patch 1 refactors damon_start() to ensure all contexts are stopped for
failures.  Patch 2 updates unnecessary damon_start() error handling from
mtier sample module.

Patch 3 refactors damon_stop() to always success.  Patches 4-6 updates
callers (damon_{sysfs,reclaim lru_sort}) to ignore the return value.
Patch 7 update damon_stop() return value to void.  Patch 8 simplifies
damon_stop() error handling in mtier sample module.

Patch 9 refactors damon_call() to return errors only after the context
is completely stopped.  Patches 10 and 11 remove unnecessary error
handlings from callers (wsse and prcl sample modules).


This patch (of 11):

When multiple contexts are passed to damon_start(), the function starts
the contexts one by one.  If any of the operations fails, it immediately
returns an error.  Contexts that successfully started before the failure
keep running.  The caller should catch this and stop the contexts.  It is
complicated and easy to make mistakes.  Stop all contexts in damon_start()
under the failures.

Link: https://lore.kernel.org/20260706140628.87414-1-sj@kernel.org
Link: https://lore.kernel.org/20260706140628.87414-2-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-stop-ctxs-in-damon_start-before-returning-an-error
+++ a/mm/damon/core.c
@@ -1917,6 +1917,9 @@ int damon_start(struct damon_ctx **ctxs,
 		running_exclusive_ctxs = true;
 	mutex_unlock(&damon_lock);
 
+	if (i != nr_ctxs)
+		damon_stop(ctxs, i);
+
 	return err;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-adjust-isolated-pages-stat-for-damos_migrate_hotcold.patch
samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch
mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch
mm-damon-reclaim-skip-damon_call-if-ctx-has-not-started.patch
mm-damon-lru_sort-skip-damon_call-if-ctx-has-not-started.patch
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

