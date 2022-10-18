Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F628C43219
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiJRBIt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiJRBIZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:08:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42A98C46D
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:08:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC5EA61346
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3726AC433D6;
        Tue, 18 Oct 2022 01:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666055300;
        bh=DSIyODwxRVK6I8N4Ws5k5qnt4QqnKPAiHCCwAUhMdUo=;
        h=Date:To:From:Subject:From;
        b=dGmUMKMvZuNNXffuKPdUKyqL3aleRqT2MnFIWUUAfNy+UItPrDOfxax0NOlhyj6+l
         Iyy6dwIEMoNCAnEzJwRKSV9Cf6wvwdM/C4iN5ftxj9Yd/n9vfrogAqYFYuJKg1iDRo
         iECQI4kkijMdlYdmpRQ2RSlA5btIEcck7UalKHng=
Date:   Mon, 17 Oct 2022 18:08:19 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shuah@kernel.org,
        rppt@kernel.org, peterx@redhat.com, namit@vmware.com,
        jhubbard@nvidia.com, jgg@nvidia.com, ddutile@redhat.com,
        crecklin@redhat.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory.patch added to mm-unstable branch
Message-Id: <20221018010820.3726AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: anon_cow: test COW handling of anonymous memory
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: selftests/vm: anon_cow: test COW handling of anonymous memory
Date: Tue, 27 Sep 2022 13:01:14 +0200

Patch series "selftests/vm: test COW handling of anonymous memory".

This is my current set of tests for testing COW handling of anonymous
memory, especially when interacting with GUP.  I developed these tests
while working on PageAnonExclusive and managed to clean them up just now.

On current upstream Linux, all tests pass except the hugetlb tests that
rely on vmsplice -- these tests should pass as soon as vmsplice properly
uses FOLL_PIN instead of FOLL_GET.

I'm working on additional tests for COW handling in private mappings,
focusing on long-term R/O pinning e.g., of the shared zeropage, pagecache
pages and KSM pages.  These tests, however, will go into a different file.
So this is everything I have regarding tests for anonymous memory.


This patch (of 7):

Let's start adding tests for our COW handling of anonymous memory.  We'll
focus on basic tests that we can achieve without additional libraries or
gup_test extensions.

We'll add THP and hugetlb tests separately.

Link: https://lkml.kernel.org/r/20220927110120.106906-1-david@redhat.com
Link: https://lkml.kernel.org/r/20220927110120.106906-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph von Recklinghausen <crecklin@redhat.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore     |    1 
 tools/testing/selftests/vm/Makefile       |    4 
 tools/testing/selftests/vm/anon_cow.c     |  401 ++++++++++++++++++++
 tools/testing/selftests/vm/run_vmtests.sh |    3 
 tools/testing/selftests/vm/vm_util.c      |    7 
 tools/testing/selftests/vm/vm_util.h      |    1 
 6 files changed, 416 insertions(+), 1 deletion(-)

--- /dev/null
+++ a/tools/testing/selftests/vm/anon_cow.c
@@ -0,0 +1,401 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * COW (Copy On Write) tests for anonymous memory.
+ *
+ * Copyright 2022, Red Hat, Inc.
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
+#include <dirent.h>
+#include <assert.h>
+#include <sys/mman.h>
+#include <sys/wait.h>
+
+#include "../kselftest.h"
+#include "vm_util.h"
+
+static size_t pagesize;
+static int pagemap_fd;
+
+struct comm_pipes {
+	int child_ready[2];
+	int parent_ready[2];
+};
+
+static int setup_comm_pipes(struct comm_pipes *comm_pipes)
+{
+	if (pipe(comm_pipes->child_ready) < 0)
+		return -errno;
+	if (pipe(comm_pipes->parent_ready) < 0) {
+		close(comm_pipes->child_ready[0]);
+		close(comm_pipes->child_ready[1]);
+		return -errno;
+	}
+
+	return 0;
+}
+
+static void close_comm_pipes(struct comm_pipes *comm_pipes)
+{
+	close(comm_pipes->child_ready[0]);
+	close(comm_pipes->child_ready[1]);
+	close(comm_pipes->parent_ready[0]);
+	close(comm_pipes->parent_ready[1]);
+}
+
+static int child_memcmp_fn(char *mem, size_t size,
+			   struct comm_pipes *comm_pipes)
+{
+	char *old = malloc(size);
+	char buf;
+
+	/* Backup the original content. */
+	memcpy(old, mem, size);
+
+	/* Wait until the parent modified the page. */
+	write(comm_pipes->child_ready[1], "0", 1);
+	while (read(comm_pipes->parent_ready[0], &buf, 1) != 1)
+		;
+
+	/* See if we still read the old values. */
+	return memcmp(old, mem, size);
+}
+
+static int child_vmsplice_memcmp_fn(char *mem, size_t size,
+				    struct comm_pipes *comm_pipes)
+{
+	struct iovec iov = {
+		.iov_base = mem,
+		.iov_len = size,
+	};
+	size_t cur, total, transferred;
+	char *old, *new;
+	int fds[2];
+	char buf;
+
+	old = malloc(size);
+	new = malloc(size);
+
+	/* Backup the original content. */
+	memcpy(old, mem, size);
+
+	if (pipe(fds) < 0)
+		return -errno;
+
+	/* Trigger a read-only pin. */
+	transferred = vmsplice(fds[1], &iov, 1, 0);
+	if (transferred < 0)
+		return -errno;
+	if (transferred == 0)
+		return -EINVAL;
+
+	/* Unmap it from our page tables. */
+	if (munmap(mem, size) < 0)
+		return -errno;
+
+	/* Wait until the parent modified it. */
+	write(comm_pipes->child_ready[1], "0", 1);
+	while (read(comm_pipes->parent_ready[0], &buf, 1) != 1)
+		;
+
+	/* See if we still read the old values via the pipe. */
+	for (total = 0; total < transferred; total += cur) {
+		cur = read(fds[0], new + total, transferred - total);
+		if (cur < 0)
+			return -errno;
+	}
+
+	return memcmp(old, new, transferred);
+}
+
+typedef int (*child_fn)(char *mem, size_t size, struct comm_pipes *comm_pipes);
+
+static void do_test_cow_in_parent(char *mem, size_t size, child_fn fn)
+{
+	struct comm_pipes comm_pipes;
+	char buf;
+	int ret;
+
+	ret = setup_comm_pipes(&comm_pipes);
+	if (ret) {
+		ksft_test_result_fail("pipe() failed\n");
+		return;
+	}
+
+	ret = fork();
+	if (ret < 0) {
+		ksft_test_result_fail("fork() failed\n");
+		goto close_comm_pipes;
+	} else if (!ret) {
+		exit(fn(mem, size, &comm_pipes));
+	}
+
+	while (read(comm_pipes.child_ready[0], &buf, 1) != 1)
+		;
+	/* Modify the page. */
+	memset(mem, 0xff, size);
+	write(comm_pipes.parent_ready[1], "0", 1);
+
+	wait(&ret);
+	if (WIFEXITED(ret))
+		ret = WEXITSTATUS(ret);
+	else
+		ret = -EINVAL;
+
+	ksft_test_result(!ret, "No leak from parent into child\n");
+close_comm_pipes:
+	close_comm_pipes(&comm_pipes);
+}
+
+static void test_cow_in_parent(char *mem, size_t size)
+{
+	do_test_cow_in_parent(mem, size, child_memcmp_fn);
+}
+
+static void test_vmsplice_in_child(char *mem, size_t size)
+{
+	do_test_cow_in_parent(mem, size, child_vmsplice_memcmp_fn);
+}
+
+static void do_test_vmsplice_in_parent(char *mem, size_t size,
+				       bool before_fork)
+{
+	struct iovec iov = {
+		.iov_base = mem,
+		.iov_len = size,
+	};
+	size_t cur, total, transferred;
+	struct comm_pipes comm_pipes;
+	char *old, *new;
+	int ret, fds[2];
+	char buf;
+
+	old = malloc(size);
+	new = malloc(size);
+
+	memcpy(old, mem, size);
+
+	ret = setup_comm_pipes(&comm_pipes);
+	if (ret) {
+		ksft_test_result_fail("pipe() failed\n");
+		goto free;
+	}
+
+	if (pipe(fds) < 0) {
+		ksft_test_result_fail("pipe() failed\n");
+		goto close_comm_pipes;
+	}
+
+	if (before_fork) {
+		transferred = vmsplice(fds[1], &iov, 1, 0);
+		if (transferred <= 0) {
+			ksft_test_result_fail("vmsplice() failed\n");
+			goto close_pipe;
+		}
+	}
+
+	ret = fork();
+	if (ret < 0) {
+		ksft_test_result_fail("fork() failed\n");
+		goto close_pipe;
+	} else if (!ret) {
+		write(comm_pipes.child_ready[1], "0", 1);
+		while (read(comm_pipes.parent_ready[0], &buf, 1) != 1)
+			;
+		/* Modify page content in the child. */
+		memset(mem, 0xff, size);
+		exit(0);
+	}
+
+	if (!before_fork) {
+		transferred = vmsplice(fds[1], &iov, 1, 0);
+		if (transferred <= 0) {
+			ksft_test_result_fail("vmsplice() failed\n");
+			wait(&ret);
+			goto close_pipe;
+		}
+	}
+
+	while (read(comm_pipes.child_ready[0], &buf, 1) != 1)
+		;
+	if (munmap(mem, size) < 0) {
+		ksft_test_result_fail("munmap() failed\n");
+		goto close_pipe;
+	}
+	write(comm_pipes.parent_ready[1], "0", 1);
+
+	/* Wait until the child is done writing. */
+	wait(&ret);
+	if (!WIFEXITED(ret)) {
+		ksft_test_result_fail("wait() failed\n");
+		goto close_pipe;
+	}
+
+	/* See if we still read the old values. */
+	for (total = 0; total < transferred; total += cur) {
+		cur = read(fds[0], new + total, transferred - total);
+		if (cur < 0) {
+			ksft_test_result_fail("read() failed\n");
+			goto close_pipe;
+		}
+	}
+
+	ksft_test_result(!memcmp(old, new, transferred),
+			 "No leak from child into parent\n");
+close_pipe:
+	close(fds[0]);
+	close(fds[1]);
+close_comm_pipes:
+	close_comm_pipes(&comm_pipes);
+free:
+	free(old);
+	free(new);
+}
+
+static void test_vmsplice_before_fork(char *mem, size_t size)
+{
+	do_test_vmsplice_in_parent(mem, size, true);
+}
+
+static void test_vmsplice_after_fork(char *mem, size_t size)
+{
+	do_test_vmsplice_in_parent(mem, size, false);
+}
+
+typedef void (*test_fn)(char *mem, size_t size);
+
+static void do_run_with_base_page(test_fn fn, bool swapout)
+{
+	char *mem;
+	int ret;
+
+	mem = mmap(NULL, pagesize, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mem == MAP_FAILED) {
+		ksft_test_result_fail("mmap() failed\n");
+		return;
+	}
+
+	ret = madvise(mem, pagesize, MADV_NOHUGEPAGE);
+	/* Ignore if not around on a kernel. */
+	if (ret && errno != EINVAL) {
+		ksft_test_result_fail("MADV_NOHUGEPAGE failed\n");
+		goto munmap;
+	}
+
+	/* Populate a base page. */
+	memset(mem, 0, pagesize);
+
+	if (swapout) {
+		madvise(mem, pagesize, MADV_PAGEOUT);
+		if (!pagemap_is_swapped(pagemap_fd, mem)) {
+			ksft_test_result_skip("MADV_PAGEOUT did not work, is swap enabled?\n");
+			goto munmap;
+		}
+	}
+
+	fn(mem, pagesize);
+munmap:
+	munmap(mem, pagesize);
+}
+
+static void run_with_base_page(test_fn fn, const char *desc)
+{
+	ksft_print_msg("[RUN] %s ... with base page\n", desc);
+	do_run_with_base_page(fn, false);
+}
+
+static void run_with_base_page_swap(test_fn fn, const char *desc)
+{
+	ksft_print_msg("[RUN] %s ... with swapped out base page\n", desc);
+	do_run_with_base_page(fn, true);
+}
+
+struct test_case {
+	const char *desc;
+	test_fn fn;
+};
+
+static const struct test_case test_cases[] = {
+	/*
+	 * Basic COW tests for fork() without any GUP. If we miss to break COW,
+	 * either the child can observe modifications by the parent or the
+	 * other way around.
+	 */
+	{
+		"Basic COW after fork()",
+		test_cow_in_parent,
+	},
+	/*
+	 * vmsplice() [R/O GUP] + unmap in the child; modify in the parent. If
+	 * we miss to break COW, the child observes modifications by the parent.
+	 * This is CVE-2020-29374 reported by Jann Horn.
+	 */
+	{
+		"vmsplice() + unmap in child",
+		test_vmsplice_in_child
+	},
+	/*
+	 * vmsplice() [R/O GUP] in parent before fork(), unmap in parent after
+	 * fork(); modify in the child. If we miss to break COW, the parent
+	 * observes modifications by the child.
+	 */
+	{
+		"vmsplice() before fork(), unmap in parent after fork()",
+		test_vmsplice_before_fork,
+	},
+	/*
+	 * vmsplice() [R/O GUP] + unmap in parent after fork(); modify in the
+	 * child. If we miss to break COW, the parent observes modifications by
+	 * the child.
+	 */
+	{
+		"vmsplice() + unmap in parent after fork()",
+		test_vmsplice_after_fork,
+	},
+};
+
+static void run_test_case(struct test_case const *test_case)
+{
+	run_with_base_page(test_case->fn, test_case->desc);
+	run_with_base_page_swap(test_case->fn, test_case->desc);
+}
+
+static void run_test_cases(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
+		run_test_case(&test_cases[i]);
+}
+
+int main(int argc, char **argv)
+{
+	int nr_test_cases = ARRAY_SIZE(test_cases);
+	int err;
+
+	pagesize = getpagesize();
+
+	ksft_print_header();
+	ksft_set_plan(nr_test_cases * 2);
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_msg("opening pagemap failed\n");
+
+	run_test_cases();
+
+	err = ksft_get_fail_cnt();
+	if (err)
+		ksft_exit_fail_msg("%d out of %d tests failed\n",
+				   err, ksft_test_num());
+	return ksft_exit_pass();
+}
--- a/tools/testing/selftests/vm/.gitignore~selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory
+++ a/tools/testing/selftests/vm/.gitignore
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
+anon_cow
 hugepage-mmap
 hugepage-mremap
 hugepage-shm
