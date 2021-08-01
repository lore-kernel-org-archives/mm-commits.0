Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABAC3C4338F
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 19:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FD9C61078
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 19:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhHAT3B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Aug 2021 15:29:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230082AbhHAT3A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Aug 2021 15:29:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94AE960EE9;
        Sun,  1 Aug 2021 19:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627846131;
        bh=16EKj+2sXuwVoH7r9fdWUA3lEpszilmvUt0+Dq9cU28=;
        h=Date:From:To:Subject:From;
        b=mneNCdUFkNJO6L30eaVjqYSbGz+OZTUh9JYgFdHHsxY8/lM2pCGKTW8WfCcm/DtJY
         fPD6zyoi9SJHfa7hQrSx8OgiQg8iNKqljzrcmFc3+l3AnXL41S/a6R4hN1jvATzBS5
         ILuQD+U1y1D1xwlOiFKmDWXsPs2iQNdPogGxkBBk=
Date:   Sun, 01 Aug 2021 12:28:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tyhicks@linux.microsoft.com,
        shuah@kernel.org, pasha.tatashin@soleen.com, hughd@google.com,
        zhansayabagdaulet@gmail.com
Subject:  + selftests-vm-add-cow-time-test-for-ksm-pages.patch added
 to -mm tree
Message-ID: <20210801192851.pa2C2%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: add COW time test for KSM pages
has been added to the -mm tree.  Its filename is
     selftests-vm-add-cow-time-test-for-ksm-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-add-cow-time-test-for-ksm-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-add-cow-time-test-for-ksm-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhansaya Bagdauletkyzy <zhansayabagdaulet@gmail.com>
Subject: selftests: vm: add COW time test for KSM pages

Since merged pages are copied every time they need to be modified,
the write access time is different between shared and non-shared pages.
Add ksm_cow_time() function which evaluates latency of these COW
breaks. First, duplicated pages are merged and then the time required
to write to each of the pages is detected.

The test is run as follows: ./ksm_tests -C -p 5000
The output:
	Total COW time:      0.012612 s
	The number of pages: 5000
	Average speed:	     1623 MB/s

Link: https://lkml.kernel.org/r/26a3cc3d02dc4fa65cc9b135be76e7d795c44877.1627828548.git.zhansayabagdaulet@gmail.com
Signed-off-by: Zhansaya Bagdauletkyzy <zhansayabagdaulet@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/ksm_tests.c |   66 +++++++++++++++++++++--
 1 file changed, 63 insertions(+), 3 deletions(-)

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
@@ -98,7 +99,9 @@ static void print_help(void)
 	       " -U (page unmerging)\n"
 	       " -P evaluate merging time and speed.\n"
 	       "    For this test, the size of duplicated memory area (in MB)\n"
-	       "    must be provided using -s option\n\n");
+	       "    must be provided using -s option\n"
+	       " -C evaluate the time required to break COW of merged pages.\n"
+	       "    The number of pages can be defined using -p option.\n\n");
 
 	printf(" -a: specify the access protections of pages.\n"
 	       "     <prot> must be of the form [rwx].\n"
@@ -457,6 +460,56 @@ err_out:
 	return KSFT_FAIL;
 }
 
+static int ksm_cow_time(int mapping, int prot, int timeout, size_t page_size, long page_count)
+{
+	void *map_ptr;
+	struct timespec start_time, end_time;
+	long cow_time_s, cow_time_ns;
+	int avg_speed;
+
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
+		perror("clock_gettime");
+		return KSFT_FAIL;
+	}
+
+	map_ptr = allocate_memory(NULL, prot, mapping, '*', page_size * page_count);
+	if (!map_ptr)
+		return KSFT_FAIL;
+
+	if (ksm_merge_pages(map_ptr, page_size * page_count, start_time, timeout))
+		goto err_out;
+
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
+		perror("clock_gettime");
+		goto err_out;
+	}
+	for (size_t i = 0; i < page_count; i++)
+		memset(map_ptr + page_size * i, '-', 1);
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
+		perror("clock_gettime");
+		goto err_out;
+	}
+
+	cow_time_ns = (end_time.tv_sec - start_time.tv_sec) * NSEC_PER_SEC +
+		       (end_time.tv_nsec - start_time.tv_nsec);
+	cow_time_s = cow_time_ns / NSEC_PER_SEC;
+	cow_time_ns %= NSEC_PER_SEC;
+	avg_speed = (page_size * page_count) / (cow_time_s * USEC_PER_SEC +
+						cow_time_ns / NSEC_PER_USEC);
+
+	printf("Total COW time:      %ld.%06ld s\n", cow_time_s, cow_time_ns / NSEC_PER_USEC);
+	printf("The number of pages: %ld\n", page_count);
+	printf("Average speed:	     %d MB/s\n", avg_speed);
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
@@ -470,7 +523,7 @@ int main(int argc, char *argv[])
 	bool merge_across_nodes = KSM_MERGE_ACROSS_NODES_DEFAULT;
 	long size_MB = 0;
 
-	while ((opt = getopt(argc, argv, "ha:p:l:z:m:s:MUZNP")) != -1) {
+	while ((opt = getopt(argc, argv, "ha:p:l:z:m:s:MUZNPC")) != -1) {
 		switch (opt) {
 		case 'a':
 			prot = str_to_prot(optarg);
@@ -524,6 +577,9 @@ int main(int argc, char *argv[])
 		case 'P':
 			test_name = KSM_MERGE_TIME;
 			break;
+		case 'C':
+			test_name = KSM_COW_TIME;
+			break;
 		default:
 			return KSFT_FAIL;
 		}
@@ -573,6 +629,10 @@ int main(int argc, char *argv[])
 		ret = ksm_merge_time(MAP_PRIVATE | MAP_ANONYMOUS, prot, ksm_scan_limit_sec,
 				     size_MB);
 		break;
+	case KSM_COW_TIME:
+		ret = ksm_cow_time(MAP_PRIVATE | MAP_ANONYMOUS, prot, ksm_scan_limit_sec,
+				   page_size, page_count);
+		break;
 	}
 
 	if (ksm_restore(&ksm_sysfs_old)) {
_

Patches currently in -mm which might be from zhansayabagdaulet@gmail.com are

selftests-vm-add-ksm-merge-test.patch
selftests-vm-add-ksm-unmerge-test.patch
selftests-vm-add-ksm-zero-page-merging-test.patch
selftests-vm-add-ksm-merging-across-nodes-test.patch
selftests-vm-add-ksm-merging-time-test.patch
selftests-vm-add-cow-time-test-for-ksm-pages.patch

