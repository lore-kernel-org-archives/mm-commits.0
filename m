Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4F639B94A;
	Mon, 21 Sep 2026 19:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790018944; cv=none; b=q/Ubf9uRY2HKk50CxibvOZLMVAJjx4yYbODP1uIks/OFDxa4L/NT8Tiiv4VYGAFDj74pO8GmhXPDWUCIaYojbb59bJ5V2pCBncNCN02weu/88GMMn52t5+fxhReeSvx6JmqUT2pFn3m7zdwtYS1ib8MejKY2cLnPYJpPkjKIL4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790018944; c=relaxed/simple;
	bh=/zqAhZ6ZmATbRjUgB3nSfL79dTJ2lIPaH9WDZwj7u4k=;
	h=Date:To:From:Subject:Message-Id; b=QcztXsp4zCH+NYPjlsef2hAYCkGOyadr9f/IhZvfnyGycSoxFqgsU7vH0wm1RZ5SSf281Vt6M75aiRGWoai0A0MXOi+VoEh+foyo7sHwWFPUox/JEIzTCCA5WOeBjahDuAtOFkp/vMcYuOy2Z39RLEadTLpNbM2wdQQOkqeURg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zIXSaqw+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zIXSaqw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C611F00898;
	Mon, 21 Sep 2026 19:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790018942;
	bh=2yQSBB9+QfEe/7UUwe9jeZMdSJEApqsxiD8a6QZJ57E=;
	h=Date:To:From:Subject;
	b=zIXSaqw+6yEVpXrlGUtyNvXXA4ZQfYj7shgJzEZsALus2OKP3HNNXBogSsddi5ZRq
	 GzJUQWlKrNN8of7O+wdiNpo1EEGQkzbsiHVKXU4OLz7wH3Boypx6gJG6hB7wEmKVUh
	 BcbpCXMqr/PNut9XSbxygiJJB8CWBohpFb9+chRY=
Date: Mon, 21 Sep 2026 12:29:01 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,david@davidgow.net,brendan.higgins@linux.dev,donggeunyoo.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-charge-only-the-part-of-a-region-the-filter-left.patch added to mm-new branch
Message-Id: <20260921192902.72C611F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: charge only the part of a region the filter left
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-charge-only-the-part-of-a-region-the-filter-left.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-charge-only-the-part-of-a-region-the-filter-left.patch

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
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Subject: mm/damon/core: charge only the part of a region the filter left
Date: Mon, 21 Sep 2026 08:24:41 -0700

Patch series "mm/damon/core: fix the size charged for a filter-trimmed
region", v2.

An address range DAMOS filter that partially overlaps a monitoring region
splits it, so the scheme action reaches only one side of the boundary. 
damos_apply_scheme() reads the region size before that split and never
re-reads it, so the quota charge and schemes/<S>/stats/sz_tried account
for the whole original region.

Patch 1 re-reads the size after the core filters have run.  Patch 2 adds
KUnit coverage for what the function charges and reports, for the trimmed
cases and for the cases that must not change.


This patch (of 2):

An address range DAMOS filter that partially overlaps a monitoring region
splits the region at the filter boundary, so the scheme action is applied
to only one side of it.  damos_apply_scheme() reads the region size once
on entry, before damos_core_filter_out() performs that split.

The quota charge and the statistics update therefore account for the
region as it was before the trim.  schemes/<S>/stats/sz_tried counts
memory the filter excluded, which Documentation/mm/damon/design.rst says
is not counted as tried, and with quotas/bytes set the excluded part is
charged against the budget, throttling the scheme to a fraction of what
was configured.

User impact is that DAMOS could unexpectedly slowly run, due to
over-charged quota.  DAMOS stat could also be confusing.  No critical
events such as crashes or leask happen.

Re-read the region size after the core filters have run.

Link: https://lore.kernel.org/20260921152443.80132-1-sj@kernel.org
Link: https://lore.kernel.org/20260921152443.80132-2-sj@kernel.org
Fixes: ab9bda001b68 ("mm/damon/core: introduce address range type damos filter")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <david@davidgow.net>
Cc: <stable@vger.kernel.org>
---

 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c~mm-damon-core-charge-only-the-part-of-a-region-the-filter-left
+++ a/mm/damon/core.c
@@ -2784,6 +2784,7 @@ static void damos_apply_scheme(struct da
 		}
 		if (damos_core_filter_out(c, t, r, s))
 			return;
+		sz = damon_sz_region(r);
 		ktime_get_coarse_ts64(&begin);
 		trace_damos_before_apply(cidx, sidx, tidx, r, nr_accesses,
 				damon_nr_regions(t), do_trace);
_

Patches currently in -mm which might be from donggeunyoo.kernel@gmail.com are

mm-damon-core-charge-only-the-part-of-a-region-the-filter-left.patch
mm-damon-tests-core-kunit-test-the-size-charged-for-a-filter-trimmed-region.patch

