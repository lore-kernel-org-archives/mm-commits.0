Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A858AEC2
	for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2025 22:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752619710; cv=none; b=Md1LUdb3ZTwG+ZrSDBxkCZQd+Tszi99XIXUmQXhUP36/pwxSHBNzjJXhEyfJUipAmOdjnVMUMCd5DSK4gSJpIH8cqBuwyuv6nuqCTpsD/ktrA4MbcBEAsbWTZKoCQFrcpmPEbILDt4m4wlsz24XaH1zxpX313zZyY0UJwoyguSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752619710; c=relaxed/simple;
	bh=m01Ibnwxho6wP/8KD/dNRxjU7f4z7RuO0dBEBpb85ys=;
	h=Date:To:From:Subject:Message-Id; b=uHyBvxqeq4Hft2InypCi3jMj5wYyb+tge38CFI32E5yyKNKv1wxfYlCZkb1yfaH/QTC0CPLUEj+WY+kAZGUacrjx4jeMkHIyDON9QsI86C+07nhA4nN4F9ilTavolkjCn+wo/Bg2GtP1FvpYIOPbyNjV+zLJzVu+8eccQREhuNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jq5SjKJS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jq5SjKJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC411C4CEE3;
	Tue, 15 Jul 2025 22:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752619710;
	bh=m01Ibnwxho6wP/8KD/dNRxjU7f4z7RuO0dBEBpb85ys=;
	h=Date:To:From:Subject:From;
	b=Jq5SjKJS7f3MDRpPn/EEMSTxqfkGPXV8N6/+JWDFy6gKzcxOmm8EgAuEZho9fsy27
	 dmnpQlWx+Li2ZVOTi60zaf+jpwA+ctI0tDy96rLEtgnmzW5hFKWwWk/p5+VrCtrCCq
	 fjdhGbGH/C/C3CvMVhDCODLL6vSUtBHbwI8NjAHI=
Date: Tue, 15 Jul 2025 15:48:29 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-cleanup_target-ops-callback-fix-2.patch added to mm-unstable branch
Message-Id: <20250715224829.EC411C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: remove damon_ctx->callback kernel-doc comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-add-cleanup_target-ops-callback-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-add-cleanup_target-ops-callback-fix-2.patch

This patch will later appear in the mm-unstable branch at
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
mm-damon-core-add-cleanup_target-ops-callback-fix.patch
mm-damon-core-add-cleanup_target-ops-callback-fix-2.patch
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch

