Return-Path: <SRS0=MO2u=DC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2798DC4363D
	for <mm-commits@archiver.kernel.org>; Fri, 25 Sep 2020 02:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D83762137B
	for <mm-commits@archiver.kernel.org>; Fri, 25 Sep 2020 02:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601001368;
	bh=BRPHZ7ZO0cPhDK3X4obWOQfZiGkpOwpPzLx2lA+9tHY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=SVH6PyYo9ehj9WDHvRxLDpFcuvV6fYsqqOd2Jl8Ic57D135bh5f3oZmlDL3m+0Y0n
	 8+U/NGlFGSz6oMk/v5G95xYsdvcxlgd4tnv3SlQiiY/nE9AwzV18iWlVNdMCJug7oH
	 lPS1qEugtQyHGaiQ4VsBkkMPhYvPfF+uULaylBGU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgIYCgI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Sep 2020 22:36:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbgIYCgI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Sep 2020 22:36:08 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0C4420888;
        Fri, 25 Sep 2020 02:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601001367;
        bh=BRPHZ7ZO0cPhDK3X4obWOQfZiGkpOwpPzLx2lA+9tHY=;
        h=Date:From:To:Subject:From;
        b=Ogzkzhx8OPgCVTYsc01wjqkrkUIqSfV9pqSDgDKZSPlIyV2EwazlF106gxca0uEsL
         8sf90Ppvbb/NftSXautMJoLmoUPae5WM78QcBR7AXcIwKkjDfa1JXbj1EY48+yWTWk
         5CWHnzQY4aNpGvEf4NyrQ/rLMCjjGMixznbCznaw=
Date:   Thu, 24 Sep 2020 19:36:05 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        viro@zeniv.linux.org.uk, tycho@tycho.ws, tglx@linutronix.de,
        shuah@kernel.org, peterz@infradead.org, paul.walmsley@sifive.com,
        palmerdabbelt@google.com, palmer@dabbelt.com,
        mtk.manpages@gmail.com, mingo@redhat.com, mark.rutland@arm.com,
        luto@kernel.org, kirill@shutemov.name, jejb@linux.ibm.com,
        idan.yaniv@ibm.com, hpa@zytor.com, elena.reshetova@intel.com,
        david@redhat.com, dave.hansen@linux.intel.com,
        dan.j.williams@intel.com, cl@linux.com, catalin.marinas@arm.com,
        bp@alien8.de, arnd@arndb.de, rppt@linux.ibm.com
Subject:  + secretmem-test-add-basic-selftest-for-memfd_secret2.patch
 added to -mm tree
Message-ID: <20200925023605.8gyWL%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: secretmem: test: add basic selftest for memfd_secret(2)
has been added to the -mm tree.  Its filename is
     secretmem-test-add-basic-selftest-for-memfd_secret2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/secretmem-test-add-basic-selftest-for-memfd_secret2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/secretmem-test-add-basic-selftest-for-memfd_secret2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: secretmem: test: add basic selftest for memfd_secret(2)

The test verifies that file descriptor created with memfd_secret does not
allow read/write operations, that secret memory mappings respect
RLIMIT_MEMLOCK and that remote accesses with process_vm_read() and
ptrace() to the secret memory fail.

Link: https://lkml.kernel.org/r/20200924132904.1391-7-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Idan Yaniv <idan.yaniv@ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore     |    1 
 tools/testing/selftests/vm/Makefile       |    3 
 tools/testing/selftests/vm/memfd_secret.c |  301 ++++++++++++++++++++
 tools/testing/selftests/vm/run_vmtests    |   17 +
 4 files changed, 321 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/.gitignore~secretmem-test-add-basic-selftest-for-memfd_secret2
+++ a/tools/testing/selftests/vm/.gitignore
@@ -20,3 +20,4 @@ va_128TBswitch
 map_fixed_noreplace
 write_to_hugetlbfs
 hmm-tests
+memfd_secret
--- a/tools/testing/selftests/vm/Makefile~secretmem-test-add-basic-selftest-for-memfd_secret2
+++ a/tools/testing/selftests/vm/Makefile
@@ -38,6 +38,7 @@ TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += userfaultfd
 TEST_GEN_FILES += khugepaged
+TEST_GEN_FILES += memfd_secret
 
 ifeq ($(ARCH),x86_64)
 CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_32bit_program.c -m32)
@@ -129,4 +130,4 @@ endif
 
 $(OUTPUT)/userfaultfd: LDLIBS += -lpthread
 
