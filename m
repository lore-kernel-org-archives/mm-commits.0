Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACCC347FED
	for <mm-commits@vger.kernel.org>; Fri, 27 Feb 2026 20:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772224047; cv=none; b=G5wcPToB0QjALLKxmBqjoCcYvTF1Y9a6e9PzI6jB69+FiC02ghKHrX79rmWCTozS3Xg3WNfF61GkAX1BRrxae/qaxo4zYjfqIOvCFbpmtVClmcjoWRYyLMEZeyIXvkLzSvauPiIv6rc4Ar5e2cXpwo5VFVIWvKO1kFjFnlA/vR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772224047; c=relaxed/simple;
	bh=K2EJbtwSU6XOGGWykTVfJYImY5lkENGb5M+SSUXKtnA=;
	h=Date:To:From:Subject:Message-Id; b=b8I6cPV+KEWy08NsLMQG5p/7ErP78Azcu9xkXxiK7TX5Jnq+UNpq3ZMtGagln6ec17ZL2mLQ/TAGRKJXhP2/GWV0JpZXAHZFFXU6LybguOveMupmnMDkWDQLVSMfmDLykyMlIqZX0vo8r0mEvGl8x5vwHPrmWxL/yDFTfltBI2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p8EocNU/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p8EocNU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879F7C116C6;
	Fri, 27 Feb 2026 20:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772224046;
	bh=K2EJbtwSU6XOGGWykTVfJYImY5lkENGb5M+SSUXKtnA=;
	h=Date:To:From:Subject:From;
	b=p8EocNU/sKV1cr9/7ACH42g3JYFc5txr/uMOzN9htmaJ8i+Uz0agCSu3aG0LYrz/a
	 /GomHBuEYByaOJt3M8JmR+xRwUHo4+hEQawWhaAenp+0sSfu5zwiZJXNIkWdxueY2f
	 /eQv+OW67a3x3LkuBqGEwRVCyylzSAii+PAbwa18=
Date: Fri, 27 Feb 2026 12:27:26 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-set-quota-score-histogram-with-core-filters.patch added to mm-new branch
Message-Id: <20260227202726.879F7C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: set quota-score histogram with core filters
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-set-quota-score-histogram-with-core-filters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-set-quota-score-histogram-with-core-filters.patch

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
Subject: mm/damon/core: set quota-score histogram with core filters
Date: Fri, 27 Feb 2026 09:06:20 -0800

Patch series "mm/damon/core: improve DAMOS quota efficiency for core layer
filters".

Improve two below problematic behaviors of DAMOS that makes it less
efficient when core layer filters are used.

DAMOS generates the under-quota regions prioritization-purpose access
temperature histogram [1] with only the scheme target access pattern.  The
DAMOS filters are ignored on the histogram, and this can result in the
scheme not applied to eligible regions.  For working around this, users
had to use separate DAMON contexts.  The memory tiering approaches are
such examples.

DAMOS splits regions that intersect with address filters, so that only
filtered-out part of the region is skipped.  But, the implementation is
skipping the other part of the region that is not filtered out, too.  As a
result, DAMOS can work slower than expected.

Improve the two inefficient behaviors with two patches, respectively. 
Read the patches for more details about the problem and how those are
fixed.


This patch (of 2):

The histogram for under-quota region prioritization [1] is made for all
regions that are eligible for the DAMOS target access pattern.  When there
are DAMOS filters, the prioritization-threshold access temperature that
generated from the histogram could be inaccurate.

For example, suppose there are three regions.  Each region is 1 GiB.  The
access temperature of the regions are 100, 50, and 0.  And a DAMOS scheme
that targets _any_ access temperature with quota 2 GiB is being used.  The
histogram will look like below:

    temperature	size of regions having >=temperature temperature
    0		3 GiB
    50		2 GiB
    100		1 GiB

Based on the histogram and the quota (2 GiB), DAMOS applies the action to
only the regions having >=50 temperature.  This is all good.

Let's suppose the region of temperature 50 is excluded by a DAMOS filter. 
Regardless of the filter, DAMOS will try to apply the action on only
regions having >=50 temperature.  Because the region of temperature 50 is
filtered out, the action is applied to only the region of temperature 100.
Worse yet, suppose the filter is excluding regions of temperature 50 and
100.  Then no action is really applied to any region, while the region of
temperature 0 is there.

People used to work around this by utilizing multiple contexts, instead of
the core layer DAMOS filters.  For example, DAMON-based memory tiering
approaches including the quota auto-tuning based one [2] are using a DAMON
context per NUMA node.  If the above explained issue is effectively
alleviated, those can be configured again to run with single context and
DAMOS filters for applying the promotion and demotion to only specific
NUMA nodes.

Alleviate the problem by checking core DAMOS filters when generating the
histogram.  The reason to check only core filters is the overhead.  While
core filters are usually for coarse-grained filtering (e.g.,
target/address filters for process, NUMA, zone level filtering), operation
layer filters are usually for fine-grained filtering (e.g., for anon
page).  Doing this for operation layer filters would cause significant
overhead.  There is no known use case that is affected by the operation
layer filters-distorted histogram problem, though.  Do this for only core
filters for now.  We will revisit this for operation layer filters in
future.  We might be able to apply a sort of sampling based operation
layer filtering.

After this fix is applied, for the first case that there is a DAMOS filter
excluding the region of temperature 50, the histogram will be like below:

    temperature	size of regions having >=temperature temperature
    0		2 GiB
    100		1 GiB

And DAMOS will set the temperature threshold as 0, allowing both regions
of temperatures 0 and 100 be applied.

For the second case that there is a DAMOS filter excluding the regions of
temperature 50 and 100, the histogram will be like below:

    temperature	size of regions having >=temperature temperature
    0		1 GiB

And DAMOS will set the temperature threshold as 0, allowing the region of
temperature 0 be applied.

[1] 'Prioritization' section of Documentation/mm/damon/design.rst
[2] commit 0e1c773b501f ("mm/damon/core: introduce damos quota goal
    metrics for memory node utilization")

Link: https://lkml.kernel.org/r/20260227170623.95384-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260227170623.95384-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-set-quota-score-histogram-with-core-filters
+++ a/mm/damon/core.c
@@ -2317,6 +2317,8 @@ static void damos_adjust_quota(struct da
 		damon_for_each_region(r, t) {
 			if (!__damos_valid_target(r, s))
 				continue;
+			if (damos_core_filter_out(c, t, r, s))
+				continue;
 			score = c->ops.get_scheme_score(c, r, s);
 			c->regions_score_histogram[score] +=
 				damon_sz_region(r);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-set-quota-score-histogram-with-core-filters.patch
mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch

