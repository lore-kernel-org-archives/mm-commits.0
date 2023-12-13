Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268F568296
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 19:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ywq1MwOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A75CC433C8;
	Wed, 13 Dec 2023 19:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702496970;
	bh=j9W0HXmc0Lm55nCpRVPtFRwvwOm6ESY4paj1RQIdXyY=;
	h=Date:To:From:Subject:From;
	b=ywq1MwOcVSeNmCre3eo0Dx5fJgIuAg1FQxSmsKHAXawbbn0qB1MbVNMaoEtY8JHV5
	 GnCYXwUrT1vEE57j+U7mvYUuHUwOJXbWQeN9CSbJWrOzCebXTtCkDqUoS1XCPnHboG
	 LSWqBBQ7Mz6/Xdjn5z5A1komV6L19LGXsQsrbcNs=
Date: Wed, 13 Dec 2023 11:49:30 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-test-test-max_nr_accesses-overflow-caused-divide-by-zero.patch added to mm-unstable branch
Message-Id: <20231213194930.9A75CC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core-test: test max_nr_accesses overflow caused divide-by-zero
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-test-test-max_nr_accesses-overflow-caused-divide-by-zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-test-test-max_nr_accesses-overflow-caused-divide-by-zero.patch

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
Subject: mm/damon/core-test: test max_nr_accesses overflow caused divide-by-zero
Date: Wed, 13 Dec 2023 19:03:34 +0000

Commit 35f5d94187a6 ("mm/damon: implement a function for max nr_accesses
safe calculation") has fixed an overflow bug that could cause
divide-by-zero.  Add a kunit test for the bug to ensure similar bugs are
not introduced again.

Link: https://lkml.kernel.org/r/20231213190338.54146-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/damon/core-test.h~mm-damon-core-test-test-max_nr_accesses-overflow-caused-divide-by-zero
+++ a/mm/damon/core-test.h
@@ -302,6 +302,16 @@ static void damon_test_set_regions(struc
 	damon_destroy_target(t);
 }
 
+static void damon_test_nr_accesses_to_accesses_bp(struct kunit *test)
+{
+	struct damon_attrs attrs = {
+		.sample_interval = 10,
+		.aggr_interval = ((unsigned long)UINT_MAX + 1) * 10
+	};
+
+	KUNIT_EXPECT_EQ(test, damon_nr_accesses_to_accesses_bp(123, &attrs), 0);
+}
+
 static void damon_test_update_monitoring_result(struct kunit *test)
 {
 	struct damon_attrs old_attrs = {
@@ -487,6 +497,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_split_regions_of),
 	KUNIT_CASE(damon_test_ops_registration),
 	KUNIT_CASE(damon_test_set_regions),
+	KUNIT_CASE(damon_test_nr_accesses_to_accesses_bp),
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_moving_sum),
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-implement-a-python-module-for-test-purpose-damon-sysfs-controls.patch
selftests-damon-_damon_sysfs-implement-kdamonds-start-function.patch
selftests-damon-_damon_sysfs-implement-updat_schemes_tried_bytes-command.patch
selftests-damon-add-a-test-for-update_schemes_tried_regions-sysfs-command.patch
selftests-damon-add-a-test-for-update_schemes_tried_regions-hang-bug.patch
mm-damon-update-email-of-seongjae.patch
mm-damon-core-test-test-max_nr_accesses-overflow-caused-divide-by-zero.patch
docs-mm-damon-design-place-execution-model-and-data-structures-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-context-directory-section-label.patch
docs-admin-guide-mm-damon-usage-add-links-to-sysfs-files-hierarchy.patch
docs-admin-guide-mm-damon-usage-use-a-list-for-state-sysfs-file-input-commands.patch

