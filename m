Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B3DC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29570610E6
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347887AbhIBWBq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347973AbhIBWBp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:01:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD984610D2;
        Thu,  2 Sep 2021 22:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630620046;
        bh=E6gdkRv8jaWgDQP9/7ifIOycJrzMuMxx4jgybpW70ts=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vk+gpo99SwhkFsofqjPm3/14Y7XbWqwDQu42YOLmF7K33ZCGUdMLCHFgcHWs3zWvo
         kJwohG9UR53ls2GIGiXf0T4shxlzxXKHK/5pX77IrfWVesM3xvJXxahLP7MXSvG9JJ
         JbhkFwYD2Fs3U6o2ERxwUj/Gv2stAXp8jnZHjpR0=
Date:   Thu, 02 Sep 2021 15:00:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        shuah@kernel.org, torvalds@linux-foundation.org,
        tyhicks@linux.microsoft.com, zhansayabagdaulet@gmail.com
Subject:  [patch 203/212] selftests: vm: add KSM zero page merging
 test
Message-ID: <20210902220045.Kue5hnUXg%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhansaya Bagdauletkyzy <zhansayabagdaulet@gmail.com>
Subject: selftests: vm: add KSM zero page merging test

Add check_ksm_zero_page_merge() function to test that empty pages are
being handled properly.  For this, several zero pages are allocated and
merged using madvise.  If use_zero_pages is enabled, the pages must be
shared with the special kernel zero pages; otherwise, they are merged as
usual duplicate pages.  The test is run as follows: ./ksm_tests -Z

Link: https://lkml.kernel.org/r/6d0caab00d4bdccf5e3791cb95cf6dfd5eb85e45.1626252248.git.zhansayabagdaulet@gmail.com
Signed-off-by: Zhansaya Bagdauletkyzy <zhansayabagdaulet@gmail.com>
Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/ksm_tests.c    |   70 +++++++++++++++++++-
 tools/testing/selftests/vm/run_vmtests.sh |   32 +++++++++
 2 files changed, 99 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/vm/ksm_tests.c~selftests-vm-add-ksm-zero-page-merging-test
+++ a/tools/testing/selftests/vm/ksm_tests.c
@@ -12,6 +12,7 @@
 #define KSM_SCAN_LIMIT_SEC_DEFAULT 120
 #define KSM_PAGE_COUNT_DEFAULT 10l
 #define KSM_PROT_STR_DEFAULT "rw"
