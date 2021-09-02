Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59ACEC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AF79610D2
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347972AbhIBWBm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:01:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347666AbhIBWBm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:01:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6BB9610A1;
        Thu,  2 Sep 2021 22:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630620043;
        bh=I6DuuVPMXLVinevBm/6PeQ31aEUnJvnzH6RvgVjBwII=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qedGAyQyTiiTRgxjSmAs3Wmh+pyqkF6SNxI6zz4kKq28SLTjg7Oh9/2k5zgYtduzp
         BhVhN4pX6x+B7PIZFCG8wCJm/BUG8b/xQoYdb/SGihn4feerNjXAITajYVatT3TiBE
         823ixBDrXGiM1OsydZhsOeWm6BxpvVYEcpUKTCkk=
Date:   Thu, 02 Sep 2021 15:00:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        shuah@kernel.org, torvalds@linux-foundation.org,
        tyhicks@linux.microsoft.com, zhansayabagdaulet@gmail.com
Subject:  [patch 202/212] selftests: vm: add KSM unmerge test
Message-ID: <20210902220042.rjUoUviEl%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhansaya Bagdauletkyzy <zhansayabagdaulet@gmail.com>
Subject: selftests: vm: add KSM unmerge test

Add check_ksm_unmerge() function to verify that KSM is properly unmerging
shared pages.  For this, two duplicate pages are merged first and then
their contents are modified.  Since they are not identical anymore, the
pages must be unmerged and the number of merged pages has to be 0.  The
test is run as follows: ./ksm_tests -U

Link: https://lkml.kernel.org/r/c0f55420440d704d5b094275b4365aa1b2ad46b5.1626252248.git.zhansayabagdaulet@gmail.com
Signed-off-by: Zhansaya Bagdauletkyzy <zhansayabagdaulet@gmail.com>
Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/ksm_tests.c    |   72 ++++++++++++++++++--
 tools/testing/selftests/vm/run_vmtests.sh |   18 ++++-
 2 files changed, 85 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/vm/ksm_tests.c~selftests-vm-add-ksm-unmerge-test
+++ a/tools/testing/selftests/vm/ksm_tests.c
@@ -23,6 +23,11 @@ struct ksm_sysfs {
 	unsigned long use_zero_pages;
 };
 
+enum ksm_test_name {
+	CHECK_KSM_MERGE,
+	CHECK_KSM_UNMERGE
+};
+
 static int ksm_write_sysfs(const char *file_path, unsigned long val)
 {
 	FILE *f = fopen(file_path, "w");
@@ -75,7 +80,12 @@ static int str_to_prot(char *prot_str)
 
 static void print_help(void)
 {
-	printf("usage: ksm_tests [-h] [-a prot] [-p page_count] [-l timeout]\n");
+	printf("usage: ksm_tests [-h] <test type> [-a prot] [-p page_count] [-l timeout]\n");
+
+	printf("Supported <test type>:\n"
+	       " -M (page merging)\n"
+	       " -U (page unmerging)\n\n");
+
 	printf(" -a: specify the access protections of pages.\n"
 	       "     <prot> must be of the form [rwx].\n"
 	       "     Default: %s\n", KSM_PROT_STR_DEFAULT);
@@ -239,6 +249,46 @@ err_out:
 	return KSFT_FAIL;
 }
 
+static int check_ksm_unmerge(int mapping, int prot, int timeout, size_t page_size)
+{
+	void *map_ptr;
+	struct timespec start_time;
+	int page_count = 2;
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
+	/* change 1 byte in each of the 2 pages -- KSM must automatically unmerge them */
+	memset(map_ptr, '-', 1);
+	memset(map_ptr + page_size, '+', 1);
+
+	/* get at least 1 scan, so KSM can detect that the pages were modified */
+	if (ksm_do_scan(1, start_time, timeout))
+		goto err_out;
+
+	/* check that unmerging was successful and 0 pages are currently merged */
+	if (assert_ksm_pages_count(0)) {
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
 int main(int argc, char *argv[])
 {
 	int ret, opt;
@@ -247,8 +297,9 @@ int main(int argc, char *argv[])
 	long page_count = KSM_PAGE_COUNT_DEFAULT;
 	size_t page_size = sysconf(_SC_PAGESIZE);
 	struct ksm_sysfs ksm_sysfs_old;
+	int test_name = CHECK_KSM_MERGE;
 
-	while ((opt = getopt(argc, argv, "ha:p:l:")) != -1) {
+	while ((opt = getopt(argc, argv, "ha:p:l:MU")) != -1) {
 		switch (opt) {
 		case 'a':
 			prot = str_to_prot(optarg);
@@ -270,6 +321,11 @@ int main(int argc, char *argv[])
 		case 'h':
 			print_help();
 			break;
+		case 'M':
+			break;
+		case 'U':
+			test_name = CHECK_KSM_UNMERGE;
+			break;
 		default:
 			return KSFT_FAIL;
 		}
@@ -294,8 +350,16 @@ int main(int argc, char *argv[])
 	    ksm_write_sysfs(KSM_FP("pages_to_scan"), page_count))
 		return KSFT_FAIL;
 
-	ret = check_ksm_merge(MAP_PRIVATE | MAP_ANONYMOUS, prot, page_count, ksm_scan_limit_sec,
-			      page_size);
+	switch (test_name) {
+	case CHECK_KSM_MERGE:
+		ret = check_ksm_merge(MAP_PRIVATE | MAP_ANONYMOUS, prot, page_count,
+				      ksm_scan_limit_sec, page_size);
+		break;
+	case CHECK_KSM_UNMERGE:
+		ret = check_ksm_unmerge(MAP_PRIVATE | MAP_ANONYMOUS, prot, ksm_scan_limit_sec,
+					page_size);
+		break;
+	}
 
 	if (ksm_restore(&ksm_sysfs_old)) {
 		printf("Cannot restore default tunables\n");
--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-add-ksm-unmerge-test
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -380,7 +380,23 @@ fi
 echo "-------------------------------------------------------"
 echo "running KSM MADV_MERGEABLE test with 10 identical pages"
 echo "-------------------------------------------------------"
-./ksm_tests -p 10
+./ksm_tests -M -p 10
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
+echo "------------------------"
+echo "running KSM unmerge test"
+echo "------------------------"
+./ksm_tests -U
 ret_val=$?
 
 if [ $ret_val -eq 0 ]; then
_
