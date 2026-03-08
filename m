Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F29434EEE2
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 20:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773002185; cv=none; b=rCRh/+meu5vMvlqhT4XJRKkWAoCQt4s0bmQnz9byGh9Xq1z4OYzaDPjpv75jZY5NIIflIY7wB8nfFYstVths0QB/eO+SBPByrcshQLQ1OMEnanykF+CiDeNkbZejuObbfPiFlKBzS+q0xP9eL5Mcxr4g0v+ENt85mOYoXb3x21k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773002185; c=relaxed/simple;
	bh=VE5bjWRUkadbJxUMA//VkDFft611oWI+tO23+XYXxxs=;
	h=Date:To:From:Subject:Message-Id; b=lrz331KqmQlQy+DEvAzwdZOhzuhTQg+wrcGiJfEB5mJzEzWzrAHeM5wpl2B/9l1B6RrwrmNgkUXoa0Nqoa3kCBKlfDEUUWzR5HrsLgwxX+ar2P+33pma/8TEplQjV75e4lxkS8ListHxCvNopy345yqZCZCyeSgvPyLeXIjn85c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eNkdWUED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eNkdWUED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCECC116C6;
	Sun,  8 Mar 2026 20:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773002184;
	bh=VE5bjWRUkadbJxUMA//VkDFft611oWI+tO23+XYXxxs=;
	h=Date:To:From:Subject:From;
	b=eNkdWUED7ScB8dRx2QmuzRJY30gMGkwXXB1nf794aCnajX7za5er0zABvzdNx4D3g
	 hb1JIgozT5NRyBBolIl0FaPCcYQ1L2ChC6nzXimLZUnqpGOyDHXjQOUZOJoiUhmyNj
	 Ced8yX5Xrf4Vlw1lhVOkwwufG6U7H2/kidbK4aMY=
Date: Sun, 08 Mar 2026 13:36:24 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch added to mm-new branch
Message-Id: <20260308203624.CFCECC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/maintainer-profile: use flexible review cadence
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch

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
Subject: Docs/mm/damon/maintainer-profile: use flexible review cadence
Date: Sat, 7 Mar 2026 11:53:54 -0800

The document mentions the maitainer is working in the usual 9-5 fashion. 
The maintainer nowadays prefers working in a more flexible way.  Update
the document to avoid contributors having a wrong time expectation.

Link: https://lkml.kernel.org/r/20260307195356.203753-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-use-flexible-review-cadence
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -63,10 +63,10 @@ management subsystem maintainer.
 Review cadence
 --------------
 
-The DAMON maintainer does the work on the usual work hour (09:00 to 17:00,
-Mon-Fri) in PT (Pacific Time).  The response to patches will occasionally be
-slow.  Do not hesitate to send a ping if you have not heard back within a week
-of sending a patch.
+The DAMON maintainer usually work in a flexible way, except early morning in PT
+(Pacific Time).  The response to patches will occasionally be slow.  Do not
+hesitate to send a ping if you have not heard back within a week of sending a
+patch.
 
 Mailing tool
 ------------
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-set-quota-score-histogram-with-core-filters.patch
mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch
mm-damon-core-split-regions-for-min_nr_regions.patch
mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch
mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch
mm-damon-add-config_damon_debug_sanity.patch
mm-damon-core-add-damon_new_region-debug_sanity-check.patch
mm-damon-core-add-damon_del_region-debug_sanity-check.patch
mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch
mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch
mm-damon-core-add-damon_reset_aggregated-debug_sanity-check.patch
mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch
selftests-damon-config-enable-damon_debug_sanity.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch
docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch
mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch
mm-damon-core-use-time_before-for-next_apply_sis.patch
mm-damon-core-use-time_after_eq-in-kdamond_fn.patch
mm-damon-core-use-mult_frac.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch
mm-damon-core-clarify-damon_set_attrs-usages.patch
mm-damon-document-non-zero-length-damon_region-assumption.patch
docs-admin-guide-mm-damn-lru_sort-fix-intervals-autotune-parameter-name.patch
docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch
docs-mm-damon-index-fix-typo-autoamted-automated.patch

