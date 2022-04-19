Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11C4C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 03:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbiDSDrl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Apr 2022 23:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348172AbiDSDri (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Apr 2022 23:47:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287B42AE3
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 20:44:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACFE061137
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 03:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC72EC385A7;
        Tue, 19 Apr 2022 03:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650339895;
        bh=l60h2ZDSQGbdwpc3y2EcnJ24GXmDoLHK0SB6iG26e6w=;
        h=Date:To:From:Subject:From;
        b=wFSnBDWFSyaJuyQedqXc4ofHSGsRqTwQMzr+Wp+eiLO6HKh2dts7nN7ouWaVlpOl1
         IoMGlU1St6GTawT5sCuYiHHpleTTLGRFOkV+nebDHwlBqnwUYJmir63HFIfmx9TuFA
         7pSde4YXlPrrpPmjLRqw+vs7SS49n4Yz1zNPsH4s=
Date:   Mon, 18 Apr 2022 20:44:54 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, shuah@kernel.org,
        krisman@collabora.com, usama.anjum@collabora.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] selftests-vm-add-test-for-soft-dirty-pte-bit.patch removed from -mm tree
Message-Id: <20220419034454.EC72EC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: add test for Soft-Dirty PTE bit
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-test-for-soft-dirty-pte-bit.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: vm: add test for Soft-Dirty PTE bit

This introduces three tests:
1) Sanity check soft dirty basic semantics: allocate area, clean, dirty,
check if the SD bit flipped.
2) Check VMA reuse: validate the VM_SOFTDIRTY usage
3) Check soft-dirty on huge pages

This was motivated by Will Deacon's fix commit 912efa17e512 ("mm: proc:
Invalidate TLB after clearing soft-dirty page state").  I was tracking the
same issue that he fixed, and this test would have caught it.

Link: https://lkml.kernel.org/r/20220224212335.3045905-1-usama.anjum@collabora.com
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Will Deacon <will@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore   |    1 
 tools/testing/selftests/vm/Makefile     |    1 
 tools/testing/selftests/vm/config       |    2 
 tools/testing/selftests/vm/soft-dirty.c |  238 ++++++++++++++++++++++
 4 files changed, 242 insertions(+)

--- a/tools/testing/selftests/vm/config~selftests-vm-add-test-for-soft-dirty-pte-bit
+++ a/tools/testing/selftests/vm/config
@@ -4,3 +4,5 @@ CONFIG_TEST_VMALLOC=m
 CONFIG_DEVICE_PRIVATE=y
 CONFIG_TEST_HMM=m
 CONFIG_GUP_TEST=y
+CONFIG_TRANSPARENT_HUGEPAGE=y
+CONFIG_MEM_SOFT_DIRTY=y
--- a/tools/testing/selftests/vm/.gitignore~selftests-vm-add-test-for-soft-dirty-pte-bit
+++ a/tools/testing/selftests/vm/.gitignore
@@ -29,5 +29,6 @@ write_to_hugetlbfs
 hmm-tests
 memfd_secret
 local_config.*
+soft-dirty
 split_huge_page_test
 ksm_tests
--- a/tools/testing/selftests/vm/Makefile~selftests-vm-add-test-for-soft-dirty-pte-bit
+++ a/tools/testing/selftests/vm/Makefile
@@ -50,6 +50,7 @@ TEST_GEN_FILES += on-fault-limit
 TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += userfaultfd
+TEST_GEN_FILES += soft-dirty
 TEST_GEN_FILES += split_huge_page_test
 TEST_GEN_FILES += ksm_tests
 