+#define KSM_USE_ZERO_PAGES_DEFAULT false
 
 struct ksm_sysfs {
 	unsigned long max_page_sharing;
@@ -25,7 +26,8 @@ struct ksm_sysfs {
 
 enum ksm_test_name {
 	CHECK_KSM_MERGE,
-	CHECK_KSM_UNMERGE
+	CHECK_KSM_UNMERGE,
+	CHECK_KSM_ZERO_PAGE_MERGE
 };
 
 static int ksm_write_sysfs(const char *file_path, unsigned long val)
@@ -80,10 +82,12 @@ static int str_to_prot(char *prot_str)
 
 static void print_help(void)
 {
-	printf("usage: ksm_tests [-h] <test type> [-a prot] [-p page_count] [-l timeout]\n");
+	printf("usage: ksm_tests [-h] <test type> [-a prot] [-p page_count] [-l timeout]\n"
+	       "[-z use_zero_pages]\n");
 
 	printf("Supported <test type>:\n"
 	       " -M (page merging)\n"
+	       " -Z (zero pages merging)\n"
 	       " -U (page unmerging)\n\n");
 
 	printf(" -a: specify the access protections of pages.\n"
@@ -93,6 +97,8 @@ static void print_help(void)
 	       "     Default: %ld\n", KSM_PAGE_COUNT_DEFAULT);
 	printf(" -l: limit the maximum running time (in seconds) for a test.\n"
 	       "     Default: %d seconds\n", KSM_SCAN_LIMIT_SEC_DEFAULT);
+	printf(" -z: change use_zero_pages tunable\n"
+	       "     Default: %d\n", KSM_USE_ZERO_PAGES_DEFAULT);
 
 	exit(0);
 }
@@ -289,6 +295,50 @@ err_out:
 	return KSFT_FAIL;
 }
 
+static int check_ksm_zero_page_merge(int mapping, int prot, long page_count, int timeout,
+				     bool use_zero_pages, size_t page_size)
+{
+	void *map_ptr;
+	struct timespec start_time;
+
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
+		perror("clock_gettime");
+		return KSFT_FAIL;
+	}
+
+	if (ksm_write_sysfs(KSM_FP("use_zero_pages"), use_zero_pages))
+		return KSFT_FAIL;
+
+	/* fill pages with zero and try to merge them */
+	map_ptr = allocate_memory(NULL, prot, mapping, 0, page_size * page_count);
+	if (!map_ptr)
+		return KSFT_FAIL;
+
+	if (ksm_merge_pages(map_ptr, page_size * page_count, start_time, timeout))
+		goto err_out;
+
+       /*
+	* verify that the right number of pages are merged:
+	* 1) if use_zero_pages is set to 1, empty pages are merged
+	*    with the kernel zero page instead of with each other;
+	* 2) if use_zero_pages is set to 0, empty pages are not treated specially
+	*    and merged as usual.
+	*/
+	if (use_zero_pages && !assert_ksm_pages_count(0))
+		goto err_out;
+	else if (!use_zero_pages && !assert_ksm_pages_count(page_count))
+		goto err_out;
+
+	printf("OK\n");
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
@@ -298,8 +348,9 @@ int main(int argc, char *argv[])
 	size_t page_size = sysconf(_SC_PAGESIZE);
 	struct ksm_sysfs ksm_sysfs_old;
 	int test_name = CHECK_KSM_MERGE;
+	bool use_zero_pages = KSM_USE_ZERO_PAGES_DEFAULT;
 
-	while ((opt = getopt(argc, argv, "ha:p:l:MU")) != -1) {
+	while ((opt = getopt(argc, argv, "ha:p:l:z:MUZ")) != -1) {
 		switch (opt) {
 		case 'a':
 			prot = str_to_prot(optarg);
@@ -321,11 +372,20 @@ int main(int argc, char *argv[])
 		case 'h':
 			print_help();
 			break;
+		case 'z':
+			if (strcmp(optarg, "0") == 0)
+				use_zero_pages = 0;
+			else
+				use_zero_pages = 1;
+			break;
 		case 'M':
 			break;
 		case 'U':
 			test_name = CHECK_KSM_UNMERGE;
 			break;
+		case 'Z':
+			test_name = CHECK_KSM_ZERO_PAGE_MERGE;
+			break;
 		default:
 			return KSFT_FAIL;
 		}
@@ -359,6 +419,10 @@ int main(int argc, char *argv[])
 		ret = check_ksm_unmerge(MAP_PRIVATE | MAP_ANONYMOUS, prot, ksm_scan_limit_sec,
 					page_size);
 		break;
+	case CHECK_KSM_ZERO_PAGE_MERGE:
+		ret = check_ksm_zero_page_merge(MAP_PRIVATE | MAP_ANONYMOUS, prot, page_count,
+						ksm_scan_limit_sec, use_zero_pages, page_size);
+		break;
 	}
 
 	if (ksm_restore(&ksm_sysfs_old)) {
--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-add-ksm-zero-page-merging-test
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -409,6 +409,38 @@ else
 	exitcode=1
 fi
 
+echo "----------------------------------------------------------"
+echo "running KSM test with 10 zero pages and use_zero_pages = 0"
+echo "----------------------------------------------------------"
+./ksm_tests -Z -p 10 -z 0
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
+echo "----------------------------------------------------------"
+echo "running KSM test with 10 zero pages and use_zero_pages = 1"
+echo "----------------------------------------------------------"
+./ksm_tests -Z -p 10 -z 1
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
