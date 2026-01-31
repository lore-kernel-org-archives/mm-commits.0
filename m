Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7ED38A73C
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898333; cv=none; b=DCojWlKFZ+pApuMvzj2Tw0bTGpAQuN/TgqfAyp7u4YadwbsBWWq680z+1x0yAMRtpC7y+qayGlSDPzV6wL3VWRTECl8oTS2SydKmx0rDo/N1IdIwtlJfHiErhYk8pafaK2RB7abv71rbhY844p0f7S792+50Zk9fM6Glsrn9aGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898333; c=relaxed/simple;
	bh=qJ3/YbVT6z6sEE9AJ0vxwe6HsmyEI7uC9oYRM2xDXHs=;
	h=Date:To:From:Subject:Message-Id; b=fUdLfniEcs+J1DUV/2lF07dL1K/iBiC6lAaRea34OAnh/ZB5g1YB+CkUxlqk2bSlKF/SJNgyL3c0bfo044PHamIYIGAmxofP9UjhJ/8bHoKwfoH+LF1TnEjE149knMMOnDoreoiRnkmR+bVksggm0/OYyS+1iMQhRJU7W0QCfUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C8E4NpLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C8E4NpLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2508FC4CEF1;
	Sat, 31 Jan 2026 22:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898333;
	bh=qJ3/YbVT6z6sEE9AJ0vxwe6HsmyEI7uC9oYRM2xDXHs=;
	h=Date:To:From:Subject:From;
	b=C8E4NpLTXSAO8SbiDQcTRqOdOXSXQVxCyR4Eni65E45esIIeEPFuxrRuC3gkxa8Yr
	 39vhhJcrahDW0ICkuENSfNJSS5GpkeHWpwCAEPx+p5e09o1oEi223gUW/uNLIysDgJ
	 od+KsX9STPlO3UvI1t+1Hxfor5LBgGpg3pZkQxlk=
Date: Sat, 31 Jan 2026 14:25:32 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-remove-damon_operations-cleanup.patch removed from -mm tree
Message-Id: <20260131222533.2508FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: remove damon_operations->cleanup()
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-damon_operations-cleanup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: remove damon_operations->cleanup()
Date: Sat, 17 Jan 2026 09:52:48 -0800

Patch series "mm/damon: cleanup kdamond, damon_call(), damos filter and
DAMON_MIN_REGION".

Do miscellaneous code cleanups for improving readability.  First three
patches cleanup kdamond termination process, by removing unused operation
set cleanup callback (patch 1) and moving damon_ctx specific resource
cleanups on kdamond termination to synchronization-easy place (patches 2
and 3).  Next two patches touch damon_call() infrastructure, by
refactoring kdamond_call() function to do less and simpler locking
operations (patch 4), and documenting when dealloc_on_free does work
(patch 5).  Final three patches rename things for clear uses of those. 
Those rename damos_filter_out() to be more explicit about the fact that it
is only for core-handled filters (patch 6), DAMON_MIN_REGION macro to be
more explicit it is not about number of regions but size of each region
(patch 7), and damon_ctx->min_sz_region to be different from
damos_access_patern->min_sz_region (patch 8), so that those are not
confusing and easy to grep.


This patch (of 8):

damon_operations->cleanup() was added for a case that an operation set
implementation requires additional cleanups.  But no such implementation
exists at the moment.  Remove it.

Link: https://lkml.kernel.org/r/20260117175256.82826-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260117175256.82826-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    3 ---
 mm/damon/core.c       |    2 --
 mm/damon/paddr.c      |    1 -
 mm/damon/vaddr.c      |    1 -
 4 files changed, 7 deletions(-)

--- a/include/linux/damon.h~mm-damon-remove-damon_operations-cleanup
+++ a/include/linux/damon.h
@@ -607,7 +607,6 @@ enum damon_ops_id {
  * @apply_scheme:		Apply a DAMON-based operation scheme.
  * @target_valid:		Determine if the target is valid.
  * @cleanup_target:		Clean up each target before deallocation.
- * @cleanup:			Clean up the context.
  *
  * DAMON can be extended for various address spaces and usages.  For this,
  * users should register the low level operations for their target address
@@ -640,7 +639,6 @@ enum damon_ops_id {
  * @target_valid should check whether the target is still valid for the
  * monitoring.
  * @cleanup_target is called before the target will be deallocated.
- * @cleanup is called from @kdamond just before its termination.
  */
 struct damon_operations {
 	enum damon_ops_id id;
@@ -656,7 +654,6 @@ struct damon_operations {
 			struct damos *scheme, unsigned long *sz_filter_passed);
 	bool (*target_valid)(struct damon_target *t);
 	void (*cleanup_target)(struct damon_target *t);
-	void (*cleanup)(struct damon_ctx *context);
 };
 
 /*
--- a/mm/damon/core.c~mm-damon-remove-damon_operations-cleanup
+++ a/mm/damon/core.c
@@ -2859,8 +2859,6 @@ done:
 			damon_destroy_region(r, t);
 	}
 
-	if (ctx->ops.cleanup)
-		ctx->ops.cleanup(ctx);
 	kfree(ctx->regions_score_histogram);
 	kdamond_call(ctx, true);
 
--- a/mm/damon/paddr.c~mm-damon-remove-damon_operations-cleanup
+++ a/mm/damon/paddr.c
@@ -373,7 +373,6 @@ static int __init damon_pa_initcall(void
 		.prepare_access_checks = damon_pa_prepare_access_checks,
 		.check_accesses = damon_pa_check_accesses,
 		.target_valid = NULL,
-		.cleanup = NULL,
 		.apply_scheme = damon_pa_apply_scheme,
 		.get_scheme_score = damon_pa_scheme_score,
 	};
--- a/mm/damon/vaddr.c~mm-damon-remove-damon_operations-cleanup
+++ a/mm/damon/vaddr.c
@@ -1014,7 +1014,6 @@ static int __init damon_va_initcall(void
 		.check_accesses = damon_va_check_accesses,
 		.target_valid = damon_va_target_valid,
 		.cleanup_target = damon_va_cleanup_target,
-		.cleanup = NULL,
 		.apply_scheme = damon_va_apply_scheme,
 		.get_scheme_score = damon_va_scheme_score,
 	};
_

Patches currently in -mm which might be from sj@kernel.org are


