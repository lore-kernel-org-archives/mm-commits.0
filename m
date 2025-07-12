Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75F3225771
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752358003; cv=none; b=GAvnqMMoCTx7VaA1/dxI3IGfxktkNsDlUX90aiwfV5tisQMBk1iKeLK+03LBYvlTJ1ljck2KDOol82Tea1F5Wupu2GnjiFrUqn/VGxZjuSJgDJ4bxKXRX8kUS4exO9fsEA+8ngF23ru4U0LRFT/G0f8Ie4Pk8NdQ/jDUOgK9W7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752358003; c=relaxed/simple;
	bh=bpL4CFC9Fx7Mw5o7NSXRYRlZq550UU1VT+VHzN1ZBcw=;
	h=Date:To:From:Subject:Message-Id; b=YmQXSxVA52B0vcQulXC3A4wUPMn+lNFHh/abbOkO0xhTQ1gvgRdYeusH54plBI15RvB4NqOIliONDmH7h/H9iUQRGwO7hBL/5BugzopGgHOGaYTGLfZS+nG1tSDPN/HpehPKY4lR97grtoiB7PDLnwui29Z6bmN9Ur2tba0rPW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x8S5RHYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x8S5RHYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE78C4CEEF;
	Sat, 12 Jul 2025 22:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752358003;
	bh=bpL4CFC9Fx7Mw5o7NSXRYRlZq550UU1VT+VHzN1ZBcw=;
	h=Date:To:From:Subject:From;
	b=x8S5RHYzdYtBQDj8wWGo5NlMGFiDoM/zmtDBUaF+ChE6S3TLCqe/U97e+ziuvIJOP
	 jHy9XMP7dzMPzJEi+j7wMPQZ9tPgIHMmbREfl0AcuUMgbMTC5noTIH3UeZTKcY8BrZ
	 YKG4fbyAqZo7DtSBU/u7JlvnkP1tDTAxxBOogixY=
Date: Sat, 12 Jul 2025 15:06:41 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch added to mm-new branch
Message-Id: <20250712220643.7AE78C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: destroy targets when kdamond_fn() finish
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: destroy targets when kdamond_fn() finish
Date: Sat, 12 Jul 2025 12:50:14 -0700

When kdamond_fn() completes, the targets are kept.  Those are kept to let
callers do additional cleanups if they need.  There are no such additional
cleanups though.  DAMON sysfs interface deallocates those in
before_terminate() callback, to reduce unnecessary memory usage, for
[f]vaddr use case.  Just destroy the targets for every case in the core
layer.  This saves more memory and simplifies the logic.

Link: https://lkml.kernel.org/r/20250712195016.151108-13-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c~mm-damon-core-destroy-targets-when-kdamond_fn-finish
+++ a/mm/damon/core.c
@@ -2657,6 +2657,7 @@ done:
 		running_exclusive_ctxs = false;
 	mutex_unlock(&damon_lock);
 
+	damon_destroy_targets(ctx);
 	return 0;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch
mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch
mm-damon-add-trace-event-for-effective-size-quota.patch
mm-damon-add-trace-event-for-effective-size-quota-fix.patch
mm-damon-add-trace-event-for-effective-size-quota-fix-2.patch
samples-damon-wsse-fix-boot-time-enable-handling.patch
samples-damon-prcl-fix-boot-time-enable-crash.patch
samples-damon-mtier-support-boot-time-enable-setup.patch
mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch
mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch
mm-damon-reclaim-use-parameter-context-correctly.patch
samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch
mm-damon-accept-parallel-damon_call-requests.patch
mm-damon-core-introduce-repeat-mode-damon_call.patch
mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch
mm-damon-core-add-cleanup_target-ops-callback.patch
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch

