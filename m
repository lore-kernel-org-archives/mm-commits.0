Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A958500973
	for <mm-commits@vger.kernel.org>; Sun, 18 Jan 2026 00:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768696787; cv=none; b=DEtRvfssjOVywmkMZEBxok3t5nGcRtSvbS0po2cgbs/ZBChQqItgKVYGAqr/QbGLa38c6HRBVQQ1yCEO5MsjRcZawZnJ55TiTceIKexQ3YqIZSQD1EvmH1cHj7ZCfEwymMrPi5Vo7rqoPhJjM0xHI342ZB/urupOTKZ9tlz/QKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768696787; c=relaxed/simple;
	bh=G0l55eN9jC/AKZ2YdmktN8g1Xl8t8HboZeQEeCtbML8=;
	h=Date:To:From:Subject:Message-Id; b=FYfXY4e1AbNmPsVVLHV+86BBnY0FgXMgY6AizDH0ydBQ1q+eMkhcBdmrDNqyScLETB8eVJacZt8mmYcRXpCTmxleG9rcLKcJuNS2vN7cX4u7bzPl5u6ygVR+pQsbirNt0afD0Av0SlT5dHTVopD3VClaX5Y/DBJzgd2ftovUrr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qHOybZ7i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qHOybZ7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6B6C4CEF7;
	Sun, 18 Jan 2026 00:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768696786;
	bh=G0l55eN9jC/AKZ2YdmktN8g1Xl8t8HboZeQEeCtbML8=;
	h=Date:To:From:Subject:From;
	b=qHOybZ7inf+KDUcKZLadwCq7oYX38Aff62Meb4IrwoNLamvmAoPw1g3DM2DlF9oev
	 gbNgrbsTtfHY+4TTs8V3EehBvJkc7PLWAr4vM+xlFNUmNZdlhUClPTM55cItyJrmuh
	 nePfLsMnrW+lGVSB2mbPO8GC8tU6fyFbI9SU60EU=
Date: Sat, 17 Jan 2026 16:39:45 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-process-damon_call_control-requests-on-a-local-list.patch added to mm-new branch
Message-Id: <20260118003946.8C6B6C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: process damon_call_control requests on a local list
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-process-damon_call_control-requests-on-a-local-list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-process-damon_call_control-requests-on-a-local-list.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: process damon_call_control requests on a local list
Date: Sat, 17 Jan 2026 09:52:51 -0800

kdamond_call() handles damon_call() requests on the ->call_controls list
of damon_ctx, which is shared with damon_call() callers.  To protect the
list from concurrent accesses while letting the callback function
independent of the call_controls_lock, the function does complicated
locking operations.  For each damon_call_control object on the list, the
function removes the control object from the list under locking, invoke
the callback of the control object without locking, and then puts the
control object back to the list if needed, under locking.  It is
complicated, and can contend the locks more frequently with other DAMON
API caller threads as the number of concurrent callback requests
increases.  Contention overhead is not a big deal, but the increased race
opportunity can make headaches.

Simplify the locking sequence by moving all damon_call_control objects
from the shared list to a local list at once under the single lock
protection, processing the callback requests without locking, and adding
back repeat mode controls to the shared list again at once again, again
under the single lock protection.  This change makes the number of locking
in kdamond_call() be always two, regardless of the number of the queued
requests.

Link: https://lkml.kernel.org/r/20260117175256.82826-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   59 ++++++++++++++++------------------------------
 1 file changed, 21 insertions(+), 38 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-process-damon_call_control-requests-on-a-local-list
+++ a/mm/damon/core.c
@@ -2649,48 +2649,31 @@ static void kdamond_usleep(unsigned long
  */
 static void kdamond_call(struct damon_ctx *ctx, bool cancel)
 {
-	struct damon_call_control *control;
-	LIST_HEAD(repeat_controls);
-	int ret = 0;
-
-	while (true) {
-		mutex_lock(&ctx->call_controls_lock);
-		control = list_first_entry_or_null(&ctx->call_controls,
-				struct damon_call_control, list);
-		mutex_unlock(&ctx->call_controls_lock);
-		if (!control)
-			break;
-		if (cancel) {
+	struct damon_call_control *control, *next;
+	LIST_HEAD(controls);
+
+	mutex_lock(&ctx->call_controls_lock);
+	list_splice_tail_init(&ctx->call_controls, &controls);
+	mutex_unlock(&ctx->call_controls_lock);
+
+	list_for_each_entry_safe(control, next, &controls, list) {
+		if (!control->repeat || cancel)
+			list_del(&control->list);
+
+		if (cancel)
 			control->canceled = true;
-		} else {
-			ret = control->fn(control->data);
-			control->return_code = ret;
-		}
-		mutex_lock(&ctx->call_controls_lock);
-		list_del(&control->list);
-		mutex_unlock(&ctx->call_controls_lock);
-		if (!control->repeat) {
+		else
+			control->return_code = control->fn(control->data);
+
+		if (!control->repeat)
 			complete(&control->completion);
-		} else if (control->canceled && control->dealloc_on_cancel) {
+		else if (control->canceled && control->dealloc_on_cancel)
 			kfree(control);
-			continue;
-		} else {
-			list_add(&control->list, &repeat_controls);
-		}
-	}
-	while (true) {
-		control = list_first_entry_or_null(&repeat_controls,
-				struct damon_call_control, list);
-		if (!control)
-			break;
-		/* Unlink from the repeate_controls list. */
-		list_del(&control->list);
-		if (cancel)
-			continue;
-		mutex_lock(&ctx->call_controls_lock);
-		list_add(&control->list, &ctx->call_controls);
-		mutex_unlock(&ctx->call_controls_lock);
 	}
+
+	mutex_lock(&ctx->call_controls_lock);
+	list_splice_tail(&controls, &ctx->call_controls);
+	mutex_unlock(&ctx->call_controls_lock);
 }
 
 /* Returns negative error code if it's not activated but should return */
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-core-introduce-nr_snapshots-damos-stat-fix.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch
mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix.patch
mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch
mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch
docs-mm-damon-design-document-damos_quota_active_mem_bp.patch
mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch
mm-damon-lru_sort-consider-age-for-quota-prioritization.patch
mm-damon-lru_sort-support-young-page-filters.patch
docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning-fix.patch
docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch
mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch
mm-damon-core-implement-damon_kdamond_pid.patch
mm-damon-sysfs-use-damon_kdamond_pid.patch
mm-damon-lru_sort-use-damon_kdamond_pid.patch
mm-damon-reclaim-use-damon_kdamond_pid.patch
mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch
mm-vma-temporary-build-fix.patch
selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch
selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch
selftests-damon-access_memory-add-repeat-mode.patch
selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch
selftests-damon-wss_estimation-deduplicate-failed-samples-output.patch
mm-damon-remove-damon_operations-cleanup.patch
mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination.patch
mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset.patch
mm-damon-core-process-damon_call_control-requests-on-a-local-list.patch
mm-damon-document-damon_call_control-dealloc_on_cancel-repeat-behavior.patch
mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out.patch
mm-damon-rename-damon_min_region-to-damon_min_region_sz.patch
mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz.patch