-$(OUTPUT)/mlock-random-test: LDLIBS += -lcap
+$(OUTPUT)/mlock-random-test $(OUTPUT)/memfd_secret: LDLIBS += -lcap
--- /dev/null
+++ a/tools/testing/selftests/vm/memfd_secret.c
@@ -0,0 +1,301 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2020, Mike Rapoport, IBM Corporation.
+ */
+
+#define _GNU_SOURCE
+#include <sys/uio.h>
+#include <sys/mman.h>
+#include <sys/wait.h>
+#include <sys/types.h>
+#include <sys/ptrace.h>
+#include <sys/syscall.h>
+#include <sys/resource.h>
+#include <sys/capability.h>
+
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <stdio.h>
+
+#include "../kselftest.h"
+
+#define fail(fmt, ...) ksft_test_result_fail(fmt, ##__VA_ARGS__)
+#define pass(fmt, ...) ksft_test_result_pass(fmt, ##__VA_ARGS__)
+#define skip(fmt, ...) ksft_test_result_skip(fmt, ##__VA_ARGS__)
+
+#ifdef __NR_memfd_secret
+
+#include <linux/secretmem.h>
+
+#define PATTERN	0x55
+
+static const int prot = PROT_READ | PROT_WRITE;
+static const int mode = MAP_SHARED;
+
+static unsigned long page_size;
+static unsigned long mlock_limit_cur;
+static unsigned long mlock_limit_max;
+
+static int memfd_secret(unsigned long flags)
+{
+	return syscall(__NR_memfd_secret, flags);
+}
+
+static void test_file_apis(int fd)
+{
+	char buf[64];
+
+	if ((read(fd, buf, sizeof(buf)) >= 0) ||
+	    (write(fd, buf, sizeof(buf)) >= 0) ||
+	    (pread(fd, buf, sizeof(buf), 0) >= 0) ||
+	    (pwrite(fd, buf, sizeof(buf), 0) >= 0))
+		fail("unexpected file IO\n");
+	else
+		pass("file IO is blocked as expected\n");
+}
+
+static void test_mlock_limit(int fd)
+{
+	size_t len;
+	char *mem;
+
+	len = mlock_limit_cur;
+	mem = mmap(NULL, len, prot, mode, fd, 0);
+	if (mem == MAP_FAILED) {
+		fail("unable to mmap secret memory\n");
+		return;
+	}
+	munmap(mem, len);
+
+	len = mlock_limit_max * 2;
+	mem = mmap(NULL, len, prot, mode, fd, 0);
+	if (mem != MAP_FAILED) {
+		fail("unexpected mlock limit violation\n");
+		munmap(mem, len);
+		return;
+	}
+
+	pass("mlock limit is respected\n");
+}
+
+static void try_process_vm_read(int fd, int pipefd[2])
+{
+	struct iovec liov, riov;
+	char buf[64];
+	char *mem;
+
+	if (read(pipefd[0], &mem, sizeof(mem)) < 0) {
+		fail("pipe write: %s\n", strerror(errno));
+		exit(KSFT_FAIL);
+	}
+
+	liov.iov_len = riov.iov_len = sizeof(buf);
+	liov.iov_base = buf;
+	riov.iov_base = mem;
+
+	if (process_vm_readv(getppid(), &liov, 1, &riov, 1, 0) < 0) {
+		if (errno == ENOSYS)
+			exit(KSFT_SKIP);
+		exit(KSFT_PASS);
+	}
+
+	exit(KSFT_FAIL);
+}
+
+static void try_ptrace(int fd, int pipefd[2])
+{
+	pid_t ppid = getppid();
+	int status;
+	char *mem;
+	long ret;
+
+	if (read(pipefd[0], &mem, sizeof(mem)) < 0) {
+		perror("pipe write");
+		exit(KSFT_FAIL);
+	}
+
+	ret = ptrace(PTRACE_ATTACH, ppid, 0, 0);
+	if (ret) {
+		perror("ptrace_attach");
+		exit(KSFT_FAIL);
+	}
+
+	ret = waitpid(ppid, &status, WUNTRACED);
+	if ((ret != ppid) || !(WIFSTOPPED(status))) {
+		fprintf(stderr, "weird waitppid result %ld stat %x\n",
+			ret, status);
+		exit(KSFT_FAIL);
+	}
+
+	/* this access should fail and the task should be killed */
+	ret = ptrace(PTRACE_PEEKDATA, ppid, mem, 0);
+	if (ret < 0) {
+		perror("ptrace_peek");
+		exit(KSFT_FAIL);
+	}
+
+	/* we shouldn't survive PTRACE_PEEKDATA */
+	exit(KSFT_FAIL);
+}
+
+static void check_child_status(pid_t pid, const char *name)
+{
+	int status;
+
+	waitpid(pid, &status, 0);
+
+	if (WIFEXITED(status) && WEXITSTATUS(status) == KSFT_SKIP) {
+		skip("%s is not supported\n", name);
+		return;
+	}
+
+	if ((WIFEXITED(status) && WEXITSTATUS(status) == KSFT_PASS) ||
+	    WIFSIGNALED(status)) {
+		pass("%s failed as expected\n", name);
+		return;
+	}
+
+	fail("%s: unexpected memory access\n", name);
+}
+
+static void test_remote_access(int fd, const char *name,
+			       void (*func)(int fd, int pipefd[2]))
+{
+	int pipefd[2];
+	pid_t pid;
+	char *mem;
+
+	if (pipe(pipefd)) {
+		fail("pipe failed: %s\n", strerror(errno));
+		return;
+	}
+
+	pid = fork();
+	if (pid < 0) {
+		fail("fork failed: %s\n", strerror(errno));
+		return;
+	}
+
+	if (pid == 0) {
+		func(fd, pipefd);
+		return;
+	}
+
+	mem = mmap(NULL, page_size, prot, mode, fd, 0);
+	if (mem == MAP_FAILED) {
+		fail("Unable to mmap secret memory\n");
+		return;
+	}
+
+	ftruncate(fd, page_size);
+	memset(mem, PATTERN, page_size);
+
+	if (write(pipefd[1], &mem, sizeof(mem)) < 0) {
+		fail("pipe write: %s\n", strerror(errno));
+		return;
+	}
+
+	check_child_status(pid, name);
+}
+
+static void test_process_vm_read(int fd)
+{
+	test_remote_access(fd, "process_vm_read", try_process_vm_read);
+}
+
+static void test_ptrace(int fd)
+{
+	test_remote_access(fd, "ptrace", try_ptrace);
+}
+
+static int set_cap_limits(rlim_t max)
+{
+	struct rlimit new;
+	cap_t cap = cap_init();
+
+	new.rlim_cur = max;
+	new.rlim_max = max;
+	if (setrlimit(RLIMIT_MEMLOCK, &new)) {
+		perror("setrlimit() returns error");
+		return -1;
+	}
+
+	/* drop capabilities including CAP_IPC_LOCK */
+	if (cap_set_proc(cap)) {
+		perror("cap_set_proc() returns error");
+		return -2;
+	}
+
+	return 0;
+}
+
+static void prepare(void)
+{
+	struct rlimit rlim;
+
+	page_size = sysconf(_SC_PAGE_SIZE);
+	if (!page_size)
+		ksft_exit_fail_msg("Failed to get page size %s\n",
+				   strerror(errno));
+
+	if (getrlimit(RLIMIT_MEMLOCK, &rlim))
+		ksft_exit_fail_msg("Unable to detect mlock limit: %s\n",
+				   strerror(errno));
+
+	mlock_limit_cur = rlim.rlim_cur;
+	mlock_limit_max = rlim.rlim_max;
+
+	printf("page_size: %ld, mlock.soft: %ld, mlock.hard: %ld\n",
+	       page_size, mlock_limit_cur, mlock_limit_max);
+
+	if (page_size > mlock_limit_cur)
+		mlock_limit_cur = page_size;
+	if (page_size > mlock_limit_max)
+		mlock_limit_max = page_size;
+
+	if (set_cap_limits(mlock_limit_max))
+		ksft_exit_fail_msg("Unable to set mlock limit: %s\n",
+				   strerror(errno));
+}
+
+#define NUM_TESTS 4
+
+int main(int argc, char *argv[])
+{
+	int fd;
+
+	prepare();
+
+	ksft_print_header();
+	ksft_set_plan(NUM_TESTS);
+
+	fd = memfd_secret(0);
+	if (fd < 0) {
+		if (errno == ENOSYS)
+			ksft_exit_skip("memfd_secret is not supported\n");
+		else
+			ksft_exit_fail_msg("memfd_secret failed: %s\n",
+					   strerror(errno));
+	}
+
+	test_mlock_limit(fd);
+	test_file_apis(fd);
+	test_process_vm_read(fd);
+	test_ptrace(fd);
+
+	close(fd);
+
+	ksft_exit(!ksft_get_fail_cnt());
+}
+
+#else /* __NR_memfd_secret */
+
+int main(int argc, char *argv[])
+{
+	printf("skip: skipping memfd_secret test (missing __NR_memfd_secret)\n");
+	return KSFT_SKIP;
+}
+
+#endif /* __NR_memfd_secret */
--- a/tools/testing/selftests/vm/run_vmtests~secretmem-test-add-basic-selftest-for-memfd_secret2
+++ a/tools/testing/selftests/vm/run_vmtests
@@ -323,4 +323,21 @@ else
 	exitcode=1
 fi
 
