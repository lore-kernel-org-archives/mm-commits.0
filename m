Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD4838A734
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898314; cv=none; b=LAuolgrkgP0Pi3MIRdPTW0SClMYJiiS+dmBfX5JmI1Ppk2D0LIx6Fvsych4en+ynmWOj+xdcY2MXssGboWZIcTXakuciMq53e3KGB0m6LMXdvMVTPdT6sZdW5OcHChrNEwaYF5WLpkin/crj6CSJJduSFgWFltwAA5UKDuchxMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898314; c=relaxed/simple;
	bh=vLwg0W/aNSrgC63A/BRWKwRKVSsIonhDn+lwCMEcndU=;
	h=Date:To:From:Subject:Message-Id; b=HPzZ0RfC6RNRuBxilI1+N12GvJhWpvskBXfKf+Bl6U744SooEEikjKhtQCj+Mb6UzrnazWQVQUxS8YorGW8g7qy22SdODpF+OQs4R0JAqIXHPW1IsgHv3tGKpH8gc1pPEPV3ZpSH4y3hQBcLtFM4B+C5TAfwKIbCDm1uU3lYkA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IQ/c9Yzs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IQ/c9Yzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C60EC4CEF1;
	Sat, 31 Jan 2026 22:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898314;
	bh=vLwg0W/aNSrgC63A/BRWKwRKVSsIonhDn+lwCMEcndU=;
	h=Date:To:From:Subject:From;
	b=IQ/c9YzsWFibaLDspGEHECcyg+ZT37VQRLVoV9tA3ylqPx5JSN/wVwWpCzuBH9vI4
	 BiYw4x3ZulqK3Q2yQtGH2QW/IGjncFJmeFA4ETGfnjH2bGFm1XODuS87Pw7DGbFtm3
	 4kvLKZyIf/ZwFJIXS99Ig0ctcrpdgRnnttZVYJsg=
Date: Sat, 31 Jan 2026 14:25:13 -0800
To: mm-commits@vger.kernel.org,usama.anjum@arm.com,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,pabeni@redhat.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,lianux.mm@gmail.com,jhubbard@nvidia.com,jgg@nvidia.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-introduce-helper-to-read-every-page.patch removed from -mm tree
Message-Id: <20260131222514.2C60EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: introduce helper to read every page
has been removed from the -mm tree.  Its filename was
     selftests-mm-introduce-helper-to-read-every-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: introduce helper to read every page
Date: Thu, 22 Jan 2026 17:02:21 +0000

FORCE_READ(*addr) ensures that the compiler will emit a load from addr. 
Several tests need to trigger such a load for a range of pages, ensuring
that every page is faulted in, if it wasn't already.

Introduce a new helper force_read_pages() that does exactly that and
replace existing loops with a call to it.

The step size (regular/huge page size) is preserved for all loops, except
in split_huge_page_test.  Reading every byte is unnecessary; we now read
every huge page, matching the following call to check_huge_file().

Link: https://lkml.kernel.org/r/20260122170224.4056513-7-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
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

 tools/testing/selftests/mm/hugetlb-madvise.c      |    9 +--------
 tools/testing/selftests/mm/pfnmap.c               |    9 +++------
 tools/testing/selftests/mm/split_huge_page_test.c |    6 +-----
 tools/testing/selftests/mm/vm_util.h              |    7 +++++++
 4 files changed, 12 insertions(+), 19 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb-madvise.c~selftests-mm-introduce-helper-to-read-every-page
+++ a/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -47,14 +47,7 @@ void write_fault_pages(void *addr, unsig
 
 void read_fault_pages(void *addr, unsigned long nr_pages)
 {
-	unsigned long i;
-
-	for (i = 0; i < nr_pages; i++) {
-		unsigned long *addr2 =
-			((unsigned long *)(addr + (i * huge_page_size)));
-		/* Prevent the compiler from optimizing out the entire loop: */
-		FORCE_READ(*addr2);
-	}
+	force_read_pages(addr, nr_pages, huge_page_size);
 }
 
 int main(int argc, char **argv)
--- a/tools/testing/selftests/mm/pfnmap.c~selftests-mm-introduce-helper-to-read-every-page
+++ a/tools/testing/selftests/mm/pfnmap.c
@@ -35,18 +35,15 @@ static void signal_handler(int sig)
 
 static int test_read_access(char *addr, size_t size, size_t pagesize)
 {
-	size_t offs;
 	int ret;
 
 	if (signal(SIGSEGV, signal_handler) == SIG_ERR)
 		return -EINVAL;
 
 	ret = sigsetjmp(sigjmp_buf_env, 1);
-	if (!ret) {
-		for (offs = 0; offs < size; offs += pagesize)
-			/* Force a read that the compiler cannot optimize out. */
-			*((volatile char *)(addr + offs));
-	}
+	if (!ret)
+		force_read_pages(addr, size/pagesize, pagesize);
+
 	if (signal(SIGSEGV, SIG_DFL) == SIG_ERR)
 		return -EINVAL;
 
--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-introduce-helper-to-read-every-page
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -652,11 +652,7 @@ static int create_pagecache_thp_and_fd(c
 	}
 	madvise(*addr, fd_size, MADV_HUGEPAGE);
 
-	for (size_t i = 0; i < fd_size; i++) {
-		char *addr2 = *addr + i;
-
-		FORCE_READ(*addr2);
-	}
+	force_read_pages(*addr, fd_size / pmd_pagesize, pmd_pagesize);
 
 	if (!check_huge_file(*addr, fd_size / pmd_pagesize, pmd_pagesize)) {
 		ksft_print_msg("No large pagecache folio generated, please provide a filesystem supporting large folio\n");
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-introduce-helper-to-read-every-page
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -54,6 +54,13 @@ static inline unsigned int pshift(void)
 	return __page_shift;
 }
 
+static inline void force_read_pages(char *addr, unsigned int nr_pages,
+				    size_t pagesize)
+{
+	for (unsigned int i = 0; i < nr_pages; i++)
+		FORCE_READ(addr[i * pagesize]);
+}
+
 bool detect_huge_zeropage(void);
 
 /*
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


