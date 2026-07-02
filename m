Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4228428030E
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 02:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782957825; cv=none; b=SiOHgj1l9fZ/wqGHw+DtQ/anWEhQCOztBAEMcOXfeLOIEzAdZ7sq6GGUF1NZaiZ1nN/2JroEdKXkjvD1VqOIO3/D3BtZhr29tTAs/EaccaCZjygWCVhPoxRSGXU76GMtQGvQ2eNgR8FphaUZiUhFnp9wYJ4TQO41WiDNmubK2EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782957825; c=relaxed/simple;
	bh=/z3M8pLhkcD+NMUN+LhxMa26sCwJKkkvRGWLDKKdycM=;
	h=Date:To:From:Subject:Message-Id; b=JAYRdiGBlxPtqjc4zHj3ogNBhqeyaGIs+qjFxKKBvjdRz0M/OpBuWldqGzDbGFmHy5o8kJq6A+kv48jakpiGymEck0XFRYfZHArqRQFc1bDThQiG47Mo1pUDjyTkd79I4MvfKQC7i5pHWbtvyTeuSa3A+Bgh1oDvjCLb1TCBXzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yokGE9Jm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yokGE9Jm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CD51F000E9;
	Thu,  2 Jul 2026 02:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782957824;
	bh=PcevMWw6d8t0fKtJfudVhOkkgF0/Gr/ToJeZrJ05W+w=;
	h=Date:To:From:Subject;
	b=yokGE9JmdRWIOht+VG1l08eD8gMQy42D2IYdcLxZW5J8NGuRdtg5TemtkROcOebqR
	 nDqru80E/PyAIiqx0+y4J+LeHsorrPd79pv6MF1TF0sqVoTy75LSujzs7HvgJkeUco
	 GUeSgUhUG/Og5YhUw8k+BMpQNTlRcY7wsiCj2nzI=
Date: Wed, 01 Jul 2026 19:03:43 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-add-a-kernel-doc-comment-for-damon_ctx-probes.patch removed from -mm tree
Message-Id: <20260702020344.17CD51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: add a kernel-doc comment for damon_ctx->probes
has been removed from the -mm tree.  Its filename was
     mm-damon-add-a-kernel-doc-comment-for-damon_ctx-probes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon: add a kernel-doc comment for damon_ctx->probes
Date: Sun, 28 Jun 2026 15:08:03 -0700

The two fields of damon_ctx struct dont have their kernel-doc comments.
That causes kernel document builds to warn.  Fix those.


This patch (of 2):

Fix below document build warning:

    WARNING: ../include/linux/damon.h:909 struct member 'probes' not described in 'damon_ctx'

Link: https://lore.kernel.org/20260628220808.98931-1-sj@kernel.org
Link: https://lore.kernel.org/20260628220808.98931-2-sj@kernel.org
Fixes: 18c777859f28 ("mm/damon/core: embed damon_probe objects in damon_ctx")
Signed-off-by: SJ Park <sj@kernel.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://lore.kernel.org/4df95955-b255-4e5a-90c4-35db02f3111f@infradead.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/damon.h~mm-damon-add-a-kernel-doc-comment-for-damon_ctx-probes
+++ a/include/linux/damon.h
@@ -843,6 +843,7 @@ struct damon_attrs {
  * including damon_call() and damos_walk().
  *
  * @ops:	Set of monitoring operations for given use cases.
+ * @probes:	Head of probes (&damon_probe) list.
  * @addr_unit:	Scale factor for core to ops address conversion.
  * @min_region_sz:	Minimum region size.
  * @pause:	Pause kdamond main loop.
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

