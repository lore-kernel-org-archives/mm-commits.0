Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77671C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 601A3610E7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242776AbhICVCb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:02:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:32850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350491AbhICVC3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:02:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 731C560EE3;
        Fri,  3 Sep 2021 21:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702888;
        bh=cMmWZoD58QpC4pCFRC6qPPXtIj2+rPlhaVY11TRkBAM=;
        h=Date:From:To:Subject:From;
        b=S3bFpfp+aDWM9kLETYa3Ogb7c6IwZBkBliB4u5N4ajiTjxbcqjr792ibCq3P0+aWy
         cRrjIeVcJYGrBrBL+RVGadkVytOHPnNy1x1muzQ2FcxHRJLeiJk4KDqyGI8Jq49nqy
         P4qyxapyH6JuzRZTsB+uDA9AKiEsLh9t7pYDYLN8=
Date:   Fri, 03 Sep 2021 14:01:28 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com, shuah@kernel.org,
        tyhicks@linux.microsoft.com, zhansayabagdaulet@gmail.com
Subject:  [merged] selftests-vm-add-ksm-merge-test.patch removed
 from -mm tree
Message-ID: <20210903210128.MWJ7hYI-S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: add KSM merge test
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-ksm-merge-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhansaya Bagdauletkyzy <zhansayabagdaulet@gmail.com>
Subject: selftests: vm: add KSM merge test

Patch series "add KSM selftests".

Introduce selftests to validate the functionality of KSM.  The tests are
run on private anonymous pages.  Since some KSM tunables are modified,
their starting values are saved and restored after testing.  At the start,
run is set to 2 to ensure that only test pages will be merged (we assume
that no applications make madvise syscalls in the background).  If KSM
config not enabled, all tests will be skipped.


This patch (of 4):

Add check_ksm_merge() function to check the basic merging feature of KSM. 
First, some number of identical pages are allocated and the MADV_MERGEABLE
advice is given to merge these pages.  Then, pages_shared and
pages_sharing values are compared with the expected numbers using
assert_ksm_pages_count() function.  The number of pages can be changed
using -p option.

Link: https://lkml.kernel.org/r/cover.1626252248.git.zhansayabagdaulet@gmail.com
Link: https://lkml.kernel.org/r/90287685c13300972ea84de93d1f3f900373f9fe.1626252248.git.zhansayabagdaulet@gmail.com
Signed-off-by: Zhansaya Bagdauletkyzy <zhansayabagdaulet@gmail.com>
Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore     |    1 
 tools/testing/selftests/vm/Makefile       |    1 
 tools/testing/selftests/vm/ksm_tests.c    |  306 ++++++++++++++++++++
 tools/testing/selftests/vm/run_vmtests.sh |   16 +
 4 files changed, 324 insertions(+)

--- a/tools/testing/selftests/vm/.gitignore~selftests-vm-add-ksm-merge-test
+++ a/tools/testing/selftests/vm/.gitignore
@@ -27,3 +27,4 @@ hmm-tests
 memfd_secret
 local_config.*
 split_huge_page_test
