Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A86130F533
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334337; cv=none; b=SixYxFRhzSb7tbHqu/VgO9pieMnaqCFNUlfmqz7sS+CIIHkEbSRaqew1JYSL3e2xPGMrljvtofRXT89jfDx9S0aBTkz2ZvDiwnxt6aM1AeRKFxfvV39ozbKbRc2O8PddcYW71OlI45DWuTDTzXGIzfMWaWTHCiPrJe8ReCbxKiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334337; c=relaxed/simple;
	bh=Ep8KQWDn8N5xkdVrw0gEc+NQ+rvW6eahbpaIWustbU0=;
	h=Date:To:From:Subject:Message-Id; b=bqj/Ve3ayRpM7pHjd7A3wxzm3+NH3AYaiPiKtScAe8iRlPobVYjSVoQDZvwHF4Bn5u/0Q63zLmFRvzsZyWN+tXrNLaHBXAPkB9hE5iAUXnB4bLC0tH/2F6F2lxLztKq+30Tvr9w7CDE3y1druUNzYVjmiHQ5tdDaSCYtYFdEtGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SxQZCQ3b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SxQZCQ3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58D01F0089B;
	Wed,  7 Oct 2026 00:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334335;
	bh=+rNGzPIgaIKgdt4wIkMgktADydgpfMOSVSQ9hika6iI=;
	h=Date:To:From:Subject;
	b=SxQZCQ3bAZ2NszGkygsf6GuwkS7w58BDigoFv7wmkPKSYFFmYexNjdiDmVcgLE3Om
	 SWQdhgqQeHz83Tw/VAJdQ4UqrIRGopAQiN3DcFdWjF/CmD7KVEnokPpGAaNl75L6O0
	 lFUWvkjH8YrZm8kQZLxv0sGffVoyk9FDv4SDiWKU=
Date: Tue, 06 Oct 2026 17:52:15 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-introduce-damon_filter_type_pgidle_unset.patch removed from -mm tree
Message-Id: <20261007005215.D58D01F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: introduce DAMON_FILTER_TYPE_PGIDLE_UNSET
has been removed from the -mm tree.  Its filename was
     mm-damon-core-introduce-damon_filter_type_pgidle_unset.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: introduce DAMON_FILTER_TYPE_PGIDLE_UNSET
Date: Tue, 1 Sep 2026 06:24:48 -0700

Patch series "mm/damon: introduce data access-as-a-data attribute", v1.1.

TL;DR: extend DAMON's data attributes monitoring system to support page
table accessed bit and PG_idle based access monitoring.

DAMON was initially introduced as a data access monitor.  Users found data
access pattern becomes more useful when it is combined with other data
attributes such as belonging cgroups and backing page types.  For such
cases, DAMON has extended to support such data attributes monitoring in
addition to the original data access monitoring.  The DAMON probes system
was introduced for this purpose.  Users set probes for filtering data
attributes of their interest.  For use cases where the primary interests
are the attributes but the access pattern, probe weights system has been
introduced.  When it is used, DAMON applies its adaptive regions
adjustment based on the monitored data attributes.

However, DAMON stops access monitoring when the probe weights are used. 
DAMON cannot optimally help users who have interests in both data
attributes and access patterns.  Data access can also be thought of as
another data attribute, though.  Extend the probe system to support data
access as a data attribute.

Introduce a new probe filter type, pgidle_unset.  It shows if the page is
not set as idle.  Specifically, it shows the page table accessed bit and
the PG_idle flag.  It can inform if the region is ever accessed.  But it
cannot say when it is accessed.  To answer the second question, introduce
a new probe feature, prep actions.  Using the features, Users can specify
what preparation actions should be made to each region for each probe. 
DAMON executes the preparation actions for each sampling interval, like it
is doing the preparation for access check in the access monitoring mode. 
To help 'pgidle_unset' probe action use case, 'set_pgidle' preparation
action is introduced together.  The action does exactly what the access
monitoring was doing: clearing the page table accessed bits and setting
the PG_idle flags.

Tests
=====

I compared the access pattern monitoring results from the classic way and
the probe based way.  As expected, the probe based way shows the results
similar to that of the classic way.  More detailed test methods and
results are below.

First, do the access monitoring using the DAMON user-space tool [1] in the
classic way.  The system is idle.  It shows no access as expected.

    $ sudo ./damo/damo start
    $ sudo ./damo/damo report access
    heatmap:
    00000000000000000000000000000000000000008999999811111110000000000000000000000000
    # min/max temperatures: -640,000,000, -100,000,000, column size: 99.800
    MiB
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    0   addr 4.000 KiB    size 3.898 GiB   access 0 hz   age 6.400 s
    1   addr 3.898 GiB    size 787.301 MiB access 0 hz   age 1 s
    2   addr 4.667 GiB    size 773.457 MiB access 0 hz   age 5.800 s
    3   addr 5.423 GiB    size 2.374 GiB   access 0 hz   age 6.400 s
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

