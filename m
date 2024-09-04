Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B498002A
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423603; cv=none; b=urGIL5IiGVHSAYMqhuOkv0CD867k05tqibPaiZkbDBKIEY6HUuhySfLpnuHu2ETB4ojhl3c5moSWTaZEQ97LLYSUXKD3mQn+1LVj8EjZ9jLWN7Wyb+kQ9NHTcVk/k3H7mXgcmbwEAztpW3pKgYl+J+xjOG4eX7jMbgVN1GiwmaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423603; c=relaxed/simple;
	bh=cV9P1F4/LvP7FLpF52NAaFGwV5uOyvxHRpQNp8g5Eso=;
	h=Date:To:From:Subject:Message-Id; b=U1iAyTs5eIz1e+kU41RwM8gH6g4ilQue0sr3USB+7YnO2KWFC6AYJ18SlYav8AFOyo5zpzOzzF2r7bo/kAkzpGKe/yD/E1DvUTzCMBjqtI89UqBYZus1nqo7qmzzSA6W0YHbpLyX3vFvjaYs6yqE2uksfigmCitN7Emji6jt2R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TOqGWlZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TOqGWlZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F82C4CEC2;
	Wed,  4 Sep 2024 04:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423602;
	bh=cV9P1F4/LvP7FLpF52NAaFGwV5uOyvxHRpQNp8g5Eso=;
	h=Date:To:From:Subject:From;
	b=TOqGWlZZVpSAHvbDDjSEGmB/FF4FZDYkdIMu+oo31DYVnTmbUoWRTKB7zkpYZZ7hR
	 VdrDl6gvcXQwsXUYuI4R7TBuWLzhrYEAAJg5/GTIWryBCgfZpRuPVYkdC37I0GdSL0
	 x02WtYuDU1AAUOlTBg6qMxS60GqCx95uf2PKi7iQ=
Date: Tue, 03 Sep 2024 21:20:02 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-test-test-only-vaddr-case-on-ops-registration-test.patch removed from -mm tree
Message-Id: <20240904042002.B2F82C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core-test: test only vaddr case on ops registration test
has been removed from the -mm tree.  Its filename was
     mm-damon-core-test-test-only-vaddr-case-on-ops-registration-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch
mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch
mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch
revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch
docs-damon-use-damonitor-github-organization-instead-of-awslabs.patch
docs-damon-maintainer-profile-add-links-in-place.patch
docs-damon-maintainer-profile-document-google-calendar-for-bi-weekly-meetups.patch

