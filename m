Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381FF1AF4E9;
	Thu,  2 Apr 2026 01:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775092119; cv=none; b=CCKgcRt51NpZryJXqPI31bx5j43XeovWIILLsPeGxn+Xxw6jhon+sZ0irEwXfEE4ITyBP3Y9EXV8eY9LXoJ4LygPxrBDBPZZIKbhWCkfvAY1nAZ3d2efp87Rqojs+5Wn/xkP41u6AoWYaiV7tvK51zOy0qrqz6Ic+y1w7UHoSMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775092119; c=relaxed/simple;
	bh=+scDrCV6gPu/P0iIvP+wa0Uhct0oB6MP3+KoELwpydM=;
	h=Date:To:From:Subject:Message-Id; b=RYZX9N7rrZhrkDelNTkAFqIvmaqq7crmxbX2OywHgKuwvOlgVVYNGnV3ULZGpwmKEEGeSlyup59TPPhY0KnJAwCtFfY9iTLEOiX8zThZvJve7n5tIe7i3VMUfialDtfZQm3u+89F4xiUg4hTLTkdtYzcsVhmpSJM40jy6n5nTp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MdmqkhE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MdmqkhE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3801C4CEF7;
	Thu,  2 Apr 2026 01:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775092118;
	bh=+scDrCV6gPu/P0iIvP+wa0Uhct0oB6MP3+KoELwpydM=;
	h=Date:To:From:Subject:From;
	b=MdmqkhE75riKheStfuqPUlmq+jfF+DNeAZWr9pHf22M2ImRTm0WjZC7YMMHhwoXRs
	 vuqrdAaykNHIUr44/iDS7cIUVjkgicHrj9pr5fFQcOEgYQUU0UImT5DmQhnY+aMr7Q
	 yThJKl4zYxWwTBoZE1ogTgrov5scHhjdc3L3Svls=
Date: Wed, 01 Apr 2026 18:08:38 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-stat-deallocate-damon_call-failure-leaking-damon_ctx.patch added to mm-hotfixes-unstable branch
Message-Id: <20260402010838.C3801C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-stat-deallocate-damon_call-failure-leaking-damon_ctx.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-stat-deallocate-damon_call-failure-leaking-damon_ctx.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
Date: Wed, 1 Apr 2026 18:04:55 -0700

DAMON_STAT does not deallocate its dynamically allocated damon_ctx object
when damon_call() is failed.  As a result, the memory is leaked.  Check
the failure and deallocate the damon_ctx object.

The issue was discovered [1] by sashiko.


Link: https://lkml.kernel.org/r/20260402010457.66860-1-sj@kernel.org
Link: https://lore.kernel.org/20260401012428.86694-1-sj@kernel.org [1]
Fixes: 405f61996d9d ("mm/damon/stat: use damon_call() repeat mode instead of damon_callback")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/damon/stat.c~mm-damon-stat-deallocate-damon_call-failure-leaking-damon_ctx
+++ a/mm/damon/stat.c
@@ -254,7 +254,12 @@ static int damon_stat_start(void)
 
 	damon_stat_last_refresh_jiffies = jiffies;
 	call_control.data = damon_stat_context;
-	return damon_call(damon_stat_context, &call_control);
+	err = damon_call(damon_stat_context, &call_control);
+	if (err) {
+		damon_destroy_ctx(damon_stat_context);
+		damon_stat_context = NULL;
+	}
+	return err;
 }
 
 static void damon_stat_stop(void)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch
mm-damon-stat-deallocate-damon_call-failure-leaking-damon_ctx.patch
mm-damon-core-fix-damon_call-vs-kdamond_fn-exit-race.patch
mm-damon-core-fix-damos_walk-vs-kdamond_fn-exit-race.patch
mm-damon-core-validate-damos_quota_goal-nid-for-node_mem_usedfree_bp.patch
mm-damon-core-validate-damos_quota_goal-nid-for-node_memcg_usedfree_bp.patch
mm-damon-core-use-time_in_range_open-for-damos-quota-window-start.patch
docs-admin-guide-mm-damon-reclaim-warn-commit_inputs-vs-param-updates-race.patch
docs-admin-guide-mm-damon-lru_sort-warn-commit_inputs-vs-param-updates-race.patch

