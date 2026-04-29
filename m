Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698143F7885
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 12:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777467121; cv=none; b=utJQS5Qx11W2r7TS5VaZ7wQnUvQdZkZo68ZLxa4bPZTslQcX7HrAazFxeX80lQw/h5ESzeSZp/B3xvpxCi9zgg3HsunKLLKsAVvp850crFZSl1I8m3qwN7I4BWF7bSN0V12juUlAv9Z4ahPEa0j5OabynoP8Wj1Hzy5DPqgQGhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777467121; c=relaxed/simple;
	bh=RSkc+paXZUyJOBVFLtyV2VsJIjc8yj7kIpJxY5snDao=;
	h=Date:To:From:Subject:Message-Id; b=bj55ZLD5Z++CYdmc7+kMvV5wlwk9eZHMvDMp7Tm+BtfiFq9zcjSg07YP4YwxShOC59Ob1E5vAzgR9mLsuOqJFuNUWtjUDqznwAWKWUYJ2mWAA6zV1oqrDdAhFxah846JrWC0XtGlx9viAbBUpCj+yma/vgz3q/HRiMbfk+gEqNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VMTBpXEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VMTBpXEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9ADC2BCF6;
	Wed, 29 Apr 2026 12:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777467120;
	bh=RSkc+paXZUyJOBVFLtyV2VsJIjc8yj7kIpJxY5snDao=;
	h=Date:To:From:Subject:From;
	b=VMTBpXEnxcTCSpHnX52w2ObP06exS8fmdhXtEWON00q0NrDV3l+j1f6pGOJiCscF3
	 3qsxI536Ii2eSnBh4J4oqSzWRIQ3+w6bP1mymBpH0v0KqpJ4yAJjNJKfyIW0M8YAp3
	 oVcMcjJHNwbq1FmjXiq+GhYIs+9xcKDqhs2pSfeo=
Date: Wed, 29 Apr 2026 05:51:59 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-cover-all-system-rams.patch added to mm-new branch
Message-Id: <20260429125200.7E9ADC2BCF6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/reclaim: cover all system rams
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-reclaim-cover-all-system-rams.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-cover-all-system-rams.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: cover all system rams
Date: Tue, 28 Apr 2026 21:12:24 -0700

DAMON_RECLAIM allows users to set the physical address range to monitor
and do the work on.  When users don't explicitly set the range, the
biggest System RAM resource of the system is selected as the monitoring
target address range.  The intention was to reduce the overhead from
monitoring non-System RAM areas because monitoring of non-System RAM may
be meaningless.  However, because of the sampling based access check and
adaptive regions adjustment, the overhead should be negligible.  It makes
more sense to just cover all system rams of the system.  Do so.

Link: https://lore.kernel.org/20260429041232.90257-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-cover-all-system-rams
+++ a/mm/damon/reclaim.c
@@ -113,7 +113,8 @@ DEFINE_DAMON_MODULES_MON_ATTRS_PARAMS(da
  * Start of the target memory region in physical address.
  *
  * The start physical address of memory region that DAMON_RECLAIM will do work
- * against.  By default, biggest System RAM is used as the region.
+ * against.  By default, the system's entire physical memory is used as the
+ * region.
  */
 static unsigned long monitor_region_start __read_mostly;
 module_param(monitor_region_start, ulong, 0600);
@@ -122,7 +123,8 @@ module_param(monitor_region_start, ulong
  * End of the target memory region in physical address.
  *
  * The end physical address of memory region that DAMON_RECLAIM will do work
- * against.  By default, biggest System RAM is used as the region.
+ * against.  By default, the system's entire physical memory is used as the
+ * region.
  */
 static unsigned long monitor_region_end __read_mostly;
 module_param(monitor_region_end, ulong, 0600);
@@ -232,11 +234,9 @@ static int damon_reclaim_apply_parameter
 		damos_add_filter(scheme, filter);
 	}
 
-	err = damon_set_region_biggest_system_ram_default(param_target,
-					&monitor_region_start,
-					&monitor_region_end,
-					param_ctx->addr_unit,
-					param_ctx->min_region_sz);
+	err = damon_set_region_system_rams_default(param_target,
+			&monitor_region_start, &monitor_region_end,
+			param_ctx->addr_unit, param_ctx->min_region_sz);
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch
mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch
docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch
mm-damon-core-introduce-damon_ctx-paused.patch
mm-damon-sysfs-add-pause-file-under-context-dir.patch
docs-mm-damon-design-update-for-context-pause-resume-feature.patch
docs-admin-guide-mm-damon-usage-update-for-pause-file.patch
docs-abi-damon-update-for-pause-sysfs-file.patch
mm-damon-tests-core-kunit-test-pause-commitment.patch
selftests-damon-_damon_sysfs-support-pause-file-staging.patch
selftests-damon-drgn_dump_damon_status-dump-pause.patch
selftests-damon-sysfspy-check-pause-on-assert_ctx_committed.patch
selftests-damon-sysfspy-pause-damon-before-dumping-status.patch
mm-damon-introduce-damon_set_region_system_rams_default.patch
mm-damon-reclaim-cover-all-system-rams.patch
mm-damon-lru_sort-cover-all-system-rams.patch
mm-damon-core-remove-damon_set_region_biggest_system_ram_default.patch
mm-damon-stat-use-damon_set_region_system_rams_default.patch
docs-admin-guide-mm-damon-reclaim-update-for-entire-memory-monitoring.patch
docs-admin-guide-mm-damon-lru_sort-update-for-entire-memory-monitoring.patch

