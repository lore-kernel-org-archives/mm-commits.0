Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2331A285;
	Thu, 10 Jul 2025 04:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752120554; cv=none; b=p70jVW8ccD598Etouia2r7bZIo6NBuAE46+ESZdMlMwKvMjzQY6m7VssZLozxkGvaYJtWkb7ORxItXJTI2NlrOkoTDR7lUYmbepxxhJBPWHxG7XRbsy7YfBzypy7plgBLXzkWL/clrFatb34ZsX4lIclNDO79Gjl1mjSBpoqsH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752120554; c=relaxed/simple;
	bh=DyJmltEUifqgQ01OZJ1yL6SiCv3NuQ5vXGGci7Fz3mQ=;
	h=Date:To:From:Subject:Message-Id; b=o5Ng4VpfDtQwjrNfFeKWQdvGVQZ8QVc5rlMLKxWxXTPC2UkTQ+MM0rmSWU7BfkuXQLdmP5CS0vOASrBFHA4M1PYOCZx0vwCe7KUQj8NoS4TSjnw2CvpX0qsfjL1coihWFbhVxE78rHU7Ut2S5qUaXSQ5n3TYgi/o+qXsiB229Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uADYAXWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uADYAXWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEF2C4CEE3;
	Thu, 10 Jul 2025 04:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752120554;
	bh=DyJmltEUifqgQ01OZJ1yL6SiCv3NuQ5vXGGci7Fz3mQ=;
	h=Date:To:From:Subject:From;
	b=uADYAXWmEPGzOLeQM+96bk+yRNhV3k4VIfK/KSeJdWU5iCaYqA5j1PeOkbRsOQelr
	 3XS43pp6ZytJvY7ivwNPQzbrpc3KJy3D9+ITk6FgsjAABHw8zqGYIzM3FrHXgTmqxj
	 AgqauuKkAth+F4V7K/YEJbgCcUd905ZsgRQ1R3dg=
Date: Wed, 09 Jul 2025 21:09:13 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-handle-damon_call_control-as-normal-under-kdmond-deactivation.patch removed from -mm tree
Message-Id: <20250710040914.6EEF2C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: handle damon_call_control as normal under kdmond deactivation
has been removed from the -mm tree.  Its filename was
     mm-damon-core-handle-damon_call_control-as-normal-under-kdmond-deactivation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: handle damon_call_control as normal under kdmond deactivation
Date: Sun, 29 Jun 2025 13:49:14 -0700

DAMON sysfs interface internally uses damon_call() to update DAMON
parameters as users requested, online.  However, DAMON core cancels any
damon_call() requests when it is deactivated by DAMOS watermarks.

As a result, users cannot change DAMON parameters online while DAMON is
deactivated.  Note that users can turn DAMON off and on with different
watermarks to work around.  Since deactivated DAMON is nearly same to
stopped DAMON, the work around should have no big problem.  Anyway, a bug
is a bug.

There is no real good reason to cancel the damon_call() request under
DAMOS deactivation.  Fix it by simply handling the request as normal,
rather than cancelling under the situation.

Link: https://lkml.kernel.org/r/20250629204914.54114-1-sj@kernel.org
Fixes: 42b7491af14c ("mm/damon/core: introduce damon_call()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-handle-damon_call_control-as-normal-under-kdmond-deactivation
+++ a/mm/damon/core.c
@@ -2355,9 +2355,8 @@ static void kdamond_usleep(unsigned long
  *
  * If there is a &struct damon_call_control request that registered via
  * &damon_call() on @ctx, do or cancel the invocation of the function depending
- * on @cancel.  @cancel is set when the kdamond is deactivated by DAMOS
- * watermarks, or the kdamond is already out of the main loop and therefore
- * will be terminated.
+ * on @cancel.  @cancel is set when the kdamond is already out of the main loop
+ * and therefore will be terminated.
  */
 static void kdamond_call(struct damon_ctx *ctx, bool cancel)
 {
@@ -2405,7 +2404,7 @@ static int kdamond_wait_activation(struc
 		if (ctx->callback.after_wmarks_check &&
 				ctx->callback.after_wmarks_check(ctx))
 			break;
-		kdamond_call(ctx, true);
+		kdamond_call(ctx, false);
 		damos_walk_cancel(ctx);
 	}
 	return -EBUSY;
_

Patches currently in -mm which might be from sj@kernel.org are

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

