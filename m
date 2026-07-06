Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F4F2F3600
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 17:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783357835; cv=none; b=jALS2owjupQGl1N7tVMiANICG5FWr9PFqBz7YdSceh/E0drwV6mwPySx//GENkzeRjKPnBSl+fgq4Q1+cWzZlyM6vIVB1sVkA6Bj/shqvU+RyrMvczETDxxmo0Nyl1lhQBJ16tiyqpft10kGbQUtbVBD8if5ObeTynEkjxIIALI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783357835; c=relaxed/simple;
	bh=4hf90vCwPWF8Wu7zGa6i6srEEqkXLp3BwwUXuYdT/FM=;
	h=Date:To:From:Subject:Message-Id; b=kx4eL76zOW6R0z5ytG9QJZYEJ8t9Zc7G5JjiT0ZN4Z7jmN4rwOdCCbJPdnX7j9+R4AscjWwfVbl1GCLQMZSajNfkzzW0thimzatnzCIi379bfUkulkcbhxMXEE23Xqby0MwOC+GA02xZh9ZrBhiYYpDAXezJguu7fjMLdZGGQuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g647VVKA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g647VVKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6691F000E9;
	Mon,  6 Jul 2026 17:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783357833;
	bh=8P3/K7eK/pGcYyM2qNZiQt6tlgngafPvoX3iBEB5ea8=;
	h=Date:To:From:Subject;
	b=g647VVKAyVvaCkMnTpgcUPyyqpt3iaDHniHrHgtGK2lPP8L1wqUc/UantF8cXDE4X
	 23Kl46sUF7KjPhSDt12LviTZ9L5/vR5xbSl7c2bygIwHzYW9cQ4Go0frwLwydinUEb
	 PgxONw0+2Fbp7UCf6wwcmgET7Oc5xznqGemAvRK4=
Date: Mon, 06 Jul 2026 10:10:33 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-make-damon_stop-never-fails.patch added to mm-new branch
Message-Id: <20260706171033.7F6691F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: make damon_stop() never fail
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-make-damon_stop-never-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-make-damon_stop-never-fails.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: make damon_stop() never fail
Date: Mon, 6 Jul 2026 07:06:18 -0700

damon_stop() has no reason to fail.  It returns an error code only for
possible future changes that can make it fail.  Such a change has not been
made yet, and this only makes the error handling complicated and
confusing.  Ensure it returns no error.

