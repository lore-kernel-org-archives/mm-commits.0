Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D5D331209
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465730; cv=none; b=OCmu1z1Hi6ccw56eZkuyX9TP0o4K6SYswdLk8SchoHJqt1lvHy0LlGPx1HA1/56BuLwy4qP6nATHaxUCpcY3nNVNDrUqucDh6Wr4XYsmZ0Yu9BN0+C0ZDSuOdALow+GbbQIWSu38NOYCpV3DbVO6VeRW3B20+G942nqYYC3sPs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465730; c=relaxed/simple;
	bh=rGN7VmKjzbVrv6XWeqPJUX8IPxsyB8/6re/Q8tAa6fs=;
	h=Date:To:From:Subject:Message-Id; b=l/Xlg26CY7mvXGJTg9KgMIrsXlbeV/2LC88pBiEegqPdkhXuSZIx8Jk9p2lwM9BwW3C7FF4UdtzzfhZz5DyuhwMohGdxpmk9Ke4F1n4kt5krL392+VcZc2kNoX0Y59alrKQNonIUfyxkgKhfFSEzNQggQiCZSLQ7D3+Vadclshw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r1l+0Dle; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r1l+0Dle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3E91F000E9;
	Fri, 31 Jul 2026 02:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465729;
	bh=k/abNN+f4jAozDHbYTMecGQkLqT5SeZHkFShNWpZsxE=;
	h=Date:To:From:Subject;
	b=r1l+0DleU6EOV1c9dTn61SD5M8nlO/V9LeY0lI7Ll4yy2RU++g/5fKfUGz/J90cTT
	 ZRxU4Vmf1Y+RNaCuxEmjGLyOcTx/NsGlzOVbD6qDAoCy+MP8puie7og0JQJFUPDqSc
	 fUmimmdql/6Fq2yU51HT9K/PKblt+I6a7dCAwXFk=
Date: Thu, 30 Jul 2026 19:42:08 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-reduce-range-setup-in-damon_commit_target_regions.patch removed from -mm tree
Message-Id: <20260731024209.3B3E91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: reduce range setup in damon_commit_target_regions()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-reduce-range-setup-in-damon_commit_target_regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: reduce range setup in damon_commit_target_regions()
Date: Tue, 30 Jun 2026 07:17:22 -0700

damon_commit_target_regions() calls damon_set_regions() for updating the
destination target's monitoring target region boundaries.  It sets the
boundaries same to source target's monitoring regions, even if they are
adjacent.  Meanwhile, damon_set_region() sets the destination target
regions exactly the same to the source, only when the target regions are
empty.  When there are existing target regions, only a few regions are
expanded or shrunk to fit on only the boundaries for disjoint regions in
the source.  Hence the adjacent source ranges mean nothing in common
cases.  When there are many regions, such adjacent range setup is only a
waste of time and space.  We recently found [1] it is actually causing
memory overhead.  Setup the ranges for only distinct ranges.

Link: https://lore.kernel.org/20260630141726.92246-9-sj@kernel.org
Link: https://lore.kernel.org/20260603112306.58490-1-akinobu.mita@gmail.com [1]
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-reduce-range-setup-in-damon_commit_target_regions
+++ a/mm/damon/core.c
@@ -1360,21 +1360,33 @@ static struct damon_target *damon_nth_ta
 static int damon_commit_target_regions(struct damon_target *dst,
 		struct damon_target *src, unsigned long src_min_region_sz)
 {
-	struct damon_region *src_region;
+	struct damon_region *src_region, *prev = NULL;
 	struct damon_addr_range *ranges;
 	int i = 0, err;
 
-	damon_for_each_region(src_region, src)
-		i++;
+	damon_for_each_region(src_region, src) {
+		if (!prev || prev->ar.end != src_region->ar.start)
+			i++;
+		prev = src_region;
+	}
 	if (!i)
 		return 0;
 
 	ranges = kvmalloc_objs(*ranges, i, GFP_KERNEL | __GFP_NOWARN);
 	if (!ranges)
 		return -ENOMEM;
+	prev = NULL;
 	i = 0;
-	damon_for_each_region(src_region, src)
-		ranges[i++] = src_region->ar;
+	damon_for_each_region(src_region, src) {
+		if (!prev) {
+			ranges[i].start = src_region->ar.start;
+		} else if (prev->ar.end != src_region->ar.start) {
+			ranges[i++].end = prev->ar.end;
+			ranges[i].start = src_region->ar.start;
+		}
+		prev = src_region;
+	}
+	ranges[i++].end = damon_last_region(src)->ar.end;
 	err = damon_set_regions(dst, ranges, i, src_min_region_sz);
 	kvfree(ranges);
 	return err;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-adjust-isolated-pages-stat-for-damos_migrate_hotcold.patch
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
mm-damon-core-remove-comment-and-test-for-nr_to_bp-divide-by-zero.patch
mm-damon-core-s-damon_max_nr_accesses-damon_nr_samples_per_aggr.patch
mm-damon-core-s-accesses_bp_to_nr_accesses-sample_bp_to_count.patch
mm-damon-core-s-nr_accesses_to_accesses_bp-sample_count_to_bp.patch
mm-damon-core-s-nr_accesses_for_new_attrs-nr_samples_for_new_attrs.patch
mm-damon-core-update-probe-hits-for-new-parameter-commit.patch
mm-damon-core-handle-unreset-probe_hits-in-probe_hits_mvsum.patch
mm-damon-core-introduce-damon_probe-weight.patch
mm-damon-core-ask-apply_probes-ops-callback-to-set-sampling-address.patch
mm-damon-paddr-set-samples-in-apply_probes-if-requested.patch
mm-damon-core-ask-apply_probe-to-return-max-probe-hits-weighted-sum.patch
mm-damon-core-implement-damon_probe_hits_wsum.patch
mm-damon-paddr-respect-return_max_wsum.patch
mm-damon-core-use-abs_diff-instead-of-abs.patch
mm-damon-core-extend-merge-function-to-work-with-probe-hits.patch
mm-damon-core-disallow-probe_hits-overflow-on-attrs-only-monitoring.patch
mm-damon-core-validate-params-for-probe-hits-weighted-sum-overflow.patch
mm-damon-core-disable-access-monitoring-when-probe-weights-are-set.patch
mm-damon-core-set-samples-in-apply_probes-if-probe-weights-are-set.patch
mm-damon-core-s-max_nr_accesses-max_merge_score-in-kdamond_fn.patch
mm-damon-core-get-merge-threshold-from-probe-hits-when-weights-are-set.patch
mm-damon-core-implement-damon_has_probe_weight.patch
mm-damon-sysfs-implement-probe-weight-file.patch
docs-mm-damon-design-document-attrs-only-monitoring.patch
docs-admin-guide-mm-damon-usage-document-weight-sysfs-file.patch
docs-abi-damon-document-probe-weight-file.patch
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

