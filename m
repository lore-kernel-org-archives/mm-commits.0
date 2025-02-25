Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F5E151991;
	Tue, 25 Feb 2025 23:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740525562; cv=none; b=ny5i3egPLFM9/xdxEWilTONI5d/Qzu0HxHCxrmueNqfW3vijEMViYuu6rWINMKlg7jc1d7Sr/oqB615tD9Aq2ZsQasNXNqNmopwh5rlLLSbQd7Kzg2VVnDIYyXKLdRv7WBmpqU9ZZK11BhItocBZgtzL72ok0G9gNwPzmAgFSFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740525562; c=relaxed/simple;
	bh=7UCsWHe+C0SYWUryeewQYV6tkfwDNOa4b79y0Ynkyhs=;
	h=Date:To:From:Subject:Message-Id; b=SZTBLv8Iltn4Pq4s9SyHmmLwt9PznZlSwNsTm4yVaY7DvStM8RO/ohnaHesMULHdrCFmM+48M5lNM7hzYL9ofV4dUJMvi0vTOe9ZJdY0403aRZh7v8V43t9uFMk9XPn5QP4OSo5fJOaivPMBhcAjI47ek9mzrrBwuXXVyqIDPkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rfL+0PD4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rfL+0PD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3021CC4CEDD;
	Tue, 25 Feb 2025 23:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740525562;
	bh=7UCsWHe+C0SYWUryeewQYV6tkfwDNOa4b79y0Ynkyhs=;
	h=Date:To:From:Subject:From;
	b=rfL+0PD4j+yn322dgeywyr6MwEagQdm1pWP+CmXULxLsKIXwi6SpZGU60yzxscwLA
	 XM44DU27BLSV4i4C14Aix/xZJlvZVT/18nUhBNhobKY4fPHXjpe1Fkr5XYceiBDlIK
	 ln1myHK7hxOMJQp/PeWhpLPoQ/rbkgu/xo6N5HuQ=
Date: Tue, 25 Feb 2025 15:19:21 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries.patch added to mm-hotfixes-unstable branch
Message-Id: <20250225231922.3021CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/damon_nr_regions: sort collected regiosn before checking with min/max boundaries
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/damon_nr_regions: sort collected regiosn before checking with min/max boundaries
Date: Tue, 25 Feb 2025 14:23:33 -0800

damon_nr_regions.py starts DAMON, periodically collect number of regions
in snapshots, and see if it is in the requested range.  The check code
assumes the numbers are sorted on the collection list, but there is no
such guarantee.  Hence this can result in false positive test success. 
Sort the list before doing the check.

Link: https://lkml.kernel.org/r/20250225222333.505646-4-sj@kernel.org
Fixes: 781497347d1b ("selftests/damon: implement test for min/max_nr_regions")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/damon_nr_regions.py |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/damon_nr_regions.py~selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries
+++ a/tools/testing/selftests/damon/damon_nr_regions.py
@@ -65,6 +65,7 @@ def test_nr_regions(real_nr_regions, min
 
     test_name = 'nr_regions test with %d/%d/%d real/min/max nr_regions' % (
             real_nr_regions, min_nr_regions, max_nr_regions)
+    collected_nr_regions.sort()
     if (collected_nr_regions[0] < min_nr_regions or
         collected_nr_regions[-1] > max_nr_regions):
         print('fail %s' % test_name)
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch
selftests-damon-damos_quota-make-real-expectation-of-quota-exceeds.patch
selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms.patch
selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries.patch
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

