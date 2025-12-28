Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B614529BD8C
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 23:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766962920; cv=none; b=i2HDULsykKLMWF0ygVjNH/8sEcGwGqHSg7Fqx4K9rkKwbh6cUPond+fayI1fQSnguRncupidATcPbak5kW/uM2NHP60dANxbIfaCRh7RPrJk8i6ThlOtaf5sZH4pVWhuv+kryyvGEJpzv/AzZPgr1QcP5hbTlHOpzE6MTFnw+wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766962920; c=relaxed/simple;
	bh=oT8f6/NJG5FpbMPMAKo6FOjWphnq7CR9ylUNRVLDSCo=;
	h=Date:To:From:Subject:Message-Id; b=H37Z8sVF3C/t+0wyo4TDJ4+uNvS/PYA/lKq+diMY4DI4ZYZaXbYECKuX/cJWGYd+Mk1+ukoEa2qEci6ivP7LuFciulEZQ3xIfTarvHHPpDcOwlsw0yiag+XPXlN045gMthEWDvqo0dNVKcDxoHQULBjUVVGoW2xa5llHg18q2rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D+R6lYQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D+R6lYQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430A1C4CEFB;
	Sun, 28 Dec 2025 23:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766962919;
	bh=oT8f6/NJG5FpbMPMAKo6FOjWphnq7CR9ylUNRVLDSCo=;
	h=Date:To:From:Subject:From;
	b=D+R6lYQIbQb1qTuWGJTr8/dFZQcDTIQYnHSUwmoP/rtrw9CaLb9EjqYAS1o2ojfOZ
	 kXM1qD8y9OBjk2Q7ExYQVeig4EJ7AQA60iQhc3NtbV8DJ1SP+bNddinFKKgry4+1f6
	 Pdf6pF80yubQTFZ+ZdVCPN0BqmexvrTGUk7EWGbQ=
Date: Sun, 28 Dec 2025 15:01:58 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shu17az@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of.patch added to mm-new branch
Message-Id: <20251228230159.430A1C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: add test cases for multiple regions in damon_test_split_regions_of()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shu Anzai <shu17az@gmail.com>
Subject: mm/damon/tests/core-kunit: add test cases for multiple regions in damon_test_split_regions_of()
Date: Wed, 24 Dec 2025 04:21:59 +0000

Extend damon_test_split_regions_of() to verify that it correctly handles
multiple regions with various 'min_sz_region'.

Link: https://lkml.kernel.org/r/20251224042200.2061847-5-shu17az@gmail.com
Signed-off-by: Shu Anzai <shu17az@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of
+++ a/mm/damon/tests/core-kunit.h
@@ -275,6 +275,9 @@ static void damon_test_split_regions_of(
 {
 	struct damon_target *t;
 	struct damon_region *r;
+	unsigned long sa[] = {0, 300, 500};
+	unsigned long ea[] = {220, 400, 700};
+	int i;
 
 	t = damon_new_target();
 	if (!t)
@@ -301,6 +304,24 @@ static void damon_test_split_regions_of(
 	damon_split_regions_of(t, 4, 1);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
 	damon_free_target(t);
+
+	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "third target alloc fail");
+	for (i = 0; i < ARRAY_SIZE(sa); i++) {
+		r = damon_new_region(sa[i], ea[i]);
+		if (!r) {
+			damon_free_target(t);
+			kunit_skip(test, "region alloc fail");
+		}
+		damon_add_region(r, t);
+	}
+	damon_split_regions_of(t, 4, 5);
+	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 12u);
+	damon_for_each_region(r, t) {
+		KUNIT_EXPECT_GE(test, damon_sz_region(r) % 5ul, 0ul);
+	}
+	damon_free_target(t);
 }
 
 static void damon_test_ops_registration(struct kunit *test)
_

Patches currently in -mm which might be from shu17az@gmail.com are

mm-damon-tests-core-kunit-verify-the-age-field-in-damon_test_split_at.patch
mm-damon-tests-core-kunit-verify-the-age-and-nr_accesses_bp-fields-in-damon_test_merge_two.patch
mm-damon-tests-core-kunit-add-a-test-case-for-region-merge-size-limit-in-damon_test_merge_regions_of.patch
mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of.patch
mm-damon-tests-core-kunit-remove-a-redundant-test-case-and-add-a-new-test-case-in-damos_test_commit_quota_goal.patch

