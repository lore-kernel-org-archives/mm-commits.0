Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA1F1E0DCB
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 23:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766962913; cv=none; b=K2y/htCkFxsFR+4PgWD7D+vzdePQA59k91yme+8J/QgxBu7alw+ds/X9JOREjVvZL9fYqU9PXqgk61DmQRKnXRoRChxTRUhNT68rEUjoOpI8MI4U/YG1g/o0hPaJYe+2pn9hBcL2EUomzYWIaNECo+SsqltiZX78/QZ3G27/F40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766962913; c=relaxed/simple;
	bh=M2xm0PY6GQ09qli6fCbekRRGWMlrJ3IXgZV7mmEscqg=;
	h=Date:To:From:Subject:Message-Id; b=b3L4MXOoY7I3eeG9OJP8ui5z+vnbprvwCoF6r49sHTk5mvVm+/r7yJOpz0HkE0WjznIVccJH0LeLyXapNbTxsVOEcdkiy+sEV5iLhiFcu8LYI2tmL9tSUioh78MNVlyihp5hI08WYDzSRUdbOELItoaaUMtroz5m8fDk3dvTHc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d/JxRrrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d/JxRrrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D895C4CEFB;
	Sun, 28 Dec 2025 23:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766962913;
	bh=M2xm0PY6GQ09qli6fCbekRRGWMlrJ3IXgZV7mmEscqg=;
	h=Date:To:From:Subject:From;
	b=d/JxRrrcuXPmiZNL8ANEtEvWXK7DQBwpkxkQxmSRIb9j0cF7FgFrGEXqiYFpSlvq9
	 j700EPPdHzFprWO8QiA+Jr2YVWVx3BDcruhga1jsfKLn7j1mCk2RGbVbtxzkchaF0e
	 dZz/bqc79UdCxofkOmgCzvpGf6Ecvk4FfN/kqLqg=
Date: Sun, 28 Dec 2025 15:01:52 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shu17az@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-verify-the-age-field-in-damon_test_split_at.patch added to mm-new branch
Message-Id: <20251228230153.3D895C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: verify the 'age' field in damon_test_split_at()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-verify-the-age-field-in-damon_test_split_at.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-verify-the-age-field-in-damon_test_split_at.patch

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
Subject: mm/damon/tests/core-kunit: verify the 'age' field in damon_test_split_at()
Date: Wed, 24 Dec 2025 04:21:56 +0000

Patch series "mm/damon/tests/core-kunit: extend existing test scenarios",
v2.

Improve the KUnit test coverage for DAMON. 

The five patches in this series respectively extend damon_test_split_at(),
damon_test_merge_two(), damon_test_merge_regions_of(),
damon_test_split_regions_of(), and damos_test_commit_quota_goal().


This patch (of 5):

Extend damon_test_split_at() to verify the 'age' field.

Link: https://lkml.kernel.org/r/20251224042200.2061847-1-shu17az@gmail.com
Link: https://lkml.kernel.org/r/20251224042200.2061847-2-shu17az@gmail.com
Signed-off-by: Shu Anzai <shu17az@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-verify-the-age-field-in-damon_test_split_at
+++ a/mm/damon/tests/core-kunit.h
@@ -158,6 +158,7 @@ static void damon_test_split_at(struct k
 	r->nr_accesses_bp = 420000;
 	r->nr_accesses = 42;
 	r->last_nr_accesses = 15;
+	r->age = 10;
 	damon_add_region(r, t);
 	damon_split_region_at(t, r, 25);
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
@@ -170,6 +171,7 @@ static void damon_test_split_at(struct k
 	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, r_new->nr_accesses_bp);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, r_new->nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
+	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
 
 	damon_free_target(t);
 }
_

Patches currently in -mm which might be from shu17az@gmail.com are

mm-damon-tests-core-kunit-verify-the-age-field-in-damon_test_split_at.patch
mm-damon-tests-core-kunit-verify-the-age-and-nr_accesses_bp-fields-in-damon_test_merge_two.patch
mm-damon-tests-core-kunit-add-a-test-case-for-region-merge-size-limit-in-damon_test_merge_regions_of.patch
mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of.patch
mm-damon-tests-core-kunit-remove-a-redundant-test-case-and-add-a-new-test-case-in-damos_test_commit_quota_goal.patch

