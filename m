Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D19FC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 22:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 025CD6143C
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 22:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbhEMWMt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 18:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhEMWMt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 18:12:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A23561370;
        Thu, 13 May 2021 22:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620943898;
        bh=t+MUDfnDd3qFor/ZqZ6Sgh9yV/lukzys7AMyFld/sSg=;
        h=Date:From:To:Subject:From;
        b=cpH/lEO/woQN/ZTjzIvk0k9Z/Phov/G1qBbwZx4AH8+LynPX9sqgbgzd11Db6rvDY
         21PwxAMBoBoqX8sf9lbwnQQP6sfLownvREYadEi5ek21EmfCL9YXKogl+jw3uJSYyM
         KgkKTUH4VmtHWTpWcx6/qSulCaoGIg9NXV22EyOg=
Date:   Thu, 13 May 2021 15:11:36 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, bp@alien8.de, catalin.marinas@arm.com, cl@linux.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, elena.reshetova@intel.com, guro@fb.com,
        hagen@jauu.net, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, kirill@shutemov.name,
        lkp@intel.com, luto@kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, mm-commits@vger.kernel.org,
        mtk.manpages@gmail.com, palmer@dabbelt.com,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        peterz@infradead.org, rick.p.edgecombe@intel.com,
        rppt@linux.ibm.com, shakeelb@google.com, shuah@kernel.org,
        tglx@linutronix.de, tycho@tycho.ws, viro@zeniv.linux.org.uk,
        will@kernel.org, willy@infradead.org
Subject:  +
 secretmem-test-add-basic-selftest-for-memfd_secret2.patch added to -mm tree
Message-ID: <20210513221136.JLYYFDe6I%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
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

Link: https://lkml.kernel.org/r/20210513184734.29317-9-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: James Bottomley <James.Bottomley@HansenPartnership.com>
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
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: Will Deacon <will@kernel.org>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore     |    1 
 tools/testing/selftests/vm/Makefile       |    3 
 tools/testing/selftests/vm/memfd_secret.c |  296 ++++++++++++++++++++
 tools/testing/selftests/vm/run_vmtests.sh |   17 +
 4 files changed, 316 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/.gitignore~secretmem-test-add-basic-selftest-for-memfd_secret2
+++ a/tools/testing/selftests/vm/.gitignore
@@ -24,5 +24,6 @@ va_128TBswitch
 map_fixed_noreplace
 write_to_hugetlbfs
 hmm-tests
+memfd_secret
 local_config.*
 split_huge_page_test
--- a/tools/testing/selftests/vm/Makefile~secretmem-test-add-basic-selftest-for-memfd_secret2
+++ a/tools/testing/selftests/vm/Makefile
@@ -35,6 +35,7 @@ TEST_GEN_FILES += madv_populate
 TEST_GEN_FILES += map_fixed_noreplace
 TEST_GEN_FILES += map_hugetlb
 TEST_GEN_FILES += map_populate
+TEST_GEN_FILES += memfd_secret
 TEST_GEN_FILES += mlock-random-test
 TEST_GEN_FILES += mlock2-tests
 TEST_GEN_FILES += mremap_dontunmap
@@ -135,7 +136,7 @@ warn_32bit_failure:
 endif
 endif
 
-$(OUTPUT)/mlock-random-test: LDLIBS += -lcap
+$(OUTPUT)/mlock-random-test $(OUTPUT)/memfd_secret: LDLIBS += -lcap
 
 $(OUTPUT)/gup_test: ../../../../mm/gup_test.h
 
--- /dev/null
+++ a/tools/testing/selftests/vm/memfd_secret.c
@@ -0,0 +1,296 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright IBM Corporation, 2020
+ *
+ * Author: Mike Rapoport <rppt@linux.ibm.com>
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
+#define PATTERN	0x55
+
+static const int prot = PROT_READ | PROT_WRITE;
+static const int mode = MAP_SHARED;
+
+static unsigned long page_size;
+static unsigned long mlock_limit_cur;
+static unsigned long mlock_limit_max;
+
+static int memfd_secret(unsigned int flags)
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
+	if (ptrace(PTRACE_PEEKDATA, ppid, mem, 0))
+		exit(KSFT_PASS);
+
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
+		pass("%s is blocked as expected\n", name);
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
--- a/tools/testing/selftests/vm/run_vmtests.sh~secretmem-test-add-basic-selftest-for-memfd_secret2
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -362,4 +362,21 @@ else
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

mm-mmzoneh-simplify-is_highmem_idx.patch
docs-procrst-meminfo-briefly-describe-gaps-in-memory-accounting.patch
include-linux-mmzoneh-add-documentation-for-pfn_valid.patch
memblock-update-initialization-of-reserved-pages.patch
arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid.patch
arm64-drop-pfn_valid_within-and-simplify-pfn_valid.patch
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

