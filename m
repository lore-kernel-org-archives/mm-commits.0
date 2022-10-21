Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB22C38A2D
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 20:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiJUUCO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 16:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiJUUCA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 16:02:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019532623E3
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 13:01:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD67EB82D21
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 20:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82054C433C1;
        Fri, 21 Oct 2022 20:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666382504;
        bh=ntlony0uby0DhQv2ECFgbqQsJgdDaTDIwo+3+3YS474=;
        h=Date:To:From:Subject:From;
        b=fSENv1HKtCj4WIq613fvX6zsdNdDzPkJUvkPbwp/oTg81Iy02p+9pj+fr2xIHc5xO
         yuzFm8eGqIVxcUCGL0Z+/K7XiqU6Lr7onWkr3jvQfFfHP+TNpLhLD3V08SJCayEL8Z
         FXMJmuR1JxbCNk+CXAz/zp6ugAQqV/yP6lmFcSh4=
Date:   Fri, 21 Oct 2022 13:01:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shuah@kernel.org, peterx@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, hughd@google.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch added to mm-unstable branch
Message-Id: <20221021200144.82054C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: add test to measure MADV_UNMERGEABLE performance
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch

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
Subject: selftests/vm: add test to measure MADV_UNMERGEABLE performance
Date: Fri, 21 Oct 2022 12:11:33 +0200

Let's add a test to measure performance of KSM breaking not triggered via
COW, but triggered by disabling KSM on an area filled with KSM pages via
MADV_UNMERGEABLE.

Link: https://lkml.kernel.org/r/20221021101141.84170-2-david@redhat.com
Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/ksm_tests.c |   76 ++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/ksm_tests.c~selftests-vm-add-test-to-measure-madv_unmergeable-performance
+++ a/tools/testing/selftests/vm/ksm_tests.c
@@ -40,6 +40,7 @@ enum ksm_test_name {
 	CHECK_KSM_NUMA_MERGE,
 	KSM_MERGE_TIME,
 	KSM_MERGE_TIME_HUGE_PAGES,
+	KSM_UNMERGE_TIME,
 	KSM_COW_TIME
 };
 
@@ -108,7 +109,10 @@ static void print_help(void)
 	       " -P evaluate merging time and speed.\n"
 	       "    For this test, the size of duplicated memory area (in MiB)\n"
 	       "    must be provided using -s option\n"
-				 " -H evaluate merging time and speed of area allocated mostly with huge pages\n"
+	       " -H evaluate merging time and speed of area allocated mostly with huge pages\n"
+	       "    For this test, the size of duplicated memory area (in MiB)\n"
+	       "    must be provided using -s option\n"
+	       " -D evaluate unmerging time and speed when disabling KSM.\n"
 	       "    For this test, the size of duplicated memory area (in MiB)\n"
 	       "    must be provided using -s option\n"
 	       " -C evaluate the time required to break COW of merged pages.\n\n");
@@ -188,6 +192,16 @@ static int ksm_merge_pages(void *addr, s
 	return 0;
 }
 
+static int ksm_unmerge_pages(void *addr, size_t size,
+			     struct timespec start_time, int timeout)
+{
+	if (madvise(addr, size, MADV_UNMERGEABLE)) {
+		perror("madvise");
+		return 1;
+	}
+	return 0;
+}
+
 static bool assert_ksm_pages_count(long dupl_page_count)
 {
 	unsigned long max_page_sharing, pages_sharing, pages_shared;
@@ -560,6 +574,53 @@ err_out:
 	return KSFT_FAIL;
 }
 
+static int ksm_unmerge_time(int mapping, int prot, int timeout, size_t map_size)
+{
+	void *map_ptr;
+	struct timespec start_time, end_time;
+	unsigned long scan_time_ns;
+
+	map_size *= MB;
+
+	map_ptr = allocate_memory(NULL, prot, mapping, '*', map_size);
+	if (!map_ptr)
+		return KSFT_FAIL;
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
+		perror("clock_gettime");
+		goto err_out;
+	}
+	if (ksm_merge_pages(map_ptr, map_size, start_time, timeout))
+		goto err_out;
+
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
+		perror("clock_gettime");
+		goto err_out;
+	}
+	if (ksm_unmerge_pages(map_ptr, map_size, start_time, timeout))
+		goto err_out;
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
+		perror("clock_gettime");
+		goto err_out;
+	}
+
+	scan_time_ns = (end_time.tv_sec - start_time.tv_sec) * NSEC_PER_SEC +
+		       (end_time.tv_nsec - start_time.tv_nsec);
+
+	printf("Total size:    %lu MiB\n", map_size / MB);
+	printf("Total time:    %ld.%09ld s\n", scan_time_ns / NSEC_PER_SEC,
+	       scan_time_ns % NSEC_PER_SEC);
+	printf("Average speed:  %.3f MiB/s\n", (map_size / MB) /
+					       ((double)scan_time_ns / NSEC_PER_SEC));
+
+	munmap(map_ptr, map_size);
+	return KSFT_PASS;
+
+err_out:
+	printf("Not OK\n");
+	munmap(map_ptr, map_size);
+	return KSFT_FAIL;
+}
+
 static int ksm_cow_time(int mapping, int prot, int timeout, size_t page_size)
 {
 	void *map_ptr;
@@ -644,7 +705,7 @@ int main(int argc, char *argv[])
 	bool merge_across_nodes = KSM_MERGE_ACROSS_NODES_DEFAULT;
 	long size_MB = 0;
 
-	while ((opt = getopt(argc, argv, "ha:p:l:z:m:s:MUZNPCH")) != -1) {
+	while ((opt = getopt(argc, argv, "ha:p:l:z:m:s:MUZNPCHD")) != -1) {
 		switch (opt) {
 		case 'a':
 			prot = str_to_prot(optarg);
@@ -701,6 +762,9 @@ int main(int argc, char *argv[])
 		case 'H':
 			test_name = KSM_MERGE_TIME_HUGE_PAGES;
 			break;
+		case 'D':
+			test_name = KSM_UNMERGE_TIME;
+			break;
 		case 'C':
 			test_name = KSM_COW_TIME;
 			break;
@@ -762,6 +826,14 @@ int main(int argc, char *argv[])
 		ret = ksm_merge_hugepages_time(MAP_PRIVATE | MAP_ANONYMOUS, prot,
 				ksm_scan_limit_sec, size_MB);
 		break;
+	case KSM_UNMERGE_TIME:
+		if (size_MB == 0) {
+			printf("Option '-s' is required.\n");
+			return KSFT_FAIL;
+		}
+		ret = ksm_unmerge_time(MAP_PRIVATE | MAP_ANONYMOUS, prot,
+				       ksm_scan_limit_sec, size_MB);
+		break;
 	case KSM_COW_TIME:
 		ret = ksm_cow_time(MAP_PRIVATE | MAP_ANONYMOUS, prot, ksm_scan_limit_sec,
 				   page_size);
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory.patch
selftests-vm-factor-out-pagemap_is_populated-into-vm_util.patch
selftests-vm-anon_cow-thp-tests.patch
selftests-vm-anon_cow-hugetlb-tests.patch
selftests-vm-anon_cow-add-liburing-test-cases.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix.patch
selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch
selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch

