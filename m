Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5FD469D
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122120; cv=none; b=Yi9TheY0+VGkvMtHaq6+wf2cFGZpoN05R1QvADQLkdYXZPqbgpZpz8SgM9UZRf9kMvMrGiJ7zGhEUraHXpM3aZ+FfeHDkG6MqKSw6qdhQWG7OJJ9b1G5GdEkcsEU1bc58rR32NGUawHnkeNsLwrdxnNG/XrhyxMeTKzZ11EuyyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122120; c=relaxed/simple;
	bh=goazf0QzpfmfeLOztq/iWGgtBQArKplD/RzbUK0moSE=;
	h=Date:To:From:Subject:Message-Id; b=K2m91WXDNuH/vEvraY3gKwyuDqVQ7Ooh1qcd20YLc65Sc7MqFT/40NN3qJ5m5N6ygJjGTeElfXRa7H2puxE4P4Q4fYvAZbyLnc58MXRjpTSVXA8e6jkvtRza477ON86WH4Cy9a4w7BM1fdx96b6PE1s0qDGyx1jUrDLxXOlr7/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tUTBy3IK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tUTBy3IK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6B8C4CEE3;
	Thu, 10 Jul 2025 04:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752122120;
	bh=goazf0QzpfmfeLOztq/iWGgtBQArKplD/RzbUK0moSE=;
	h=Date:To:From:Subject:From;
	b=tUTBy3IK/GLvmBNNMwGQQ+Ua/PIpEruqTHHgNiYgK41Zp6Fac8C6ePP11eC8nYfLS
	 0JiQLoLIW6U39kisWsxp6wBRUEWeG32RbDAbc8KopnduIn0H9xjA2YApYNp2dkVtcw
	 x82mn0meaM4m+ylKl5YWzVYr/7caqJCVrcZgl6jI=
Date: Wed, 09 Jul 2025 21:35:19 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-introduce-damon_stat-module-fix.patch removed from -mm tree
Message-Id: <20250710043520.3E6B8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/stat: use IS_ENABLED() for enabled initial value
has been removed from the -mm tree.  Its filename was
     mm-damon-introduce-damon_stat-module-fix.patch

This patch was dropped because it was folded into mm-damon-introduce-damon_stat-module.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/stat: use IS_ENABLED() for enabled initial value
Date: Wed, 4 Jun 2025 13:48:30 -0700

The initial value of enabled parameter is set as
CONFIG_DAMON_STAT_ENABLED_DEFAULT, so get below build error when the
config is not enabled.  Fix it using IS_ENABLED().

    mm/damon/stat.c:27:37: error: `CONFIG_DAMON_STAT_ENABLED_DEFAULT' undeclared here (not in a function)
       27 | static bool enabled __read_mostly = CONFIG_DAMON_STAT_ENABLED_DEFAULT;
          |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20250604205619.18929-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/damon/stat.c~mm-damon-introduce-damon_stat-module-fix
+++ a/mm/damon/stat.c
@@ -24,7 +24,8 @@ static const struct kernel_param_ops ena
 	.get = param_get_bool,
 };
 
-static bool enabled __read_mostly = CONFIG_DAMON_STAT_ENABLED_DEFAULT;
+static bool enabled __read_mostly = IS_ENABLED(
+	CONFIG_DAMON_STAT_ENABLED_DEFAULT);
 module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
 MODULE_PARM_DESC(enabled, "Enable of disable DAMON_STAT");
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-introduce-damon_stat-module.patch
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

