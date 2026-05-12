Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7214C386C31
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 21:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778622038; cv=none; b=FiiDuLmskBrRcbJrpGARQm79Rl+VsCHAHKQQ9Pbzc6UUKzUV/xjaqnRlAHtjNwBx7FMS2/lZ50tS1BqRqGWmNSRF1pPsXJZ+YxmGtnLLvH/4oIKq+WvfgutVMjYpKEhQLdzJVxfjJJu7QJRkmRXw1/Iz2kQuTGjXjJywy1nSaGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778622038; c=relaxed/simple;
	bh=zW6yY7gJ3mXXnLlIOEgI6+vX6GDkneqQWXDGgy0+Afk=;
	h=Date:To:From:Subject:Message-Id; b=LqP9I1YVcf1VtI7OMhktT7HVCT5dM9JyDdhFd0pwaNOTgZUg/fCZbus/I4Ofe4kgsBjOxWxngMYU07twqrBRYIKyMJX9/oqdamqkiVz3P3DD+ih6KFVQdL3bx4D96iZBX333ywfKN6QMXiOJAQ5RMh5aOg7se63FuUgKJiZ9nA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FvN3Q3vC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FvN3Q3vC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172FEC2BCB0;
	Tue, 12 May 2026 21:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778622038;
	bh=zW6yY7gJ3mXXnLlIOEgI6+vX6GDkneqQWXDGgy0+Afk=;
	h=Date:To:From:Subject:From;
	b=FvN3Q3vCtgb7EL9g/pFdwsyDFQlP8bfvGXW0yD6BSeG5aoIOHRd35J4tMiUAp7P/T
	 hWwVMImdTb8NgnZxW0130hqsoaiX0Ap1owbyKloykmh3UZACgfofdG/C7mG1EBObA7
	 mpNSlOGtdfr+eiV3fmmo8JPHOnuSsWG2CBJIheUs=
Date: Tue, 12 May 2026 14:40:37 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-validate-min_region_size-to-be-power-of-2.patch added to mm-new branch
Message-Id: <20260512214038.172FEC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/reclaim: validate min_region_size to be power of 2
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-reclaim-validate-min_region_size-to-be-power-of-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-validate-min_region_size-to-be-power-of-2.patch

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
From: Liew Rui Yan <aethernet65535@gmail.com>
Subject: mm/damon/reclaim: validate min_region_size to be power of 2
Date: Fri, 1 May 2026 09:37:50 +0800

Problem
=======
When a user sets an invalid 'addr_unit' (e.g., 3) via DAMON_RECLAIM,
'min_region_sz' becomes a non-power-of-2 value. While damon_commit_ctx()
correctly detects this and returns -EINVAL, it sets the
'maybe_corrupted' flag during this process.

This flag causes the running kdamond to terminate. While the termination
is a safety measure, it is suboptimal in this case because the error is
just a simple invalid input from the user, which shouldn't neccessitate
stopping the kdamond.

Reproduction
============
1. Enable DAMON_RECLAIM
2. Set addr_unit=3
3. Commit inputs via 'commit_inputs'
4. Observe kdamond termination

Solution
========
Add an early validation in damon_reclaim_apply_parameters() to check
'min_region_sz' before any state change occurs. If it is non-power-of-2,
return -EINVAL immediately, preventing 'maybe_corrupted' from being set.

Link: https://lore.kernel.org/20260501013750.71704-3-aethernet65535@gmail.com
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-validate-min_region_size-to-be-power-of-2
+++ a/mm/damon/reclaim.c
@@ -210,6 +210,11 @@ static int damon_reclaim_apply_parameter
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
+	if (!is_power_of_2(param_ctx->min_region_sz)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (!damon_reclaim_mon_attrs.aggr_interval) {
 		err = -EINVAL;
 		goto out;
_

Patches currently in -mm which might be from aethernet65535@gmail.com are

mm-damon-ops-common-optimize-damon_hot_score-using-ilog2.patch
mm-damon-add-synchronous-commit-for-commit_inputs.patch
mm-damon-lru_sort-validate-min_region_size-to-be-power-of-2.patch
mm-damon-reclaim-validate-min_region_size-to-be-power-of-2.patch

