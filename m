Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F6E44F548;
	Thu, 10 Sep 2026 21:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789075930; cv=none; b=KtZ4Xgl41tV9DQQ76fjdgLbQoWN8q9XpcP3AIxbcvdx/2A6TO+8EPC8UuOY0u7g3lZhO5CvUuHeRn2AX8fi1FLFyI3dscoDwNHg7V4czfwDqVwtRzjxCMyTBXmSSHnBd6PU5FNmsbZ5N0jCaMg8nW2klEl6m4hguu1bu87E0bIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789075930; c=relaxed/simple;
	bh=dY/ayxkXSuNhB7Ui6cSoDZhtYVRwSU0hckyB0cFla5s=;
	h=Date:To:From:Subject:Message-Id; b=hv8j5MNNM4Jk/kB4KvwyVp4OjEuscnvaA1UKYlXLN5XrVHNjVQKGmtcKBrBhe2IQOB0vItOUNq6/eJAyWTBuvHtGmBsV+0S0UQRvN5YlvHiF6Fx+tfhaHFOmuSyCWRksVckyH8V+9hKNgwFU491VFoZKT0VpflujnmWzg6AaZxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M5SMchfV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M5SMchfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE511F000FF;
	Thu, 10 Sep 2026 21:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789075928;
	bh=/WcAo4dUzNOOqwVr2ROhjAJ2Krmf+6K96u8CXurCIR8=;
	h=Date:To:From:Subject;
	b=M5SMchfV6PecEA9rSra3nP9Yysmp8HCjo6G1sClBvLDe9zUmXNQPmipybm2bMtU6t
	 3xEg8sJTCoNNMHzUbPFOzNZqb5OVsQgSMuv5X3hvC3+UaPeVhdWG6yhavJnbcB6Y6x
	 Hpw/1o55U97gFbE3dFwQJpCo340/D3h6ECY10jG8=
Date: Thu, 10 Sep 2026 14:32:08 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,lienze@kylinos.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-reset-invalid-quota-charge_target_from.patch added to mm-hotfixes-unstable branch
Message-Id: <20260910213208.7EE511F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: reset invalid quota->charge_target_from
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-reset-invalid-quota-charge_target_from.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-reset-invalid-quota-charge_target_from.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/damon/core: reset invalid quota->charge_target_from
Date: Thu, 10 Sep 2026 07:28:45 -0700

DAMOS can suddenly stop working if a target process that the quota is just
fully charged on is terminated.  Fix by catching and processing the corner
case.

When DAMOS quota is fully charged, the target and the region to continue
applying the action in the next round is saved in
damos_quota->charge_{target,addr}_from.  In the next round, DAMOS iterates
targets and regions from the beginning.  It skips applying the action to
the regions until it visits and skips the saved target/region.

