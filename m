Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AE32AD00
	for <mm-commits@vger.kernel.org>; Sun,  6 Jul 2025 20:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751832861; cv=none; b=lqRI8QFWDEjILy/NhsHxdNtzQq2Hz2VbOuKh+z6hsA6uGJkyoo0arVpWpyRGw3kskpnuM7v1SjTHY5LLjPYPy6PFh+lv7dW3Z7ABB1m0frC68nXPOVqMg3Sp7VLfF8XlUioIyOVRioSQKlP2P8KNmlKXerV53ksjc554elyEnBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751832861; c=relaxed/simple;
	bh=cwqVTfVuzD2hksB23KZ6oY8AQsj384wR5ibEgyAnAcw=;
	h=Date:To:From:Subject:Message-Id; b=Z32/sTQei98gmkBxHNN7A3S4SRCljtuJH9ySE8yHvkbIqMWraYogsHj9YdEUI8IayHxV7tvnzXze/lYvDl8EblH42W+PHRB8LCv5sJw1azEUXeI3cjUueFMaB10KUu/+QqnCD4NCr4IKDTY+Lebxnh0SyjsucBON1bpwRF3Qv9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LkYfuX4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LkYfuX4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DD8C4CEED;
	Sun,  6 Jul 2025 20:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751832861;
	bh=cwqVTfVuzD2hksB23KZ6oY8AQsj384wR5ibEgyAnAcw=;
	h=Date:To:From:Subject:From;
	b=LkYfuX4KpYEkTwsVOOa2E9B4dEGiw8Xk7J93fCvQQPVNCB0BMDW7siQUiwXDX2ZQL
	 8yUhnBcgBd1oiIE9ICWHOwJz4PQ139B5D3izYDlG+XysPK+RRJceSqq0VfdwtmEd3i
	 dNLnDl1kLYKJj/+zFZgQjalgAlKmgKwhEgHeIjW8=
Date: Sun, 06 Jul 2025 13:14:20 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-introduce-damon_stat-module-fix-2.patch added to mm-unstable branch
Message-Id: <20250706201421.34DD8C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/stat: reset enabled when DAMON start failed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-introduce-damon_stat-module-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-introduce-damon_stat-module-fix-2.patch

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
Subject: mm/damon/stat: reset enabled when DAMON start failed
Date: Sun, 6 Jul 2025 11:47:50 -0700

When damon_stat_start() fails, 'enabled' parameter is not reset.  As a
result, users show the parameter 'Y' while it is not really working.  Fix
it by resetting 'enabled' to 'false' when damon_stat_start() failed.

Link: https://lkml.kernel.org/r/20250706184750.36588-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/damon/stat.c~mm-damon-introduce-damon_stat-module-fix-2
+++ a/mm/damon/stat.c
@@ -118,8 +118,12 @@ static int damon_stat_enabled_store(
 		 */
 		return 0;
 
-	if (enabled)
-		return damon_stat_start();
+	if (enabled) {
+		err = damon_stat_start();
+		if (err)
+			enabled = false;
+		return err;
+	}
 	damon_stat_stop();
 	return 0;
 }
@@ -133,6 +137,9 @@ static int __init damon_stat_init(void)
 	/* probably set via command line */
 	if (enabled)
 		err = damon_stat_start();
+
+	if (err && enabled)
+		enabled = false;
 	return err;
 }
 
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

