Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305A715D1;
	Wed,  8 Oct 2025 00:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759883008; cv=none; b=EwLMOzgQH4jMMFXpZrpN3vW3+b1whCDoKmuetwvcemgRJ8SgQYraCHjgTAdu01WxhbQlEqrUOF2osqMs9xDeZW7EI0Td26GzHcw8dS1qlmbXQD8+7RvgSfQDPGtZk6okjHnGU4pG5ZcLTjagzbe/zZ5jwXoQZqwk1VYa4orotG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759883008; c=relaxed/simple;
	bh=HG766PIEGjLLJ1t7BYCmz5lJH3aG0rEHRVB6Rvdl1Ks=;
	h=Date:To:From:Subject:Message-Id; b=kvvgAW+8ZiIC41w7FW4mxT278XaF3qc8os0q+FPFKPVkgUO5/0lLlCcNKyEHD/5TP6/cqcLg4udytp1RJoJpx63qIu68kg5aEBMFBMhj+VJ06XJsThpc5rfylwrhoxq7rEvxe2rnQofSuFndtekWXntFiHQQ7D5FhYJE8J/v0k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BZnHZr4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BZnHZr4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24ECC4CEF1;
	Wed,  8 Oct 2025 00:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759883004;
	bh=HG766PIEGjLLJ1t7BYCmz5lJH3aG0rEHRVB6Rvdl1Ks=;
	h=Date:To:From:Subject:From;
	b=BZnHZr4+Lw+NIuMnOEODWu1ZgwTQb6EYZ633JcsjbIiW/pYr1JE+BIu4p75CsAF3l
	 Cg+BgwQ6sYjtLRuMPBIxUvl3fHkXBJjidSQyYlHv3ueH8GiqCB2oPEJFSBgKFn40D6
	 VPfodvnuAPvZkjKBTTEj56TzeD1ljuk+I7y0oln8=
Date: Tue, 07 Oct 2025 17:23:24 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-dealloc-commit-test-ctx-always.patch added to mm-hotfixes-unstable branch
Message-Id: <20251008002324.A24ECC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: dealloc commit test ctx always
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-dealloc-commit-test-ctx-always.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-dealloc-commit-test-ctx-always.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/damon/sysfs: dealloc commit test ctx always
Date: Fri, 3 Oct 2025 13:14:55 -0700

The damon_ctx for testing online DAMON parameters commit inputs is
deallocated only when the test fails.  This means memory is leaked for
every successful online DAMON parameters commit.  Fix the leak by always
deallocating it.

Link: https://lkml.kernel.org/r/20251003201455.41448-3-sj@kernel.org
Fixes: 4c9ea539ad59 ("mm/damon/sysfs: validate user inputs from damon_sysfs_commit_input()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-dealloc-commit-test-ctx-always
+++ a/mm/damon/sysfs.c
@@ -1476,12 +1476,11 @@ static int damon_sysfs_commit_input(void
 	if (!test_ctx)
 		return -ENOMEM;
 	err = damon_commit_ctx(test_ctx, param_ctx);
-	if (err) {
-		damon_destroy_ctx(test_ctx);
+	if (err)
 		goto out;
-	}
 	err = damon_commit_ctx(kdamond->damon_ctx, param_ctx);
 out:
+	damon_destroy_ctx(test_ctx);
 	damon_destroy_ctx(param_ctx);
 	return err;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-catch-commit-test-ctx-alloc-failure.patch
mm-damon-sysfs-dealloc-commit-test-ctx-always.patch
mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch

