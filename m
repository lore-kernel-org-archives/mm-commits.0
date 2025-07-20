Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D91481A3
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 01:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976409; cv=none; b=ViQFNtnDvADCVQR3584DqnL+ag7ow4q4SYg8cg2Y9RFDvvAR3Mu9M/5qH5L5J7SAXRsd2w8cJBuyoxkRlDApDQHPFPfTrVUN90gOGZQIdAkTxyuodyjPkLT7HbjuzvsiiBBRpHMDMISGvE8XdNuyYcK06r7/nSSdLT/wQL0nxpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976409; c=relaxed/simple;
	bh=dH84ToyHEAF/kWuVv5+FvDPmuTZ/pTamKzdeXpDBX/Q=;
	h=Date:To:From:Subject:Message-Id; b=fmBtjowTmVQsJ7mj1aKbtJOf52/7IiZGm9LKtkdsTk3oU3lAwAX8aRlMUfnvuAl2poega8fQvezxotgEHA8AJC477uh47K7PHpGLeOKPLMXRjULI3P/OPL+vQ0cctRWFsDlO2/c7q7wH4EhP66QNkHJyw9ScfsV+jUVxmsfc/VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cPrQ7aXf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cPrQ7aXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E251AC4CEE3;
	Sun, 20 Jul 2025 01:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976409;
	bh=dH84ToyHEAF/kWuVv5+FvDPmuTZ/pTamKzdeXpDBX/Q=;
	h=Date:To:From:Subject:From;
	b=cPrQ7aXfmVKtvnUJvhZ2Jjh+M2urHC/HxoHDBqhEWdlFTVEpWSXtQi84PcNbTTwjL
	 yOJNVfJfm1NelIaTGGC1cQy0kVdOF23HzZt4EcWqFGFoAb7MZ8LsEeNrF1EucUFrUC
	 ZQTP7nS6oy3kQ2wCEgyQMBEkD092z6H6gBKaRem0=
Date: Sat, 19 Jul 2025 18:53:28 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-core-add-cleanup_target-ops-callback-fix-2.patch removed from -mm tree
Message-Id: <20250720015328.E251AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: remove damon_ctx->callback kernel-doc comment
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-cleanup_target-ops-callback-fix-2.patch

This patch was dropped because it was folded into mm-damon-core-add-cleanup_target-ops-callback.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: remove damon_ctx->callback kernel-doc comment
Date: Tue, 15 Jul 2025 11:52:39 -0700

Commit 769bd386e490 ("mm/damon/core: add cleanup_target() ops callback")
on mm-unstable tree removed callback field of damon_ctx, but not erased
the kernel-doc comment for the field.  This results in build warning.  Fix
it by removing the obsolete comment.

Link: https://lkml.kernel.org/r/20250715185239.89152-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-core-add-cleanup_target-ops-callback-fix-2
+++ a/include/linux/damon.h
@@ -774,7 +774,6 @@ struct damon_attrs {
  * Accesses to other fields must be protected by themselves.
  *
  * @ops:	Set of monitoring operations for given use cases.
- * @callback:	Set of callbacks for monitoring events notifications.
  *
  * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
  * @schemes:		Head of schemes (&damos) list.
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
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