+echo "running memfd_secret test"
+echo "------------------------------------"
+./memfd_secret
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
+exit $exitcode
+
 exit $exitcode
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-account-pmd-tables-like-pte-tables-fix.patch
kvm-ppc-book3s-hv-simplify-kvm_cma_reserve.patch
dma-contiguous-simplify-cma_early_percent_memory.patch
arm-xtensa-simplify-initialization-of-high-memory-pages.patch
arm64-numa-simplify-dummy_numa_init.patch
h8300-nds32-openrisc-simplify-detection-of-memory-extents.patch
riscv-drop-unneeded-node-initialization.patch
mircoblaze-drop-unneeded-numa-and-sparsemem-initializations.patch
memblock-make-for_each_memblock_type-iterator-private.patch
memblock-make-memblock_debug-and-related-functionality-private.patch
memblock-reduce-number-of-parameters-in-for_each_mem_range.patch
arch-mm-replace-for_each_memblock-with-for_each_mem_pfn_range.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix-2.patch
x86-setup-simplify-initrd-relocation-and-reservation.patch
x86-setup-simplify-reserve_crashkernel.patch
memblock-remove-unused-memblock_mem_size.patch
memblock-implement-for_each_reserved_mem_region-using-__next_mem_region.patch
memblock-use-separate-iterators-for-memory-and-reserved-regions.patch
mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
mm-secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

