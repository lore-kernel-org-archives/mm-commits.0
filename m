Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1ECA38A9AE
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898340; cv=none; b=PyGCmoHoMjw5FTBApOqUGb6HvJhYmTmoLuX18Zle3nJw5ro4zXd55mZ1J8PDP8OHT5jJMTrm2nARfgBNbnIaaBGrw1sOoDHwrszOnSk1M/7IG8Y6RBPQTf+tzp5kco+egnIq/K6hSdAITnAU6akz3RSIzW3dhWP/gnO2VyRJxvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898340; c=relaxed/simple;
	bh=eax2J9kf4/iF2dDnGJacGrUDKiaWduP9xwkaOipbW+o=;
	h=Date:To:From:Subject:Message-Id; b=caynKgi5ANgfHKqtLxqJ4iInIjcbBBBTh3zMx/7gAPcH5Y6u+6F3DdA5IvMEbKqDb+A4+SR94lAKSGrBCStnhzBhEbsfbJf1ucG7hsrXMb2PJpbxrBwoG5/nPMjcne/E7gamasJPkd6x64RANwdtbwxF/g/X/7YV4Ag4AG6BAoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mse0gPP8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mse0gPP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1ED2C2BC86;
	Sat, 31 Jan 2026 22:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898339;
	bh=eax2J9kf4/iF2dDnGJacGrUDKiaWduP9xwkaOipbW+o=;
	h=Date:To:From:Subject:From;
	b=Mse0gPP8ZFTHCNw31pKDu9ZKsHtq298G3U7orct2SaxI184qxqL9o2jUc5tOZbU5u
	 tnrsQ7FbBpfs2+gg5RSu02C0EPV2Ie+cqDYkjPmFSEDQzmtVWGstK6zNkvE1N4FPgl
	 /KfXF7tjY5hkuDwBetop7sHQjUe8LEBN0HSV5VcI=
Date: Sat, 31 Jan 2026 14:25:39 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-rename-damon_min_region-to-damon_min_region_sz.patch removed from -mm tree
Message-Id: <20260131222539.C1ED2C2BC86@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: rename DAMON_MIN_REGION to DAMON_MIN_REGION_SZ
has been removed from the -mm tree.  Its filename was
     mm-damon-rename-damon_min_region-to-damon_min_region_sz.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: rename DAMON_MIN_REGION to DAMON_MIN_REGION_SZ
Date: Sat, 17 Jan 2026 09:52:54 -0800

The macro is for the default minimum size of each DAMON region.  There was
a case that a reader was confused if it is the minimum number of total
DAMON regions, which is set on damon_attrs->min_nr_regions.  Make the name
more explicit.

Link: https://lkml.kernel.org/r/20260117175256.82826-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h        |    2 +-
 mm/damon/core.c              |    2 +-
 mm/damon/lru_sort.c          |    2 +-
 mm/damon/reclaim.c           |    2 +-
 mm/damon/sysfs.c             |    2 +-
 mm/damon/tests/vaddr-kunit.h |    2 +-
 mm/damon/vaddr.c             |   24 ++++++++++++------------
 7 files changed, 18 insertions(+), 18 deletions(-)

--- a/include/linux/damon.h~mm-damon-rename-damon_min_region-to-damon_min_region_sz
+++ a/include/linux/damon.h
@@ -15,7 +15,7 @@
 #include <linux/random.h>
 
 /* Minimal region size.  Every damon_region is aligned by this. */
-#define DAMON_MIN_REGION	PAGE_SIZE
+#define DAMON_MIN_REGION_SZ	PAGE_SIZE
 /* Max priority score for DAMON-based operation schemes */
 #define DAMOS_MAX_SCORE		(99)
 
--- a/mm/damon/core.c~mm-damon-rename-damon_min_region-to-damon_min_region_sz
+++ a/mm/damon/core.c
@@ -553,7 +553,7 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.max_nr_regions = 1000;
 
 	ctx->addr_unit = 1;
-	ctx->min_sz_region = DAMON_MIN_REGION;
+	ctx->min_sz_region = DAMON_MIN_REGION_SZ;
 
 	INIT_LIST_HEAD(&ctx->adaptive_targets);
 	INIT_LIST_HEAD(&ctx->schemes);
--- a/mm/damon/lru_sort.c~mm-damon-rename-damon_min_region-to-damon_min_region_sz
+++ a/mm/damon/lru_sort.c
@@ -298,7 +298,7 @@ static int damon_lru_sort_apply_paramete
 	if (!monitor_region_start && !monitor_region_end)
 		addr_unit = 1;
 	param_ctx->addr_unit = addr_unit;
