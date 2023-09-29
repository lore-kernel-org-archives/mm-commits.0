Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A86E728D8
	for <mm-commits@archiver.kernel.org>; Fri, 29 Sep 2023 19:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbjI2TI7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 15:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbjI2TI5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 15:08:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381A2195
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 12:08:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CAFC433C9;
        Fri, 29 Sep 2023 19:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696014532;
        bh=su21iu2/tALndDqFnDjlq0FbN3M5rtlRzI1eVNWL0OQ=;
        h=Date:To:From:Subject:From;
        b=DXjMo6mBTqyoOf5VCQBC3BMktEQ7b7JhkWt9JlApkRUG0pUJPSj0Mc0/WaEPzSBPU
         jlyWOHQ5BeV5iwICRzPlRNnpUm/s/j7onkVYZDVb0D/uZsLvzG3iYEc27Rt6mlL1x/
         XwUZDY+wt+rrYJ65Lbnv+ZtsMHjjlrm4oYCFTBos=
Date:   Fri, 29 Sep 2023 12:08:52 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rientjes@google.com, mcgrof@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        itaru.kitayama@gmail.com, hughd@google.com, fengwei.yin@intel.com,
        david@redhat.com, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-cow-generalize-do_run_with_thp-helper.patch added to mm-unstable branch
Message-Id: <20230929190852.C3CAFC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm/cow: generalize do_run_with_thp() helper
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-cow-generalize-do_run_with_thp-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-cow-generalize-do_run_with_thp-helper.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm/cow: generalize do_run_with_thp() helper
Date: Fri, 29 Sep 2023 12:44:19 +0100

do_run_with_thp() prepares (PMD-sized) THP memory into different states
before running tests. With the introduction of THP orders that are
smaller than PMD_ORDER, we would like to reuse this logic to also test
those smaller orders. So let's add a size parameter which tells the
function what size THP it should operate on.

No functional change intended here, but a separate commit will add new
tests for smaller order THP, where available.

Link: https://lkml.kernel.org/r/20230929114421.3761121-9-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
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

 tools/testing/selftests/mm/cow.c |  151 ++++++++++++++++-------------
 1 file changed, 84 insertions(+), 67 deletions(-)

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
@@ -734,14 +734,14 @@ enum thp_run {
 	THP_RUN_PARTIAL_SHARED,
 };
 
