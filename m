Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6304FC38145
	for <mm-commits@archiver.kernel.org>; Wed,  7 Sep 2022 22:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiIGWUX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Sep 2022 18:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiIGWUJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Sep 2022 18:20:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C081622BDD
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 15:20:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63D5CB81F27
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 22:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1718DC433D6;
        Wed,  7 Sep 2022 22:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662589205;
        bh=O6diY65EOWo24xCXyYayRN6uZ/3JLYAMg6vvZ6AAINQ=;
        h=Date:To:From:Subject:From;
        b=HtWu7eehf9QNNoX8gW2VVctLRLzS4bCBRm4v525cdWtweD7manqmstbhx3PXPJ69+
         jG6tW5CrLOgKnU3BndfTy7RBveV2rngSgj+Y+mr8GCk80O9UnhbtWnoJgD8wWPqRh0
         9r5V8n4fairfQ9GJg4EtYgqNdDdfrgO6akHZlHiU=
Date:   Wed, 07 Sep 2022 15:20:04 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        songliubraving@fb.com, sj@kernel.org, shy828301@gmail.com,
        rongwei.wang@linux.alibaba.com, rientjes@google.com,
        peterx@redhat.com, pasha.tatashin@soleen.com, minchan@kernel.org,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jthoughton@google.com, hughd@google.com, david@redhat.com,
        ckennelly@google.com, axelrasmussen@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-dedup-thp-helpers.patch added to mm-unstable branch
Message-Id: <20220907222005.1718DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: dedup THP helpers
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-dedup-thp-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-dedup-thp-helpers.patch

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
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: selftests/vm: dedup THP helpers
Date: Wed, 7 Sep 2022 07:45:16 -0700

These files:

tools/testing/selftests/vm/vm_util.c
tools/testing/selftests/vm/khugepaged.c

Both contain logic to:

1) Determine hugepage size on current system
2) Read /proc/self/smaps to determine number of THPs at an address

Refactor selftests/vm/khugepaged.c to use the vm_util common helpers and
add it as a build dependency.

Since selftests/vm/khugepaged.c is the largest user of check_huge(),
change the signature of check_huge() to match selftests/vm/khugepaged.c's
useage: take an expected number of hugepages, and return a bool indicating
if the correct number of hugepages were found.  Add a wrapper,
check_huge_anon(), in anticipation of checking smaps for file and shmem
hugepages.

Update existing callsites to use the new pattern / function.

Likewise, check_for_pattern() was duplicated, and it's a general enough
helper to include in vm_util helpers as well.

Link: https://lkml.kernel.org/r/20220907144521.3115321-6-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile               |    1 
 tools/testing/selftests/vm/khugepaged.c           |   64 +-----------
 tools/testing/selftests/vm/soft-dirty.c           |    2 
 tools/testing/selftests/vm/split_huge_page_test.c |   12 --
 tools/testing/selftests/vm/vm_util.c              |   26 +++-
 tools/testing/selftests/vm/vm_util.h              |    3 
 6 files changed, 32 insertions(+), 76 deletions(-)

--- a/tools/testing/selftests/vm/khugepaged.c~selftests-vm-dedup-thp-helpers
+++ a/tools/testing/selftests/vm/khugepaged.c
@@ -11,6 +11,8 @@
 #include <sys/mman.h>
 #include <sys/wait.h>
 
+#include "vm_util.h"
+
 #ifndef MADV_PAGEOUT
 #define MADV_PAGEOUT 21
 #endif
@@ -351,64 +353,12 @@ static void save_settings(void)
 	signal(SIGQUIT, restore_settings);
 }
 
