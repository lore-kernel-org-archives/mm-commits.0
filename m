Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0406A285CA6
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126386; cv=none; b=U2xRj34BFOWI3M3pBIr8+4m5fccpguZA8w0AHxqRc3pC28CsIaInaOJfaq8HM1KmVIJlsClA3QmpT61+eY7U80HwDNoatBUYfIrFXEfQBM5iLCZKEdayyLdH35s1XoQw3TznJwM+LrYac4LxBBGPu8tZnoEp7MQYrPrn16NxWb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126386; c=relaxed/simple;
	bh=0SzXchb51cYAXXLIP5EPUcslcYEx25lq8s3bTOZuW6I=;
	h=Date:To:From:Subject:Message-Id; b=kJvRB5xlZzrOgKn7lwSDqEy133C4YaBlmr/pdFs8ILGm7GRKXok9ccTQlCUil/E3VZRjqtKyGT3YJ0ZQp5Zwj+HXV4bxRVF4wFs7zwzrbdUQbYL05Quu8f0i0EXwsI32U1RpNuoqrmGGnrQ940Yv+RW7qDAnjz6Rsr2vhFNCm+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hWoO8hSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hWoO8hSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB674C4CEE3;
	Thu, 10 Jul 2025 05:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126385;
	bh=0SzXchb51cYAXXLIP5EPUcslcYEx25lq8s3bTOZuW6I=;
	h=Date:To:From:Subject:From;
	b=hWoO8hSxSXE6OGEcfmb8xo3U839PB5gLNveMO3EcIcg3D4+7GoZHBpfQSBo+Rj20b
	 +ypVt51KQxuTAWL076X3tinOy19cKJk6O0XlP6IYUcydTqd6JizjvmxNesx0eJZIR7
	 2jFoaXNfy4qzrdnobsrDwYanbyzLE29czTft4MhM=
Date: Wed, 09 Jul 2025 22:46:25 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,nadav.amit@gmail.com,keith.lucas@oracle.com,joey.gouly@arm.com,hannes@cmpxchg.org,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bagasdotme@gmail.com,axelrasmussen@google.com,aruna.ramakrishna@oracle.com,liwang@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-uffdio_api-usage-with-proper-two-step-feature-negotiation.patch removed from -mm tree
Message-Id: <20250710054625.CB674C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix UFFDIO_API usage with proper two-step feature negotiation
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-uffdio_api-usage-with-proper-two-step-feature-negotiation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[liwang@redhat.com: fail the test if sys_userfaultfd() fails, per David]
  Link: https://lkml.kernel.org/r/20250625004645.400520-1-liwang@redhat.com
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
+		ksft_test_result_fail("__NR_userfaultfd failed\n");
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


