Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4528E33936C
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465793; cv=none; b=q60k7sCmre3KjdtuxgvAkkqSurX9FDCS0p3vwReSZcdpegO4SLOVcXRkZuGJ3yaHvWdIfyriNcv0sqskstm5oMJGmgXcMQb7/35pFxCK+RdBUmYKahJ+uTJ9n42oCxX+xyONmw1+rk3sqBnZvXtP6uQL/X7B0AqV3qbO+RJ7GVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465793; c=relaxed/simple;
	bh=UCyozkFFBBqM6HorYPa7taN/ZZuJSgK9Z1/4b9n2Qkg=;
	h=Date:To:From:Subject:Message-Id; b=U4NBrlrP6pTGfI5RVz4YsvwRlproFdHz45o6Bbjn3cAihEs6PpkW1uUH90AfSSjLXCfVrn37Ll9khNAgcB+cLtMt3wq+7nJmtz/bOUg7Hhgbo/99LzW8Iyi85CV1pzjMFgSk3A+2DOd3EzathMUjtEnvGwNg9IqCZ8/SSPd/xlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cm++F6ej; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cm++F6ej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C721F00A3A;
	Fri, 31 Jul 2026 02:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465792;
	bh=AAMu8a478Wx0/P5LxAhL/EYwuzJ1sHC/3sCzsk4Hi3I=;
	h=Date:To:From:Subject;
	b=cm++F6ejWcUlk3VUpPUH6c+H2J4/aMSiMSzjqu+Z8Fz8/uQZR8XDUolWIJj9/6EPI
	 1rDpgz54HvN0FkXmOV22JBmpJo6fx1ZhD8noWFIOZQCPpiasGv6Dl211vIY0v8qhU1
	 6xhRE/HnuyGy3dYz5+yOz1PHfKQqckpGsVvay01g=
Date: Thu, 30 Jul 2026 19:43:11 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-add-damon_region-last_probe_hits.patch removed from -mm tree
Message-Id: <20260731024312.17C721F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: add damon_region->last_probe_hits
has been removed from the -mm tree.  Its filename was
     mm-damon-add-damon_region-last_probe_hits.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon: add damon_region->last_probe_hits
Date: Fri, 3 Jul 2026 10:06:01 -0700

Patch series "mm/damon: provide pseudo moving sum probe_hits".

Data attribute counters (probe_hits) of DAMON are managed in the classical
way.  The counter value is accumulated every sampling interval, gets the
complete view at the end of the aggregation interval, and is reset when
the next aggregation interval starts.  Hence, the complete view can be
retrieved only once per aggregation interval, which can be quite long. 
With the suggested intervals autotuning setup, it becomes 2-4 seconds in
common real production systems.  It can span up to 200 seconds in theory. 
This will restrict online monitoring use case of DAMON.

Actually DAMON is already providing online monitoring of probe_hits. 
DAMON sysfs interface exposes the values via schemes tried regions
directory files.  However, due to the above mentioned limitation, it
usually shows only partially accumulated hit counters and therefore not
useful.

DAMOS is not using probe_hits at the moment.  In the future, using it can
further strengthen DAMOS.  However, a recommended setup of DAMOS is
utilizing sampling/aggregation intervals auto-tuning, and having its own
DAMOS apply_interval (1 second is mostly recommended).  In the setup,
DAMOS will nearly always show incompletely accumulated probe_hits, which
will not really be useful.

Data frequency counter (nr_accesses) of DAMON solves this problem using
the pseudo moving sum value.  The infrastructure is not limited to
nr_accesses but general sampling based counters.  Maintain and provide the
pseudo moving sum of probe_hits similar to nr_accesses, using the
infrastructure.

Tests
=====

On an idle system, I ran DAMON with an attribute probe filter for
non-anonymous page, using DAMON user-space tool, damo [1], like below.

    $ sudo ./damo start --probe_filter allow non anon

Because the system is idle, nearly all memory is not an anonymous page but
a free page, so the probe_hits are expected to be nearly always full.  In
this setup, since the sampling interval is 5ms and the aggregation
interval is 100ms, the counter value is expected to always be near 20.

On kernels not having this series, if we retrieve the probe hits in an
arbitrary time that is likely not aligned to the aggregation interval, the
values are usually much lower than the expectation like below.  This is
because the tool is showing the incompletely aggregated values.

    $ sudo ./damo report access --format append region "probe_hits: <probe hits>"
    heatmap: 00000000000000000000000000000000000000008999999711111111000000000000000000000000
    # min/max temperatures: -1,630,000,000, 0, column size: 99.800 MiB
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    0   addr 4.000 KiB    size 3.898 GiB   access 0 hz   age 16.300 s     probe_hits: 11
    1   addr 3.898 GiB    size 77.859 MiB  access 0 hz   age 1.500 s      probe_hits: 11
    2   addr 3.974 GiB    size 700.770 MiB access 0 hz   age 0 ns         probe_hits: 11
    3   addr 4.659 GiB    size 791.078 MiB access 0 hz   age 13.700 s     probe_hits: 11
    4   addr 5.431 GiB    size 1.472 GiB   access 0 hz   age 15.800 s     probe_hits: 11
    5   addr 6.903 GiB    size 915.059 MiB access 0 hz   age 15.300 s     probe_hits: 11
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

