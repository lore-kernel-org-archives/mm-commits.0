Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DC41E8335
	for <mm-commits@vger.kernel.org>; Sun,  6 Jul 2025 21:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751838595; cv=none; b=EneLstcJfqzNrtXmwZavI9MgZ1ROG63dEnfWko3s5I7qZspzf5uEFPU2ivlyU+ZxbKzedoukF7cmQuN6VP14zGrsPwU1uRR9v5ZOJ4PbIq9OeJotlhzUXHRolseaAoMTqtid1C1Nuv/7DR0vfze9tqNYijRVuScB6/wsBZnHimc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751838595; c=relaxed/simple;
	bh=TGegFf1MI1JcaadulcrfCTG7zboCNiDvyBieKq9m3T8=;
	h=Date:To:From:Subject:Message-Id; b=W1aJTzW21r0aruwSubzhBCkXxNSOraWtHPsPOa3Ni8jopUXNFNVxcB5eQCmYbcDEOpIhktgbJ4vbj0YyFirEs+KI//lp2vxgXBCGFlOLEBbfdqQIppvEQEY0AIAvZ0z5eBMw1tXz7VZBd8lX/vPvy3RMSggJQFRQlVQq43AF21k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=04wzkP7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="04wzkP7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24352C4CEED;
	Sun,  6 Jul 2025 21:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751838595;
	bh=TGegFf1MI1JcaadulcrfCTG7zboCNiDvyBieKq9m3T8=;
	h=Date:To:From:Subject:From;
	b=04wzkP7cTS8qDYxLOszxirI3UP/nVp0A1YppFoZWIGdGGB8PcoC1Ow0/4V4AFhbOz
	 QQ6cVrysqxCrSt+HmxsG+IOdFv28amjqMCuirPOuVBvQAmVLdvUAwPCsXinoNiojO1
	 paVVYkiPHI3sAp5xlAaR3okT0deTBl8PVQYVzhn8=
Date: Sun, 06 Jul 2025 14:49:54 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-use-damon-core-api-damon_is_running.patch added to mm-new branch
Message-Id: <20250706214955.24352C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: use DAMON core API damon_is_running()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-use-damon-core-api-damon_is_running.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-use-damon-core-api-damon_is_running.patch

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
Subject: mm/damon/sysfs: use DAMON core API damon_is_running()
Date: Sat, 5 Jul 2025 10:49:58 -0700

DAMON core implements a static function to see if a given DAMON context is
running.  DAMON sysfs interface is implementing the same one on its own. 
Make the core function non-static and reuse it from the DAMON sysfs
interface.

Link: https://lkml.kernel.org/r/20250705175000.56259-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 +
 mm/damon/core.c       |    8 +++++++-
 mm/damon/sysfs.c      |   14 ++------------
 3 files changed, 10 insertions(+), 13 deletions(-)

--- a/include/linux/damon.h~mm-damon-sysfs-use-damon-core-api-damon_is_running
+++ a/include/linux/damon.h
@@ -934,6 +934,7 @@ static inline unsigned int damon_max_nr_
 
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
+bool damon_is_running(struct damon_ctx *ctx);
 
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
--- a/mm/damon/core.c~mm-damon-sysfs-use-damon-core-api-damon_is_running
+++ a/mm/damon/core.c
@@ -1311,7 +1311,13 @@ int damon_stop(struct damon_ctx **ctxs,
 	return err;
 }
 
-static bool damon_is_running(struct damon_ctx *ctx)
+/**
+ * damon_is_running() - Returns if a given DAMON context is running.
+ * @ctx:	The DAMON context to see if running.
+ *
+ * Return: true if @ctx is running, false otherwise.
+ */
+bool damon_is_running(struct damon_ctx *ctx)
 {
 	bool running;
 
--- a/mm/damon/sysfs.c~mm-damon-sysfs-use-damon-core-api-damon_is_running
+++ a/mm/damon/sysfs.c
@@ -1189,16 +1189,6 @@ static void damon_sysfs_kdamond_rm_dirs(
 	kobject_put(&kdamond->contexts->kobj);
 }
 
-static bool damon_sysfs_ctx_running(struct damon_ctx *ctx)
-{
-	bool running;
-
-	mutex_lock(&ctx->kdamond_lock);
-	running = ctx->kdamond != NULL;
-	mutex_unlock(&ctx->kdamond_lock);
-	return running;
-}
-
 /*
  * enum damon_sysfs_cmd - Commands for a specific kdamond.
  */
@@ -1275,7 +1265,7 @@ static ssize_t state_show(struct kobject
 	if (!ctx)
 		running = false;
 	else
-		running = damon_sysfs_ctx_running(ctx);
+		running = damon_is_running(ctx);
 
 	return sysfs_emit(buf, "%s\n", running ?
 			damon_sysfs_cmd_strs[DAMON_SYSFS_CMD_ON] :
@@ -1429,7 +1419,7 @@ static inline bool damon_sysfs_kdamond_r
 		struct damon_sysfs_kdamond *kdamond)
 {
 	return kdamond->damon_ctx &&
-		damon_sysfs_ctx_running(kdamond->damon_ctx);
+		damon_is_running(kdamond->damon_ctx);
 }
 
 static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
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

