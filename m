Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACEBF9D9;
	Fri,  1 Nov 2024 00:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730420725; cv=none; b=k6ptJPZ6Ed7KsbV+q3ZIwN2dYpiYlTtI9/JJDAoSPmibnO2Aw0ZQPwMmaRYqh+247y45vRecOyFiqzxA9xBa29ZlOenZ+Rum9a7A5QchIvFlPMc6GPOYP1SwBF6hvUot8BEig4aW9L/DuGsQiB0AYBBydZKSv+ldURQK/kReauI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730420725; c=relaxed/simple;
	bh=pvDk1rl72iEa2RQgiczHayeM9CkrAV0+3yzUQur/0Js=;
	h=Date:To:From:Subject:Message-Id; b=PYX6LWxLeiWwP1qcUxw6DZEM/l54RP3DZZ1OKuAkRE9E4ze3lrZoBZsX13ZMKCcrkZG3Zf9P04KXdOgDRRl52yQFqFRStsZnidvjJVI7joLicjvmvzWPeDFXjFKm6gaPk90i7iglQ/HSTV648npndX73kWkmzigzBa28kTyiUQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t1UHqIfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t1UHqIfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76F7C4CEDA;
	Fri,  1 Nov 2024 00:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730420725;
	bh=pvDk1rl72iEa2RQgiczHayeM9CkrAV0+3yzUQur/0Js=;
	h=Date:To:From:Subject:From;
	b=t1UHqIfRJfMnCFhr4NvmqEog8QjcDjX7xZwTtiY6bLksKSjy2TU2cnCIpHr2MRG4H
	 zH0l/HsC+n0w+gU4mAwqsoByQx2YxGlY4z5Kfs5hVluNwwZHrwVvqadtZNthhJBR3K
	 hhVKFtHWUnfByoQXkUpeFJXYIOaBoBnpwdXgdTyM=
Date: Thu, 31 Oct 2024 17:25:24 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-handle-zero-schemes-apply-interval.patch added to mm-hotfixes-unstable branch
Message-Id: <20241101002524.E76F7C4CEDA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: handle zero schemes apply interval
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-handle-zero-schemes-apply-interval.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-handle-zero-schemes-apply-interval.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: handle zero schemes apply interval
Date: Thu, 31 Oct 2024 11:37:57 -0700

DAMON's logics to determine if this is the time to apply damos schemes
assumes next_apply_sis is always set larger than current
passed_sample_intervals.  And therefore assume continuously incrementing
passed_sample_intervals will make it reaches to the next_apply_sis in
future.  The logic hence does apply the scheme and update next_apply_sis
only if passed_sample_intervals is same to next_apply_sis.

If Schemes apply interval is set as zero, however, next_apply_sis is set
same to current passed_sample_intervals, respectively.  And
passed_sample_intervals is incremented before doing the next_apply_sis
check.  Hence, next_apply_sis becomes larger than next_apply_sis, and the
logic says it is not the time to apply schemes and update next_apply_sis. 
In other words, DAMON stops applying schemes until passed_sample_intervals
overflows.

Based on the documents and the common sense, a reasonable behavior for
such inputs would be applying the schemes for every sampling interval. 
Handle the case by removing the assumption.

Link: https://lkml.kernel.org/r/20241031183757.49610-3-sj@kernel.org
Fixes: 42f994b71404 ("mm/damon/core: implement scheme-specific apply interval")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.7.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-handle-zero-schemes-apply-interval
+++ a/mm/damon/core.c
@@ -1412,7 +1412,7 @@ static void damon_do_apply_schemes(struc
 	damon_for_each_scheme(s, c) {
 		struct damos_quota *quota = &s->quota;
 
-		if (c->passed_sample_intervals != s->next_apply_sis)
+		if (c->passed_sample_intervals < s->next_apply_sis)
 			continue;
 
 		if (!s->wmarks.activated)
@@ -1622,7 +1622,7 @@ static void kdamond_apply_schemes(struct
 	bool has_schemes_to_apply = false;
 
 	damon_for_each_scheme(s, c) {
-		if (c->passed_sample_intervals != s->next_apply_sis)
+		if (c->passed_sample_intervals < s->next_apply_sis)
 			continue;
 
 		if (!s->wmarks.activated)
@@ -1642,9 +1642,9 @@ static void kdamond_apply_schemes(struct
 	}
 
 	damon_for_each_scheme(s, c) {
-		if (c->passed_sample_intervals != s->next_apply_sis)
+		if (c->passed_sample_intervals < s->next_apply_sis)
 			continue;
-		s->next_apply_sis +=
+		s->next_apply_sis = c->passed_sample_intervals +
 			(s->apply_interval_us ? s->apply_interval_us :
 			 c->attrs.aggr_interval) / sample_interval;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-handle-zero-aggregationops_update-intervals.patch
mm-damon-core-handle-zero-schemes-apply-interval.patch
selftests-damon-huge_count_read_write-remove-unnecessary-debugging-message.patch
selftests-damon-_debugfs_common-hide-expected-error-message-from-test_write_result.patch
selftests-damon-debugfs_duplicate_context_creation-hide-errors-from-expected-file-write-failures.patch
mm-damon-kconfig-update-dbgfs_kunit-prompt-copy-for-sysfs_kunit.patch
mm-damon-tests-dbgfs-kunit-fix-the-header-double-inclusion-guarding-ifdef-comment.patch

