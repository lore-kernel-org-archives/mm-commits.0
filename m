Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FEC2BCF70
	for <mm-commits@vger.kernel.org>; Sun,  6 Jul 2025 20:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751832049; cv=none; b=SmXqAJmSy18lYqM1k1NSe+1BlaskP0FYUohy3xuyhQWQ9OfVaksWnp6SQT+FAvtbzINGXohANTyFcdMu4Grxjew2RjTdSfNvWTw5u7kS4Cn85+ipeGM6kP5eeuHtqY2rhH57DGfWLISyJbv8CtPbjgVe8ZaVGOc/KAB6vkdxvCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751832049; c=relaxed/simple;
	bh=yvxnzvjDYUwppSBF6/qHe5xIFmToxgDEWwOaCv4aPj0=;
	h=Date:To:From:Subject:Message-Id; b=I0tcrmjBvDZIdlZZQyVF0QL2Tl8YrofCambKTksv6WRiEkfijTogTieTAMNLh6oMCjhHN2/gqmQC/N18OKmBmhCEE6lvHgP4qXrjCQTXzQJv0wEjKZmBMyVexzkdKCxO/fp3WEbjbkiaYjq/TLCVL+PQ/t/uveOBAOjYRG07oQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E5SGWQPT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E5SGWQPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47CDC4CEED;
	Sun,  6 Jul 2025 20:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751832048;
	bh=yvxnzvjDYUwppSBF6/qHe5xIFmToxgDEWwOaCv4aPj0=;
	h=Date:To:From:Subject:From;
	b=E5SGWQPTj/JtaCgcCn/n5Uj7icNvNP1oIb9QFs4CVgi3sAEjoKJqXUrutgaoj9ASL
	 ixRfT4JT77IODlmHDtV+DBVJEYmhyO6nePzzFsq1ohAp3Qd2KwZx5PYNaPIsGd2f61
	 jBneX9eZbLLJveZ+JDQ6JOKOwDc5fgyaoTf4AOsU=
Date: Sun, 06 Jul 2025 13:00:48 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch added to mm-new branch
Message-Id: <20250706200048.A47CDC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: reset enabled when DAMON start failed
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch

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
Subject: mm/damon/lru_sort: reset enabled when DAMON start failed
Date: Sun, 6 Jul 2025 12:32:06 -0700

When the startup fails, 'enabled' parameter is not reset.  As a result,
users show the parameter 'Y' while it is not really working.  Fix it by
resetting 'enabled' to 'false' when the work is failed.

Link: https://lkml.kernel.org/r/20250706193207.39810-6-sj@kernel.org
Fixes: 7a034fbba336 ("mm/damon/lru_sort: enable and disable synchronously")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-reset-enabled-when-damon-start-failed
+++ a/mm/damon/lru_sort.c
@@ -325,7 +325,7 @@ static int __init damon_lru_sort_init(vo
 	int err = damon_modules_new_paddr_ctx_target(&ctx, &target);
 
 	if (err)
-		return err;
+		goto out;
 
 	ctx->callback.after_wmarks_check = damon_lru_sort_after_wmarks_check;
 	ctx->callback.after_aggregation = damon_lru_sort_after_aggregation;
@@ -334,6 +334,9 @@ static int __init damon_lru_sort_init(vo
 	if (enabled)
 		err = damon_lru_sort_turn(true);
 
+out:
+	if (err && enabled)
+		enabled = false;
 	return err;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-handle-damon_call_control-as-normal-under-kdmond-deactivation.patch
mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
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

