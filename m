Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160A4469D
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122122; cv=none; b=FE9SqkC7XJD2R7g5mobAKPWbLPlG8wcWcXoycLT5P6J5AIcb5LQWI5uYpP6UjK4CfgEHKFQBbjE4n+VjuH2JtlyWKeiXqUF0zUqJZUsgbLXWl4EzNtHHH773vz3STnRWgt2U0awwcADs0ScwXSzdovZBptoDcWwLRFO984kGN5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122122; c=relaxed/simple;
	bh=AQUGD+k8KhCXNLpt0F2YpY/qIosoJ/y9V8Kc852m92s=;
	h=Date:To:From:Subject:Message-Id; b=O3YqC4FGqmEtYb707s1I9Unkn0fGJ+OQjZMe2sY6ltX+ZuWkVs9t8lXAfZklkO7uD3caLp7ZY1BdEnVIq16iS9sgeIzGL/sGs7INUmOX58d7I2s4hCFrMrW4PbiExllHl+yyyel8uk6wssKkRpIX2tOAQYqPknanxluMTC2FOPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kb4C00Ut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kb4C00Ut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7248BC4CEE3;
	Thu, 10 Jul 2025 04:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752122121;
	bh=AQUGD+k8KhCXNLpt0F2YpY/qIosoJ/y9V8Kc852m92s=;
	h=Date:To:From:Subject:From;
	b=Kb4C00Ut7CFwbd1Gg1hFNFP+Zys/Cqf2PcM5nkYbeNL0SB0aycEYik+3qNlJRxQyi
	 4iejZDys9xIZIKvhDX2TrDiFfHmlwEvVpR4sNV9gqOarDs28RFmqzXR7eVzQu0KuAP
	 +xfpDCcCwWmuNLd6kK2Dhpce1clVpKq6LEYdIja4=
Date: Wed, 09 Jul 2025 21:35:20 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-introduce-damon_stat-module-fix-2.patch removed from -mm tree
Message-Id: <20250710043521.7248BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/stat: reset enabled when DAMON start failed
has been removed from the -mm tree.  Its filename was
     mm-damon-introduce-damon_stat-module-fix-2.patch

This patch was dropped because it was folded into mm-damon-introduce-damon_stat-module.patch

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

mm-damon-introduce-damon_stat-module.patch
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

