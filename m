Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 465A7C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Jun 2022 17:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiFCRLq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Jun 2022 13:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344205AbiFCRLp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2022 13:11:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594155251B
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 10:11:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 81A58CE2413
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 17:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEBCC385A9;
        Fri,  3 Jun 2022 17:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654276300;
        bh=rXcu3ra09ZJbkTTdwutUQXHDuaMPacRiLtF1Wi3Qkcw=;
        h=Date:To:From:Subject:From;
        b=FXKbLXc4sXUIvY6SV7MTK5b036/YYZIL8j5mwseT6iPNXbWsINkl3VeTo7iTQBcm5
         0qk9vf6+PlUXmxdEh6RRCdOu6fO3qfTShxZ1hK7H1Qbsu2azGTVJgPyvTOXtbHEf71
         Zi+hX1N7lOUuG28rWVaWKNKLHzIjLewypsqzFD7c=
Date:   Fri, 03 Jun 2022 10:11:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        rostedt@goodmis.org, riel@surriel.com, peterz@infradead.org,
        mhocko@kernel.org, mgorman@techsingularity.net,
        liam.howlett@oracle.com, kirill@shutemov.name, hughd@google.com,
        matenajakub@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-merging-after-mremap-resize.patch added to mm-unstable branch
Message-Id: <20220603171140.CDEBCC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH 2/2] mm: add merging after mremap resize
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-merging-after-mremap-resize.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-merging-after-mremap-resize.patch

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
From: Jakub Matěna <matenajakub@gmail.com>
Subject: [PATCH 2/2] mm: add merging after mremap resize
Date: Fri, 3 Jun 2022 16:57:19 +0200

When mremap call results in expansion, it might be possible to merge the
VMA with the next VMA which might become adjacent.  This patch adds
vma_merge call after the expansion is done to try and merge.

Link: https://lkml.kernel.org/r/20220603145719.1012094-3-matenajakub@gmail.com
Signed-off-by: Jakub Matěna <matenajakub@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c                              |   19 +++++++-
 tools/testing/selftests/vm/mremap_test.c |   47 ++++++++++++++++++++-
 2 files changed, 63 insertions(+), 3 deletions(-)

--- a/mm/mremap.c~mm-add-merging-after-mremap-resize
+++ a/mm/mremap.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/mm.h>
+#include <linux/mm_inline.h>
 #include <linux/hugetlb.h>
 #include <linux/shm.h>
 #include <linux/ksm.h>
@@ -23,6 +24,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/uaccess.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/mempolicy.h>
 
 #include <asm/cacheflush.h>
 #include <asm/tlb.h>
@@ -1012,6 +1014,9 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 		/* can we just expand the current mapping? */
 		if (vma_expandable(vma, new_len - old_len)) {
 			long pages = (new_len - old_len) >> PAGE_SHIFT;
+			unsigned long extension_start = addr + old_len;
+			unsigned long extension_end = addr + new_len;
+			pgoff_t extension_pgoff = vma->vm_pgoff + (old_len >> PAGE_SHIFT);
 
 			if (vma->vm_flags & VM_ACCOUNT) {
 				if (security_vm_enough_memory_mm(mm, pages)) {
@@ -1020,8 +1025,18 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 				}
 			}
 
-			if (vma_adjust(vma, vma->vm_start, addr + new_len,
-				       vma->vm_pgoff, NULL)) {
+			/*
+			 * Function vma_merge() is called on the extension we are adding to
+			 * the already existing vma, vma_merge() will merge this extension with
+			 * the already existing vma (expand operation itself) and possibly also
+			 * with the next vma if it becomes adjacent to the expanded vma and
+			 * otherwise compatible.
+			 */
+			vma = vma_merge(mm, vma, extension_start, extension_end,
+					vma->vm_flags, vma->anon_vma, vma->vm_file,
+					extension_pgoff, vma_policy(vma),
+					vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+			if (!vma) {
 				vm_unacct_memory(pages);
 				ret = -ENOMEM;
 				goto out;
--- a/tools/testing/selftests/vm/mremap_test.c~mm-add-merging-after-mremap-resize
+++ a/tools/testing/selftests/vm/mremap_test.c
@@ -119,6 +119,48 @@ static unsigned long long get_mmap_min_a
 }
 
 /*
+ * This test validates that merge is called when expanding a mapping.
+ * Mapping containing three pages is created, middle page is unmapped
+ * and then the mapping containing the first page is expanded so that
+ * it fills the created hole. The two parts should merge creating
+ * single mapping with three pages.
+ */
+static void mremap_expand_merge(unsigned long page_size)
+{
+	char *test_name = "mremap expand merge";
+	FILE *fp;
+	char *line = NULL;
+	size_t len = 0;
+	bool success = false;
+
+	char *start = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	munmap(start + page_size, page_size);
+	mremap(start, page_size, 2 * page_size, 0);
+
+	fp = fopen("/proc/self/maps", "r");
+	if (fp == NULL) {
+		ksft_test_result_fail("%s\n", test_name);
+		return;
+	}
+
+	while(getline(&line, &len, fp) != -1) {
+		char *first = strtok(line,"- ");
+		void *first_val = (void *) strtol(first, NULL, 16);
+		char *second = strtok(NULL,"- ");
+		void *second_val = (void *) strtol(second, NULL, 16);
+		if (first_val == start && second_val == start + 3 * page_size) {
+			success = true;
+			break;
+		}
+	}
+	if (success)
+		ksft_test_result_pass("%s\n", test_name);
+	else
+		ksft_test_result_fail("%s\n", test_name);
+	fclose(fp);
+}
+
+/*
  * Returns the start address of the mapping on success, else returns
  * NULL on failure.
  */
@@ -336,6 +378,7 @@ int main(int argc, char **argv)
 	int i, run_perf_tests;
 	unsigned int threshold_mb = VALIDATION_DEFAULT_THRESHOLD;
 	unsigned int pattern_seed;
+	int num_expand_tests = 1;
 	struct test test_cases[MAX_TEST];
 	struct test perf_test_cases[MAX_PERF_TEST];
 	int page_size;
@@ -407,12 +450,14 @@ int main(int argc, char **argv)
 				(threshold_mb * _1MB >= _1GB);
 
 	ksft_set_plan(ARRAY_SIZE(test_cases) + (run_perf_tests ?
-		      ARRAY_SIZE(perf_test_cases) : 0));
+		      ARRAY_SIZE(perf_test_cases) : 0) + num_expand_tests);
 
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
 		run_mremap_test_case(test_cases[i], &failures, threshold_mb,
 				     pattern_seed);
 
+	mremap_expand_merge(page_size);
+
 	if (run_perf_tests) {
 		ksft_print_msg("\n%s\n",
 		 "mremap HAVE_MOVE_PMD/PUD optimization time comparison for 1GB region:");
_

Patches currently in -mm which might be from matenajakub@gmail.com are

mm-refactor-of-vma_merge.patch
mm-add-merging-after-mremap-resize.patch