Virtual address space targets become invalid if the process is terminated.
Trying to apply the scheme to invalid target is just a waste of time. 
Hence commit 6e4930e33329 ("mm/damon/core: fix wasteful CPU calls by
skipping non-existent targets") made the logic to skip invalid targets. 
However, it does skip before the charged target/region skipping/updating.

Let's suppose the user runs DAMOS for multiple virtual address spaces with
a quota.  The quota exceeded in the middle of a virtual address space. 
And the process of the address space is terminated.  Then the
charge_target_from points to the invalid target.  The pointer update logic
is skipped for the invalid target, so the charge_target_from is never
updated.  DAMOS action to every target/region is skipped.  From the user's
perspective, it would look like suddenly DAMOS has stopped working.

No critical leak or crash can happen.  The user could reinstall the
scheme.  But this makes use of DAMOS under certain setups quite
unreliable.

When the invalid target is found, further check the corner case and reset
the pointer.

This issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260910142846.172957-1-sj@kernel.org
Link: https://lore.kernel.org/20260830064708.40CA61F000E9@smtp.kernel.org [1]
Fixes: 6e4930e33329 ("mm/damon/core: fix wasteful CPU calls by skipping non-existent targets")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Enze Li <lienze@kylinos.cn>
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-reset-invalid-quota-charge_target_from
+++ a/mm/damon/core.c
@@ -3245,8 +3245,15 @@ static void kdamond_apply_schemes(struct
 	max_region_sz = damon_region_sz_limit(c);
 	mutex_lock(&c->walk_control_lock);
 	damon_for_each_target(t, c) {
-		if (c->ops.target_valid && c->ops.target_valid(t) == false)
+		if (c->ops.target_valid && c->ops.target_valid(t) == false) {
+			damon_for_each_scheme(s, c) {
+				if (s->quota.charge_target_from != t)
+					continue;
+				s->quota.charge_target_from = NULL;
+				s->quota.charge_addr_from = 0;
+			}
 			continue;
+		}
 		damos_apply_target(c, t, max_region_sz);
 	}
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-vaddr-avoid-hw-driven-pte-updates-during-damon_hugetlb_mkold.patch
mm-damon-core-reset-invalid-quota-charge_target_from.patch
mm-damon-core-skip-applying-scheme-if-region-split-for-quota-fails.patch
mm-damon-paddr-respect-folio-end-for-damos_stat.patch
mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold.patch
mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch
mm-damon-core-introduce-damon_filter_type_pgidle_unset.patch
mm-damon-paddr-support-pgidle_unset-probe-filter-type.patch
mm-damon-sysfs-support-pgidle_unset-probe-filter-type.patch
docs-mm-damon-design-document-pgidle_unset-probe-filter-type.patch
mm-damon-core-introduce-damon_prep-struct.patch
mm-damon-core-commit-preps.patch
mm-damon-core-introduce-damon_operations-prep_probes.patch
mm-damon-paddr-support-damon_prep.patch
mm-damon-sysfs-implement-preps-directory.patch
mm-damon-sysfs-implement-preps-nr_preps-file.patch
mm-damon-sysfs-create-directories-for-nr_preps-writes.patch
mm-damon-sysfs-implement-prep_action-file.patch
mm-damon-sysfs-pass-preps-to-damon-core.patch
selftests-damon-sysfssh-test-probe-prep-sysfs-files.patch
docs-mm-damon-design-document-probe-preps.patch
docs-admin-guide-mm-damon-usage-document-probe-preps-sysfs-files.patch
docs-abi-damon-document-probe-prep-sysfs-files.patch
mm-damon-tests-core-kunit-test-committing-psi-goal-to-psi-goal.patch
mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total.patch
mm-damon-core-copy-nid-for-eligible_mem_bp-damos-quota-goal-commit.patch
mm-damon-sysfs-set-next-refresh-jiffies-per-sysfs-context.patch
mm-damon-tests-core-kunit-test-damon_commit_filter.patch
mm-damon-tests-core-kunit-add-damon_commit_probes-test.patch
selftests-damon-_damon_sysfs-implement-damonprobes.patch
selftests-damon-drgn_dump_damon_status-dump-probes.patch
selftests-damon-sysfspy-extend-commit-assertion-function-for-probes.patch
selftests-damon-sysfspy-test-damon-probes.patch
mm-damon-core-use-damon_nr_samples_per_aggr-for-max-merge-threshold.patch
mm-damon-core-remove-debug-messages.patch
mm-damon-core-remove-debug-messages-fix.patch
mm-damon-vaddr-remove-a-debug-message.patch
mm-damon-core-validate-number-of-probes-in-valid_probe_params.patch
mm-damon-sysfs-remove-probes-number-validation.patch
mm-damon-tests-core-kunit-extend-set_regions-test-for-error-case.patch
mm-damon-tests-core-kunit-test-=0-size-damon_set_regions-inputs.patch
mm-damon-tests-core-kunit-test-overlapping-ranges-for-set_regions.patch
mm-damon-tests-core-kunit-test-damon_nr_samples_per_aggr.patch
selftests-damon-sysfssh-test-hugepage_mem_bp-quota-goal.patch
docs-mm-damon-maintainer-profile-update-ai-review-for-sashiko-replies.patch
docs-abi-damon-recommend-subsystem-doc-instead-of-admin-guide.patch
mm-damon-core-error-damos_commit_quota_goal-for-zero-target_value.patch
revert-mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch
revert-samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch
mm-damon-core-handle-null-ctx-parameter-in-damon_call.patch
mm-damon-core-set-ctx-call_controls_obsolete-in-damon_new_ctx.patch
mm-damon-reclaim-remove-unnecessary-damon_call-param-validation.patch
mm-damon-lru_sort-remove-unnecessary-damon_call-param-validation.patch
mm-damon-vaddr-support-prep_probes.patch
mm-damon-paddr-move-probe-filter-handling-to-ops-common.patch
mm-damon-vaddr-support-apply_probe.patch
mm-damon-vaddr-extend-apply_probes-for-hugetlb.patch
mm-damon-vaddr-support-pgidle_unset-probe-filter-type.patch
mm-damon-api-introduce-damon_filter_type_pgidle_set.patch
mm-damon-paddr-support-damon_filter_type_pgidle_set.patch
mm-damon-vaddr-support-damon_filter_type_pgidle_set.patch
mm-damon-sysfs-support-damon_filter_type_pgidle_set.patch
docs-mm-damon-design-update-for-pgidle_set-probe-filter.patch

