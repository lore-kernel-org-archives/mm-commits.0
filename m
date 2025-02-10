Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDE8260A2B
	for <mm-commits@vger.kernel.org>; Mon, 10 Feb 2025 23:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739231012; cv=none; b=YYoSRhy62SHMEDQf5KXlHUOvOyEZcXNeTXDjwyFVp7aVaG65/16gIiA1huM/QFFbuWSAnEnbQiAxR5c09lvcv4FXGnDu9R2Jxpq4/ZjEo6oA+jkyaD1Y0SNr2wUx820peY/K2w7xYq7bAXgM8c8vGHiI+rMD+gh07JyhCzut/Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739231012; c=relaxed/simple;
	bh=B/6RFwJPAU5h/j1ht2Hz+arSYOpjv9Nm2zmbtgGGaXM=;
	h=Date:To:From:Subject:Message-Id; b=POMS2HwN564P6XqK2Tnqzv3VmaEABqdQ0x0RSJZ38VV6m6rIj2uD1OxkbNiD2y4HgUE5j8kJpmOxhyQQhDXXvnlfhziJZCVQRCcQrQfjv6m8Bw5EFvCHROiWR1XA6LbHWmDv0up8sGMAtXhf6Fkg9XSkSN4wjewNR6Yba+ghfkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b30YuTcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b30YuTcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B033C4CED1;
	Mon, 10 Feb 2025 23:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739231011;
	bh=B/6RFwJPAU5h/j1ht2Hz+arSYOpjv9Nm2zmbtgGGaXM=;
	h=Date:To:From:Subject:From;
	b=b30YuTcNlWJdPjGQFBD9uZU9cuG7TTyvmzxQ+P01GXEMJSm8ndt7Bs3umGIr0EipA
	 KbafcLC1EqffeWFdxwBvtp81n0+IlCKE33ZKyUmrzg8UDeZqwbapLEm8fgvAcgA934
	 y/U88l6p6SFngWdCY9FmNjZXhuR0Ztq3Hq7hfpXw=
Date: Mon, 10 Feb 2025 15:43:30 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch added to mm-unstable branch
Message-Id: <20250210234331.3B033C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: do damos walking in entire regions granularity
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch

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
Subject: mm/damon/core: do damos walking in entire regions granularity
Date: Mon, 10 Feb 2025 10:27:36 -0800

damos_walk_control can be installed while DAMOS is walking the regions. 
This means the walk callback function invocations can be started from a
region at the middle of the regions list.  This makes it hard to be used
reliably.  Particularly, DAMOS tried regions update for collecting
monitoring results gets problematic results.  Increase the
walk_control_lock critical section to do walking in entire regions
granularity.

Link: https://lkml.kernel.org/r/20250210182737.134994-4-sj@kernel.org
Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-do-damos-walking-in-entire-regions-granularity
+++ a/mm/damon/core.c
@@ -1456,11 +1456,10 @@ static void damos_walk_call_walk(struct
 	if (s->walk_completed)
 		return;
 
-	mutex_lock(&ctx->walk_control_lock);
 	control = ctx->walk_control;
-	mutex_unlock(&ctx->walk_control_lock);
 	if (!control)
 		return;
+
 	control->walk_fn(control->data, ctx, t, r, s, sz_filter_passed);
 }
 
@@ -1480,9 +1479,7 @@ static void damos_walk_complete(struct d
 	struct damos *siter;
 	struct damos_walk_control *control;
 
-	mutex_lock(&ctx->walk_control_lock);
 	control = ctx->walk_control;
-	mutex_unlock(&ctx->walk_control_lock);
 	if (!control)
 		return;
 
@@ -1496,9 +1493,7 @@ static void damos_walk_complete(struct d
 		siter->walk_completed = false;
 
 	complete(&control->completion);
-	mutex_lock(&ctx->walk_control_lock);
 	ctx->walk_control = NULL;
-	mutex_unlock(&ctx->walk_control_lock);
 }
 
 /*
@@ -1845,6 +1840,7 @@ static void kdamond_apply_schemes(struct
 	if (!has_schemes_to_apply)
 		return;
 
+	mutex_lock(&c->walk_control_lock);
 	damon_for_each_target(t, c) {
 		damon_for_each_region_safe(r, next_r, t)
 			damon_do_apply_schemes(c, t, r);
@@ -1859,6 +1855,7 @@ static void kdamond_apply_schemes(struct
 			 c->attrs.aggr_interval) / sample_interval;
 		s->last_applied = NULL;
 	}
+	mutex_unlock(&c->walk_control_lock);
 }
 
 /*
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch
mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch
mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch
mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch
mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch

