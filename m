Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E008235C1B4
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 22:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772837075; cv=none; b=o6/m8OmwyTqh5lcpS9X3sT3fxW02EchsqVMRb2fu+RrSZrxk4IM3XEhXuW3zlpO3XImSU9hSHXcIZXy5ao+mCCAxKt/csgL2ijg61AMWnpPeThU75YSIfQSyTiPQOqqUQFjsOXXvwUgdUqnwefyVnxt7KvN0ysloXVUKbnJ6ZmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772837075; c=relaxed/simple;
	bh=PRQw9yc8xd9OackcGO8h0qFD8rOsQ7HiUIJgUFlNIH0=;
	h=Date:To:From:Subject:Message-Id; b=ovy/AvJFSDln+ztJti7WyVtVYBxkZtqsxy0DScVQl96zQxQYkswuDhRqHHwlx49jhxMmoQtOtXD0T/2k0G/wDsfikLRmGJDwbm/SxTIhlKvEurfoltjxkgsZZkaU4y+r7Sa0dX68Js+9WHu3QFOe/KCybZkZUXvmxvNk19nSCeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S9lQitTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S9lQitTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9416CC4CEF7;
	Fri,  6 Mar 2026 22:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772837075;
	bh=PRQw9yc8xd9OackcGO8h0qFD8rOsQ7HiUIJgUFlNIH0=;
	h=Date:To:From:Subject:From;
	b=S9lQitTob/ltnjte0BK2j5wACk02jhGfKUifao9EbR5qATA5TTpY4sg/yWTxDrCgP
	 HQmDGqOcg8A4NQ+3fPFTINiPkyQrH22kBZohw00T9eWPEsnX2nSGl1CmG36H11dl2E
	 Vi6fkZaCadUicFUk+cRu4DDEcsR6XOoXUp1ljIh4=
Date: Fri, 06 Mar 2026 14:44:35 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch added to mm-new branch
Message-Id: <20260306224435.9416CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: add damon_merge_regions_of() debug_sanity check
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch

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
Subject: mm/damon/core: add damon_merge_regions_of() debug_sanity check
Date: Fri, 6 Mar 2026 07:29:09 -0800

damon_merge_regions_of() should be called only after aggregation is
finished and therefore each region's nr_accesses and nr_accesses_bp match.
There were bugs that broke the assumption, during development of online
DAMON parameter updates and monitoring results handling changes.  Add a
sanity check for that under CONFIG_DAMON_DEBUG_SANITY.

Link: https://lkml.kernel.org/r/20260306152914.86303-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-add-damon_merge_regions_of-debug_sanity-check
+++ a/mm/damon/core.c
@@ -2505,6 +2505,20 @@ static void damon_merge_two_regions(stru
 	damon_destroy_region(r, t);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_merge_regions_of(struct damon_region *r)
+{
+	WARN_ONCE(r->nr_accesses != r->nr_accesses_bp / 10000,
+			"nr_accesses (%u) != nr_accesses_bp (%u)\n",
+			r->nr_accesses, r->nr_accesses_bp);
+}
+#else
+static void damon_verify_merge_regions_of(struct damon_region *r)
+{
+}
+#endif
+
+
 /*
  * Merge adjacent regions having similar access frequencies
  *
@@ -2518,6 +2532,7 @@ static void damon_merge_regions_of(struc
 	struct damon_region *r, *prev = NULL, *next;
 
 	damon_for_each_region_safe(r, next, t) {
+		damon_verify_merge_regions_of(r);
 		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
 			r->age = 0;
 		else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
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