-#define MAX_LINE_LENGTH 500
-
-static bool check_for_pattern(FILE *fp, char *pattern, char *buf)
-{
-	while (fgets(buf, MAX_LINE_LENGTH, fp) != NULL) {
-		if (!strncmp(buf, pattern, strlen(pattern)))
-			return true;
-	}
-	return false;
-}
-
 static bool check_huge(void *addr, int nr_hpages)
 {
-	bool thp = false;
-	int ret;
-	FILE *fp;
-	char buffer[MAX_LINE_LENGTH];
-	char addr_pattern[MAX_LINE_LENGTH];
-
-	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "%08lx-",
-		       (unsigned long) addr);
-	if (ret >= MAX_LINE_LENGTH) {
-		printf("%s: Pattern is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
-
-
-	fp = fopen(PID_SMAPS, "r");
-	if (!fp) {
-		printf("%s: Failed to open file %s\n", __func__, PID_SMAPS);
-		exit(EXIT_FAILURE);
-	}
-	if (!check_for_pattern(fp, addr_pattern, buffer))
-		goto err_out;
-
-	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "AnonHugePages:%10ld kB",
-		       nr_hpages * (hpage_pmd_size >> 10));
-	if (ret >= MAX_LINE_LENGTH) {
-		printf("%s: Pattern is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
-	/*
-	 * Fetch the AnonHugePages: in the same block and check whether it got
-	 * the expected number of hugeepages next.
-	 */
-	if (!check_for_pattern(fp, "AnonHugePages:", buffer))
-		goto err_out;
-
-	if (strncmp(buffer, addr_pattern, strlen(addr_pattern)))
-		goto err_out;
-
-	thp = true;
-err_out:
-	fclose(fp);
-	return thp;
+	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
 }
 
-
+#define MAX_LINE_LENGTH 500
 static bool check_swap(void *addr, unsigned long size)
 {
 	bool swap = false;
@@ -430,7 +380,7 @@ static bool check_swap(void *addr, unsig
 		printf("%s: Failed to open file %s\n", __func__, PID_SMAPS);
 		exit(EXIT_FAILURE);
 	}
-	if (!check_for_pattern(fp, addr_pattern, buffer))
+	if (!check_for_pattern(fp, addr_pattern, buffer, sizeof(buffer)))
 		goto err_out;
 
 	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "Swap:%19ld kB",
@@ -443,7 +393,7 @@ static bool check_swap(void *addr, unsig
 	 * Fetch the Swap: in the same block and check whether it got
 	 * the expected number of hugeepages next.
 	 */
-	if (!check_for_pattern(fp, "Swap:", buffer))
+	if (!check_for_pattern(fp, "Swap:", buffer, sizeof(buffer)))
 		goto err_out;
 
 	if (strncmp(buffer, addr_pattern, strlen(addr_pattern)))
@@ -1045,7 +995,7 @@ int main(int argc, const char **argv)
 	setbuf(stdout, NULL);
 
 	page_size = getpagesize();
-	hpage_pmd_size = read_num("hpage_pmd_size");
+	hpage_pmd_size = read_pmd_pagesize();
 	hpage_pmd_nr = hpage_pmd_size / page_size;
 
 	default_settings.khugepaged.max_ptes_none = hpage_pmd_nr - 1;
--- a/tools/testing/selftests/vm/Makefile~selftests-vm-dedup-thp-helpers
+++ a/tools/testing/selftests/vm/Makefile
@@ -95,6 +95,7 @@ TEST_FILES += va_128TBswitch.sh
 
 include ../lib.mk
 
+$(OUTPUT)/khugepaged: vm_util.c
 $(OUTPUT)/madv_populate: vm_util.c
 $(OUTPUT)/soft-dirty: vm_util.c
 $(OUTPUT)/split_huge_page_test: vm_util.c
--- a/tools/testing/selftests/vm/soft-dirty.c~selftests-vm-dedup-thp-helpers
+++ a/tools/testing/selftests/vm/soft-dirty.c
@@ -91,7 +91,7 @@ static void test_hugepage(int pagemap_fd
 	for (i = 0; i < hpage_len; i++)
 		map[i] = (char)i;
 
-	if (check_huge(map)) {
+	if (check_huge_anon(map, 1, hpage_len)) {
 		ksft_test_result_pass("Test %s huge page allocation\n", __func__);
 
 		clear_softdirty();
--- a/tools/testing/selftests/vm/split_huge_page_test.c~selftests-vm-dedup-thp-helpers
+++ a/tools/testing/selftests/vm/split_huge_page_test.c
@@ -92,7 +92,6 @@ void split_pmd_thp(void)
 {
 	char *one_page;
 	size_t len = 4 * pmd_pagesize;
-	uint64_t thp_size;
 	size_t i;
 
 	one_page = memalign(pmd_pagesize, len);
@@ -107,8 +106,7 @@ void split_pmd_thp(void)
 	for (i = 0; i < len; i++)
 		one_page[i] = (char)i;
 
-	thp_size = check_huge(one_page);
-	if (!thp_size) {
+	if (!check_huge_anon(one_page, 1, pmd_pagesize)) {
 		printf("No THP is allocated\n");
 		exit(EXIT_FAILURE);
 	}
@@ -124,9 +122,8 @@ void split_pmd_thp(void)
 		}
 
 
-	thp_size = check_huge(one_page);
-	if (thp_size) {
-		printf("Still %ld kB AnonHugePages not split\n", thp_size);
+	if (check_huge_anon(one_page, 0, pmd_pagesize)) {
+		printf("Still AnonHugePages not split\n");
 		exit(EXIT_FAILURE);
 	}
 
@@ -172,8 +169,7 @@ void split_pte_mapped_thp(void)
 	for (i = 0; i < len; i++)
 		one_page[i] = (char)i;
 
-	thp_size = check_huge(one_page);
-	if (!thp_size) {
+	if (!check_huge_anon(one_page, 1, pmd_pagesize)) {
 		printf("No THP is allocated\n");
 		exit(EXIT_FAILURE);
 	}
--- a/tools/testing/selftests/vm/vm_util.c~selftests-vm-dedup-thp-helpers
+++ a/tools/testing/selftests/vm/vm_util.c
@@ -42,9 +42,9 @@ void clear_softdirty(void)
 		ksft_exit_fail_msg("writing clear_refs failed\n");
 }
 
-static bool check_for_pattern(FILE *fp, const char *pattern, char *buf)
+bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len)
 {
-	while (fgets(buf, MAX_LINE_LENGTH, fp) != NULL) {
+	while (fgets(buf, len, fp)) {
 		if (!strncmp(buf, pattern, strlen(pattern)))
 			return true;
 	}
@@ -72,9 +72,10 @@ uint64_t read_pmd_pagesize(void)
 	return strtoul(buf, NULL, 10);
 }
 
-uint64_t check_huge(void *addr)
+bool __check_huge(void *addr, char *pattern, int nr_hpages,
+		  uint64_t hpage_size)
 {
-	uint64_t thp = 0;
+	uint64_t thp = -1;
 	int ret;
 	FILE *fp;
 	char buffer[MAX_LINE_LENGTH];
@@ -89,20 +90,27 @@ uint64_t check_huge(void *addr)
 	if (!fp)
 		ksft_exit_fail_msg("%s: Failed to open file %s\n", __func__, SMAP_FILE_PATH);
 
-	if (!check_for_pattern(fp, addr_pattern, buffer))
+	if (!check_for_pattern(fp, addr_pattern, buffer, sizeof(buffer)))
 		goto err_out;
 
 	/*
-	 * Fetch the AnonHugePages: in the same block and check the number of
+	 * Fetch the pattern in the same block and check the number of
 	 * hugepages.
 	 */
-	if (!check_for_pattern(fp, "AnonHugePages:", buffer))
+	if (!check_for_pattern(fp, pattern, buffer, sizeof(buffer)))
 		goto err_out;
 
-	if (sscanf(buffer, "AnonHugePages:%10ld kB", &thp) != 1)
+	snprintf(addr_pattern, MAX_LINE_LENGTH, "%s%%9ld kB", pattern);
+
+	if (sscanf(buffer, addr_pattern, &thp) != 1)
 		ksft_exit_fail_msg("Reading smap error\n");
 
 err_out:
 	fclose(fp);
-	return thp;
+	return thp == (nr_hpages * (hpage_size >> 10));
+}
+
+bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size)
+{
+	return __check_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
 }
--- a/tools/testing/selftests/vm/vm_util.h~selftests-vm-dedup-thp-helpers
+++ a/tools/testing/selftests/vm/vm_util.h
@@ -5,5 +5,6 @@
 uint64_t pagemap_get_entry(int fd, char *start);
 bool pagemap_is_softdirty(int fd, char *start);
 void clear_softdirty(void);
+bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
 uint64_t read_pmd_pagesize(void);
-uint64_t check_huge(void *addr);
+bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size);
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-add-struct-collapse_control.patch
mm-khugepaged-add-struct-collapse_control-fix.patch
mm-khugepaged-add-struct-collapse_control-fix-fix-fix.patch
mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging.patch
mm-khugepaged-pipe-enum-scan_result-codes-back-to-callers.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch
mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior-fix.patch
mm-khugepaged-record-scan_pmd_mapped-when-scan_pmd-finds-hugepage.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-2.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-3.patch
mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch
mm-madvise-add-madv_collapse-to-process_madvise.patch
mm-madvise-add-madv_collapse-to-process_madvise-fix.patch
selftests-vm-modularize-collapse-selftests.patch
selftests-vm-dedup-hugepage-allocation-logic.patch
selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch
selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch
selftests-vm-add-selftest-to-verify-multi-thp-collapse.patch
mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check.patch
mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds.patch
mm-madvise-add-file-and-shmem-support-to-madv_collapse.patch
mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file.patch
selftests-vm-dedup-thp-helpers.patch
selftests-vm-modularize-thp-collapse-memory-operations.patch
selftests-vm-add-thp-collapse-file-and-tmpfs-testing.patch
selftests-vm-add-thp-collapse-shmem-testing.patch
selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd.patch
selftests-vm-add-selftest-for-madv_collapse-of-uffd-minor-memory.patch

