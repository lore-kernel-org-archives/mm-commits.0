Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CCDFC4320A
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 19:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3375361050
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 19:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhHAT25 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Aug 2021 15:28:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230082AbhHAT25 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Aug 2021 15:28:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7D6460234;
        Sun,  1 Aug 2021 19:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627846129;
        bh=B29plXByZzBXJrNpQ+sWz193m+43pA+NfFTAtZ+lGmk=;
        h=Date:From:To:Subject:From;
        b=cvdl1NUWRVf9bNqXYo+c4JdneIHYLG917XxikRcuTfhJ6K6AKdC7YhlJbUQytYn3/
         rOWxZ/hQHRhIZ0JGs3/wCjDd5aYKGZB4m8LQf2gLy1MjyGJC1ibwsc3Hg2tfhE+YtX
         3kS1SxvsKWWtepud6EvmYLpQla3TYbjO7lmhPqRw=
Date:   Sun, 01 Aug 2021 12:28:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tyhicks@linux.microsoft.com,
        shuah@kernel.org, pasha.tatashin@soleen.com, hughd@google.com,
        zhansayabagdaulet@gmail.com
Subject:  + selftests-vm-add-ksm-merging-time-test.patch added to -mm
 tree
Message-ID: <20210801192848.LfxLG%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: add KSM merging time test
has been added to the -mm tree.  Its filename is
     selftests-vm-add-ksm-merging-time-test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-add-ksm-merging-time-test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-add-ksm-merging-time-test.patch

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
Subject: selftests: vm: add KSM merging time test

Patch series "add KSM performance tests".

Extend KSM self tests with a performance benchmark. These tests are not
part of regular regression testing, as they are mainly intended to be
used by developers making changes to the memory management subsystem. 


This patch (of 2):

Add ksm_merge_time() function to determine speed and time needed for
merging.  The total spent time is shown in seconds while speed is in MB/s.
User must specify the size of duplicated memory area (in MB) before
running the test.

The test is run as follows: ./ksm_tests -P -s 100
The output:
        Total size:    100 MB
        Total time:    0.309561 s
        Average speed: 323 MB/s

Link: https://lkml.kernel.org/r/cover.1627828548.git.zhansayabagdaulet@gmail.com
Link: https://lkml.kernel.org/r/5de9beffc409b660229695e0ad921825903156d6.1627828548.git.zhansayabagdaulet@gmail.com
Signed-off-by: Zhansaya Bagdauletkyzy <zhansayabagdaulet@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/ksm_tests.c |   76 +++++++++++++++++++++--
 1 file changed, 72 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/vm/ksm_tests.c~selftests-vm-add-ksm-merging-time-test
+++ a/tools/testing/selftests/vm/ksm_tests.c
@@ -7,6 +7,7 @@
 #include <numa.h>
 
 #include "../kselftest.h"
+#include "../../../../include/vdso/time64.h"
 
 #define KSM_SYSFS_PATH "/sys/kernel/mm/ksm/"
 #define KSM_FP(s) (KSM_SYSFS_PATH s)
@@ -15,6 +16,7 @@
 #define KSM_PROT_STR_DEFAULT "rw"
 #define KSM_USE_ZERO_PAGES_DEFAULT false
 #define KSM_MERGE_ACROSS_NODES_DEFAULT true
+#define MB_TO_B 1000000ul
 
 struct ksm_sysfs {
 	unsigned long max_page_sharing;
@@ -30,7 +32,8 @@ enum ksm_test_name {
 	CHECK_KSM_MERGE,
 	CHECK_KSM_UNMERGE,
 	CHECK_KSM_ZERO_PAGE_MERGE,
-	CHECK_KSM_NUMA_MERGE
+	CHECK_KSM_NUMA_MERGE,
+	KSM_MERGE_TIME
 };
 
 static int ksm_write_sysfs(const char *file_path, unsigned long val)
@@ -86,13 +89,16 @@ static int str_to_prot(char *prot_str)
 static void print_help(void)
 {
 	printf("usage: ksm_tests [-h] <test type> [-a prot] [-p page_count] [-l timeout]\n"
-	       "[-z use_zero_pages] [-m merge_across_nodes]\n");
+	       "[-z use_zero_pages] [-m merge_across_nodes] [-s size]\n");
 
 	printf("Supported <test type>:\n"
 	       " -M (page merging)\n"
 	       " -Z (zero pages merging)\n"
 	       " -N (merging of pages in different NUMA nodes)\n"
-	       " -U (page unmerging)\n\n");
+	       " -U (page unmerging)\n"
+	       " -P evaluate merging time and speed.\n"
+	       "    For this test, the size of duplicated memory area (in MB)\n"
+	       "    must be provided using -s option\n\n");
 
 	printf(" -a: specify the access protections of pages.\n"
 	       "     <prot> must be of the form [rwx].\n"
@@ -105,6 +111,7 @@ static void print_help(void)
 	       "     Default: %d\n", KSM_USE_ZERO_PAGES_DEFAULT);
 	printf(" -m: change merge_across_nodes tunable\n"
 	       "     Default: %d\n", KSM_MERGE_ACROSS_NODES_DEFAULT);
