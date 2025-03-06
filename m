Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C0219F135;
	Thu,  6 Mar 2025 05:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239458; cv=none; b=HbgUjNxGJAhpXtp2KEYQjG6DUpUl8e8OUKUnLrvqKKeUCacn0oEn8HCjG2WRgk/U0rNOhLLp6YSzgOrW62MHq1UwzfWmNoqGfpLhRpx5ThDmI8N5tWmA2gtvNodUCzIWRhFBfHuEjRRrfQ1rNge0sTc8OaxJvyZCHMkEKdrget0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239458; c=relaxed/simple;
	bh=gouEdN/9yV1RiXvyLsqnXdYd5+kdYjUlTM8Q8MAE688=;
	h=Date:To:From:Subject:Message-Id; b=ZxwS4AG8bWCd7LuzHmdKhS1MCocmGD5vidWFjJthulzD+vh4ejkGr+Ldr4IrzG3Mx4b6a/3d5AfBXcjDM+aH8LSWzerU44VX81p0cn/YLfrfgIbR03Q29DqMSrDN8Ar/HbtUD+YKp5WhEmdfC04FQ4W46dYedEu+KS0JSl5OIzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PUnnMwPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PUnnMwPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6872EC4CEE4;
	Thu,  6 Mar 2025 05:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239458;
	bh=gouEdN/9yV1RiXvyLsqnXdYd5+kdYjUlTM8Q8MAE688=;
	h=Date:To:From:Subject:From;
	b=PUnnMwPdsMFa0SjsMwWkuRDOQAaFQbmY/n0HYeUlDNSv8MHAYZNvNF1T1qnf5U2tV
	 uSgS8TT2aSa+hTJGv3dM/wUQWyrQeyPa9tBG2ktcs238O7YXXptKEi6Au6qKRnXjSS
	 N+Alk/a0YPFLlLwdNAFPrGclY3S/IiSs9XYP671E=
Date: Wed, 05 Mar 2025 21:37:37 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-damon-damos_quota-make-real-expectation-of-quota-exceeds.patch removed from -mm tree
Message-Id: <20250306053738.6872EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/damos_quota: make real expectation of quota exceeds
has been removed from the -mm tree.  Its filename was
     selftests-damon-damos_quota-make-real-expectation-of-quota-exceeds.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/damos_quota: make real expectation of quota exceeds
Date: Tue, 25 Feb 2025 14:23:31 -0800

Patch series "selftests/damon: three fixes for false results".

Fix three DAMON selftest bugs that cause two and one false positive
failures and successes.


This patch (of 3):

damos_quota.py assumes the quota will always exceeded.  But whether quota
will be exceeded or not depend on the monitoring results.  Actually the
monitored workload has chaning access pattern and hence sometimes the
quota may not really be exceeded.  As a result, false positive test
failures happen.  Expect how much time the quota will be exceeded by
checking the monitoring results, and use it instead of the naive
assumption.

Link: https://lkml.kernel.org/r/20250225222333.505646-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250225222333.505646-2-sj@kernel.org
Fixes: 51f58c9da14b ("selftests/damon: add a test for DAMOS quota")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/damos_quota.py |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/damon/damos_quota.py~selftests-damon-damos_quota-make-real-expectation-of-quota-exceeds
+++ a/tools/testing/selftests/damon/damos_quota.py
@@ -51,16 +51,19 @@ def main():
         nr_quota_exceeds = scheme.stats.qt_exceeds
 
     wss_collected.sort()
+    nr_expected_quota_exceeds = 0
     for wss in wss_collected:
         if wss > sz_quota:
             print('quota is not kept: %s > %s' % (wss, sz_quota))
             print('collected samples are as below')
             print('\n'.join(['%d' % wss for wss in wss_collected]))
             exit(1)
+        if wss == sz_quota:
+            nr_expected_quota_exceeds += 1
 
-    if nr_quota_exceeds < len(wss_collected):
-        print('quota is not always exceeded: %d > %d' %
-              (len(wss_collected), nr_quota_exceeds))
+    if nr_quota_exceeds < nr_expected_quota_exceeds:
+        print('quota is exceeded less than expected: %d < %d' %
+              (nr_quota_exceeds, nr_expected_quota_exceeds))
         exit(1)
 
 if __name__ == '__main__':
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-respect-core-layer-filters-allowance-decision-on-ops-layer.patch
mm-damon-core-initialize-damos-walk_completed-in-damon_new_scheme.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch
mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch
mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch
mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch
mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch
mm-damon-introduce-damos-filter-type-hugepage_size-fix.patch
docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link.patch
docs-mm-damon-design-document-hugepage_size-filter.patch
docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc.patch
docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence.patch
docs-mm-damon-design-categorize-damos-filter-types-based-on-handling-layer.patch
mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages.patch
docs-mm-damon-design-document-unmapped-damos-filter-type.patch
mm-damon-add-data-structure-for-monitoring-intervals-auto-tuning.patch
mm-damon-core-implement-intervals-auto-tuning.patch
mm-damon-sysfs-implement-intervals-tuning-goal-directory.patch
mm-damon-sysfs-commit-intervals-tuning-goal.patch
mm-damon-sysfs-implement-a-command-to-update-auto-tuned-monitoring-intervals.patch
docs-mm-damon-design-document-for-intervals-auto-tuning.patch
docs-mm-damon-design-document-for-intervals-auto-tuning-fix.patch
docs-abi-damon-document-intervals-auto-tuning-abi.patch
docs-admin-guide-mm-damon-usage-add-intervals_goal-directory-on-the-hierarchy.patch
mm-damon-core-introduce-damos-ops_filters.patch
mm-damon-paddr-support-ops_filters.patch
mm-damon-core-support-committing-ops_filters.patch
mm-damon-core-put-ops-handled-filters-to-damos-ops_filters.patch
mm-damon-paddr-support-only-damos-ops_filters.patch
mm-damon-add-default-allow-reject-behavior-fields-to-struct-damos.patch
mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters.patch
mm-damon-paddr-respect-ops_filters_default_reject.patch
docs-mm-damon-design-update-for-changed-filter-default-behavior.patch
mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch
mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch
mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch
mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch
mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch
mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch
docs-abi-damon-document-coreops_filters-directories.patch
docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch

