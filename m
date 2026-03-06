Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A02E29D273
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 22:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772837077; cv=none; b=HaLLDdSx2+EmZBvFK1onJBAsjtPVgUuURLyrYox8ea1kovcRQAcc2xNQFgzkMmeL5ZdI48yu02B8Kz61ojApuERF2W5MdqxFCEpj8Xzm5FcTdsVkex8t7s0GM0ZtmvC9861jK4IEc5NjryEeIoPfGsEhDHTxOmk3gB73WZxRZ5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772837077; c=relaxed/simple;
	bh=+MRGWpwAs/RyhBw5NLIcB0sKm19EVafR8+rfW8V7orM=;
	h=Date:To:From:Subject:Message-Id; b=RiwNSOEl/AJvuxQwKsB95sGlKPPnFwqa8fKezPHRetDIziR4j5YwqL7Pvgc+tICuMGyp6O8F+NPR7FzYd6BKkvwc1vsh2xou8PWzDBAc81YYkoe5BzgMe8sPe+nhWCI6ZqRmAiBcY15GBZ0hiZ7z82Aqy1P698UXfKTrSvu04zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KuVuNHs6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KuVuNHs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED91C4CEF7;
	Fri,  6 Mar 2026 22:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772837077;
	bh=+MRGWpwAs/RyhBw5NLIcB0sKm19EVafR8+rfW8V7orM=;
	h=Date:To:From:Subject:From;
	b=KuVuNHs6GYm381MZ0CihcdPeRzvOat6HmqTRBaHg24YBc89qkHNNCI7auCoI/IXuf
	 RCPeDkxIzhG2KHMhhDaoxyoZHkCK8ZpbB2LJbiybufJ/JBBSYvKInIL6TvwS+k5umF
	 wrIGr/LNwncKhsZAthEsTsy+U0LLQT3lDTO4jAao=
Date: Fri, 06 Mar 2026 14:44:36 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch added to mm-new branch
Message-Id: <20260306224436.DED91C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: add damon_split_region_at() debug_sanity check
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Subject: mm/damon/core: add damon_split_region_at() debug_sanity check
Date: Fri, 6 Mar 2026 07:29:10 -0800

damon_split_region_at() should be called with the correct address to split
on.  Add a sanity check for that under CONFIG_DAMON_DEBUG_SANITY.

Link: https://lkml.kernel.org/r/20260306152914.86303-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-add-damon_split_region_at-debug_sanity-check
+++ a/mm/damon/core.c
@@ -2586,6 +2586,21 @@ static void kdamond_merge_regions(struct
 			threshold / 2 < max_thres);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_split_region_at(struct damon_region *r,
+		unsigned long sz_r)
+{
+	WARN_ONCE(sz_r == 0 || sz_r >= damon_sz_region(r),
+			"sz_r: %lu r: %lu-%lu (%lu)\n",
+			sz_r, r->ar.start, r->ar.end, damon_sz_region(r));
+}
+#else
+static void damon_verify_split_region_at(struct damon_region *r,
+		unsigned long sz_r)
+{
+}
+#endif
+
 /*
  * Split a region in two
  *
@@ -2597,6 +2612,7 @@ static void damon_split_region_at(struct
 {
 	struct damon_region *new;
 
+	damon_verify_split_region_at(r, sz_r);
 	new = damon_new_region(r->ar.start + sz_r, r->ar.end);
 	if (!new)
 		return;
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

