Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C000920FAB4
	for <mm-commits@vger.kernel.org>; Tue, 27 May 2025 21:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748380231; cv=none; b=DFHCJAy6GEmxasQaN2j0sjk+ja7QjhwxCxMiiDsXb52hAPPtSA4MyyZTGE4sXNGXFkysdEVkWLS3WXPBEwSyyYvAL6Xc8pxEcHWvHcOcfhqMUgy69WSwNOL7Qd8pSAFTbSi+Vz3g3hvsOzgxB7YG8hS0UlGbsW5kHSBlCiC+ZPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748380231; c=relaxed/simple;
	bh=AuimvUkI/iZe5Y83TycN21GNkfC2Pp6bZbtqBxlnfYk=;
	h=Date:To:From:Subject:Message-Id; b=t4mRVm0iQZflB6Afyf95E7pLAHZf/JerJF5mYuiFoDlUw+IytQLkXP3jY6EejK5ME8PPynRhrdiG+HTW3+NSZNkLyYz3xQ60vAw075WY9AF/5YED9UJhecIu5SE10l2bXyg/h5N1ktCXRUaeZmxyNJDe+RsTDkbohP+ZRi82PTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S3QvZ2lp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S3QvZ2lp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FB0C4CEE9;
	Tue, 27 May 2025 21:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748380231;
	bh=AuimvUkI/iZe5Y83TycN21GNkfC2Pp6bZbtqBxlnfYk=;
	h=Date:To:From:Subject:From;
	b=S3QvZ2lpXgVeh9FrIUi3yyakvpyVrXNVhQXxx3Dj76fVhuK/bqGRiZjhgv/cHlmnT
	 70tOQJmpjO/+p/UHgzdLU8D39AiOdKW2VMynqnPku7KT5dmiOL5nS7WNE+JEu9VRfN
	 eLb2aS+9rV2NTG0UCKLH+aj4LMpsxpqh0e0WhhoE=
Date: Tue, 27 May 2025 14:10:30 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-use-standard-ksft_finished-in-cow-and-gup_longterm.patch added to mm-new branch
Message-Id: <20250527211031.06FB0C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: use standard ksft_finished() in cow and gup_longterm
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-use-standard-ksft_finished-in-cow-and-gup_longterm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-use-standard-ksft_finished-in-cow-and-gup_longterm.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: use standard ksft_finished() in cow and gup_longterm
Date: Tue, 27 May 2025 17:04:45 +0100

Patch series "selftests/mm: cow and gup_longterm cleanups", v2.

The bulk of these changes modify the cow and gup_longterm tests to report
unique and stable names for each test, bringing them into line with the
expectations of tooling that works with kselftest.  The string reported as
a test result is used by tooling to both deduplicate tests and track tests
between test runs, using the same string for multiple tests or changing
the string depending on test result causes problems for user interfaces
and automation such as bisection.

It was suggested that converting to use kselftest_harness.h would be a
good way of addressing this, however that really wants the set of tests to
run to be known at compile time but both test programs dynamically
enumarate the set of huge page sizes the system supports and test each. 
Refactoring to handle this would be even more invasive than these changes
which are large but straightforward and repetitive.

A version of the main gup_longterm cleanup was previously sent separately,
this version factors out the helpers for logging the start of the test
since the cow test looks very similar.


This patch (of 4):

The cow and gup_longterm test programs open code something that looks a
lot like the standard ksft_finished() helper to summarise the test results
and provide an exit code, convert to use ksft_finished().

Link: https://lkml.kernel.org/r/20250527-selftests-mm-cow-dedupe-v2-0-ff198df8e38e@kernel.org
Link: https://lkml.kernel.org/r/20250527-selftests-mm-cow-dedupe-v2-1-ff198df8e38e@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c          |    7 +------
 tools/testing/selftests/mm/gup_longterm.c |    8 ++------
 2 files changed, 3 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-use-standard-ksft_finished-in-cow-and-gup_longterm
+++ a/tools/testing/selftests/mm/cow.c
@@ -1771,7 +1771,6 @@ static int tests_per_non_anon_test_case(
 
 int main(int argc, char **argv)
 {
-	int err;
 	struct thp_settings default_settings;
 
 	ksft_print_header();
@@ -1811,9 +1810,5 @@ int main(int argc, char **argv)
 		thp_restore_settings();
 	}
 
-	err = ksft_get_fail_cnt();
-	if (err)
-		ksft_exit_fail_msg("%d out of %d tests failed\n",
-				   err, ksft_test_num());
-	ksft_exit_pass();
+	ksft_finished();
 }
--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-use-standard-ksft_finished-in-cow-and-gup_longterm
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -455,7 +455,7 @@ static int tests_per_test_case(void)
 
 int main(int argc, char **argv)
 {
-	int i, err;
+	int i;
 
 	pagesize = getpagesize();
 	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
@@ -469,9 +469,5 @@ int main(int argc, char **argv)
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
 		run_test_case(&test_cases[i]);
 
-	err = ksft_get_fail_cnt();
-	if (err)
-		ksft_exit_fail_msg("%d out of %d tests failed\n",
-				   err, ksft_test_num());
-	ksft_exit_pass();
+	ksft_finished();
 }
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-deduplicate-test-logging-in-test_mlock_lock.patch
selftests-mm-deduplicate-default-page-size-test-results-in-thuge-gen.patch
selftests-mm-deduplicate-test-names-in-madv_populate.patch
selftests-mm-use-standard-ksft_finished-in-cow-and-gup_longterm.patch
selftests-mm-add-helper-for-logging-test-start-and-results.patch
selftests-mm-report-unique-test-names-for-each-cow-test.patch
selftests-mm-fix-test-result-reporting-in-gup_longterm.patch

