Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9111BC9E2
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 23:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750808767; cv=none; b=WQt6sjhRqnkrZ2/fs8RAD97g/r5/L3GMRhQwg/BCK8yzybPqd9fI7YB20hD+ivJWpgewf4LtWhEiQ/MAJlBOvtvOc5KBBB9ZvxqbJcEGIVz/GAg0n/Gf9+zoWf3VMe8OrdI0fuQdEz3hfcQisPHguxPjQo8KBde2Xz7bvnO8iMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750808767; c=relaxed/simple;
	bh=0wkqzbs+Aiv6JqXDhdBTfHq2WiI1W9cb9wv3X85cYhI=;
	h=Date:To:From:Subject:Message-Id; b=pykDgry82ibUWTmRPdPqfjgIqWwuq0MOuLG+TfVHeB/WtU4bwoIvmVCuj4VFBJJla63rUKv/zzcf7D+BtTVZVlDfiMzG1UNzo4ZJNBWWsuWohHMA7YP/w4n7Ep7OxBfjrR3rrnh47BiIbKXn/cJGG9nCvjY2Xs4Zys8M2BmUooY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IwYiqIIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IwYiqIIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06340C4CEE3;
	Tue, 24 Jun 2025 23:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750808767;
	bh=0wkqzbs+Aiv6JqXDhdBTfHq2WiI1W9cb9wv3X85cYhI=;
	h=Date:To:From:Subject:From;
	b=IwYiqIIuWt8Rk5kxJ9ehgWEjB9Jdxm8a14v2HeI1cJqp5JDwxbZB4dvpl1sNqTTaL
	 0W31Y7p6N0e5hr/k4r78qCDJpamEROOApcBEa0dceV+gBM++PtLpLVbe/gL3Eqar2F
	 ShqSWfN7ZEiySpWxXzRVtVgiSGpNzP/dgkpX2QsQ=
Date: Tue, 24 Jun 2025 16:46:06 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,nadav.amit@gmail.com,keith.lucas@oracle.com,joey.gouly@arm.com,hannes@cmpxchg.org,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bagasdotme@gmail.com,axelrasmussen@google.com,aruna.ramakrishna@oracle.com,liwang@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-uffdio_api-usage-with-proper-two-step-feature-negotiation.patch added to mm-new branch
Message-Id: <20250624234607.06340C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix UFFDIO_API usage with proper two-step feature negotiation
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-uffdio_api-usage-with-proper-two-step-feature-negotiation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-uffdio_api-usage-with-proper-two-step-feature-negotiation.patch

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
From: Li Wang <liwang@redhat.com>
Subject: selftests/mm: fix UFFDIO_API usage with proper two-step feature negotiation
Date: Tue, 24 Jun 2025 12:24:11 +0800

The current implementation of test_unmerge_uffd_wp() explicitly sets
`uffdio_api.features = UFFD_FEATURE_PAGEFAULT_FLAG_WP` before calling
UFFDIO_API.  This can cause the ioctl() call to fail with EINVAL on
kernels that do not support UFFD-WP, leading the test to fail
unnecessarily:

  # ------------------------------
  # running ./ksm_functional_tests
  # ------------------------------
  # TAP version 13
  # 1..9
  # # [RUN] test_unmerge
  # ok 1 Pages were unmerged
  # # [RUN] test_unmerge_zero_pages
  # ok 2 KSM zero pages were unmerged
  # # [RUN] test_unmerge_discarded
  # ok 3 Pages were unmerged
  # # [RUN] test_unmerge_uffd_wp
  # not ok 4 UFFDIO_API failed     <-----
  # # [RUN] test_prot_none
  # ok 5 Pages were unmerged
  # # [RUN] test_prctl
  # ok 6 Setting/clearing PR_SET_MEMORY_MERGE works
  # # [RUN] test_prctl_fork
  # # No pages got merged
  # # [RUN] test_prctl_fork_exec
  # ok 7 PR_SET_MEMORY_MERGE value is inherited
  # # [RUN] test_prctl_unmerge
  # ok 8 Pages were unmerged
  # Bail out! 1 out of 8 tests failed
  # # Planned tests != run tests (9 != 8)
  # # Totals: pass:7 fail:1 xfail:0 xpass:0 skip:0 error:0
  # [FAIL]

This patch improves compatibility and robustness of the UFFD-WP test
(test_unmerge_uffd_wp) by correctly implementing the UFFDIO_API two-step
handshake as recommended by the userfaultfd(2) man page.

Key changes:

1. Use features=0 in the initial UFFDIO_API call to query supported
   feature bits, rather than immediately requesting WP support.

2. Skip the test gracefully if:
   - UFFDIO_API fails with EINVAL (e.g. unsupported API version), or
   - UFFD_FEATURE_PAGEFAULT_FLAG_WP is not advertised by the kernel.

3. Close the initial userfaultfd and create a new one before enabling
   the required feature, since UFFDIO_API can only be called once per fd.

4. Improve diagnostics by distinguishing between expected and unexpected
   failures, using strerror() to report errors.

This ensures the test behaves correctly across a wider range of kernel
versions and configurations, while preserving the intended behavior on
kernels that support UFFD-WP.

Link: https://lkml.kernel.org/r/20250624042411.395285-1-liwang@redhat.com
Signed-off-by: Li Wang <liwang@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Li Wang <liwang@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |   28 +++++++++++-
 1 file changed, 26 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftests-mm-fix-uffdio_api-usage-with-proper-two-step-feature-negotiation
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -393,9 +393,13 @@ static void test_unmerge_uffd_wp(void)
 
 	/* See if UFFD-WP is around. */
 	uffdio_api.api = UFFD_API;
-	uffdio_api.features = UFFD_FEATURE_PAGEFAULT_FLAG_WP;
+	uffdio_api.features = 0;
 	if (ioctl(uffd, UFFDIO_API, &uffdio_api) < 0) {
-		ksft_test_result_fail("UFFDIO_API failed\n");
+		if (errno == EINVAL)
+			ksft_test_result_skip("The API version requested is not supported\n");
+		else
+			ksft_test_result_fail("UFFDIO_API failed: %s\n", strerror(errno));
+
 		goto close_uffd;
 	}
 	if (!(uffdio_api.features & UFFD_FEATURE_PAGEFAULT_FLAG_WP)) {
@@ -403,6 +407,26 @@ static void test_unmerge_uffd_wp(void)
 		goto close_uffd;
 	}
 
+	/*
+	 * UFFDIO_API must only be called once to enable features.
+	 * So we close the old userfaultfd and create a new one to
+	 * actually enable UFFD_FEATURE_PAGEFAULT_FLAG_WP.
+	 */
+	close(uffd);
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (uffd < 0) {
+		ksft_test_result_skip("__NR_userfaultfd failed\n");
+		goto unmap;
+	}
+
+	/* Now, enable it ("two-step handshake") */
+	uffdio_api.api = UFFD_API;
+	uffdio_api.features = UFFD_FEATURE_PAGEFAULT_FLAG_WP;
+	if (ioctl(uffd, UFFDIO_API, &uffdio_api) < 0) {
+		ksft_test_result_fail("UFFDIO_API failed: %s\n", strerror(errno));
+		goto close_uffd;
+	}
+
 	/* Register UFFD-WP, no need for an actual handler. */
 	if (uffd_register(uffd, map, size, false, true, false)) {
 		ksft_test_result_fail("UFFDIO_REGISTER_MODE_WP failed\n");
_

Patches currently in -mm which might be from liwang@redhat.com are

selftests-mm-fix-uffdio_api-usage-with-proper-two-step-feature-negotiation.patch

