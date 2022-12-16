Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE02C4167B
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 22:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiLPWCR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 17:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiLPWCR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 17:02:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEC218D
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 14:02:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4969AB81E3C
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 22:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC98AC433D2;
        Fri, 16 Dec 2022 22:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671228133;
        bh=Wtw7+ZaYONo0TzKRrxd8zFn5+P1fwBzZb8dYkNiu0pc=;
        h=Date:To:From:Subject:From;
        b=VhnUKVqraq5FMkegVkwY3TXNZpF9M0FufxA+jkCq+yU24uRnxl++gr/fb8MAkTxXg
         BtxBQunnhtuLq2PLUsZlgd5FruX4DkoJzs0I85ZjC+dcWrteh4OUgR8nqY1EVfY3ae
         cWXS0tHwfaUGanyjmIz6+S+/wX+bQ1Po9qwBctus=
Date:   Fri, 16 Dec 2022 14:02:12 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shuah@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net,
        matenajakub@gmail.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-vm-add-mremap-expand-merge-offset-test.patch added to mm-unstable branch
Message-Id: <20221216220212.EC98AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/vm: add mremap expand merge offset test
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-vm-add-mremap-expand-merge-offset-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-vm-add-mremap-expand-merge-offset-test.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: selftest/vm: add mremap expand merge offset test
Date: Fri, 16 Dec 2022 21:44:36 +0000

Add a test to assert that we can mremap() and expand a mapping starting
from an offset within an existing mapping.  We unmap the last page in a 3
page mapping to ensure that the remap should always succeed, before
remapping from the 2nd page.

This is additionally a regression test for the issue solved in "mm,
mremap: fix mremap() expanding vma with addr inside vma" and confirmed to
fail prior to the change and pass after it.

Finally, this patch updates the existing mremap expand merge test to check
error conditions and reduce code duplication between the two tests.

Link: https://lkml.kernel.org/r/20221216214436.405071-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mremap_test.c |  111 +++++++++++++++++----
 1 file changed, 93 insertions(+), 18 deletions(-)

--- a/tools/testing/selftests/vm/mremap_test.c~selftest-vm-add-mremap-expand-merge-offset-test
+++ a/tools/testing/selftests/vm/mremap_test.c
@@ -119,30 +119,19 @@ static unsigned long long get_mmap_min_a
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
+static bool is_range_mapped(void *start, void *end)
 {
-	char *test_name = "mremap expand merge";
 	FILE *fp;
 	char *line = NULL;
 	size_t len = 0;
 	bool success = false;
-	char *start = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-
-	munmap(start + page_size, page_size);
-	mremap(start, page_size, 2 * page_size, 0);
 
 	fp = fopen("/proc/self/maps", "r");
-	if (fp == NULL) {
-		ksft_test_result_fail("%s\n", test_name);
-		return;
-	}
+	if (fp == NULL)
+		return false;
 
 	while (getline(&line, &len, fp) != -1) {
 		char *first = strtok(line, "- ");
@@ -150,16 +139,101 @@ static void mremap_expand_merge(unsigned
 		char *second = strtok(NULL, "- ");
 		void *second_val = (void *) strtol(second, NULL, 16);
 
-		if (first_val == start && second_val == start + 3 * page_size) {
+		if (first_val <= start && second_val >= end) {
 			success = true;
 			break;
 		}
 	}
+
+	fclose(fp);
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
+static void mremap_expand_merge(unsigned long page_size)
+{
+	char *test_name = "mremap expand merge";
+	bool success = false;
+	int errsv = 0;
+	char *remap;
+	char *start = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+
+	if (start == MAP_FAILED) {
+		errsv = errno;
+		goto error;
+	}
+
+	munmap(start + page_size, page_size);
+	remap = mremap(start, page_size, 2 * page_size, 0);
+	if (remap == MAP_FAILED) {
+		errsv = errno;
+		munmap(start, page_size);
+		munmap(start + 2 * page_size, page_size);
+		goto error;
+	}
+
+	success = is_range_mapped(start, start + 3 * page_size);
+
+	munmap(start, 3 * page_size);
+	goto out;
+
+error:
+	ksft_print_msg("Unexpected mapping/remapping error: %s\n",
+		       strerror(errsv));
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
+static void mremap_expand_merge_offset(unsigned long page_size)
+{
+
+	char *test_name = "mremap expand merge offset";
+	bool success = false;
+	int errsv = 0;
+	char *remap;
+	char *start = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+
+	if (start == MAP_FAILED) {
+		errsv = errno;
+		goto error;
+	}
+
+	/* Unmap final page to ensure we have space to expand. */
+	munmap(start + 2 * page_size, page_size);
+	remap = mremap(start + page_size, page_size, 2 * page_size, 0);
+	if (remap == MAP_FAILED) {
+		errsv = errno;
+		munmap(start, 2 * page_size);
+		goto error;
+	}
+
+	success = is_range_mapped(start, start + 3 * page_size);
+	goto out;
+
+error:
+	ksft_print_msg("Unexpected mapping/remapping error: %s\n",
+		       strerror(errsv));
+out:
 	if (success)
 		ksft_test_result_pass("%s\n", test_name);
 	else
 		ksft_test_result_fail("%s\n", test_name);
-	fclose(fp);
 }
 
 /*
@@ -459,6 +533,7 @@ int main(int argc, char **argv)
 				     pattern_seed);
 
 	mremap_expand_merge(page_size);
+	mremap_expand_merge_offset(page_size);
 
 	if (run_perf_tests) {
 		ksft_print_msg("\n%s\n",
_

Patches currently in -mm which might be from lstoakes@gmail.com are

selftest-vm-add-mremap-expand-merge-offset-test.patch

