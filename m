Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136351C5F14
	for <mm-commits@vger.kernel.org>; Sun,  6 Jul 2025 20:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751832051; cv=none; b=gKHyXF8lkB/IJY+PLM8inE2+CHjJysZYjs7IKAPIbKFwZXDdQIsDyfUvglhXeuQzTspP7iz34yK9XB6DDK6cxTPiMcdVHVBXi6aw01tbeNL4R3YUFjh8VTTvGpghHtEEbr4Zd2Ovx2JS3pQSKHnnydu6Ob296ZpdCU2sW3y/54I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751832051; c=relaxed/simple;
	bh=O5+DcqqIjo7Sl2Rn9YH/3Z6GNzTsDctS1MlKc6pdw+w=;
	h=Date:To:From:Subject:Message-Id; b=YKyzWwHdMIY6jSq1UBRwRJ1EFlMR/L0oTO343Q3311oLfrTaLRkMYh1y8KoJd/H0v51RAhpSaCawV6iygsuNnBGAuxW1nDoITg/oNPeSphQ+o1XvPQFQL/uolHS85TV9MNCOuRdFVcEDaH8MFqTqVb/eYntiByPZdg7p14shGqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F6Azc6IX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F6Azc6IX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DC3C4CEED;
	Sun,  6 Jul 2025 20:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751832050;
	bh=O5+DcqqIjo7Sl2Rn9YH/3Z6GNzTsDctS1MlKc6pdw+w=;
	h=Date:To:From:Subject:From;
	b=F6Azc6IX3DVKz9kdrbOh1pn5tJ8YbzhQU/Ep4DNznM1aA/5K6qM2dWjuOALk9unFB
	 eZ3a5yPriVhExOP/K707HwFg7QGi2YuShqKrIQVaskTkHRaE2TL3ibk+bKeftPEYlY
	 chge75NyGVB9Sr7QSXay8hBz8Ei3fvRoqDhmPZCI=
Date: Sun, 06 Jul 2025 13:00:50 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-use-parameter-context-correctly.patch added to mm-new branch
Message-Id: <20250706200050.93DC3C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/reclaim: use parameter context correctly
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-reclaim-use-parameter-context-correctly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-use-parameter-context-correctly.patch

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
Subject: mm/damon/reclaim: use parameter context correctly
Date: Sun, 6 Jul 2025 12:32:07 -0700

damon_reclaim_apply_parameters() allocates a new DAMON context, stages
user-specified DAMON parameters on it, and commits to running DAMON
context at once, using damon_commit_ctx().  The code is mistakenly
over-writing the monitoring attributes and the reclaim scheme on the
running context.  It is not causing a real problem for monitoring
attributes, but the scheme overwriting can remove scheme's internal status
such as charged quota.  Fix the wrong use of the parameter context.

Link: https://lkml.kernel.org/r/20250706193207.39810-7-sj@kernel.org
Fixes: 11ddcfc257a3 ("mm/damon/reclaim: use damon_commit_ctx()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-use-parameter-context-correctly
+++ a/mm/damon/reclaim.c
@@ -194,7 +194,7 @@ static int damon_reclaim_apply_parameter
 	if (err)
 		return err;
 
-	err = damon_set_attrs(ctx, &damon_reclaim_mon_attrs);
+	err = damon_set_attrs(param_ctx, &damon_reclaim_mon_attrs);
 	if (err)
 		goto out;
 
@@ -202,7 +202,7 @@ static int damon_reclaim_apply_parameter
 	scheme = damon_reclaim_new_scheme();
 	if (!scheme)
 		goto out;
-	damon_set_schemes(ctx, &scheme, 1);
+	damon_set_schemes(param_ctx, &scheme, 1);
 
 	if (quota_mem_pressure_us) {
 		goal = damos_new_quota_goal(DAMOS_QUOTA_SOME_MEM_PSI_US,
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

