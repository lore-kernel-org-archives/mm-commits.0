Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C157FC4167D
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiJRBIx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbiJRBId (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:08:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302B37D1CE
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:08:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4A75B81BF3
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E36C433C1;
        Tue, 18 Oct 2022 01:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666055309;
        bh=So3ciBP0ysHq81jBQO/+CEYVQoMMX3hZuEOAaUbMZrw=;
        h=Date:To:From:Subject:From;
        b=j59TrvmUhqGQpjcLGbRpOHzH33X4Q6JjiWZdyJf0M4umCAESBZG1+kbE6tTvvYrRR
         mvDB7DpWg/E3qnrfN15MnPKfF3o01JVwwKryuD1Z8SveQvs0eN+kwSDY47vZl9i/FU
         Cd4uXe7cC/jBZHpGd8qRE4BFvvI+pF2TBj1o3Wsk=
Date:   Mon, 17 Oct 2022 18:08:28 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shuah@kernel.org,
        rppt@kernel.org, peterx@redhat.com, namit@vmware.com,
        jhubbard@nvidia.com, jgg@nvidia.com, ddutile@redhat.com,
        crecklin@redhat.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-anon_cow-hugetlb-tests.patch added to mm-unstable branch
Message-Id: <20221018010829.93E36C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: anon_cow: hugetlb tests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-anon_cow-hugetlb-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-anon_cow-hugetlb-tests.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: selftests/vm: anon_cow: hugetlb tests
Date: Tue, 27 Sep 2022 13:01:17 +0200

Let's run all existing test cases with all hugetlb sizes we're able to
detect.

Note that some tests cases still fail. This will, for example, be fixed
once vmsplice properly uses FOLL_PIN instead of FOLL_GET for pinning.
With 2 MiB and 1 GiB hugetlb on x86_64, the expected failures are:

 # [RUN] vmsplice() + unmap in child ... with hugetlb (2048 kB)
 not ok 23 No leak from parent into child
 # [RUN] vmsplice() + unmap in child ... with hugetlb (1048576 kB)
 not ok 24 No leak from parent into child
 # [RUN] vmsplice() before fork(), unmap in parent after fork() ... with hugetlb (2048 kB)
 not ok 35 No leak from child into parent
 # [RUN] vmsplice() before fork(), unmap in parent after fork() ... with hugetlb (1048576 kB)
 not ok 36 No leak from child into parent
 # [RUN] vmsplice() + unmap in parent after fork() ... with hugetlb (2048 kB)
 not ok 47 No leak from child into parent
 # [RUN] vmsplice() + unmap in parent after fork() ... with hugetlb (1048576 kB)
 not ok 48 No leak from child into parent

Link: https://lkml.kernel.org/r/20220927110120.106906-5-david@redhat.com
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

 tools/testing/selftests/vm/anon_cow.c |   70 +++++++++++++++++++++++-
 1 file changed, 69 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/anon_cow.c~selftests-vm-anon_cow-hugetlb-tests
+++ a/tools/testing/selftests/vm/anon_cow.c
@@ -25,6 +25,8 @@
 static size_t pagesize;
 static int pagemap_fd;
 static size_t thpsize;
+static int nr_hugetlbsizes;
+static size_t hugetlbsizes[10];
 
 static void detect_thpsize(void)
 {
@@ -54,6 +56,31 @@ static void detect_thpsize(void)
 	close(fd);
 }
 
+static void detect_hugetlbsizes(void)
+{
+	DIR *dir = opendir("/sys/kernel/mm/hugepages/");
+
+	if (!dir)
+		return;
+
+	while (nr_hugetlbsizes < ARRAY_SIZE(hugetlbsizes)) {
+		struct dirent *entry = readdir(dir);
+		size_t kb;
+
+		if (!entry)
+			break;
+		if (entry->d_type != DT_DIR)
+			continue;
+		if (sscanf(entry->d_name, "hugepages-%zukB", &kb) != 1)
+			continue;
+		hugetlbsizes[nr_hugetlbsizes] = kb * 1024;
+		nr_hugetlbsizes++;
+		ksft_print_msg("[INFO] detected hugetlb size: %zu KiB\n",
+			       kb);
+	}
+	closedir(dir);
+}
+
 static bool range_is_swapped(void *addr, size_t size)
 {
 	for (; size; addr += pagesize, size -= pagesize)
@@ -556,6 +583,41 @@ static void run_with_partial_shared_thp(
 	do_run_with_thp(fn, THP_RUN_PARTIAL_SHARED);
 }
 
+static void run_with_hugetlb(test_fn fn, const char *desc, size_t hugetlbsize)
+{
+	int flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
+	char *mem, *dummy;
+
+	ksft_print_msg("[RUN] %s ... with hugetlb (%zu kB)\n", desc,
+		       hugetlbsize / 1024);
+
+	flags |= __builtin_ctzll(hugetlbsize) << MAP_HUGE_SHIFT;
+
+	mem = mmap(NULL, hugetlbsize, PROT_READ | PROT_WRITE, flags, -1, 0);
+	if (mem == MAP_FAILED) {
+		ksft_test_result_skip("need more free huge pages\n");
+		return;
+	}
+
+	/* Populate an huge page. */
+	memset(mem, 0, hugetlbsize);
+
+	/*
+	 * We need a total of two hugetlb pages to handle COW/unsharing
+	 * properly, otherwise we might get zapped by a SIGBUS.
+	 */
+	dummy = mmap(NULL, hugetlbsize, PROT_READ | PROT_WRITE, flags, -1, 0);
+	if (dummy == MAP_FAILED) {
+		ksft_test_result_skip("need more free huge pages\n");
+		goto munmap;
+	}
+	munmap(dummy, hugetlbsize);
+
+	fn(mem, hugetlbsize);
+munmap:
+	munmap(mem, hugetlbsize);
+}
+
 struct test_case {
 	const char *desc;
 	test_fn fn;
@@ -602,6 +664,8 @@ static const struct test_case test_cases
 
 static void run_test_case(struct test_case const *test_case)
 {
+	int i;
+
 	run_with_base_page(test_case->fn, test_case->desc);
 	run_with_base_page_swap(test_case->fn, test_case->desc);
 	if (thpsize) {
@@ -614,6 +678,9 @@ static void run_test_case(struct test_ca
 		run_with_partial_mremap_thp(test_case->fn, test_case->desc);
 		run_with_partial_shared_thp(test_case->fn, test_case->desc);
 	}
+	for (i = 0; i < nr_hugetlbsizes; i++)
+		run_with_hugetlb(test_case->fn, test_case->desc,
+				 hugetlbsizes[i]);
 }
 
 static void run_test_cases(void)
@@ -626,7 +693,7 @@ static void run_test_cases(void)
 
 static int tests_per_test_case(void)
 {
-	int tests = 2;
+	int tests = 2 + nr_hugetlbsizes;
 
 	if (thpsize)
 		tests += 8;
@@ -640,6 +707,7 @@ int main(int argc, char **argv)
 
 	pagesize = getpagesize();
 	detect_thpsize();
+	detect_hugetlbsizes();
 
 	ksft_print_header();
 	ksft_set_plan(nr_test_cases * tests_per_test_case());
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory.patch
selftests-vm-factor-out-pagemap_is_populated-into-vm_util.patch
selftests-vm-anon_cow-thp-tests.patch
selftests-vm-anon_cow-hugetlb-tests.patch
selftests-vm-anon_cow-add-liburing-test-cases.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch
selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch

