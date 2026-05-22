Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2273803D3
	for <mm-commits@vger.kernel.org>; Fri, 22 May 2026 20:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779481343; cv=none; b=b70wTMyuXwsx1Ij/4JSHKwIKxDddN8C1kgpKmSIxqweFFWqQCcBcF9/c4T97x+cT8NX6vh/GMMWKGxp76uE9wAGI9UMUEEC5LEZ/0Wig50dww0rzo3Oxi0o+1KxBxhK+nc14KdpLWWqrH852ujU6f0AU9opaywCcSeQL27OYaaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779481343; c=relaxed/simple;
	bh=QNN5PpWo0VkNjLuxoPNwvNkD9NHdq1akQtovx57IA6E=;
	h=Date:To:From:Subject:Message-Id; b=DcYwsA67AtuE5z/5n9HkstvpYiNI+MMzwgRWfkabhTqkpwJtQuENniIheo98PTCyUiVMzAxqBp3e+2N9IsGEa5+h/16Vjvo3uqk9zHd9XRVhSiGykMm7Kk2jl5NI26BZGoGh9q5FNjShy7JDBLjdD7/pzvN5iACPQHsBuWphJKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vsPl9Ajc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vsPl9Ajc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35421F000E9;
	Fri, 22 May 2026 20:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779481341;
	bh=TJzfUqce1Tr+vVQ48TPORbJBIwoKkE+R5dYvLl6E07g=;
	h=Date:To:From:Subject;
	b=vsPl9AjcPp3srwrJGG4wAj+CfBbvrbBqLZAJ6lsqj+ca9BIYZbmxL9Ej1UQU5U7aX
	 M0OmhJCb3s1ti7NF0eVX6F2F8GWP8DUBUAa6oNGg6jEVeJldByR9aMpqIzoeXnJOn0
	 uVlchnm0z4AGNmbum7yAk8QjruvBSUu0oHf/6L8M=
Date: Fri, 22 May 2026 13:22:21 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-safely-handle-no-region-case-in-damon_set_regions.patch added to mm-new branch
Message-Id: <20260522202221.D35421F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: safely handle no region case in damon_set_regions()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-safely-handle-no-region-case-in-damon_set_regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-safely-handle-no-region-case-in-damon_set_regions.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: safely handle no region case in damon_set_regions()
Date: Fri, 22 May 2026 08:40:12 -0700

Patch series "mm/damon: minor improvements for code readability and tests".

Implement minor improvements on code readability and tests for DAMON.

First seven patches are for DAMON code readability and resulting
maintenance.  Patches 1 and 2 make damon_set_regions() safer and easier to
read.  Patches 3 and 4 remove fragmented DAMON API use cases.  Patches 5-7
hides unused core functions that are unnecessarily exposed to API callers.

The following seven patches are for DAMON tests improvement.  Patches 8
and 9 adds and removes DAMON_DEBUG_SANITY verifications to ensure
reasonable test coverage without too high overhead.  Patch 10 adds a new
kunit test for damon_set_regions().  Patch 11 makes sysfs.py selftest more
gracefully finishes under test failures.  Patches 12-13 adds simple
sysfs.sh test cases for the monitoring intervals goal directory, the
addr_unit file and the pause file.


This patch (of 14):

damon_set_regions() calls damon_first_region() regardless of the number of
DAMON regions in a given DAMON target.  damon_first_region() internally
uses list_first_entry(), which clearly documents the list is expected to
be not empty.  Due to the internal implementation of the macro,
damon_set_regions() is safe for now.  But the internal implementation of
the macro can be changed in future.  Refactor the function to explicitly
and safely handle the empty region list case without depending on the
internal implementation.

No behavioral change is intended.

Link: https://lore.kernel.org/20260522154026.80546-1-sj@kernel.org
Link: https://lore.kernel.org/20260522154026.80546-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-safely-handle-no-region-case-in-damon_set_regions
+++ a/mm/damon/core.c
@@ -356,6 +356,19 @@ int damon_set_regions(struct damon_targe
 			damon_destroy_region(r, t);
 	}
 
+	if (!damon_nr_regions(t)) {
+		for (i = 0; i < nr_ranges; i++) {
+			r = damon_new_region(
+					ALIGN_DOWN(ranges[i].start,
+						min_region_sz),
+					ALIGN(ranges[i].end, min_region_sz));
+			if (!r)
+				return -ENOMEM;
+			damon_add_region(r, t);
+		}
+		return 0;
+	}
+
 	r = damon_first_region(t);
 	/* Add new regions or resize existing regions to fit in the ranges */
 	for (i = 0; i < nr_ranges; i++) {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-make-charge_addr_from-aware-of-end-address-exclusivity.patch
mm-damon-core-handle-min_region_sz-remaining-quota-as-empty.patch
mm-damon-core-merge-regions-after-applying-damos-schemes.patch
mm-damon-core-introduce-failed-region-quota-charge-ratio.patch
mm-damon-sysfs-schemes-implement-fail_charge_numdenom-files.patch
docs-mm-damon-design-document-fail_charge_numdenom.patch
docs-admin-guide-mm-damon-usage-document-fail_charge_numdenom-files.patch
docs-abi-damon-document-fail_charge_numdenom.patch
mm-damon-tests-core-kunit-test-fail_charge_numdenom-committing.patch
selftests-damon-_damon_sysfs-support-failed-region-quota-charge-ratio.patch
selftests-damon-drgn_dump_damon_status-support-failed-region-quota-charge-ratio.patch
selftests-damon-sysfspy-test-failed-region-quota-charge-ratio.patch
docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch
mm-damon-core-introduce-damon_ctx-paused.patch
mm-damon-sysfs-add-pause-file-under-context-dir.patch
docs-mm-damon-design-update-for-context-pause-resume-feature.patch
docs-admin-guide-mm-damon-usage-update-for-pause-file.patch
docs-abi-damon-update-for-pause-sysfs-file.patch
mm-damon-tests-core-kunit-test-pause-commitment.patch
selftests-damon-_damon_sysfs-support-pause-file-staging.patch
selftests-damon-drgn_dump_damon_status-dump-pause.patch
selftests-damon-sysfspy-check-pause-on-assert_ctx_committed.patch
selftests-damon-sysfspy-pause-damon-before-dumping-status.patch
mm-damon-introduce-damon_set_region_system_rams_default.patch
mm-damon-reclaim-cover-all-system-rams.patch
mm-damon-lru_sort-cover-all-system-rams.patch
mm-damon-core-remove-damon_set_region_biggest_system_ram_default.patch
mm-damon-stat-use-damon_set_region_system_rams_default.patch
docs-admin-guide-mm-damon-reclaim-update-for-entire-memory-monitoring.patch
docs-admin-guide-mm-damon-lru_sort-update-for-entire-memory-monitoring.patch
docs-admin-guide-mm-damon-usage-mark-scheme-filters-sysfs-dir-as-deprecated.patch
docs-abi-damon-mark-schemes-s-filters-deprecated.patch
mm-damon-reclaim-add-autotune_monitoring_intervals-parameter.patch
docs-admin-guide-mm-damon-reclaim-update-for-autotune_monitoring_intervals.patch
mm-damon-stat-add-a-parameter-for-reading-kdamond-pid.patch
docs-admin-guide-mm-damon-stat-document-kdamond_pid-parameter.patch
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

