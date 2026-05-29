Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AB5282F02
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027576; cv=none; b=XKbQjL8XKwRkIeefJu6+m8lLtRR5ZWHCGkCIHtbqTQEIln8xgVROqfd0kBzkOpEA5hYIPPV56mpAV8h7h3RbvrBiVlJO4ZHb76LMN/AV0eoeBRlz4ebjNMTUJpAp68xyYGLT8/luxPUjQ7kqkAirPPb4iE1SpvkXO62mPHutkJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027576; c=relaxed/simple;
	bh=dJmqPOH7l3Zn5tduzrPDM3uomsqpFFUbU+MI99C0LvI=;
	h=Date:To:From:Subject:Message-Id; b=G9pAbsyl/vuSZBpJtGBG0NpTphfsd4s8j8oX4vKpU8Tsc4v2SeI7g07RFpv6ZHPW9XS073Gpp2ouDKumMitwWeD4kVfp+oAP0iIfiRbwYOjwjBOJmEKoplMn5crpqEZYw/rOp8vx/wNadt94AECDtU6wyZQsaVc9RIhfuEwO1bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0lC97E7O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0lC97E7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DE61F00898;
	Fri, 29 May 2026 04:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027574;
	bh=EOeXDZOExISM2ztHphifCI2tvygrrzM6LQKPxZ2ejGg=;
	h=Date:To:From:Subject;
	b=0lC97E7OamLElufC9GXG6ZnhRt4OLdpkHhKWSkDOjfG4h3eEPyszTbtRpRSadZy4g
	 yTbrUlp2d8ohQgSFC4grI0k/TZR9uciR1LW5xM9Bfn0k2X1BlhUMLXvelW8pIM/5ZI
	 SbUNQ5xDJw4TjMzq8bCk8nEvk51LhG+KOCGmfe7A=
Date: Thu, 28 May 2026 21:06:14 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-handle-min_region_sz-remaining-quota-as-empty.patch removed from -mm tree
Message-Id: <20260529040614.93DE61F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: handle <min_region_sz remaining quota as empty
has been removed from the -mm tree.  Its filename was
     mm-damon-core-handle-min_region_sz-remaining-quota-as-empty.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: handle <min_region_sz remaining quota as empty
Date: Mon, 27 Apr 2026 18:33:50 -0700

Patch series "mm/damon: introduce DAMOS failed region quota charge ratio".

Let users set different DAMOS quota charge ratios for DAMOS action failed
regions, for deterministic and consistent DAMOS action progress.

Common Reports: Unexpectedly Slow DAMOS
=======================================

One common issue report that we get from DAMON users is that DAMOS action
applying progress speed is sometimes much slower than expected.  And one
common root cause is that the DAMOS quota is exceeded by the action
applying failed memory regions.

For example, a group of users tried to run DAMOS-based proactive memory
reclamation (DAMON_RECLAIM) with 100 MiB per second DAMOS quota.  They ran
it on a system having no active workload which means all memory of the
system is cold.  The expectation was that the system will show 100 MiB per
second reclamation until (nearly) all memory is reclaimed.  But what they
found is that the speed is quite inconsistent and sometimes it becomes
very slower than the expectation, sometimes even no reclamation at all for
about tens of seconds.  The upper limit of the speed (100 MiB per second)
was being kept as expected, though.

By monitoring the qt_exceeds (number of DAMOS quota exceed events) DAMOS
stat, we found DAMOS quota is always exceeded when the speed is slow.  By
monitoring sz_tried and sz_applied (the total amount of DAMOS action tried
memory and succeeded memory) DAMOS stats together, we found the
reclamation attempts nearly always failed when the speed is slow.

DAMOS quota charges DAMOS action tried regions regardless of the
successfulness of the try.  Hence in the example reported case, there was
unreclaimable memory spread around the system memory.  Sometimes nearly
100 MiB of memory that DAMOS tried to reclaim in the given quota interval
was reclaimable, and therefore showed nearly 100 MiB per second speed. 
Sometimes nearly 99 MiB of memory that DAMOS was trying to reclaim in the
given quota interval was unreclaimable, and therefore showing only about 1
MiB per second reclaim speed.

We explained it is an expected behavior of the feature rather than a bug,
as DAMOS quota is there for only the upper-limit of the speed.  The users
agreed and later reported a huge win from the adoption of DAMON_RECLAIM on
their products.

It is Not a Bug but a Feature; But...
=====================================

So nothing is broken.  DAMOS quota is working as intended, as the upper
limit of the speed.  It also provides its behavior observability via DAMOS
stat.  In the real world production environment that runs long term active
workloads and matters stability, the speed sometimes being slow is not a
real problem.

But, the non-deterministic behavior is sometimes annoying, especially in
lab environments.  Even in a realistic production environment, when there
is a huge amount of DAMOS action unapplicable memory, the speed could be
problematically slow.  Let's suppose a virtual machines provider that
setup 99% of the host memory as hugetlb pages that cannot be reclaimed, to
give it to virtual machines.  Also, when aim-oriented DAMOS auto-tuning is
applied, this could also make the internal feedback loop confused.

