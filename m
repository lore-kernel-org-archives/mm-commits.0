Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A5B2BD58A
	for <mm-commits@vger.kernel.org>; Sun,  6 Jul 2025 20:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751832047; cv=none; b=QHshrkkderzhyiaAmFFW/XHtd2Lphsy3L1br3V1x9iA229sJzjp8bCSowbkHEbSDhEDQSm7EcsWmG4pYrFSxSKLkU0YrcKjrR99uWJJYzfECGCOHY+R1stwx0Sm4f7lsn24EBAiE57xP+eWDPEVTAgaDdnPxc+VfepLAEpSLq2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751832047; c=relaxed/simple;
	bh=vweGvL3+tgy4BGO5Bex0rbwzvxW6AxU2jbWGnTHWh0w=;
	h=Date:To:From:Subject:Message-Id; b=aHsvETNYFobBAZDkvLI0uymgLsvS1KZH3OMG4/xPjL+RnuPPRYZZhEmJkyYDRJOX3M5HLfGwF/rJWO6bA0uKt2M/Gge54ad2MJgcmqvgsxPDPBfUdN3LxTP97MprHzT3DMyf1G14AI5nruJxqerDWMAjqDE5WiBURfg96E7bo90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MhLzwUEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MhLzwUEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE52AC4CEED;
	Sun,  6 Jul 2025 20:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751832046;
	bh=vweGvL3+tgy4BGO5Bex0rbwzvxW6AxU2jbWGnTHWh0w=;
	h=Date:To:From:Subject:From;
	b=MhLzwUEhUXfjDo4TC24mL3TrxCtv0VYbD7g/ozOqmqn70Rxv3W9sagXo1dS/qo2nv
	 49fSYRH0fN/YJt7k8sSgDvvF6EoIX8aW9+RAGsO+s5RJuFVOpp9pJS4Ty1gdV4WXY3
	 Wn3Dy4OS3LbJTRbpCWjYJMFtV1/8j4X4EJSfJRis=
Date: Sun, 06 Jul 2025 13:00:46 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch added to mm-new branch
Message-Id: <20250706200046.BE52AC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/reclaim: reset enabled when DAMON start failed
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch

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
Subject: mm/damon/reclaim: reset enabled when DAMON start failed
Date: Sun, 6 Jul 2025 12:32:05 -0700

When the startup fails, 'enabled' parameter is not reset.  As a result,
users show the parameter 'Y' while it is not really working.  Fix it by
resetting 'enabled' to 'false' when the work is failed.

Link: https://lkml.kernel.org/r/20250706193207.39810-5-sj@kernel.org
Fixes: 04e98764befa ("mm/damon/reclaim: enable and disable synchronously")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-reset-enabled-when-damon-start-failed
+++ a/mm/damon/reclaim.c
@@ -329,7 +329,7 @@ static int __init damon_reclaim_init(voi
 	int err = damon_modules_new_paddr_ctx_target(&ctx, &target);
 
 	if (err)
-		return err;
+		goto out;
 
 	ctx->callback.after_wmarks_check = damon_reclaim_after_wmarks_check;
 	ctx->callback.after_aggregation = damon_reclaim_after_aggregation;
@@ -338,6 +338,9 @@ static int __init damon_reclaim_init(voi
 	if (enabled)
 		err = damon_reclaim_turn(true);
 
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

