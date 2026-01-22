Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2333542F0
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 18:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769106391; cv=none; b=eiPbUoqKTfl59VFIygRcUvOHEC3itn5YJ6C7FZEX/R6++7uCnfoTjkZQs7TRJ0bgMugCNgLrITLxhtMj41P96kHCePuYKDzgRVXe3/onidXclmlJxKeVzL7GYgz2rkV5HvNECgEmFjLREycpklbWwKZLEZlGLjhU9c0x7QEChFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769106391; c=relaxed/simple;
	bh=QO7BGNRDcINagvDBkpWcSwMF7FXyY9YU6tygThv9sfc=;
	h=Date:To:From:Subject:Message-Id; b=KLqH+Jjc6vVkSp2VUCFajpZWGh6srTZsbEUI37rBg6LyKl6/8VnzV1ceAoAdT33uv8Mlnz7LKdd2RshIStY0fQpfC0o6+CverBtKbobB/QBSZIO9YJVSYDcxCtQQx5tf+CdfZHv+y2KrgcmOvFU+f1zPIMbu2/z8MPw1qonSrJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I1GgVi7M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I1GgVi7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB69C116C6;
	Thu, 22 Jan 2026 18:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769106390;
	bh=QO7BGNRDcINagvDBkpWcSwMF7FXyY9YU6tygThv9sfc=;
	h=Date:To:From:Subject:From;
	b=I1GgVi7M8J9x8pQ65bbV1CDqd7iR2taCAOm4CROI9cNiq2Ipm/AxDCJGgUWo7a+nL
	 sd97Z8es42PnsZNZZ+45T3izTbwLwYhKO2/qQNyKWXR8LxbyOv1N+13lGAZf1Ub+yn
	 6CX7B3YCuKTNuisK/FiKyNcvTlMAx7YaaWtilXrw=
Date: Thu, 22 Jan 2026 10:26:29 -0800
To: mm-commits@vger.kernel.org,Usama.Anjum@arm.com,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,pabeni@redhat.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,lianux.mm@gmail.com,jhubbard@nvidia.com,jgg@nvidia.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-usage-of-force_read-in-cow-tests.patch added to mm-unstable branch
Message-Id: <20260122182630.1EB69C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix usage of FORCE_READ() in cow tests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-usage-of-force_read-in-cow-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-usage-of-force_read-in-cow-tests.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: fix usage of FORCE_READ() in cow tests
Date: Thu, 22 Jan 2026 17:02:19 +0000

Commit 5bbc2b785e63 ("selftests/mm: fix FORCE_READ to read input value
correctly") modified FORCE_READ() to take a value instead of a pointer. 
It also changed most of the call sites accordingly, but missed many of
them in cow.c.  In those cases, we ended up with the pointer itself being
read, not the memory it points to.

No failure occurred as a result, so it looks like the tests work just fine
without faulting in.  However, the huge_zeropage tests explicitly check
that pages are populated, so those became skipped.

Convert all the remaining FORCE_READ() to fault in the mapped page, as was
originally intended.  This allows the huge_zeropage tests to run again (3
tests in total).

Link: https://lkml.kernel.org/r/20260122170224.4056513-5-kevin.brodsky@arm.com
Fixes: 5bbc2b785e63 ("selftests/mm: fix FORCE_READ to read input value correctly")
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Usama Anjum <Usama.Anjum@arm.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-fix-usage-of-force_read-in-cow-tests
+++ a/tools/testing/selftests/mm/cow.c
@@ -1612,8 +1612,8 @@ static void run_with_huge_zeropage(non_a
 	 * the first sub-page and test if we get another sub-page populated
 	 * automatically.
 	 */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 	if (!pagemap_is_populated(pagemap_fd, mem + pagesize) ||
 	    !pagemap_is_populated(pagemap_fd, smem + pagesize)) {
 		ksft_test_result_skip("Did not get THPs populated\n");
@@ -1663,8 +1663,8 @@ static void run_with_memfd(non_anon_test
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1719,8 +1719,8 @@ static void run_with_tmpfile(non_anon_te
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1773,8 +1773,8 @@ static void run_with_memfd_hugetlb(non_a
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 
 	fn(mem, smem, hugetlbsize);
 munmap:
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests.patch
selftests-mm-default-kdir-to-build-directory.patch
selftests-mm-remove-flaky-header-check.patch
selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch
selftests-mm-fix-usage-of-force_read-in-cow-tests.patch
selftests-mm-check-that-force_read-succeeded.patch
selftests-mm-introduce-helper-to-read-every-page.patch
selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch
selftests-mm-fix-exit-code-in-pagemap_ioctl.patch
selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch

