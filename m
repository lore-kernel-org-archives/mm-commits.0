Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB8DC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 20 Apr 2022 21:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382760AbiDTWCo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Apr 2022 18:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382785AbiDTWCj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Apr 2022 18:02:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD281027
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 14:59:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FCFDB821B3
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 21:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAD2C385A0;
        Wed, 20 Apr 2022 21:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650491989;
        bh=oxvNH4QEr+hNwEb+5+BQJbnRMJ199K6nkoxoMxfqmEE=;
        h=Date:To:From:Subject:From;
        b=WGsBeI/ZR+N0ZLV+9OlQVWv/qEML2bpG/WQa8q9XVI8vaT2lq22POXfgW3FUUG3eE
         Y0eUB8Qjg/nYl69/mdX4DhrnG+e+iW8usc2u0jZUx+IFeGaMBAeWxTEEDqeNPKICVx
         VthKo0yzUccEQinF01pv3gp/RC10i6HUP2NUcz9E=
Date:   Wed, 20 Apr 2022 14:59:48 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        usama.anjum@collabora.com, shuah@kernel.org, krisman@collabora.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-add-test-for-soft-dirty-pte-bit.patch added to -mm tree
Message-Id: <20220420215949.0BAD2C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: add test for Soft-Dirty PTE bit
has been added to the -mm tree.  Its filename is
     selftests-vm-add-test-for-soft-dirty-pte-bit.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-add-test-for-soft-dirty-pte-bit.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-add-test-for-soft-dirty-pte-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: selftests: vm: add test for Soft-Dirty PTE bit

This introduces three tests:

1) Sanity check soft dirty basic semantics: allocate area, clean,
   dirty, check if the SD bit is flipped.

2) Check VMA reuse: validate the VM_SOFTDIRTY usage

3) Check soft-dirty on huge pages

This was motivated by Will Deacon's fix commit 912efa17e512 ("mm: proc:
Invalidate TLB after clearing soft-dirty page state").  I was tracking the
same issue that he fixed, and this test would have caught it.

Link: https://lkml.kernel.org/r/20220420084036.4101604-2-usama.anjum@collabora.com
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Co-developed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Will Deacon <will@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore   |    1 
 tools/testing/selftests/vm/Makefile     |    2 
 tools/testing/selftests/vm/config       |    2 
 tools/testing/selftests/vm/soft-dirty.c |  145 ++++++++++++++++++++++
 4 files changed, 150 insertions(+)

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
@@ -49,6 +49,7 @@ TEST_GEN_FILES += on-fault-limit
 TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += userfaultfd
+TEST_GEN_PROGS += soft-dirty
 TEST_GEN_PROGS += split_huge_page_test
 TEST_GEN_FILES += ksm_tests
 
@@ -94,6 +95,7 @@ KSFT_KHDR_INSTALL := 1
 include ../lib.mk
 
 $(OUTPUT)/madv_populate: vm_util.c
+$(OUTPUT)/soft-dirty: vm_util.c
 $(OUTPUT)/split_huge_page_test: vm_util.c
 
 ifeq ($(MACHINE),x86_64)
--- /dev/null
+++ a/tools/testing/selftests/vm/soft-dirty.c
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdio.h>
+#include <string.h>
+#include <stdbool.h>
+#include <fcntl.h>
+#include <stdint.h>
+#include <malloc.h>
+#include <sys/mman.h>
+#include "../kselftest.h"
+#include "vm_util.h"
+
+#define PAGEMAP_FILE_PATH "/proc/self/pagemap"
+#define TEST_ITERATIONS 10000
+
+static void test_simple(int pagemap_fd, int pagesize)
+{
+	int i;
+	char *map;
+
+	map = aligned_alloc(pagesize, pagesize);
+	if (!map)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	clear_softdirty();
+
+	for (i = 0 ; i < TEST_ITERATIONS; i++) {
+		if (pagemap_is_softdirty(pagemap_fd, map) == 1) {
+			ksft_print_msg("dirty bit was 1, but should be 0 (i=%d)\n", i);
+			break;
+		}
+
+		clear_softdirty();
+		// Write something to the page to get the dirty bit enabled on the page
+		map[0]++;
+
+		if (pagemap_is_softdirty(pagemap_fd, map) == 0) {
+			ksft_print_msg("dirty bit was 0, but should be 1 (i=%d)\n", i);
+			break;
+		}
+
+		clear_softdirty();
+	}
+	free(map);
+
+	ksft_test_result(i == TEST_ITERATIONS, "Test %s\n", __func__);
+}
+
+static void test_vma_reuse(int pagemap_fd, int pagesize)
+{
+	char *map, *map2;
+
+	map = mmap(NULL, pagesize, (PROT_READ | PROT_WRITE), (MAP_PRIVATE | MAP_ANON), -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed");
+
+	// The kernel always marks new regions as soft dirty
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map) == 1,
+			 "Test %s dirty bit of allocated page\n", __func__);
+
+	clear_softdirty();
+	munmap(map, pagesize);
+
+	map2 = mmap(NULL, pagesize, (PROT_READ | PROT_WRITE), (MAP_PRIVATE | MAP_ANON), -1, 0);
+	if (map2 == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed");
+
+	// Dirty bit is set for new regions even if they are reused
+	if (map == map2)
+		ksft_test_result(pagemap_is_softdirty(pagemap_fd, map2) == 1,
+				 "Test %s dirty bit of reused address page\n", __func__);
+	else
+		ksft_test_result_skip("Test %s dirty bit of reused address page\n", __func__);
+
+	munmap(map2, pagesize);
+}
+
+static void test_hugepage(int pagemap_fd, int pagesize)
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
+	if (check_huge(map)) {
+		ksft_test_result_pass("Test %s huge page allocation\n", __func__);
+
+		clear_softdirty();
+		for (i = 0 ; i < TEST_ITERATIONS ; i++) {
+			if (pagemap_is_softdirty(pagemap_fd, map) == 1) {
+				ksft_print_msg("dirty bit was 1, but should be 0 (i=%d)\n", i);
+				break;
+			}
+
+			clear_softdirty();
+			// Write something to the page to get the dirty bit enabled on the page
+			map[0]++;
+
+			if (pagemap_is_softdirty(pagemap_fd, map) == 0) {
+				ksft_print_msg("dirty bit was 0, but should be 1 (i=%d)\n", i);
+				break;
+			}
+			clear_softdirty();
+		}
+
+		ksft_test_result(i == TEST_ITERATIONS, "Test %s huge page dirty bit\n", __func__);
+	} else {
+		// hugepage allocation failed. skip these tests
+		ksft_test_result_skip("Test %s huge page allocation\n", __func__);
+		ksft_test_result_skip("Test %s huge page dirty bit\n", __func__);
+	}
+	free(map);
+}
+
+int main(int argc, char **argv)
+{
+	int pagemap_fd;
+	int pagesize;
+
+	ksft_print_header();
+	ksft_set_plan(5);
+
+	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_msg("Failed to open %s\n", PAGEMAP_FILE_PATH);
+
+	pagesize = getpagesize();
+
+	test_simple(pagemap_fd, pagesize);
+	test_vma_reuse(pagemap_fd, pagesize);
+	test_hugepage(pagemap_fd, pagesize);
+
+	close(pagemap_fd);
+
+	return ksft_exit_pass();
+}
_

Patches currently in -mm which might be from krisman@collabora.com are

selftests-vm-add-test-for-soft-dirty-pte-bit.patch