+	printf(" -s: the size of duplicated memory area (in MB)\n");
 
 	exit(0);
 }
@@ -407,6 +414,49 @@ err_out:
 	return KSFT_FAIL;
 }
 
+static int ksm_merge_time(int mapping, int prot, int timeout, size_t map_size)
+{
+	void *map_ptr;
+	struct timespec start_time, end_time;
+	long scan_time_s, scan_time_ns;
+	int avg_speed;
+
+	map_size *= MB_TO_B;
+
+	map_ptr = allocate_memory(NULL, prot, mapping, '*', map_size);
+	if (!map_ptr)
+		return KSFT_FAIL;
+
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
+		perror("clock_gettime");
+		goto err_out;
+	}
+	if (ksm_merge_pages(map_ptr, map_size, start_time, timeout))
+		goto err_out;
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
+		perror("clock_gettime");
+		goto err_out;
+	}
+
+	scan_time_ns = (end_time.tv_sec - start_time.tv_sec) * NSEC_PER_SEC +
+		       (end_time.tv_nsec - start_time.tv_nsec);
+	scan_time_s = scan_time_ns / NSEC_PER_SEC;
+	scan_time_ns %= NSEC_PER_SEC;
+	avg_speed = map_size / (scan_time_s * USEC_PER_SEC + scan_time_ns / NSEC_PER_USEC);
+
+	printf("Total size:    %lu MB\n", map_size / MB_TO_B);
+	printf("Total time:    %ld.%06ld s\n", scan_time_s, scan_time_ns / NSEC_PER_USEC);
+	printf("Average speed: %d MB/s\n", avg_speed);
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
 int main(int argc, char *argv[])
 {
 	int ret, opt;
@@ -418,8 +468,9 @@ int main(int argc, char *argv[])
 	int test_name = CHECK_KSM_MERGE;
 	bool use_zero_pages = KSM_USE_ZERO_PAGES_DEFAULT;
 	bool merge_across_nodes = KSM_MERGE_ACROSS_NODES_DEFAULT;
+	long size_MB = 0;
 
-	while ((opt = getopt(argc, argv, "ha:p:l:z:m:MUZN")) != -1) {
+	while ((opt = getopt(argc, argv, "ha:p:l:z:m:s:MUZNP")) != -1) {
 		switch (opt) {
 		case 'a':
 			prot = str_to_prot(optarg);
@@ -453,6 +504,12 @@ int main(int argc, char *argv[])
 			else
 				merge_across_nodes = 1;
 			break;
+		case 's':
+			size_MB = atoi(optarg);
+			if (size_MB <= 0) {
+				printf("Size must be greater than 0\n");
+				return KSFT_FAIL;
+			}
 		case 'M':
 			break;
 		case 'U':
@@ -464,6 +521,9 @@ int main(int argc, char *argv[])
 		case 'N':
 			test_name = CHECK_KSM_NUMA_MERGE;
 			break;
+		case 'P':
+			test_name = KSM_MERGE_TIME;
+			break;
 		default:
 			return KSFT_FAIL;
 		}
@@ -505,6 +565,14 @@ int main(int argc, char *argv[])
 		ret = check_ksm_numa_merge(MAP_PRIVATE | MAP_ANONYMOUS, prot, ksm_scan_limit_sec,
 					   merge_across_nodes, page_size);
 		break;
+	case KSM_MERGE_TIME:
+		if (size_MB == 0) {
+			printf("Option '-s' is required.\n");
+			return KSFT_FAIL;
+		}
+		ret = ksm_merge_time(MAP_PRIVATE | MAP_ANONYMOUS, prot, ksm_scan_limit_sec,
+				     size_MB);
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