-static void do_run_with_thp(test_fn fn, enum thp_run thp_run)
+static void do_run_with_thp(test_fn fn, enum thp_run thp_run, size_t size)
 {
 	char *mem, *mmap_mem, *tmp, *mremap_mem = MAP_FAILED;
-	size_t size, mmap_size, mremap_size;
+	size_t mmap_size, mremap_size;
 	int ret;
 
-	/* For alignment purposes, we need twice the thp size. */
-	mmap_size = 2 * thpsize;
+	/* For alignment purposes, we need twice the requested size. */
+	mmap_size = 2 * size;
 	mmap_mem = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
 			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	if (mmap_mem == MAP_FAILED) {
@@ -749,36 +749,40 @@ static void do_run_with_thp(test_fn fn,
 		return;
 	}
 
-	/* We need a THP-aligned memory area. */
-	mem = (char *)(((uintptr_t)mmap_mem + thpsize) & ~(thpsize - 1));
+	/* We need to naturally align the memory area. */
+	mem = (char *)(((uintptr_t)mmap_mem + size) & ~(size - 1));
 
-	ret = madvise(mem, thpsize, MADV_HUGEPAGE);
+	ret = madvise(mem, size, MADV_HUGEPAGE);
 	if (ret) {
 		ksft_test_result_fail("MADV_HUGEPAGE failed\n");
 		goto munmap;
 	}
 
 	/*
-	 * Try to populate a THP. Touch the first sub-page and test if we get
-	 * another sub-page populated automatically.
+	 * Try to populate a THP. Touch the first sub-page and test if
+	 * we get the last sub-page populated automatically.
 	 */
 	mem[0] = 0;
-	if (!pagemap_is_populated(pagemap_fd, mem + pagesize)) {
+	if (!pagemap_is_populated(pagemap_fd, mem + size - pagesize)) {
 		ksft_test_result_skip("Did not get a THP populated\n");
 		goto munmap;
 	}
-	memset(mem, 0, thpsize);
+	memset(mem, 0, size);
 
-	size = thpsize;
 	switch (thp_run) {
 	case THP_RUN_PMD:
 	case THP_RUN_PMD_SWAPOUT:
+		if (size != pmdsize) {
+			ksft_test_result_fail("test bug: can't PMD-map size\n");
+			goto munmap;
+		}
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
@@ -797,7 +801,7 @@ static void do_run_with_thp(test_fn fn,
 		 * Discard all but a single subpage of that PTE-mapped THP. What
 		 * remains is a single PTE mapping a single subpage.
 		 */
-		ret = madvise(mem + pagesize, thpsize - pagesize, MADV_DONTNEED);
+		ret = madvise(mem + pagesize, size - pagesize, MADV_DONTNEED);
 		if (ret) {
 			ksft_test_result_fail("MADV_DONTNEED failed\n");
 			goto munmap;
@@ -809,7 +813,7 @@ static void do_run_with_thp(test_fn fn,
 		 * Remap half of the THP. We need some new memory location
 		 * for that.
 		 */
-		mremap_size = thpsize / 2;
+		mremap_size = size / 2;
 		mremap_mem = mmap(NULL, mremap_size, PROT_NONE,
 				  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 		if (mem == MAP_FAILED) {
@@ -830,7 +834,7 @@ static void do_run_with_thp(test_fn fn,
 		 * child. This will result in some parts of the THP never
 		 * have been shared.
 		 */
-		ret = madvise(mem + pagesize, thpsize - pagesize, MADV_DONTFORK);
+		ret = madvise(mem + pagesize, size - pagesize, MADV_DONTFORK);
 		if (ret) {
 			ksft_test_result_fail("MADV_DONTFORK failed\n");
 			goto munmap;
@@ -844,7 +848,7 @@ static void do_run_with_thp(test_fn fn,
 		}
 		wait(&ret);
 		/* Allow for sharing all pages again. */
-		ret = madvise(mem + pagesize, thpsize - pagesize, MADV_DOFORK);
+		ret = madvise(mem + pagesize, size - pagesize, MADV_DOFORK);
 		if (ret) {
 			ksft_test_result_fail("MADV_DOFORK failed\n");
 			goto munmap;
@@ -875,52 +879,65 @@ munmap:
 		munmap(mremap_mem, mremap_size);
 }
 
-static void run_with_thp(test_fn fn, const char *desc)
+static int sz2ord(size_t size)
+{
+	return __builtin_ctzll(size / pagesize);
+}
+
+static void run_with_thp(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PMD);
+	ksft_print_msg("[RUN] %s ... with order-%d THP\n",
+		desc, sz2ord(size));
+	do_run_with_thp(fn, THP_RUN_PMD, size);
 }
 
-static void run_with_thp_swap(test_fn fn, const char *desc)
+static void run_with_thp_swap(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with swapped-out THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PMD_SWAPOUT);
+	ksft_print_msg("[RUN] %s ... with swapped-out order-%d THP\n",
+		desc, sz2ord(size));
+	do_run_with_thp(fn, THP_RUN_PMD_SWAPOUT, size);
 }
 
-static void run_with_pte_mapped_thp(test_fn fn, const char *desc)
+static void run_with_pte_mapped_thp(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with PTE-mapped THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PTE);
+	ksft_print_msg("[RUN] %s ... with PTE-mapped order-%d THP\n",
+		desc, sz2ord(size));
+	do_run_with_thp(fn, THP_RUN_PTE, size);
 }
 
-static void run_with_pte_mapped_thp_swap(test_fn fn, const char *desc)
+static void run_with_pte_mapped_thp_swap(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with swapped-out, PTE-mapped THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PTE_SWAPOUT);
+	ksft_print_msg("[RUN] %s ... with swapped-out, PTE-mapped order-%d THP\n",
+		desc, sz2ord(size));
+	do_run_with_thp(fn, THP_RUN_PTE_SWAPOUT, size);
 }
 
-static void run_with_single_pte_of_thp(test_fn fn, const char *desc)
+static void run_with_single_pte_of_thp(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with single PTE of THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_SINGLE_PTE);
+	ksft_print_msg("[RUN] %s ... with single PTE of order-%d THP\n",
+		desc, sz2ord(size));
+	do_run_with_thp(fn, THP_RUN_SINGLE_PTE, size);
 }
 
-static void run_with_single_pte_of_thp_swap(test_fn fn, const char *desc)
+static void run_with_single_pte_of_thp_swap(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with single PTE of swapped-out THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_SINGLE_PTE_SWAPOUT);
+	ksft_print_msg("[RUN] %s ... with single PTE of swapped-out order-%d THP\n",
+		desc, sz2ord(size));
+	do_run_with_thp(fn, THP_RUN_SINGLE_PTE_SWAPOUT, size);
 }
 
-static void run_with_partial_mremap_thp(test_fn fn, const char *desc)
+static void run_with_partial_mremap_thp(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with partially mremap()'ed THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PARTIAL_MREMAP);
+	ksft_print_msg("[RUN] %s ... with partially mremap()'ed order-%d THP\n",
+		desc, sz2ord(size));
+	do_run_with_thp(fn, THP_RUN_PARTIAL_MREMAP, size);
 }
 
-static void run_with_partial_shared_thp(test_fn fn, const char *desc)
+static void run_with_partial_shared_thp(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with partially shared THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PARTIAL_SHARED);
+	ksft_print_msg("[RUN] %s ... with partially shared order-%d THP\n",
+		desc, sz2ord(size));
+	do_run_with_thp(fn, THP_RUN_PARTIAL_SHARED, size);
 }
 
 static void run_with_hugetlb(test_fn fn, const char *desc, size_t hugetlbsize)
@@ -1091,15 +1108,15 @@ static void run_anon_test_case(struct te
 
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
@@ -1120,7 +1137,7 @@ static int tests_per_anon_test_case(void
 {
 	int tests = 2 + nr_hugetlbsizes;
 
-	if (thpsize)
+	if (pmdsize)
 		tests += 8;
 	return tests;
 }
@@ -1329,7 +1346,7 @@ static void run_anon_thp_test_cases(void
 {
 	int i;
 
-	if (!thpsize)
+	if (!pmdsize)
 		return;
 
 	ksft_print_msg("[INFO] Anonymous THP tests\n");
@@ -1338,13 +1355,13 @@ static void run_anon_thp_test_cases(void
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
@@ -1419,7 +1436,7 @@ static void run_with_huge_zeropage(non_a
 	}
 
 	/* For alignment purposes, we need twice the thp size. */
-	mmap_size = 2 * thpsize;
+	mmap_size = 2 * pmdsize;
 	mmap_mem = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
 			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	if (mmap_mem == MAP_FAILED) {
@@ -1434,11 +1451,11 @@ static void run_with_huge_zeropage(non_a
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
@@ -1457,7 +1474,7 @@ static void run_with_huge_zeropage(non_a
 		goto munmap;
 	}
 
-	fn(mem, smem, thpsize);
+	fn(mem, smem, pmdsize);
 munmap:
 	munmap(mmap_mem, mmap_size);
 	if (mmap_smem != MAP_FAILED)
@@ -1650,7 +1667,7 @@ static void run_non_anon_test_case(struc
 	run_with_zeropage(test_case->fn, test_case->desc);
 	run_with_memfd(test_case->fn, test_case->desc);
 	run_with_tmpfile(test_case->fn, test_case->desc);
-	if (thpsize)
+	if (pmdsize)
 		run_with_huge_zeropage(test_case->fn, test_case->desc);
 	for (i = 0; i < nr_hugetlbsizes; i++)
 		run_with_memfd_hugetlb(test_case->fn, test_case->desc,
@@ -1671,7 +1688,7 @@ static int tests_per_non_anon_test_case(
 {
 	int tests = 3 + nr_hugetlbsizes;
 
-	if (thpsize)
+	if (pmdsize)
 		tests += 1;
 	return tests;
 }
@@ -1681,10 +1698,10 @@ int main(int argc, char **argv)
 	int err;
 
 	pagesize = getpagesize();
-	thpsize = read_pmd_pagesize();
-	if (thpsize)
-		ksft_print_msg("[INFO] detected THP size: %zu KiB\n",
-			       thpsize / 1024);
+	pmdsize = read_pmd_pagesize();
+	if (pmdsize)
+		ksft_print_msg("[INFO] detected PMD-mapped THP size: %zu KiB\n",
+			       pmdsize / 1024);
 	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
 						    ARRAY_SIZE(hugetlbsizes));
 	detect_huge_zeropage();
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-hugetlb-add-huge-page-size-param-to-set_huge_pte_at.patch
arm64-hugetlb-fix-set_huge_pte_at-to-work-with-all-swap-entries.patch
mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-account-pte-mapped-anonymous-thp-usage.patch
mm-thp-introduce-anon_orders-and-anon_always_mask-sysfs-files.patch
mm-thp-extend-thp-to-allocate-anonymous-large-folios.patch
mm-thp-add-recommend-option-for-anon_orders.patch
arm64-mm-override-arch_wants_pte_order.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-small-order-anon-thp.patch

