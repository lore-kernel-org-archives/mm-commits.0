Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D32C433B4
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 287AD60FDB
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhEJEWk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 00:22:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhEJEWk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 00:22:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FA4E60232;
        Mon, 10 May 2021 04:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620620495;
        bh=POnkh985hnAv0ablER1jnwAKbMvFGHvkZaWnXKllI8Y=;
        h=Date:From:To:Subject:From;
        b=ImmxXx33NaWzA2pTDpVzgPj91R45PenMiW4P43W++nm9TUmI8wOXlRnhtui93VpQL
         ae+HHSFeRoMuhYXm+6zxpCid5/tRvoIlYlqNoopMzrxQDk7640HUHPvrcqog7AD6OE
         dgwAmPdVDjL/YLxpcmuTxepmFX1/TLZuBjr3YMFg=
Date:   Sun, 09 May 2021 21:21:33 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, arnd@arndb.de, chris@zankel.net,
        dave.hansen@intel.com, david@redhat.com, deller@gmx.de,
        eike-kernel@sf-tec.de, hughd@google.com, ink@jurassic.park.msu.ru,
        James.Bottomley@HansenPartnership.com, jannh@google.com,
        jcmvbkbc@gmail.com, jgg@ziepe.ca, kirill.shutemov@linux.intel.com,
        linuxram@us.ibm.com, mattst88@gmail.com, mhocko@suse.com,
        mike.kravetz@oracle.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        peterx@redhat.com, riel@surriel.com, rth@twiddle.net,
        shuah@kernel.org, tsbogend@alpha.franken.de, vbabka@suse.cz,
        willy@infradead.org
Subject:  + selftests-vm-add-test-for-madv_populate_readwrite.patch
 added to -mm tree
Message-ID: <20210510042133.cuMw852iz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: add test for MADV_POPULATE_(READ|WRITE)
has been added to the -mm tree.  Its filename is
     selftests-vm-add-test-for-madv_populate_readwrite.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-add-test-for-madv_populate_readwrite.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-add-test-for-madv_populate_readwrite.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests/vm: add test for MADV_POPULATE_(READ|WRITE)

Let's add a simple test for MADV_POPULATE_READ and MADV_POPULATE_WRITE,
verifying some error handling, that population works, and that softdirty
tracking works as expected.  For now, limit the test to private anonymous
memory.

Link: https://lkml.kernel.org/r/20210419135443.12822-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore      |    1 
 tools/testing/selftests/vm/Makefile        |    1 
 tools/testing/selftests/vm/madv_populate.c |  342 +++++++++++++++++++
 tools/testing/selftests/vm/run_vmtests.sh  |   16 
 4 files changed, 360 insertions(+)

--- a/tools/testing/selftests/vm/.gitignore~selftests-vm-add-test-for-madv_populate_readwrite
+++ a/tools/testing/selftests/vm/.gitignore
@@ -14,6 +14,7 @@ transhuge-stress
 protection_keys
 protection_keys_32
 protection_keys_64
+madv_populate
 userfaultfd
 mlock-intersect-test
 mlock-random-test
