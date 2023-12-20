Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CBC4CDE1
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TB6zYQ5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABADC433C7;
	Wed, 20 Dec 2023 22:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112555;
	bh=7m69MPJLSKKsfWMknkjj3+azz5+6/4a6/TqKvwLDn38=;
	h=Date:To:From:Subject:From;
	b=TB6zYQ5fiASwnE5f8e69smLH41c9cyYIZu7gmU1J74dJycxWLOhjVc6QAsqlBFUmt
	 hUzEtxMBdrZSCOXdMgKQWl/2VdLrq+kraJWgyoHId5aTDyvHs5jVKzWEyOow97b6s1
	 P9ew0YfJImzQ77Hd58VBog5IhZTXbbSnKhrcrOSo=
Date: Wed, 20 Dec 2023 14:49:15 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,vbabka@suse.cz,shy828301@gmail.com,rientjes@google.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,itaru.kitayama@gmail.com,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,catalin.marinas@arm.com,apopple@nvidia.com,anshuman.khandual@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-cow-generalize-do_run_with_thp-helper.patch removed from -mm tree
Message-Id: <20231220224915.9ABADC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/cow: generalize do_run_with_thp() helper
has been removed from the -mm tree.  Its filename was
     selftests-mm-cow-generalize-do_run_with_thp-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm/cow: generalize do_run_with_thp() helper
Date: Thu, 7 Dec 2023 16:12:10 +0000

do_run_with_thp() prepares (PMD-sized) THP memory into different states
before running tests.  With the introduction of multi-size THP, we would
like to reuse this logic to also test those smaller THP sizes.  So let's
add a thpsize parameter which tells the function what size THP it should
operate on.

A separate commit will utilize this change to add new tests for multi-size
THP, where available.

Link: https://lkml.kernel.org/r/20231207161211.2374093-10-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |  121 ++++++++++++++++-------------
 1 file changed, 67 insertions(+), 54 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-cow-generalize-do_run_with_thp-helper
+++ a/tools/testing/selftests/mm/cow.c
@@ -32,7 +32,7 @@
 
 static size_t pagesize;
 static int pagemap_fd;
-static size_t thpsize;
+static size_t pmdsize;
 static int nr_hugetlbsizes;
 static size_t hugetlbsizes[10];
 static int gup_fd;
@@ -734,7 +734,7 @@ enum thp_run {
 	THP_RUN_PARTIAL_SHARED,
 };
 
-static void do_run_with_thp(test_fn fn, enum thp_run thp_run)
+static void do_run_with_thp(test_fn fn, enum thp_run thp_run, size_t thpsize)
 {
 	char *mem, *mmap_mem, *tmp, *mremap_mem = MAP_FAILED;
 	size_t size, mmap_size, mremap_size;
@@ -759,11 +759,11 @@ static void do_run_with_thp(test_fn fn,
 	}
 
 	/*
-	 * Try to populate a THP. Touch the first sub-page and test if we get
-	 * another sub-page populated automatically.
+	 * Try to populate a THP. Touch the first sub-page and test if
+	 * we get the last sub-page populated automatically.
 	 */
 	mem[0] = 0;
-	if (!pagemap_is_populated(pagemap_fd, mem + pagesize)) {
+	if (!pagemap_is_populated(pagemap_fd, mem + thpsize - pagesize)) {
 		ksft_test_result_skip("Did not get a THP populated\n");
 		goto munmap;
 	}
@@ -773,12 +773,14 @@ static void do_run_with_thp(test_fn fn,
 	switch (thp_run) {
 	case THP_RUN_PMD:
 	case THP_RUN_PMD_SWAPOUT:
+		assert(thpsize == pmdsize);
 		break;
 	case THP_RUN_PTE:
 	case THP_RUN_PTE_SWAPOUT:
 		/*
 		 * Trigger PTE-mapping the THP by temporarily mapping a single
-		 * subpage R/O.
+		 * subpage R/O. This is a noop if the THP is not pmdsize (and
+		 * therefore already PTE-mapped).
 		 */
 		ret = mprotect(mem + pagesize, pagesize, PROT_READ);
 		if (ret) {
@@ -875,52 +877,60 @@ munmap:
 		munmap(mremap_mem, mremap_size);
 }
 
-static void run_with_thp(test_fn fn, const char *desc)
+static void run_with_thp(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PMD);
+	ksft_print_msg("[RUN] %s ... with THP (%zu kB)\n",
+		desc, size / 1024);
+	do_run_with_thp(fn, THP_RUN_PMD, size);
 }
 
-static void run_with_thp_swap(test_fn fn, const char *desc)
+static void run_with_thp_swap(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with swapped-out THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PMD_SWAPOUT);
+	ksft_print_msg("[RUN] %s ... with swapped-out THP (%zu kB)\n",
+		desc, size / 1024);
+	do_run_with_thp(fn, THP_RUN_PMD_SWAPOUT, size);
 }
 
-static void run_with_pte_mapped_thp(test_fn fn, const char *desc)
+static void run_with_pte_mapped_thp(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with PTE-mapped THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PTE);
+	ksft_print_msg("[RUN] %s ... with PTE-mapped THP (%zu kB)\n",
+		desc, size / 1024);
+	do_run_with_thp(fn, THP_RUN_PTE, size);
 }
 
-static void run_with_pte_mapped_thp_swap(test_fn fn, const char *desc)
+static void run_with_pte_mapped_thp_swap(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with swapped-out, PTE-mapped THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PTE_SWAPOUT);
+	ksft_print_msg("[RUN] %s ... with swapped-out, PTE-mapped THP (%zu kB)\n",
+		desc, size / 1024);
+	do_run_with_thp(fn, THP_RUN_PTE_SWAPOUT, size);
 }
 
