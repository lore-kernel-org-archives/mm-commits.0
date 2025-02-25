Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BE2151991;
	Tue, 25 Feb 2025 23:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740525559; cv=none; b=Ixr5cfg73PfuKP6rpkbvnIgc3vetrQ/7ozksWMOObO/ndRfSbFG+EsJrXixEgJoi7gyTI44YjQA7UXDVwWCIJZNm/H4PNpokdcGEi/eWlrBT+WgxFxDwqDk2DGZ0v/OXy3RppOsCgXYNTDh4dnb4qgymBMexQgxAwZwSsIKKbmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740525559; c=relaxed/simple;
	bh=CM8cMgLsoifca4gB+YqGwkLQSiG8AImNJWvjycxeiOc=;
	h=Date:To:From:Subject:Message-Id; b=AvrlpelYDmjNdPnFjmZynnPmVIKkwF937duKTuNYpuU828BQImwFDRe8//dK1S9fy1KUemeI3+lV2JF/tK1RC/PqJjEsXUzyoadz4BkiCgRyRcQzNT5+/GDuvEz7bKWgqEcyQZHL8v+KxAJJzf9Fu5ReMW3t8cABLJbzpCMr200=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ihC2jObH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ihC2jObH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F27DC4CEDD;
	Tue, 25 Feb 2025 23:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740525558;
	bh=CM8cMgLsoifca4gB+YqGwkLQSiG8AImNJWvjycxeiOc=;
	h=Date:To:From:Subject:From;
	b=ihC2jObH/Sy+gNwvm/IPJa+AFizgP175SB8EeAZNC4Szy3KgSIt1pE1ZHQ7YRtxen
	 f509dmcoilG1/TiA1c/NkVV7YEJiRHi8uYKxQmDjqqGYghOwiRFOgmfdhRmsSiyFdN
	 pV7u0muvQltzw0M1MF9OYMza921dpJGp+dveytBE=
Date: Tue, 25 Feb 2025 15:19:17 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-damos_quota-make-real-expectation-of-quota-exceeds.patch added to mm-hotfixes-unstable branch
Message-Id: <20250225231918.5F27DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/damos_quota: make real expectation of quota exceeds
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-damon-damos_quota-make-real-expectation-of-quota-exceeds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-damos_quota-make-real-expectation-of-quota-exceeds.patch

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

