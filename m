Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C8421C9F5
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450122; cv=none; b=pplwig3pYzijbhuJviV3MiSq94wFLgmbqi0aceUn/ARim8NgKLPWK5kZbIfyo6CmdFmxlncYMdgLqq4fm+U7fDBeWSmM2qmYoQRn7bNCehenLsFsUSIAqYFUWnSniWkTytKXY2VnEsbTJHHT+8Ct4h7hQBpf0EsEDUlUyzhMM0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450122; c=relaxed/simple;
	bh=5IazPnaUgP5ygVIMo0ZmoSBUUd5nToebMXWgFGlJepI=;
	h=Date:To:From:Subject:Message-Id; b=clpZhLgFlV+EPV/RnxaiNc7bJksNK3fz+/E5xo8ytmC/FSFqRdeFefEoPUz3okEjDbnEvL9ISUzbn+cxB0josWcD8cS7eWIFd33MBVxyvyuiRMGb+evkddUjfJlu+neketZpE2fF+B+Ny2arGyfhVBuW13RjC3/PuKMsyQ970o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V5Fhkmfn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V5Fhkmfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6A4C4CEE3;
	Sun, 13 Jul 2025 23:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450122;
	bh=5IazPnaUgP5ygVIMo0ZmoSBUUd5nToebMXWgFGlJepI=;
	h=Date:To:From:Subject:From;
	b=V5FhkmfnxRcgDOoJgymMahqdlqo4Ybqper/09lZsRDKkrCNBjPpcLi/8vhycJMc+E
	 kFs8NriCstpWxPPKHcnmPfgXrsNOJ5YwMpVWHmUHU7hztPf3gqPFlGe0chXfDF5aEl
	 gQtk29RRhzGPwxawd/b4rgyyNqURy6GkBhbmFUiY=
Date: Sun, 13 Jul 2025 16:42:01 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-use-parameter-context-correctly.patch removed from -mm tree
Message-Id: <20250713234201.DF6A4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: use parameter context correctly
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-use-parameter-context-correctly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: use parameter context correctly
Date: Sun, 6 Jul 2025 12:32:07 -0700

damon_reclaim_apply_parameters() allocates a new DAMON context, stages
user-specified DAMON parameters on it, and commits to running DAMON
context at once, using damon_commit_ctx().  The code is mistakenly
over-writing the monitoring attributes and the reclaim scheme on the
running context.  It is not causing a real problem for monitoring
attributes, but the scheme overwriting can remove scheme's internal status
such as charged quota.  Fix the wrong use of the parameter context.

Link: https://lkml.kernel.org/r/20250706193207.39810-7-sj@kernel.org
Fixes: 11ddcfc257a3 ("mm/damon/reclaim: use damon_commit_ctx()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-use-parameter-context-correctly
+++ a/mm/damon/reclaim.c
@@ -194,7 +194,7 @@ static int damon_reclaim_apply_parameter
 	if (err)
 		return err;
 
-	err = damon_set_attrs(ctx, &damon_reclaim_mon_attrs);
+	err = damon_set_attrs(param_ctx, &damon_reclaim_mon_attrs);
 	if (err)
 		goto out;
 
@@ -202,7 +202,7 @@ static int damon_reclaim_apply_parameter
 	scheme = damon_reclaim_new_scheme();
 	if (!scheme)
 		goto out;
-	damon_set_schemes(ctx, &scheme, 1);
+	damon_set_schemes(param_ctx, &scheme, 1);
 
 	if (quota_mem_pressure_us) {
 		goal = damos_new_quota_goal(DAMOS_QUOTA_SOME_MEM_PSI_US,
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
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch

