Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2406BC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbiEJEQy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235949AbiEJEQW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C302EA23
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0DABB81AEF
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5851DC385A6;
        Tue, 10 May 2022 04:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155905;
        bh=fQOx8iZzNYvYDYt4yVEwvjJX+um4WaHfG302CBnf6yA=;
        h=Date:To:From:Subject:From;
        b=rl4HOxuqCMmxwKaUJfOS+Iw15yiBq/0DFSd4xA3q9v5rOIwLKHW/5qFUPhrZVPYUD
         KKcTW/EcS7iaoHEcUtt0hD8yaQW9nlIXSqiir2goPW2FPIh9zD/Cvh4211g/izPxjf
         gFEvOmGZNiTu+EMGvBuEEXCr2C7t4OEjJze2Pb4s=
Date:   Mon, 09 May 2022 21:11:44 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, shuah@kernel.org,
        krisman@collabora.com, david@redhat.com, usama.anjum@collabora.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-bring-common-functions-to-a-new-file.patch removed from -mm tree
Message-Id: <20220510041145.5851DC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: vm: bring common functions to a new file
has been removed from the -mm tree.  Its filename was
     selftests-vm-bring-common-functions-to-a-new-file.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: vm: bring common functions to a new file

Bring common functions to a new file while keeping code as much same as
possible.  These functions can be used in the new tests.  This helps in
avoiding code duplication.

Link: https://lkml.kernel.org/r/20220420084036.4101604-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile               |    7 
 tools/testing/selftests/vm/madv_populate.c        |   34 ---
 tools/testing/selftests/vm/split_huge_page_test.c |   79 --------
 tools/testing/selftests/vm/vm_util.c              |  108 ++++++++++++
 tools/testing/selftests/vm/vm_util.h              |    9 +
 5 files changed, 124 insertions(+), 113 deletions(-)

--- a/tools/testing/selftests/vm/madv_populate.c~selftests-vm-bring-common-functions-to-a-new-file
+++ a/tools/testing/selftests/vm/madv_populate.c
@@ -18,6 +18,7 @@
 #include <sys/mman.h>
 
 #include "../kselftest.h"
