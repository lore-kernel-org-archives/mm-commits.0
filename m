Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487C1481A3
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 01:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976408; cv=none; b=YT6eF/ghVebCJh/dwmnYHQbnGS53CrlvQ6OBRe4OX2mb85TLEmF+qd8Ec9tUFKXbKsK8R2cYk8JZa1nhB2rc+RQTlSz0LmiKfbwT+REddlBp5WI2XLUqZCONcSnCcA1XsVcXrhruAi+CkSICjyRNPHF5I8ua9H+ZNDzgGqHyNsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976408; c=relaxed/simple;
	bh=FCntTPAje0MqezDNYHq2dOHF4u14x2Vs1Mji0qZDT/c=;
	h=Date:To:From:Subject:Message-Id; b=QSnr0Yg9dM6cbe+w6R0jy/uRMJRvJIkMOb0ftQq9s60itCUZ87JK1ub7UjZKS5UMlxcUqxN38uT8ugLUe5uum1cUczifPYIxs7qKafEstnpRYEB3/hcq9qQgZExkZqVdw4d6UZBOME+rWfw+Qtp0adKEedSfRIlWYir5hSLPxYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MQ2xj/6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MQ2xj/6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE0EC4CEE3;
	Sun, 20 Jul 2025 01:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976407;
	bh=FCntTPAje0MqezDNYHq2dOHF4u14x2Vs1Mji0qZDT/c=;
	h=Date:To:From:Subject:From;
	b=MQ2xj/6QBdrpi4nFVegN7AZgghX8cPp3DHNuCf41Lpi47LaU3COJ5HiA6nLoHE5Xr
	 ckyuen56anl/eURCPPo31+jyTCbC1ajqm+8Ov+k4je6GjpXgrKFakWejfPN3fhwMdu
	 LOBugsgV8EhdDQxNGlLTzhKecLBf/1mVGHQMDOks=
Date: Sat, 19 Jul 2025 18:53:27 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-core-add-cleanup_target-ops-callback-fix.patch removed from -mm tree
Message-Id: <20250720015327.BBE0EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: add kernel-doc comment for damon_operations->cleanup_target
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-cleanup_target-ops-callback-fix.patch

This patch was dropped because it was folded into mm-damon-core-add-cleanup_target-ops-callback.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: add kernel-doc comment for damon_operations->cleanup_target
Date: Tue, 15 Jul 2025 11:52:38 -0700

Commit 769bd386e490 ("mm/damon/core: add cleanup_target() ops callback")
on mm-unstable added cleanup_target field to damon_operations, but forgot
adding the kernel-doc description.  This causes a build warning.  Fix it
by adding the description.

Link: https://lkml.kernel.org/r/20250715185239.89152-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/20250715185549.264260b8@canb.auug.org.au
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/damon.h~mm-damon-core-add-cleanup_target-ops-callback-fix
+++ a/include/linux/damon.h
@@ -576,6 +576,7 @@ enum damon_ops_id {
  * @get_scheme_score:		Get the score of a region for a scheme.
  * @apply_scheme:		Apply a DAMON-based operation scheme.
  * @target_valid:		Determine if the target is valid.
+ * @cleanup_target:		Clean up each target before deallocation.
  * @cleanup:			Clean up the context.
  *
  * DAMON can be extended for various address spaces and usages.  For this,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
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
mm-damon-accept-parallel-damon_call-requests.patch
mm-damon-core-introduce-repeat-mode-damon_call.patch
mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch
mm-damon-core-add-cleanup_target-ops-callback.patch
mm-damon-core-add-cleanup_target-ops-callback-fix-2.patch
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

