Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601BE142E83
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 21:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750887090; cv=none; b=QENnfBLnMrkvF5dgML+k01e1+ipnD8mxYJmF/RHAzipksLz9t3nL7MfVMuMZGxSoGanJyoO+JVKSqWFALc0IgXODqLeQ11sG0FXZI77JKSLiVAnwKOQU86TKw6zE/qJt2s20nZaxYb7+R7Itns/Ia0AqvFfo+3alWXSk1+FXT6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750887090; c=relaxed/simple;
	bh=9k9c0vJM9sF2rAa4YQRK1qKCiQEFN0WbwEiFBW8VhQo=;
	h=Date:To:From:Subject:Message-Id; b=RIKrV0ijekpGbn8KLBSEE9/ltkm5jdeY8WySXCo69qwc8RVuAJOggZH8olPBFN2Szuj+BP7uC/MyV/H5dLRQxiSs565RO4UdQW/VMd+e5uROhPbNq9Y5I8KiPO8QAV+e1R4febpT1UxrJoyoV++6XWqXA30YAUvFpHobIXZpZn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tINbAiVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tINbAiVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC1EC4CEEA;
	Wed, 25 Jun 2025 21:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750887089;
	bh=9k9c0vJM9sF2rAa4YQRK1qKCiQEFN0WbwEiFBW8VhQo=;
	h=Date:To:From:Subject:From;
	b=tINbAiVmhtqIgA12IDiM6VSUr+eDWZOdJpwEiGC8bzIWFY7Lu5QjyBtWqFeke1y/n
	 kmSomQ7pIu6k+sxgrl6iovmFNIn1D57KWN/eQAGoJ5799F2appPteJyr8pY1u6F+L9
	 Bw1NfH2E/c0ozB1FVnGWCq/BWe25DUFcYhRhm9oI=
Date: Wed, 25 Jun 2025 14:31:29 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,peterx@redhat.com,nadav.amit@gmail.com,keith.lucas@oracle.com,joey.gouly@arm.com,hannes@cmpxchg.org,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bagasdotme@gmail.com,aruna.ramakrishna@oracle.com,liwang@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-uffdio_api-usage-with-proper-two-step-feature-negotiation-v3.patch added to mm-new branch
Message-Id: <20250625213129.CCC1EC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: Fix UFFDIO_API usage with proper two-step feature negotiation
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-uffdio_api-usage-with-proper-two-step-feature-negotiation-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-uffdio_api-usage-with-proper-two-step-feature-negotiation-v3.patch

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
Subject: selftests/mm: Fix UFFDIO_API usage with proper two-step feature negotiation
Date: Wed, 25 Jun 2025 08:46:45 +0800

fail the test if sys_userfaultfd() fails

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
selftests-mm-fix-uffdio_api-usage-with-proper-two-step-feature-negotiation-v3.patch
ksm_tests-skip-hugepage-test-when-transparent-hugepages-are-disabled.patch

