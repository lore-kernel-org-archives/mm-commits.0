Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B51151991;
	Tue, 25 Feb 2025 23:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740525560; cv=none; b=TJpjzCR9LsnHYnAcToIYwTV0IetVH3k3o9yxyjyyJL/SmMNQ6PdDMTAYUHBBRQy1nRjCQWJgCK0bODnEaViF2yr4y+bRafyUvJSVzkrgZ/Loq5v0IrGgQQR5oDPgoW0L2YUSwrUGmk3iaUGAdMPjZwybpUFmVgs9DZolQ2eRzy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740525560; c=relaxed/simple;
	bh=3X7DdTcn036EgNAKgISSh615AsRfxWx+rLlTucRCkZ8=;
	h=Date:To:From:Subject:Message-Id; b=luKvOaCshfWAUe4dDCNx84+1229xaec/Xf7cFgG0VSuteE+YlCZwxNLV+KMROXXSy31UsnhItw12uQiNN4icxTk8xl972QUAi1O3RTD3sPmfnT4lX1U+OzLR2kPOE1P4t9p5C8ZEH17OUtpPGJfOcFN9Zwv5r/ZXSztJYychdAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N/9r+0DG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N/9r+0DG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43229C4CEDD;
	Tue, 25 Feb 2025 23:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740525560;
	bh=3X7DdTcn036EgNAKgISSh615AsRfxWx+rLlTucRCkZ8=;
	h=Date:To:From:Subject:From;
	b=N/9r+0DGe1nmXVDleR7Plby4rWWPo9/rAvuFM/xc8mehTUXgBYwJrPfVssyFbtPTR
	 I+0LgSV51aHkfFt7YG/3yqzAoKuebmHVtAm2oPi+VKIYRERlh27BLhAnIW7017X+fV
	 Vv7N2weFBqNIJ1sOErWxKEeuSoigALQ7Ct/1en70=
Date: Tue, 25 Feb 2025 15:19:19 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms.patch added to mm-hotfixes-unstable branch
Message-Id: <20250225231920.43229C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/damon_nr_regions: set ops update for merge results check to 100ms
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms.patch

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
Subject: selftests/damon/damon_nr_regions: set ops update for merge results check to 100ms
Date: Tue, 25 Feb 2025 14:23:32 -0800

damon_nr_regions.py updates max_nr_regions to a number smaller than
expected number of real regions and confirms DAMON respect the harsh
limit.  To give time for DAMON to make changes for the regions, 3
aggregation intervals (300 milliseconds) are given.

The internal mechanism works with not only the max_nr_regions, but also
sz_limit, though.  It avoids merging region if that casn make region of
size larger than sz_limit.  In the test, sz_limit is set too small to
achive the new max_nr_regions, unless it is updated for the new
min_nr_regions.  But the update is done only once per operations set
update interval, which is one second by default.

Hence, the test randomly incurs false positive failures.  Fix it by
setting the ops interval same to aggregation interval, to make sure
sz_limit is updated by the time of the check.

Link: https://lkml.kernel.org/r/20250225222333.505646-3-sj@kernel.org
Fixes: 8bf890c81612 ("selftests/damon/damon_nr_regions: test online-tuned max_nr_regions")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/damon_nr_regions.py |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/damon_nr_regions.py~selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms
+++ a/tools/testing/selftests/damon/damon_nr_regions.py
@@ -109,6 +109,7 @@ def main():
     attrs = kdamonds.kdamonds[0].contexts[0].monitoring_attrs
     attrs.min_nr_regions = 3
     attrs.max_nr_regions = 7
+    attrs.update_us = 100000
     err = kdamonds.kdamonds[0].commit()
     if err is not None:
         proc.terminate()
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