--- /dev/null
+++ a/tools/testing/selftests/vm/madv_populate.c
@@ -0,0 +1,342 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
+ *
+ * Copyright 2021, Red Hat, Inc.
+ *
+ * Author(s): David Hildenbrand <david@redhat.com>
+ */
+#define _GNU_SOURCE
+#include <stdlib.h>
+#include <string.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <unistd.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <sys/mman.h>
+
+#include "../kselftest.h"
+
+#if defined(MADV_POPULATE_READ) && defined(MADV_POPULATE_WRITE)
+
+/*
+ * For now, we're using 2 MiB of private anonymous memory for all tests.
+ */
+#define SIZE (2 * 1024 * 1024)
+
+static size_t pagesize;
+
+static uint64_t pagemap_get_entry(int fd, char *start)
+{
+	const unsigned long pfn = (unsigned long)start / pagesize;
+	uint64_t entry;
+	int ret;
+
+	ret = pread(fd, &entry, sizeof(entry), pfn * sizeof(entry));
+	if (ret != sizeof(entry))
+		ksft_exit_fail_msg("reading pagemap failed\n");
+	return entry;
+}
+
+static bool pagemap_is_populated(int fd, char *start)
+{
+	uint64_t entry = pagemap_get_entry(fd, start);
+
+	/* Present or swapped. */
+	return entry & 0xc000000000000000ull;
+}
+
+static bool pagemap_is_softdirty(int fd, char *start)
+{
+	uint64_t entry = pagemap_get_entry(fd, start);
+
+	return entry & 0x0080000000000000ull;
+}
+
+static void sense_support(void)
+{
+	char *addr;
+	int ret;
+
+	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (!addr)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	ret = madvise(addr, pagesize, MADV_POPULATE_READ);
+	if (ret)
+		ksft_exit_skip("MADV_POPULATE_READ is not available\n");
+
+	ret = madvise(addr, pagesize, MADV_POPULATE_WRITE);
+	if (ret)
+		ksft_exit_skip("MADV_POPULATE_WRITE is not available\n");
+
+	munmap(addr, pagesize);
+}
+
+static void test_prot_read(void)
+{
+	char *addr;
+	int ret;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	addr = mmap(0, SIZE, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	ret = madvise(addr, SIZE, MADV_POPULATE_READ);
+	ksft_test_result(!ret, "MADV_POPULATE_READ with PROT_READ\n");
+
+	ret = madvise(addr, SIZE, MADV_POPULATE_WRITE);
+	ksft_test_result(ret == -1 && errno == EINVAL,
+			 "MADV_POPULATE_WRITE with PROT_READ\n");
+
+	munmap(addr, SIZE);
+}
+
+static void test_prot_write(void)
+{
+	char *addr;
+	int ret;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	addr = mmap(0, SIZE, PROT_WRITE, MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	ret = madvise(addr, SIZE, MADV_POPULATE_READ);
+	ksft_test_result(ret == -1 && errno == EINVAL,
+			 "MADV_POPULATE_READ with PROT_WRITE\n");
+
+	ret = madvise(addr, SIZE, MADV_POPULATE_WRITE);
+	ksft_test_result(!ret, "MADV_POPULATE_WRITE with PROT_WRITE\n");
+
+	munmap(addr, SIZE);
+}
+
+static void test_holes(void)
+{
+	char *addr;
+	int ret;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	addr = mmap(0, SIZE, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+	ret = munmap(addr + pagesize, pagesize);
+	if (ret)
+		ksft_exit_fail_msg("munmap failed\n");
+
+	/* Hole in the middle */
+	ret = madvise(addr, SIZE, MADV_POPULATE_READ);
+	ksft_test_result(ret == -1 && errno == ENOMEM,
+			 "MADV_POPULATE_READ with holes in the middle\n");
+	ret = madvise(addr, SIZE, MADV_POPULATE_WRITE);
+	ksft_test_result(ret == -1 && errno == ENOMEM,
+			 "MADV_POPULATE_WRITE with holes in the middle\n");
+
+	/* Hole at end */
+	ret = madvise(addr, 2 * pagesize, MADV_POPULATE_READ);
+	ksft_test_result(ret == -1 && errno == ENOMEM,
+			 "MADV_POPULATE_READ with holes at the end\n");
+	ret = madvise(addr, 2 * pagesize, MADV_POPULATE_WRITE);
+	ksft_test_result(ret == -1 && errno == ENOMEM,
+			 "MADV_POPULATE_WRITE with holes at the end\n");
+
+	/* Hole at beginning */
+	ret = madvise(addr + pagesize, pagesize, MADV_POPULATE_READ);
+	ksft_test_result(ret == -1 && errno == ENOMEM,
+			 "MADV_POPULATE_READ with holes at the beginning\n");
+	ret = madvise(addr + pagesize, pagesize, MADV_POPULATE_WRITE);
+	ksft_test_result(ret == -1 && errno == ENOMEM,
+			 "MADV_POPULATE_WRITE with holes at the beginning\n");
+
+	munmap(addr, SIZE);
+}
+
+static bool range_is_populated(char *start, ssize_t size)
+{
+	int fd = open("/proc/self/pagemap", O_RDONLY);
+	bool ret = true;
+
+	if (fd < 0)
+		ksft_exit_fail_msg("opening pagemap failed\n");
+	for (; size > 0 && ret; size -= pagesize, start += pagesize)
+		if (!pagemap_is_populated(fd, start))
+			ret = false;
+	close(fd);
+	return ret;
+}
+
+static bool range_is_not_populated(char *start, ssize_t size)
+{
+	int fd = open("/proc/self/pagemap", O_RDONLY);
+	bool ret = true;
+
+	if (fd < 0)
+		ksft_exit_fail_msg("opening pagemap failed\n");
+	for (; size > 0 && ret; size -= pagesize, start += pagesize)
+		if (pagemap_is_populated(fd, start))
+			ret = false;
+	close(fd);
+	return ret;
+}
+
+static void test_populate_read(void)
+{
+	char *addr;
+	int ret;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	addr = mmap(0, SIZE, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+	ksft_test_result(range_is_not_populated(addr, SIZE),
+			 "range initially not populated\n");
+
+	ret = madvise(addr, SIZE, MADV_POPULATE_READ);
+	ksft_test_result(!ret, "MADV_POPULATE_READ\n");
+	ksft_test_result(range_is_populated(addr, SIZE),
+			 "range is populated\n");
+
+	munmap(addr, SIZE);
+}
+
+static void test_populate_write(void)
+{
+	char *addr;
+	int ret;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	addr = mmap(0, SIZE, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+	ksft_test_result(range_is_not_populated(addr, SIZE),
+			 "range initially not populated\n");
+
+	ret = madvise(addr, SIZE, MADV_POPULATE_WRITE);
+	ksft_test_result(!ret, "MADV_POPULATE_WRITE\n");
+	ksft_test_result(range_is_populated(addr, SIZE),
+			 "range is populated\n");
+
+	munmap(addr, SIZE);
+}
+
+static bool range_is_softdirty(char *start, ssize_t size)
+{
+	int fd = open("/proc/self/pagemap", O_RDONLY);
+	bool ret = true;
+
+	if (fd < 0)
+		ksft_exit_fail_msg("opening pagemap failed\n");
+	for (; size > 0 && ret; size -= pagesize, start += pagesize)
+		if (!pagemap_is_softdirty(fd, start))
+			ret = false;
+	close(fd);
+	return ret;
+}
+
+static bool range_is_not_softdirty(char *start, ssize_t size)
+{
+	int fd = open("/proc/self/pagemap", O_RDONLY);
+	bool ret = true;
+
+	if (fd < 0)
+		ksft_exit_fail_msg("opening pagemap failed\n");
+	for (; size > 0 && ret; size -= pagesize, start += pagesize)
+		if (pagemap_is_softdirty(fd, start))
+			ret = false;
+	close(fd);
+	return ret;
+}
+
+static void clear_softdirty(void)
+{
+	int fd = open("/proc/self/clear_refs", O_WRONLY);
+	const char *ctrl = "4";
+	int ret;
+
+	if (fd < 0)
+		ksft_exit_fail_msg("opening clear_refs failed\n");
+	ret = write(fd, ctrl, strlen(ctrl));
+	if (ret != strlen(ctrl))
+		ksft_exit_fail_msg("writing clear_refs failed\n");
+	close(fd);
+}
+
+static void test_softdirty(void)
+{
+	char *addr;
+	int ret;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	addr = mmap(0, SIZE, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	/* Clear any softdirty bits. */
+	clear_softdirty();
+	ksft_test_result(range_is_not_softdirty(addr, SIZE),
+			 "range is not softdirty\n");
+
+	/* Populating READ should set softdirty. */
+	ret = madvise(addr, SIZE, MADV_POPULATE_READ);
+	ksft_test_result(!ret, "MADV_POPULATE_READ\n");
+	ksft_test_result(range_is_not_softdirty(addr, SIZE),
+			 "range is not softdirty\n");
+
+	/* Populating WRITE should set softdirty. */
+	ret = madvise(addr, SIZE, MADV_POPULATE_WRITE);
+	ksft_test_result(!ret, "MADV_POPULATE_WRITE\n");
+	ksft_test_result(range_is_softdirty(addr, SIZE),
+			 "range is softdirty\n");
+
+	munmap(addr, SIZE);
+}
+
+int main(int argc, char **argv)
+{
+	int err;
+
+	pagesize = getpagesize();
+
+	ksft_print_header();
+	ksft_set_plan(21);
+
+	sense_support();
+	test_prot_read();
+	test_prot_write();
+	test_holes();
+	test_populate_read();
+	test_populate_write();
+	test_softdirty();
+
+	err = ksft_get_fail_cnt();
+	if (err)
+		ksft_exit_fail_msg("%d out of %d tests failed\n",
+				   err, ksft_test_num());
+	return ksft_exit_pass();
+}
+
+#else /* defined(MADV_POPULATE_READ) && defined(MADV_POPULATE_WRITE) */
+
+#warning "missing MADV_POPULATE_READ or MADV_POPULATE_WRITE definition"
+
+int main(int argc, char **argv)
+{
+	ksft_print_header();
+	ksft_exit_skip("MADV_POPULATE_READ or MADV_POPULATE_WRITE not defined\n");
+}
+
+#endif /* defined(MADV_POPULATE_READ) && defined(MADV_POPULATE_WRITE) */
--- a/tools/testing/selftests/vm/Makefile~selftests-vm-add-test-for-madv_populate_readwrite
+++ a/tools/testing/selftests/vm/Makefile
@@ -31,6 +31,7 @@ TEST_GEN_FILES += hmm-tests
 TEST_GEN_FILES += hugepage-mmap
 TEST_GEN_FILES += hugepage-shm
 TEST_GEN_FILES += khugepaged
+TEST_GEN_FILES += madv_populate
 TEST_GEN_FILES += map_fixed_noreplace
 TEST_GEN_FILES += map_hugetlb
 TEST_GEN_FILES += map_populate
--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-add-test-for-madv_populate_readwrite
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -346,4 +346,20 @@ else
 	exitcode=1
 fi
 
+echo "--------------------------------------------------------"
+echo "running MADV_POPULATE_READ and MADV_POPULATE_WRITE tests"
+echo "--------------------------------------------------------"
+./madv_populate
+ret_val=$?
+
+if [ $ret_val -eq 0 ]; then
+	echo "[PASS]"
+elif [ $ret_val -eq $ksft_skip ]; then
+	echo "[SKIP]"
+	exitcode=$ksft_skip
+else
+	echo "[FAIL]"
+	exitcode=1
+fi
+
 exit $exitcode
_

Patches currently in -mm which might be from david@redhat.com are

perf-map_executable-does-not-indicate-vm_mayexec.patch
binfmt-remove-in-tree-usage-of-map_executable.patch
mm-ignore-map_executable-in-ksys_mmap_pgoff.patch
mm-make-variable-names-for-populate_vma_page_range-consistent.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables.patch
maintainers-add-tools-testing-selftests-vm-to-memory-management.patch
selftests-vm-add-protection_keys_32-protection_keys_64-to-gitignore.patch
selftests-vm-add-test-for-madv_populate_readwrite.patch

