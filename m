Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDE41442E8
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801586; cv=none; b=rBvz3qMjiIP0d2Gx3xfuncD+VEjye1B14y+M7K7rnz422rTTWfM1MeQUaxxi/xO6Im3hSOmOudy5952jkrU5T3zNbBtcVl01ZPTZbrJUTaAAO36/ZJYfoxMYKAXTOuSoX5EYLSbJJRs9fqQaCv0ExpJay4s/c6COWI2ufds5YGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801586; c=relaxed/simple;
	bh=eMnWamf0k/+nkGYB5FKDrlewuOa4faqc7HXqu52hkEM=;
	h=Date:To:From:Subject:Message-Id; b=IIElEt1J31abF7hsmDnKbeIqFNEXVagZAIyJDIO7obdIpJvz5xcTTjmmyM8ctHjdt47l0PADjIarG0gbYVPoDsoNXe1YzKiiHombPMiU+N9Z/U5X/kWGO1fUQ2PNDtxdJvoBbbBNt2WzkaYjZ5S6UrLuPEmrbtahoAZYGcto064=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fKgmDPrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fKgmDPrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A416C4FF6D;
	Tue, 27 Aug 2024 23:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724801585;
	bh=eMnWamf0k/+nkGYB5FKDrlewuOa4faqc7HXqu52hkEM=;
	h=Date:To:From:Subject:From;
	b=fKgmDPrcxxUS3HruOghW4plBE9Vm3Ob5CemweNodZsVVTBYN9e68lLWGVDWGoFf/y
	 UFUuqOKNBHqYZzB95IvtPXpnG7Qh+2yYMAywXRby5GHuJIGT1wn3uXlbDIZ4QRyz1I
	 x6gYfdscoFS0LVmx8WBnID09mM15h9TJhrueA/dc=
Date: Tue, 27 Aug 2024 16:33:04 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-test-test-only-vaddr-case-on-ops-registration-test.patch added to mm-unstable branch
Message-Id: <20240827233305.4A416C4FF6D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core-test: test only vaddr case on ops registration test
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-test-test-only-vaddr-case-on-ops-registration-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-test-test-only-vaddr-case-on-ops-registration-test.patch

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
Subject: mm/damon/core-test: test only vaddr case on ops registration test
Date: Mon, 26 Aug 2024 20:03:31 -0700

DAMON ops registration kunit test tests both vaddr and paddr use cases in
parts of the whole test cases.  Basically testing only one ops use case is
enough.  Do the test with only vaddr use case.

Link: https://lkml.kernel.org/r/20240827030336.7930-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/damon/core-test.h~mm-damon-core-test-test-only-vaddr-case-on-ops-registration-test
+++ a/mm/damon/core-test.h
@@ -246,16 +246,12 @@ static void damon_test_split_regions_of(
 static void damon_test_ops_registration(struct kunit *test)
 {
 	struct damon_ctx *c = damon_new_ctx();
-	struct damon_operations ops, bak;
+	struct damon_operations ops = {.id = DAMON_OPS_VADDR}, bak;
 
-	/* DAMON_OPS_{V,P}ADDR are registered on subsys_initcall */
+	/* DAMON_OPS_VADDR is registered on subsys_initcall */
 	KUNIT_EXPECT_EQ(test, damon_select_ops(c, DAMON_OPS_VADDR), 0);
-	KUNIT_EXPECT_EQ(test, damon_select_ops(c, DAMON_OPS_PADDR), 0);
 
 	/* Double-registration is prohibited */
-	ops.id = DAMON_OPS_VADDR;
-	KUNIT_EXPECT_EQ(test, damon_register_ops(&ops), -EINVAL);
-	ops.id = DAMON_OPS_PADDR;
 	KUNIT_EXPECT_EQ(test, damon_register_ops(&ops), -EINVAL);
 
 	/* Unknown ops id cannot be registered */
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