+#include "vm_util.h"
 
 /*
  * For now, we're using 2 MiB of private anonymous memory for all tests.
@@ -26,18 +27,6 @@
 
 static size_t pagesize;
 
-static uint64_t pagemap_get_entry(int fd, char *start)
-{
-	const unsigned long pfn = (unsigned long)start / pagesize;
-	uint64_t entry;
-	int ret;
-
-	ret = pread(fd, &entry, sizeof(entry), pfn * sizeof(entry));
-	if (ret != sizeof(entry))
-		ksft_exit_fail_msg("reading pagemap failed\n");
-	return entry;
-}
-
 static bool pagemap_is_populated(int fd, char *start)
 {
 	uint64_t entry = pagemap_get_entry(fd, start);
@@ -46,13 +35,6 @@ static bool pagemap_is_populated(int fd,
 	return entry & 0xc000000000000000ull;
 }
 
-static bool pagemap_is_softdirty(int fd, char *start)
-{
-	uint64_t entry = pagemap_get_entry(fd, start);
-
-	return entry & 0x0080000000000000ull;
-}
-
 static void sense_support(void)
 {
 	char *addr;
@@ -258,20 +240,6 @@ static bool range_is_not_softdirty(char
 	return ret;
 }
 
-static void clear_softdirty(void)
-{
-	int fd = open("/proc/self/clear_refs", O_WRONLY);
-	const char *ctrl = "4";
-	int ret;
-
-	if (fd < 0)
-		ksft_exit_fail_msg("opening clear_refs failed\n");
-	ret = write(fd, ctrl, strlen(ctrl));
-	if (ret != strlen(ctrl))
-		ksft_exit_fail_msg("writing clear_refs failed\n");
-	close(fd);
-}
-
 static void test_softdirty(void)
 {
 	char *addr;
--- a/tools/testing/selftests/vm/Makefile~selftests-vm-bring-common-functions-to-a-new-file
+++ a/tools/testing/selftests/vm/Makefile
@@ -36,7 +36,7 @@ TEST_GEN_FILES += hugepage-mremap
 TEST_GEN_FILES += hugepage-shm
 TEST_GEN_FILES += hugepage-vmemmap
 TEST_GEN_FILES += khugepaged
-TEST_GEN_FILES += madv_populate
+TEST_GEN_PROGS = madv_populate
 TEST_GEN_FILES += map_fixed_noreplace
 TEST_GEN_FILES += map_hugetlb
 TEST_GEN_FILES += map_populate
@@ -50,7 +50,7 @@ TEST_GEN_FILES += on-fault-limit
 TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += userfaultfd
-TEST_GEN_FILES += split_huge_page_test
+TEST_GEN_PROGS += split_huge_page_test
 TEST_GEN_FILES += ksm_tests
 
 ifeq ($(MACHINE),x86_64)
@@ -94,6 +94,9 @@ TEST_FILES := test_vmalloc.sh
 KSFT_KHDR_INSTALL := 1
 include ../lib.mk
 
+$(OUTPUT)/madv_populate: vm_util.c
+$(OUTPUT)/split_huge_page_test: vm_util.c
+
 ifeq ($(MACHINE),x86_64)
 BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
 BINARIES_64 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_64))
--- a/tools/testing/selftests/vm/split_huge_page_test.c~selftests-vm-bring-common-functions-to-a-new-file
+++ a/tools/testing/selftests/vm/split_huge_page_test.c
@@ -16,14 +16,13 @@
 #include <sys/mount.h>
 #include <malloc.h>
 #include <stdbool.h>
+#include "vm_util.h"
 
 uint64_t pagesize;
 unsigned int pageshift;
 uint64_t pmd_pagesize;
 
-#define PMD_SIZE_PATH "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
 #define SPLIT_DEBUGFS "/sys/kernel/debug/split_huge_pages"
-#define SMAP_PATH "/proc/self/smaps"
 #define INPUT_MAX 80
 
 #define PID_FMT "%d,0x%lx,0x%lx"
@@ -51,30 +50,6 @@ int is_backed_by_thp(char *vaddr, int pa
 	return 0;
 }
 
-
-static uint64_t read_pmd_pagesize(void)
-{
-	int fd;
-	char buf[20];
-	ssize_t num_read;
-
-	fd = open(PMD_SIZE_PATH, O_RDONLY);
-	if (fd == -1) {
-		perror("Open hpage_pmd_size failed");
-		exit(EXIT_FAILURE);
-	}
-	num_read = read(fd, buf, 19);
-	if (num_read < 1) {
-		close(fd);
-		perror("Read hpage_pmd_size failed");
-		exit(EXIT_FAILURE);
-	}
-	buf[num_read] = '\0';
-	close(fd);
-
-	return strtoul(buf, NULL, 10);
-}
-
 static int write_file(const char *path, const char *buf, size_t buflen)
 {
 	int fd;
@@ -113,58 +88,6 @@ static void write_debugfs(const char *fm
 	}
 }
 
-#define MAX_LINE_LENGTH 500
-
-static bool check_for_pattern(FILE *fp, const char *pattern, char *buf)
-{
-	while (fgets(buf, MAX_LINE_LENGTH, fp) != NULL) {
-		if (!strncmp(buf, pattern, strlen(pattern)))
-			return true;
-	}
-	return false;
-}
-
-static uint64_t check_huge(void *addr)
-{
-	uint64_t thp = 0;
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
-	fp = fopen(SMAP_PATH, "r");
-	if (!fp) {
-		printf("%s: Failed to open file %s\n", __func__, SMAP_PATH);
-		exit(EXIT_FAILURE);
-	}
-	if (!check_for_pattern(fp, addr_pattern, buffer))
-		goto err_out;
-
-	/*
-	 * Fetch the AnonHugePages: in the same block and check the number of
-	 * hugepages.
-	 */
-	if (!check_for_pattern(fp, "AnonHugePages:", buffer))
-		goto err_out;
-
-	if (sscanf(buffer, "AnonHugePages:%10ld kB", &thp) != 1) {
-		printf("Reading smap error\n");
-		exit(EXIT_FAILURE);
-	}
-
-err_out:
-	fclose(fp);
-	return thp;
-}
-
 void split_pmd_thp(void)
 {
 	char *one_page;
--- /dev/null
+++ a/tools/testing/selftests/vm/vm_util.c
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <string.h>
+#include <fcntl.h>
+#include "../kselftest.h"
+#include "vm_util.h"
+
+#define PMD_SIZE_FILE_PATH "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
+#define SMAP_FILE_PATH "/proc/self/smaps"
+#define MAX_LINE_LENGTH 500
+
+uint64_t pagemap_get_entry(int fd, char *start)
+{
+	const unsigned long pfn = (unsigned long)start / getpagesize();
+	uint64_t entry;
+	int ret;
+
+	ret = pread(fd, &entry, sizeof(entry), pfn * sizeof(entry));
+	if (ret != sizeof(entry))
+		ksft_exit_fail_msg("reading pagemap failed\n");
+	return entry;
+}
+
+bool pagemap_is_softdirty(int fd, char *start)
+{
+	uint64_t entry = pagemap_get_entry(fd, start);
+
+	// Check if dirty bit (55th bit) is set
+	return entry & 0x0080000000000000ull;
+}
+
+void clear_softdirty(void)
+{
+	int ret;
+	const char *ctrl = "4";
+	int fd = open("/proc/self/clear_refs", O_WRONLY);
+
+	if (fd < 0)
+		ksft_exit_fail_msg("opening clear_refs failed\n");
+	ret = write(fd, ctrl, strlen(ctrl));
+	close(fd);
+	if (ret != strlen(ctrl))
+		ksft_exit_fail_msg("writing clear_refs failed\n");
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
+uint64_t read_pmd_pagesize(void)
+{
+	int fd;
+	char buf[20];
+	ssize_t num_read;
+
+	fd = open(PMD_SIZE_FILE_PATH, O_RDONLY);
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
+uint64_t check_huge(void *addr)
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
+		ksft_exit_fail_msg("%s: Pattern is too long\n", __func__);
+
+	fp = fopen(SMAP_FILE_PATH, "r");
+	if (!fp)
+		ksft_exit_fail_msg("%s: Failed to open file %s\n", __func__, SMAP_FILE_PATH);
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
+		ksft_exit_fail_msg("Reading smap error\n");
+
+err_out:
+	fclose(fp);
+	return thp;
+}
--- /dev/null
+++ a/tools/testing/selftests/vm/vm_util.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <stdint.h>
+#include <stdbool.h>
+
+uint64_t pagemap_get_entry(int fd, char *start);
+bool pagemap_is_softdirty(int fd, char *start);
+void clear_softdirty(void);
+uint64_t read_pmd_pagesize(void);
+uint64_t check_huge(void *addr);
_

Patches currently in -mm which might be from usama.anjum@collabora.com are


