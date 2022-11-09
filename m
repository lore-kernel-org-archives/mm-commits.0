Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1F45C4321E
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiKIBi5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiKIBio (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BD763CF8
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4894DB81CC8
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE044C433D6;
        Wed,  9 Nov 2022 01:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957914;
        bh=CAkV0OWov185HR6RjfgW0WHeWcT2GynHkcuxMh7pUEc=;
        h=Date:To:From:Subject:From;
        b=jSdEGIAvKXbjtL0sQk6qjHBopUKIlCQLTO0NK55/F6NM1PWrdVHcNlwgpFvkXmvRb
         5STrmRWsCRtvtI15xOgzwkWC9KAOT0CvouGewshzvavc803PyA5AzSSR9FOM9IG5QJ
         ju3TP5KxLZNSrunqb54GQr78/Yju15TElz6/yDpY=
Date:   Tue, 08 Nov 2022 17:38:33 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shuah@kernel.org,
        rppt@kernel.org, peterx@redhat.com, namit@vmware.com,
        jhubbard@nvidia.com, jgg@nvidia.com, ddutile@redhat.com,
        crecklin@redhat.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-anon_cow-thp-tests.patch removed from -mm tree
Message-Id: <20221109013833.DE044C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: anon_cow: THP tests
has been removed from the -mm tree.  Its filename was
     selftests-vm-anon_cow-thp-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests/vm: anon_cow: THP tests
Date: Tue, 27 Sep 2022 13:01:16 +0200

Let's add various THP variants that we'll run with our existing test
cases.

Link: https://lkml.kernel.org/r/20220927110120.106906-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph von Recklinghausen <crecklin@redhat.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/anon_cow.c |  259 +++++++++++++++++++++++-
 1 file changed, 258 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/anon_cow.c~selftests-vm-anon_cow-thp-tests
+++ a/tools/testing/selftests/vm/anon_cow.c
@@ -24,6 +24,43 @@
 
 static size_t pagesize;
 static int pagemap_fd;
+static size_t thpsize;
+
+static void detect_thpsize(void)
+{
+	int fd = open("/sys/kernel/mm/transparent_hugepage/hpage_pmd_size",
+		      O_RDONLY);
+	size_t size = 0;
+	char buf[15];
+	int ret;
+
+	if (fd < 0)
+		return;
+
+	ret = pread(fd, buf, sizeof(buf), 0);
+	if (ret > 0 && ret < sizeof(buf)) {
+		buf[ret] = 0;
+
+		size = strtoul(buf, NULL, 10);
+		if (size < pagesize)
+			size = 0;
+		if (size > 0) {
+			thpsize = size;
+			ksft_print_msg("[INFO] detected THP size: %zu KiB\n",
+				       thpsize / 1024);
+		}
+	}
+
+	close(fd);
+}
+
+static bool range_is_swapped(void *addr, size_t size)
+{
+	for (; size; addr += pagesize, size -= pagesize)
+		if (!pagemap_is_swapped(pagemap_fd, addr))
+			return false;
+	return true;
+}
 
 struct comm_pipes {
 	int child_ready[2];
@@ -319,6 +356,206 @@ static void run_with_base_page_swap(test
 	do_run_with_base_page(fn, true);
 }
 
+enum thp_run {
+	THP_RUN_PMD,
+	THP_RUN_PMD_SWAPOUT,
+	THP_RUN_PTE,
+	THP_RUN_PTE_SWAPOUT,
+	THP_RUN_SINGLE_PTE,
+	THP_RUN_SINGLE_PTE_SWAPOUT,
+	THP_RUN_PARTIAL_MREMAP,
+	THP_RUN_PARTIAL_SHARED,
+};
+
+static void do_run_with_thp(test_fn fn, enum thp_run thp_run)
+{
+	char *mem, *mmap_mem, *tmp, *mremap_mem = MAP_FAILED;
+	size_t size, mmap_size, mremap_size;
+	int ret;
+
+	/* For alignment purposes, we need twice the thp size. */
+	mmap_size = 2 * thpsize;
+	mmap_mem = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mmap_mem == MAP_FAILED) {
+		ksft_test_result_fail("mmap() failed\n");
+		return;
+	}
+
+	/* We need a THP-aligned memory area. */
+	mem = (char *)(((uintptr_t)mmap_mem + thpsize) & ~(thpsize - 1));
+
+	ret = madvise(mem, thpsize, MADV_HUGEPAGE);
+	if (ret) {
+		ksft_test_result_fail("MADV_HUGEPAGE failed\n");
+		goto munmap;
+	}
+
+	/*
+	 * Try to populate a THP. Touch the first sub-page and test if we get
+	 * another sub-page populated automatically.
+	 */
+	mem[0] = 0;
+	if (!pagemap_is_populated(pagemap_fd, mem + pagesize)) {
+		ksft_test_result_skip("Did not get a THP populated\n");
+		goto munmap;
+	}
+	memset(mem, 0, thpsize);
+
+	size = thpsize;
+	switch (thp_run) {
+	case THP_RUN_PMD:
+	case THP_RUN_PMD_SWAPOUT:
+		break;
+	case THP_RUN_PTE:
+	case THP_RUN_PTE_SWAPOUT:
+		/*
+		 * Trigger PTE-mapping the THP by temporarily mapping a single
+		 * subpage R/O.
+		 */
+		ret = mprotect(mem + pagesize, pagesize, PROT_READ);
+		if (ret) {
+			ksft_test_result_fail("mprotect() failed\n");
+			goto munmap;
+		}
+		ret = mprotect(mem + pagesize, pagesize, PROT_READ | PROT_WRITE);
+		if (ret) {
+			ksft_test_result_fail("mprotect() failed\n");
+			goto munmap;
+		}
+		break;
+	case THP_RUN_SINGLE_PTE:
+	case THP_RUN_SINGLE_PTE_SWAPOUT:
+		/*
+		 * Discard all but a single subpage of that PTE-mapped THP. What
+		 * remains is a single PTE mapping a single subpage.
+		 */
+		ret = madvise(mem + pagesize, thpsize - pagesize, MADV_DONTNEED);
+		if (ret) {
+			ksft_test_result_fail("MADV_DONTNEED failed\n");
+			goto munmap;
+		}
+		size = pagesize;
+		break;
+	case THP_RUN_PARTIAL_MREMAP:
+		/*
+		 * Remap half of the THP. We need some new memory location
+		 * for that.
+		 */
+		mremap_size = thpsize / 2;
+		mremap_mem = mmap(NULL, mremap_size, PROT_NONE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+		if (mem == MAP_FAILED) {
+			ksft_test_result_fail("mmap() failed\n");
+			goto munmap;
+		}
+		tmp = mremap(mem + mremap_size, mremap_size, mremap_size,
+			     MREMAP_MAYMOVE | MREMAP_FIXED, mremap_mem);
+		if (tmp != mremap_mem) {
+			ksft_test_result_fail("mremap() failed\n");
+			goto munmap;
+		}
+		size = mremap_size;
+		break;
+	case THP_RUN_PARTIAL_SHARED:
+		/*
+		 * Share the first page of the THP with a child and quit the
+		 * child. This will result in some parts of the THP never
+		 * have been shared.
+		 */
+		ret = madvise(mem + pagesize, thpsize - pagesize, MADV_DONTFORK);
+		if (ret) {
+			ksft_test_result_fail("MADV_DONTFORK failed\n");
+			goto munmap;
+		}
+		ret = fork();
+		if (ret < 0) {
+			ksft_test_result_fail("fork() failed\n");
+			goto munmap;
+		} else if (!ret) {
+			exit(0);
+		}
+		wait(&ret);
+		/* Allow for sharing all pages again. */
+		ret = madvise(mem + pagesize, thpsize - pagesize, MADV_DOFORK);
+		if (ret) {
+			ksft_test_result_fail("MADV_DOFORK failed\n");
+			goto munmap;
+		}
+		break;
+	default:
+		assert(false);
+	}
+
+	switch (thp_run) {
+	case THP_RUN_PMD_SWAPOUT:
+	case THP_RUN_PTE_SWAPOUT:
+	case THP_RUN_SINGLE_PTE_SWAPOUT:
+		madvise(mem, size, MADV_PAGEOUT);
+		if (!range_is_swapped(mem, size)) {
+			ksft_test_result_skip("MADV_PAGEOUT did not work, is swap enabled?\n");
+			goto munmap;
+		}
+		break;
+	default:
+		break;
+	}
+
+	fn(mem, size);
+munmap:
+	munmap(mmap_mem, mmap_size);
+	if (mremap_mem != MAP_FAILED)
+		munmap(mremap_mem, mremap_size);
+}
+
+static void run_with_thp(test_fn fn, const char *desc)
+{
+	ksft_print_msg("[RUN] %s ... with THP\n", desc);
+	do_run_with_thp(fn, THP_RUN_PMD);
+}
+
+static void run_with_thp_swap(test_fn fn, const char *desc)
+{
+	ksft_print_msg("[RUN] %s ... with swapped-out THP\n", desc);
+	do_run_with_thp(fn, THP_RUN_PMD_SWAPOUT);
+}
+
+static void run_with_pte_mapped_thp(test_fn fn, const char *desc)
+{
+	ksft_print_msg("[RUN] %s ... with PTE-mapped THP\n", desc);
+	do_run_with_thp(fn, THP_RUN_PTE);
+}
+
+static void run_with_pte_mapped_thp_swap(test_fn fn, const char *desc)
+{
+	ksft_print_msg("[RUN] %s ... with swapped-out, PTE-mapped THP\n", desc);
+	do_run_with_thp(fn, THP_RUN_PTE_SWAPOUT);
+}
+
+static void run_with_single_pte_of_thp(test_fn fn, const char *desc)
+{
+	ksft_print_msg("[RUN] %s ... with single PTE of THP\n", desc);
+	do_run_with_thp(fn, THP_RUN_SINGLE_PTE);
+}
+
+static void run_with_single_pte_of_thp_swap(test_fn fn, const char *desc)
+{
+	ksft_print_msg("[RUN] %s ... with single PTE of swapped-out THP\n", desc);
+	do_run_with_thp(fn, THP_RUN_SINGLE_PTE_SWAPOUT);
+}
+
+static void run_with_partial_mremap_thp(test_fn fn, const char *desc)
+{
+	ksft_print_msg("[RUN] %s ... with partially mremap()'ed THP\n", desc);
+	do_run_with_thp(fn, THP_RUN_PARTIAL_MREMAP);
+}
+
+static void run_with_partial_shared_thp(test_fn fn, const char *desc)
+{
+	ksft_print_msg("[RUN] %s ... with partially shared THP\n", desc);
+	do_run_with_thp(fn, THP_RUN_PARTIAL_SHARED);
+}
+
 struct test_case {
 	const char *desc;
 	test_fn fn;
@@ -367,6 +604,16 @@ static void run_test_case(struct test_ca
 {
 	run_with_base_page(test_case->fn, test_case->desc);
 	run_with_base_page_swap(test_case->fn, test_case->desc);
+	if (thpsize) {
+		run_with_thp(test_case->fn, test_case->desc);
+		run_with_thp_swap(test_case->fn, test_case->desc);
+		run_with_pte_mapped_thp(test_case->fn, test_case->desc);
+		run_with_pte_mapped_thp_swap(test_case->fn, test_case->desc);
+		run_with_single_pte_of_thp(test_case->fn, test_case->desc);
+		run_with_single_pte_of_thp_swap(test_case->fn, test_case->desc);
+		run_with_partial_mremap_thp(test_case->fn, test_case->desc);
+		run_with_partial_shared_thp(test_case->fn, test_case->desc);
+	}
 }
 
 static void run_test_cases(void)
@@ -377,15 +624,25 @@ static void run_test_cases(void)
 		run_test_case(&test_cases[i]);
 }
 
+static int tests_per_test_case(void)
+{
+	int tests = 2;
+
+	if (thpsize)
+		tests += 8;
+	return tests;
+}
+
 int main(int argc, char **argv)
 {
 	int nr_test_cases = ARRAY_SIZE(test_cases);
 	int err;
 
 	pagesize = getpagesize();
+	detect_thpsize();
 
 	ksft_print_header();
-	ksft_set_plan(nr_test_cases * 2);
+	ksft_set_plan(nr_test_cases * tests_per_test_case());
 
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	if (pagemap_fd < 0)
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
mm-mprotect-minor-can_change_pte_writable-cleanups.patch
mm-huge_memory-try-avoiding-write-faults-when-changing-pmd-protection.patch
mm-mprotect-factor-out-check-whether-manual-pte-write-upgrades-are-required.patch
mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite.patch
mm-remove-unused-savedwrite-infrastructure.patch
selftests-vm-anon_cow-add-mprotect-optimization-tests.patch

