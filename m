Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E1454654
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 22:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772837074; cv=none; b=Agvsy82wxdxgDyNvkS2dncYrHzczbir8ZR6vZ6ZK7MRleev8XMcKfjpn2tCtw2PxE1SNvAo3/Tawuyh1V7BUstYVFe/Ci2woGWhGMnslN72Om8FcVmn6xOuGZtub0XBx4CD4i0+Tyr9Ygm8hRc+gmZs2KJ5mqvuxLc4BZ+FweYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772837074; c=relaxed/simple;
	bh=RXx4fffS8B4EnUcy1FsP5t6LMh0+Ug1GiCQgSf23/JQ=;
	h=Date:To:From:Subject:Message-Id; b=BA1KM9Q8HGTivEX+sBdA9oZBAUC+Hs7pTnbZFFlCoAa8reiE7VDK4QSARiMb46i611lvM9v/Z7J1JOcCDKMah73VuQeJuBe80WxQdrefLMdH8EFuGNE/Ap6M8n4oL0hH7elsJ/OXyIi0f7Lp5YPoSxXkoUdeIBoQb91MlXaVN6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wl6V9AXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wl6V9AXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BB1C4CEF7;
	Fri,  6 Mar 2026 22:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772837074;
	bh=RXx4fffS8B4EnUcy1FsP5t6LMh0+Ug1GiCQgSf23/JQ=;
	h=Date:To:From:Subject:From;
	b=Wl6V9AXrQQn0Uf0r5rsIusmIKoFzzOGX+pLxhzCjoqYfmRxjar/iOQqjfWBnp5GmW
	 5BgV+20kvAPbNAGSbQhmD+raXF9p9YryTSrthbGBexvHTWfkqHk9Xb83A29UxxQT7v
	 r+LKTdMUeuD8ge4SW3LZEb7TV25+GZ7HvvalURB4=
Date: Fri, 06 Mar 2026 14:44:33 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch added to mm-new branch
Message-Id: <20260306224434.54BB1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: add damon_merge_two_regions() debug_sanity check
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch

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
Subject: mm/damon/core: add damon_merge_two_regions() debug_sanity check
Date: Fri, 6 Mar 2026 07:29:08 -0800

A data corruption could cause damon_merge_two_regions() creating zero
length DAMON regions.  Add a sanity check for that under
CONFIG_DAMON_DEBUG_SANITY.

Link: https://lkml.kernel.org/r/20260306152914.86303-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-add-damon_merge_two_regions-debug_sanity-check
+++ a/mm/damon/core.c
@@ -2473,6 +2473,21 @@ static void kdamond_apply_schemes(struct
 	mutex_unlock(&c->walk_control_lock);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_merge_two_regions(
+		struct damon_region *l, struct damon_region *r)
+{
+	/* damon_merge_two_regions() may created incorrect left region */
+	WARN_ONCE(l->ar.start >= l->ar.end, "l: %lu-%lu, r: %lu-%lu\n",
+			l->ar.start, l->ar.end, r->ar.start, r->ar.end);
+}
+#else
+static void damon_verify_merge_two_regions(
+		struct damon_region *l, struct damon_region *r)
+{
+}
+#endif
+
 /*
  * Merge two adjacent regions into one region
  */
@@ -2486,6 +2501,7 @@ static void damon_merge_two_regions(stru
 	l->nr_accesses_bp = l->nr_accesses * 10000;
 	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
 	l->ar.end = r->ar.end;
+	damon_verify_merge_two_regions(l, r);
 	damon_destroy_region(r, t);
 }
 
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