--- /dev/null
+++ a/tools/testing/selftests/vm/soft-dirty.c
@@ -0,0 +1,238 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdio.h>
+#include <string.h>
+#include <stdbool.h>
+#include <fcntl.h>
+#include <stdint.h>
+#include <malloc.h>
+#include <sys/mman.h>
+#include "../kselftest.h"
+
+#define PAGEMAP_PATH		"/proc/self/pagemap"
+#define CLEAR_REFS_PATH		"/proc/self/clear_refs"
+#define SMAP_PATH		"/proc/self/smaps"
+#define PMD_SIZE_PATH		"/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
+#define MAX_LINE_LENGTH		512
+#define TEST_ITERATIONS		10000
+#define PAGE_NUM_TO_TEST	2
+
+int clear_refs;
+int pagemap;
+
+int pagesize;
+int mmap_size;	/* Size of test region */
+
+static void clear_all_refs(void)
+{
+	const char *ctrl = "4";
+
+	if (write(clear_refs, ctrl, strlen(ctrl)) != strlen(ctrl))
+		ksft_exit_fail_msg("%s: failed to clear references\n", __func__);
+}
+
+static void touch_page(char *map, int n)
+{
+	map[(pagesize * n) + 1]++;
+}
+
+static int check_page(char *start, int page_num, int clear)
+{
+	unsigned long pfn = (unsigned long)start / pagesize;
+	uint64_t entry;
+	int ret;
+
+	ret = pread(pagemap, &entry, sizeof(entry), (pfn + page_num) * sizeof(entry));
+	if (ret != sizeof(entry))
+		ksft_exit_fail_msg("reading pagemap failed\n");
+	if (clear)
+		clear_all_refs();
+
+	return ((entry >> 55) & 1);
+}
+
+static void test_simple(void)
+{
+	int i;
+	char *map;
+
+	map = aligned_alloc(pagesize, mmap_size);
+	if (!map)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	clear_all_refs();
+
+	for (i = 0 ; i < TEST_ITERATIONS; i++) {
+		if (check_page(map, PAGE_NUM_TO_TEST, 1) == 1) {
+			ksft_print_msg("dirty bit was 1, but should be 0 (i=%d)\n", i);
+			break;
+		}
+
+		touch_page(map, 2);
+
+		if (check_page(map, PAGE_NUM_TO_TEST, 1) == 0) {
+			ksft_print_msg("dirty bit was 0, but should be 1 (i=%d)\n", i);
+			break;
+		}
+
+	}
+	free(map);
+
+	ksft_test_result(i == TEST_ITERATIONS, "Test %s\n", __func__);
+}
+
+static void test_vma_reuse(void)
+{
+	char *map, *map2;
+
+	map = (char *) 0x900000000000;
+	map = mmap(map, mmap_size, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANON, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed");
+
+	clear_all_refs();
+	touch_page(map, PAGE_NUM_TO_TEST);
+
+	munmap(map, mmap_size);
+	map2 = mmap(map, mmap_size, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANON, -1, 0);
+	if (map2 == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed");
+
+	ksft_test_result(map == map2, "Test %s reused memory location\n", __func__);
+
+	ksft_test_result(check_page(map, PAGE_NUM_TO_TEST, 1) != 0,
+			 "Test %s dirty bit of previous page\n", __func__);
+
+	munmap(map2, mmap_size);
+}
+
+/*
+ * read_pmd_pagesize(), check_for_pattern() and check_huge() adapted
+ * from 'tools/testing/selftest/vm/split_huge_page_test.c'
+ */
+static uint64_t read_pmd_pagesize(void)
+{
+	int fd;
+	char buf[20];
+	ssize_t num_read;
+
+	fd = open(PMD_SIZE_PATH, O_RDONLY);
+	if (fd == -1)
+		ksft_exit_fail_msg("Open hpage_pmd_size failed\n");
+
+	num_read = read(fd, buf, 19);
+	if (num_read < 1) {
+		close(fd);
+		ksft_exit_fail_msg("Read hpage_pmd_size failed\n");
+	}
+	buf[num_read] = '\0';
+	close(fd);
+
+	return strtoul(buf, NULL, 10);
+}
+
+static bool check_for_pattern(FILE *fp, const char *pattern, char *buf)
+{
+	while (fgets(buf, MAX_LINE_LENGTH, fp) != NULL) {
+		if (!strncmp(buf, pattern, strlen(pattern)))
+			return true;
+	}
+	return false;
+}
+
+static uint64_t check_huge(void *addr)
+{
+	uint64_t thp = 0;
+	int ret;
+	FILE *fp;
+	char buffer[MAX_LINE_LENGTH];
+	char addr_pattern[MAX_LINE_LENGTH];
+
+	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "%08lx-",
+		       (unsigned long) addr);
+	if (ret >= MAX_LINE_LENGTH)
+		ksft_print_msg("%s: Pattern is too long\n", __func__);
+
+	fp = fopen(SMAP_PATH, "r");
+	if (!fp)
+		ksft_print_msg("%s: Failed to open file %s\n", __func__, SMAP_PATH);
+
+	if (!check_for_pattern(fp, addr_pattern, buffer))
+		goto err_out;
+
+	/*
+	 * Fetch the AnonHugePages: in the same block and check the number of
+	 * hugepages.
+	 */
+	if (!check_for_pattern(fp, "AnonHugePages:", buffer))
+		goto err_out;
+
+	if (sscanf(buffer, "AnonHugePages:%10ld kB", &thp) != 1)
+		ksft_print_msg("Reading smap error\n");
+
+err_out:
+	fclose(fp);
+
+	return thp;
+}
+
+static void test_hugepage(void)
+{
+	char *map;
+	int i, ret;
+	size_t hpage_len = read_pmd_pagesize();
+
+	map = memalign(hpage_len, hpage_len);
+	if (!map)
+		ksft_exit_fail_msg("memalign failed\n");
+
+	ret = madvise(map, hpage_len, MADV_HUGEPAGE);
+	if (ret)
+		ksft_exit_fail_msg("madvise failed %d\n", ret);
+
+	for (i = 0; i < hpage_len; i++)
+		map[i] = (char)i;
+
+	ksft_test_result(check_huge(map), "Test %s huge page allocation\n", __func__);
+
+	clear_all_refs();
+	for (i = 0 ; i < TEST_ITERATIONS ; i++) {
+		if (check_page(map, PAGE_NUM_TO_TEST, 1) == 1) {
+			ksft_print_msg("dirty bit was 1, but should be 0 (i=%d)\n", i);
+			break;
+		}
+
+		touch_page(map, PAGE_NUM_TO_TEST);
+
+		if (check_page(map, PAGE_NUM_TO_TEST, 1) == 0) {
+			ksft_print_msg("dirty bit was 0, but should be 1 (i=%d)\n", i);
+			break;
+		}
+	}
+
+	ksft_test_result(i == TEST_ITERATIONS, "Test %s dirty bit\n", __func__);
+
+	munmap(map, mmap_size);
+}
+
+int main(int argc, char **argv)
+{
+	ksft_print_header();
+	ksft_set_plan(5);
+
+	pagemap = open(PAGEMAP_PATH, O_RDONLY);
+	if (pagemap < 0)
+		ksft_exit_fail_msg("Failed to open %s\n", PAGEMAP_PATH);
+
+	clear_refs = open(CLEAR_REFS_PATH, O_WRONLY);
+	if (clear_refs < 0)
+		ksft_exit_fail_msg("Failed to open %s\n", CLEAR_REFS_PATH);
+
+	pagesize = getpagesize();
+	mmap_size = 10 * pagesize;
+
+	test_simple();
+	test_vma_reuse();
+	test_hugepage();
+
+	return ksft_exit_pass();
+}
_

Patches currently in -mm which might be from usama.anjum@collabora.com are


