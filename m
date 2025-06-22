Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D331A3150
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 18:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750615714; cv=none; b=bkhdjErEM0R/ITv/NJyRY57fEqiHncTevDLa2EduelTqyh8XBl+kwtAw/G6s/LpXx07z2L50QS34QB+WKzj8lJMVwTC4hEdaaV9RfLNIVvT9Xn2XPr2otxtERbxg9MywLmosrVP008hsxTy8EdFJl0LxzSbO+Zt/XxfufWoUuEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750615714; c=relaxed/simple;
	bh=JU9vTjZWl/tMqZXqUHbhBKJA5CYlc9WNokzoY/ZAf1c=;
	h=Date:To:From:Subject:Message-Id; b=V9aQPE89jCN2ubeNGI2KHTcmS5mICCalYKKB5ULye8LHZOQv1LLQ1D2fkrmgvvzeBdzYz1W4pOjCMIXCGXCPFZX8LQ8CYM2KP5l+9CZEIqu9RhP/OJlmOkN6dnQ2zKB328Vex9kKfpU1JAx/Zq9BPNrPikWNHCh0PMTO0MRM9Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gJCmfAf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gJCmfAf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55594C4CEE3;
	Sun, 22 Jun 2025 18:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750615713;
	bh=JU9vTjZWl/tMqZXqUHbhBKJA5CYlc9WNokzoY/ZAf1c=;
	h=Date:To:From:Subject:From;
	b=gJCmfAf+Wg/CcKqDDMPBBwKjFvPFB6zvMDWrn5pymegr+8WNaIrTLa1Vp2K1RWAxT
	 7gMQDU3aCKbOiBRRD/gKWCImz64+KoHtL7XnzXxO5njqLSP5wn9puZO5Rn36yl7rZ0
	 7aKD06KKdVxBDFVZKmYQlvpLbhr9W8LvKJ/82hbE=
Date: Sun, 22 Jun 2025 11:08:32 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,hannes@cmpxchg.org,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bagasdotme@gmail.com,aruna.ramakrishna@oracle.com,liwang@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-selftests-improve-uffd-wp-feature-detection-in-ksm-test.patch added to mm-new branch
Message-Id: <20250622180833.55594C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/selftests: improve UFFD-WP feature detection in KSM test
has been added to the -mm mm-new branch.  Its filename is
     mm-selftests-improve-uffd-wp-feature-detection-in-ksm-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-selftests-improve-uffd-wp-feature-detection-in-ksm-test.patch

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
Subject: mm/selftests: improve UFFD-WP feature detection in KSM test
Date: Sun, 22 Jun 2025 16:10:35 +0800

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

This patch improves compatibility and error handling by:

1. Changes the feature check to first query supported features (features=0)
   rather than specifically requesting WP support.

2. Gracefully skipping the test if:
   - UFFDIO_API fails with EINVAL (feature not supported), or
   - UFFD_FEATURE_PAGEFAULT_FLAG_WP is not advertised by the kernel.

3. Providing better diagnostics by distinguishing expected failures (e.g.,
   EINVAL) from unexpected ones and reporting them using strerror().

The updated logic makes the test more robust across different kernel versions
and configurations, while preserving existing behavior on systems that do
support UFFD-WP.

Link: https://lkml.kernel.org/r/20250622081035.378164-1-liwang@redhat.com
Signed-off-by: Li Wang <liwang@redhat.com>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~mm-selftests-improve-uffd-wp-feature-detection-in-ksm-test
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -393,9 +393,13 @@ static void test_unmerge_uffd_wp(void)
 
 	/* See if UFFD-WP is around. */
 	uffdio_api.api = UFFD_API;
-	uffdio_api.features = UFFD_FEATURE_PAGEFAULT_FLAG_WP;
+	uffdio_api.features = 0;
 	if (ioctl(uffd, UFFDIO_API, &uffdio_api) < 0) {
-		ksft_test_result_fail("UFFDIO_API failed\n");
+		if (errno == EINVAL)
+			ksft_test_result_skip("UFFDIO_API not supported (EINVAL)\n");
+		else
+			ksft_test_result_fail("UFFDIO_API failed: %s\n", strerror(errno));
+
 		goto close_uffd;
 	}
 	if (!(uffdio_api.features & UFFD_FEATURE_PAGEFAULT_FLAG_WP)) {
_

Patches currently in -mm which might be from liwang@redhat.com are

ksm_tests-skip-hugepage-test-when-transparent-hugepages-are-disabled.patch
mm-selftests-improve-uffd-wp-feature-detection-in-ksm-test.patch