+ksm_tests
--- /dev/null
+++ a/tools/testing/selftests/vm/ksm_tests.c
@@ -0,0 +1,306 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <sys/mman.h>
+#include <stdbool.h>
+#include <time.h>
+#include <string.h>
+
+#include "../kselftest.h"
+
+#define KSM_SYSFS_PATH "/sys/kernel/mm/ksm/"
+#define KSM_FP(s) (KSM_SYSFS_PATH s)
+#define KSM_SCAN_LIMIT_SEC_DEFAULT 120
+#define KSM_PAGE_COUNT_DEFAULT 10l
+#define KSM_PROT_STR_DEFAULT "rw"
+
+struct ksm_sysfs {
+	unsigned long max_page_sharing;
+	unsigned long merge_across_nodes;
+	unsigned long pages_to_scan;
+	unsigned long run;
+	unsigned long sleep_millisecs;
+	unsigned long stable_node_chains_prune_millisecs;
+	unsigned long use_zero_pages;
+};
+
+static int ksm_write_sysfs(const char *file_path, unsigned long val)
+{
+	FILE *f = fopen(file_path, "w");
+
+	if (!f) {
+		fprintf(stderr, "f %s\n", file_path);
+		perror("fopen");
+		return 1;
+	}
+	if (fprintf(f, "%lu", val) < 0) {
+		perror("fprintf");
+		return 1;
+	}
+	fclose(f);
+
+	return 0;
+}
+
+static int ksm_read_sysfs(const char *file_path, unsigned long *val)
+{
+	FILE *f = fopen(file_path, "r");
+
+	if (!f) {
+		fprintf(stderr, "f %s\n", file_path);
+		perror("fopen");
+		return 1;
+	}
+	if (fscanf(f, "%lu", val) != 1) {
+		perror("fscanf");
+		return 1;
+	}
+	fclose(f);
+
+	return 0;
+}
+
+static int str_to_prot(char *prot_str)
+{
+	int prot = 0;
+
+	if ((strchr(prot_str, 'r')) != NULL)
+		prot |= PROT_READ;
+	if ((strchr(prot_str, 'w')) != NULL)
+		prot |= PROT_WRITE;
+	if ((strchr(prot_str, 'x')) != NULL)
+		prot |= PROT_EXEC;
+
+	return prot;
+}
+
+static void print_help(void)
+{
+	printf("usage: ksm_tests [-h] [-a prot] [-p page_count] [-l timeout]\n");
+	printf(" -a: specify the access protections of pages.\n"
+	       "     <prot> must be of the form [rwx].\n"
+	       "     Default: %s\n", KSM_PROT_STR_DEFAULT);
+	printf(" -p: specify the number of pages to test.\n"
+	       "     Default: %ld\n", KSM_PAGE_COUNT_DEFAULT);
+	printf(" -l: limit the maximum running time (in seconds) for a test.\n"
+	       "     Default: %d seconds\n", KSM_SCAN_LIMIT_SEC_DEFAULT);
+
+	exit(0);
+}
+
+static void  *allocate_memory(void *ptr, int prot, int mapping, char data, size_t map_size)
+{
+	void *map_ptr = mmap(ptr, map_size, PROT_WRITE, mapping, -1, 0);
+
+	if (!map_ptr) {
+		perror("mmap");
+		return NULL;
+	}
+	memset(map_ptr, data, map_size);
+	if (mprotect(map_ptr, map_size, prot)) {
+		perror("mprotect");
+		munmap(map_ptr, map_size);
+		return NULL;
+	}
+
+	return map_ptr;
+}
+
+static int ksm_do_scan(int scan_count, struct timespec start_time, int timeout)
+{
+	struct timespec cur_time;
+	unsigned long cur_scan, init_scan;
+
+	if (ksm_read_sysfs(KSM_FP("full_scans"), &init_scan))
+		return 1;
+	cur_scan = init_scan;
+
+	while (cur_scan < init_scan + scan_count) {
+		if (ksm_read_sysfs(KSM_FP("full_scans"), &cur_scan))
+			return 1;
+		if (clock_gettime(CLOCK_MONOTONIC_RAW, &cur_time)) {
+			perror("clock_gettime");
+			return 1;
+		}
+		if ((cur_time.tv_sec - start_time.tv_sec) > timeout) {
+			printf("Scan time limit exceeded\n");
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static int ksm_merge_pages(void *addr, size_t size, struct timespec start_time, int timeout)
+{
+	if (madvise(addr, size, MADV_MERGEABLE)) {
+		perror("madvise");
+		return 1;
+	}
+	if (ksm_write_sysfs(KSM_FP("run"), 1))
+		return 1;
+
+	/* Since merging occurs only after 2 scans, make sure to get at least 2 full scans */
+	if (ksm_do_scan(2, start_time, timeout))
+		return 1;
+
+	return 0;
+}
+
+static bool assert_ksm_pages_count(long dupl_page_count)
+{
+	unsigned long max_page_sharing, pages_sharing, pages_shared;
+
+	if (ksm_read_sysfs(KSM_FP("pages_shared"), &pages_shared) ||
+	    ksm_read_sysfs(KSM_FP("pages_sharing"), &pages_sharing) ||
+	    ksm_read_sysfs(KSM_FP("max_page_sharing"), &max_page_sharing))
+		return false;
+
+	/*
+	 * Since there must be at least 2 pages for merging and 1 page can be
+	 * shared with the limited number of pages (max_page_sharing), sometimes
+	 * there are 'leftover' pages that cannot be merged. For example, if there
+	 * are 11 pages and max_page_sharing = 10, then only 10 pages will be
+	 * merged and the 11th page won't be affected. As a result, when the number
+	 * of duplicate pages is divided by max_page_sharing and the remainder is 1,
+	 * pages_shared and pages_sharing values will be equal between dupl_page_count
+	 * and dupl_page_count - 1.
+	 */
+	if (dupl_page_count % max_page_sharing == 1 || dupl_page_count % max_page_sharing == 0) {
+		if (pages_shared == dupl_page_count / max_page_sharing &&
+		    pages_sharing == pages_shared * (max_page_sharing - 1))
+			return true;
+	} else {
+		if (pages_shared == (dupl_page_count / max_page_sharing + 1) &&
+		    pages_sharing == dupl_page_count - pages_shared)
+			return true;
+	}
+
+	return false;
+}
+
+static int ksm_save_def(struct ksm_sysfs *ksm_sysfs)
+{
+	if (ksm_read_sysfs(KSM_FP("max_page_sharing"), &ksm_sysfs->max_page_sharing) ||
+	    ksm_read_sysfs(KSM_FP("merge_across_nodes"), &ksm_sysfs->merge_across_nodes) ||
+	    ksm_read_sysfs(KSM_FP("sleep_millisecs"), &ksm_sysfs->sleep_millisecs) ||
+	    ksm_read_sysfs(KSM_FP("pages_to_scan"), &ksm_sysfs->pages_to_scan) ||
+	    ksm_read_sysfs(KSM_FP("run"), &ksm_sysfs->run) ||
+	    ksm_read_sysfs(KSM_FP("stable_node_chains_prune_millisecs"),
+			   &ksm_sysfs->stable_node_chains_prune_millisecs) ||
+	    ksm_read_sysfs(KSM_FP("use_zero_pages"), &ksm_sysfs->use_zero_pages))
+		return 1;
+
+	return 0;
+}
+
+static int ksm_restore(struct ksm_sysfs *ksm_sysfs)
+{
+	if (ksm_write_sysfs(KSM_FP("max_page_sharing"), ksm_sysfs->max_page_sharing) ||
+	    ksm_write_sysfs(KSM_FP("merge_across_nodes"), ksm_sysfs->merge_across_nodes) ||
+	    ksm_write_sysfs(KSM_FP("pages_to_scan"), ksm_sysfs->pages_to_scan) ||
+	    ksm_write_sysfs(KSM_FP("run"), ksm_sysfs->run) ||
+	    ksm_write_sysfs(KSM_FP("sleep_millisecs"), ksm_sysfs->sleep_millisecs) ||
+	    ksm_write_sysfs(KSM_FP("stable_node_chains_prune_millisecs"),
+			    ksm_sysfs->stable_node_chains_prune_millisecs) ||
+	    ksm_write_sysfs(KSM_FP("use_zero_pages"), ksm_sysfs->use_zero_pages))
+		return 1;
+
+	return 0;
+}
+
+static int check_ksm_merge(int mapping, int prot, long page_count, int timeout, size_t page_size)
+{
+	void *map_ptr;
+	struct timespec start_time;
+
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
+		perror("clock_gettime");
+		return KSFT_FAIL;
+	}
+
+	/* fill pages with the same data and merge them */
+	map_ptr = allocate_memory(NULL, prot, mapping, '*', page_size * page_count);
+	if (!map_ptr)
+		return KSFT_FAIL;
+
+	if (ksm_merge_pages(map_ptr, page_size * page_count, start_time, timeout))
+		goto err_out;
+
+	/* verify that the right number of pages are merged */
+	if (assert_ksm_pages_count(page_count)) {
+		printf("OK\n");
+		munmap(map_ptr, page_size * page_count);
+		return KSFT_PASS;
+	}
+
+err_out:
+	printf("Not OK\n");
+	munmap(map_ptr, page_size * page_count);
+	return KSFT_FAIL;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret, opt;
+	int prot = 0;
+	int ksm_scan_limit_sec = KSM_SCAN_LIMIT_SEC_DEFAULT;
+	long page_count = KSM_PAGE_COUNT_DEFAULT;
+	size_t page_size = sysconf(_SC_PAGESIZE);
+	struct ksm_sysfs ksm_sysfs_old;
+
+	while ((opt = getopt(argc, argv, "ha:p:l:")) != -1) {
+		switch (opt) {
+		case 'a':
+			prot = str_to_prot(optarg);
+			break;
+		case 'p':
+			page_count = atol(optarg);
+			if (page_count <= 0) {
+				printf("The number of pages must be greater than 0\n");
+				return KSFT_FAIL;
+			}
+			break;
+		case 'l':
+			ksm_scan_limit_sec = atoi(optarg);
+			if (ksm_scan_limit_sec <= 0) {
+				printf("Timeout value must be greater than 0\n");
+				return KSFT_FAIL;
+			}
+			break;
+		case 'h':
+			print_help();
+			break;
+		default:
+			return KSFT_FAIL;
+		}
+	}
+
+	if (prot == 0)
+		prot = str_to_prot(KSM_PROT_STR_DEFAULT);
+
+	if (access(KSM_SYSFS_PATH, F_OK)) {
+		printf("Config KSM not enabled\n");
+		return KSFT_SKIP;
+	}
+
+	if (ksm_save_def(&ksm_sysfs_old)) {
+		printf("Cannot save default tunables\n");
+		return KSFT_FAIL;
+	}
+
+	if (ksm_write_sysfs(KSM_FP("run"), 2) ||
+	    ksm_write_sysfs(KSM_FP("sleep_millisecs"), 0) ||
+	    ksm_write_sysfs(KSM_FP("merge_across_nodes"), 1) ||
+	    ksm_write_sysfs(KSM_FP("pages_to_scan"), page_count))
+		return KSFT_FAIL;
+
+	ret = check_ksm_merge(MAP_PRIVATE | MAP_ANONYMOUS, prot, page_count, ksm_scan_limit_sec,
+			      page_size);
+
+	if (ksm_restore(&ksm_sysfs_old)) {
+		printf("Cannot restore default tunables\n");
+		return KSFT_FAIL;
+	}
+
+	return ret;
+}
--- a/tools/testing/selftests/vm/Makefile~selftests-vm-add-ksm-merge-test
+++ a/tools/testing/selftests/vm/Makefile
@@ -45,6 +45,7 @@ TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += userfaultfd
 TEST_GEN_FILES += split_huge_page_test
+TEST_GEN_FILES += ksm_tests
 
 ifeq ($(MACHINE),x86_64)
 CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_32bit_program.c -m32)
--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-add-ksm-merge-test
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -377,6 +377,22 @@ else
 	exitcode=1
 fi
 
+echo "-------------------------------------------------------"
+echo "running KSM MADV_MERGEABLE test with 10 identical pages"
+echo "-------------------------------------------------------"
+./ksm_tests -p 10
+ret_val=$?
+
+if [ $ret_val -eq 0 ]; then
+	echo "[PASS]"
+elif [ $ret_val -eq $ksft_skip ]; then
+	 echo "[SKIP]"
+	 exitcode=$ksft_skip
+else
+	echo "[FAIL]"
+	exitcode=1
+fi
+
 exit $exitcode
 
 exit $exitcode
_

Patches currently in -mm which might be from zhansayabagdaulet@gmail.com are


