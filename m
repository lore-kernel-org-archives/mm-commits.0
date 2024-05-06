Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACD815ADAC
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 19:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715025382; cv=none; b=PPrN8ooXR29Cs1S30dAAcl4JxVO4gmCqdXbHQSN/YhtMpIeeDE5wi3Et+MFYCpOL4lT/clJrOgBdBdMOCSiObeMZJ1NXMOrGkRpQN8LbR5eszwzyulC2UWLXZeU63a8PX+IjoI/ugptSyJncl1Aq7RGsP06C/FdtwVyb7NvDPCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715025382; c=relaxed/simple;
	bh=Kh5A+97gYKe1bImSE0TvHZR+62L/FRQe8X62Ae/oZuU=;
	h=Date:To:From:Subject:Message-Id; b=okUYwePBamlHRusOontMazFec1Pix3QlLyhIKN/PMkFVVmAhLH70KTWa+5WkQPb70u8lCmvCmTPy2voX/638bXSUyR/tWFoCkH9MdzNOSOY4tMCxfbW9b1dOJgUXBAnAfSWxpGjx0Gz130F17rNHz3M+KqOI369+qgjt4swmdH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OUprVtxR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OUprVtxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40EDC116B1;
	Mon,  6 May 2024 19:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715025381;
	bh=Kh5A+97gYKe1bImSE0TvHZR+62L/FRQe8X62Ae/oZuU=;
	h=Date:To:From:Subject:From;
	b=OUprVtxRc/EEwzjInkNjLgUe3X9s2xanMSx/j5yIuHolw11sBkuOLCSBNpDH5Jtsq
	 7K/UMLzCgJ4wIdnYq+YpU4CAGFXjIO87AB+ZNaeQtJMwWWG/mFDBvWYPVTjFNtY8xO
	 DOK42fVaFTObTKNT34GQQ2LAWudHGjIfIganlK50=
Date: Mon, 06 May 2024 12:56:21 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,yorha.op@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-fix-return-value-from-damos_wmark_metric_value.patch added to mm-unstable branch
Message-Id: <20240506195621.D40EDC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: fix return value from damos_wmark_metric_value
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-fix-return-value-from-damos_wmark_metric_value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-fix-return-value-from-damos_wmark_metric_value.patch

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
From: Alex Rusuf <yorha.op@gmail.com>
Subject: mm/damon/core: fix return value from damos_wmark_metric_value
Date: Mon, 6 May 2024 11:02:38 -0700

damos_wmark_metric_value's return value is 'unsigned long', so returning
-EINVAL as 'unsigned long' may turn out to be very different from the
expected one (using 2's complement) and treat as usual matric's value. 
So, fix that, checking if returned value is not 0.

Link: https://lkml.kernel.org/r/20240506180238.53842-1-sj@kernel.org
Fixes: ee801b7dd782 ("mm/damon/schemes: activate schemes based on a watermarks mechanism")
Signed-off-by: Alex Rusuf <yorha.op@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-fix-return-value-from-damos_wmark_metric_value
+++ a/mm/damon/core.c
@@ -1481,12 +1481,14 @@ static bool kdamond_need_stop(struct dam
 	return true;
 }
 
-static unsigned long damos_wmark_metric_value(enum damos_wmark_metric metric)
+static int damos_get_wmark_metric_value(enum damos_wmark_metric metric,
+					unsigned long *metric_value)
 {
 	switch (metric) {
 	case DAMOS_WMARK_FREE_MEM_RATE:
-		return global_zone_page_state(NR_FREE_PAGES) * 1000 /
+		*metric_value = global_zone_page_state(NR_FREE_PAGES) * 1000 /
 		       totalram_pages();
+		return 0;
 	default:
 		break;
 	}
@@ -1501,10 +1503,9 @@ static unsigned long damos_wmark_wait_us
 {
 	unsigned long metric;
 
-	if (scheme->wmarks.metric == DAMOS_WMARK_NONE)
+	if (damos_get_wmark_metric_value(scheme->wmarks.metric, &metric))
 		return 0;
 
-	metric = damos_wmark_metric_value(scheme->wmarks.metric);
 	/* higher than high watermark or lower than low watermark */
 	if (metric > scheme->wmarks.high || scheme->wmarks.low > metric) {
 		if (scheme->wmarks.activated)
_

Patches currently in -mm which might be from yorha.op@gmail.com are

mm-damon-core-fix-return-value-from-damos_wmark_metric_value.patch

