Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3024E225771
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752357992; cv=none; b=fNjuGvYq5OOC+d5tC17se/xn2EjXnIh15JkbcFj0fw7csbQysXQd3VSkhDO49n+9lsGy5rYy9NzeXvtzdaQZGnLubbhJtALbswflrFeKpA54gJt5OKKQRXhqbdF3suFmv0hiAB8p0QNPy9Ivg7hlqeLyoZ3PZL/xOp8PVYsFeJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752357992; c=relaxed/simple;
	bh=XSeHh/UMWpKbZaZk6Qrld7i7CkeIWslSTdpHrbxLKbg=;
	h=Date:To:From:Subject:Message-Id; b=b6ooxEuREnyc03GYWH+HRWhjOKvZtpYn8xZMaNBoLYeY9uGTAfWb7df9Vo7hR82fb9M5R/X6KMZetCLpATMa9ijtkH+nm3Ar6kFnrGPqeB9p4wAPlS7EUjZCsx+2GkeclkDHqttZRsP33F+K1z1jSYPbfy04zLtHALOMhKBQX/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=unDgr1rA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="unDgr1rA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21A7C4CEEF;
	Sat, 12 Jul 2025 22:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752357992;
	bh=XSeHh/UMWpKbZaZk6Qrld7i7CkeIWslSTdpHrbxLKbg=;
	h=Date:To:From:Subject:From;
	b=unDgr1rAInjQ/4PoatDNL9PJJc86IAa6h5Sn4V793uNWAJZpW2URzqZLp6itnqxyf
	 UsInplnoPglehO9OLUG1HAVaQ5TvoH8KMrdciXT8HSyHBA/E7nKKPCyO7VsDlKbqyQ
	 zPFnXRkm6mKPRTHFsngT8+nhVDMhrgy1En8WgcwM=
Date: Sat, 12 Jul 2025 15:06:31 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch added to mm-new branch
Message-Id: <20250712220631.E21A7C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: do not call ops.cleanup() when destroying targets
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch

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
Subject: mm/damon/core: do not call ops.cleanup() when destroying targets
Date: Sat, 12 Jul 2025 12:50:10 -0700

damon_operations.cleanup() is documented to be called for kdamond
termination, but also being called for targets destruction, which is done
for any damon_ctx destruction.  Nobody is using the callback for now,
though.  Remove the cleanup() call under the destruction.

Link: https://lkml.kernel.org/r/20250712195016.151108-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-do-not-call-opscleanup-when-destroying-targets
+++ a/mm/damon/core.c
@@ -550,11 +550,6 @@ static void damon_destroy_targets(struct
 {
 	struct damon_target *t, *next_t;
 
-	if (ctx->ops.cleanup) {
-		ctx->ops.cleanup(ctx);
-		return;
-	}
-
 	damon_for_each_target_safe(t, next_t, ctx)
 		damon_destroy_target(t);
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

