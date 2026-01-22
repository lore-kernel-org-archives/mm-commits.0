Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEEA32826F
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 18:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769106400; cv=none; b=R4JOodDQ+fY/iXWokWDGiiMcmnz48utS91CEhZsHBTnovOZMQvp341JBcL/UDpKaj4Op2vJYpbU4uUlFj3+e1AtJ6MIrwqkII29FhUpOzFSqjBBL19K4WlbdLLObS26I+jnEQk3bOAHwwHEyZ8tHAShFrPDOUDKI+ZfFpE/8ZnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769106400; c=relaxed/simple;
	bh=SSNvW01SQmzqhf3lL8fOTpeHSOzCkaMthKeIwiR+/S0=;
	h=Date:To:From:Subject:Message-Id; b=hKY6P+0m5HIm1KB8ZK8qomAeCopHgfxQxOFmakjLLypZHXavO+L5DgoEptDpNvkz0WNxg6SL2rAm26vSJeU6PocTrT5UdU9cQfZ9ik1pTwnhQ2tdIfoeZMEBgkBQBEXNMYkmBpPKTg9y+24oJicv49Te3uF63oJcvODlQ8xiyTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uF6YuoUd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uF6YuoUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A54BC116C6;
	Thu, 22 Jan 2026 18:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769106398;
	bh=SSNvW01SQmzqhf3lL8fOTpeHSOzCkaMthKeIwiR+/S0=;
	h=Date:To:From:Subject:From;
	b=uF6YuoUd9SLhOocR1yiC+h9uoJ2zsgV9q4nUx8WC/4UjoOfCO2cIa8Oa1XSdv5lcf
	 ABc3lN4xc4wuzIelp0oVZagQisQzRxX0wAyVXLwwmoNQCB0yupRRKvZqe2WqnkHZwX
	 q+0BqCLXRnZaMpHwhGVvbD4PWNxgIzcM1KJe8R+Y=
Date: Thu, 22 Jan 2026 10:26:37 -0800
To: mm-commits@vger.kernel.org,Usama.Anjum@arm.com,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,pabeni@redhat.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,lianux.mm@gmail.com,jhubbard@nvidia.com,jgg@nvidia.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch added to mm-unstable branch
Message-Id: <20260122182638.2A54BC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix faulting-in code in pagemap_ioctl test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch

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
Subject: selftests/mm: fix faulting-in code in pagemap_ioctl test
Date: Thu, 22 Jan 2026 17:02:22 +0000

One of the pagemap_ioctl tests attempts to fault in pages by memcpy()'ing
them to an unused buffer.  This probably worked originally, but since
commit 46036188ea1f ("selftests/mm: build with -O2") the compiler is free
to optimise away that unused buffer and the memcpy() with it.  As a result
there might not be any resident page in the mapping and the test may fail.

We don't need to copy all that memory anyway.  Just fault in every page.

While at it also make sure to compute the number of pages once using
simple integer arithmetic instead of ceilf() and implicit conversions.

Link: https://lkml.kernel.org/r/20260122170224.4056513-8-kevin.brodsky@arm.com
Fixes: 46036188ea1f ("selftests/mm: build with -O2")
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Usama Anjum <Usama.Anjum@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: wang lian <lianux.mm@gmail.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1052,11 +1052,10 @@ static void test_simple(void)
 int sanity_tests(void)
 {
 	unsigned long long mem_size, vec_size;
-	long ret, fd, i, buf_size;
+	long ret, fd, i, buf_size, nr_pages;
 	struct page_region *vec;
 	char *mem, *fmem;
 	struct stat sbuf;
-	char *tmp_buf;
 
 	/* 1. wrong operation */
 	mem_size = 10 * page_size;
@@ -1167,14 +1166,14 @@ int sanity_tests(void)
 	if (fmem == MAP_FAILED)
 		ksft_exit_fail_msg("error nomem %d %s\n", errno, strerror(errno));
 
-	tmp_buf = malloc(sbuf.st_size);
-	memcpy(tmp_buf, fmem, sbuf.st_size);
+	nr_pages = (sbuf.st_size + page_size - 1) / page_size;
+	force_read_pages(fmem, nr_pages, page_size);
 
 	ret = pagemap_ioctl(fmem, sbuf.st_size, vec, vec_size, 0, 0,
 			    0, PAGEMAP_NON_WRITTEN_BITS, 0, PAGEMAP_NON_WRITTEN_BITS);
 
 	ksft_test_result(ret >= 0 && vec[0].start == (uintptr_t)fmem &&
-			 LEN(vec[0]) == ceilf((float)sbuf.st_size/page_size) &&
+			 LEN(vec[0]) == nr_pages &&
 			 (vec[0].categories & PAGE_IS_FILE),
 			 "%s Memory mapped file\n", __func__);
 
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

