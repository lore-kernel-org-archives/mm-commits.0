Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74888C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjASBVG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjASBTc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:19:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F03B6CCCC
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BFEF61B0B
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CD2C43392;
        Thu, 19 Jan 2023 01:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090989;
        bh=/hOZ7uRRIjJ8kkdKF5rUKrxMnksZ3DilIR6waoxnvyc=;
        h=Date:To:From:Subject:From;
        b=U5xVnZjG1shFGUW9T+gYoPGkqS8kGft3Sz9OtTsCoxOI9bdt5rYb5x8qyH6Ox1IDb
         IW3Az++ngcHW0Mh+6G9s3ML3WjrtXCNPBSUGe/j3Msee4Lnt7FgWf5G6zyQ9JIU1X4
         exyf6mwVHN27YHvGi9OBLyywk20i+KR+U4vK1sBA=
Date:   Wed, 18 Jan 2023 17:16:28 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shuah@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net,
        matenajakub@gmail.com, david@redhat.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-vm-add-mremap-expand-merge-offset-test.patch removed from -mm tree
Message-Id: <20230119011628.F1CD2C43392@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftest/vm: add mremap expand merge offset test
has been removed from the -mm tree.  Its filename was
     selftest-vm-add-mremap-expand-merge-offset-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: selftest/vm: add mremap expand merge offset test
Date: Mon, 2 Jan 2023 16:11:26 +0000

Add a test to assert that we can mremap() and expand a mapping starting
from an offset within an existing mapping.  We unmap the last page in a 3
page mapping to ensure that the remap should always succeed, before
remapping from the 2nd page.

This is additionally a regression test for the issue solved in "mm,
mremap: fix mremap() expanding vma with addr inside vma" and confirmed to
fail prior to the change and pass after it.

Finally, this patch updates the existing mremap expand merge test to check
error conditions and reduce code duplication between the two tests.