The intention of the current behavior was that trying DAMOS action to
regions would anyway impose some overhead, and therefore somehow be
charged.  But in the real world, the overhead for failed action is much
lighter than successful action.  Charging those at the same ratio may be
unfair, or at least suboptimum in some environments.

DAMOS Action Failed Region Quota Charge Ratio
=============================================

Let users set the charge ratio for the action-failed memory, for more
optimal and deterministic use of DAMOS.  It allows users to specify the
numerator and the denominator of the ratio for flexible setup.  For
example, let's suppose the numerator and the denominator are set to 1 and
4,096, respectively.  The ratio is 1 / 4,096.  A DAMOS scheme action is
applied to 5 GiB memory.  For 1 GiB of the memory, the action is
succeeded.  For the rest (4 GiB), the action is failed.  Then, only 1 GiB
and 1 MiB quota is charged.

The optimal charge ratio will depend on the use case and system/workload. 
I'd recommend starting from setting the nominator as 1 and the denominator
as PAGE_SIZE and tune based on the results, because many DAMOS actions are
applied at page level.

Tests
=====

I tested this feature in the steps below.

1. Allocate 50% of system memory and mlock() it using a test program.
2. Fill up the page cache to exhaust nearly all free memory.
3. Start DAMON-based proactive reclamation with 100 MiB/second DAMOS
   hard-quota.  Auto-tune the DAMOS soft-quota under the hard-quota for
   achieving 40% free memory of the system with 'temporal' tuner.

For step 1, I run a simple C program that is written by Gemini.  It is
quite straightforward, so I'm not sharing the code here.

For step 2, I use dd command like below:

   dd if=/dev/zero of=foo bs=1M count=$50_percent_of_system_memory

For step 3, I use the latest version of DAMON user-space tool (damo) like
below.

    sudo damo start --damos_action pageout \
            ` # Do the pageout only up to 100 MiB per second ` \
            --damos_quota_space 100M --damos_quota_interval 1s \
            ` # Auto-tune the quota below the hard quota aiming` \
            ` # 40% free memory of the node 0 ` \
            ` # (entire node of the test system)` \
            --damos_quota_goal node_mem_free_bp 40% 0 \
            ` # use temporal tuner, which is easy to understnd ` \
            --damos_quota_goal_tuner temporal

As expected, the progress of the reclamation is not consistent, because
the quota is exceeded for the failed reclamation of the unreclaimable
memory.

I do this again, but with the failed region charge ratio feature.  For
this, the above 'damo' command is used, after appending command line
option for setup of the charge ratio like below.  Note that the option was
added to 'damo' after v3.1.9.

    sudo ./damo start --damos_action pageout \
            [...]
            ` # quota-charge only 1/4096 for pageout-failed regions ` \
            --damos_quota_fail_charge_ratio 1 4096

The progress of the reclamation was nearly 100 MiB per second until the
goal was achieved, meeting the expectation.

Patches Sequence
================

The first two patches make preparational changes.  Patch 1 updates fully
charged quota check to handle <min_region_sz remaining quota, which will
be able to exist after this series is applied.  Patch 2 merges regions
after applying schemes is done as long as it is ok to do, since regions
split operations for quota could happen much more frequently under a
corner case that this series will make available.

Patch 3 implements the feature and exposes it via DAMON core API.  Patch 4
implements DAMON sysfs ABI for the feature.  Three following patches (5-7)
document the feature and ABI on design, usage, and ABI documents,
respectively.  Four patches for testing of the new feature follow.  Patch
8 implements a kunit test for the feature.  Patches 9 and 10 extend DAMON
selftest helpers for DAMON sysfs control and internal state dumping for
adding a new selftest for the feature.  Patch 11 extends existing DAMON
sysfs interface selftest to test the new feature using the extended helper
scripts.


This patch (of 11):

Less than min_region_sz remaining quota effectively means the quota is
fully charged.  In other words, no remaining quota.  This is because DAMOS
actions are applied in the region granularity, and each region should have
min_region_sz or larger size.  However the existing fully charged quota
check, which is also used for setting charge_target_from and
charge_addr_from of the quota, is not aware of the case.  For the reason,
charge_target_from and charge_addr_from of the quota will not be updated
in the case.  This can result in DAMOS action being applied more
frequently to a specific area of the memory.

The case is unreal because quota charging is also made in the region
granularity.  It could be changed in future, though.  Actually, the
following commit will make the change, by allowing users to set arbitrary
quota charging ratio for action-failed regions.  To be prepared for the
change, update the fully charged quota checks to treat having less than
min_region_sz remaining quota as fully charged.

Link: https://lore.kernel.org/20260428013402.115171-1-sj@kernel.org
Link: https://lore.kernel.org/20260428013402.115171-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
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

 mm/damon/core.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-handle-min_region_sz-remaining-quota-as-empty