Link: https://lore.kernel.org/20260706140628.87414-4-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-make-damon_stop-never-fails
+++ a/mm/damon/core.c
@@ -1926,10 +1926,8 @@ int damon_start(struct damon_ctx **ctxs,
 /*
  * __damon_stop() - Stops monitoring of a given context.
  * @ctx:	monitoring context
- *
- * Return: 0 on success, negative error code otherwise.
  */
-static int __damon_stop(struct damon_ctx *ctx)
+static void __damon_stop(struct damon_ctx *ctx)
 {
 	struct task_struct *tsk;
 
@@ -1939,31 +1937,24 @@ static int __damon_stop(struct damon_ctx
 		get_task_struct(tsk);
 		mutex_unlock(&ctx->kdamond_lock);
 		kthread_stop_put(tsk);
-		return 0;
+		return;
 	}
 	mutex_unlock(&ctx->kdamond_lock);
-
-	return -EPERM;
 }
 
 /**
  * damon_stop() - Stops the monitorings for a given group of contexts.
  * @ctxs:	an array of the pointers for contexts to stop monitoring
  * @nr_ctxs:	size of @ctxs
- *
- * Return: 0 on success, negative error code otherwise.
  */
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs)
 {
-	int i, err = 0;
+	int i;
 
-	for (i = 0; i < nr_ctxs; i++) {
+	for (i = 0; i < nr_ctxs; i++)
 		/* nr_running_ctxs is decremented in kdamond_fn */
-		err = __damon_stop(ctxs[i]);
-		if (err)
-			break;
-	}
-	return err;
+		__damon_stop(ctxs[i]);
+	return 0;
 }
 
 /**
_

Patches currently in -mm which might be from sj@kernel.org are

maintainers-s-seongjae-sj.patch
mm-damon-core-validate-ranges-in-damon_set_regions.patch
mm-damon-core-disallow-overlapping-input-ranges-for-damon_set_regions.patch
samples-damon-wsse-handle-damon_start-failure.patch
samples-damon-prcl-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_stop-failure.patch
samples-damon-wsse-stop-and-free-damon-ctx-when-damon_call-fails.patch
samples-damon-prcl-stop-and-free-damon-ctx-when-damon_call-fails.patch
mm-damon-sysfs-kobject_del-target-normal-context-and-kdamond-dirs.patch
mm-damon-sysfs-kobject_del-region-and-target-error-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-region-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-filter-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-quota-goal-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-action-destination-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs.patch
mm-damon-sysfs-kobject_del-probe-filter-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs-in-probes_addd_dir-error-path.patch
mm-damon-sysfs-schemes-kobject_del-region-for-populate_region-error.patch
docs-mm-damon-design-update-for-damos_quota_node_eligible_mem_bp.patch
docs-abi-damon-document-probe-files.patch
mm-damon-tests-core-kunit-test-damon_rand.patch
selftests-damon-sysfssh-test-multiple-probe-dirs-creation.patch
selftests-damon-sysfssh-test-coreops_filters-directories.patch
selftests-damon-sysfssh-test-dests-dir.patch
selftests-damon-sysfssh-test-all-files-in-quota-goal-dir.patch
mm-damon-core-reduce-range-setup-in-damon_commit_target_regions.patch
mm-damon-sysfs-split-probe-setup-function-out.patch
mm-damon-sysfs-split-out-filters-setup-function.patch
mm-damon-sysfs-fix-typos-in-probe_addrm_dirs-s-attr-probe.patch
mm-damon-core-introduce-damon_nr_accesses_mvsum.patch
mm-damon-tests-core-kunit-test-damon_mvsum.patch
mm-damon-core-always-update-last_nr_accesses-for-intervals-change.patch
mm-damon-core-handle-unreset-nr_accesses-in-damon_nr_accesses_mvsum.patch
mm-damon-core-use-damon_nr_accesses_mvsum-in-__damos_valid_target.patch
mm-damon-core-use-damon_nr_accesses_mvsum-for-damos-region-tracing.patch
mm-damon-sysfs-schemes-use-damon_nr_accesses_mvsum-for-damo-regions.patch
mm-damon-core-remove-damon_warn_fix_nr_accesses_corruption.patch
mm-damon-core-remove-damon_verify_reset_aggregated.patch
mm-damon-core-remove-damon_verify_merge_regions_of.patch
mm-damon-tests-core-kunit-remove-nr_accesses_bp-setup-and-tests.patch
selftests-damon-drgn_dump_damon_status-do-not-dump-nr_accesses_bp.patch
mm-damon-core-remove-nr_accesses_bp-setups-and-updates.patch
mm-damon-core-remove-attrs-param-from-damon_update_region_access_rate.patch
mm-damon-paddr-remove-attrs-param-from-__damon_pa_check_access.patch
mm-damon-vaddr-remove-attrs-param-from-__damon_va_check_access.patch
mm-damon-core-remove-damon_moving_sum-and-its-unit-test.patch
mm-damon-core-remove-damon_region-nr_accesses_bp.patch
mm-damon-add-damon_region-last_probe_hits.patch
mm-damon-core-introduce-damon_probe_hits_mvsum.patch
mm-damon-sysfs-schemes-set-probe-hits-as-pseudo-moving-sums.patch
mm-damon-core-safely-validate-src-on-damon_commit_ctx.patch
mm-damon-core-do-parameter-testing-commit-on-damon_start.patch
mm-damon-sysfs-remove-duplicated-commit-input-validity-check.patch
mm-damon-reclaim-remove-duplicated-min_region_sz-power-of-2-check.patch
mm-damon-lru_sort-remove-duplicated-min_region_sz-power_of_2-check.patch
mm-damon-document-region-size-validation-in-damon_set_regions.patch
mm-damon-core-remove-start-end-check-in-damon_set_region_system_rams.patch
mm-damon-sysfs-remove-region-size-validation.patch
mm-damon-core-stop-ctxs-in-damon_start-before-returning-an-error.patch
samples-damon-mtier-do-not-stop-first-context-for-damon_start-failure.patch
mm-damon-core-make-damon_stop-never-fails.patch
mm-damon-sysfs-ignore-damon_stop-return-value.patch
mm-damon-reclaaim-ignore-damon_stop-return-value.patch
mm-damon-lru_sort-ignore-damon_stop-return-value.patch
mm-damon-core-change-damon_stop-return-type-to-void.patch
samples-damon-mtier-stop-all-contexts-with-single-damon_stop-call.patch
mm-damon-core-wait-ctx-stop-in-damon_call-before-reruning-an-error.patch
samples-damon-wsse-do-not-stop-ctx-for-damon_call-failure.patch
samples-damon-prcl-do-not-stop-damon-for-damon_call-failure.patch