Start an artificial memory access generator (masim) [2] in another window.

    $ ./masim/masim.py run --config_file ./masim/configs/zigzag.cfg

Show the monitoring results.  As expected, it captures accesses.

    $ sudo ./damo/damo report access
    heatmap:
    00000000000000000000000000000000000000011111111111111118888888833378988888888888
    # min/max temperatures: -1,470,000,000, -12,482,536, column size: 99.800
    MiB
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    0   addr 4.000 KiB    size 1.542 GiB   access 0 hz   age 14.700 s
    1   addr 1.542 GiB    size 788.324 MiB access 0 hz   age 14.600 s
    2   addr 2.311 GiB    size 772.844 MiB access 0 hz   age 14.200 s
    [...]
    50  addr 6.839 GiB    size 1.742 MiB   access 0 hz   age 1.300 s
    51  addr 6.840 GiB    size 8.000 KiB   access 100 hz age 0 ns
    52  addr 6.840 GiB    size 1.496 MiB   access 160 hz age 0 ns
    [...]
    97  addr 7.162 GiB    size 1.199 MiB   access 40 hz  age 400 ms
    98  addr 7.163 GiB    size 1.199 MiB   access 20 hz  age 400 ms
    99  addr 7.164 GiB    size 2.004 MiB   access 160 hz age 0 ns
    100 addr 7.166 GiB    size 646.004 MiB access 0 hz   age 400 ms
    memory bw estimate: 26.148 GiB per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

After the artificial memory access generator (masim) is terminated,
restart DAMON with the probe-based access monitoring.  As expected, it
shows no access since the system is idle again.

    $ sudo ./damo/damo stop
    $ sudo ./damo/damo start --probe_prep set_pgidle \
            --probe_filter allow pgidle_unset --probe_weight 1
    $ sudo ./damo/damo report attrs
    heatmap:
    00000000000000000000000000000000000000008999999711111100000000000000000000000000
    # min/max temperatures: -600,000,000, -430,000,000, column size: 99.800
    MiB
    probe prep: set_pgidle, filter: allow pgidle_unset (weight: 1)
    intervals: sample 5 ms aggr 100 ms (max probe hits 20)
    #   addr         size         age           probe_hits
    0   4.000 KiB    3.898 GiB    6 s           0
    1   5.285 GiB    2.512 GiB    6 s           0
    2   4.659 GiB    641.816 MiB  5.700 s       0
    3   3.898 GiB    778.375 MiB  4.300 s       0
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

Start the artificial memory access generator [2] again.

    $ ./masim/masim.py run --config_file ./masim/configs/zigzag.cfg

Show the monitoring results.  As expected, it captures accesses similar to
the classic monitoring mode.

    $ sudo ./damo/damo report attrs
    heatmap:
    00000000000000000000000000000000000000011111110000000177777777777777878798887777
    # min/max temperatures: -1,330,000,000, 84,847,514, column size: 99.800
    MiB
    probe prep: set_pgidle, filter: allow pgidle_unset (weight: 1)
    intervals: sample 5 ms aggr 100 ms (max probe hits 20)
    #   addr         size         age           probe_hits
    0   4.000 KiB    1.508 GiB    13.300 s      0
    1   1.508 GiB    794.684 MiB  13.200 s      0
    2   2.284 GiB    764.555 MiB  13 s          0
    [...]
    50  6.711 GiB    4.625 MiB    0 ns          17
    51  6.716 GiB    2.504 MiB    0 ns          17
    52  6.732 GiB    796.000 KiB  0 ns          17
    [...]
    90  7.162 GiB    512.000 KiB  2.200 s       2
    91  7.061 GiB    700.000 KiB  2.300 s       1
    92  6.935 GiB    316.000 KiB  2.300 s       4
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

Patches Sequence
================

First four patches (patches 1-4) introduce the new probe filter type for
knowing if a region is accessed.  Patch 1 defines the new type in the
core.  Patch 2 implements the execution of the new filter in the physical
address space DAMON operation set.  Patch 3 implements a user interface on
DAMON sysfs interface.  Patch 4 updates the documentation for the new
filter type.

Following 13 patches (patches 5-17) introduce the probe preparation
actions feature.  Patch 5 defines the data structure for specifying the
preparation actions.  Patch 6 completes setup of the API parameter for the
prep.  Patch 7 extends the DAMON operation set callback list to connect
the parameter with the underlying operation set.  Patch 8 implements the
execution of the prep in the physical address space DAMON operation set.

