Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C6F86334
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122749; cv=none; b=pdCJxHoklkIyIdriTu7s4E0+Y6ShfkO9ZsA3edmYhI0RhzEUVXYvKwSKDm4s/EoC4cAKPGaRRcVQ/1eHvBVnKwvpKfwbm/cbtgJE9xtQQJTmVir65eiLg3xOVTemUGKAcir/GLS6T0nXbCNZwH1XBhNIE1EDSdwS0burFqR0ieM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122749; c=relaxed/simple;
	bh=2ARcAQd+bHV3X7jYK74HvMEfLh6oplPY6kikYARykO4=;
	h=Date:To:From:Subject:Message-Id; b=JUJuQUCks/hbjk0SKcAn9t5GKUG5lYPLAl3UgoYzRALOca4zaPOsWlZ7YD7NGEcvYhUf6ezn3J+ZPjQZ6heF9gEOlGgYRGWNBPCpIgmblupAZfPYFE6y5egFh7asMQYyxlhZZLffyVifZUupie4Q2CNCEhdgnLQ/ROaXwsIqoq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XijjmuCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XijjmuCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEFDC4CEE3;
	Thu, 10 Jul 2025 04:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752122749;
	bh=2ARcAQd+bHV3X7jYK74HvMEfLh6oplPY6kikYARykO4=;
	h=Date:To:From:Subject:From;
	b=XijjmuCcyhbZbhOgeqvXsTvFnvw/0Rlso3FbJxOEPqwn3wRvwQDUXrASeM+2CECTA
	 ztFbC4bmYLt1vZnnTSFqStKe9hZS2p+8DgWNXfz4cVkHK1oUMW1mMkVzlP+oH0we7V
	 HB88RBiuWSSzVV/2Tdp0Lon7j0eq8ZoVwPGz8pyA=
Date: Wed, 09 Jul 2025 21:45:48 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,peterx@redhat.com,nadav.amit@gmail.com,keith.lucas@oracle.com,joey.gouly@arm.com,hannes@cmpxchg.org,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bagasdotme@gmail.com,aruna.ramakrishna@oracle.com,liwang@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-fix-uffdio_api-usage-with-proper-two-step-feature-negotiation-v3.patch removed from -mm tree
Message-Id: <20250710044549.4BEFDC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix UFFDIO_API usage with proper two-step feature negotiation
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-uffdio_api-usage-with-proper-two-step-feature-negotiation-v3.patch

This patch was dropped because it was folded into selftests-mm-fix-uffdio_api-usage-with-proper-two-step-feature-negotiation.patch

------------------------------------------------------
From: Li Wang <liwang@redhat.com>
Subject: selftests/mm: fix UFFDIO_API usage with proper two-step feature negotiation
Date: Wed, 25 Jun 2025 08:46:45 +0800

fail the test if sys_userfaultfd() fails, per David

Link: https://lkml.kernel.org/r/20250625004645.400520-1-liwang@redhat.com
Signed-off-by: Li Wang <liwang@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftests-mm-fix-uffdio_api-usage-with-proper-two-step-feature-negotiation-v3
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -415,7 +415,7 @@ static void test_unmerge_uffd_wp(void)
 	close(uffd);
 	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
 	if (uffd < 0) {
-		ksft_test_result_skip("__NR_userfaultfd failed\n");
+		ksft_test_result_fail("__NR_userfaultfd failed\n");
 		goto unmap;
 	}
 
_

Patches currently in -mm which might be from liwang@redhat.com are

selftests-mm-fix-uffdio_api-usage-with-proper-two-step-feature-negotiation.patch
ksm_tests-skip-hugepage-test-when-transparent-hugepages-are-disabled.patch

