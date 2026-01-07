Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0923148C5
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 17:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806501; cv=none; b=EKwXu1TPPprprxZk6ERnuGd6gTl8IE5QdQ7Z3SNh0AMuziUflZvkxYjPF1NCdtkmWb8bNr09dUZvmD/dOYIhJtSBHneM+wT/pi+Z7dWiC+Dbsi1Z0FQcfUDs2TtsWRZ/qHx4hlxljaX9w+o6L/0XjKocRu1lEPxGDyJYXiRoYbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806501; c=relaxed/simple;
	bh=KElW4EXonVcvOHHYvMwBpgTrF+J2XocI022Cy7JjxZw=;
	h=Date:To:From:Subject:Message-Id; b=dXfzfjuZGuZaKU0hvJtXxc/hwiFfuCFBGSt7E9XteG2j6neP+ifPAkG3mYo66fhvxCr6NVvOPbyA1MOjpczsl8NBc0rwhIwflJNoHICuKBmdt5Hs14EgBueQirtkg9Np5hOyck7S7FiSputLSPTpqC8cKZsCzCbVBKZjjNSVkYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WVREOWjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WVREOWjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C335C4CEF1;
	Wed,  7 Jan 2026 17:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767806500;
	bh=KElW4EXonVcvOHHYvMwBpgTrF+J2XocI022Cy7JjxZw=;
	h=Date:To:From:Subject:From;
	b=WVREOWjyyjGB+HIexC3/XJF1x5ztF/kTB9dr/ZZgupgot6iwiwVGL1Nm1rFxQnsGK
	 nw7cqMFASfjDoe5BQgdmjxN6tCsA/3AgnqwuOwDvN6+2qpdDveLJXjyhi2Q3UkeTxR
	 9ybKXTVQvlspXAb/FFso00PGQgKHyD3o3QzBp0Oo=
Date: Wed, 07 Jan 2026 09:21:39 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Usama.Anjum@arm.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,pabeni@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,Liam.Howlett@oracle.com,jhubbard@nvidia.com,jgg@nvidia.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-introduce-helper-to-read-every-page-in-range.patch added to mm-new branch
Message-Id: <20260107172140.6C335C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: introduce helper to read every page in range
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-introduce-helper-to-read-every-page-in-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-introduce-helper-to-read-every-page-in-range.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Subject: selftests/mm: introduce helper to read every page in range
Date: Wed, 7 Jan 2026 16:48:39 +0000

FORCE_READ(*addr) ensures that the compiler will emit a load from addr. 
Several tests need to trigger such a load for every page in the range
[addr, addr + len), ensuring that every page is faulted in, if it wasn't
already.

Introduce a new helper force_read_pages_in_range() that does exactly that
and replace existing loops with a call to it.  Some of those loops have a
different step size, but reading from every page is appropriate in all
cases.

Link: https://lkml.kernel.org/r/20260107164842.3289559-6-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Anjum <Usama.Anjum@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb-madvise.c      |    9 ------
 tools/testing/selftests/mm/pfnmap.c               |   16 ++++--------
 tools/testing/selftests/mm/split_huge_page_test.c |    6 ----
 tools/testing/selftests/mm/vm_util.h              |    6 ++++
 4 files changed, 14 insertions(+), 23 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb-madvise.c~selftests-mm-introduce-helper-to-read-every-page-in-range
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
+	force_read_pages_in_range(addr, nr_pages * huge_page_size);
 }
 
 int main(int argc, char **argv)
--- a/tools/testing/selftests/mm/pfnmap.c~selftests-mm-introduce-helper-to-read-every-page-in-range
+++ a/tools/testing/selftests/mm/pfnmap.c
@@ -33,20 +33,17 @@ static void signal_handler(int sig)
 	siglongjmp(sigjmp_buf_env, -EFAULT);
 }
 
-static int test_read_access(char *addr, size_t size, size_t pagesize)
+static int test_read_access(char *addr, size_t size)
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
+		force_read_pages_in_range(addr, size);
+
 	if (signal(SIGSEGV, SIG_DFL) == SIG_ERR)
 		return -EINVAL;
 
@@ -138,7 +135,7 @@ FIXTURE_SETUP(pfnmap)
 		SKIP(return, "Invalid file: '%s'. Not pfnmap'ed\n", file);
 
 	/* ... and want to be able to read from them. */
-	if (test_read_access(self->addr1, self->size1, self->pagesize))
+	if (test_read_access(self->addr1, self->size1))
 		SKIP(return, "Cannot read-access mmap'ed '%s'\n", file);
 
 	self->size2 = 0;
@@ -243,8 +240,7 @@ TEST_F(pfnmap, fork)
 	ASSERT_GE(pid, 0);
 
 	if (!pid) {
-		EXPECT_EQ(test_read_access(self->addr1, self->size1,
-					   self->pagesize), 0);
+		EXPECT_EQ(test_read_access(self->addr1, self->size1), 0);
 		exit(0);
 	}
 
--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-introduce-helper-to-read-every-page-in-range
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -652,11 +652,7 @@ static int create_pagecache_thp_and_fd(c
 	}
 	madvise(*addr, fd_size, MADV_HUGEPAGE);
 
-	for (size_t i = 0; i < fd_size; i++) {
-		char *addr2 = *addr + i;
-
-		FORCE_READ(*addr2);
-	}
+	force_read_pages_in_range(*addr, fd_size);
 
 	if (!check_huge_file(*addr, fd_size / pmd_pagesize, pmd_pagesize)) {
 		ksft_print_msg("No large pagecache folio generated, please provide a filesystem supporting large folio\n");
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-introduce-helper-to-read-every-page-in-range
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -55,6 +55,12 @@ static inline unsigned int pshift(void)
 	return __page_shift;
 }
 
+static inline void force_read_pages_in_range(char *addr, size_t len)
+{
+	for (size_t i = 0; i < len; i += psize())
+		FORCE_READ(addr[i]);
+}
+
 bool detect_huge_zeropage(void);
 
 /*
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

x86-xen-simplify-flush_lazy_mmu.patch
powerpc-mm-implement-arch_flush_lazy_mmu_mode.patch
sparc-mm-implement-arch_flush_lazy_mmu_mode.patch
mm-clarify-lazy_mmu-sleeping-constraints.patch
mm-introduce-config_arch_has_lazy_mmu_mode.patch
mm-introduce-generic-lazy_mmu-helpers.patch
mm-bail-out-of-lazy_mmu_mode_-in-interrupt-context.patch
mm-enable-lazy_mmu-sections-to-nest.patch
arm64-mm-replace-tif_lazy_mmu-with-is_lazy_mmu_mode_active.patch
powerpc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
sparc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
x86-xen-use-lazy_mmu_state-when-context-switching.patch
mm-add-basic-tests-for-lazy_mmu.patch
mm-add-basic-tests-for-lazy_mmu-fix-fix-fix.patch
selftests-mm-default-kdir-to-build-directory.patch
selftests-mm-remove-flaky-header-check.patch
selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch
selftests-mm-fix-usage-of-force_read-in-cow-tests.patch
selftests-mm-introduce-helper-to-read-every-page-in-range.patch
selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch
selftests-mm-fix-exit-code-in-pagemap_ioctl.patch
selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch

