Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9A2346797
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 20:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773002174; cv=none; b=HAbxVt7vItptoPZJ+MiOqOgcdhJiZz7uRBQxsm5jOUKPcczcZRIhqM/Qo0r3LpUyUCiSKxUdyURhOBTP+1BpDaCxqPWSWvyY59WShhEcOcWlEJxZfuwHmVdloGrYeKM9N1qSkXeIn/MGAvXJX7atXZom1Y/I9iwIJ2UwdupjfWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773002174; c=relaxed/simple;
	bh=W+thaBD6s7iaSz+KJuzb0nWaqTGGYewGYjWFzzdLrZ4=;
	h=Date:To:From:Subject:Message-Id; b=XT/5+xquKXSEietxHsiXbBdrCLUmgGYBVVwiZWGhJPff5/xg3k2PWEZgvsHBR0pwNVCHwFPIyLXmiTOPVfqtIi4M2GzyAYGagCTPKxNZ51wzu3cKJp0j0XiUMp5YSLIHmIACqXHKBD9kFLpjE8zwWW3LBE4ELaGiYUAfp2qS+o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T7obiykS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T7obiykS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F13C116C6;
	Sun,  8 Mar 2026 20:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773002174;
	bh=W+thaBD6s7iaSz+KJuzb0nWaqTGGYewGYjWFzzdLrZ4=;
	h=Date:To:From:Subject:From;
	b=T7obiykSSOYfJKJysSSxHaORr0YieZPnqAe+UTLrzbSD97SktItp3YErNkc1iXL8g
	 F8WIpIQ3a/rnumNABU1ufTdVQy3cSNyGAOA2SARgVXNw+4tNOg4+gsxkonWFfzk0cE
	 qYpfoBNFH9x2sRDxevkUs97O0ozQqVWcSu2tZ8k0=
Date: Sun, 08 Mar 2026 13:36:13 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-use-mult_frac.patch added to mm-new branch
Message-Id: <20260308203614.22F13C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: use mult_frac()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-use-mult_frac.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-use-mult_frac.patch

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
Subject: mm/damon/core: use mult_frac()
Date: Sat, 7 Mar 2026 11:53:49 -0800

Patch series "mm/damon: improve/fixup/update ratio calculation, test and
documentation".

Yet another batch of misc/minor improvements and fixups.  Use mult_frac()
instead of the worse open-coding for rate calculations (patch 1).  Add a
test for a previously found and fixed bug (patch 2).  Improve and update
comments and documentations for easier code review and up-to-date
information (patches 3-6).  Finally, fix an obvious typo (patch 7).


This patch (of 7):

There are multiple places in core code that do open-code rate
calculations.  Use mult_frac(), which is developed for doing that in a way
more safe from overflow and precision loss.

Link: https://lkml.kernel.org/r/20260307195356.203753-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260307195356.203753-2-sj@kernel.org
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

 mm/damon/core.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-use-mult_frac
+++ a/mm/damon/core.c
@@ -665,7 +665,7 @@ static unsigned int damon_accesses_bp_to
 static unsigned int damon_nr_accesses_to_accesses_bp(
 		unsigned int nr_accesses, struct damon_attrs *attrs)
 {
-	return nr_accesses * 10000 / damon_max_nr_accesses(attrs);
+	return mult_frac(nr_accesses, 10000, damon_max_nr_accesses(attrs));
 }
 
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
@@ -1722,7 +1722,7 @@ static unsigned long damon_get_intervals
 	}
 	target_access_events = max_access_events * goal_bp / 10000;
 	target_access_events = target_access_events ? : 1;
-	return access_events * 10000 / target_access_events;
+	return mult_frac(access_events, 10000, target_access_events);
 }
 
 static unsigned long damon_feed_loop_next_input(unsigned long last_input,
@@ -2202,7 +2202,7 @@ static __kernel_ulong_t damos_get_node_m
 		numerator = i.totalram - i.freeram;
 	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
 		numerator = i.freeram;
-	return numerator * 10000 / i.totalram;
+	return mult_frac(numerator, 10000, i.totalram);
 }
 
 static unsigned long damos_get_node_memcg_used_bp(
@@ -2235,7 +2235,7 @@ static unsigned long damos_get_node_memc
 		numerator = used_pages;
 	else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
 		numerator = i.totalram - used_pages;
-	return numerator * 10000 / i.totalram;
+	return mult_frac(numerator, 10000, i.totalram);
 }
 #else
 static __kernel_ulong_t damos_get_node_mem_bp(
@@ -2265,8 +2265,8 @@ static unsigned int damos_get_in_active_
 		global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_FILE);
 	total = active + inactive;
 	if (active_ratio)
-		return active * 10000 / total;
-	return inactive * 10000 / total;
+		return mult_frac(active, 10000, total);
+	return mult_frac(inactive, 10000, total);
 }
 
 static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
@@ -2309,8 +2309,8 @@ static unsigned long damos_quota_score(s
 	damos_for_each_quota_goal(goal, quota) {
 		damos_set_quota_goal_current_value(goal);
 		highest_score = max(highest_score,
-				goal->current_value * 10000 /
-				goal->target_value);
+				mult_frac(goal->current_value, 10000,
+					goal->target_value));
 	}
 
 	return highest_score;
@@ -2340,8 +2340,8 @@ static void damos_set_effective_quota(st
 
 	if (quota->ms) {
 		if (quota->total_charged_ns)
-			throughput = mult_frac(quota->total_charged_sz, 1000000,
-							quota->total_charged_ns);
+			throughput = mult_frac(quota->total_charged_sz,
+					1000000, quota->total_charged_ns);
 		else
 			throughput = PAGE_SIZE * 1024;
 		esz = min(throughput * quota->ms, esz);
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

