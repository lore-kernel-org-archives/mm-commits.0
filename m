Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F1B1C3C11
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837160; cv=none; b=Wxz8aE5yc8uTLAJ4S+biu7SUfSj+lp7btVEvabjodFRDANXZnrXLhUbu0MrGQLbW2oNyGiOQDxQ6mMNrthLCb0VsGNauOhW6ZBudRjYCDLqzo76kaF/eeoL0XcquJQbUzdbHjgIP2yn1d20LBkXeWoGWH34GD+Z7KMwb+xDwtvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837160; c=relaxed/simple;
	bh=UN9zxPNf4LIWGd67g0k8aVaEnDTivumvNS5FvloJy1U=;
	h=Date:To:From:Subject:Message-Id; b=Jq6qGQFAsa+N2LvBBZopS6NVYfLmf1lZAOIJ9LxOSMMpV5UaEgIPegoVHlNoM/yzo72JVhEYiAE4NFtGY2BypEGJt5dancrAwS0c9+3L51JM7axP12vkaDUs4YUH26TY4VbKYVCxh2bvyL5byKUeZ0/tHk18VcG5FdA1NT9eMS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XFtQtnCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XFtQtnCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11160C4CEDD;
	Tue, 14 Jan 2025 06:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837160;
	bh=UN9zxPNf4LIWGd67g0k8aVaEnDTivumvNS5FvloJy1U=;
	h=Date:To:From:Subject:From;
	b=XFtQtnCuEMJzsYX2Z2Jne+23qN2nCKL5Gh4OrZA3xZ++EgtrYok129pNxvdk5AegQ
	 PtAFaWZn5B39+p04Os4vNbry1fWpTTeZJkrUGpfHwMQBxwnmdUaK6UCVl8QMK+FueS
	 UJqwcdlSnq4N8APbAsAF1s72x00+WYO5ihCGiFa8=
Date: Mon, 13 Jan 2025 22:45:59 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes.patch removed from -mm tree
Message-Id: <20250114064600.11160C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: ask apply_scheme() to report filter-passed region-internal bytes
has been removed from the -mm tree.  Its filename was
     mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: ask apply_scheme() to report filter-passed region-internal bytes
Date: Mon, 6 Jan 2025 11:33:49 -0800

Some DAMOS filter types including those for young page, anon page, and
belonging memcg are handled by underlying DAMON operations set
implementation, via damon_operations->apply_scheme() interface.  How many
bytes of the region have passed the filter can be useful for DAMOS scheme
tuning and access pattern monitoring.  Modify the interface to let the
callback implementation reports back the number if possible.

Link: https://lkml.kernel.org/r/20250106193401.109161-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    5 +++--
 mm/damon/core.c       |    4 +++-
 mm/damon/paddr.c      |    2 +-
 mm/damon/vaddr.c      |    2 +-
 4 files changed, 8 insertions(+), 5 deletions(-)

--- a/include/linux/damon.h~mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes
+++ a/include/linux/damon.h
@@ -529,7 +529,8 @@ enum damon_ops_id {
  * @apply_scheme is called from @kdamond when a region for user provided
  * DAMON-based operation scheme is found.  It should apply the scheme's action
  * to the region and return bytes of the region that the action is successfully
- * applied.
+ * applied.  It should also report how many bytes of the region has passed
+ * filters (&struct damos_filter) that handled by itself.
  * @target_valid should check whether the target is still valid for the
  * monitoring.
  * @cleanup is called from @kdamond just before its termination.
@@ -546,7 +547,7 @@ struct damon_operations {
 			struct damos *scheme);
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
 			struct damon_target *t, struct damon_region *r,
-			struct damos *scheme);
+			struct damos *scheme, unsigned long *sz_filter_passed);
 	bool (*target_valid)(struct damon_target *t);
 	void (*cleanup)(struct damon_ctx *context);
 };
--- a/mm/damon/core.c~mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes
+++ a/mm/damon/core.c
@@ -1523,6 +1523,7 @@ static void damos_apply_scheme(struct da
 	unsigned long sz = damon_sz_region(r);
 	struct timespec64 begin, end;
 	unsigned long sz_applied = 0;
+	unsigned long sz_ops_filter_passed = 0;
 	int err = 0;
 	/*
 	 * We plan to support multiple context per kdamond, as DAMON sysfs
@@ -1568,7 +1569,8 @@ static void damos_apply_scheme(struct da
 		if (!err) {
 			trace_damos_before_apply(cidx, sidx, tidx, r,
 					damon_nr_regions(t), do_trace);
-			sz_applied = c->ops.apply_scheme(c, t, r, s);
+			sz_applied = c->ops.apply_scheme(c, t, r, s,
+					&sz_ops_filter_passed);
 		}
 		damos_walk_call_walk(c, t, r, s);
 		ktime_get_coarse_ts64(&end);
--- a/mm/damon/paddr.c~mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes
+++ a/mm/damon/paddr.c
@@ -477,7 +477,7 @@ put_folio:
 
 static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
-		struct damos *scheme)
+		struct damos *scheme, unsigned long *sz_filter_passed)
 {
 	switch (scheme->action) {
 	case DAMOS_PAGEOUT:
--- a/mm/damon/vaddr.c~mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes
+++ a/mm/damon/vaddr.c
@@ -655,7 +655,7 @@ static unsigned long damos_madvise(struc
 
 static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
-		struct damos *scheme)
+		struct damos *scheme, unsigned long *sz_filter_passed)
 {
 	int madv_action;
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

