Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CB1346797
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 20:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773002178; cv=none; b=szGjUg2/P69TEuhk34gHxot6Zj5oV7H/lQ4TfSFXjDKp9bBqBue5ptnj3NevXgdBVOWtIVnb9fju/q44T+ZM8nhuqjrgs4uWx6eAzo5R3dfiLWthUUH1tm3GhtNjXiXPFjiWKdcL4C2zmzN79qJdt4/fB8JrenO2ZH/MyV/A2rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773002178; c=relaxed/simple;
	bh=mc4PAm4XY3NjUygtVbvZJ2A6Jsp6C30VAi+mp9sfwwE=;
	h=Date:To:From:Subject:Message-Id; b=Rj3LV2nKa/ohJWhms3LCiOz+Ohx3YkvptaQkhcBS/mM0IAxll4LY+dDT3M4pv4ZNTil2d5ILVxmIlyMdgaNQnkTKcIkPTVRaZebX8sLjOgnjD0E1tawvtntrsLapr0yTPpeWVr3d8thPMbO/jkFTe/hgCC56ypsAt3ItJGsT5qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eh7OxXoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eh7OxXoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9BBC116C6;
	Sun,  8 Mar 2026 20:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773002178;
	bh=mc4PAm4XY3NjUygtVbvZJ2A6Jsp6C30VAi+mp9sfwwE=;
	h=Date:To:From:Subject:From;
	b=eh7OxXoRqwoxfw3qIspN5I6x6QMr+OdvMni4bTfCmUc4Hw2Gl7rAn1FDh/Tj00Xtl
	 prQq2iioeGNQgrxVBwHlGhUE6wWB0t5D2DfOoxnBM51QxY0FgdjbYFWvg3RAiwcS66
	 QxuOs5CgNeFKFhYHbBA6cSK2u8aaK6JQw0hG1De0=
Date: Sun, 08 Mar 2026 13:36:17 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-clarify-damon_set_attrs-usages.patch added to mm-new branch
Message-Id: <20260308203618.8D9BBC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: clarify damon_set_attrs() usages
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-clarify-damon_set_attrs-usages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-clarify-damon_set_attrs-usages.patch

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
Subject: mm/damon/core: clarify damon_set_attrs() usages
Date: Sat, 7 Mar 2026 11:53:51 -0800

damon_set_attrs() is called for multiple purposes from multiple places. 
Calling it in an unsafe context can make DAMON internal state polluted and
results in unexpected behaviors.  Clarify when it is safe, and where it is
being called.

Link: https://lkml.kernel.org/r/20260307195356.203753-4-sj@kernel.org
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

 mm/damon/core.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-clarify-damon_set_attrs-usages
+++ a/mm/damon/core.c
@@ -751,8 +751,16 @@ static bool damon_valid_intervals_goal(s
  * @ctx:		monitoring context
  * @attrs:		monitoring attributes
  *
- * This function should be called while the kdamond is not running, an access
- * check results aggregation is not ongoing (e.g., from damon_call().
+ * This function updates monitoring results and next monitoring/damos operation
+ * schedules.  Because those are periodically updated by kdamond, this should
+ * be called from a safe contexts.  Such contexts include damon_ctx setup time
+ * while the kdamond is not yet started, and inside of kdamond_fn().
+ *
+ * In detail, all DAMON API callers directly call this function for initial
+ * setup of damon_ctx before calling damon_start().  Some of the API callers
+ * also indirectly call this function via damon_call() -> damon_commit() for
+ * online parameters updates.  Finally, kdamond_fn() itself use this for
+ * applying auto-tuned monitoring intervals.
  *
  * Every time interval is in micro-seconds.
  *
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