[lstoakes@gmail.com: increment num_expand_tests so test doesn't complain about unexpected tests being run]
  Link: https://lkml.kernel.org/r/8ff3ba3cadc0b6c1b2688ae5c851bf73aa062d57.1673701836.git.lstoakes@gmail.com
Link: https://lkml.kernel.org/r/02b117a8ffd52acc01dc66c2fb39754f08d92c0e.1672675824.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |  119 ++++++++++++++++-----
 1 file changed, 96 insertions(+), 23 deletions(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftest-vm-add-mremap-expand-merge-offset-test
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -119,47 +119,109 @@ static unsigned long long get_mmap_min_a
 }
 
 /*
- * This test validates that merge is called when expanding a mapping.
- * Mapping containing three pages is created, middle page is unmapped
- * and then the mapping containing the first page is expanded so that
- * it fills the created hole. The two parts should merge creating
- * single mapping with three pages.
+ * Using /proc/self/maps, assert that the specified address range is contained
+ * within a single mapping.
  */
-static void mremap_expand_merge(unsigned long page_size)
+static bool is_range_mapped(FILE *maps_fp, void *start, void *end)
 {
-	char *test_name = "mremap expand merge";
-	FILE *fp;
 	char *line = NULL;
 	size_t len = 0;
 	bool success = false;
-	char *start = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-
-	munmap(start + page_size, page_size);
-	mremap(start, page_size, 2 * page_size, 0);
 
-	fp = fopen("/proc/self/maps", "r");
-	if (fp == NULL) {
-		ksft_test_result_fail("%s\n", test_name);
-		return;
-	}
+	rewind(maps_fp);
 
-	while (getline(&line, &len, fp) != -1) {
+	while (getline(&line, &len, maps_fp) != -1) {
 		char *first = strtok(line, "- ");
 		void *first_val = (void *)strtol(first, NULL, 16);
 		char *second = strtok(NULL, "- ");
 		void *second_val = (void *) strtol(second, NULL, 16);
 
-		if (first_val == start && second_val == start + 3 * page_size) {
+		if (first_val <= start && second_val >= end) {
 			success = true;
 			break;
 		}
 	}
+
+	return success;
+}
+
+/*
+ * This test validates that merge is called when expanding a mapping.
+ * Mapping containing three pages is created, middle page is unmapped
+ * and then the mapping containing the first page is expanded so that
+ * it fills the created hole. The two parts should merge creating
+ * single mapping with three pages.
+ */
+static void mremap_expand_merge(FILE *maps_fp, unsigned long page_size)
+{
+	char *test_name = "mremap expand merge";
+	bool success = false;
+	char *remap, *start;
+
+	start = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+
+	if (start == MAP_FAILED) {
+		ksft_print_msg("mmap failed: %s\n", strerror(errno));
+		goto out;
+	}
+
+	munmap(start + page_size, page_size);
+	remap = mremap(start, page_size, 2 * page_size, 0);
+	if (remap == MAP_FAILED) {
+		ksft_print_msg("mremap failed: %s\n", strerror(errno));
+		munmap(start, page_size);
+		munmap(start + 2 * page_size, page_size);
+		goto out;
+	}
+
+	success = is_range_mapped(maps_fp, start, start + 3 * page_size);
+	munmap(start, 3 * page_size);
+
+out:
+	if (success)
+		ksft_test_result_pass("%s\n", test_name);
+	else
+		ksft_test_result_fail("%s\n", test_name);
+}
+
+/*
+ * Similar to mremap_expand_merge() except instead of removing the middle page,
+ * we remove the last then attempt to remap offset from the second page. This
+ * should result in the mapping being restored to its former state.
+ */
+static void mremap_expand_merge_offset(FILE *maps_fp, unsigned long page_size)
+{
+
+	char *test_name = "mremap expand merge offset";
+	bool success = false;
+	char *remap, *start;
+
+	start = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+
+	if (start == MAP_FAILED) {
+		ksft_print_msg("mmap failed: %s\n", strerror(errno));
+		goto out;
+	}
+
+	/* Unmap final page to ensure we have space to expand. */
+	munmap(start + 2 * page_size, page_size);
+	remap = mremap(start + page_size, page_size, 2 * page_size, 0);
+	if (remap == MAP_FAILED) {
+		ksft_print_msg("mremap failed: %s\n", strerror(errno));
+		munmap(start, 2 * page_size);
+		goto out;
+	}
+
+	success = is_range_mapped(maps_fp, start, start + 3 * page_size);
+	munmap(start, 3 * page_size);
+
+out:
 	if (success)
 		ksft_test_result_pass("%s\n", test_name);
 	else
 		ksft_test_result_fail("%s\n", test_name);
-	fclose(fp);
 }
 
 /*
@@ -380,11 +442,12 @@ int main(int argc, char **argv)
 	int i, run_perf_tests;
 	unsigned int threshold_mb = VALIDATION_DEFAULT_THRESHOLD;
 	unsigned int pattern_seed;
-	int num_expand_tests = 1;
+	int num_expand_tests = 2;
 	struct test test_cases[MAX_TEST];
 	struct test perf_test_cases[MAX_PERF_TEST];
 	int page_size;
 	time_t t;
+	FILE *maps_fp;
 
 	pattern_seed = (unsigned int) time(&t);
 
@@ -458,7 +521,17 @@ int main(int argc, char **argv)
 		run_mremap_test_case(test_cases[i], &failures, threshold_mb,
 				     pattern_seed);
 
-	mremap_expand_merge(page_size);
+	maps_fp = fopen("/proc/self/maps", "r");
+
+	if (maps_fp == NULL) {
+		ksft_print_msg("Failed to read /proc/self/maps: %s\n", strerror(errno));
+		exit(KSFT_FAIL);
+	}
+
+	mremap_expand_merge(maps_fp, page_size);
+	mremap_expand_merge_offset(maps_fp, page_size);
+
+	fclose(maps_fp);
 
 	if (run_perf_tests) {
 		ksft_print_msg("\n%s\n",
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-pagevec-add-folio_batch_reinit.patch
mm-mlock-use-folios-and-a-folio-batch-internally.patch
m68k-mm-motorola-specify-pmd_page-type.patch
mm-mlock-update-the-interface-to-use-folios.patch
documentation-mm-update-references-to-__mlock_page-to-_folio.patch

