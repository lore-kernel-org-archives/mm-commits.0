Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C453054E8
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763674699; cv=none; b=nStzofC4A6Miub6/M54oRzMnxlJFM7I3sZN34uYittzP1TaxJnSDTnHmEwL7OkiQUNVYwEp9WhXYObFPmywr+xb46QROiGvn8NoVAI69PetSs1DruNl570lVuY4/LxYYhEmfx49Pm33UXthVGJmXulOKXj65mWXY7UHeb62zLhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763674699; c=relaxed/simple;
	bh=0CLaI1sZP7k4WWfYhwL1jNXSlQ4bqR1A95UQTdYaw1E=;
	h=Date:To:From:Subject:Message-Id; b=kHVC564mX8rCV4wRWSfm/kKUzz4HtQNsJWFTjwlt7R7m0oknvnRO+4M0YEXCp2ESh9iIereXcQq4UHXDAQ4g4zbujmR3MIjKGGAVh/QR1a+6O6HyV9SwYE2++GV3QzhXpa+ZFFeeZnBUsBHu0J+RxgoBabiSQXE3BpMwkhAHEVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aQ/QMDoC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aQ/QMDoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3533EC4CEF1;
	Thu, 20 Nov 2025 21:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763674699;
	bh=0CLaI1sZP7k4WWfYhwL1jNXSlQ4bqR1A95UQTdYaw1E=;
	h=Date:To:From:Subject:From;
	b=aQ/QMDoCLS0oKPLIcUVP8oBp0pheToiYx4g8ip6jBpdRE5DaE96/ZKDDoJw6/dRmd
	 B6Qhnd7+6SikxbBVXjk8ketJVteOTW9NrjG4kmoHk61j42sSVtWax3PMOxtMB9nQPj
	 tsd5WgxkZbalz08PVnVOKqwuv/OcguJ1A+qt6Zso=
Date: Thu, 20 Nov 2025 13:38:18 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock-fix.patch removed from -mm tree
Message-Id: <20251120213819.3533EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: provide lvalue to pmd_present()
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock-fix.patch

This patch was dropped because it was folded into mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch

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
mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch
mm-damon-vaddr-consistently-use-only-pmd_entry-for-damos_migrate.patch
mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch
selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch
docs-mm-damon-maintainer-profile-fix-a-typo-on-mm-untable-link.patch
docs-mm-damon-maintainer-profile-fix-grammartical-errors.patch