After applying this series, I was able to reliably show the expected
results like below.

    $ sudo ./damo report access --format append region "probe_hits: <probe hits>"
    heatmap: 00000000333333330000000166666665111111139999999855555555333333333333333444444444
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    0   addr 4.000 KiB    size 790.496 MiB access 0 hz   age 1 m 33.300 s probe_hits: 20
    1   addr 790.500 MiB  size 791.160 MiB access 0 hz   age 1 m 15.400 s probe_hits: 19
    2   addr 1.545 GiB    size 792.316 MiB access 0 hz   age 1 m 32.400 s probe_hits: 19
    3   addr 2.318 GiB    size 795.465 MiB access 0 hz   age 1 m 2.600 s  probe_hits: 19
    4   addr 3.095 GiB    size 797.102 MiB access 0 hz   age 1 m 23.500 s probe_hits: 20
    5   addr 3.874 GiB    size 797.293 MiB access 0 hz   age 47.900 s     probe_hits: 20
    6   addr 4.652 GiB    size 787.516 MiB access 0 hz   age 1 m 3.800 s  probe_hits: 20
    7   addr 5.421 GiB    size 784.461 MiB access 0 hz   age 1 m 14.400 s probe_hits: 19
    8   addr 6.187 GiB    size 795.621 MiB access 0 hz   age 1 m 15.700 s probe_hits: 20
    9   addr 6.964 GiB    size 798.000 MiB access 0 hz   age 1 m 10.200 s probe_hits: 20
    10  addr 7.744 GiB    size 54.566 MiB  access 0 hz   age 1 m 9.300 s  probe_hits: 20
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

FYI, 'damo report access' output format has changed on v3.3.0.  Above
outputs can be reproduced on <3.3.0 versions of damo.

Patches Sequence
================

Patch 1 adds probe_hits counters for values that fully accumulated in the
last aggregation interval.  This is required for using the moving sum
infrastructure.  Patch 2 introduces a function for getting the moving sum
values on demand, using the infrastructure.  Finally, patch 3 updates the
DAMON sysfs interface to expose the moving sum values to the schemes tried
regions directory.


This patch (of 3):

Add new damon_region filed, last_probe_hits.  Maintain fully accumulated
probe_hits values from the last aggregation interval in the field.

Link: https://lore.kernel.org/20260703170605.94472-1-sj@kernel.org
Link: https://lore.kernel.org/20260703170605.94472-2-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 +-
 mm/damon/core.c       |   10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-add-damon_region-last_probe_hits
+++ a/include/linux/damon.h
@@ -68,10 +68,10 @@ struct damon_region {
 	unsigned int nr_accesses;
 	unsigned char probe_hits[DAMON_MAX_PROBES];
 	struct list_head list;
-
 	unsigned int age;
 /* private: Internal value for age calculation. */
 	unsigned int last_nr_accesses;
+	unsigned char last_probe_hits[DAMON_MAX_PROBES];
 };
 
 /**
--- a/mm/damon/core.c~mm-damon-add-damon_region-last_probe_hits
+++ a/mm/damon/core.c
@@ -302,8 +302,10 @@ struct damon_region *damon_new_region(un
 	region->ar.start = start;
 	region->ar.end = end;
 	region->nr_accesses = 0;
-	for (i = 0; i < DAMON_MAX_PROBES; i++)
+	for (i = 0; i < DAMON_MAX_PROBES; i++) {
 		region->probe_hits[i] = 0;
+		region->last_probe_hits[i] = 0;
+	}
 	INIT_LIST_HEAD(&region->list);
 
 	region->age = 0;
@@ -2047,8 +2049,10 @@ static void kdamond_reset_aggregated(str
 					damon_nr_regions(t), nr_probes);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
-			for (i = 0; i < DAMON_MAX_PROBES; i++)
+			for (i = 0; i < DAMON_MAX_PROBES; i++) {
+				r->last_probe_hits[i] = r->probe_hits[i];
 				r->probe_hits[i] = 0;
+			}
 		}
 		ti++;
 	}
@@ -3239,6 +3243,8 @@ static void damon_split_region_at(struct
 	new->nr_accesses = r->nr_accesses;
 	/* todo: do this for only installed probes */
 	memcpy(new->probe_hits, r->probe_hits, sizeof(r->probe_hits));
+	memcpy(new->last_probe_hits, r->last_probe_hits,
+			sizeof(r->last_probe_hits));
 
 	damon_insert_region(new, r, damon_next_region(r), t);
 }
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

