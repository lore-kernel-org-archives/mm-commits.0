Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A47DC04A6A
	for <mm-commits@archiver.kernel.org>; Thu, 10 Aug 2023 16:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbjHJQbl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Aug 2023 12:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233748AbjHJQbf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2023 12:31:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25C0C5
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 09:31:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4402964F63
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 16:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996EEC433C8;
        Thu, 10 Aug 2023 16:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691685093;
        bh=0jU/gX88BAAQy9faPy1dSRB0rc9NJrFYxn0KJRSVgM8=;
        h=Date:To:From:Subject:From;
        b=TDKTYqrusvwUXUDMw3vLjZcWK3HtYMiGWBDPkpJRQ0EHPLR3E9H5JGJ/iq3md5jOI
         tUTDRvLQ7I9rmgqXHB2Gu0QyDy94vXTtn/A+Zon0A6SYY2Ih75GkU8UP9kJbHmobWe
         JLsGD+DaJZiiLGYDwsXT+Y/BmOcEbhvVWhDUjAoE=
Date:   Thu, 10 Aug 2023 09:31:33 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, shy828301@gmail.com,
        mcgrof@kernel.org, kirill.shutemov@linux.intel.com,
        itaru.kitayama@gmail.com, fengwei.yin@intel.com, david@redhat.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        ryan.roberts@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-cow-generalize-do_run_with_thp-helper.patch added to mm-unstable branch
Message-Id: <20230810163133.996EEC433C8@smtp.kernel.org>
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
Date: Thu, 10 Aug 2023 15:29:41 +0100

do_run_with_thp() prepares THP memory into different states before running
tests.  We would like to reuse this logic to also test large anon folios. 
So let's add a size parameter which tells the function what size of memory
it should operate on.

Remove references to THP and replace with LARGE, and fix up all existing
call sites to pass thpsize as the required size.

No functional change intended here, but a separate commit will add new
large anon folio tests that use this new capability.

Link: https://lkml.kernel.org/r/20230810142942.3169679-5-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |  118 ++++++++++++++---------------
 1 file changed, 61 insertions(+), 57 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-cow-generalize-do_run_with_thp-helper
+++ a/tools/testing/selftests/mm/cow.c
@@ -723,25 +723,25 @@ static void run_with_base_page_swap(test
 	do_run_with_base_page(fn, true);
 }
 
