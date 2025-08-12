Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0309278E42;
	Tue, 12 Aug 2025 01:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754962915; cv=none; b=Uhll5OqiOlAllI+k2WV33Y3zpJfL7zwKUNOVo/eQOErW/tqY/vj37XZ4iwepFIfCEFvU+fWwTHoNiqW8TaChice/Fhu5WlNl0BReLosrhRXgtNeGnB5bn5wiEnc0iFzYehKI7C+vnX6e3RYurk8NNjQrepKbsLJtVb+3/HAIOe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754962915; c=relaxed/simple;
	bh=rOgYXPbOuMb7HER27UokJxfXGzUuXfjQMC12hj/ITbY=;
	h=Date:To:From:Subject:Message-Id; b=ljwRwUxX2DdmgVqYBF2dwXilCcs3e6mp6O/kmL+39CyQvrVR8dCKN0vUwKFaA1L7+JJaGdF8tc9CcOPsXjDtxzj8mSvDkbWIh28QqayULB15xWb88bvSA2vdAd/sCK1+SHkSdKc7ySeM6cGpw1vuaTmlXauS1ZREsRAAPJVGe+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FY+8bIM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FY+8bIM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C5FC4CEF5;
	Tue, 12 Aug 2025 01:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754962914;
	bh=rOgYXPbOuMb7HER27UokJxfXGzUuXfjQMC12hj/ITbY=;
	h=Date:To:From:Subject:From;
	b=FY+8bIM432uN1ylRwAGQxKgQL0TWIIPWNLQo9WuEqxI2+dPT2tIDeEvSEtYRdhVfo
	 5UBeVVSoFiCsblSeDi6HCU0nZLo93PL7Cw/5S/kGn6NXbLSE7JIumFXb9XytnU3R9M
	 LgAQGpVB/Wn4n/7N0pC8GycksZ2bWn/zjGmm69Ko=
Date: Mon, 11 Aug 2025 18:41:53 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-fix-commit_ops_filters-by-using-correct-nth-function.patch added to mm-hotfixes-unstable branch
Message-Id: <20250812014154.51C5FC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: fix commit_ops_filters by using correct nth function
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-fix-commit_ops_filters-by-using-correct-nth-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-fix-commit_ops_filters-by-using-correct-nth-function.patch

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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/damon/core: fix commit_ops_filters by using correct nth function
Date: Sun, 10 Aug 2025 21:42:01 +0900

damos_commit_ops_filters() incorrectly uses damos_nth_filter() which
iterates core_filters.  As a result, performing a commit unintentionally
corrupts ops_filters.

Add damos_nth_ops_filter() which iterates ops_filters.  Use this function
to fix issues caused by wrong iteration.

Link: https://lkml.kernel.org/r/20250810124201.15743-1-ekffu200098@gmail.com
Fixes: 3607cc590f18 ("mm/damon/core: support committing ops_filters") # 6.15.x
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-fix-commit_ops_filters-by-using-correct-nth-function
+++ a/mm/damon/core.c
@@ -845,6 +845,18 @@ static struct damos_filter *damos_nth_fi
 	return NULL;
 }
 
+static struct damos_filter *damos_nth_ops_filter(int n, struct damos *s)
+{
+	struct damos_filter *filter;
+	int i = 0;
+
+	damos_for_each_ops_filter(filter, s) {
+		if (i++ == n)
+			return filter;
+	}
+	return NULL;
+}
+
 static void damos_commit_filter_arg(
 		struct damos_filter *dst, struct damos_filter *src)
 {
@@ -908,7 +920,7 @@ static int damos_commit_ops_filters(stru
 	int i = 0, j = 0;
 
 	damos_for_each_ops_filter_safe(dst_filter, next, dst) {
-		src_filter = damos_nth_filter(i++, src);
+		src_filter = damos_nth_ops_filter(i++, src);
 		if (src_filter)
 			damos_commit_filter(dst_filter, src_filter);
 		else
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-damon-core-fix-commit_ops_filters-by-using-correct-nth-function.patch
mm-damon-update-expired-description-of-damos_action.patch
docs-mm-damon-design-fix-typo-s-sz_trtied-sz_tried.patch

