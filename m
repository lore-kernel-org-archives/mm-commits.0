Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AEB3033EC
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 19:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783278989; cv=none; b=mn6gZ14M0Hw8BwIZe5WGlpYV1hmrZHyJGohiKpRPqBvDyHY631Jrvjek4I54izFTtn6mewDl6w5iqJzdqYoh770PY8OSvUz9WW2AUnldtTtHjvM+YYIpZOMkKdj2ej45wwVNzhgM/ApgdbwHz2YDXXxWLJP92b/h5t+dpBrLrpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783278989; c=relaxed/simple;
	bh=i9LlD/KcxLG3aUiCljiaiHv4SPEnmM85ISrnsQ42UvU=;
	h=Date:To:From:Subject:Message-Id; b=lGw9L6YYZn2CeS5DFa4Z3zkXOQRiozEM1F6vJEZ2WOJRWLrLfJU71ngqVLPh5/EKfschhr34XFJ+7gZh42GeLbtlF7bl4rWbKk51UbtO087cBQ3kN6uHA7IQttN/wecp97DKg9eNQHnGaOIhTMwoU9TS2KC6jgp0kNim5UQgWe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RDF/4BcJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RDF/4BcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66BA1F000E9;
	Sun,  5 Jul 2026 19:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783278987;
	bh=lZKkDFHSMCBnQ9YRWMGrDeBVurYsp0c1fpMc5KQ/bwA=;
	h=Date:To:From:Subject;
	b=RDF/4BcJETJ7pVMqlfPI3fUzEYJBPq2d+DA2Qkku0ruAaTb4PajidSU+AOOuITjK4
	 0UZR8DsM0mdIT3Gk9ax+ayodqrjHd1W+ueIBSYIxMYkW8G1ZzCjlVgPZT2VytfmtkX
	 bUDwg33I82oXrsEEYKqLXwzr3l3qo0tdCrsYaZEk=
Date: Sun, 05 Jul 2026 12:16:27 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-safely-validate-src-on-damon_commit_ctx.patch added to mm-new branch
Message-Id: <20260705191627.D66BA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: safely validate src on damon_commit_ctx()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-safely-validate-src-on-damon_commit_ctx.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-safely-validate-src-on-damon_commit_ctx.patch

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
Subject: mm/damon/core: safely validate src on damon_commit_ctx()
Date: Sun, 5 Jul 2026 08:55:52 -0700

Patch series "mm/damon: validate all parameters in the core".

DAMON has a number of parameters.  Some of the parameters are validated by
DAMON, while some are validated by DAMON API callers.  Each caller has
their own set of parameters that are exposed to users.  Hence each caller
has their own ways to do the validation.  There is no clear lines for the
responsibilities.  It is confusing and easy to make mistakes at
validations.  Actually we found a few bugs in the class.

Define DAMON core as the place to do all the validations and implement
those.  damon_set_regions(), damon_start() and damon_commit_ctx() are the
three main DAMON core API functions for setup of DAMON parameters.  Make
the three functions to do safe and holistic parameter checks.  The first
one is already providing the validation, so changes are only for the last
two functions.

This might add unnecessary validations for some use cases.  The overhead
should be negligible as parameters update is expected to only rarely
happen.  It reduces the number of places to check and fix for bugs of the
class from all callers to the single component.  The maintenance
efficiency gain is obvious.

Further cleanup documents and caller code.  Make the lines of validation
duties clearer.  Remove validations that are no more needed owing to the
core validations.

Patches Sequence
================

Patch 1 implements the core holistic parameters validation for
damon_commit_ctx().  Patch 2 extends the validation to damon_start(). 
Patch 3 removes the duplicated holistic parameters validation in DAMON
sysfs interface, which is now embedded into the core layer.  Patches 4 and
5 remove duplicated min_region_sz validation in DAMON modules.  Patches 6
updates kernel doc to clarify damon_set_regions() is doing the range
validation.  Patches 7 and 8 remove monitoring target range validations
that doesn't necessary thanks to the validation in damon_set_regions().


This patch (of 8):

damon_commit_ctx() does its holistic parameter set validation while
applying the new parameter in the set one by one.  If it finds a parameter
is invalid, because some invalid parameters may already be committed (it
is called "commit" but not atomic and irreversable), it stops the running
DAMON context.

The callers of the function therefore have to validate the parameters
before calling it.  Because the function already embeds holistic
validation, DAMON_SYSFS reuses it in a safe way.  It creates a
test-purpose context that is not running but mimics the running one, and
calls damon_commit_ctx() against the test purpose context.  If it
succeeds, the parameters are considered valid, and a real
damon_commit_ctx() call against the running context is made with those.

Other callers such as DAMON_RECLAIM and DAMON_LRU_SORT do not expose full
parameters to users.  For efficiency, they validate only the known set of
parameters.  The efficiency gain is arguably small and doubtful, though. 
Meanwhile the maintenance overhead of the multiple different validations
is clearly high.  We actually found and fixed a few bugs in the class.

Update damon_commit_ctx() to embed DAMON_SYSFS' safe and holistic
validation approach.  Callers can simply call damon_commit_ctx() without
worrying if their parameters are invalid.

Note that damon_commit_ctx() can still cause an unexpected stop of the
running context, if internal memory allocation fails.  It is arguably
unlikely since those internal allocations are too small to fail, but
theoretically possible.  It should also be better addressed, but not
necessarily a blocker of this small and incremental improvement effort.

Link: https://lore.kernel.org/20260705155600.96555-1-sj@kernel.org
Link: https://lore.kernel.org/20260705155600.96555-2-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   61 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 47 insertions(+), 14 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-safely-validate-src-on-damon_commit_ctx
+++ a/mm/damon/core.c
@@ -1664,20 +1664,7 @@ static int damon_commit_probes(struct da
 	return 0;
 }
 
-/**
- * damon_commit_ctx() - Commit parameters of a DAMON context to another.
- * @dst:	The commit destination DAMON context.
- * @src:	The commit source DAMON context.
- *
- * This function copies user-specified parameters from @src to @dst and update
- * the internal status and results accordingly.  Users should use this function
- * for context-level parameters update of running context, instead of manual
- * in-place updates.
- *
- * This function should be called from parameters-update safe context, like
- * damon_call().
- */
-int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
+static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 {
 	int err;
 	struct damos *scheme;
@@ -1732,6 +1719,52 @@ int damon_commit_ctx(struct damon_ctx *d
 	return 0;
 }
 
+static struct damon_ctx *damon_new_test_ctx(struct damon_ctx *dst)
+{
+	struct damon_ctx *test_ctx;
+	int err;
+
+	test_ctx = damon_new_ctx();
+	if (!test_ctx)
+		return NULL;
+	err = __damon_commit_ctx(test_ctx, dst);
+	if (err) {
+		damon_destroy_ctx(test_ctx);
+		return NULL;
+	}
+	return test_ctx;
+}
+
+/**
+ * damon_commit_ctx() - Commit parameters of a DAMON context to another.
+ * @dst:	The commit destination DAMON context.
+ * @src:	The commit source DAMON context.
+ *
+ * This function copies user-specified parameters from @src to @dst and update
+ * the internal status and results accordingly.  Users should use this function
+ * for context-level parameters update of running context, instead of manual
+ * in-place updates.
+ *
+ * This function should be called from parameters-update safe context, like
+ * damon_call().
+ */
+int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
+{
+	struct damon_ctx *test_ctx;
+	int err;
+
+	test_ctx = damon_new_test_ctx(dst);
+	if (!test_ctx)
+		return -ENOMEM;
+	err = __damon_commit_ctx(test_ctx, src);
+	if (err)
+		goto out;
+	err = __damon_commit_ctx(dst, src);
+out:
+	damon_destroy_ctx(test_ctx);
+	return err;
+}
+
 /**
  * damon_nr_running_ctxs() - Return number of currently running contexts.
  */
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