-enum thp_run {
-	THP_RUN_PMD,
-	THP_RUN_PMD_SWAPOUT,
-	THP_RUN_PTE,
-	THP_RUN_PTE_SWAPOUT,
-	THP_RUN_SINGLE_PTE,
-	THP_RUN_SINGLE_PTE_SWAPOUT,
-	THP_RUN_PARTIAL_MREMAP,
-	THP_RUN_PARTIAL_SHARED,
+enum large_run {
+	LARGE_RUN_PMD,
+	LARGE_RUN_PMD_SWAPOUT,
+	LARGE_RUN_PTE,
+	LARGE_RUN_PTE_SWAPOUT,
+	LARGE_RUN_SINGLE_PTE,
+	LARGE_RUN_SINGLE_PTE_SWAPOUT,
+	LARGE_RUN_PARTIAL_MREMAP,
+	LARGE_RUN_PARTIAL_SHARED,
 };
 
-static void do_run_with_thp(test_fn fn, enum thp_run thp_run)
+static void do_run_with_large(test_fn fn, enum large_run large_run, size_t size)
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
+	 * Try to populate a large folio. Touch the first sub-page and test if
+	 * we get the last sub-page populated automatically.
 	 */
 	mem[0] = 0;
-	if (!pagemap_is_populated(pagemap_fd, mem + pagesize)) {
-		ksft_test_result_skip("Did not get a THP populated\n");
+	if (!pagemap_is_populated(pagemap_fd, mem + size - pagesize)) {
+		ksft_test_result_skip("Did not get fully populated\n");
 		goto munmap;
 	}
-	memset(mem, 0, thpsize);
+	memset(mem, 0, size);
 
-	size = thpsize;
-	switch (thp_run) {
-	case THP_RUN_PMD:
-	case THP_RUN_PMD_SWAPOUT:
+	switch (large_run) {
+	case LARGE_RUN_PMD:
+	case LARGE_RUN_PMD_SWAPOUT:
+		if (size != thpsize) {
+			ksft_test_result_fail("test bug: can't PMD-map size\n");
+			goto munmap;
+		}
 		break;
-	case THP_RUN_PTE:
-	case THP_RUN_PTE_SWAPOUT:
+	case LARGE_RUN_PTE:
+	case LARGE_RUN_PTE_SWAPOUT:
 		/*
-		 * Trigger PTE-mapping the THP by temporarily mapping a single
-		 * subpage R/O.
+		 * Trigger PTE-mapping the large folio by temporarily mapping a
+		 * single subpage R/O. This is a noop if the large-folio is not
+		 * thpsize (and therefore already PTE-mapped).
 		 */
 		ret = mprotect(mem + pagesize, pagesize, PROT_READ);
 		if (ret) {
@@ -791,25 +795,25 @@ static void do_run_with_thp(test_fn fn,
 			goto munmap;
 		}
 		break;
-	case THP_RUN_SINGLE_PTE:
-	case THP_RUN_SINGLE_PTE_SWAPOUT:
+	case LARGE_RUN_SINGLE_PTE:
+	case LARGE_RUN_SINGLE_PTE_SWAPOUT:
 		/*
-		 * Discard all but a single subpage of that PTE-mapped THP. What
-		 * remains is a single PTE mapping a single subpage.
+		 * Discard all but a single subpage of that PTE-mapped large
+		 * folio. What remains is a single PTE mapping a single subpage.
 		 */
-		ret = madvise(mem + pagesize, thpsize - pagesize, MADV_DONTNEED);
+		ret = madvise(mem + pagesize, size - pagesize, MADV_DONTNEED);
 		if (ret) {
 			ksft_test_result_fail("MADV_DONTNEED failed\n");
 			goto munmap;
 		}
 		size = pagesize;
 		break;
-	case THP_RUN_PARTIAL_MREMAP:
+	case LARGE_RUN_PARTIAL_MREMAP:
 		/*
-		 * Remap half of the THP. We need some new memory location
-		 * for that.
+		 * Remap half of the lareg folio. We need some new memory
+		 * location for that.
 		 */
-		mremap_size = thpsize / 2;
+		mremap_size = size / 2;
 		mremap_mem = mmap(NULL, mremap_size, PROT_NONE,
 				  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 		if (mem == MAP_FAILED) {
@@ -824,13 +828,13 @@ static void do_run_with_thp(test_fn fn,
 		}
 		size = mremap_size;
 		break;
-	case THP_RUN_PARTIAL_SHARED:
+	case LARGE_RUN_PARTIAL_SHARED:
 		/*
-		 * Share the first page of the THP with a child and quit the
-		 * child. This will result in some parts of the THP never
-		 * have been shared.
+		 * Share the first page of the large folio with a child and quit
+		 * the child. This will result in some parts of the large folio
+		 * never have been shared.
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
@@ -854,10 +858,10 @@ static void do_run_with_thp(test_fn fn,
 		assert(false);
 	}
 
-	switch (thp_run) {
-	case THP_RUN_PMD_SWAPOUT:
-	case THP_RUN_PTE_SWAPOUT:
-	case THP_RUN_SINGLE_PTE_SWAPOUT:
+	switch (large_run) {
+	case LARGE_RUN_PMD_SWAPOUT:
+	case LARGE_RUN_PTE_SWAPOUT:
+	case LARGE_RUN_SINGLE_PTE_SWAPOUT:
 		madvise(mem, size, MADV_PAGEOUT);
 		if (!range_is_swapped(mem, size)) {
 			ksft_test_result_skip("MADV_PAGEOUT did not work, is swap enabled?\n");
@@ -878,49 +882,49 @@ munmap:
 static void run_with_thp(test_fn fn, const char *desc)
 {
 	ksft_print_msg("[RUN] %s ... with THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PMD);
+	do_run_with_large(fn, LARGE_RUN_PMD, thpsize);
 }
 
 static void run_with_thp_swap(test_fn fn, const char *desc)
 {
 	ksft_print_msg("[RUN] %s ... with swapped-out THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PMD_SWAPOUT);
+	do_run_with_large(fn, LARGE_RUN_PMD_SWAPOUT, thpsize);
 }
 
 static void run_with_pte_mapped_thp(test_fn fn, const char *desc)
 {
 	ksft_print_msg("[RUN] %s ... with PTE-mapped THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PTE);
+	do_run_with_large(fn, LARGE_RUN_PTE, thpsize);
 }
 
 static void run_with_pte_mapped_thp_swap(test_fn fn, const char *desc)
 {
 	ksft_print_msg("[RUN] %s ... with swapped-out, PTE-mapped THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PTE_SWAPOUT);
+	do_run_with_large(fn, LARGE_RUN_PTE_SWAPOUT, thpsize);
 }
 
 static void run_with_single_pte_of_thp(test_fn fn, const char *desc)
 {
 	ksft_print_msg("[RUN] %s ... with single PTE of THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_SINGLE_PTE);
+	do_run_with_large(fn, LARGE_RUN_SINGLE_PTE, thpsize);
 }
 
 static void run_with_single_pte_of_thp_swap(test_fn fn, const char *desc)
 {
 	ksft_print_msg("[RUN] %s ... with single PTE of swapped-out THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_SINGLE_PTE_SWAPOUT);
+	do_run_with_large(fn, LARGE_RUN_SINGLE_PTE_SWAPOUT, thpsize);
 }
 
 static void run_with_partial_mremap_thp(test_fn fn, const char *desc)
 {
 	ksft_print_msg("[RUN] %s ... with partially mremap()'ed THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PARTIAL_MREMAP);
+	do_run_with_large(fn, LARGE_RUN_PARTIAL_MREMAP, thpsize);
 }
 
 static void run_with_partial_shared_thp(test_fn fn, const char *desc)
 {
 	ksft_print_msg("[RUN] %s ... with partially shared THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PARTIAL_SHARED);
+	do_run_with_large(fn, LARGE_RUN_PARTIAL_SHARED, thpsize);
 }
 
 static void run_with_hugetlb(test_fn fn, const char *desc, size_t hugetlbsize)
@@ -1338,7 +1342,7 @@ static void run_anon_thp_test_cases(void
 		struct test_case const *test_case = &anon_thp_test_cases[i];
 
 		ksft_print_msg("[RUN] %s\n", test_case->desc);
-		do_run_with_thp(test_case->fn, THP_RUN_PMD);
+		do_run_with_large(test_case->fn, LARGE_RUN_PMD, thpsize);
 	}
 }
 
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-line-buffer-test-programs-stdout.patch
selftests-line-buffer-test-programs-stdout-fix.patch
selftests-mm-skip-soft-dirty-tests-on-arm64.patch
selftests-mm-enable-mrelease_test-for-arm64.patch
selftests-mm-fix-thuge-gen-test-bugs.patch
selftests-mm-va_high_addr_switch-should-skip-unsupported-arm64-configs.patch
selftests-mm-make-migration-test-robust-to-failure.patch
selftests-mm-optionally-pass-duration-to-transhuge-stress.patch
selftests-mm-run-all-tests-from-run_vmtestssh.patch
mm-allow-deferred-splitting-of-arbitrary-large-anon-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-large_anon_folio-for-improved-performance.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-large-anon-folio-tests.patch

