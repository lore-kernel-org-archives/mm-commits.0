Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0176AC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0E55610E6
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347975AbhIBWB5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:01:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347666AbhIBWB4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:01:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B63DF60F42;
        Thu,  2 Sep 2021 22:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630620058;
        bh=6GYPhrCvagMtHK9OSO2oPdLkx2rOCFdLK3/VJxTiN+o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eGVxa1J/eUbckIPZGFT2x7n1mk8w0VcZsNsL/7qFMDHbQwGbhDOTjXvzrimkKkBNq
         R7HBU51AQaYNaIRlNOccOItO592/qL+h0HFHwpdTaxYggidm3vyH0+kyxWqIIa2U2B
         vBn1r1DLUB2XPm2qJVUne8pcMZ9XIEDRAuqxFhMw=
Date:   Thu, 02 Sep 2021 15:00:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        torvalds@linux-foundation.org, tyhicks@linux.microsoft.com,
        zhansayabagdaulet@gmail.com
Subject:  [patch 207/212] selftests: vm: add COW time test for KSM
 pages
Message-ID: <20210902220057.Vt016qtZu%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
