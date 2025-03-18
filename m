Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA1A82D91
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274607; cv=none; b=GfudAAYKfKCbDkq/RI+P1izMMdp6Xe7eQZLGUJJsIuOAhg9v3xNwZDdpqcRiw4yBcJeocT9INP+72RfklStyizlYMiWcxRGN4lccJ3OswCbBdhhcHmNLMvi0+F8yIkj13Wb+/qXuLZKVES62hsGYHlTte6xI7hHpNjMASvZw8oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274607; c=relaxed/simple;
	bh=Lramu4aB+MRwk/p6BZv3yb4yyzMgmFOe8a1rrHfLNw8=;
	h=Date:To:From:Subject:Message-Id; b=uw50QWu7jtlXD2FAPCEa6WhZjBy0I2Lngw9DBs+6WnxYTV4/c5iaZ7HtOJKW59WUxZ6qBlRCiYbppyGTTDp+gLnqkSYXwV93qFA9n9TPNl+HJZptsdIj4cf67oP04fK6gRYOJGHVw0fQ24HNCnli8KGLACPF/RJhBL5IXmw4ixM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dTr4h9M2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dTr4h9M2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E28C4CEDD;
	Tue, 18 Mar 2025 05:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274606;
	bh=Lramu4aB+MRwk/p6BZv3yb4yyzMgmFOe8a1rrHfLNw8=;
	h=Date:To:From:Subject:From;
	b=dTr4h9M2km9AUo48MgVsis/fryBcXxkPdces/1wJsYmPVa+Mj/cPS6eKGOWG37SOW
	 xk2TS5aZhnHrsXHJs1FXRFXt2NfQ50yNYwmx+jZW7DguG6ug7QeyF0rtlMGeFmpcr3
	 3E/t0w0S7uwPtR0qlTXx5iAHxUjWBiyyTM413miQ=
Date: Mon, 17 Mar 2025 22:10:06 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-remove-damon_operations-reset_aggregated.patch removed from -mm tree
Message-Id: <20250318051006.D3E28C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: remove damon_operations->reset_aggregated
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-damon_operations-reset_aggregated.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: remove damon_operations->reset_aggregated
Date: Thu, 6 Mar 2025 09:59:08 -0800

The operations layer hook was introduced to let operations set do any
aggregation data reset if needed.  But it is not really be used now. 
Remove it.

Link: https://lkml.kernel.org/r/20250306175908.66300-14-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    7 +------
 mm/damon/core.c       |    2 --
 mm/damon/paddr.c      |    1 -
 mm/damon/vaddr.c      |    1 -
 4 files changed, 1 insertion(+), 10 deletions(-)

--- a/include/linux/damon.h~mm-damon-remove-damon_operations-reset_aggregated
+++ a/include/linux/damon.h
@@ -542,7 +542,6 @@ enum damon_ops_id {
  * @update:			Update operations-related data structures.
  * @prepare_access_checks:	Prepare next access check of target regions.
  * @check_accesses:		Check the accesses to target regions.
- * @reset_aggregated:		Reset aggregated accesses monitoring results.
  * @get_scheme_score:		Get the score of a region for a scheme.
  * @apply_scheme:		Apply a DAMON-based operation scheme.
  * @target_valid:		Determine if the target is valid.
@@ -554,8 +553,7 @@ enum damon_ops_id {
  * (&damon_ctx.kdamond) calls @init and @prepare_access_checks before starting
  * the monitoring, @update after each &damon_attrs.ops_update_interval, and
  * @check_accesses, @target_valid and @prepare_access_checks after each
- * &damon_attrs.sample_interval.  Finally, @reset_aggregated is called after
- * each &damon_attrs.aggr_interval.
+ * &damon_attrs.sample_interval.
  *
  * Each &struct damon_operations instance having valid @id can be registered
  * via damon_register_ops() and selected by damon_select_ops() later.
@@ -570,8 +568,6 @@ enum damon_ops_id {
  * last preparation and update the number of observed accesses of each region.
  * It should also return max number of observed accesses that made as a result
  * of its update.  The value will be used for regions adjustment threshold.
- * @reset_aggregated should reset the access monitoring results that aggregated
- * by @check_accesses.
  * @get_scheme_score should return the priority score of a region for a scheme
  * as an integer in [0, &DAMOS_MAX_SCORE].
  * @apply_scheme is called from @kdamond when a region for user provided
@@ -589,7 +585,6 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
-	void (*reset_aggregated)(struct damon_ctx *context);
 	int (*get_scheme_score)(struct damon_ctx *context,
 			struct damon_target *t, struct damon_region *r,
 			struct damos *scheme);
--- a/mm/damon/core.c~mm-damon-remove-damon_operations-reset_aggregated
+++ a/mm/damon/core.c
@@ -2490,8 +2490,6 @@ static int kdamond_fn(void *data)
 
 			kdamond_reset_aggregated(ctx);
 			kdamond_split_regions(ctx);
-			if (ctx->ops.reset_aggregated)
-				ctx->ops.reset_aggregated(ctx);
 		}
 
 		if (ctx->passed_sample_intervals >= next_ops_update_sis) {
--- a/mm/damon/paddr.c~mm-damon-remove-damon_operations-reset_aggregated
+++ a/mm/damon/paddr.c
@@ -621,7 +621,6 @@ static int __init damon_pa_initcall(void
 		.update = NULL,
 		.prepare_access_checks = damon_pa_prepare_access_checks,
 		.check_accesses = damon_pa_check_accesses,
-		.reset_aggregated = NULL,
 		.target_valid = NULL,
 		.cleanup = NULL,
 		.apply_scheme = damon_pa_apply_scheme,
--- a/mm/damon/vaddr.c~mm-damon-remove-damon_operations-reset_aggregated
+++ a/mm/damon/vaddr.c
@@ -710,7 +710,6 @@ static int __init damon_va_initcall(void
 		.update = damon_va_update,
 		.prepare_access_checks = damon_va_prepare_access_checks,
 		.check_accesses = damon_va_check_accesses,
-		.reset_aggregated = NULL,
 		.target_valid = damon_va_target_valid,
 		.cleanup = NULL,
 		.apply_scheme = damon_va_apply_scheme,
_

Patches currently in -mm which might be from sj@kernel.org are


