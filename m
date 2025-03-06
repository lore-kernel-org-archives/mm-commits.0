Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C89119C546;
	Thu,  6 Mar 2025 05:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239435; cv=none; b=Yi7T8VT0b/zThhUkneMjyMLJEvZNUg9pQw9JMdMFP05faATSySaWPiuZES6WIbXGkQGslQ2GMu3OXhGaf4Vl4Bcm6wlY+ZWUOOcrAe4S3HemYXykGuqKJTYOakUM+LUpwcCsRo/FOsEaG4vlAsH5H/xAVDyCoDc+x0ekMyIp1ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239435; c=relaxed/simple;
	bh=jkph/MIBSAO02JD5aWcMQZyOkiUV9ukqW3ASZwVQs2c=;
	h=Date:To:From:Subject:Message-Id; b=MhMNk8ceYzBJRwa+0QpBvABmZAirZDuN85MNlGDUA/w2ve59im9PPeoA+tlIxoHJ+AMif1IZlXiFXH341hBmtH1Dp77+Rg4t61TPBUxlm+Ak7CeWG8/j5LfVhmSgivUGupTokDYsWv1atSQRyLMTQQLbIU58CiIjIOxPpJlMCeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AdqxxV9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AdqxxV9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF93FC4CEE5;
	Thu,  6 Mar 2025 05:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239434;
	bh=jkph/MIBSAO02JD5aWcMQZyOkiUV9ukqW3ASZwVQs2c=;
	h=Date:To:From:Subject:From;
	b=AdqxxV9WCmcjeQnv7dmihd+hz7biZbVBHsf6wKZZdvo51X7P4T6bjhrw8AtOyZMEZ
	 T0jZ1J2wfSOEvZImYkkl5PWUCZoxp0XNOZhza3x2Tr3ZRoyiYE8uLERP4LJOkHf0Lx
	 na2xkpFqHCJGA+sa07tIVkDwygyO7qL/imosWr2Q=
Date: Wed, 05 Mar 2025 21:37:14 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,oliver.sang@intel.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch removed from -mm tree
Message-Id: <20250306053714.AF93FC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/damos_quota_goal: handle minimum quota that cannot be further reduced
has been removed from the -mm tree.  Its filename was
     selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/damos_quota_goal: handle minimum quota that cannot be further reduced
Date: Mon, 17 Feb 2025 10:23:04 -0800

damos_quota_goal.py selftest see if DAMOS quota goals tuning feature
increases or reduces the effective size quota for given score as expected.
The tuning feature sets the minimum quota size as one byte, so if the
effective size quota is already one, we cannot expect it further be
reduced.  However the test is not aware of the edge case, and fails since
it shown no expected change of the effective quota.  Handle the case by
updating the failure logic for no change to see if it was the case, and
simply skips to next test input.

Link: https://lkml.kernel.org/r/20250217182304.45215-1-sj@kernel.org
Fixes: f1c07c0a1662 ("selftests/damon: add a test for DAMOS quota goal")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202502171423.b28a918d-lkp@intel.com
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>	[6.10.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/damos_quota_goal.py |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/damon/damos_quota_goal.py~selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced
+++ a/tools/testing/selftests/damon/damos_quota_goal.py
@@ -63,6 +63,9 @@ def main():
             if last_effective_bytes != 0 else -1.0))
 
         if last_effective_bytes == goal.effective_bytes:
+            # effective quota was already minimum that cannot be more reduced
+            if expect_increase is False and last_effective_bytes == 1:
+                continue
             print('efective bytes not changed: %d' % goal.effective_bytes)
             exit(1)
 
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