Following five patches (patches 9-13) extends DAMON sysfs interface for
the new prep feature.  Patch 14 adds simple selftest for basic file
operations of the new sysfs files.  Final three patches (patches 15-17)
respectively update design, usage and ABI documents for the new feature
and its interface.


This patch (of 17):

Introduce a new DAMON filter type, pgidle_unset.  It will match pages that
have their PG_Idle flag unset, or the page table accessed bit set.  In
other words, it says if the page is accessed.

Link: https://lore.kernel.org/20260901132506.99243-1-sj@kernel.org
Link: https://lore.kernel.org/20260901132506.99243-2-sj@kernel.org
Link: https://github.com/damonitor/damo [1]
Link: https://github.com/sjp38/masim [2]
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 include/linux/damon.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-introduce-damon_filter_type_pgidle_unset
+++ a/include/linux/damon.h
@@ -745,12 +745,14 @@ struct damon_intervals_goal {
 /**
  * enum damon_filter_type - Type of &struct damon_filter
  *
- * @DAMON_FILTER_TYPE_ANON:	Anonymous pages.
- * @DAMON_FILTER_TYPE_MEMCG:	Specific memcg's pages.
+ * @DAMON_FILTER_TYPE_ANON:		Anonymous pages.
+ * @DAMON_FILTER_TYPE_MEMCG:		Specific memcg's pages.
+ * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
 	DAMON_FILTER_TYPE_MEMCG,
+	DAMON_FILTER_TYPE_PGIDLE_UNSET,
 };
 
 /**
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-use-damon_nr_samples_per_aggr-for-max-merge-threshold.patch
mm-damon-core-remove-debug-messages.patch
mm-damon-core-remove-debug-messages-fix.patch
mm-damon-vaddr-remove-a-debug-message.patch
mm-damon-core-validate-number-of-probes-in-valid_probe_params.patch
mm-damon-sysfs-remove-probes-number-validation.patch
mm-damon-tests-core-kunit-extend-set_regions-test-for-error-case.patch
mm-damon-tests-core-kunit-test-=0-size-damon_set_regions-inputs.patch
mm-damon-tests-core-kunit-test-overlapping-ranges-for-set_regions.patch
mm-damon-tests-core-kunit-test-damon_nr_samples_per_aggr.patch
selftests-damon-sysfssh-test-hugepage_mem_bp-quota-goal.patch
docs-mm-damon-maintainer-profile-update-ai-review-for-sashiko-replies.patch
docs-abi-damon-recommend-subsystem-doc-instead-of-admin-guide.patch
mm-damon-core-error-damos_commit_quota_goal-for-zero-target_value.patch
revert-mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch
revert-samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch
mm-damon-core-handle-null-ctx-parameter-in-damon_call.patch
mm-damon-core-set-ctx-call_controls_obsolete-in-damon_new_ctx.patch
mm-damon-reclaim-remove-unnecessary-damon_call-param-validation.patch
mm-damon-lru_sort-remove-unnecessary-damon_call-param-validation.patch
mm-damon-vaddr-support-prep_probes.patch
mm-damon-paddr-move-probe-filter-handling-to-ops-common.patch
mm-damon-vaddr-support-apply_probe.patch
mm-damon-vaddr-extend-apply_probes-for-hugetlb.patch
mm-damon-vaddr-support-pgidle_unset-probe-filter-type.patch
mm-damon-api-introduce-damon_filter_type_pgidle_set.patch
mm-damon-paddr-support-damon_filter_type_pgidle_set.patch
mm-damon-vaddr-support-damon_filter_type_pgidle_set.patch
mm-damon-sysfs-support-damon_filter_type_pgidle_set.patch
docs-mm-damon-design-update-for-pgidle_set-probe-filter.patch
mm-damon-api-introduce-damos_filter_type_probe_hits_wsum.patch
mm-damon-api-introduce-damos_filter_type_probe_hits_wsum-fix.patch
mm-damon-core-extend-probe_hits_wsum-for-moving-sum-based-calculation.patch
mm-damon-core-support-probe_hits_wsum-damos-core-filter.patch
mm-damon-sysfs-schemes-rename-sysfs_filter-sz_range-to-range_minmax.patch
mm-damon-sysfs-schemes-support-probe_hits_wsum-damos-core-filter.patch
docs-mm-damon-design-update-for-probe_hits_wsum-damos-core-filter.patch
docs-admin-guide-mm-damon-usage-update-for-probe_hits_wsum-damos-filter.patch
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

