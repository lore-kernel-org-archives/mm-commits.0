Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2D6302141
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 16:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763398371; cv=none; b=a1MADkX1osgqwtI9WYAmrUS6u4GuoxlXTpI/ZnwZjr5BM9l+QVUP3v7PwK+CK19uPhLsNmmPRkqY9kzwhMlvmV+tZ5VPGjRKjYyNyx+QxzM+axJQxL01FyFtGaN7uyDB3/4yNRX95IwkS6ICbcNkWZqPMPt9gtxx8ejDMYiIxBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763398371; c=relaxed/simple;
	bh=5kWo57xJlWTbvJ/PD4ibz7r0iyScrXQcTgBwZCeA5zs=;
	h=Date:To:From:Subject:Message-Id; b=oHbAhPsaqU2q4FrdSB0pCd6pL99o5pRI3/rKo9aHsrPrVQA064yjXEa0p8unLye2FPcHYzr4ZTlILS4HnUpyeJn2TNNJ3x/9vp267ZDahw0E0Ues0bu/qDOK3NPqrPD8Kkq6uaxnfFH8RMxq+zdp2nr6hrw+h49Y4MHZbNelHaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NzU+kWyA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NzU+kWyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D64C113D0;
	Mon, 17 Nov 2025 16:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763398370;
	bh=5kWo57xJlWTbvJ/PD4ibz7r0iyScrXQcTgBwZCeA5zs=;
	h=Date:To:From:Subject:From;
	b=NzU+kWyANi3BblVwN+d7HFZyLNpUnRnnrEzqqn/Vs6zbUoYBauEj/TFzGYOhB2G+U
	 fR5bClj4oKgfI3HBc6alaBcAClaYPMv8Vh62AYLcr7yqdaNfiLof7WR3O5p5SoODlR
	 q2eHOXkw4e8AdKZBih3ES5VutCAw26Ugb980iga4=
Date: Mon, 17 Nov 2025 08:52:49 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock-fix.patch added to mm-unstable branch
Message-Id: <20251117165250.99D64C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: provide lvalue to pmd_present()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock-fix.patch

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
Subject: mm/damon/vaddr: provide lvalue to pmd_present()
Date: Mon, 17 Nov 2025 07:36:43 -0800

On m68k, vaddr.c build fails since pmd_present() requires lvalue while
vaddr.c is passing pmdp_get().  Fix it.

Link: https://lkml.kernel.org/r/20251117154415.11041-1-sj@kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511172257.CjElDcRX-lkp@intel.com/
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock-fix
+++ a/mm/damon/vaddr.c
@@ -311,7 +311,9 @@ static int damon_mkold_pmd_entry(pmd_t *
 
 	ptl = pmd_trans_huge_lock(pmd, walk->vma);
 	if (ptl) {
-		if (pmd_present(pmdp_get(pmd)))
+		pmd_t pmde = pmdp_get(pmd);
+
+		if (pmd_present(pmde))
 			damon_pmdp_mkold(pmd, walk->vma, addr);
 		spin_unlock(ptl);
 		return 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-split-out-damos_test_commit_filter-core-logic.patch
mm-damon-tests-core-kunit-extend-damos_test_commit_filter_for-for-union-fields.patch
mm-damon-tests-core-kunit-add-test-cases-to-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goal-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goals-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota-test.patch
mm-damon-core-pass-migrate_dests-to-damos_commit_dests.patch
mm-damon-tests-core-kunit-add-damos_commit_dests-test.patch
mm-damon-tests-core-kunit-add-damos_commit-test.patch
mm-damon-tests-core-kunit-add-damon_commit_target_regions-test.patch
mm-damon-rename-damos-core-filter-helpers-to-have-word-core.patch
mm-damon-rename-damos-filters-to-damos-core_filters.patch
mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch
mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock-fix.patch
mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch
mm-damon-vaddr-consistently-use-only-pmd_entry-for-damos_migrate.patch
mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch
selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch
docs-mm-damon-maintainer-profile-fix-a-typo-on-mm-untable-link.patch
docs-mm-damon-maintainer-profile-fix-grammartical-errors.patch

