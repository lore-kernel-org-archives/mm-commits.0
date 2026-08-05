Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4B03BF66B
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896675; cv=none; b=JvzSuPcurWPu74pIEU4rpUbnGohZ+dWz0k+J+bbvwFmOGteDAnk6Axv6aRPT8zVFgVkQgwxuMBhbukh3loTYJHOPmxzcRtWUWC9QLiheGcKpZaeQRwMiZ+t/mdH/JlgEtMMQWhgGS33/FrmHUh3Z/R75Ld7M+DF01p09wo1bDP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896675; c=relaxed/simple;
	bh=FboW8VuV2jEnjDRmthxPrkFarzX8mDWOzy7tm8mwY+s=;
	h=Date:To:From:Subject:Message-Id; b=f9Bi67RZV1nYFILfT1/7Fijsk86HHlP0IgGfnAnQL6pPT1SyFAfOeYj3PqD7JNYyLLEtUPQWs5fC1pSLo6eKsjYn+GdlJqNwRaGin5xwxIFTbSFV20niA5MuUxZavAE2b+BgUopRhJBHJlgejju209wBKo/NOMVFTw3OvH8LFx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=enVuh+xs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="enVuh+xs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6D41F00A3D;
	Wed,  5 Aug 2026 02:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896671;
	bh=Bt1xD7R8QBic1CcYHXq6RkeFPqhrDzqhijinrauSybY=;
	h=Date:To:From:Subject;
	b=enVuh+xsiQyfacIyVd2TB2sTUpV+Ua5sIrmLVbN/UTxAK8w1m9qYJVJkjjjJR/Yz1
	 KGYyzrlxn9ms8Ws0Cj6qeDhlTe8QeMMbebmH3CHZmzJ21pc5EiKpzgLDdQK1lV2ZfZ
	 ATuL/ptJFrW7yxNyfY63dXtazghVJ3yWySXrrZH8=
Date: Tue, 04 Aug 2026 19:24:30 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-s-nr_accesses_for_new_attrs-nr_samples_for_new_attrs.patch removed from -mm tree
Message-Id: <20260805022431.7B6D41F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: s/nr_accesses_for_new_attrs/nr_samples_for_new_attrs/
has been removed from the -mm tree.  Its filename was
     mm-damon-core-s-nr_accesses_for_new_attrs-nr_samples_for_new_attrs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: s/nr_accesses_for_new_attrs/nr_samples_for_new_attrs/
Date: Wed, 8 Jul 2026 06:53:55 -0700

damon_nr_accesses_for_new_attrs() can be used for not only nr_accesses but
also any positive sample count, like probe_hits.  Rename to be able to be
used for such general uses without confusion.

Link: https://lore.kernel.org/20260708135359.122587-6-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-s-nr_accesses_for_new_attrs-nr_samples_for_new_attrs
+++ a/mm/damon/core.c
@@ -890,22 +890,21 @@ static unsigned int damon_sample_count_t
 	return mult_frac(count, 10000, damon_nr_samples_per_aggr(attrs));
 }
 
-static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
+static unsigned int damon_nr_samples_for_new_attrs(unsigned int nr,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
 	return damon_sample_bp_to_count(
-			damon_sample_count_to_bp(nr_accesses, old_attrs),
-			new_attrs);
+			damon_sample_count_to_bp(nr, old_attrs), new_attrs);
 }
 
 static void damon_update_monitoring_result(struct damon_region *r,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs,
 		bool aggregating)
 {
-	r->last_nr_accesses = damon_nr_accesses_for_new_attrs(
+	r->last_nr_accesses = damon_nr_samples_for_new_attrs(
 			r->last_nr_accesses, old_attrs, new_attrs);
 	if (!aggregating)
-		r->nr_accesses = damon_nr_accesses_for_new_attrs(
+		r->nr_accesses = damon_nr_samples_for_new_attrs(
 				r->nr_accesses, old_attrs, new_attrs);
 	else
 		/*
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