-	param_ctx->min_sz_region = max(DAMON_MIN_REGION / addr_unit, 1);
+	param_ctx->min_sz_region = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
 	if (!damon_lru_sort_mon_attrs.sample_interval) {
 		err = -EINVAL;
--- a/mm/damon/reclaim.c~mm-damon-rename-damon_min_region-to-damon_min_region_sz
+++ a/mm/damon/reclaim.c
@@ -208,7 +208,7 @@ static int damon_reclaim_apply_parameter
 	if (!monitor_region_start && !monitor_region_end)
 		addr_unit = 1;
 	param_ctx->addr_unit = addr_unit;
-	param_ctx->min_sz_region = max(DAMON_MIN_REGION / addr_unit, 1);
+	param_ctx->min_sz_region = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
 	if (!damon_reclaim_mon_attrs.aggr_interval) {
 		err = -EINVAL;
--- a/mm/damon/sysfs.c~mm-damon-rename-damon_min_region-to-damon_min_region_sz
+++ a/mm/damon/sysfs.c
@@ -1470,7 +1470,7 @@ static int damon_sysfs_apply_inputs(stru
 	/* addr_unit is respected by only DAMON_OPS_PADDR */
 	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
 		ctx->min_sz_region = max(
-				DAMON_MIN_REGION / sys_ctx->addr_unit, 1);
+				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
 		return err;
--- a/mm/damon/tests/vaddr-kunit.h~mm-damon-rename-damon_min_region-to-damon_min_region_sz
+++ a/mm/damon/tests/vaddr-kunit.h
@@ -147,7 +147,7 @@ static void damon_do_test_apply_three_re
 		damon_add_region(r, t);
 	}
 
-	damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION);
+	damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION_SZ);
 
 	for (i = 0; i < nr_expected / 2; i++) {
 		r = __nth_region_of(t, i);
--- a/mm/damon/vaddr.c~mm-damon-rename-damon_min_region-to-damon_min_region_sz
+++ a/mm/damon/vaddr.c
@@ -19,8 +19,8 @@
 #include "ops-common.h"
 
 #ifdef CONFIG_DAMON_VADDR_KUNIT_TEST
-#undef DAMON_MIN_REGION
-#define DAMON_MIN_REGION 1
+#undef DAMON_MIN_REGION_SZ
+#define DAMON_MIN_REGION_SZ 1
 #endif
 
 /*
@@ -78,7 +78,7 @@ static int damon_va_evenly_split_region(
 
 	orig_end = r->ar.end;
 	sz_orig = damon_sz_region(r);
-	sz_piece = ALIGN_DOWN(sz_orig / nr_pieces, DAMON_MIN_REGION);
+	sz_piece = ALIGN_DOWN(sz_orig / nr_pieces, DAMON_MIN_REGION_SZ);
 
 	if (!sz_piece)
 		return -EINVAL;
@@ -161,12 +161,12 @@ next:
 		swap(first_gap, second_gap);
 
 	/* Store the result */
-	regions[0].start = ALIGN(start, DAMON_MIN_REGION);
-	regions[0].end = ALIGN(first_gap.start, DAMON_MIN_REGION);
-	regions[1].start = ALIGN(first_gap.end, DAMON_MIN_REGION);
-	regions[1].end = ALIGN(second_gap.start, DAMON_MIN_REGION);
-	regions[2].start = ALIGN(second_gap.end, DAMON_MIN_REGION);
-	regions[2].end = ALIGN(prev->vm_end, DAMON_MIN_REGION);
+	regions[0].start = ALIGN(start, DAMON_MIN_REGION_SZ);
+	regions[0].end = ALIGN(first_gap.start, DAMON_MIN_REGION_SZ);
+	regions[1].start = ALIGN(first_gap.end, DAMON_MIN_REGION_SZ);
+	regions[1].end = ALIGN(second_gap.start, DAMON_MIN_REGION_SZ);
+	regions[2].start = ALIGN(second_gap.end, DAMON_MIN_REGION_SZ);
+	regions[2].end = ALIGN(prev->vm_end, DAMON_MIN_REGION_SZ);
 
 	return 0;
 }
@@ -259,8 +259,8 @@ static void __damon_va_init_regions(stru
 		sz += regions[i].end - regions[i].start;
 	if (ctx->attrs.min_nr_regions)
 		sz /= ctx->attrs.min_nr_regions;
-	if (sz < DAMON_MIN_REGION)
-		sz = DAMON_MIN_REGION;
+	if (sz < DAMON_MIN_REGION_SZ)
+		sz = DAMON_MIN_REGION_SZ;
 
 	/* Set the initial three regions of the target */
 	for (i = 0; i < 3; i++) {
@@ -299,7 +299,7 @@ static void damon_va_update(struct damon
 	damon_for_each_target(t, ctx) {
 		if (damon_va_three_regions(t, three_regions))
 			continue;
-		damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION);
+		damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION_SZ);
 	}
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are


