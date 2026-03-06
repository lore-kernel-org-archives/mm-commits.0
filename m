Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E875854654
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 22:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772837071; cv=none; b=Ng9YxeZM1Ht1UmmSTW1z9nHwTDQaAuLOfTcHQTuD44bgg5WYqHMKFzqurWS2lGjXLNY1NgSIvDuuMw/PoebxF7Ny4T6tWABh0FLz1/dUtn5wVg3EK6Rq5kO7vbIdWaLY3KptFQpohpQ5DwlEpJQij5sRdX4wKJyE11aQrXN/yJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772837071; c=relaxed/simple;
	bh=iU6RcYEqcS4690mkGIVdZJL3dDiHDKdddCQjDJYFBBo=;
	h=Date:To:From:Subject:Message-Id; b=OmnWf0eMInXrRk2zBo/vAH6tJFuNenvEh51S1ZHnNCbwo+KcYM/kgXY3LMVG7GEMatdA4mvKWGohS9kQSUAUlrTjfk1nLtQa6HLbj0WH4LBdOm6vOt8iIg0azyCuxAbheboQr2aybicSVz4E4OgVBQFCUZnlYJ04kI470WrbqaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EoE9ony8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EoE9ony8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCA6C4CEF7;
	Fri,  6 Mar 2026 22:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772837070;
	bh=iU6RcYEqcS4690mkGIVdZJL3dDiHDKdddCQjDJYFBBo=;
	h=Date:To:From:Subject:From;
	b=EoE9ony83JOr769SGfi5UkV1x2Y9WOwTalQIMQqGUCZ5RTAKB/yf4SJpxmG2+BI73
	 7eS4UWiw/9NAPmwgJ/B4WgtQ1S4tuMGCogksr6gakg8R8sO52iCD3lroFQ7qE8Tq90
	 X/5he4xY50/rjgSfveMvo08OE+34GNKqQ3JNArVI=
Date: Fri, 06 Mar 2026 14:44:30 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-damon_new_region-debug_sanity-check.patch added to mm-new branch
Message-Id: <20260306224430.BBCA6C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: add damon_new_region() debug_sanity check
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-add-damon_new_region-debug_sanity-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-add-damon_new_region-debug_sanity-check.patch

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
Subject: mm/damon/core: add damon_new_region() debug_sanity check
Date: Fri, 6 Mar 2026 07:29:05 -0800

damon_new_region() is supposed to be called with only valid address range
arguments.  Do the check under DAMON_DEBUG_SANITY.

Link: https://lkml.kernel.org/r/20260306152914.86303-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-add-damon_new_region-debug_sanity-check
+++ a/mm/damon/core.c
@@ -109,6 +109,17 @@ int damon_select_ops(struct damon_ctx *c
 	return err;
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_new_region(unsigned long start, unsigned long end)
+{
+	WARN_ONCE(start >= end, "start %lu >= end %lu\n", start, end);
+}
+#else
+static void damon_verify_new_region(unsigned long start, unsigned long end)
+{
+}
+#endif
+
 /*
  * Construct a damon_region struct
  *
@@ -118,6 +129,7 @@ struct damon_region *damon_new_region(un
 {
 	struct damon_region *region;
 
+	damon_verify_new_region(start, end);
 	region = kmem_cache_alloc(damon_region_cache, GFP_KERNEL);
 	if (!region)
 		return NULL;
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