--- a/tools/testing/selftests/vm/Makefile~selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory
+++ a/tools/testing/selftests/vm/Makefile
@@ -25,7 +25,8 @@ MAKEFLAGS += --no-builtin-rules
 
 CFLAGS = -Wall -I $(top_srcdir) -I $(top_srcdir)/usr/include $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
 LDLIBS = -lrt -lpthread
-TEST_GEN_FILES = compaction_test
+TEST_GEN_FILES = anon_cow
+TEST_GEN_FILES += compaction_test
 TEST_GEN_FILES += gup_test
 TEST_GEN_FILES += hmm-tests
 TEST_GEN_FILES += hugetlb-madvise
@@ -95,6 +96,7 @@ TEST_FILES += va_128TBswitch.sh
 
 include ../lib.mk
 
+$(OUTPUT)/anon_cow: vm_util.c
 $(OUTPUT)/khugepaged: vm_util.c
 $(OUTPUT)/madv_populate: vm_util.c
 $(OUTPUT)/soft-dirty: vm_util.c
--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -185,4 +185,7 @@ fi
 
 run_test ./soft-dirty
 
+# COW tests for anonymous memory
+run_test ./anon_cow
+
 exit $exitcode
--- a/tools/testing/selftests/vm/vm_util.c~selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory
+++ a/tools/testing/selftests/vm/vm_util.c
@@ -28,6 +28,13 @@ bool pagemap_is_softdirty(int fd, char *
 	return entry & 0x0080000000000000ull;
 }
 
+bool pagemap_is_swapped(int fd, char *start)
+{
+	uint64_t entry = pagemap_get_entry(fd, start);
+
+	return entry & 0x4000000000000000ull;
+}
+
 void clear_softdirty(void)
 {
 	int ret;
--- a/tools/testing/selftests/vm/vm_util.h~selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory
+++ a/tools/testing/selftests/vm/vm_util.h
@@ -4,6 +4,7 @@
 
 uint64_t pagemap_get_entry(int fd, char *start);
 bool pagemap_is_softdirty(int fd, char *start);
+bool pagemap_is_swapped(int fd, char *start);
 void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
 uint64_t read_pmd_pagesize(void);
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory.patch
selftests-vm-factor-out-pagemap_is_populated-into-vm_util.patch
selftests-vm-anon_cow-thp-tests.patch
selftests-vm-anon_cow-hugetlb-tests.patch
selftests-vm-anon_cow-add-liburing-test-cases.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch
selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch

