Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0F7846F
	for <mm-commits@vger.kernel.org>; Sun,  6 Jul 2025 21:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751838598; cv=none; b=L6L55XttGIjy8mYbfy1uzH2NkVtc4kjZ29phAogqpz/F8Vkel5VQja4jNX+ENJpPjjlFzavl7Pyj/MuVOk5utA683hiS67ybQVvK+O2usgkKAWTNj+RiYKALa4ic/crSXqrmJ9KPlZCs5ekHTgFtSZJultGy51tNUP3vqwRkfeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751838598; c=relaxed/simple;
	bh=sFFp1puK/ktfNXBkx1NbwuG0K2MxyZ7S4o82UB6q8M8=;
	h=Date:To:From:Subject:Message-Id; b=g6knGhNaHa6xOJXMRo28ySxmI2OAQ6J5QaXiiM4LX+18UI8xdDg24nk4HhtqSwVOsVFzTSvWlCk8qEZqonfVHaOEluEq90hD89SZYfy9MRnqRBt3g2wKOx6umLFxkUEywcSCd/jzmmfWiDc+/86FMNnYw0ycmbIDho879tUGYSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P/s3JzOe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P/s3JzOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0407C4CEED;
	Sun,  6 Jul 2025 21:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751838597;
	bh=sFFp1puK/ktfNXBkx1NbwuG0K2MxyZ7S4o82UB6q8M8=;
	h=Date:To:From:Subject:From;
	b=P/s3JzOeL2HxMdDqza5k3+/wg5qgVtCTWrrx/khLOBSmgunTlMGuCd9J6p06R/cMI
	 P0sCV7v6CDetmJx4QUoz4YkGoaGSEN6R6jssRK/78X9oipzHs/l/6/Lr1tV/n0JhSl
	 iEZwI9gC+p/CZDmqaoqf7CbN0og0d49XDkj5hqcU=
Date: Sun, 06 Jul 2025 14:49:57 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch added to mm-new branch
Message-Id: <20250706214957.C0407C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: don't hold kdamond_lock in before_terminate()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch

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
Subject: mm/damon/sysfs: don't hold kdamond_lock in before_terminate()
Date: Sat, 5 Jul 2025 10:49:59 -0700

damon_sysfs_before_terminate() is a DAMON callback that is executed from
the kdamond's context.  Hence it is safe to access DAMON context internal
data.  But the function is unnecessarily holding kdamond_lock of the
context.  It is just unnecessary.  Remove the locking code.

Link: https://lkml.kernel.org/r/20250705175000.56259-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate
+++ a/mm/damon/sysfs.c
@@ -1387,12 +1387,10 @@ static void damon_sysfs_before_terminate
 	if (!damon_target_has_pid(ctx))
 		return;
 
-	mutex_lock(&ctx->kdamond_lock);
 	damon_for_each_target_safe(t, next, ctx) {
 		put_pid(t->pid);
 		damon_destroy_target(t);
 	}
-	mutex_unlock(&ctx->kdamond_lock);
 }
 
 /*
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-handle-damon_call_control-as-normal-under-kdmond-deactivation.patch
mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
mm-damon-introduce-damon_stat-module-fix-2.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch
mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch
revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch
revert-mm-make-alloc_demote_folio-externally-invokable-for-migration.patch
selftets-damon-add-a-test-for-memcg_path-leak.patch
mm-damon-sysfs-schemes-decouple-from-damos_quota_goal_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_action.patch
mm-damon-sysfs-schemes-decouple-from-damos_wmark_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_filter_type.patch
mm-damon-sysfs-decouple-from-damon_ops_id.patch
selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch
mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch
mm-damon-add-trace-event-for-effective-size-quota.patch
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

