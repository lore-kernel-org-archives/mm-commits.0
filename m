Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25319C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 122EB60EE3
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349516AbhICVCm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:02:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:32998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349675AbhICVCk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:02:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92639610E7;
        Fri,  3 Sep 2021 21:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702899;
        bh=qKFiarGhqRxw0stzSBuqO+29wJJ0k6L593vkDVD97jw=;
        h=Date:From:To:Subject:From;
        b=Ie8JFvi4hZd7ICGFKijDk6Q8r6P7TDysNSX8j9AIi+gHP+2fe+xmK/r4v2YUu+8MC
         DWtRxgMIUyeC2XOcF1eOm4K09xImKhRCOAR2UbcWc2Ec7fh6KgF1eIne2kruI01P/0
         ckHAP14yZEojYJul2fbSedB1uWZwkIQiiYhcr0jU=
Date:   Fri, 03 Sep 2021 14:01:39 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        tyhicks@linux.microsoft.com, zhansayabagdaulet@gmail.com
Subject:  [merged]
 selftests-vm-add-cow-time-test-for-ksm-pages.patch removed from -mm tree
Message-ID: <20210903210139.UxUzCrX__%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: add COW time test for KSM pages
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-cow-time-test-for-ksm-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhansaya Bagdauletkyzy <zhansayabagdaulet@gmail.com>
Subject: selftests: vm: add COW time test for KSM pages

Since merged pages are copied every time they need to be modified, the
write access time is different between shared and non-shared pages.  Add
ksm_cow_time() function which evaluates latency of these COW breaks. 
First, 4000 pages are allocated and the time, required to modify 1 byte in
every other page, is measured.  After this, the pages are merged into 2000
pairs and in each pair, 1 page is modified (i.e.  they are decoupled) to
detect COW breaks.  The time needed to break COW of merged pages is then
compared with performance of non-shared pages.

The test is run as follows: ./ksm_tests -C
The output:
	Total size:    15 MiB

	Not merged pages:
	Total time:     0.002185489 s
	Average speed:  3202.945 MiB/s

	Merged pages:
	Total time:     0.004386872 s
	Average speed:  1595.670 MiB/s

Link: https://lkml.kernel.org/r/1d03ee0d1b341959d4b61672c6401d498bff5652.1629386192.git.zhansayabagdaulet@gmail.com
Signed-off-by: Zhansaya Bagdauletkyzy <zhansayabagdaulet@gmail.com>
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/ksm_tests.c |   86 ++++++++++++++++++++++-
 1 file changed, 83 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/vm/ksm_tests.c~selftests-vm-add-cow-time-test-for-ksm-pages
+++ a/tools/testing/selftests/vm/ksm_tests.c
@@ -33,7 +33,8 @@ enum ksm_test_name {
 	CHECK_KSM_UNMERGE,
 	CHECK_KSM_ZERO_PAGE_MERGE,
 	CHECK_KSM_NUMA_MERGE,
-	KSM_MERGE_TIME
+	KSM_MERGE_TIME,
+	KSM_COW_TIME
 };
 
 static int ksm_write_sysfs(const char *file_path, unsigned long val)
@@ -98,7 +99,8 @@ static void print_help(void)
 	       " -U (page unmerging)\n"
 	       " -P evaluate merging time and speed.\n"
 	       "    For this test, the size of duplicated memory area (in MiB)\n"
-	       "    must be provided using -s option\n\n");
+	       "    must be provided using -s option\n"
+	       " -C evaluate the time required to break COW of merged pages.\n\n");
 
 	printf(" -a: specify the access protections of pages.\n"
 	       "     <prot> must be of the form [rwx].\n"
@@ -455,6 +457,77 @@ err_out:
 	return KSFT_FAIL;
 }
 
+static int ksm_cow_time(int mapping, int prot, int timeout, size_t page_size)
+{
+	void *map_ptr;
+	struct timespec start_time, end_time;
+	unsigned long cow_time_ns;
+
+	/* page_count must be less than 2*page_size */
+	size_t page_count = 4000;
+
+	map_ptr = allocate_memory(NULL, prot, mapping, '*', page_size * page_count);
+	if (!map_ptr)
+		return KSFT_FAIL;
+
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
+		perror("clock_gettime");
+		return KSFT_FAIL;
+	}
+	for (size_t i = 0; i < page_count - 1; i = i + 2)
+		memset(map_ptr + page_size * i, '-', 1);
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
+		perror("clock_gettime");
+		return KSFT_FAIL;
+	}
+
+	cow_time_ns = (end_time.tv_sec - start_time.tv_sec) * NSEC_PER_SEC +
+		       (end_time.tv_nsec - start_time.tv_nsec);
+
+	printf("Total size:    %lu MiB\n\n", (page_size * page_count) / MB);
+	printf("Not merged pages:\n");
+	printf("Total time:     %ld.%09ld s\n", cow_time_ns / NSEC_PER_SEC,
+	       cow_time_ns % NSEC_PER_SEC);
+	printf("Average speed:  %.3f MiB/s\n\n", ((page_size * (page_count / 2)) / MB) /
+					       ((double)cow_time_ns / NSEC_PER_SEC));
+
+	/* Create 2000 pairs of duplicate pages */
+	for (size_t i = 0; i < page_count - 1; i = i + 2) {
+		memset(map_ptr + page_size * i, '+', i / 2 + 1);
+		memset(map_ptr + page_size * (i + 1), '+', i / 2 + 1);
+	}
+	if (ksm_merge_pages(map_ptr, page_size * page_count, start_time, timeout))
+		goto err_out;
+
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
+		perror("clock_gettime");
+		goto err_out;
+	}
+	for (size_t i = 0; i < page_count - 1; i = i + 2)
+		memset(map_ptr + page_size * i, '-', 1);
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
+		perror("clock_gettime");
+		goto err_out;
+	}
+
+	cow_time_ns = (end_time.tv_sec - start_time.tv_sec) * NSEC_PER_SEC +
+		       (end_time.tv_nsec - start_time.tv_nsec);
+
+	printf("Merged pages:\n");
+	printf("Total time:     %ld.%09ld s\n", cow_time_ns / NSEC_PER_SEC,
+	       cow_time_ns % NSEC_PER_SEC);
+	printf("Average speed:  %.3f MiB/s\n", ((page_size * (page_count / 2)) / MB) /
+					       ((double)cow_time_ns / NSEC_PER_SEC));
+
+	munmap(map_ptr, page_size * page_count);
+	return KSFT_PASS;
+
+err_out:
+	printf("Not OK\n");
+	munmap(map_ptr, page_size * page_count);
+	return KSFT_FAIL;
+}
+
 int main(int argc, char *argv[])
 {
 	int ret, opt;
@@ -468,7 +541,7 @@ int main(int argc, char *argv[])
 	bool merge_across_nodes = KSM_MERGE_ACROSS_NODES_DEFAULT;
 	long size_MB = 0;
 
-	while ((opt = getopt(argc, argv, "ha:p:l:z:m:s:MUZNP")) != -1) {
+	while ((opt = getopt(argc, argv, "ha:p:l:z:m:s:MUZNPC")) != -1) {
 		switch (opt) {
 		case 'a':
 			prot = str_to_prot(optarg);
@@ -522,6 +595,9 @@ int main(int argc, char *argv[])
 		case 'P':
 			test_name = KSM_MERGE_TIME;
 			break;
+		case 'C':
+			test_name = KSM_COW_TIME;
+			break;
 		default:
 			return KSFT_FAIL;
 		}
@@ -571,6 +647,10 @@ int main(int argc, char *argv[])
 		ret = ksm_merge_time(MAP_PRIVATE | MAP_ANONYMOUS, prot, ksm_scan_limit_sec,
 				     size_MB);
 		break;
+	case KSM_COW_TIME:
+		ret = ksm_cow_time(MAP_PRIVATE | MAP_ANONYMOUS, prot, ksm_scan_limit_sec,
+				   page_size);
+		break;
 	}
 
 	if (ksm_restore(&ksm_sysfs_old)) {
_

Patches currently in -mm which might be from zhansayabagdaulet@gmail.com are


