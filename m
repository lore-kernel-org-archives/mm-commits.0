Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FAA1442E8
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801589; cv=none; b=ZC8G4Ubj1ojG/B6+1bpt4wpveiR7FEQMl9Pe2h24a9BlqeDWE1dkv3Ty1ywhAeLioS8+PhbTEt/wOlrr3jwD3NuSakXx3mciNoBYRzMHHho1VMQTGnp9TyzQDS0N+3WnVu/e4pSKi9Xq2QJH3LtfMdKvcDWbqXLa31xus8BI8Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801589; c=relaxed/simple;
	bh=CC85eNCD3BafWW5gbxuUBcuILLmdegdOm0/5R/6ROpw=;
	h=Date:To:From:Subject:Message-Id; b=CvybLtiKs70q3Zy1kNvGkH+vR9EpAYzqSR8cqkxPPhATDfsz2P2rmrSTwI6tQbIxYUN2j25V0z6KeTURz53WM0PZxEVWjgN6tcDYDysbXbSt2uN4EaF5FjLcStIu31hJml8UE2elDjBkuy5TQ7VNuNA7t0l/u56pcyoz589U05c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iidRxqFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iidRxqFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D91C4FF6B;
	Tue, 27 Aug 2024 23:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724801589;
	bh=CC85eNCD3BafWW5gbxuUBcuILLmdegdOm0/5R/6ROpw=;
	h=Date:To:From:Subject:From;
	b=iidRxqFvQNvEtklAxM5iAfDtJDkup4e45vMA5fpJ4A8xYXgeEzZXozlvRJA4qEZjI
	 3GTIMC+qzA3XBxAyA6WiZzluysejOlhSFm83KeGfHfhzZNmH/e+8O7Rsr0v9Nt5O48
	 I2y/XinkwWpsAjbUd+SQd8lUTxz2Ys2mDLKEJNGU=
Date: Tue, 27 Aug 2024 16:33:08 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-dbgfs-test-skip-dbgfs_set_targets-test-if-paddr-is-not-registered.patch added to mm-unstable branch
Message-Id: <20240827233309.35D91C4FF6B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/dbgfs-test: skip dbgfs_set_targets() test if PADDR is not registered
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-dbgfs-test-skip-dbgfs_set_targets-test-if-paddr-is-not-registered.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-dbgfs-test-skip-dbgfs_set_targets-test-if-paddr-is-not-registered.patch

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
Subject: mm/damon/dbgfs-test: skip dbgfs_set_targets() test if PADDR is not registered
Date: Mon, 26 Aug 2024 20:03:33 -0700

The test depends on registration of DAMON_OPS_PADDR.  It would be
registered only when CONFIG_DAMON_PADDR is set.  DAMON core kunit tests do
fake ops registration for such case.  However, the functions for such fake
ops registration is not available to DAMON debugfs interface.  Just skip
the test in the case.

Link: https://lkml.kernel.org/r/20240827030336.7930-7-sj@kernel.org
Fixes: 999b9467974f ("mm/damon/dbgfs-test: fix is_target_id() change")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs-test.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/dbgfs-test.h~mm-damon-dbgfs-test-skip-dbgfs_set_targets-test-if-paddr-is-not-registered
+++ a/mm/damon/dbgfs-test.h
@@ -73,6 +73,11 @@ static void damon_dbgfs_test_set_targets
 	struct damon_ctx *ctx = dbgfs_new_ctx();
 	char buf[64];
 
+	if (!damon_is_registered_ops(DAMON_OPS_PADDR)) {
+		dbgfs_destroy_ctx(ctx);
+		kunit_skip(test, "PADDR not registered");
+	}
+
 	/* Make DAMON consider target has no pid */
 	damon_select_ops(ctx, DAMON_OPS_PADDR);
 
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-add-access_memory_even-to-gitignore.patch
selftests-damon-cleanup-__pycache__-with-make-clean.patch
selftests-damon-add-execute-permissions-to-test-scripts.patch
mm-damon-core-test-test-only-vaddr-case-on-ops-registration-test.patch
mm-damon-core-test-fix-damon_test_ops_registration-for-damon_vaddr-unset-case.patch
mm-damon-dbgfs-test-skip-dbgfs_set_targets-test-if-paddr-is-not-registered.patch
mm-damon-dbgfs-test-skip-dbgfs_set_init_regions-test-if-paddr-is-not-registered.patch
mm-damon-move-kunit-tests-to-tests-subdirectory-with-_kunit-suffix.patch
mm-damon-tests-add-kunitconfig-file-for-damon-kunit-tests.patch

