Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FA91442E8
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801587; cv=none; b=R9gXyIm2jEordQZvJBNDE403CbBptaCzWCF7rzItkbSlljO9AMOQzHkcgfgenyCAPhSNNI9kTaVovpY/Bz2RS2+pf/bw7WnmJqaYHjk5taAGOIZQXzT2M1324iHikzLMh/lNj0g5o/G/qUDOMDFJqYVQhIETart/4r5Ywb2xZz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801587; c=relaxed/simple;
	bh=yitZ54AsttLtSAO2IknuyHgyHmVFqMLog/658BGt+oE=;
	h=Date:To:From:Subject:Message-Id; b=qxNq7gH1FnYG+ooVL/qTl5K51J67oeHzN2B8Drz2k5IhCm7Fk7JeuY+UfPsvFa4eN2WGhfCudkc5clH49M6rLrSbyCZjrE0hS7RiJKzTkWLKQjATUM0Txb6S2q/6NCFzaLqA6GJ1DSRm5zNNOBP8Vw/ehIwjzPM+MLpM49Uve4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o78fxC6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o78fxC6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D5CC4FF70;
	Tue, 27 Aug 2024 23:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724801587;
	bh=yitZ54AsttLtSAO2IknuyHgyHmVFqMLog/658BGt+oE=;
	h=Date:To:From:Subject:From;
	b=o78fxC6F0sf8ARAE3SRMIiYHBFEbQabEp/1M/OJoZcrobfydiGR+6w4c1WS1XY/v3
	 9aGoaQwJg3vKuOvjrTFwN7ODT7E+fVWERlsVbu6YM6PusjZxM9WRDKjr+HfjivxQ2H
	 ET7m/JrQ9O0Ncb7W/aDZ+dIY5Ot8kybhJHnd1lDw=
Date: Tue, 27 Aug 2024 16:33:06 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-test-fix-damon_test_ops_registration-for-damon_vaddr-unset-case.patch added to mm-unstable branch
Message-Id: <20240827233307.48D5CC4FF70@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core-test: fix damon_test_ops_registration() for DAMON_VADDR unset case
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-test-fix-damon_test_ops_registration-for-damon_vaddr-unset-case.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-test-fix-damon_test_ops_registration-for-damon_vaddr-unset-case.patch

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
Subject: mm/damon/core-test: fix damon_test_ops_registration() for DAMON_VADDR unset case
Date: Mon, 26 Aug 2024 20:03:32 -0700

DAMON core kunit test can be executed without CONFIG_DAMON_VADDR.  In the
case, vaddr DAMON ops is not registered.  Meanwhile, ops registration
kunit test assumes the vaddr ops is registered.  Check and handle the case
by registrering fake vaddr ops inside the test code.

Link: https://lkml.kernel.org/r/20240827030336.7930-6-sj@kernel.org
Fixes: 4f540f5ab4f2 ("mm/damon/core-test: add a kunit test case for ops registration")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/mm/damon/core-test.h~mm-damon-core-test-fix-damon_test_ops_registration-for-damon_vaddr-unset-case
+++ a/mm/damon/core-test.h
@@ -247,8 +247,16 @@ static void damon_test_ops_registration(
 {
 	struct damon_ctx *c = damon_new_ctx();
 	struct damon_operations ops = {.id = DAMON_OPS_VADDR}, bak;
+	bool need_cleanup = false;
 
-	/* DAMON_OPS_VADDR is registered on subsys_initcall */
+	/* DAMON_OPS_VADDR is registered only if CONFIG_DAMON_VADDR is set */
+	if (!damon_is_registered_ops(DAMON_OPS_VADDR)) {
+		bak.id = DAMON_OPS_VADDR;
+		KUNIT_EXPECT_EQ(test, damon_register_ops(&bak), 0);
+		need_cleanup = true;
+	}
+
+	/* DAMON_OPS_VADDR is ensured to be registered */
 	KUNIT_EXPECT_EQ(test, damon_select_ops(c, DAMON_OPS_VADDR), 0);
 
 	/* Double-registration is prohibited */
@@ -274,6 +282,13 @@ static void damon_test_ops_registration(
 	KUNIT_EXPECT_EQ(test, damon_register_ops(&ops), -EINVAL);
 
 	damon_destroy_ctx(c);
+
+	if (need_cleanup) {
+		mutex_lock(&damon_ops_lock);
+		damon_registered_ops[DAMON_OPS_VADDR] =
+			(struct damon_operations){};
+		mutex_unlock(&damon_ops_lock);
+	}
 }
 
 static void damon_test_set_regions(struct kunit *test)
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