-static void run_with_single_pte_of_thp(test_fn fn, const char *desc)
+static void run_with_single_pte_of_thp(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with single PTE of THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_SINGLE_PTE);
+	ksft_print_msg("[RUN] %s ... with single PTE of THP (%zu kB)\n",
+		desc, size / 1024);
+	do_run_with_thp(fn, THP_RUN_SINGLE_PTE, size);
 }
 
-static void run_with_single_pte_of_thp_swap(test_fn fn, const char *desc)
+static void run_with_single_pte_of_thp_swap(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with single PTE of swapped-out THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_SINGLE_PTE_SWAPOUT);
+	ksft_print_msg("[RUN] %s ... with single PTE of swapped-out THP (%zu kB)\n",
+		desc, size / 1024);
+	do_run_with_thp(fn, THP_RUN_SINGLE_PTE_SWAPOUT, size);
 }
 
-static void run_with_partial_mremap_thp(test_fn fn, const char *desc)
+static void run_with_partial_mremap_thp(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with partially mremap()'ed THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PARTIAL_MREMAP);
+	ksft_print_msg("[RUN] %s ... with partially mremap()'ed THP (%zu kB)\n",
+		desc, size / 1024);
+	do_run_with_thp(fn, THP_RUN_PARTIAL_MREMAP, size);
 }
 
-static void run_with_partial_shared_thp(test_fn fn, const char *desc)
+static void run_with_partial_shared_thp(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with partially shared THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PARTIAL_SHARED);
+	ksft_print_msg("[RUN] %s ... with partially shared THP (%zu kB)\n",
+		desc, size / 1024);
+	do_run_with_thp(fn, THP_RUN_PARTIAL_SHARED, size);
 }
 
 static void run_with_hugetlb(test_fn fn, const char *desc, size_t hugetlbsize)
@@ -1091,15 +1101,15 @@ static void run_anon_test_case(struct te
 
 	run_with_base_page(test_case->fn, test_case->desc);
 	run_with_base_page_swap(test_case->fn, test_case->desc);
-	if (thpsize) {
-		run_with_thp(test_case->fn, test_case->desc);
-		run_with_thp_swap(test_case->fn, test_case->desc);
-		run_with_pte_mapped_thp(test_case->fn, test_case->desc);
-		run_with_pte_mapped_thp_swap(test_case->fn, test_case->desc);
-		run_with_single_pte_of_thp(test_case->fn, test_case->desc);
-		run_with_single_pte_of_thp_swap(test_case->fn, test_case->desc);
-		run_with_partial_mremap_thp(test_case->fn, test_case->desc);
-		run_with_partial_shared_thp(test_case->fn, test_case->desc);
+	if (pmdsize) {
+		run_with_thp(test_case->fn, test_case->desc, pmdsize);
+		run_with_thp_swap(test_case->fn, test_case->desc, pmdsize);
+		run_with_pte_mapped_thp(test_case->fn, test_case->desc, pmdsize);
+		run_with_pte_mapped_thp_swap(test_case->fn, test_case->desc, pmdsize);
+		run_with_single_pte_of_thp(test_case->fn, test_case->desc, pmdsize);
+		run_with_single_pte_of_thp_swap(test_case->fn, test_case->desc, pmdsize);
+		run_with_partial_mremap_thp(test_case->fn, test_case->desc, pmdsize);
+		run_with_partial_shared_thp(test_case->fn, test_case->desc, pmdsize);
 	}
 	for (i = 0; i < nr_hugetlbsizes; i++)
 		run_with_hugetlb(test_case->fn, test_case->desc,
@@ -1120,7 +1130,7 @@ static int tests_per_anon_test_case(void
 {
 	int tests = 2 + nr_hugetlbsizes;
 
-	if (thpsize)
+	if (pmdsize)
 		tests += 8;
 	return tests;
 }
@@ -1329,7 +1339,7 @@ static void run_anon_thp_test_cases(void
 {
 	int i;
 
-	if (!thpsize)
+	if (!pmdsize)
 		return;
 
 	ksft_print_msg("[INFO] Anonymous THP tests\n");
@@ -1338,13 +1348,13 @@ static void run_anon_thp_test_cases(void
 		struct test_case const *test_case = &anon_thp_test_cases[i];
 
 		ksft_print_msg("[RUN] %s\n", test_case->desc);
-		do_run_with_thp(test_case->fn, THP_RUN_PMD);
+		do_run_with_thp(test_case->fn, THP_RUN_PMD, pmdsize);
 	}
 }
 
 static int tests_per_anon_thp_test_case(void)
 {
-	return thpsize ? 1 : 0;
+	return pmdsize ? 1 : 0;
 }
 
 typedef void (*non_anon_test_fn)(char *mem, const char *smem, size_t size);
@@ -1419,7 +1429,7 @@ static void run_with_huge_zeropage(non_a
 	}
 
 	/* For alignment purposes, we need twice the thp size. */
-	mmap_size = 2 * thpsize;
+	mmap_size = 2 * pmdsize;
 	mmap_mem = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
 			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	if (mmap_mem == MAP_FAILED) {
@@ -1434,11 +1444,11 @@ static void run_with_huge_zeropage(non_a
 	}
 
 	/* We need a THP-aligned memory area. */
-	mem = (char *)(((uintptr_t)mmap_mem + thpsize) & ~(thpsize - 1));
-	smem = (char *)(((uintptr_t)mmap_smem + thpsize) & ~(thpsize - 1));
+	mem = (char *)(((uintptr_t)mmap_mem + pmdsize) & ~(pmdsize - 1));
+	smem = (char *)(((uintptr_t)mmap_smem + pmdsize) & ~(pmdsize - 1));
 
-	ret = madvise(mem, thpsize, MADV_HUGEPAGE);
-	ret |= madvise(smem, thpsize, MADV_HUGEPAGE);
+	ret = madvise(mem, pmdsize, MADV_HUGEPAGE);
+	ret |= madvise(smem, pmdsize, MADV_HUGEPAGE);
 	if (ret) {
 		ksft_test_result_fail("MADV_HUGEPAGE failed\n");
 		goto munmap;
@@ -1457,7 +1467,7 @@ static void run_with_huge_zeropage(non_a
 		goto munmap;
 	}
 
-	fn(mem, smem, thpsize);
+	fn(mem, smem, pmdsize);
 munmap:
 	munmap(mmap_mem, mmap_size);
 	if (mmap_smem != MAP_FAILED)
@@ -1650,7 +1660,7 @@ static void run_non_anon_test_case(struc
 	run_with_zeropage(test_case->fn, test_case->desc);
 	run_with_memfd(test_case->fn, test_case->desc);
 	run_with_tmpfile(test_case->fn, test_case->desc);
-	if (thpsize)
+	if (pmdsize)
 		run_with_huge_zeropage(test_case->fn, test_case->desc);
 	for (i = 0; i < nr_hugetlbsizes; i++)
 		run_with_memfd_hugetlb(test_case->fn, test_case->desc,
@@ -1671,7 +1681,7 @@ static int tests_per_non_anon_test_case(
 {
 	int tests = 3 + nr_hugetlbsizes;
 
-	if (thpsize)
+	if (pmdsize)
 		tests += 1;
 	return tests;
 }
@@ -1683,10 +1693,13 @@ int main(int argc, char **argv)
 	ksft_print_header();
 
 	pagesize = getpagesize();
-	thpsize = read_pmd_pagesize();
-	if (thpsize)
+	pmdsize = read_pmd_pagesize();
+	if (pmdsize) {
+		ksft_print_msg("[INFO] detected PMD size: %zu KiB\n",
+			       pmdsize / 1024);
 		ksft_print_msg("[INFO] detected THP size: %zu KiB\n",
-			       thpsize / 1024);
+			       pmdsize / 1024);
+	}
 	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
 						    ARRAY_SIZE(hugetlbsizes));
 	detect_huge_zeropage();
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-mm-log-run_vmtestssh-results-in-tap-format.patch

