Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40EF1EEE6
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 03:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765855671; cv=none; b=BB82kN9QixBKPc70+EOpHfGZtV/IXXUxwW2pbySb2cwS2S593VSzT3P3+aEEY5fDZ67YfQJx3MG6lgfv7YGbcdCJac6SV+1mmUqVijXOp+6QhN6ttWpOXxSOCaOZxeEV8FSROb9KBQihqlM5XKmkbaIB8xd6lu3XjggnRKGss1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765855671; c=relaxed/simple;
	bh=Hkj+sEgVbEbUEft6YhjbqlmOEFnzznaGK09bBW13Ca4=;
	h=Date:To:From:Subject:Message-Id; b=K84/rI/rZfxc5GnUxnO3/zLRifI2OrtfiEHnGl0eu8UaWtmmqCE28malU4ZqxRSHE49c5JYepnJE+LVebD0/6+E3g9SB+xDF6pdfHdOpROhxu+pbRPZaj60+vjZevSzWKv75G5YdV5UyQAvPUE4H07F7J801b8fMF6xpVzjHuRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lyUxdAN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lyUxdAN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B5FC4CEF5;
	Tue, 16 Dec 2025 03:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765855671;
	bh=Hkj+sEgVbEbUEft6YhjbqlmOEFnzznaGK09bBW13Ca4=;
	h=Date:To:From:Subject:From;
	b=lyUxdAN0HtlSSDG8701u3vNl5PrKeaRrPIXAxIBNFZ7wntO1m/iObtfwwf/mX65gh
	 NrJhBW/xRd/izetR4xRMbboMP6k+xIO0SMfmFGd82n85CF17rDebEETO7vP2HsLqaM
	 f+OQR9G4zyxfdREbSyyAj6N5xLohJuVmqWtq/CyI=
Date: Mon, 15 Dec 2025 19:27:50 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-fix-wasteful-cpu-calls-by-skipping-non-existent-targets.patch added to mm-new branch
Message-Id: <20251216032751.46B5FC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: fix wasteful CPU calls by skipping non-existent targets
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-fix-wasteful-cpu-calls-by-skipping-non-existent-targets.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-fix-wasteful-cpu-calls-by-skipping-non-existent-targets.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Enze Li <lienze@kylinos.cn>
Subject: mm/damon/core: fix wasteful CPU calls by skipping non-existent targets
Date: Wed, 10 Dec 2025 13:25:08 +0800

Currently, DAMON does not proactively clean up invalid monitoring targets
during its runtime.  When some monitored processes exit, DAMON continues
to make the following unnecessary function calls,

  --damon_for_each_target--
  --damon_for_each_region--
      damon_do_apply_schemes
        damos_apply_scheme
          damon_va_apply_scheme
            damos_madvise
              damon_get_mm

it is only in the damon_get_mm() function that it may finally discover the
target no longer exists, which wastes CPU resources.  A simple idea is to
check for the existence of monitoring targets within the
kdamond_need_stop() function and promptly clean up non-existent targets.

However, SJ pointed out that this approach is problematic because the
online commit logic incorrectly uses list indices to update the monitoring
state.  This can lead to data loss if the target list is changed
concurrently.  Meanwhile, SJ suggests checking for target existence at the
damon_for_each_target level, and if a target does not exist, simply skip
it and proceed to the next one.

Link: https://lkml.kernel.org/r/20251210052508.264433-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-fix-wasteful-cpu-calls-by-skipping-non-existent-targets
+++ a/mm/damon/core.c
@@ -2266,6 +2266,9 @@ static void kdamond_apply_schemes(struct
 
 	mutex_lock(&c->walk_control_lock);
 	damon_for_each_target(t, c) {
+		if (c->ops.target_valid && c->ops.target_valid(t) == false)
+			continue;
+
 		damon_for_each_region_safe(r, next_r, t)
 			damon_do_apply_schemes(c, t, r);
 	}
_

Patches currently in -mm which might be from lienze@kylinos.cn are

mm-damon-core-fix-memory-leak-of-repeat-mode-damon_call_control-objects.patch
mm-damon-core-fix-wasteful-cpu-calls-by-skipping-non-existent-targets.patch