+++ a/mm/damon/core.c
@@ -2065,6 +2065,20 @@ static void damos_walk_cancel(struct dam
 	mutex_unlock(&ctx->walk_control_lock);
 }
 
+static bool damos_quota_is_full(struct damos_quota *quota,
+		unsigned long min_region_sz)
+{
+	if (!damos_quota_is_set(quota))
+		return false;
+	if (quota->charged_sz >= quota->esz)
+		return true;
+	/*
+	 * DAMOS action is applied per region, so <min_region_sz remaining
+	 * quota means the quota is effectively full.
+	 */
+	return quota->esz - quota->charged_sz < min_region_sz;
+}
+
 static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
@@ -2122,8 +2136,7 @@ static void damos_apply_scheme(struct da
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
 		quota->charged_sz += sz;
-		if (damos_quota_is_set(quota) &&
-				quota->charged_sz >= quota->esz) {
+		if (damos_quota_is_full(quota, c->min_region_sz)) {
 			quota->charge_target_from = t;
 			quota->charge_addr_from = r->ar.end;
 		}
@@ -2151,8 +2164,7 @@ static void damon_do_apply_schemes(struc
 			continue;
 
 		/* Check the quota */
-		if (damos_quota_is_set(quota) &&
-				quota->charged_sz >= quota->esz)
+		if (damos_quota_is_full(quota, c->min_region_sz))
 			continue;
 
 		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
@@ -2601,8 +2613,7 @@ static void damos_adjust_quota(struct da
 	if (!time_in_range_open(jiffies, quota->charged_from,
 				quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
-		if (damos_quota_is_set(quota) &&
-				quota->charged_sz >= quota->esz)
+		if (damos_quota_is_full(quota, c->min_region_sz))
 			s->stat.qt_exceeds++;
 		quota->total_charged_sz += quota->charged_sz;
 		quota->charged_from = jiffies;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-ops-common-call-folio_test_lru-after-folio_get.patch
mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
mm-damon-core-introduce-struct-damon_probe.patch
mm-damon-core-embed-damon_probe-objects-in-damon_ctx.patch
mm-damon-core-introduce-damon_filter.patch
mm-damon-core-commit-probes.patch
mm-damon-core-introduce-damon_region-probe_hits.patch
mm-damon-core-introduce-damon_ops-apply_probes.patch
mm-damon-core-do-data-attributes-monitoring.patch
mm-damon-paddr-support-data-attributes-monitoring.patch
mm-damon-sysfs-implement-probes-dir.patch
mm-damon-sysfs-implement-probe-dir.patch
mm-damon-sysfs-implement-filters-directory.patch
mm-damon-sysfs-implement-filter-dir.patch
mm-damon-sysfs-implement-filter-dir-files.patch
mm-damon-sysfs-setup-probes-on-damon-core-api-parameters.patch
mm-damon-sysfs-schemes-implement-tried_regions-r-probes.patch
mm-damon-sysfs-schemes-implement-probe-dir.patch
mm-damon-sysfs-schemes-implement-probe-hits-file.patch
mm-damon-trace-probe_hits.patch
selftests-damon-sysfssh-test-probes-dir.patch
docs-mm-damon-design-document-data-attributes-monitoring.patch
docs-admin-guide-mm-damon-usage-document-data-attributes-monitoring.patch
mm-damon-core-introduce-damon_filter_type_memcg.patch
mm-damon-paddr-support-damon_filter_type_memcg.patch
mm-damon-sysfs-add-filters-f-path-file.patch
mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common.patch
mm-damon-sysfs-setup-damon_filter-memcg_id-from-path.patch
docs-mm-damon-design-update-for-memcg-damon-filter.patch
docs-admin-guide-mm-damon-usage-update-for-memcg-damon-filter.patch
mm-damon-core-safely-handle-no-region-case-in-damon_set_regions.patch
mm-damon-core-do-not-use-region-out-of-a-loop-in-damon_set_regions.patch
samples-damon-mtier-replace-damon_add_region-with-damon_set_regions.patch
mm-damon-tests-vaddr-kunit-replace-damon_add_region-with-damon_set_regions.patch
mm-damon-core-hide-damon_add_region.patch
mm-damon-core-hide-damon_insert_region.patch
mm-damon-core-hide-damon_destroy_region.patch
mm-damon-core-add-kdamond_call-debug_sanity-check.patch
mm-damon-core-remove-damon_verify_nr_regions.patch
mm-damon-tests-core-kunit-add-damon_set_regions-test-cases.patch
selftests-damon-sysfspy-stop-kdamonds-before-failing.patch
selftests-damon-sysfssh-test-monitoring-intervals-goal-dir.patch
selftests-damon-sysfssh-test-addr_unit-file-existence.patch
selftests-damon-sysfssh-test-pause-file-existence.patch
mm-damon-core-trace-esz-at-first-setup.patch

