Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C302C028F;
	Tue, 16 Sep 2025 04:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757996021; cv=none; b=lGcbMsbR3vbyE4xOcOR/5gEs4go4fBqDJYGb+pvQZuJGSSEADRzYv1EvcRrAJtNBn4/4vzPgHzxn6JL8bYjac4nhy0sgQ3sVLcwKiAWZ/NgGCg0K6E7WkHeU0olyczte3Zgil8DX+q+OWTbICgMSuniheOR/goCLQtArrULNv88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757996021; c=relaxed/simple;
	bh=ueWSX0OIMNV793/wPU8X3vLygfbgNOy+s9gGrQbQNc0=;
	h=Date:To:From:Subject:Message-Id; b=OjJqaB5dyG2FN/M6WkgkE8tMjwXvq10ly6SiGEFQd1IEVIRcp3hWOWZM94gialmveSltzyXq/oeCVHyPItbYqasLivIBhP61kEe7sw5J6YFBm2O6m2kN7LAhYHTtKHMsTYB/UnfmWbC1bV/FZ32++7q57XDPKST7kN8ICHteWh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1rZUCyyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1rZUCyyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DF4C4CEEB;
	Tue, 16 Sep 2025 04:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757996021;
	bh=ueWSX0OIMNV793/wPU8X3vLygfbgNOy+s9gGrQbQNc0=;
	h=Date:To:From:Subject:From;
	b=1rZUCyyiwRcIUnnCebi/z9rdslgCPtbcYp4ajadmaswufMemyLjFW4ZOQGCUuo9OP
	 sW9Gz2sB/bq6G/w9QXKlDwkzgNSZll8rMG0Fm5aG7LIkemJixJ7XbYIvxfP88v0LQ4
	 YYo0B1ymviJ0vKdLcpmp2sBRl0YqEARSmrfQy1WY=
Date: Mon, 15 Sep 2025 21:13:40 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,joshua.hahnjy@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-use-param_ctx-for-damon_attrs-staging.patch added to mm-unstable branch
Message-Id: <20250916041341.17DF4C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: use param_ctx for damon_attrs staging
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-lru_sort-use-param_ctx-for-damon_attrs-staging.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-use-param_ctx-for-damon_attrs-staging.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm/damon/lru_sort: use param_ctx for damon_attrs staging
Date: Mon, 15 Sep 2025 20:15:49 -0700

damon_lru_sort_apply_parameters() allocates a new DAMON context, stages
user-specified DAMON parameters on it, and commits to running DAMON
context at once, using damon_commit_ctx().  The code is, however, directly
updating the monitoring attributes of the running context.  And the
attributes are over-written by later damon_commit_ctx() call.  This means
that the monitoring attributes parameters are not really working.  Fix the
wrong use of the parameter context.

Link: https://lkml.kernel.org/r/20250916031549.115326-1-sj@kernel.org
Fixes: a30969436428 ("mm/damon/lru_sort: use damon_commit_ctx()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: <stable@vger.kernel.org>	[6.11+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-use-param_ctx-for-damon_attrs-staging
+++ a/mm/damon/lru_sort.c
@@ -219,7 +219,7 @@ static int damon_lru_sort_apply_paramete
 		goto out;
 	}
 
-	err = damon_set_attrs(ctx, &damon_lru_sort_mon_attrs);
+	err = damon_set_attrs(param_ctx, &damon_lru_sort_mon_attrs);
 	if (err)
 		goto out;
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-lru_sort-use-param_ctx-for-damon_attrs-staging.patch
mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero.patch
mm-damon-core-set-effective-quota-on-first-charge-window.patch
mm-damon-lru_sort-use-param_ctx-correctly.patch
docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements.patch
docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch
maintainers-rename-damon-section.patch

