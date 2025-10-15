Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F001624D5;
	Wed, 15 Oct 2025 20:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760559907; cv=none; b=JxkauMgVWgbGkf5kUxcZDHwmjWRHPZW4DA3BU5Q2bGmurtkeOr2DpKFf5IVQp2rf37U4Ivi5KwOaqz7FqlT3J8r6jq+l9FaeHsYwm96AIKEWhZ4ZV0V5tYxJwlL2c379LbBBZxzflkujGC9jtZa9+UNCn92WkFhXNJjMbJjzxjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760559907; c=relaxed/simple;
	bh=PgpDUoepzdC4R30vQ+IqqcIdsiLeMz1UftMTBHP2yq8=;
	h=Date:To:From:Subject:Message-Id; b=k0RJKKIRsOswXnQdT8JF4R5y8tmbGJqweMpMZpxjTOxWhG1I9k2dje/LfUKeOHnjG2wFxrBBdJrQtlmwIteW700nNBHhI04sYsxw+/jJcMgiEYW/65VIsR8rXnUccpq6lKIMmtm8ntxXQNeIf4tSBVK6EjZaIgfqFdw4D1mIU9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BHuSqMx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BHuSqMx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B788C113D0;
	Wed, 15 Oct 2025 20:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760559906;
	bh=PgpDUoepzdC4R30vQ+IqqcIdsiLeMz1UftMTBHP2yq8=;
	h=Date:To:From:Subject:From;
	b=BHuSqMx0Bw9auY0OtIafJaBJNqhc5HjISgU5mxJ6/1U8NoIU0QDeutEcwAtSsDOra
	 q+u83x3EZa8l9ecfCMKamuvn3m/rU5uX9p7M72JiFhIN0g5zf6yzXjtsKred8dXm/i
	 ghD9oBY0ZLAiZYAN3zt9TDjGRv+tfF0EmjujOIBU=
Date: Wed, 15 Oct 2025 13:25:05 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-dealloc-commit-test-ctx-always.patch removed from -mm tree
Message-Id: <20251015202506.7B788C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: dealloc commit test ctx always
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-dealloc-commit-test-ctx-always.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-fix-list_add_tail-call-on-damon_call.patch
mm-damon-core-use-damos_commit_quota_goal-for-new-goal-commit.patch
mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch

