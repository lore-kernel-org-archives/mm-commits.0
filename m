Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FA52C0268
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 02:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782957826; cv=none; b=HyJ8YTIK39OuYaETrx2/gKzKvBNS5VM+eepw0kRlU5KnWlX02XqQf7TOCdUN+UzbGXYUBLS3h79SIuBZKVMFWo0oNuuFLvGUvEftnmcnqfQLg6yDRYu+kutPv6v68Jczacw4A14tuETOrzA36TAtexfwKNkzZyIZIwKLCyLMork=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782957826; c=relaxed/simple;
	bh=GFs+X3Y2HuxkdXDgap1N4QRyw1JMfg3/ag+uRKEE+Yg=;
	h=Date:To:From:Subject:Message-Id; b=P1vnXTIUM/anfb9Is7eNI1Yu/QkpcPKgdiEIpqoq+4cN8pOfGbJPNvoSXA+9KFW46J8hkpptwoC7WEvvxSc6nJZrVX/16Wbmm9ZtY1IWJkLzDRwCpRW5W8CJ4msvUxIbI6HCuihCaLmcQwYwqrtfQpiAoOF+jvFMT43Ba0c7+sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WGA3vScc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WGA3vScc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C451F00A3D;
	Thu,  2 Jul 2026 02:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782957825;
	bh=cd3tSYatzYB+Sq8DiGWnftf/Q89TZ7UeLip5FoqTV/I=;
	h=Date:To:From:Subject;
	b=WGA3vSccY6XPHLZrsKQ8f3T9LdQye6jIuRdV8yZCEopFijUg0ar9FMLidhYQoXDnN
	 DxzZ3xC5q0a3CW1npB9vihg4N57CrmIy9xT12HmidVtnj4YiscnOOHRObYlJIJDOuJ
	 lckz2hVFrC8WmkAoHRlU85L/duKHtal4kdFbKePY=
Date: Wed, 01 Jul 2026 19:03:44 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-add-a-kernel-doc-comment-for-damon_ctx-rnd_state.patch removed from -mm tree
Message-Id: <20260702020345.44C451F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: add a kernel-doc comment for damon_ctx->rnd_state
has been removed from the -mm tree.  Its filename was
     mm-damon-add-a-kernel-doc-comment-for-damon_ctx-rnd_state.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon: add a kernel-doc comment for damon_ctx->rnd_state
Date: Sun, 28 Jun 2026 15:08:04 -0700

Fix below kernel document build warning:

    WARNING: ../include/linux/damon.h:909 struct member 'rnd_state' not described in 'damon_ctx'

Link: https://lore.kernel.org/20260628220808.98931-3-sj@kernel.org
Fixes: 9012c4e647df ("mm/damon: replace damon_rand() with a per-ctx lockless PRNG")
Signed-off-by: SJ Park <sj@kernel.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://lore.kernel.org/4df95955-b255-4e5a-90c4-35db02f3111f@infradead.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-add-a-kernel-doc-comment-for-damon_ctx-rnd_state
+++ a/include/linux/damon.h
@@ -849,6 +849,7 @@ struct damon_attrs {
  * @pause:	Pause kdamond main loop.
  * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
  * @schemes:		Head of schemes (&damos) list.
+ * @rnd_state:	Per-ctx PRNG state for damon_rand().
  */
 struct damon_ctx {
 	struct damon_attrs attrs;
@@ -906,7 +907,6 @@ struct damon_ctx {
 	struct list_head adaptive_targets;
 	struct list_head schemes;
 
-	/* Per-ctx PRNG state for damon_rand(); kdamond is the sole consumer. */
 	struct rnd_state rnd_state;
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are

maintainers-s-seongjae-sj.patch
mm-damon-core-validate-ranges-in-damon_set_regions.patch
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

