Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865FF239085;
	Sun, 29 Jun 2025 21:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751232520; cv=none; b=QH25WmZS7+t20Q9wIxjdXw+ykNTP8ge9cM7xWD9tX2hy5A1fOr1A3/+SK1Na1Q76H7RuoXVMxVO+Mao2JmZKm9oy3pzV8RYxLH8zCla3JRrIU/lbSQ4PlaOeLXT/NwDEsiDt8srglCutGpSNWNs815fB3OJ87h34ubMUuMlWVDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751232520; c=relaxed/simple;
	bh=0Q7ZbGd7B1uxnKImELozS9ZGD9d2x+2sgUZD6FVMNc8=;
	h=Date:To:From:Subject:Message-Id; b=BkQoD/eZ7cUQUQl8EOZEGLlqgqSaTSrRnj2GzNPilI8UP+Mv6z5V+Sj5kSyni+Wln8u9i4HGNgl8G6Z7hHvgk4M8Nh98mpvB3+4UIHVYhnoMPQq0z9p121fYdxdrfwVKSgfD0aoza93TOpOpADNdsiugwdU/MGboPESDRfaeuQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ExKCqrQu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ExKCqrQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52D1C4CEEB;
	Sun, 29 Jun 2025 21:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751232520;
	bh=0Q7ZbGd7B1uxnKImELozS9ZGD9d2x+2sgUZD6FVMNc8=;
	h=Date:To:From:Subject:From;
	b=ExKCqrQuLz4f646TGq9ZOzKR3eOJAXeR9fBppAzFrkwju2Y1rz/YP7MxZYcvQ1sty
	 /NGyn00d4L/eEY4LDRPrNVN/mTHZYj8aO2siVImYHOGLRYSvy61e1Y+4C2q/h5qZDT
	 1zYst8qXPnXrnvQ/h5+BVjDVs7BQFzwtfld4/3Eg=
Date: Sun, 29 Jun 2025 14:28:39 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-handle-damon_call_control-as-normal-under-kdmond-deactivation.patch added to mm-hotfixes-unstable branch
Message-Id: <20250629212839.E52D1C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: handle damon_call_control as normal under kdmond deactivation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-handle-damon_call_control-as-normal-under-kdmond-deactivation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-handle-damon_call_control-as-normal-under-kdmond-deactivation.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

